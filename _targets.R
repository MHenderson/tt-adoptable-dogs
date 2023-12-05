# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("dplyr", "ggplot2", "historydata", "patchwork", "readr", "statebins", "tibble", "tidyr", "usa", "viridis") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  #
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multicore")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
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
    name = most_popular_breeds_plot,
    command = plot_most_popular_breeds(breed_counts_by_state)
  ),
  tar_target(
    name = save_dog_moves_plot,
    command = ggsave(plot = dog_moves_plot, filename = "img/dog-moves-plot.png", bg = "white", width = 4000, height = 2000, units = "px"),
    format = "file"
  ),
  tar_target(
    name = save_top_names_plot,
    command = ggsave(plot = top_names_plot, filename = "img/top-names-plot.png", bg = "white", width = 4000, height = 5000, units = "px"),
    format = "file"
  ),
  tar_target(
    name = save_most_popular_breeds_plot,
    command = ggsave(plot = most_popular_breeds_plot, filename = "img/most-popular-breeds-plot.png", bg = "white", width = 6000, height = 3000, units = "px"),
    format = "file"
  )
)
