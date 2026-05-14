from crewai import Agent, LLM
import os


def create_healthkit_agent() -> Agent:
    llm = LLM(
        model="groq/llama-3.3-70b-versatile",
        api_key=os.getenv("GROQ_API_KEY"),
        temperature=0.2,
    )

    return Agent(
        role="Health Data Analyst",
        goal=(
            "Analyze Apple Health metrics sent from the iOS app and generate "
            "personalized daily insights, progress summaries, and workout intensity "
            "recommendations based on the user's current physiological state."
        ),
        backstory=(
            "You are a sports scientist specializing in energy expenditure, "
            "recovery, and performance optimization. You interpret HealthKit data "
            "— active energy, resting heart rate, steps, sleep — and detect "
            "patterns like overtraining, under-recovery, or momentum streaks. "
            "You give evidence-based, practical recommendations."
        ),
        llm=llm,
        verbose=True,
        allow_delegation=False,
    )
