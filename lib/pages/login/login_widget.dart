import '/auth/firebase_auth/auth_util.dart';
import '/components/reset_password_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_model.dart';
export 'login_model.dart';

/// ```
/// Build GlobalFlavors login page with Material 3.
///
/// Colors: Primary #D81B60, Surface #FFFBFF, use 28px card radius, 12px input
/// radius. CENTER LAYOUT: Max-width 448px. HEADER: Pink chef icon (64px, 20px
/// radius), "Welcome Back" h1, "Log in to continue your culinary adventure"
/// subtitle. CARD: 28px rounded card with shadow. FORM: Email field with mail
/// icon left, placeholder "you@example.com", 56px height, 12px radius, light
/// bg #F1E3E9. Password field with lock icon, placeholder dots, same styling.
/// "Remember me" checkbox left, "Forgot password?" link right (pink). "Log
/// In" button full-width, 56px height, pink #D81B60, white text,
/// rounded-full, shadow. DIVIDER: "Or continue with" text. SOCIAL: 2-column
/// grid - Google button (with colorful G logo SVG), Apple button (black apple
/// icon), both outlined, rounded-full, 48px height. FOOTER TEXT: "Don't have
/// account? Sign up free" (pink link). BACK LINK: Arrow + "Back to home" at
/// bottom. Enable form validation, loading states.
/// ```
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'login'});
    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 448.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 64.0,
                              height: 64.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFD81B60),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: Color(0xFFFFFBFF),
                                  size: 36.0,
                                ),
                              ),
                            ),
                            Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF1C1B1F),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .fontStyle,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Text(
                                'Log in to continue your culinary adventure',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF49454F),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF49454F),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'LOGIN_PAGE_Text_cmtfzudv_ON_TAP');
                                logFirebaseEvent('Text_navigate_to');

                                context.pushNamed(Signupv1Widget.routeName);
                              },
                              child: Text(
                                'Sign up free',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFFD81B60),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _model.textFieldEmailTextController,
                                focusNode: _model.textFieldEmailFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textFieldEmailTextController',
                                  Duration(milliseconds: 2000),
                                  () => safeSetState(() {}),
                                ),
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'you@example.com',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF79747E),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
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
                                      color: Color(0xFFBA1A1A),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFBA1A1A),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF1E3E9),
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 16.0, 16.0, 16.0),
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: Color(0xFF79747E),
                                    size: 24.0,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1C1B1F),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Color(0xFFD81B60),
                                validator: _model
                                    .textFieldEmailTextControllerValidator
                                    .asValidator(context),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextFormField(
                                    controller: _model.passwordTextController,
                                    focusNode: _model.textFieldFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.passwordTextController',
                                      Duration(milliseconds: 2000),
                                      () => safeSetState(() {}),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    obscureText: !_model.passwordVisibility,
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF79747E),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE7E0EC),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD81B60),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFBA1A1A),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFBA1A1A),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF1E3E9),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 16.0, 16.0, 16.0),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Color(0xFF79747E),
                                        size: 24.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () => safeSetState(
                                          () => _model.passwordVisibility =
                                              !_model.passwordVisibility,
                                        ),
                                        focusNode:
                                            FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF1C1B1F),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                    cursorColor: Color(0xFFD81B60),
                                    validator: _model
                                        .passwordTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'LOGIN_PAGE_Text_17njhhkm_ON_TAP');
                                          logFirebaseEvent('Text_bottom_sheet');
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: ResetPasswordWidget(),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Text(
                                          'Forgot password?',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFFD81B60),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ].addToEnd(SizedBox(width: 2.0)),
                                  ),
                                ].divide(SizedBox(height: 2.0)),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'LOGIN_PAGE_LOG_IN_BTN_ON_TAP');
                                  logFirebaseEvent('Button_validate_form');
                                  if (_model.formKey.currentState == null ||
                                      !_model.formKey.currentState!
                                          .validate()) {
                                    return;
                                  }
                                  logFirebaseEvent('Button_auth');
                                  GoRouter.of(context).prepareAuthEvent();

                                  final user =
                                      await authManager.signInWithEmail(
                                    context,
                                    _model.textFieldEmailTextController.text,
                                    _model.passwordTextController.text,
                                  );
                                  if (user == null) {
                                    return;
                                  }

                                  if (loggedIn) {
                                    logFirebaseEvent('Button_navigate_to');

                                    context.pushNamedAuth(
                                        HomePageWidget.routeName,
                                        context.mounted);
                                  } else {
                                    logFirebaseEvent('Button_show_snack_bar');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Wrong email or password',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    );
                                  }
                                },
                                text: 'Log In',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 56.0,
                                  padding: EdgeInsets.all(8.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFFD81B60),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFFFFFBFF),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                  elevation: 2.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(28.0),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE7E0EC),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: Text(
                                      'Or continue with',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF79747E),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE7E0EC),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'LOGIN_PAGE_GOOGLE_BTN_ON_TAP');
                                        logFirebaseEvent('Button_auth');
                                        GoRouter.of(context).prepareAuthEvent();
                                        final user = await authManager
                                            .signInWithGoogle(context);
                                        if (user == null) {
                                          return;
                                        }

                                        context.goNamedAuth(
                                            HomePageWidget.routeName,
                                            context.mounted);
                                      },
                                      text: 'Google',
                                      icon: Icon(
                                        Icons.g_translate,
                                        size: 20.0,
                                      ),
                                      options: FFButtonOptions(
                                        height: 48.0,
                                        padding: EdgeInsets.all(8.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        iconColor: Color(0xFF4285F4),
                                        color: Color(0xFFFFFBFF),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF1C1B1F),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: Color(0xFFE7E0EC),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                  ),
                                  isAndroid
                                      ? Container()
                                      : Expanded(
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'LOGIN_PAGE_APPLE_BTN_ON_TAP');
                                              logFirebaseEvent('Button_auth');
                                              GoRouter.of(context)
                                                  .prepareAuthEvent();
                                              final user = await authManager
                                                  .signInWithApple(context);
                                              if (user == null) {
                                                return;
                                              }

                                              context.goNamedAuth(
                                                  HomePageWidget.routeName,
                                                  context.mounted);
                                            },
                                            text: 'Apple',
                                            icon: Icon(
                                              Icons.apple,
                                              size: 20.0,
                                            ),
                                            options: FFButtonOptions(
                                              height: 48.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              iconColor: Colors.black,
                                              color: Color(0xFFFFFBFF),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF1C1B1F),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                              elevation: 0.0,
                                              borderSide: BorderSide(
                                                color: Color(0xFFE7E0EC),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                          ),
                                        ),
                                ].divide(SizedBox(width: 12.0)),
                              ),
                            ].divide(SizedBox(height: 24.0)),
                          ),
                        ),
                      ].divide(SizedBox(height: 28.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
