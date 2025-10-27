https://docs.google.com/presentation/d/1v-aC7fV9JYPXmm0UWb9eIlruzgUbsn-iV_jjc4utHhI/edit?slide=id.gc8216bd24_20_0#slide=id.gc8216bd24_20_0

Metric 1: How many users complete their first recipe / any given recipe <br>
We can track this by tracking the first time the user scrolls all the way to the bottom of a recipe's page. We could also create a dedicated "Recipe complete" button for users to press when finishing a recipe.

Metric 2: Recipe Search Engagement
We will log a custom Firebase Analytics event `recipe_search` every time a user performs a search in the app. This measures how actively users explore new recipes and cuisines. Implement via FlutterFlow’s “Log Firebase Event” action.
