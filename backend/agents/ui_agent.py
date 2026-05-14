from crewai import Agent, LLM
import os


def create_ui_agent() -> Agent:
    llm = LLM(
        model="groq/llama-3.3-70b-versatile",
        api_key=os.getenv("GROQ_API_KEY"),
        temperature=0.3,
    )

    return Agent(
        role="Fitness UI Coach",
        goal=(
            "Translate raw pose keypoint data from Apple Vision framework into "
            "clear, human-readable form feedback that helps users improve their "
            "exercise technique safely."
        ),
        backstory=(
            "You are an expert personal trainer with 10 years of experience "
            "coaching athletes. You can read body mechanics from joint angle data "
            "and keypoints, and you communicate corrections in a motivating, "
            "encouraging tone. You adapt your language to the user's fitness level."
        ),
        llm=llm,
        verbose=True,
        allow_delegation=False,
    )
