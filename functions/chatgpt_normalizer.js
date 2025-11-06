// chatgpt_normalizer.js
const functions = require("firebase-functions");
const OpenAI = require("openai");
const dotenv = require("dotenv");
const { sleep, withRetry } = require("./helpers.js");

dotenv.config();

const apiKey = process.env.OPENAI_API_KEY || (functions.config().openai && functions.config().openai.key);
if (!apiKey) {
  console.error("❌ OpenAI API key not found. Set it via .env or Firebase config.");
}

const openai = new OpenAI({ apiKey });

exports.normalizeAllRegions = async function (allRegionData) {
  const promises = allRegionData.map((data) => withRetry(() => normalizeSingleRegion(data)));
  const settled = await Promise.allSettled(promises);
  return settled.filter((r) => r.status === "fulfilled").map((r) => r.value);
};

async function normalizeSingleRegion(regionData) {
  const region = regionData.region;

  const basePrompt = `
You are a culinary data assistant for GlobalFlavors.
Convert the following raw recipe API data into this JSON schema:

{
  "region": "string",
  "recipes": [
    {
      "img": "string",
      "title": "string",
      "desc": "string",
      "descLong": "string",
      "prep": "string",
      "difficulty": "string",
      "prepSteps": ["string", "string", "string"],
      "ingredientNames": ["string", "string"],
      "ingredientQuantities": ["string", "string"],
      "region": "string",
      "category": "string",
      "timestamp": "timestamp",
      "sourceURL": "string"
    }
  ]
}

Rules:
1. Include "region" in every recipe.
2. Arrays "prepSteps", "ingredientNames", and "ingredientQuantities" must exist.
3. Infer 3–5 logical steps if missing.
4. Estimate ingredient quantities if missing.
5. Output only valid JSON.
6. No commentary.

Region: "${region}"
Raw API data:
${JSON.stringify(regionData).slice(0, 5000)}
`;

  try {
    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: basePrompt }],
      temperature: 0.3,
      response_format: { type: "json_object" },
    });

    const content = completion.choices?.[0]?.message?.content;
    if (!content) throw new Error("Empty model response");

    const parsed = JSON.parse(content);
    parsed.region = parsed.region || region;

    parsed.recipes = (parsed.recipes || []).map((recipe) => ({
      img: recipe.img || "",
      title: recipe.title || "Untitled Recipe",
      desc: recipe.desc || "",
      descLong: recipe.descLong || recipe.desc || "",
      prep: recipe.prep || "",
      difficulty: recipe.difficulty || "Medium",
      prepSteps: Array.isArray(recipe.prepSteps) && recipe.prepSteps.length > 0
        ? recipe.prepSteps
        : ["Step 1: Prepare ingredients", "Step 2: Cook dish", "Step 3: Serve hot"],
      ingredientNames: Array.isArray(recipe.ingredientNames) && recipe.ingredientNames.length > 0
        ? recipe.ingredientNames
        : ["Ingredient A", "Ingredient B"],
      ingredientQuantities: Array.isArray(recipe.ingredientQuantities) && recipe.ingredientQuantities.length > 0
        ? recipe.ingredientQuantities
        : ["1 cup", "2 tbsp"],
      region: recipe.region || region,
      category: recipe.category || "General",
      timestamp: recipe.timestamp || new Date().toISOString(),
      sourceURL: recipe.sourceURL || "",
    }));

    await sleep(250);
    return parsed;
  } catch (err) {
    console.error(`❌ Error normalizing region ${region}:`, err);
    return { region, recipes: [] };
  }
}
