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

