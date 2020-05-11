#this chart will create a graph that shows All Adults(15+) upper estimate deaths from UNAIDS data

library(tidyverse)
library(scales)
library(janitor)

#get the file 
#original file is here: http://data.un.org/Handlers/DownloadHandler.ashx?DataFilter=inID:33&DataMartId=UNAIDS&Format=csv&c=1,2,3,4,5,6&s=crEngName:asc,sgvEngName:asc,timeEngName:desc
df <- read.csv("https://raw.githubusercontent.com/calvindw/datasets/a7b87f0211dd62944f0717792f795aeb28bdc5df/UNdata_Export_20200422_172837186.csv")

#clean column names with janitor
df <- df %>% clean_names 

#prevent the academic notation
options(scipen = 999)

#filter adults (15+) variables and "all countries"
df_x <- df  %>% 
  filter(str_detect(country_or_area, "UNAIDS")) %>% 
  filter(year %in% 2014) %>% 
  filter(!str_detect(subgroup,"upper| lower")) %>% 
  filter(str_detect(subgroup,"Children|Females|Males")) 

#change the strings into factors
df_x <- df_x %>% mutate_at(vars(country_or_area,subgroup), funs(as_factor))

#reorder factors
df_x$subgroup <- fct_relevel(df_x$subgroup,"Children (0-14) estimate", 
                             "Females Adults (15+) estimate", 
                             "Males Adults (15+) estimate")

#visualize
v <- df_x %>% 
  ggplot(.) +
  aes(x=country_or_area, y=value,fill=subgroup)+
  geom_bar(width= 0.5, stat="identity", position = position_dodge(width=0.9))+ 
  labs(title="AIDS Related Deaths across regions",
       subtitle="Year 2014\n",
       caption = "Source: UNAIDS")+
  theme_minimal()+
  ylab("Deaths\n")+
  xlab("Year\n")+
  theme(plot.title = element_text(size = 30, face = "bold",
                                  colour = "black", vjust = 0),
        plot.subtitle = element_text(size = 15, face = "italic",
                                     colour = "black", vjust = 0),
        plot.caption = element_text(size = 12),
        strip.text.x = element_text(size = 15),
        strip.text.y = element_text(size = 15),
        axis.text = element_text(size = 15),
        axis.title = element_text(size = 18, face = "bold"),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 18),
        panel.spacing = unit(4, "lines"))+
  scale_x_discrete(labels = wrap_format(10))





#save it
ggsave(plot=v, filename="plt.png",height = 30, width = 60, units="cm", limitsize = FALSE)