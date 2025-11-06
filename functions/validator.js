// validator.js
exports.validateRecipe = function (recipe) {
  const required = [
    "title", "desc", "descLong",
    "prep", "difficulty", "prepSteps",
    "ingredientNames", "ingredientQuantities", "img"
  ];
  return required.filter((f) => !recipe[f] || recipe[f].length === 0);
};
