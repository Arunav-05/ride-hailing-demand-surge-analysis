# Reusable helper functions for NYC Ride-Hailing Demand & Surge Pricing Analysis

#' Fetch one day of aggregated HVFHV data from the NYC Open Data SODA API
#' @param day Date string or Date object (YYYY-MM-DD)
#' @param api_url SODA API endpoint URL
#' @param retries Number of retry attempts
#' @return A data.frame with hourly aggregated trip metrics
fetch_one_day <- function(day,
                          api_url = "https://data.cityofnewyork.us/resource/bqxa-629f.json",
                          retries = 3) {
  day <- as.Date(day)
  q <- list(
    `$select` = paste(
      "pulocationid,",
      "date_extract_hh(request_datetime) as hr,",
      "count(*) as trips,",
      "sum(trip_miles) as miles,",
      "sum(base_passenger_fare) as fare_sum"
    ),
    `$where`  = sprintf("request_datetime >= '%sT00:00:00' AND request_datetime < '%sT00:00:00'",
                        day, day + 1),
    `$group`  = "pulocationid, hr",
    `$limit`  = 50000
  )
  for (i in seq_len(retries)) {
    resp <- try(httr::GET(api_url, query = q, httr::timeout(180)), silent = TRUE)
    if (!inherits(resp, "try-error") && httr::status_code(resp) == 200) {
      out <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
      if (length(out) == 0) return(NULL)
      out$day <- day
      return(out)
    }
    Sys.sleep(3 * i)
  }
  stop("API request failed for ", day, ". Check network connectivity or API status.")
}

#' Root Mean Squared Error (RMSE)
rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2, na.rm = TRUE))
}

#' Mean Absolute Error (MAE)
mae <- function(actual, predicted) {
  mean(abs(actual - predicted), na.rm = TRUE)
}

#' Volume-Weighted Absolute Percentage Error (WAPE)
wape <- function(actual, predicted) {
  sum(abs(actual - predicted), na.rm = TRUE) / max(sum(actual, na.rm = TRUE), .Machine$double.eps)
}

#' Score forecast models using standard metrics
score_forecast <- function(actual, predicted) {
  tibble::tibble(
    RMSE = rmse(actual, predicted),
    MAE  = mae(actual, predicted),
    WAPE = wape(actual, predicted)
  )
}

#' Evaluate Top-K zone demand capture rate for driver positioning
#' @param data Test data.frame containing actual demand `y` and prediction column `pred_col`
#' @param pred_col Name of column containing model predictions
#' @param k Number of top zones recommended
#' @return Mean share of total demand captured across all test time periods
evaluate_positioning_rule <- function(data, pred_col, k = 10) {
  data %>%
    dplyr::group_by(target_ts) %>%
    dplyr::mutate(rk = rank(-.data[[pred_col]], ties.method = "first")) %>%
    dplyr::summarise(capture = sum(y[rk <= k], na.rm = TRUE) / sum(y, na.rm = TRUE), .groups = "drop") %>%
    dplyr::summarise(mean_capture = mean(capture, na.rm = TRUE)) %>%
    dplyr::pull(mean_capture)
}
