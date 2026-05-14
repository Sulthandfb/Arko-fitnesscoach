"""
ARKO — A2A Agent Cards
========================
Setiap agent punya Agent Card di /.well-known/agent.json
Ini yang dibaca oleh client (iOS app / agent lain) untuk discovery.
"""

APPLE_HEALTH_AGENT_CARD = {
    "name": "ARKO AppleHealthAgent",
    "description": (
        "Reads Apple HealthKit data (active energy, steps, heart rate, sleep) "
        "and returns structured daily health metrics in A2A format."
    ),
    "url": "https://arko-apple-health-agent-<YOUR_ID>.run.app",
    "version": "1.0.0",
    "capabilities": {
        "streaming": False,
        "pushNotifications": False,
    },
    "skills": [
        {
            "id": "daily-calorie-report",
            "name": "Daily Calorie Report",
            "description": "Returns today's active energy, steps, HR, and AI insight.",
            "inputModes": ["application/json"],
            "outputModes": ["application/json"],
            "examples": [
                "Give me today's calorie summary",
                "How many calories did I burn today?",
            ],
        }
    ],
}

UI_AGENT_CARD = {
    "name": "ARKO UIAgent",
    "description": (
        "Analyzes exercise form from Apple Vision pose keypoints "
        "and returns corrective feedback in A2A format."
    ),
    "url": "https://arko-ui-agent-<YOUR_ID>.run.app",
    "version": "1.0.0",
    "capabilities": {"streaming": False, "pushNotifications": False},
    "skills": [
        {
            "id": "form-feedback",
            "name": "Exercise Form Feedback",
            "description": "Analyzes pose keypoints and returns form corrections.",
            "inputModes": ["application/json"],
            "outputModes": ["application/json"],
        }
    ],
}

QA_AGENT_CARD = {
    "name": "ARKO QAAgent",
    "description": (
        "Reviews AI-generated fitness content for safety, accuracy, "
        "and App Store compliance before sending to users."
    ),
    "url": "https://arko-qa-agent-<YOUR_ID>.run.app",
    "version": "1.0.0",
    "capabilities": {"streaming": False, "pushNotifications": False},
    "skills": [
        {
            "id": "safety-review",
            "name": "Safety & Compliance Review",
            "description": "Validates fitness recommendations are safe and compliant.",
            "inputModes": ["application/json"],
            "outputModes": ["application/json"],
        }
    ],
}
