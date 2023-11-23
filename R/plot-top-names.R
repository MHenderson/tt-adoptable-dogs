plot_top_names <- function(X) {

  f1 <- "Roboto Condensed"
  f2 <- "Cardo"

  X |>
    ggplot(aes(reorder(name, n), n)) +
    geom_text(aes(label = name), family = f2, size = 5, fontface = "bold", alpha = .9) +
    coord_flip() +
    ylim(50, 300) +
    scale_color_brewer(type = "qual") +
    labs(
             y = "Number of dogs",
             x = "",
         title = NULL,
      subtitle = NULL,
       caption = "Data: Collected from the PetFinder API on September 20, 2019 by Amber Thomas\nGraphic: Matthew Henderson\nCode: https://github.com/MHenderson/adoptable-dogs"
    ) +
    theme_minimal() +
    theme(
            axis.title.x = element_text(hjust = 1, margin = margin(10, 0, 0, 0), family = f1),
             axis.text.y = element_blank(),
      panel.grid.major.y = element_blank(),
         legend.position = "none",
            plot.caption = element_text(size = 10, family = f1, hjust = 0, margin = margin(20, 0, 0, 0))
    ) +
    annotate(geom = "text", x = 60, y = 125, label = "One Hundred\nMost Popular\nDog Names", size = 18, hjust = 0, family = f1, fontface = "bold")

}
