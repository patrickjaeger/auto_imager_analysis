# TODO filter values after tears

library(tidyverse)


path <- "data/ADi-130_distances.csv"
path <- c("data/bn-1_distances.csv", "data/bn-1_distances_2.csv")


distances <- read_csv(path) %>%
  mutate(day = str_replace(day, "day\\d{1}_", paste0("day0", day, "_"))) %>% 
  mutate(nday = parse_number(day)) 

# Calculate forces
post_forces <- distances %>% 
  group_nest(experiment, chamber, post) %>%
  mutate(initial_distance = map_dbl(data, ~filter(., nday == min(nday)) %>% 
      pluck('distance_um', 1))) %>%
  unnest(data) %>%
  mutate(force = (initial_distance - distance_um)*k) %>% 
  select(-initial_distance)

donor_forces <- post_forces %>% 
  group_by(experiment, chamber, donor, k, condition, nday) %>% 
  summarise(force = mean(force),
            distance = mean(distance_um)) %>% 
  ungroup()

wide_post_forces <- post_forces %>% 
  pivot_wider(id_cols = nday, 
              names_from = c(chamber, post), 
              values_from = force) %>% 
  rename(day = "nday")

wide_donor_forces <- donor_forces %>% 
  pivot_wider(id_cols = nday, 
              names_from = c(donor, chamber), 
              values_from = force) %>% 
  rename(day = "nday")


# Export forces as CSV
experiment <- basename(path) %>% str_split_1(., pattern = "_") %>% pluck(1)
if (!dir.exists("results")) dir.create("results")
write_csv(wide_post_forces, file = paste0("results/", experiment, "_post_forces.csv"))
write_csv(wide_donor_forces, file = paste0("results/", experiment, "_donor_forces.csv"))


# Plot
## Plot force per post
ggplot(post_forces, aes(nday, force, group = interaction(post, donor), color = condition)) +
  geom_point() +
  geom_line(aes(group = interaction(donor, post, chamber)))

## Plot force per donor
ggplot(donor_forces, aes(nday, force, group = donor, color = condition)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = 3) +
  geom_line(aes(group = interaction(donor, chamber))) +
  facet_grid(donor~condition) +
  theme_bw() +
  theme(axis.text = element_text(size = 7)) +
  scale_x_continuous(breaks = unique(donor_forces$nday)) +
  labs(x = "Day [n]", y = "Tension [uN]")


## Plot force per condition
ggplot(donor_forces, aes(nday, force, group = condition, color = condition)) +
  stat_summary(geom = "point") +
  stat_summary(geom = "line") +
  scale_x_continuous(breaks = unique(donor_forces$nday)) +
  scale_y_continuous(breaks = seq(-100, 300, 50))


## Plot contraction per condition
ggplot(donor_forces, aes(nday, distance, group = condition, color = condition)) +
  stat_summary(geom = "point") +
  stat_summary(geom = "line") +
  scale_x_continuous(breaks = unique(donor_forces$nday)) 

