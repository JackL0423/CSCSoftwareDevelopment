import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/recipe_view_folder/recipe_info_card_difficulty/recipe_info_card_difficulty_widget.dart';
import '/pages/recipe_view_folder/recipe_info_card_prep/recipe_info_card_prep_widget.dart';
import '/pages/recipe_view_folder/recipe_view_cooking_steps/recipe_view_cooking_steps_widget.dart';
import '/pages/recipe_view_folder/recipe_view_ingridients/recipe_view_ingridients_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_view_page_model.dart';
export 'recipe_view_page_model.dart';

class RecipeViewPageWidget extends StatefulWidget {
  const RecipeViewPageWidget({
    super.key,
    String? difficulty,
    String? recipeTitle,
    required this.region,
  })  : this.difficulty = difficulty ?? 'NaN',
        this.recipeTitle = recipeTitle ?? 'NaN';

  final String difficulty;
  final String recipeTitle;
  final String? region;

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
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('RECIPE_VIEW_RecipeViewPage_ON_INIT_STATE');
      logFirebaseEvent('RecipeViewPage_firestore_query');
      _model.recipeQuery = await queryRecipesRecordOnce(
        queryBuilder: (recipesRecord) => recipesRecord.where(
          'title',
          isEqualTo: widget.recipeTitle,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if ((_model.recipeQuery?.title == widget.recipeTitle) &&
          (widget.difficulty == _model.recipeQuery?.difficulty)) {
        logFirebaseEvent('RecipeViewPage_update_page_state');
        _model.recipeViewTitle = _model.recipeQuery!.title;
        _model.recipeViewDescription = _model.recipeQuery!.desc;
        _model.recipeViewPrepTime = _model.recipeQuery!.prep;
        _model.recipeViewDifficulty = _model.recipeQuery!.difficulty;
        _model.recipePreparationStepsArray =
            _model.recipeQuery!.prepSteps.toList().cast<String>();
        _model.recipeViewIngredientArray =
            _model.recipeQuery!.ingredientNames.toList().cast<String>();
        _model.recipeViewQuantitityArray =
            _model.recipeQuery!.ingredientQuantities.toList().cast<String>();
        safeSetState(() {});
      } else {
        logFirebaseEvent('RecipeViewPage_navigate_back');
        context.safePop();
        logFirebaseEvent('RecipeViewPage_show_snack_bar');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error. Failed to find page.',
              style: TextStyle(
                color: Color(0xFFA31414),
              ),
            ),
            duration: Duration(milliseconds: 3000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipesRecord>>(
      future: queryRecipesRecordOnce(
        queryBuilder: (recipesRecord) => recipesRecord
            .where(
              'title',
              isEqualTo: widget.recipeTitle,
            )
            .where(
              'difficulty',
              isEqualTo: widget.difficulty,
            ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<RecipesRecord> recipeViewPageRecipesRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final recipeViewPageRecipesRecord =
            recipeViewPageRecipesRecordList.isNotEmpty
                ? recipeViewPageRecipesRecordList.first
                : null;

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
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).primary,
                          icon: Icon(
                            Icons.arrow_back,
                            color: FlutterFlowTheme.of(context).info,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            logFirebaseEvent(
                                'RECIPE_VIEW_arrow_back_ICN_ON_TAP');
                            logFirebaseEvent('IconButton_navigate_back');
                            context.safePop();
                          },
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/Logotipo_de_GlobalFlavors-Picsart-BackgroundRemover.png',
                          width: 318.7,
                          height: 200.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                  expandedTitleScale: 1.0,
                  titlePadding:
                      EdgeInsetsDirectional.fromSTEB(1.0, 5.0, 0.0, 7.0),
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
                            recipeViewPageRecipesRecord!.img,
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            _model.recipeViewTitle,
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
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
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                _model.recipeViewDescription,
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
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: wrapWithModel(
                            model: _model.recipeInfoCardPrepModel,
                            updateCallback: () => safeSetState(() {}),
                            child: RecipeInfoCardPrepWidget(
                              recipePrepTime: _model.recipeViewPrepTime,
                            ),
                          ),
                        ),
                        Expanded(
                          child: wrapWithModel(
                            model: _model.recipeInfoCardDifficultyModel,
                            updateCallback: () => safeSetState(() {}),
                            child: RecipeInfoCardDifficultyWidget(
                              recipeDifficulty: _model.recipeViewDifficulty,
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                    Builder(
                      builder: (context) {
                        final prepList =
                            _model.recipePreparationStepsArray.toList();

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: prepList.length,
                          itemBuilder: (context, prepListIndex) {
                            final prepListItem = prepList[prepListIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 10.0, 0.0, 0.0),
                              child: RecipeViewCookingStepsWidget(
                                key: Key(
                                    'Keyceg_${prepListIndex}_of_${prepList.length}'),
                                recipeStepNum: valueOrDefault<int>(
                                  prepListIndex,
                                  0,
                                ),
                                recipeStepDescription: valueOrDefault<String>(
                                  prepListItem,
                                  'Empty',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Text(
                        'Ingridients',
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
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: wrapWithModel(
                        model: _model.recipeViewIngridientsModel,
                        updateCallback: () => safeSetState(() {}),
                        child: RecipeViewIngridientsWidget(
                          recipeIngridientList:
                              _model.recipeViewIngredientArray,
                          recipeIngridientQuantityList:
                              _model.recipeViewQuantitityArray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
