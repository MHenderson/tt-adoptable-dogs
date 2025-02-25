library(targets)

tar_option_set(
  packages = c("dplyr", "ggplot2", "historydata", "patchwork", "readr", "statebins", "tibble", "tidyr", "usa", "viridis")
)

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
    command = dog_moves |>
      filter(inUS) |>
      filter(location!="Washington DC") |>
      replace_na(list(exported = 0, imported = 0)) |>
      mutate(
        x = (exported - imported)/total
      )
  ),
  tar_target(
       name = top_names_df,
    command = dog_descriptions |>
      mutate(
        name = tolower(name)
      ) |>
      group_by(name) |>
      count() |>
      arrange(desc(n)) |>
      head(50) |>
      ungroup()
  ),
  tar_target(
       name = dogs_imported_plot,
    command = pp_dog_moves |>
      rename(value = imported) |>
      ggplot(aes(state = location, fill = value)) +
	geom_statebins() +
	theme_statebins() +
	coord_equal() +
	labs(
	     title = "imported dogs",
	  subtitle = "The number of adoptable dogs available in this state that originated\nin a different location."
	) +
	theme(
	     plot.title = element_text(size = 20, family = "Roboto Condensed", hjust = 0),
	  plot.subtitle = element_text(size = 12, family = "Roboto Condensed", hjust = 0)
	)
  ),
  tar_target(
       name = dogs_exported_plot,
    command = pp_dog_moves |>
      rename(value = exported) |>
      ggplot(aes(state = location, fill = value)) +
	geom_statebins() +
	theme_statebins() +
	coord_equal() +
	labs(
             title = "exported dogs",
          subtitle = "The number of adoptable dogs available in the US that originated\nin this location but were available for adoption in another location."
	) +
	theme(
             plot.title = element_text(size = 20, family = "Roboto Condensed", hjust = 0),
          plot.subtitle = element_text(size = 12, family = "Roboto Condensed", hjust = 0)
	)
  ),
  tar_target(
       name = dog_moves_plot,
    command = dogs_imported_plot + dogs_exported_plot +
      plot_layout(guides = "collect") &
      scale_fill_viridis(option = "magma", direction = -1, limits = range(c(0, 1000))) &
      plot_annotation(
           title = "Dog Moves",
        subtitle = "Data collected from the PetFinder API for all adoptable dogs\nin each state on September 20, 2019.",
         caption = "Data: Collected from the PetFinder API by Amber Thomas | Graphic: Matthew Henderson | Code: https://github.com/MHenderson/adoptable-dogs",
           theme = theme(
             plot.title = element_text(size = 34, family = "Roboto Condenses", hjust = 0.5, face = "bold", margin = margin(15, 0, 0, 0)),
             plot.subtitle = element_text(size = 14, family = "Roboto Condensed", hjust = 0.5, margin = margin(15, 0, 0, 0)),
             plot.caption = element_text(size = 10, family = "Roboto Condensed", hjust = 0.5, margin = margin(20, 0, 0, 0))
	  )
      ) &
      theme(
	  legend.position = "right",
	     legend.title = element_blank(),
	 legend.key.width = unit(1, "line"),
	legend.key.height = unit(1.5, "line"),
              legend.text = element_text(family = "Roboto Condensed"),
	  plot.background = element_rect(fill = "#FFFDF4", color = NA)
      )
  ),
  tar_target(
       name = top_names_plot,
    command = top_names_df |>
      ggplot(aes(reorder(name, n), n)) +
	geom_text(aes(label = name), family = "Roboto Condensed", size = 5, fontface = "bold", alpha = .9) +
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
		axis.title.x = element_text(hjust = 1, margin = margin(10, 0, 0, 0), family = "Roboto Condensed"),
		 axis.text.y = element_blank(),
	  panel.grid.major.y = element_blank(),
	     legend.position = "none",
		plot.caption = element_text(size = 10, family = "Roboto Condensed", hjust = 0, margin = margin(20, 0, 0, 0))
	) +
	annotate(geom = "text", x = 60, y = 125, label = "One Hundred\nMost Popular\nDog Names", size = 18, hjust = 0, family = "Roboto Condensed", fontface = "bold")
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
