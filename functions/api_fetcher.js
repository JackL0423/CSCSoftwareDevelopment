// api_fetcher.js
const fetch = require("node-fetch");
const functions = require("firebase-functions");
const { sleep, withRetry } = require("./helpers.js");

exports.fetchAllRegions = async function (regions) {
  const tasks = regions.map((r) => fetchRegionData(r));
  const results = await Promise.allSettled(tasks);
  return results.filter((r) => r.status === "fulfilled").map((r) => r.value);
};

async function fetchRegionData(region) {
  const SPOON_KEY = functions.config().spoonacular.key;
  const mealdbURL = `https://www.themealdb.com/api/json/v1/1/filter.php?a=${region}`;
  const spoonURL = `https://api.spoonacular.com/recipes/complexSearch?cuisine=${region}&number=5&apiKey=${SPOON_KEY}`;

  const [mealdb, spoonacular] = await Promise.all([
    withRetry(() => fetch(mealdbURL).then((r) => r.json())),
    withRetry(() => fetch(spoonURL).then((r) => r.json())),
  ]);

  await sleep(300);
  return { region, mealdb, spoonacular };
}
