import '/flutter_flow/flutter_flow_util.dart';
import '/recipe_view_folder/ingridient_item/ingridient_item_widget.dart';
import 'recipe_view_ingridients_widget.dart' show RecipeViewIngridientsWidget;
import 'package:flutter/material.dart';

class RecipeViewIngridientsModel
    extends FlutterFlowModel<RecipeViewIngridientsWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for ingridientItem component.
  late IngridientItemModel ingridientItemModel;

  @override
  void initState(BuildContext context) {
    ingridientItemModel = createModel(context, () => IngridientItemModel());
  }

  @override
  void dispose() {
    ingridientItemModel.dispose();
  }
}
