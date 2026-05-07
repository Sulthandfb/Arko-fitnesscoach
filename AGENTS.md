# ARKO Multi-Agent Architecture

## Overview

ARKO uses a multi-agent system orchestrated by **CrewAI** (Python backend on Railway/Render).
The iOS app communicates with the backend via REST API (JSON over HTTPS).

HealthKit data is read locally on iOS then sent to backend — agents never directly access HealthKit.

---

## Agent Definitions

### UIAgent
**Role:** UI/UX intelligence and form feedback interpretation  
**Goal:** Translate raw Vision/Core ML pose data into human-readable, actionable feedback  
**Backstory:** Expert personal trainer who can read body mechanics from keypoint data

**Responsibilities:**
- Parse pose estimation keypoints from iOS Vision framework
- Generate corrective feedback (e.g., "Lower your hips 10cm in squat position")
- Adapt language to user fitness level (beginner/intermediate/advanced)
- Output structured feedback JSON for SwiftUI rendering

**Tools:** Claude API (claude-sonnet-4-6), pose analysis prompts  
**Input:** `{ exercise: String, keypoints: [Point], confidence: Float, user_level: String }`  
**Output:** `{ feedback: String, severity: "good"|"warn"|"error", tip: String }`

---

### HealthKitAgent
**Role:** Health data analyst and progress tracker  
**Goal:** Interpret Apple Health metrics and generate insights for daily coaching  
**Backstory:** Sports scientist specializing in energy expenditure and recovery

**Responsibilities:**
- Analyze active energy, resting HR, step count, sleep data sent from iOS
- Compare against user's daily calorie goal
- Detect overtraining signals (high HR + low sleep + high active energy)
- Generate daily progress summary and adjust workout intensity recommendation

**Tools:** Claude API, statistical analysis  
**Input:** `{ active_energy: Float, resting_hr: Int, steps: Int, sleep_hours: Float, calorie_goal: Int }`  
**Output:** `{ progress_pct: Float, status: String, recommendation: String, adjust_intensity: Bool }`

---

### QAAgent
**Role:** Quality assurance and recommendation validator  
**Goal:** Ensure all AI outputs are safe, accurate, and App Store compliant  
**Backstory:** Medical fitness professional focused on user safety

**Responsibilities:**
- Validate workout recommendations don't exceed safe intensity thresholds
- Flag potentially dangerous form feedback
- Ensure calorie recommendations are within healthy ranges (1200–4000 kcal)
- Review UIAgent output before sending to iOS
- Generate safe disclaimers when needed

**Tools:** Rule-based validation + Claude API  
**Input:** Output from UIAgent and HealthKitAgent  
**Output:** `{ approved: Bool, modified_output: String?, safety_note: String? }`

---

## CrewAI Workflow

```
iOS App
  │
  ├─ POST /analyze-form
  │    └─ UIAgent → QAAgent → response
  │
  ├─ POST /health-insights
  │    └─ HealthKitAgent → QAAgent → response
  │
  └─ POST /workout-recommendation
       └─ HealthKitAgent → UIAgent → QAAgent → response
```

## Backend Tech Stack

- **Framework:** FastAPI (Python)
- **Agent Orchestration:** CrewAI + Claude API (claude-sonnet-4-6)
- **Deploy:** Railway or Render (free tier for MVP)
- **Auth:** Firebase Admin SDK (verify iOS Firebase tokens)

## iOS ↔ Backend Contract

All requests include Firebase Auth token in header:
```
Authorization: Bearer <firebase_id_token>
```

All responses follow:
```json
{
  "success": true,
  "data": { ... },
  "agent_used": "UIAgent|HealthKitAgent",
  "qa_approved": true
}
```

## iOS Skill References

When building iOS side of agent communication:
- Use `swift-concurrency` skill for all async API calls
- Use `swiftui-expert-skill` for rendering agent feedback in UI
- Use `core-data-expert` skill for caching agent responses locally (SwiftData)
