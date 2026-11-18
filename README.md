# Ride-Hailing Demand and Surge Pricing Analysis

**Primary analytics type:** Predictive analytics  
**Study area:** New York City, USA  
**Primary dataset:** NYC Taxi & Limousine Commission (TLC) High Volume For-Hire Vehicle trip records  
**Notebook:** [project_notebook.Rmd](project_notebook.Rmd)

## Research question

Can historical ride-hailing demand by NYC taxi zone and hour predict next-hour demand well enough to support data-informed driver-positioning recommendations?

## Objectives

1. Quantify hourly ride-hailing activity by pickup zone, weekday and provider.
2. Identify recurring temporal and spatial demand patterns.
3. Forecast next-hour, zone-level trip activity and compare it with a simple baseline.
4. Translate forecasts into a transparent driver-positioning decision rule.
5. Assess which surge-pricing, wait-time and supply questions the public data can actually answer.

## Data and scope

The notebook retrieves a bounded January 2024 sample from the public NYC Open Data API. Each record represents a trip dispatched by a high-volume for-hire base. Fields include request time, pickup/drop-off time and taxi-zone IDs, provider license, trip distance, fare and driver pay.

The TLC dataset is not a complete platform marketplace feed. It does not include a general surge multiplier, all online/idle drivers, rejected requests, or wait times for every trip. The TLC data dictionary documents `on_scene_datetime` for accessible-vehicle trips only. Accordingly, the project does not fabricate surge multipliers, causal surge effects, universal wait times or live driver supply. Realized dispatched-trip counts are used as an observable proxy for activity.

## Run

Requires R 4.2+ and internet access. Open `project_notebook.Rmd` in RStudio and Knit to HTML. The notebook installs missing packages, downloads a bounded public API sample (up to 5 million records, with an explicit warning if the safety ceiling is reached), performs quality checks, creates plots, trains/evaluates a model and records extraction and analysis outcomes. Raw data and generated HTML are not committed. Rendering is manual in RStudio; no GitHub Actions workflow is used.

## Repository structure

- `project_notebook.Rmd` — complete analysis, methods, outputs and activity log.
- `R/analysis_helpers.R` — reusable data-cleaning and feature-engineering functions.
- `data/README.md` — source, fields, access method and limitations.
- `outputs/figures/` — charts generated when the notebook is knitted.

## Sources

- [NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
- [2024 High Volume FHV Trip Data](https://data.cityofnewyork.us/Transportation/2024-High-Volume-FHV-Trip-Data/bqxa-629f)
- [High Volume FHV Trip Records Data Dictionary](https://home4.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf)

## Submission

The assignment's stated Google Form deadline was **August 6, 2026, 11:59 PM**. This repository is public. If a private copy is used, grant `datta_subhajit@yahoo.com` access as instructed. Submit the repository URL through https://forms.gle/ctRk3p9wuCav1za9A.
