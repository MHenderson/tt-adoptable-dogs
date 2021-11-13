library(dplyr)
library(ggplot2)
library(here)
library(readr)

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
  ungroup()

top_fifty_names <- top_fifty_names %>%
  mutate(
    syllables = as.numeric(count_vector(top_fifty_names$name))
  )

top_fifty_names %>%
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
    panel.grid.major.y = element_blank()
  ) +
  annotate(geom = "text", x = 50, y = 130, label = "One Hundred\nMost Popular\nDog Names", size = 15, hjust = 0, family = f1)

ggsave(filename = here("plots", "most-popular-names.png"), height = 4000, width = 2000, units = "px", bg = "white")
