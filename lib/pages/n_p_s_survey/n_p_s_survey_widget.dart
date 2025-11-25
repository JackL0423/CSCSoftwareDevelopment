import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'n_p_s_survey_model.dart';
export 'n_p_s_survey_model.dart';

class NPSSurveyWidget extends StatefulWidget {
  const NPSSurveyWidget({super.key});

  static String routeName = 'NPSSurvey';
  static String routePath = '/nPSSurvey';

  @override
  State<NPSSurveyWidget> createState() => _NPSSurveyWidgetState();
}

class _NPSSurveyWidgetState extends State<NPSSurveyWidget> {
  late NPSSurveyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NPSSurveyModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'NPSSurvey'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'We are eager to hear your feedback!',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).displaySmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle:
                      FlutterFlowTheme.of(context).displaySmall.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'On a scale of 0–10, how likely are you to recommend this app to a friend who loves cooking authentic regional meals?',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Slider(
                  key: ValueKey(FFAppState().sliderValue.toString()),
                  activeColor: FlutterFlowTheme.of(context).primary,
                  inactiveColor: FlutterFlowTheme.of(context).secondary,
                  min: 0.0,
                  max: 10.0,
                  value: _model.sliderValue ??= 0.0,
                  label: _model.sliderValue?.toStringAsFixed(0),
                  divisions: 10,
                  onChanged: (newValue) {
                    newValue = double.parse(newValue.toStringAsFixed(0));
                    safeSetState(() => _model.sliderValue = newValue);
                  },
                ),
              ),
              Container(
                width: 100.0,
                height: 48.12,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: FFButtonWidget(
                  onPressed: () async {
                    logFirebaseEvent('N_P_S_SURVEY_PAGE_SUBMIT_BTN_ON_TAP');
                    logFirebaseEvent('Button_google_analytics_event');
                    logFirebaseEvent(
                      'NPSEvent',
                      parameters: {
                        'Score': _model.sliderValue,
                      },
                    );
                    logFirebaseEvent('Button_update_app_state');
                    FFAppState().surveyCompleted = true;
                    safeSetState(() {});
                    logFirebaseEvent('Button_navigate_back');
                    context.safePop();
                  },
                  text: 'Submit',
                  options: FFButtonOptions(
                    height: 6.9,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context)
                        .titleMedium
                        .override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
