library(dplyr)
library(ggplot2)
library(here)
library(readr)
library(statebins)
library(tidyr)
library(viridis)

dog_moves <- read_csv(here("data-raw", "dog_moves.csv"), show_col_types = FALSE)

dog_moves_ <- dog_moves %>%
  replace_na(list(exported = 0, imported = 0))

dog_moves %>%
  ggplot(aes(state = location, fill = (exported - imported)/total)) +
  geom_statebins() +
  scale_fill_viridis(
    option = "magma", direction = -1
  ) +
  theme_statebins() +
  coord_equal()

ggsave(filename = here("plots", "dog-moves.png"))
