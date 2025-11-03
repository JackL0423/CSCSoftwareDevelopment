import '/flutter_flow/flutter_flow_util.dart';
import 'add_new_tag_diet_widget.dart' show AddNewTagDietWidget;
import 'package:flutter/material.dart';

class AddNewTagDietModel extends FlutterFlowModel<AddNewTagDietWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for newTagField widget.
  FocusNode? newTagFieldFocusNode;
  TextEditingController? newTagFieldTextController;
  String? Function(BuildContext, String?)? newTagFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    newTagFieldFocusNode?.dispose();
    newTagFieldTextController?.dispose();
  }
}
