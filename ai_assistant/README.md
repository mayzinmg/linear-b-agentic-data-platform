# AI/RAG Assistant — Version 0

This folder contains the first Agentic/RAG-style assistant prototype for the Linear B Research Data Platform.

## Purpose

The assistant explains project outputs using:

* DuckDB Gold/enrichment tables
* project documentation
* simple keyword-based retrieval
* structured evidence-based answer formatting

## Current Scope

Version 0 does not use a live LLM yet.

It demonstrates the core workflow:

```text
Question
→ query DuckDB evidence
→ load project documentation
→ retrieve relevant context
→ produce structured answer with evidence and uncertainty
```

## First Supported Question

```text
What does the DĀMOS match coverage mean?
```

## Important Limitation

This assistant does not translate Linear B.

It only explains evidence from the current project outputs. The DĀMOS input is a search-result snapshot, not a confirmed full export of the entire DĀMOS corpus.

Therefore, unmatched records should only be interpreted as unmatched against the current snapshot, not as absent from DĀMOS entirely.

## Future Work

Planned improvements:

1. Add a local/open-source LLM.
2. Add vector-based retrieval.
3. Add more evaluation questions.
4. Add guardrails against unsupported historical claims.
5. Add a small CLI or web interface.
