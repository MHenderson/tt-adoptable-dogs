library(dplyr)
library(ggplot2)
library(here)
library(historydata)
library(ragg)
library(readr)
library(usa) # remotes::install_github("kiernann/usa")
library(viridis)

dog_descriptions <- read_csv(here("data-raw", "dog_descriptions.csv"), show_col_types = FALSE)

state_pops <- us_state_populations %>%
  filter(year == 2010) %>%
  mutate(
    contact_state = state_convert(state, to = "abb")
  ) %>%
  select(contact_state, population)

X <- dog_descriptions %>%
  filter(contact_state %in% state.abb) %>%
  group_by(contact_state, breed_primary) %>%
  count(breed_primary)

X <- left_join(X, state_pops) %>%
  mutate(
    n_frac = 1000000*n/population
  )

agg_png(here("plots", "most-popular-breeds.png"), res = 320, height = 10, width = 26, units = "in")

p <- X %>%
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

print(p)

dev.off()
