import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'recipe_view_component_model.dart';
export 'recipe_view_component_model.dart';

class RecipeViewComponentWidget extends StatefulWidget {
  const RecipeViewComponentWidget({super.key});

  @override
  State<RecipeViewComponentWidget> createState() =>
      _RecipeViewComponentWidgetState();
}

class _RecipeViewComponentWidgetState extends State<RecipeViewComponentWidget> {
  late RecipeViewComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipeViewComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
