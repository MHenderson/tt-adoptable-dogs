library(dplyr)
library(ggplot2)
library(here)
library(readr)

dog_descriptions <- read_csv(here("data-raw", "dog_descriptions.csv"), show_col_types = FALSE)

top_fifty_names <- dog_descriptions %>%
  mutate(
    name = tolower(name)
  ) %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(50)

top_fifty_names %>%
  ggplot(aes(reorder(name, n), n)) +
  geom_text(aes(label = name)) +
  coord_flip() +
  labs(
    x = "",
    y = ""
  ) +
  ylim(50, 300) +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank()
  )

ggsave(filename = here("plots", "most-popular-names.png"))
