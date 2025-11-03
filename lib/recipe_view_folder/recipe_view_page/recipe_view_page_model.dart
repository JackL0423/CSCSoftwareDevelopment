import '/flutter_flow/flutter_flow_util.dart';
import '/recipe_view_folder/recipe_info_card_difficulty/recipe_info_card_difficulty_widget.dart';
import '/recipe_view_folder/recipe_info_card_prep/recipe_info_card_prep_widget.dart';
import '/recipe_view_folder/recipe_view_cooking_steps/recipe_view_cooking_steps_widget.dart';
import '/recipe_view_folder/recipe_view_ingridients/recipe_view_ingridients_widget.dart';
import '/recipe_view_folder/recipe_view_review/recipe_view_review_widget.dart';
import '/index.dart';
import 'recipe_view_page_widget.dart' show RecipeViewPageWidget;
import 'package:flutter/material.dart';

class RecipeViewPageModel extends FlutterFlowModel<RecipeViewPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for RecipeInfoCardPrep component.
  late RecipeInfoCardPrepModel recipeInfoCardPrepModel;
  // Model for RecipeInfoCardDifficulty component.
  late RecipeInfoCardDifficultyModel recipeInfoCardDifficultyModel;
  // Model for RecipeViewCookingSteps component.
  late RecipeViewCookingStepsModel recipeViewCookingStepsModel1;
  // Model for RecipeViewCookingSteps component.
  late RecipeViewCookingStepsModel recipeViewCookingStepsModel2;
  // Model for RecipeViewCookingSteps component.
  late RecipeViewCookingStepsModel recipeViewCookingStepsModel3;
  // Model for RecipeViewCookingSteps component.
  late RecipeViewCookingStepsModel recipeViewCookingStepsModel4;
  // Model for RecipeViewCookingSteps component.
  late RecipeViewCookingStepsModel recipeViewCookingStepsModel5;
  // Model for RecipeViewCookingSteps component.
  late RecipeViewCookingStepsModel recipeViewCookingStepsModel6;
  // Model for recipeViewIngridients component.
  late RecipeViewIngridientsModel recipeViewIngridientsModel;
  // Model for RecipeViewReview component.
  late RecipeViewReviewModel recipeViewReviewModel;

  @override
  void initState(BuildContext context) {
    recipeInfoCardPrepModel =
        createModel(context, () => RecipeInfoCardPrepModel());
    recipeInfoCardDifficultyModel =
        createModel(context, () => RecipeInfoCardDifficultyModel());
    recipeViewCookingStepsModel1 =
        createModel(context, () => RecipeViewCookingStepsModel());
    recipeViewCookingStepsModel2 =
        createModel(context, () => RecipeViewCookingStepsModel());
    recipeViewCookingStepsModel3 =
        createModel(context, () => RecipeViewCookingStepsModel());
    recipeViewCookingStepsModel4 =
        createModel(context, () => RecipeViewCookingStepsModel());
    recipeViewCookingStepsModel5 =
        createModel(context, () => RecipeViewCookingStepsModel());
    recipeViewCookingStepsModel6 =
        createModel(context, () => RecipeViewCookingStepsModel());
    recipeViewIngridientsModel =
        createModel(context, () => RecipeViewIngridientsModel());
    recipeViewReviewModel = createModel(context, () => RecipeViewReviewModel());
  }

  @override
  void dispose() {
    recipeInfoCardPrepModel.dispose();
    recipeInfoCardDifficultyModel.dispose();
    recipeViewCookingStepsModel1.dispose();
    recipeViewCookingStepsModel2.dispose();
    recipeViewCookingStepsModel3.dispose();
    recipeViewCookingStepsModel4.dispose();
    recipeViewCookingStepsModel5.dispose();
    recipeViewCookingStepsModel6.dispose();
    recipeViewIngridientsModel.dispose();
    recipeViewReviewModel.dispose();
  }
}
