import '/auth/firebase_auth/auth_util.dart';
import '/components/recipe_nav_preview_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'golden_path_model.dart';
export 'golden_path_model.dart';

class GoldenPathWidget extends StatefulWidget {
  const GoldenPathWidget({super.key});

  static String routeName = 'GoldenPath';
  static String routePath = '/goldenPath';

  @override
  State<GoldenPathWidget> createState() => _GoldenPathWidgetState();
}

class _GoldenPathWidgetState extends State<GoldenPathWidget> {
  late GoldenPathModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GoldenPathModel());

    _model.textController ??= TextEditingController();
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
        backgroundColor: Color(0xFFF1F4F8),
        drawer: Drawer(
          elevation: 16.0,
          child: Container(
            width: 280.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFD81B60),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.restaurant_menu_rounded,
                          color: Colors.white,
                          size: 32.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            'GlobalFlavors',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ]
                          .divide(SizedBox(width: 12.0))
                          .around(SizedBox(width: 12.0)),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(ProfileWidget.routeName);
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFFD81B60),
                                    size: 24.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Profile',
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
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Manage your account',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(HomePageWidget.routeName);
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.dashboard_rounded,
                                    color: Color(0xFFD81B60),
                                    size: 24.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Home',
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
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'About us',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(GoldenPathWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E3E9),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFFD81B60),
                                    size: 24.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Search Recipes',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFFD81B60),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Find your next meal',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFFD81B60),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Color(0xFFD81B60),
                                  size: 24.0,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Grocery List',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Plan your shopping',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ].divide(SizedBox(width: 16.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 0.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            GoRouter.of(context).prepareAuthEvent();
                            await authManager.signOut();
                            GoRouter.of(context).clearRedirectLocation();

                            context.goNamedAuth(
                                LoginWidget.routeName, context.mounted);
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: FlutterFlowTheme.of(context).error,
                                    size: 24.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Log out',
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Sign out of your account',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primary),
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 58.0,
                        height: 58.0,
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
                        'GlobalFlavors',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  fontSize: 34.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                      ),
                    ].divide(SizedBox(width: 8.0)).around(SizedBox(width: 8.0)),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 20.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.menu_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              expandedTitleScale: 1.0,
              titlePadding: EdgeInsetsDirectional.fromSTEB(1.0, 5.0, 0.0, 10.0),
            ),
            toolbarHeight: 40.0,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Search for recipes...',
                      hintStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: Color(0xFF14181B),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFDBE2E7),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCE035F),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Color(0xFF57636C),
                        size: 24.0,
                      ),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF14181B),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    validator:
                        _model.textControllerValidator.asValidator(context),
                  ),
                ),
              ),
              FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController ??=
                    FormFieldController<String>(null),
                options: [
                  'Italy',
                  'France',
                  'Japan',
                  'Mexico',
                  'India',
                  'Thailand',
                  'Spain',
                  'China'
                ],
                onChanged: (val) =>
                    safeSetState(() => _model.dropDownValue = val),
                height: 50.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: Color(0xFF14181B),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Select Country',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF14181B),
                  size: 24.0,
                ),
                fillColor: Colors.white,
                elevation: 2.0,
                borderColor: Color(0xFFDBE2E7),
                borderWidth: 1.0,
                borderRadius: 12.0,
                margin: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                hidesUnderline: true,
                isSearchable: false,
                isMultiSelect: false,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Dishes',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                            ),
                            color: Color(0xFF14181B),
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                    ),
                    GridView(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        wrapWithModel(
                          model: _model.recipeNavPreviewModel,
                          updateCallback: () => safeSetState(() {}),
                          child: RecipeNavPreviewWidget(),
                        ),
                        Container(
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'data:image/jpeg;base64,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',
                                          width: double.infinity,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.94, -0.99),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Container(
                                            width: 69.6,
                                            height: 35.4,
                                            decoration: BoxDecoration(
                                              color: Color(0xCC000000),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star_rounded,
                                                    color: Color(0xFFFFD700),
                                                    size: 16.0,
                                                  ),
                                                  Text(
                                                    '4.9',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .spaceGrotesk(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Fresh Salmon Sushi Roll',
                                            maxLines: 2,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font:
                                                      GoogleFonts.spaceGrotesk(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF14181B),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            'Traditional Japanese sushi',
                                            maxLines: 2,
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font:
                                                      GoogleFonts.spaceGrotesk(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF57636C),
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    '45 min',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .spaceGrotesk(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFF14181B),
                                                          fontSize: 11.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                                    color: Color(0xFFE65454),
                                                    size: 16.0,
                                                  ),
                                                  Text(
                                                    'Hard',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .spaceGrotesk(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFF14181B),
                                                          fontSize: 11.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(width: 8.0)),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              print('Button pressed ...');
                                            },
                                            text: 'View Recipe',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 32.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFCE035F),
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                              elevation: 0.0,
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 6.0)),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'https://www.thecookierookie.com/wp-content/uploads/2024/05/street-tacos-recipe-2.jpg',
                                          width: double.infinity,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.8, -0.8),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Container(
                                            width: 60.0,
                                            height: 38.53,
                                            decoration: BoxDecoration(
                                              color: Color(0xCC000000),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star_rounded,
                                                    color: Color(0xFFFFD700),
                                                    size: 16.0,
                                                  ),
                                                  Text(
                                                    '4.7',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .spaceGrotesk(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Authentic Street Tacos',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF14181B),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Mexican street-style tacos',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF57636C),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  '20 min',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF14181B),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                  color: Color(0xFF39D2C0),
                                                  size: 16.0,
                                                ),
                                                Text(
                                                  'Easy',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF14181B),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: 'View Recipe',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 32.0,
                                            padding: EdgeInsets.all(8.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFCE035F),
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodySmall
                                                .override(
                                                  font:
                                                      GoogleFonts.spaceGrotesk(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 6.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'https://images.immediate.co.uk/production/volatile/sites/30/2021/02/butter-chicken-ac2ff98.jpg?quality=90&resize=440,400',
                                          width: double.infinity,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.8, -0.8),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Container(
                                            width: 76.54,
                                            height: 35.5,
                                            decoration: BoxDecoration(
                                              color: Color(0xCC000000),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star_rounded,
                                                    color: Color(0xFFFFD700),
                                                    size: 16.0,
                                                  ),
                                                  Text(
                                                    '4.6',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .spaceGrotesk(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Butter Chicken Curry',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF14181B),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Rich and creamy Indian curry',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF57636C),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  '40 min',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF14181B),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                  'Medium',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF14181B),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: 'View Recipe',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 32.0,
                                            padding: EdgeInsets.all(8.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFCE035F),
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodySmall
                                                .override(
                                                  font:
                                                      GoogleFonts.spaceGrotesk(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 6.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'data:image/jpeg;base64,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',
                                          width: double.infinity,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.8, -0.8),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Container(
                                            width: 64.9,
                                            height: 43.1,
                                            decoration: BoxDecoration(
                                              color: Color(0xCC000000),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star_rounded,
                                                    color: Color(0xFFFFD700),
                                                    size: 16.0,
                                                  ),
                                                  Text(
                                                    '4.5',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .spaceGrotesk(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'French Butter Croissants',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF14181B),
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Flaky, buttery pastries',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF57636C),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  '3 hours',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF14181B),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                  color: Color(0xFFE65454),
                                                  size: 16.0,
                                                ),
                                                Text(
                                                  'Hard',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF14181B),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FFButtonWidget(
                                              onPressed: () {
                                                print('Button pressed ...');
                                              },
                                              text: 'View Recipe',
                                              options: FFButtonOptions(
                                                padding: EdgeInsets.all(8.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle: GoogleFonts.roboto(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  fontSize: 0.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ].divide(SizedBox(height: 6.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
            ].divide(SizedBox(height: 12.0)),
          ),
        ),
      ),
    );
  }
}
