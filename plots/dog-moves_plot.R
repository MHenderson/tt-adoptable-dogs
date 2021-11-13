library(dplyr)
library(ggplot2)
library(here)
library(patchwork)
library(readr)
library(statebins)
library(tidyr)
library(viridis)

dog_moves <- read_csv(here("data-raw", "dog_moves.csv"), show_col_types = FALSE)

dog_moves_ <- dog_moves %>%
  filter(inUS) %>%
  filter(location!="Washington DC") %>%
  replace_na(list(exported = 0, imported = 0)) %>%
  mutate(
    x = (exported - imported)/total
  )

dogs_imported <- dog_moves_ %>%
  rename(value = imported) %>%
  ggplot(aes(state = location, fill = value))+
  geom_statebins() +
  scale_fill_viridis(
    option = "magma", direction = -1
  ) +
  theme_statebins() +
  coord_equal() +
  labs(
    title = "imported"
  )

dogs_exported <- dog_moves_ %>%
  rename(value = exported) %>%
  ggplot(aes(state = location, fill = value))+
  geom_statebins() +
  scale_fill_viridis(
    option = "magma", direction = -1
  ) +
  theme_statebins() +
  coord_equal() +
  labs(
    title = "exported"
  )

dogs_imported + dogs_exported +
  plot_layout(guides = "collect") &
  scale_fill_viridis(option = "magma", direction = -1, limits = range(c(0, 1000))) &
  theme(legend.position = "bottom")

ggsave(filename = here("plots", "dog-moves.png"))
