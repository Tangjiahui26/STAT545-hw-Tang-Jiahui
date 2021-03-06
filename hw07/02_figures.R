library(purrr)
library(tidyverse)
library(forcats)
knitr::opts_chunk$set(fig.width=13, fig.height=10)

country_codes = readRDS("01_dataframe.tsv")
gapminder <- read.delim("gap-every-five-years.tsv")
ios_codes <- read.delim("iso-codes.tsv")

#Save a couple descriptive plots to file with highly informative names
#Get the maximum and minimum of GDP per capita for all continents.
#make figures and distinguished the max/min GdpPercap and others in differnet colors.

T1 <- country_codes %>% 
    group_by(continent) %>% 
    summarise(Max_GdpPercap = max(gdpPercap), Min_GdpPercap = min(gdpPercap))
              
P1 <- country_codes %>% 
    ggplot(aes(x = year, y = gdpPercap))+
    facet_wrap(~ continent) +
    geom_point(aes(color = (gdpPercap %in% c(T1$Max_GdpPercap, T1$Min_GdpPercap))), size = 5, alpha = 0.5) +
    theme_bw() +
    theme(strip.background = element_rect(fill="orange"),
          axis.title.x = element_text(size=15),
          axis.title.y = element_text(size=15),
          strip.text = element_text(size=18, face="bold",hjust=0.5))+
    labs(title="GdpPercap for all continents")+
    scale_colour_discrete("Max_GdpPercap/Min_GdpPercap")
#print(P1)   
ggsave("./figures/GdpPercap for all continents.png",P1,device = "png", width = 10, 
       height = 7,dpi = 500)

#The spread of GDP per capita within the continents

P2 <- country_codes %>%
    select(gdpPercap, continent) %>% 
    ggplot(aes(x = gdpPercap, color = continent))+
    geom_histogram() +
    facet_wrap(~ continent, scales = "free_y") +
    theme_bw() +
    theme(strip.background = element_rect(fill="orange"),
          axis.title.x = element_text(size=15),
          axis.title.y = element_text(size=15),
          strip.text = element_text(size=18, face="bold"))+
    labs(title="GdpPercap histogram for each continent")
 
ggsave("./figures/GdpPercap histogram for each continent.png",P2,device = "png", width = 10, 
       height = 7,dpi = 500)

#Plot mean of life expectancy for different years

T2 <- country_codes %>% 
    group_by(year) %>% 
    summarise(mean_LifeExp = mean(lifeExp), 
              weighted_by_pop = weighted.mean(lifeExp, pop),
              weighted_by_gdpPercap = weighted.mean(lifeExp, gdpPercap))

P3 <- ggplot(T2, aes(x = year, y = LifeExp)) +
    geom_line(aes(y = mean_LifeExp, color = "mean_LifeExp")) +
    geom_line(aes(y = weighted_by_pop, color = "weighted_by_pop")) +
    geom_line(aes(y = weighted_by_gdpPercap, color = "weighted_by_gdpPercap")) +
    labs(title = "Means of Life Expectancy for different years")

ggsave("./figures/Means of Life Expectancy for different years.png",P3,device = "png", width = 10, 
       height = 7,dpi = 500)

#Make a plot of GDP for countries' iso_code between 120 and 170

P4 <- country_codes %>% 
    filter(iso_num >120 & iso_num <170) %>% 
    ggplot(aes(x = year, y = (gdpPercap*pop)))+
    facet_wrap(~ country , scales = "free_y") +
    geom_point(aes(color = country, size = 2)) +
    theme_bw() +
    theme(strip.background = element_rect(fill="grey"),
    axis.title.x = element_text(size=15),
    axis.title.y = element_text(size=15),
    strip.text = element_text(size=10, face="bold",hjust=0.5))+
    labs(title="GDP for countries' iso_code between 120 and 170")+
    scale_y_continuous("GDP")   

ggsave("./figures/GDP for some countries or areas.png",P4,device = "png", width = 10, 
       height = 7,dpi = 500)


country_codes %>% 
    saveRDS("02_figures.tsv")
