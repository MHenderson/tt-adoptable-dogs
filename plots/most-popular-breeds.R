library(dplyr)
library(ggplot2)
library(here)
library(ragg)
library(readr)

dog_descriptions <- read_csv(here("data-raw", "dog_descriptions.csv"), show_col_types = FALSE)

X <- dog_descriptions %>%
  filter(contact_state %in% state.abb) %>%
  mutate(
    breed = case_when(
      breed_mixed & !is.na(breed_secondary) ~ paste0(breed_primary, " x ", breed_secondary),
      TRUE ~ breed_primary
    )
  ) %>%
  group_by(contact_state, breed) %>%
  count(breed) %>%
  ungroup() %>%
  group_by(contact_state) %>%
  slice_max(n, n = 5) %>%
  ungroup() %>%
  arrange(contact_state, n) %>%
  mutate(order = row_number())

agg_png(here("plots", "most-popular-breeds.png"), height = 2000, width = 4000, units = "px")

p <- X %>%
  ggplot(aes(x = order, y = n)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~contact_state, scales = "free", ncol = 8) +
  scale_x_continuous(
    breaks = X$order,
    labels = X$breed,
    expand = c(0,0)
  ) +
  coord_flip() +
  theme_minimal()

print(p)

dev.off()
