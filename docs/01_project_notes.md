# Project Notes: Linear B Agentic Data Engineering

## Step 1A — Understanding Linear B as Data

Linear B tablets can be treated as ancient administrative records rather than narrative texts. Most surviving Linear B tablets record organized information about animals, places, vehicles, assets, people, and quantities.

From a data engineering perspective, this makes Linear B suitable for structured analysis. Each tablet can be viewed as a historical data record, while signs, ideograms, places, and quantities can be modeled as fields, categories, or entities within a dataset.

## Step 1B — Viewing a Tablet as a Data Record


A Linear B tablet can be viewed as a historical source record. Each tablet usually has an identifier, a place of origin, written signs, transliterated text, and sometimes ideograms or quantities.

From a data engineering perspective, the tablet can become the raw record in the bronze layer. Later, its signs, words, ideograms, places, and quantities can be extracted into cleaner silver and gold tables for analysis.

A possible raw Linear B tablet record may include the following fields:

- tablet_id
- site
- source
- transliteration
- sign_sequence
- ideogram
- quantity
- notes

## Why This Project Uses Medallion Architecture

This project uses a simple medallion architecture because Linear B tablet data moves through different levels of structure and trust. The bronze layer preserves the raw tablet records and source information. The silver layer standardizes tablet identifiers, sites, transliterations, signs, ideograms, and quantities. The gold layer prepares analysis-ready tables such as sign frequencies, site summaries, and entity relationships.

This layered approach helps separate original evidence from cleaned interpretation and analytical outputs. It is especially useful for historical data, where uncertainty, fragmentation, and source variation must be handled carefully.

## Step 1C — Evidence vs Interpretation

In this project, the data engineering layers and the agentic AI interpretation layer will be separated. The bronze, silver, and gold layers will store raw, cleaned, and analysis-ready data. The interpretation layer will generate possible explanations, observations, and hypotheses based on the structured data.

This separation is important because historical interpretation can be uncertain. The system should preserve the original evidence, provide measurable analytical outputs, and clearly mark AI-generated interpretations as hypotheses rather than confirmed facts.

## Step 1D — Understanding Signs, Ideograms, and Quantities
## Sample Tablet — PY Ub 1318

The sample tablet was found at the archaeological site of Pylos. It appears to be an administrative distribution record that logs animal hides, including bovine, pig, and deer hides, and connects them with people or roles such as saddle-makers and shoe-makers.

From a data engineering perspective, this record can be modeled as a structured data table using the following data fields:

Field	Example value
tablet_id	PY_Ub_1318
site	Pylos
source_type	clay_tablet
script	Linear B
record_category	administrative_distribution
commodity_group	animal_hides
animal_sources	bovine, pig, deer
recipient_roles	shoe_makers, saddle_makers
has_numbers	true
notes	Distribution record involving hides and craft worker

## Step 1D — Metadata Fields vs Analytical Fields
Metadata tells us about the tablet.
Analytical fields tell us what we can study from the tablet.
For example, tablet_id and site are metadata.
Animal sources, commodity group, and recipient roles are analytical fields.
This separation helps us organize the data clearly.

## Step 2A
DĀMOS is treated as the primary academic reference corpus for this project. However, the first prototype uses a simpler CSV dataset so that the data engineering workflow can be built and tested before integrating a more complex research corpus.

## Step 2B — Silver Layer Cleaning

The Silver layer was created from the Bronze table by standardizing column names, trimming unnecessary spaces, and removing confirmed exact duplicate records.

The original Bronze table preserves all source rows from the external dataset. Before removing duplicates, a duplicate audit table was created to show which records appeared more than once. This keeps the cleaning process transparent and traceable.

The Silver table uses clearer field names such as `tablet_id`, `site_code`, `tablet_series`, `transliterated_text`, and `original_inscription`. These names make the dataset easier to understand and prepare it for later analysis in the Gold layer.