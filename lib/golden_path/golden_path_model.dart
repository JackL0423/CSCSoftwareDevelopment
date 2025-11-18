import '/components/recipe_nav_preview_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'golden_path_widget.dart' show GoldenPathWidget;
import 'package:flutter/material.dart';

class GoldenPathModel extends FlutterFlowModel<GoldenPathWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Model for recipeNavPreview component.
  late RecipeNavPreviewModel recipeNavPreviewModel;

  @override
  void initState(BuildContext context) {
    recipeNavPreviewModel = createModel(context, () => RecipeNavPreviewModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    recipeNavPreviewModel.dispose();
  }
}
