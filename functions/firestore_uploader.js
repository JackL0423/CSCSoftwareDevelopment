// firestore_uploader.js
const { validateRecipe } = require("./validator.js");
const { logInfo } = require("./logger.js");

exports.uploadAllRegions = async function (db, normalizedRegions) {
  const results = [];

  for (const region of normalizedRegions) {
    const regionName = region.region;
    const regionRef = db.collection("regions").doc(regionName);
    const timestamp = new Date().toISOString();

    const snap = await regionRef.get();
    if (snap.exists && Date.now() - new Date(snap.data().timestamp) < 24 * 60 * 60 * 1000) {
      logInfo(`⏭️ Skipping ${regionName} (fresh data)`);
      continue;
    }

    await regionRef.set({ regionName, regionCode: regionName.slice(0, 2).toUpperCase(), timestamp }, { merge: true });

    let batch = db.batch();
    let uploaded = 0, skipped = 0;

    for (const recipe of region.recipes) {
      const recipeId = recipe.title.replace(/\s+/g, "");
      const recipeRef = regionRef.collection("recipes").doc(recipeId);
      const exists = (await recipeRef.get()).exists;
      if (exists) { skipped++; continue; }

      const missing = validateRecipe(recipe);
      if (missing.length > 0) {
        logInfo(`⚠️ Skipping ${recipe.title} (${missing.join(", ")})`);
        continue;
      }

      batch.set(recipeRef, recipe);
      uploaded++;

      if (uploaded % 400 === 0) {
        await batch.commit();
        batch = db.batch(); // reset batch
      }
    }

    await batch.commit();
    results.push({ region: regionName, uploaded, skipped });
    logInfo(`✅ ${regionName}: ${uploaded} new, ${skipped} skipped`);
  }

  return results;
};
