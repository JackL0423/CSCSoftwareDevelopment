import '/flutter_flow/flutter_flow_util.dart';
import 'onboarding_v1_widget.dart' show OnboardingV1Widget;
import 'package:flutter/material.dart';

class OnboardingV1Model extends FlutterFlowModel<OnboardingV1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
