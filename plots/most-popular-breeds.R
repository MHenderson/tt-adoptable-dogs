library(dplyr)
library(ggplot2)
library(here)
library(ragg)
library(readr)

dog_descriptions <- read_csv(here("data-raw", "dog_descriptions.csv"), show_col_types = FALSE)

X <- dog_descriptions %>%
  filter(contact_state %in% state.abb) %>%
  group_by(contact_state, breed_primary) %>%
  count(breed_primary)

agg_png(here("plots", "most-popular-breeds.png"), res = 320, height = 10, width = 26, units = "in")

p <- X %>%
  ggplot(aes(breed_primary, contact_state)) +
  geom_raster(aes(fill = n), hjust = 1) +
  scale_y_discrete(limits = rev) +
  theme_minimal() +
  theme(
    legend.position = "top",
    axis.text.x = element_text(angle = 90, hjust = 1)
  ) +
  scale_fill_viridis() +
  labs(x = "", y = "")

print(p)

dev.off()
