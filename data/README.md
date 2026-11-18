# Dataset documentation

## Source
**2024 High Volume FHV Trip Data**, NYC Taxi and Limousine Commission (TLC), NYC Open Data.

- Dataset: https://data.cityofnewyork.us/Transportation/2024-High-Volume-FHV-Trip-Data/bqxa-629f
- Public API: https://data.cityofnewyork.us/resource/bqxa-629f.json
- TLC data portal: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Data dictionary: https://home4.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf

## Access plan
The R Markdown notebook uses the public Socrata JSON API without credentials. It queries January 1–8, 2024, selects only necessary fields and uses pages of 50,000 records with a safety ceiling of 5 million records; the notebook flags the extraction if that ceiling is reached. It records the query, extraction timestamp, returned row count and data-quality results. Raw data is downloaded at runtime and is not committed to Git.

## Relevant fields
| Field | Meaning | Use |
|---|---|---|
| hvfhs_license_num | High-volume service license | Provider grouping |
| request_datetime | Passenger request timestamp | Demand time |
| on_scene_datetime | Driver arrival; accessible-vehicle-only | Restricted arrival-time analysis |
| pickup_datetime | Trip pickup timestamp | Realized pickup activity |
| dropoff_datetime | Trip drop-off timestamp | Trip completion |
| PULocationID | Pickup TLC taxi zone | Spatial aggregation |
| DOLocationID | Drop-off TLC taxi zone | Destination analysis |
| trip_miles | Trip distance | Descriptive profile |
| base_passenger_fare | Base passenger fare | Fare profile |
| driver_pay | Driver pay | Driver-economics proxy |

## Limitations
A row is a dispatched trip record, not an unfulfilled ride request. There is no general surge multiplier, full online/idle driver supply, pre-dispatch cancellations or universal rider wait-time field. `on_scene_datetime` is documented for accessible-vehicle trips only. Therefore the notebook does not claim to estimate causal surge effects or citywide wait times.

TLC notes that records are submitted by bases and may not be complete or perfectly accurate. Results describe submitted records, not every ride-hailing event.
