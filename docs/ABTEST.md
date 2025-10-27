## Adding a Profile Progress Bar  

**User Story 3**

### Metrics  
- Number of tags users add to their profile  
- Number of fields completed in the profile  

### Hypothesis  
A profile progress bar will increase the number of users who complete their profiles.  

### Experiment  
We will start by showing the new progress bar to **10% of users** — both new and existing.  

- **New users:** Track whether they are more likely to complete their profiles when they see the progress bar.  
- **Existing users:** If they open an unfinished profile, track whether they decide to finish it.  
- Over time, gradually increase the percentage of users who see the progress bar.  

**Implementation details:**  
Use **Firebase Remote Config** to:  
- Control whether the user sees the progress bar.  
- Track how many profile fields are completed.  

### Variations  
1. **Simple Addition**  
   - Add a progress bar to the current profile screen.  

2. **Enhanced Setup Flow**  
   - Create a multi-page profile setup, with each page representing a step in the process.  
   - Display the progress bar at the top.  
   - Include a **“Complete Later”** button, which can also be tracked via Firebase Remote Config.  


## A/B Test – Search Button Text (“Search” vs “Find Recipes”)

**A/B Test Name:** Search CTA Text: “Search” vs “Find Recipes”

**User Story Number:** US4 – Golden Path

**Metrics:**
- **Engagement:** `recipe_search` events per DAU
- **Task Success:** Search CTR = `recipe_search` / `search_view`

**Hypothesis:**
A more action-oriented button label (“Find Recipes”) will encourage more users to begin searching for a recipe, increasing app engagement and recipe starts.

**Problem & Impact:**
Some users do not progress into the Golden Path after landing on the home screen. Improving search initiation increases the likelihood they enter recipe pages and complete the Golden Path.

**Experiment (Firebase A/B Testing):**
- **Remote Config parameter:** `search_button_text` -> {`Search`, `Find Recipes`}
- **Audience:** All users 
- **Split:** 50% / 50%
- **Events Tracked (Firebase Analytics):**
  - `search_view` (CTA visible; param: `variant`)
  - `recipe_search` (search executed; param: `variant`)
- **Primary Success Metric:** Increase in recipe search engagement
- **Guardrails:** Retention, DAU stability, crash-free users

**Variations:**
- **Variant A (Control):** `search_button_text = "Search"`
- **Variant B (Test):** `search_button_text = "Find Recipes"`

**Implementation Notes (FlutterFlow + Remote Config):**
- Bind CTA text to RC parameter `search_button_text`
- Log events using “Log Firebase Event” actions on:
  - Page load → `search_view`
  - Tap/submit search → `recipe_search`
- Use DebugView for validation before experiment launch

**A/B Test Name:** Ingredient Substitution Pop-Up Help  
**User Story Number:** US4 – Golden Path

### Metrics
- Number of users tapping “Helpful” on the pop-up (`substitution_helpful`)
- Increase in recipe completion (`recipe_completed`)
- Decrease in recipe confusion or shopping issues (`grocery_sync_error`)

### Hypothesis
If users get a quick explanation for an ingredient substitution, they will feel less confused and will be more likely to finish cooking the recipe.

### Problem & Impact
Some users stop cooking when they can’t find or recognize certain ingredients. This hurts engagement and the main experience of our app which is helping users cook global meals easily. Explaining substitutions improves confidence and keeps users progressing through the recipe.

### Experiment
- Use Firebase Remote Config to show a pop-up message explaining ingredient substitutions:
  - `show_substitution_popup = true` → sees pop-up
  - `show_substitution_popup = false` → no pop-up
- Audience: Users who view recipes with substituted ingredients
- Split: 50% control / 50% variant

**Events Tracked**
- `substitution_popup_view`
- `substitution_helpful`
- `recipe_completed`
- `grocery_sync_error`

**Primary success metric:** More recipe completions  
**Secondary success metric:** More “Helpful” button taps

### Variations
- **Control (A):** Substitution only shown as regular text on recipe page
- **Variant (B):** Pop-up with a short explanation and two buttons:
  - “Helpful”
  - “Skip”

### Implementation Notes
Tracking done using Firebase Analytics events. Pop-up display controlled by Remote Config.
