library(dplyr)
library(ggplot2)
library(here)
library(ragg)
library(readr)
library(RColorBrewer)
library(syllable)

f1 <- "Roboto Condensed"
f2 <- "Cardo"

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
  geom_text(aes(label = name, colour = as.factor(syllables)), family = f2, size = 5, fontface = "bold", alpha = .9) +
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

print(p)

dev.off()
