https://docs.google.com/presentation/d/1v-aC7fV9JYPXmm0UWb9eIlruzgUbsn-iV_jjc4utHhI/edit?slide=id.gc8216bd24_20_0#slide=id.gc8216bd24_20_0

Metric 1: How many users complete their first recipe / any given recipe <br>
We can track this by tracking the first time the user scrolls all the way to the bottom of a recipe's page. We could also create a dedicated "Recipe complete" button for users to press when finishing a recipe.

Metric 2: Recipe Search Engagement
We will log a custom Firebase Analytics event `recipe_search` every time a user performs a search in the app. This measures how actively users explore new recipes and cuisines. Implement via FlutterFlow’s “Log Firebase Event” action.

**Metric 3: Ingredient Substitution Help**<br><br>
We will track if a user sees the pop-up and if they tap the “Helpful” button using Firebase Analytics events. We will also compare recipe completion rates to see if the pop-up helps users finish recipes when an ingredient substitution is needed.

**Metric 4: User Search Efficiency**
We will record how many recipes/searches it takes for a user to add a recipe to their cart. It will measure how effective our search is. Lower searches means more effient search algo, more searches means tweaking needs to be done to our prompt. 
