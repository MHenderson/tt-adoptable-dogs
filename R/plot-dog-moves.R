plot_dog_moves <- function(X, Y) {

  f1 <- "Roboto Condensed"
  f2 <- "Roboto Condensed"

  X + Y +
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
