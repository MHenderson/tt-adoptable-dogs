plot_dogs_imported <- function(X) {

  f1 <- "Roboto Condensed"
  f2 <- "Roboto Condensed"

  X |>
    rename(value = imported) |>
    ggplot(aes(state = location, fill = value)) +
    geom_statebins() +
    theme_statebins() +
    coord_equal() +
    labs(
      title = "imported dogs",
      subtitle = "The number of adoptable dogs available in this state that originated\nin a different location."
    ) +
    theme(
      plot.title = element_text(size = 20, family = f1, hjust = 0),
      plot.subtitle = element_text(size = 12, family = f2, hjust = 0)
    )
}
