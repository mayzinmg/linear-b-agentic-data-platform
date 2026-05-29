# DĀMOS Source Exploration

## Goal

Explore whether DĀMOS can be used as an academic source for the Linear B Agentic Data Platform.

## Questions to Investigate

1. Does DĀMOS provide CSV, XML, JSON, or another export format?
2. Can data be downloaded directly, or only through the web interface?
3. What metadata fields are available?
4. What text/transliteration fields are available?
5. What citation or licensing requirements must be respected?
6. Should the first version use manual snapshots instead of automated scraping?

## Initial Decision

The first DĀMOS integration will use a controlled snapshot approach. Automated ingestion will only be added later if a stable and appropriate export method is available.

# DĀMOS Source Exploration

## Goal

Explore whether DĀMOS can be used as an academic source for the Linear B Agentic Data Platform.

## Questions to Investigate

1. Does DĀMOS provide CSV, XML, JSON, or another export format?
2. Can data be downloaded directly, or only through the web interface?
3. What metadata fields are available?
4. What text or transliteration fields are available?
5. What citation or licensing requirements must be respected?
6. Should the first version use manual snapshots instead of automated scraping?

## Initial Decision

The first DĀMOS integration will use a controlled snapshot approach. Automated ingestion will only be added later if a stable and appropriate export method is available.

## DĀMOS Source Limitation

This project does not claim to ingest the complete DĀMOS corpus. The first DĀMOS integration uses a controlled search-result snapshot exported from the DĀMOS interface. This snapshot is used to explore source structure, token-level metadata, source-version tracking, and evidence-based interpretation.

Because the snapshot may not represent the entire corpus, analytical outputs should be interpreted as findings from the selected snapshot only. Future work may expand the integration if a stable and appropriate full export method becomes available.

## DĀMOS Match Coverage

The DĀMOS snapshot was joined with the tablet-level InsiderPhD dataset using a normalized tablet key. In the current snapshot, 2,738 tablet records were matched with DĀMOS token-level metadata, while 2,109 records were not matched.

The unmatched records should not be interpreted as missing from DĀMOS entirely, because the current DĀMOS input is a search-result snapshot rather than a complete corpus export.