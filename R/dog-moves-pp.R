dog_moves_pp <- function(X) {
  X |>
    filter(inUS) |>
    filter(location!="Washington DC") |>
    replace_na(list(exported = 0, imported = 0)) |>
    mutate(
      x = (exported - imported)/total
    )
}
