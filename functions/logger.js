// logger.js
exports.logInfo = function (message) {
  const time = new Date().toISOString();
  console.log(`[${time}] ${message}`);
};
