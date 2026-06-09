
from pathlib import Path
import duckdb


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DB_PATH = PROJECT_ROOT / "linear_b.duckdb"


def get_damos_match_coverage():
    query = """
    SELECT
        damos_match_status,
        COUNT(*) AS tablet_count,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
    FROM gold_tablet_damos_enrichment
    GROUP BY damos_match_status
    ORDER BY tablet_count DESC;
    """

    with duckdb.connect(str(DB_PATH), read_only=True) as conn:
        return conn.execute(query).fetchall()

def build_match_coverage_answer(rows, relevant_context):
    coverage_lines = []

    for status, count, percentage in rows:
        coverage_lines.append(f"- {status}: {count} tablets ({percentage}%)")

    evidence_text = "\n".join(coverage_lines)

    answer = f"""
Question:
What does the DĀMOS match coverage mean?

Observation:
The DĀMOS match coverage shows how many tablet records from the Linear B dataset could be matched with the current DĀMOS search-result snapshot.

Evidence:
{evidence_text}

Relevant project context:
{relevant_context}

Possible interpretation:
Matched records have additional token-level information from the DĀMOS snapshot. This helps enrich the tablet-level dataset with more detailed linguistic and source-related information.

Uncertainty:
The DĀMOS input is a search-result snapshot, not a confirmed full export of the entire DĀMOS corpus. Therefore, unmatched records should only be interpreted as unmatched against the current snapshot.

Conclusion:
This is an evidence-based explanation from the project data and documentation. It does not translate Linear B.
"""
    return answer.strip()

def route_question(question: str):
    question_lower = question.lower()

    if "match" in question_lower or "coverage" in question_lower:
        return "match_coverage"

    if "series" in question_lower:
        return "top_series"

    return "unknown"

def get_top_damos_series(limit: int = 10):
    query = f"""
    SELECT
        site_code,
        tablet_series,
        token_count,
        tablet_count
    FROM gold_damos_tokens_by_series
    ORDER BY token_count DESC
    LIMIT {limit};
    """

    with duckdb.connect(str(DB_PATH), read_only=True) as conn:
        return conn.execute(query).fetchall()
    
def build_top_series_answer(rows):
    series_lines = []

    for site_code, tablet_series, token_count, tablet_count in rows:
        series_lines.append(
            f"- {site_code} {tablet_series}: {token_count} tokens across {tablet_count} tablets"
        )

    evidence_text = "\n".join(series_lines)

    answer = f"""
        Question:
        Which DĀMOS tablet series has the highest token count?

        Observation:
        This result shows the DĀMOS tablet series with the highest number of token records in the current snapshot.

        Evidence:
        {evidence_text}

        Possible interpretation:
        A higher token count may indicate that the series has richer token-level representation in the current DĀMOS snapshot.

        Uncertainty:
        This is based only on the current DĀMOS search-result snapshot, not the full DĀMOS corpus.

        Conclusion:
        This is an evidence-based ranking from the Gold DĀMOS series table.
        """
    return answer.strip()

def load_project_context():
    context_files = [
        PROJECT_ROOT / "README.md",
        PROJECT_ROOT / "docs" / "damos_source_exploration.md",
        PROJECT_ROOT / "docs" / "dbt_migration_status.md",
    ]

    context_parts = []

    for file_path in context_files:
        if file_path.exists():
            context_parts.append(f"\n--- {file_path.name} ---\n")
            context_parts.append(file_path.read_text(encoding="utf-8", errors="ignore"))

    return "\n".join(context_parts)

def retrieve_relevant_context(question: str, context: str):
    keywords = [
        "DĀMOS",
        "snapshot",
        "match",
        "coverage",
        "enrichment",
        "corpus",
        "source",
        "uncertainty",
    ]

    paragraphs = context.split("\n\n")
    relevant = []

    for paragraph in paragraphs:
        paragraph_lower = paragraph.lower()

        score = sum(
            1 for keyword in keywords
            if keyword.lower() in paragraph_lower
        )

        if score > 0:
            relevant.append((score, paragraph.strip()))

    relevant.sort(reverse=True, key=lambda item: item[0])

    top_paragraphs = [paragraph for score, paragraph in relevant[:3]]

    return "\n\n".join(top_paragraphs)

if __name__ == "__main__":
    question = "What does the DĀMOS match coverage mean?"

    context = load_project_context()
    relevant_context = retrieve_relevant_context(question, context)

    rows = get_damos_match_coverage()
    answer = build_match_coverage_answer(rows, relevant_context)

    print(answer)