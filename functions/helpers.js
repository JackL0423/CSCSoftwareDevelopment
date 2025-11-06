// helpers.js
exports.sleep = (ms) => new Promise((r) => setTimeout(r, ms));

exports.withRetry = async function (fn, retries = 3, delay = 1000) {
  for (let i = 0; i < retries; i++) {
    try {
      return await fn();
    } catch (err) {
      console.warn(`Retry ${i + 1} failed: ${err.message}`);
      await exports.sleep(delay * (i + 1));
    }
  }
  throw new Error("Max retries reached");
};
