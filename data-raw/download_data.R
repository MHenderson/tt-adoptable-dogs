library(here)

dog_moves <- download.file('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_moves.csv', destfile = here("data-raw", "dog_moves.csv"))
dog_travel <- download.file('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_travel.csv', destfile = here("data-raw", "dog_travel.csv"))
dog_descriptions <- download.file('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_descriptions.csv', destfile = here("data-raw", "dog_descriptions.csv"))
