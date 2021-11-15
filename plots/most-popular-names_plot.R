library(dplyr)
library(ggplot2)
library(here)
library(ragg)
library(readr)
library(syllable)

f1 <- "Roboto Condensed"

dog_descriptions <- read_csv(here("data-raw", "dog_descriptions.csv"), show_col_types = FALSE)

top_fifty_names <- dog_descriptions %>%
  mutate(
    name = tolower(name)
  ) %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(100) %>%
  ungroup() %>%
  mutate(
    syllables = as.numeric(count_vector(name))
  )

agg_png(here("plots", "most-popular-names.png"), res = 320, height = 14, width = 7.43, units = "in")

p <- top_fifty_names %>%
  ggplot(aes(reorder(name, n), n)) +
  geom_text(aes(label = name, colour = as.factor(syllables)), family = f1) +
  coord_flip() +
  labs(
    y = "Number of dogs with name",
    x = ""
  ) +
  ylim(50, 300) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "none"
  ) +
  annotate(geom = "text", x = 50, y = 130, label = "One Hundred\nMost Popular\nDog Names", size = 15, hjust = 0, family = f1)

print(p)

dev.off()
