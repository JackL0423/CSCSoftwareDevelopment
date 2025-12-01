import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'generation_prompt_widget.dart' show GenerationPromptWidget;
import 'package:flutter/material.dart';

class GenerationPromptModel extends FlutterFlowModel<GenerationPromptWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for promptField widget.
  FocusNode? promptFieldFocusNode;
  TextEditingController? promptFieldTextController;
  String? Function(BuildContext, String?)? promptFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (GenAI image)] action in confirm widget.
  ApiCallResponse? genImageResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    promptFieldFocusNode?.dispose();
    promptFieldTextController?.dispose();
  }
}
