import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_info_card_prep_model.dart';
export 'recipe_info_card_prep_model.dart';

/// Used in recipe header to display prep time, difficulty, etc.
class RecipeInfoCardPrepWidget extends StatefulWidget {
  const RecipeInfoCardPrepWidget({
    super.key,
    String? recipePrepTime,
  }) : this.recipePrepTime = recipePrepTime ?? '0 Minutes';

  /// Used for both the landing page and the recipe view page.
  final String recipePrepTime;

  @override
  State<RecipeInfoCardPrepWidget> createState() =>
      _RecipeInfoCardPrepWidgetState();
}

class _RecipeInfoCardPrepWidgetState extends State<RecipeInfoCardPrepWidget> {
  late RecipeInfoCardPrepModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipeInfoCardPrepModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          shape: BoxShape.rectangle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Container(
                width: 47.69,
                height: 47.69,
                decoration: BoxDecoration(
                  color: Color(0xFFEDC2D8),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Icon(
                    Icons.timer_sharp,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prep Time',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    widget.recipePrepTime,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
