# Dataset Documentation

## Primary Dataset: NYC TLC High Volume For-Hire Vehicle (HVFHV) Trip Records (2024)

- **Source:** New York City Taxi and Limousine Commission (TLC) via NYC Open Data
- **Dataset ID:** `bqxa-629f`
- **Dataset Portal:** [NYC Open Data — 2024 High Volume FHV Trip Data](https://data.cityofnewyork.us/Transportation/2024-High-Volume-FHV-Trip-Data/bqxa-629f)
- **API Endpoint:** `https://data.cityofnewyork.us/resource/bqxa-629f.json`
- **Data Dictionary:** [TLC High Volume FHV Data Dictionary (PDF)](https://home4.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf)

### Cached Files

1. **`hvfhv_hourly_zone_2024-01-01_to_21.csv`**
   - **Scope:** January 1 – January 21, 2024 (three complete weeks).
   - **Volume:** 126,584 zone-hour-day rows representing **13,317,158 dispatched trips**.
   - **Method of Extraction:** Server-side SoQL aggregation via the SODA API. Trips are grouped by `pulocationid` (pickup taxi zone) and `hr` (`date_extract_hh(request_datetime)`), summing trips, miles, and base passenger fare. This avoids downloading dozens of gigabytes of raw individual trip records.
   - **Fields:**
     - `pulocationid`: TLC pickup taxi zone ID (integer 1–263+).
     - `hr`: Hour of trip request in NYC local time (0–23).
     - `trips`: Number of trip requests dispatched in that zone-hour.
     - `miles`: Total trip distance in miles across all trips in that zone-hour.
     - `fare_sum`: Total base passenger fare in USD across all trips in that zone-hour.
     - `day`: Date string (`YYYY-MM-DD`).

2. **`taxi_zone_lookup.csv`**
   - **Source:** [NYC TLC Official Zone Lookup Table](https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv)
   - **Fields:** `LocationID`, `Borough`, `Zone`, `service_zone`.
   - **Purpose:** Maps numeric TLC zone identifiers to real-world NYC neighbourhoods and boroughs (e.g. JFK Airport, Midtown Center, Crown Heights).

---

## Methodological Boundaries & Limitations

1. **Fulfilled vs. Unfulfilled Demand:** Public TLC trip records only document fulfilled, dispatched trips. Platform cancellations, rider walkaways, and unfulfilled trip requests during peak shortage periods are not observable.
2. **Surge Multiplier Not Available:** The public TLC data does not record quote-level surge multipliers or dynamic price increments. Base passenger fare per mile serves as an aggregate price-level proxy, but cannot support causal claims about surge elasticities.
3. **Driver Supply & Universal Wait Times:** Driver app status (online, idle, cruising) is not published. Arrival times (`on_scene_datetime`) are collected exclusively for wheelchair-accessible vehicle (WAV) trips and cannot be generalized to standard trips.
