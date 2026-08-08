# Progress & Analytics Dashboard Requirements

## Introduction

The Progress & Analytics Dashboard is a comprehensive metrics visualization feature for the "Talk With Sadiq" app that enables Ethiopian youth to track their personal growth journey over time. The feature transforms raw habit completion data and focus session metrics into motivational visual insights, helping users understand the direct impact of their daily discipline and sustained effort. Every element is designed to celebrate progress and encourage continued commitment to building lasting habits.

The dashboard integrates seamlessly with the existing habit tracking and focus timer systems, providing a single source of truth for understanding user progress while maintaining Sadiq's supportive, coaching-oriented tone throughout all interactions and insights.

## Glossary

- **User**: An authenticated member of the app, typically an Ethiopian youth aged 13-25
- **Analytics_Dashboard**: The main screen displaying progress metrics, charts, and insights (the product of this feature)
- **Habit**: A repeating daily task tracked by the user (e.g., morning run, meditation)
- **Focus_Session**: A timed focus session (25-minute or 50-minute Pomodoro-style sessions) tracked with XP rewards
- **Metric**: A quantifiable measurement of user progress (e.g., completion percentage, total XP earned)
- **Time_Period**: A defined date range for analytics (weekly, monthly, all-time)
- **Streak**: Consecutive days of habit completion without breaks
- **XP (Experience Points)**: Reward points earned by completing habits and focus sessions
- **Completion_Rate**: The percentage of habit completions achieved versus total habit days in a period
- **Personal_Record**: A user's all-time best achievement in a specific metric
- **Insight**: A motivational or informational statement generated from analytics data
- **Empty_State**: UI state shown when a user has no data to display (e.g., brand new user, no focus sessions)
- **Offline_Cache**: Locally stored analytics data available when network connectivity is unavailable
- **Heatmap**: A visual calendar grid showing daily activity patterns through color intensity

---

## Requirements

### Requirement 1: Display Multi-Period Analytics Overview

**User Story:** As a user, I want to view my progress across different time periods, so that I can track both my recent efforts and long-term consistency.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is opened, THE Dashboard SHALL display three default time period tabs (Week, Month, All-Time)
2. WHEN a time period tab is selected, THE Dashboard SHALL switch to that period and refresh all metrics synchronously; ADDITIONALLY, THE Dashboard SHALL refresh metrics automatically when the dashboard opens or when data changes in the background
3. THE Dashboard SHALL calculate metrics accurately for the selected period based on Firestore completion history
4. WHERE custom date range selection is enabled, THE Dashboard SHALL allow selection of start and end dates within the user's habit history
5. WHEN the user opens the dashboard, THE Dashboard SHALL default to displaying the current Week tab as the initial view
6. THE Dashboard SHALL persist the user's last selected time period for 24 hours and restore it on next app launch; IF the app is launched after the 24-hour boundary (exclusive), THE Dashboard SHALL revert to the Week default

---

### Requirement 2: Track and Display Habit Completion Metrics

**User Story:** As a user, I want to see detailed habit completion statistics, so that I can understand which habits are most consistent and where I'm succeeding.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard aggregates completion data across habits, THE Dashboard SHALL control which non-archived habits are included in dashboard displays
2. WHEN displaying completion percentage, THE Dashboard SHALL show the metric as both a percentage value and a visual progress bar
3. THE Dashboard SHALL display individual habit completion counts (e.g., "Completed 5 out of 7 days this week")
4. THE Dashboard SHALL rank habits by completion rate in descending order on the main metrics view
5. WHEN a habit has 100% completion rate in the selected period, THE Dashboard SHALL mark it with a special achievement indicator or badge
6. THE Dashboard SHALL aggregate completion data across all non-archived habits for period-level calculations
7. IF a habit has zero completions in the selected period, THE Dashboard SHALL still display it with 0% completion rate and include it in rankings

---

### Requirement 3: Display Focus Session Analytics

**User Story:** As a user, I want to see my focus time achievements, so that I can feel motivated by my deep work efforts and track productivity gains.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is displayed, THE Dashboard SHALL show total focus session minutes completed in the selected time period
2. WHEN displaying focus time metrics, THE Dashboard SHALL break down focus sessions by session type (25-minute, 50-minute) with counts and total minutes for each
3. THE Dashboard SHALL display the number of completed focus sessions in the selected period
4. THE Dashboard SHALL calculate average session duration and display it prominently
5. WHEN displaying focus session data, THE Dashboard SHALL also show total XP earned from focus sessions in the period
6. THE Dashboard SHALL display the longest consecutive completed focus sessions streak
7. IF no session data exists in the selected period, THE Dashboard SHALL display "0 sessions" and show 0 minutes with a motivational empty state; HOWEVER, IF session data exists but all sessions are incomplete/abandoned, THE Dashboard SHALL display actual metrics including zero completed sessions

---

### Requirement 4: Display Streak Statistics and Personal Records

**User Story:** As a user, I want to see my streak achievements and personal bests, so that I feel recognized for my consistency and understand my top performances.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is displayed, THE Dashboard SHALL show the user's current active habit streak (consecutive days of any habit completion)
2. WHEN displaying streak data, THE Dashboard SHALL show the longest/best streak achieved for each individual habit
3. THE Dashboard SHALL display the user's overall longest streak across all habits
4. WHEN streak display occurs, THE Dashboard SHALL highlight active streaks that are one day or longer with visual differentiation; streaks of zero days SHALL NOT receive active highlighting
5. THE Dashboard SHALL track and display the personal record for total habits completed in a single day
6. THE Dashboard SHALL track and display the personal record for total XP earned in a single day
7. THE Dashboard SHALL display the personal record for focus session minutes completed in a single day
8. WHEN a personal record is broken, THE Dashboard SHALL show a celebratory indicator or milestone badge next to the updated record

---

### Requirement 5: Generate Motivational Coaching Insights

**User Story:** As a user, I want to receive personalized, encouraging insights about my progress, so that Sadiq's coaching feels present and I stay motivated to continue my habits.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is displayed, THE Dashboard SHALL generate at least three distinct motivational insights based on the user's current metrics
2. WHEN generating insights, THE Dashboard SHALL compare current period performance with the previous identical period (e.g., this week vs last week) via comparative analysis
3. WHEN the comparative analysis shows progress has improved, THE Dashboard SHALL highlight improvements with language like "3 more habits this week!"
4. WHEN progress has declined versus the previous period, THE Dashboard SHALL provide encouraging language that reframes the situation positively (e.g., "Let's rebuild momentum together")
5. WHEN a personal record is actually achieved, THE Dashboard SHALL highlight it with celebratory language and emojis (e.g., "You've completed 15 habits this week! That's 3 more than last week. Keep building momentum! 💪")
6. WHEN a user reaches specific milestones (e.g., 7-day streak, 100 total habits completed), THE Dashboard SHALL generate a special achievement insight
7. THE Dashboard SHALL rotate insights displayed to prevent the same messages from showing repeatedly on successive visits
8. WHERE a user has very limited data (e.g., only 1-2 days of activity), THE Dashboard SHALL display introductory, encouraging insights rather than comparative analysis

---

### Requirement 6: Visualize Progress with Charts and Heatmaps

**User Story:** As a user, I want to see visual representations of my progress, so that I can quickly understand patterns and stay motivated by seeing my growth visually.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard displays Weekly period data, THE Dashboard SHALL show a bar chart displaying daily completion counts for each day of the week
2. WHEN the Analytics_Dashboard displays Monthly period data, THE Dashboard SHALL show a heatmap displaying daily habit completion activity with color intensity indicating activity level
3. WHEN displaying the heatmap, THE Dashboard SHALL use a color gradient from light (low activity) to dark/saturated (high activity) to represent completion density
4. THE Dashboard SHALL display a line chart tracking XP earned over time (with time axis based on selected period: daily for week, weekly for month)
5. WHEN a chart is explicitly tapped, THE Dashboard SHALL display a tooltip showing exact values for that data point; tooltips SHALL NOT appear automatically on hover or other interactions
6. THE Dashboard SHALL use Material 3 design colors and smooth animations for all chart transitions
7. IF no data exists for a visualization in the selected period, THE Dashboard SHALL show a placeholder with an empty state message and explanation

---

### Requirement 7: Integrate Analytics Dashboard with Main Navigation

**User Story:** As a user, I want to easily access the analytics dashboard from the main app, so that checking my progress is a natural part of my daily app experience.

#### Acceptance Criteria

1. WHEN viewing the main dashboard screen, THE User_Interface SHALL display a navigation tab or button that leads to the Analytics_Dashboard
2. WHEN the analytics button is tapped from the main dashboard, THE Analytics_Dashboard SHALL open smoothly with Material 3 transitions; IF the dashboard fails to open due to technical issues or loading errors, THE System SHALL provide specific error feedback and offer retry options or alternative access methods
3. THE Analytics_Dashboard SHALL include a back button or navigation mechanism to return to the main dashboard
4. WHEN navigating away from the Analytics_Dashboard and returning within 5 minutes, THE Dashboard SHALL restore to the same time period and scroll position
5. THE Analytics_Dashboard route SHALL be accessible via deep linking (e.g., app://analytics or similar)
6. WHERE the user has any data, THE Dashboard SHALL remain navigable regardless of other technical issues; WHERE the user has no habits or data, THE Dashboard SHALL still be navigable but show empty states with setup guidance

---

### Requirement 8: Handle Empty States and New User Experience

**User Story:** As a new user, I want to understand what the analytics dashboard will show me, so that I feel guided and motivated to build habits and track progress.

#### Acceptance Criteria

1. WHEN a new user opens the Analytics_Dashboard with no habit data, THE Dashboard SHALL display a welcoming empty state with Sadiq's encouraging message
2. WHEN showing empty state for habits, THE Dashboard SHALL display motivational text like "Start building your habit journey! Create your first habit to see your progress appear here. 🚀"
3. WHEN showing empty state for focus sessions, THE Dashboard SHALL display text like "Once you complete your first focus session, your productivity insights will appear here. Start focusing! 💪"
4. WHEN empty state is shown, THE Dashboard SHALL provide a clear action button that navigates the user to create their first habit or start a focus session
5. WHEN a user has some data but not others (e.g., habits but no focus sessions), THE Dashboard SHALL show the welcoming empty state since it takes precedence over partial states; alternatively, WHERE appropriate, show partial empty states only for unavailable metrics
6. WHEN a user has completed exactly one habit, THE Dashboard SHALL show that single data point clearly with encouragement to build on the momentum

---

### Requirement 9: Support Offline Analytics Caching

**User Story:** As a user in an area with unreliable connectivity, I want to view my recent analytics offline, so that my progress is always visible even without internet.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is opened and internet is available, THE Dashboard SHALL fetch the latest data from Firestore and cache it locally
2. WHEN the Analytics_Dashboard is opened and internet is unavailable, THE Dashboard SHALL display locally cached analytics data from the previous successful fetch
3. WHEN offline, THE Dashboard SHALL display a clear indicator (e.g., offline badge or message) showing that data may not be real-time; ADDITIONALLY, if displaying stale cached data, THE Dashboard MAY keep the offline indicator visible or omit it per design choice
4. THE Dashboard SHALL cache analytics data for the current week and month periods automatically
5. WHEN the cache is older than 6 hours and internet becomes available, THE Dashboard SHALL automatically refresh data in the background
6. IF cached data does not exist and internet is unavailable, THE Dashboard SHALL display an offline empty state with explanation; IF cached data is corrupted or invalid, THE Dashboard SHALL display it with a warning rather than treating it as non-existent
7. WHEN a user returns online after viewing cached data, THE Dashboard SHALL refresh and highlight any metrics that changed significantly

---

### Requirement 10: Support Comparison Mode and Week-over-Week Analysis

**User Story:** As a user, I want to compare my performance across weeks or months, so that I can see if I'm building consistent discipline over time.

#### Acceptance Criteria

1. WHERE comparison mode is enabled, THE Analytics_Dashboard SHALL display a toggle or selector allowing "This Period vs Previous Period" comparison
2. WHEN comparison mode is active, THE Dashboard SHALL display side-by-side or contrasting metrics showing current period and previous period values
3. WHEN displaying comparison metrics, THE Dashboard SHALL highlight increases in green and decreases in red, with neutral color for zero change
4. THE Dashboard SHALL display percentage change between periods (e.g., "+15% more completions this week"); WHERE the previous period value is zero and percentage change is mathematically undefined, THE Dashboard SHALL display 'N/A' or a similar indicator
5. WHEN comparison is displayed, THE Dashboard SHALL show change arrows or indicators to make trends immediately visible
6. THE Dashboard SHALL support comparing Week vs Week, Month vs Month, and custom date ranges
7. WHEN a user selects a specific habit, THE Dashboard SHALL show comparison metrics for that habit individually across periods

---

### Requirement 11: Archive and Filter Analytics by Habit Category

**User Story:** As a user with many habits across different areas, I want to filter my analytics by category, so that I can focus on specific areas of my life (fitness, mindfulness, learning, etc.).

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is displayed, THE Dashboard SHALL show category filter chips (Fitness, Mindfulness, Learning, Health, Custom categories)
2. WHEN a category filter is selected, THE Dashboard SHALL recalculate all metrics to show only data for habits in that category
3. WHEN a category is selected, THE Dashboard SHALL update all charts, streaks, and insights to reflect category-specific data only; additionally, insight messages SHALL reference the selected category only when category filtering is actively selected by the user
4. THE Dashboard SHALL show "All Categories" as the default filter option, displaying combined analytics
5. WHEN filtering by category, THE Dashboard SHALL update the insight messages to reference the selected category (e.g., "Your mindfulness habits this week...")
6. IF a category has no habits, THE Dashboard SHALL display that category as disabled in the filter options
7. WHEN a category filter is applied, THE Dashboard SHALL immediately prepare and persist the selection, showing it as active on the next visit within 24 hours

---

### Requirement 12: Display Specific Habit Performance Details

**User Story:** As a user, I want to drill down into individual habit performance, so that I can understand exactly how I'm doing with each habit and identify which ones need attention.

#### Acceptance Criteria

1. WHEN a user taps on a habit in the Analytics_Dashboard, THE Dashboard SHALL display a detailed habit performance view
2. WHEN viewing habit details, THE Dashboard SHALL display the habit's completion rate, streak, best performance period, and historical data
3. THE Dashboard SHALL show a mini timeline or chart specifically for that habit showing completions over the selected period
4. WHEN displaying habit details, THE Dashboard SHALL include the habit emoji and color for visual recognition
5. THE Dashboard SHALL show when the habit was last completed and how long the current streak is
6. THE Dashboard SHALL display comparative metrics (e.g., "8/10 completions this week, compared to 6/10 last week")
7. WHEN the user closes the habit detail view, THE Dashboard SHALL return to the main analytics dashboard with the time period preserved

---

### Requirement 13: Surface Achievements and Milestone Recognition

**User Story:** As a user, I want to see my achievements and milestones celebrated, so that I feel recognized for my hard work and stay motivated.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is displayed, THE Dashboard SHALL show an achievements section highlighting recent milestones unlocked
2. THE Dashboard SHALL track and display milestone achievements such as "7-Day Streak", "30-Day Streak", "100 Habits Completed", "1000 XP Earned", "50 Focus Hours"
3. WHEN an achievement is unlocked (e.g., 7-day streak reached), THE Dashboard SHALL show a celebratory animation and badge only when the achievement is actually unlocked
4. WHEN displaying achievements, THE Dashboard SHALL include achievement date and the associated metric value (e.g., "7-Day Streak - Achieved on March 15")
5. THE Dashboard SHALL display locked upcoming milestones with progress toward unlocking (e.g., "100 Habits Completed - 73/100")
6. WHEN scrolling through achievements, THE Dashboard SHALL show at least the 5 most recent achievements with older ones accessible via scrolling
7. WHEN an achievement is locked and near completion, THE Dashboard SHALL highlight it with encouragement; additionally, WHEN achievement thresholds change, THE Dashboard SHALL immediately apply new thresholds and recalculate all progress and near-completion status based on current values

---

### Requirement 14: Support Responsive Design Across Device Sizes

**User Story:** As a user on different devices, I want the analytics dashboard to work beautifully on phones, tablets, and larger screens, so that I can view my progress anywhere.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard is displayed on a phone (portrait orientation), THE Dashboard SHALL stack metrics and charts vertically with appropriate responsive sizing
2. WHEN the Analytics_Dashboard is displayed on a tablet or larger screen, THE Dashboard SHALL display multiple metrics horizontally in a grid layout
3. THE Dashboard SHALL use responsive font sizes that scale appropriately for different screen sizes
4. WHEN displaying charts on small screens, THE Dashboard SHALL ensure all data is visible without excessive scrolling
5. WHEN the device is rotated, THE Dashboard SHALL reflow and adapt smoothly to the new orientation
6. WHEN scrolling through metrics on any device size, THE Dashboard SHALL maintain smooth 60fps performance
7. THE Dashboard SHALL follow Material 3 responsive design patterns and guidelines for all screen sizes

---

### Requirement 15: Implement Real-Time Data Updates

**User Story:** As a user, I want my analytics to update automatically when I complete habits or focus sessions, so that my progress is always current and motivating.

#### Acceptance Criteria

1. WHEN a habit is completed in another part of the app (e.g., habits screen), THE Analytics_Dashboard SHALL automatically update its metrics via Firestore listeners
2. WHEN a focus session is completed, THE Dashboard SHALL automatically refresh focus-related metrics within 2 seconds; THE Dashboard SHALL maintain this 2-second refresh limit strictly regardless of system load
3. WHEN metrics are updated in real-time, THE Dashboard SHALL show smooth animations or transitions rather than jarring refreshes
4. WHEN real-time updates occur, THE Dashboard SHALL preserve the user's current scroll position and selected time period
5. WHEN multiple rapid updates occur (e.g., completing multiple habits quickly), THE Dashboard SHALL batch updates and refresh once per 500ms to avoid excessive re-renders
6. IF real-time updates fail due to connectivity loss or for other reasons (server errors, permission issues), THE Dashboard SHALL gracefully handle the error and retry transparently in the background
7. WHEN connectivity is restored after an offline period, THE Dashboard SHALL automatically sync and update to reflect all changes that occurred during downtime

---

### Requirement 16: Generate Predictive Insights About Future Progress

**User Story:** As a user, I want to see projections and insights about my likely performance, so that I can understand the impact of my current habits on future goals.

#### Acceptance Criteria

1. WHEN the Analytics_Dashboard displays data for at least 7 days of habit history, THE Dashboard SHALL generate a projection insight about the user's likely completion rate for the coming month
2. WHEN generating projections, THE Dashboard SHALL use the user's average completion rate to estimate total completions in the next period
3. THE Dashboard SHALL display insights like "At your current pace, you'll complete 85 habits next month" or similar projections
4. WHERE a user's completion rate is increasing, THE Dashboard SHALL project accelerated results (e.g., "With your growing momentum, you could complete 95 habits next month")
5. THE Dashboard SHALL display the confidence level of predictions based on data recency and consistency
6. IF prediction confidence is low (e.g., user is new or has sporadic activity), THE Dashboard SHALL note that predictions will improve as the user builds consistent history
7. WHEN a user's trajectory is declining, THE Dashboard SHALL provide supportive reframing: "Let's focus on rebuilding this week"

---

## Visual Design & Coaching Tone Principles

The following principles guide all aspects of the Analytics Dashboard to ensure alignment with Sadiq's supportive coaching philosophy:

- **Celebrate, Don't Judge**: All metrics and insights frame progress as achievement and growth, never as failure
- **Comparative Motivation**: When showing improvement areas, compare only to user's own past performance, never to other users
- **Emoji-Enriched Communication**: Use emojis and warm language to make analytics feel conversational and encouraging
- **Action-Oriented Insights**: Insights always suggest next steps or actions the user can take
- **Accessibility First**: Ensure all charts have alt-text, color blindness-safe palettes, and text labels
- **Performance Optimized**: All analytics queries and UI updates maintain 60fps performance
- **Firestore-Centric Data**: All metrics are calculated from Firestore completion history; no local calculations create inconsistencies

---

## Data Source Dependencies

This feature depends on the following existing Firestore data structures:

- **Habits Collection**: `users/{userId}/habits/` - Contains habit definitions and aggregated stats
- **Habit Completions**: `users/{userId}/habits/{habitId}/completions/` - Daily completion records
- **Focus Sessions Collection**: `users/{userId}/focusSessions/` - Contains all focus session records with completion status and XP
- **User Profile**: `users/{userId}/` - Contains accumulated user stats (totalXp, totalFocusSeconds, focusSessionsCompleted)

---

## Out of Scope

The following items are intentionally excluded from this feature specification:

- Social comparison or leaderboard functionality
- Automatic habit recommendations based on analytics
- Advanced ML-based insights or pattern detection
- Export/download of analytics data
- Analytics push notifications or reminders
- Integration with third-party health/fitness apps
