library(targets)

tar_option_set(
  packages = c("dplyr", "ggplot2", "historydata", "patchwork", "readr", "statebins", "tibble", "tidyr", "usa", "viridis")
)

tar_source()

list(
  tar_target(
       name = dog_moves,
    command = read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_moves.csv')
  ),
  tar_target(
       name = dog_travel,
    command = read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_travel.csv')
  ),
  tar_target(
       name = dog_descriptions,
    command = read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_descriptions.csv')
  ),
  tar_target(
       name = state_pops,
    command = us_state_populations |>
      filter(year == 2010) |>
      mutate(
        contact_state = state_convert(state, to = "abb")
      ) |>
      select(contact_state, population)
  ),
  tar_target(
       name = breed_counts_by_state,
    command = dog_descriptions |>
      filter(contact_state %in% state.abb) |>
      group_by(contact_state, breed_primary) |>
      count(breed_primary) |>
      left_join(state_pops) |>
      mutate(
        n_frac = 1000000*n/population
      )
  ),
  tar_target(
       name = pp_dog_moves,
    command = dog_moves_pp(dog_moves)
  ),
  tar_target(
       name = top_names_df,
    command = top_names(dog_descriptions)
  ),
  tar_target(
       name = dogs_imported_plot,
    command = plot_dogs_imported(pp_dog_moves)
  ),
  tar_target(
       name = dogs_exported_plot,
    command = plot_dogs_exported(pp_dog_moves)
  ),
  tar_target(
       name = dog_moves_plot,
    command = plot_dog_moves(dogs_imported_plot, dogs_exported_plot)
  ),
  tar_target(
       name = top_names_plot,
    command = plot_top_names(top_names_df)
  ),
  tar_target(
       name = save_dog_moves_plot,
     format = "file",
    command = ggsave(
          plot = dog_moves_plot,
      filename = "plot/dog-moves-plot.png",
            bg = "white",
         width = 4000,
        height = 2000,
         units = "px"
    ) 
  ),
  tar_target(
       name = save_top_names_plot,
     format = "file",
    command = ggsave(
          plot = top_names_plot,
      filename = "plot/top-names-plot.png",
            bg = "white",
         width = 4000,
        height = 5000,
         units = "px"
    )
  )
)
