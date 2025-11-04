import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/recipe_view_folder/recipe_info_card_difficulty/recipe_info_card_difficulty_widget.dart';
import '/recipe_view_folder/recipe_info_card_prep/recipe_info_card_prep_widget.dart';
import '/recipe_view_folder/recipe_view_cooking_steps/recipe_view_cooking_steps_widget.dart';
import '/recipe_view_folder/recipe_view_ingridients/recipe_view_ingridients_widget.dart';
import '/recipe_view_folder/recipe_view_review/recipe_view_review_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_view_page_model.dart';
export 'recipe_view_page_model.dart';

class RecipeViewPageWidget extends StatefulWidget {
  const RecipeViewPageWidget({super.key});

  static String routeName = 'RecipeViewPage';
  static String routePath = '/recipeViewPage';

  @override
  State<RecipeViewPageWidget> createState() => _RecipeViewPageWidgetState();
}

class _RecipeViewPageWidgetState extends State<RecipeViewPageWidget> {
  late RecipeViewPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipeViewPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'RecipeViewPage'});
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
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
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      logFirebaseEvent('RECIPE_VIEW_arrow_back_ICN_ON_TAP');
                      logFirebaseEvent('IconButton_navigate_back');
                      context.safePop();
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                  fontSize: 30.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                      ),
                      Container(
                        width: 53.0,
                        height: 53.0,
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
                    ].divide(SizedBox(width: 8.0)).around(SizedBox(width: 8.0)),
                  ),
                ].divide(SizedBox(width: 0.5)).around(SizedBox(width: 0.5)),
              ),
              centerTitle: false,
              expandedTitleScale: 1.0,
              titlePadding: EdgeInsetsDirectional.fromSTEB(1.0, 5.0, 0.0, 7.0),
            ),
            toolbarHeight: 40.0,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://whatsgabycooking.com/wp-content/uploads/2023/02/Le-Creuset-__-Pasta-Carbonara-1.jpg',
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Classic Spaghetti Carbonara',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).tertiary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Creamy Italian pasta ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: wrapWithModel(
                        model: _model.recipeInfoCardPrepModel,
                        updateCallback: () => safeSetState(() {}),
                        child: RecipeInfoCardPrepWidget(
                          recipePrepTime: '25 Minutes',
                        ),
                      ),
                    ),
                    Expanded(
                      child: wrapWithModel(
                        model: _model.recipeInfoCardDifficultyModel,
                        updateCallback: () => safeSetState(() {}),
                        child: RecipeInfoCardDifficultyWidget(
                          recipeDifficulty: 'Medium',
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Preparation Steps',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).tertiary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                      child: wrapWithModel(
                        model: _model.recipeViewCookingStepsModel1,
                        updateCallback: () => safeSetState(() {}),
                        updateOnChange: true,
                        child: RecipeViewCookingStepsWidget(
                          recipeStepNum: 1,
                          recipeStepDescription:
                              'Bring a large pot of salted water to a boil. Cook spaghetti according to package directions until al dente.',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                      child: wrapWithModel(
                        model: _model.recipeViewCookingStepsModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: RecipeViewCookingStepsWidget(
                          recipeStepNum: 2,
                          recipeStepDescription:
                              'While pasta cooks, cut pancetta into small cubes and cook in a large skillet over medium heat until crispy, about 5-7 minutes.',
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                        child: wrapWithModel(
                          model: _model.recipeViewCookingStepsModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: RecipeViewCookingStepsWidget(
                            recipeStepNum: 3,
                            recipeStepDescription:
                                'In a bowl, whisk together eggs, Pecorino Romano cheese, and freshly ground black pepper until well combined.',
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                        child: wrapWithModel(
                          model: _model.recipeViewCookingStepsModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: RecipeViewCookingStepsWidget(
                            recipeStepNum: 4,
                            recipeStepDescription:
                                'Reserve 1 cup of pasta water, then drain the pasta. Add hot pasta to the skillet with pancetta.',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                      child: wrapWithModel(
                        model: _model.recipeViewCookingStepsModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: RecipeViewCookingStepsWidget(
                          recipeStepNum: 5,
                          recipeStepDescription:
                              'Remove skillet from heat and quickly add the egg mixture, tossing constantly. Add pasta water a little at a time until you achieve a creamy consistency.',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                      child: wrapWithModel(
                        model: _model.recipeViewCookingStepsModel6,
                        updateCallback: () => safeSetState(() {}),
                        child: RecipeViewCookingStepsWidget(
                          recipeStepNum: 6,
                          recipeStepDescription:
                              'Serve immediatelly with extra Pecorino Romano and black pepper on top',
                        ),
                      ),
                    ),
                  ],
                ),
                wrapWithModel(
                  model: _model.recipeViewIngridientsModel,
                  updateCallback: () => safeSetState(() {}),
                  child: RecipeViewIngridientsWidget(),
                ),
                Text(
                  'User Reviews',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).tertiary,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
                wrapWithModel(
                  model: _model.recipeViewReviewModel,
                  updateCallback: () => safeSetState(() {}),
                  child: RecipeViewReviewWidget(
                    recipeViewUserName: 'Keanu Reeves',
                    userStarReviewOfRecipe: 1.0,
                    timeSinceReview: 23,
                    userReviewDescription:
                        'The storm rolled in faster than anyone expected, swallowing the horizon in violet clouds.Amid the chaos, Mira clutched the broken compass that still pointed to something she couldn’t see.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
