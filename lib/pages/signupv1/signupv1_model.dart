import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'signupv1_widget.dart' show Signupv1Widget;
import 'package:flutter/material.dart';

class Signupv1Model extends FlutterFlowModel<Signupv1Widget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for SignUpemail widget.
  FocusNode? signUpemailFocusNode;
  TextEditingController? signUpemailTextController;
  String? Function(BuildContext, String?)? signUpemailTextControllerValidator;
  // State field(s) for SignUpConfirmemail widget.
  FocusNode? signUpConfirmemailFocusNode;
  TextEditingController? signUpConfirmemailTextController;
  String? Function(BuildContext, String?)?
      signUpConfirmemailTextControllerValidator;
  // State field(s) for SignUpPassword widget.
  FocusNode? signUpPasswordFocusNode;
  TextEditingController? signUpPasswordTextController;
  late bool signUpPasswordVisibility;
  String? Function(BuildContext, String?)?
      signUpPasswordTextControllerValidator;
  // State field(s) for SignUpConfirmPassword widget.
  FocusNode? signUpConfirmPasswordFocusNode;
  TextEditingController? signUpConfirmPasswordTextController;
  late bool signUpConfirmPasswordVisibility;
  String? Function(BuildContext, String?)?
      signUpConfirmPasswordTextControllerValidator;

  @override
  void initState(BuildContext context) {
    signUpPasswordVisibility = false;
    signUpConfirmPasswordVisibility = false;
  }

  @override
  void dispose() {
    signUpemailFocusNode?.dispose();
    signUpemailTextController?.dispose();

    signUpConfirmemailFocusNode?.dispose();
    signUpConfirmemailTextController?.dispose();

    signUpPasswordFocusNode?.dispose();
    signUpPasswordTextController?.dispose();

    signUpConfirmPasswordFocusNode?.dispose();
    signUpConfirmPasswordTextController?.dispose();
  }
}
