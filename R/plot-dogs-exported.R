plot_dogs_exported <- function(X) {

  f1 <- "Roboto Condensed"
  f2 <- "Roboto Condensed"

  X |>
    rename(value = exported) |>
    ggplot(aes(state = location, fill = value)) +
    geom_statebins() +
    theme_statebins() +
    coord_equal() +
    labs(
      title = "exported dogs",
      subtitle = "The number of adoptable dogs available in the US that originated\nin this location but were available for adoption in another location."
    ) +
    theme(
      plot.title = element_text(size = 20, family = f1, hjust = 0),
      plot.subtitle = element_text(size = 12, family = f2, hjust = 0)
    )
}
