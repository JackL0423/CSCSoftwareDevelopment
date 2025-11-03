import '/flutter_flow/flutter_flow_util.dart';
import 'reset_password_widget.dart' show ResetPasswordWidget;
import 'package:flutter/material.dart';

class ResetPasswordModel extends FlutterFlowModel<ResetPasswordWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextFieldEmail widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();
  }
}
