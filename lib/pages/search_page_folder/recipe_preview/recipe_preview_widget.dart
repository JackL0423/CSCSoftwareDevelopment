import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_preview_model.dart';
export 'recipe_preview_model.dart';

class RecipePreviewWidget extends StatefulWidget {
  const RecipePreviewWidget({
    super.key,
    required this.img,
    required this.title,
    required this.shortDesc,
    required this.difficulty,
    String? prepTime,
    required this.region,
  }) : this.prepTime = prepTime ?? '0';

  final String? img;
  final String? title;
  final String? shortDesc;
  final String? difficulty;
  final String prepTime;
  final String? region;

  @override
  State<RecipePreviewWidget> createState() => _RecipePreviewWidgetState();
}

class _RecipePreviewWidgetState extends State<RecipePreviewWidget> {
  late RecipePreviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipePreviewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x1A000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      imageUrl: widget.img!,
                      width: double.infinity,
                      height: 121.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.8, -0.8),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                      child: Container(
                        width: 74.4,
                        height: 38.6,
                        decoration: BoxDecoration(
                          color: Color(0xCC000000),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFD700),
                                size: 16.0,
                              ),
                              Text(
                                '4.8',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.spaceGrotesk(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.title,
                        'NaN',
                      ),
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF14181B),
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Text(
                      valueOrDefault<String>(
                        widget.shortDesc,
                        'NaN',
                      ),
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: Color(0xFF57636C),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: Color(0xFFCE035F),
                              size: 16.0,
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget.prepTime,
                                'NaN',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF14181B),
                                    fontSize: 11.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              color: Color(0x4DD43EED),
                              size: 16.0,
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget.difficulty,
                                'NaN',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF14181B),
                                    fontSize: 11.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ].divide(SizedBox(width: 8.0)),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent(
                            'RECIPE_PREVIEW_VIEW_RECIPE_BTN_ON_TAP');
                        logFirebaseEvent('Button_navigate_to');

                        context.pushNamed(
                          RecipeViewPageWidget.routeName,
                          queryParameters: {
                            'recipeTitle': serializeParam(
                              widget.title,
                              ParamType.String,
                            ),
                            'difficulty': serializeParam(
                              widget.difficulty,
                              ParamType.String,
                            ),
                            'region': serializeParam(
                              '',
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      },
                      text: 'View Recipe',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 32.0,
                        padding: EdgeInsets.all(8.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFFCE035F),
                        textStyle:
                            FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.spaceGrotesk(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ].divide(SizedBox(height: 6.0)),
                ),
              ),
            ].divide(SizedBox(height: 8.0)),
          ),
        ),
      ),
    );
  }
}
