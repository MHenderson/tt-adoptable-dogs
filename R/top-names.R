top_names <- function(X, N = 50) {
  X |>
    mutate(
      name = tolower(name)
    ) |>
    group_by(name) %>%
    count() %>%
    arrange(desc(n)) %>%
    head(N) %>%
    ungroup()
}
