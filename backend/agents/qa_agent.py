from crewai import Agent, LLM
import os


def create_qa_agent() -> Agent:
    llm = LLM(
        model="groq/llama-3.3-70b-versatile",
        api_key=os.getenv("GROQ_API_KEY"),
        temperature=0.1,
    )

    return Agent(
        role="Safety & Quality Reviewer",
        goal=(
            "Review all AI-generated fitness content before it reaches the user. "
            "Ensure recommendations are safe, within healthy physiological ranges, "
            "and compliant with App Store health app guidelines."
        ),
        backstory=(
            "You are a certified medical fitness professional and App Store "
            "compliance reviewer. You verify that calorie goals are within safe "
            "ranges (1200–4000 kcal), workout intensity doesn't push injured or "
            "over-trained users too hard, and all content includes appropriate "
            "safety disclaimers. You are the last line of defense before content "
            "reaches users."
        ),
        llm=llm,
        verbose=True,
        allow_delegation=False,
    )
