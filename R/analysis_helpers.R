# Reusable helper functions for the project

clean_hvfhv <- function(data) {
  stopifnot(all(c("request_datetime", "PULocationID", "hvfhs_license_num") %in% names(data)))
  data |>
    dplyr::mutate(
      request_datetime = lubridate::ymd_hms(request_datetime, quiet = TRUE, tz = "America/New_York"),
      pickup_zone = as.integer(PULocationID),
      provider = as.character(hvfhs_license_num),
      trip_miles = suppressWarnings(as.numeric(trip_miles)),
      base_passenger_fare = suppressWarnings(as.numeric(base_passenger_fare)),
      driver_pay = suppressWarnings(as.numeric(driver_pay))
    ) |>
    dplyr::filter(!is.na(request_datetime), !is.na(pickup_zone), pickup_zone > 0)
}

make_hourly_zone_panel <- function(data) {
  hourly <- data |>
    dplyr::mutate(hour = lubridate::floor_date(request_datetime, "hour")) |>
    dplyr::count(pickup_zone, hour, name = "trips")
  zones <- sort(unique(hourly$pickup_zone))
  hours <- seq(min(hourly$hour), max(hourly$hour), by = "hour")
  tidyr::expand_grid(pickup_zone = zones, hour = hours) |>
    dplyr::left_join(hourly, by = c("pickup_zone", "hour")) |>
    dplyr::mutate(trips = tidyr::replace_na(trips, 0L)) |>
    dplyr::arrange(pickup_zone, hour) |>
    dplyr::group_by(pickup_zone) |>
    dplyr::mutate(
      hour_of_day = lubridate::hour(hour),
      weekday = factor(lubridate::wday(hour, label = TRUE, week_start = 1)),
      weekend = lubridate::wday(hour, week_start = 1) >= 6,
      lag_1 = dplyr::lag(trips, 1),
      lag_24 = dplyr::lag(trips, 24),
      rolling_24 = dplyr::lag(slider::slide_dbl(trips, mean, .before = 23, .complete = TRUE), 1)
    ) |>
    dplyr::ungroup() |>
    dplyr::filter(!is.na(lag_24), !is.na(rolling_24))
}

score_forecast <- function(actual, predicted) {
  tibble::tibble(
    MAE = mean(abs(actual - predicted), na.rm = TRUE),
    RMSE = sqrt(mean((actual - predicted)^2, na.rm = TRUE)),
    WAPE = sum(abs(actual - predicted), na.rm = TRUE) /
      max(sum(actual, na.rm = TRUE), .Machine$double.eps)
  )
}
