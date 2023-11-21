plot_dog_moves <- function(X) {

  f1 <- "Roboto Condensed"
  f2 <- "Roboto Condensed"

  dog_moves_ <- X |>
    filter(inUS) |>
    filter(location!="Washington DC") |>
    replace_na(list(exported = 0, imported = 0)) |>
    mutate(
      x = (exported - imported)/total
    )

  dogs_imported <- dog_moves_ |>
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

  dogs_exported <- dog_moves_ |>
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

  dogs_imported + dogs_exported +
    plot_layout(guides = "collect") &
    scale_fill_viridis(option = "magma", direction = -1, limits = range(c(0, 1000))) &
    plot_annotation(
      title = "Dog Moves",
      subtitle = "Data collected from the PetFinder API for all adoptable dogs\nin each state on September 20, 2019.",
      caption = "Data: Collected from the PetFinder API by Amber Thomas | Graphic: Matthew Henderson | Code: https://github.com/MHenderson/adoptable-dogs",
      theme = theme(
        plot.title = element_text(size = 34, family = f1, hjust = 0.5, face = "bold", margin = margin(15, 0, 0, 0)),
        plot.subtitle = element_text(size = 14, family = f2, hjust = 0.5, margin = margin(15, 0, 0, 0)),
        plot.caption = element_text(size = 10, family = f2, hjust = 0.5, margin = margin(20, 0, 0, 0))
      )
    ) &
    theme(
      legend.position = "right",
      legend.title = element_blank(),
      legend.key.width = unit(1, "line"),
      legend.key.height = unit(1.5, "line"),
      legend.text = element_text(family = f1),
      plot.background = element_rect(fill = "#FFFDF4", color = NA)
    )
}
