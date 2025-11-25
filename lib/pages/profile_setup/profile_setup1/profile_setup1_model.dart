import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_setup1_widget.dart' show ProfileSetup1Widget;
import 'package:flutter/material.dart';

class ProfileSetup1Model extends FlutterFlowModel<ProfileSetup1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for usernameField widget.
  FocusNode? usernameFieldFocusNode;
  TextEditingController? usernameFieldTextController;
  String? Function(BuildContext, String?)? usernameFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    usernameFieldFocusNode?.dispose();
    usernameFieldTextController?.dispose();
  }
}
