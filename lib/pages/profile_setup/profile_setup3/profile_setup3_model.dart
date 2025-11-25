import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'profile_setup3_widget.dart' show ProfileSetup3Widget;
import 'package:flutter/material.dart';

class ProfileSetup3Model extends FlutterFlowModel<ProfileSetup3Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for dietChips widget.
  FormFieldController<List<String>>? dietChipsValueController;
  String? get dietChipsValue => dietChipsValueController?.value?.firstOrNull;
  set dietChipsValue(String? val) =>
      dietChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
