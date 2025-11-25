import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signupv1_model.dart';
export 'signupv1_model.dart';

class Signupv1Widget extends StatefulWidget {
  const Signupv1Widget({super.key});

  static String routeName = 'SIGNUPV1';
  static String routePath = '/signupv1';

  @override
  State<Signupv1Widget> createState() => _Signupv1WidgetState();
}

class _Signupv1WidgetState extends State<Signupv1Widget> {
  late Signupv1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Signupv1Model());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SIGNUPV1'});
    _model.signUpemailTextController ??= TextEditingController();
    _model.signUpemailFocusNode ??= FocusNode();

    _model.signUpConfirmemailTextController ??= TextEditingController();
    _model.signUpConfirmemailFocusNode ??= FocusNode();

    _model.signUpPasswordTextController ??= TextEditingController();
    _model.signUpPasswordFocusNode ??= FocusNode();

    _model.signUpConfirmPasswordTextController ??= TextEditingController();
    _model.signUpConfirmPasswordFocusNode ??= FocusNode();

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
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/Logotipo_de_GlobalFlavors-Picsart-BackgroundRemover.png',
                      width: 290.8,
                      height: 86.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .displaySmall
                                .fontStyle,
                          ),
                          color: Colors.black,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .displaySmall
                              .fontStyle,
                        ),
                  ),
                  Text(
                    'Join Global Favors and start connecting with your community',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          color: Color(0xFF49454F),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          key: ValueKey('SignUpemail_kaqw'),
                          controller: _model.signUpemailTextController,
                          focusNode: _model.signUpemailFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.signUpemailTextController',
                            Duration(milliseconds: 2000),
                            () => safeSetState(() {}),
                          ),
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
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
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: Color(0xFF79747E),
                              size: 24.0,
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
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
                          validator: _model.signUpemailTextControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          key: ValueKey('SignUpConfirmemail_uqdt'),
                          controller: _model.signUpConfirmemailTextController,
                          focusNode: _model.signUpConfirmemailFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.signUpConfirmemailTextController',
                            Duration(milliseconds: 2000),
                            () => safeSetState(() {}),
                          ),
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Confirm email...',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
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
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: Color(0xFF79747E),
                              size: 24.0,
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
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
                              .signUpConfirmemailTextControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          key: ValueKey('SignUpPassword_h7ic'),
                          controller: _model.signUpPasswordTextController,
                          focusNode: _model.signUpPasswordFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.signUpPasswordTextController',
                            Duration(milliseconds: 2000),
                            () => safeSetState(() {}),
                          ),
                          textInputAction: TextInputAction.next,
                          obscureText: !_model.signUpPasswordVisibility,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
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
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF79747E),
                              size: 24.0,
                            ),
                            suffixIcon: InkWell(
                              onTap: () => safeSetState(
                                () => _model.signUpPasswordVisibility =
                                    !_model.signUpPasswordVisibility,
                              ),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.signUpPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 22,
                              ),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
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
                          cursorColor: Color(0xFFD81B60),
                          enableInteractiveSelection: true,
                          validator: _model
                              .signUpPasswordTextControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          key: ValueKey('SignUpConfirmPassword_mrlq'),
                          controller:
                              _model.signUpConfirmPasswordTextController,
                          focusNode: _model.signUpConfirmPasswordFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.signUpConfirmPasswordTextController',
                            Duration(milliseconds: 2000),
                            () => safeSetState(() {}),
                          ),
                          textInputAction: TextInputAction.done,
                          obscureText: !_model.signUpConfirmPasswordVisibility,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password...',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
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
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF79747E),
                              size: 24.0,
                            ),
                            suffixIcon: InkWell(
                              onTap: () => safeSetState(
                                () => _model.signUpConfirmPasswordVisibility =
                                    !_model.signUpConfirmPasswordVisibility,
                              ),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.signUpConfirmPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 22,
                              ),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
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
                          cursorColor: Color(0xFFD81B60),
                          enableInteractiveSelection: true,
                          validator: _model
                              .signUpConfirmPasswordTextControllerValidator
                              .asValidator(context),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ),
                  FFButtonWidget(
                    key: ValueKey('Button_e9qg'),
                    onPressed: () async {
                      logFirebaseEvent(
                          'SIGNUPV1_PAGE_CREATE_ACCOUNT_BTN_ON_TAP');
                      logFirebaseEvent('Button_validate_form');
                      if (_model.formKey.currentState == null ||
                          !_model.formKey.currentState!.validate()) {
                        return;
                      }
                      if (_model.signUpemailTextController.text ==
                          _model.signUpConfirmemailTextController.text) {
                        if (_model.signUpPasswordTextController.text ==
                            _model.signUpConfirmPasswordTextController.text) {
                          logFirebaseEvent('Button_auth');
                          GoRouter.of(context).prepareAuthEvent();
                          if (_model.signUpPasswordTextController.text !=
                              _model.signUpConfirmPasswordTextController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Passwords don\'t match!',
                                ),
                              ),
                            );
                            return;
                          }

                          final user = await authManager.createAccountWithEmail(
                            context,
                            _model.signUpemailTextController.text,
                            _model.signUpPasswordTextController.text,
                          );
                          if (user == null) {
                            return;
                          }

                          await UsersRecord.collection
                              .doc(user.uid)
                              .update(createUsersRecordData(
                                email: _model.signUpemailTextController.text,
                              ));

                          logFirebaseEvent('Button_auth');
                          if (_model.signUpemailTextController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Email required!',
                                ),
                              ),
                            );
                            return;
                          }

                          await authManager.updateEmail(
                            email: _model.signUpemailTextController.text,
                            context: context,
                          );
                          safeSetState(() {});

                          logFirebaseEvent('Button_update_app_state');
                          FFAppState().emailField = currentUserEmail;
                          safeSetState(() {});
                          logFirebaseEvent('Button_navigate_to');

                          context.pushNamedAuth(
                              ProfileSetup1Widget.routeName, context.mounted);
                        } else {
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Errror: Passwords dont match',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                            ),
                          );
                        }
                      } else {
                        logFirebaseEvent('Button_show_snack_bar');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error: emails dont match',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    },
                    text: 'Create Account',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: EdgeInsets.all(8.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFFD81B60),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                      ),
                      Text(
                        'OR',
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
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 16.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            logFirebaseEvent('SIGNUPV1_PAGE_GOOGLE_BTN_ON_TAP');
                            logFirebaseEvent('Button_auth');
                            GoRouter.of(context).prepareAuthEvent();
                            final user =
                                await authManager.signInWithGoogle(context);
                            if (user == null) {
                              return;
                            }
                            logFirebaseEvent('Button_navigate_to');

                            context.pushNamedAuth(
                                ProfileSetup1Widget.routeName, context.mounted);
                          },
                          text: 'Google',
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            size: 18.0,
                          ),
                          options: FFButtonOptions(
                            height: 48.0,
                            padding: EdgeInsets.all(8.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconColor: FlutterFlowTheme.of(context).primaryText,
                            color: Color(0xFFFFFBFF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF1C1B1F),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Color(0xFFE7E0EC),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                              'SIGNUPV1_PAGE_Text_ia98ged6_ON_TAP');
                          logFirebaseEvent('Text_navigate_to');

                          context.pushNamed(LoginWidget.routeName);
                        },
                        child: Text(
                          'Login',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
