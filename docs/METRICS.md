https://docs.google.com/presentation/d/1v-aC7fV9JYPXmm0UWb9eIlruzgUbsn-iV_jjc4utHhI/edit?slide=id.gc8216bd24_20_0#slide=id.gc8216bd24_20_0

**Happiness Metric: Net Promoter Score (NPS)**<br><br>

We will track user responses to the in-app NPS survey using Firebase Analytics events. Each submission logs a score from 0–10 under the nps_score event. We will use these values to calculate the average NPS and measure how satisfied and inspired users feel when cooking authentic regional meals. This metric aligns with the Happiness category of our HEART framework, focused on user delight and confidence.

Metric 1: How many users complete their first recipe / any given recipe <br>
We can track this by tracking the first time the user scrolls all the way to the bottom of a recipe's page. We could also create a dedicated "Recipe complete" button for users to press when finishing a recipe.

Metric 2: Recipe Search Engagement <br>
We will log a custom Firebase Analytics event `recipe_search` every time a user performs a search in the app. This measures how actively users explore new recipes and cuisines. Implement via FlutterFlow’s “Log Firebase Event” action.

**Metric 3: Ingredient Substitution Help**<br><br>
We will track if a user sees the pop-up and if they tap the “Helpful” button using Firebase Analytics events. We will also compare recipe completion rates to see if the pop-up helps users finish recipes when an ingredient substitution is needed.

**Metric 4: User Search Efficiency**
We will record how many recipes/searches it takes for a user to add a recipe to their cart. It will measure how effective our search is. Lower searches means more effient search algo, more searches means tweaking needs to be done to our prompt. 
