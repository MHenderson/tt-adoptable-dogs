plot_most_popular_breeds <- function(X) {
  X |>
    ggplot(aes(breed_primary, contact_state)) +
    geom_raster(aes(fill = n_frac), hjust = 1) +
    scale_x_discrete(position = "top") +
    scale_y_discrete(limits = rev) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      axis.text.x = element_text(angle = 70, hjust = 0)
    ) +
    scale_fill_viridis() +
    labs(x = "", y = "")
}
