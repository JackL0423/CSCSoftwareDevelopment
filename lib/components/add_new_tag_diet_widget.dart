import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_new_tag_diet_model.dart';
export 'add_new_tag_diet_model.dart';

class AddNewTagDietWidget extends StatefulWidget {
  const AddNewTagDietWidget({super.key});

  @override
  State<AddNewTagDietWidget> createState() => _AddNewTagDietWidgetState();
}

class _AddNewTagDietWidgetState extends State<AddNewTagDietWidget> {
  late AddNewTagDietModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddNewTagDietModel());

    _model.newTagFieldTextController ??= TextEditingController();
    _model.newTagFieldFocusNode ??= FocusNode();

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
      width: 300.0,
      height: 500.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 40.0;
                    } else if (MediaQuery.sizeOf(context).width <
                        kBreakpointMedium) {
                      return 50.0;
                    } else if (MediaQuery.sizeOf(context).width <
                        kBreakpointLarge) {
                      return 60.0;
                    } else {
                      return 70.0;
                    }
                  }(),
                  fillColor: Color(0xFFD81B60),
                  icon: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).info,
                    size: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 24.0;
                      } else if (MediaQuery.sizeOf(context).width <
                          kBreakpointMedium) {
                        return 30.0;
                      } else if (MediaQuery.sizeOf(context).width <
                          kBreakpointLarge) {
                        return 30.0;
                      } else {
                        return 30.0;
                      }
                    }(),
                  ),
                  onPressed: () async {
                    logFirebaseEvent('ADD_NEW_TAG_DIET_arrow_back_ICN_ON_TAP');
                    logFirebaseEvent('IconButton_bottom_sheet');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Text(
            'New Diet / Allergy',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).displaySmall.fontStyle,
                  ),
                  color: Color(0xFF861043),
                  fontSize: () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 32.0;
                    } else if (MediaQuery.sizeOf(context).width <
                        kBreakpointMedium) {
                      return 40.0;
                    } else if (MediaQuery.sizeOf(context).width <
                        kBreakpointLarge) {
                      return 50.0;
                    } else {
                      return 50.0;
                    }
                  }(),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).displaySmall.fontStyle,
                ),
          ),
          Container(
            width: () {
              if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                return 240.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                return 500.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                return 500.0;
              } else {
                return 600.0;
              }
            }(),
            child: TextFormField(
              controller: _model.newTagFieldTextController,
              focusNode: _model.newTagFieldFocusNode,
              autofocus: false,
              enabled: true,
              obscureText: false,
              decoration: InputDecoration(
                isDense: false,
                labelStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      color: Color(0xFF1C1B1F),
                      fontSize: () {
                        if (MediaQuery.sizeOf(context).width <
                            kBreakpointSmall) {
                          return 16.0;
                        } else if (MediaQuery.sizeOf(context).width <
                            kBreakpointMedium) {
                          return 24.0;
                        } else if (MediaQuery.sizeOf(context).width <
                            kBreakpointLarge) {
                          return 30.0;
                        } else {
                          return 30.0;
                        }
                      }(),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
                hintText: 'New Diet / Allergy Tag',
                hintStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      color: Color(0xFF79747E),
                      fontSize: () {
                        if (MediaQuery.sizeOf(context).width <
                            kBreakpointSmall) {
                          return 16.0;
                        } else if (MediaQuery.sizeOf(context).width <
                            kBreakpointMedium) {
                          return 24.0;
                        } else if (MediaQuery.sizeOf(context).width <
                            kBreakpointLarge) {
                          return 30.0;
                        } else {
                          return 30.0;
                        }
                      }(),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE7E0EC),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD81B60),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondary,
                contentPadding:
                    EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              ),
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
                    color: Color(0xFF1C1B1F),
                    fontSize: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 16.0;
                      } else if (MediaQuery.sizeOf(context).width <
                          kBreakpointMedium) {
                        return 24.0;
                      } else if (MediaQuery.sizeOf(context).width <
                          kBreakpointLarge) {
                        return 30.0;
                      } else {
                        return 30.0;
                      }
                    }(),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
              cursorColor: FlutterFlowTheme.of(context).primaryText,
              enableInteractiveSelection: true,
              validator: _model.newTagFieldTextControllerValidator
                  .asValidator(context),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              logFirebaseEvent('ADD_NEW_TAG_DIET_COMP_confirm_ON_TAP');
              logFirebaseEvent('confirm_update_app_state');
              FFAppState()
                  .addToDietaryTags(_model.newTagFieldTextController.text);
              safeSetState(() {});
              logFirebaseEvent('confirm_google_analytics_event');
              logFirebaseEvent('addDietTag');
              logFirebaseEvent('confirm_bottom_sheet');
              Navigator.pop(context);
            },
            text: 'Add tag',
            options: FFButtonOptions(
              width: () {
                if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                  return 240.0;
                } else if (MediaQuery.sizeOf(context).width <
                    kBreakpointMedium) {
                  return 300.0;
                } else if (MediaQuery.sizeOf(context).width <
                    kBreakpointLarge) {
                  return 300.0;
                } else {
                  return 400.0;
                }
              }(),
              height: () {
                if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                  return 47.0;
                } else if (MediaQuery.sizeOf(context).width <
                    kBreakpointMedium) {
                  return 60.0;
                } else if (MediaQuery.sizeOf(context).width <
                    kBreakpointLarge) {
                  return 60.0;
                } else {
                  return 60.0;
                }
              }(),
              padding: EdgeInsets.all(8.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: Color(0xFFD81B60),
              textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.interTight(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
                    color: Color(0xFFFFFBFF),
                    fontSize: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 16.0;
                      } else if (MediaQuery.sizeOf(context).width <
                          kBreakpointMedium) {
                        return 24.0;
                      } else if (MediaQuery.sizeOf(context).width <
                          kBreakpointLarge) {
                        return 30.0;
                      } else {
                        return 30.0;
                      }
                    }(),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
              elevation: 2.0,
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ].divide(SizedBox(height: 24.0)),
      ),
    );
  }
}
