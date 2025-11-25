import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/recipe_view_folder/recipe_info_card_difficulty/recipe_info_card_difficulty_widget.dart';
import '/pages/recipe_view_folder/recipe_info_card_prep/recipe_info_card_prep_widget.dart';
import '/pages/recipe_view_folder/recipe_view_ingridients/recipe_view_ingridients_widget.dart';
import 'recipe_view_page_widget.dart' show RecipeViewPageWidget;
import 'package:flutter/material.dart';

class RecipeViewPageModel extends FlutterFlowModel<RecipeViewPageWidget> {
  ///  Local state fields for this page.
  /// recipe view page title
  String recipeViewTitle = 'NaN';

  /// Recipe view description variable
  String recipeViewDescription = 'NaN';

  /// recipe view page variable for prep time.
  String recipeViewPrepTime = 'NaN';

  /// recipe view variable for difficulty.
  String recipeViewDifficulty = 'NaN';

  /// Array with recipe view level steps.
  List<String> recipePreparationStepsArray = [];
  void addToRecipePreparationStepsArray(String item) =>
      recipePreparationStepsArray.add(item);
  void removeFromRecipePreparationStepsArray(String item) =>
      recipePreparationStepsArray.remove(item);
  void removeAtIndexFromRecipePreparationStepsArray(int index) =>
      recipePreparationStepsArray.removeAt(index);
  void insertAtIndexInRecipePreparationStepsArray(int index, String item) =>
      recipePreparationStepsArray.insert(index, item);
  void updateRecipePreparationStepsArrayAtIndex(
          int index, Function(String) updateFn) =>
      recipePreparationStepsArray[index] =
          updateFn(recipePreparationStepsArray[index]);

  /// Array for recipe view ingredients.
  List<String> recipeViewIngredientArray = [];
  void addToRecipeViewIngredientArray(String item) =>
      recipeViewIngredientArray.add(item);
  void removeFromRecipeViewIngredientArray(String item) =>
      recipeViewIngredientArray.remove(item);
  void removeAtIndexFromRecipeViewIngredientArray(int index) =>
      recipeViewIngredientArray.removeAt(index);
  void insertAtIndexInRecipeViewIngredientArray(int index, String item) =>
      recipeViewIngredientArray.insert(index, item);
  void updateRecipeViewIngredientArrayAtIndex(
          int index, Function(String) updateFn) =>
      recipeViewIngredientArray[index] =
          updateFn(recipeViewIngredientArray[index]);

  /// Array for recipe view page ingridient quantities.
  List<String> recipeViewQuantitityArray = [];
  void addToRecipeViewQuantitityArray(String item) =>
      recipeViewQuantitityArray.add(item);
  void removeFromRecipeViewQuantitityArray(String item) =>
      recipeViewQuantitityArray.remove(item);
  void removeAtIndexFromRecipeViewQuantitityArray(int index) =>
      recipeViewQuantitityArray.removeAt(index);
  void insertAtIndexInRecipeViewQuantitityArray(int index, String item) =>
      recipeViewQuantitityArray.insert(index, item);
  void updateRecipeViewQuantitityArrayAtIndex(
          int index, Function(String) updateFn) =>
      recipeViewQuantitityArray[index] =
          updateFn(recipeViewQuantitityArray[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in RecipeViewPage widget.
  RecipesRecord? recipeQuery;
  // Model for RecipeInfoCardPrep component.
  late RecipeInfoCardPrepModel recipeInfoCardPrepModel;
  // Model for RecipeInfoCardDifficulty component.
  late RecipeInfoCardDifficultyModel recipeInfoCardDifficultyModel;
  // Model for recipeViewIngridients component.
  late RecipeViewIngridientsModel recipeViewIngridientsModel;

  @override
  void initState(BuildContext context) {
    recipeInfoCardPrepModel =
        createModel(context, () => RecipeInfoCardPrepModel());
    recipeInfoCardDifficultyModel =
        createModel(context, () => RecipeInfoCardDifficultyModel());
    recipeViewIngridientsModel =
        createModel(context, () => RecipeViewIngridientsModel());
  }

  @override
  void dispose() {
    recipeInfoCardPrepModel.dispose();
    recipeInfoCardDifficultyModel.dispose();
    recipeViewIngridientsModel.dispose();
  }
}
