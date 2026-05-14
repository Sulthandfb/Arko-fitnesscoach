"""
ARKO CrewAI — Interactive Terminal Test
========================================
Jalankan: python test_interactive.py
Bisa input data sendiri dan pilih agent mana yang mau ditest.
"""

from dotenv import load_dotenv
from crew import run_health_insight_crew, run_form_feedback_crew
from agents.apple_health_agent import mock_a2a_response

load_dotenv()


def separator(title=""):
    print("\n" + "=" * 60)
    if title:
        print(f"  {title}")
        print("=" * 60)


def test_health_insight():
    separator("TEST 1 — HealthKitAgent + QAAgent")
    print("Masukkan data health kamu (Enter = pakai default):\n")

    active  = input("  Active energy kcal [342]: ").strip() or "342"
    goal    = input("  Calorie goal kcal  [600]: ").strip() or "600"
    steps   = input("  Steps             [6240]: ").strip() or "6240"
    hr      = input("  Resting HR bpm      [68]: ").strip() or "68"
    sleep   = input("  Sleep hours        [7.5]: ").strip() or "7.5"
    streak  = input("  Streak days          [4]: ").strip() or "4"

    health_data = {
        "active_energy": float(active),
        "calorie_goal":  int(goal),
        "steps":         int(steps),
        "resting_hr":    int(hr),
        "sleep_hours":   float(sleep),
        "streak_days":   int(streak),
    }

    print("\n  Sending to HealthKitAgent → QAAgent...\n")
    result = run_health_insight_crew(health_data)
    print("\n  RESULT:\n", result)


def test_form_feedback():
    separator("TEST 2 — UIAgent + QAAgent")
    print("Masukkan data exercise kamu (Enter = pakai default):\n")

    exercise = input("  Exercise [Squat]: ").strip() or "Squat"
    level    = input("  Level (beginner/intermediate/advanced) [beginner]: ").strip() or "beginner"

    print("\n  Keypoints (pakai data sample squat):")
    keypoints = [
        {"joint": "left_knee",  "angle": 75},
        {"joint": "right_knee", "angle": 73},
        {"joint": "hip",        "angle": 90},
        {"joint": "spine",      "angle": 5},
    ]
    for kp in keypoints:
        print(f"    {kp['joint']}: {kp['angle']}°")

    print(f"\n  Sending '{exercise}' to UIAgent → QAAgent...\n")
    result = run_form_feedback_crew(exercise, keypoints, level)
    print("\n  RESULT:\n", result)


def test_a2a():
    separator("TEST 3 — AppleHealthAgent A2A Mock")
    print("Generate mock A2A JSON response:\n")

    active = input("  Active energy kcal [342]: ").strip() or "342"
    goal   = input("  Calorie goal kcal  [600]: ").strip() or "600"
    steps  = input("  Steps             [6240]: ").strip() or "6240"

    import json
    response = mock_a2a_response({
        "active_energy": float(active),
        "calorie_goal":  int(goal),
        "steps":         int(steps),
        "resting_hr":    68,
        "sleep_hours":   7.5,
        "streak_days":   4,
    })

    print("\n  A2A JSON Response:")
    print(json.dumps(response, indent=2))

    # Parse like SwiftUI does
    artifact = response["result"]["artifacts"][0]
    data_part = next(p for p in artifact["parts"] if p["type"] == "data")
    text_part = next(p for p in artifact["parts"] if p["type"] == "text")

    print("\n  Parsed (like SwiftUI):")
    print(f"    Active Energy : {data_part['data']['active_energy_kcal']} kcal")
    print(f"    Progress      : {data_part['data']['progress_pct']}%")
    print(f"    Insight       : {text_part['text']}")


def main():
    separator("ARKO CrewAI — Interactive Test")
    print("""
  Pilih test:
    1 — HealthKitAgent + QAAgent (daily insight)
    2 — UIAgent + QAAgent (form feedback)
    3 — AppleHealthAgent A2A mock
    0 — Run semua (auto dengan data default)
""")

    choice = input("  Pilihan [0]: ").strip() or "0"

    if choice == "1":
        test_health_insight()
    elif choice == "2":
        test_form_feedback()
    elif choice == "3":
        test_a2a()
    elif choice == "0":
        test_a2a()
        test_health_insight()
        test_form_feedback()
    else:
        print("  Pilihan tidak valid.")

    separator("DONE")


if __name__ == "__main__":
    main()
