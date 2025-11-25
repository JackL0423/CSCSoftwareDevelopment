import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_view_cooking_steps_model.dart';
export 'recipe_view_cooking_steps_model.dart';

/// Component for the ingridient list.
class RecipeViewCookingStepsWidget extends StatefulWidget {
  const RecipeViewCookingStepsWidget({
    super.key,
    int? recipeStepNum,
    String? recipeStepDescription,
  })  : this.recipeStepNum = recipeStepNum ?? 0,
        this.recipeStepDescription = recipeStepDescription ?? 'Empty Step';

  /// Used in the recipe view page for the recipe steps
  final int recipeStepNum;

  /// Used in the recipe view page for the recipe step description.
  final String recipeStepDescription;

  @override
  State<RecipeViewCookingStepsWidget> createState() =>
      _RecipeViewCookingStepsWidgetState();
}

class _RecipeViewCookingStepsWidgetState
    extends State<RecipeViewCookingStepsWidget> {
  late RecipeViewCookingStepsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipeViewCookingStepsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).primary
              ],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              widget.recipeStepNum.toString(),
              '0',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondary,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
            child: Text(
              widget.recipeStepDescription,
              textAlign: TextAlign.start,
              maxLines: 3,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }
}
