# install.packages('devtools')
# install.packages("RCurl")

# library(devtools)
# install_github("luiscape/freegeoip")

library(rjson)
library(RCurl)
library(ggplot2)
library("colorspace")

library(dplyr)

library(maps)
library(mapdata)

ips<-read.table("ips.txt")

ips_to_plot<-freegeoip::freegeoip(ips)

#ips_to_plot$col_by_country <- factor(ips_to_plot$country_name)
#ip_list<-ips_to_plot
# ips_to_plot<-arrange(ips_to_plot, tolower(longitude),country_name )

world_data <- map_data("worldHires")

# Plot global distribution of IP addresses, coloured by country_name
p <- ggplot(ips_to_plot, aes(ips_to_plot$longitude, ips_to_plot$latitude))
p <- p + scale_y_continuous(limits=c(-90,90), expand=c(0,0))
p <- p + scale_x_continuous(expand=c(0,0))
p <- p + theme(axis.ticks=element_blank(), axis.title=element_blank(),
      axis.text=element_blank(), panel.grid = element_blank())
p <- p + geom_polygon(data=world_data, mapping=aes(x=long, y=lat, group=group), fill='grey')
p <- p + geom_point(aes(colour=country_name, stroke = 0), alpha=7/10, size = 4)
p <- p + coord_fixed()
p <- p + ggsave("ip_plot_world_large.pdf", width = 20, height = 10)

# Plot the same thing, but use smaller points to allow close-up of Europe

world_data <- map_data("worldHires")

p <- ggplot(ips_to_plot, aes(ips_to_plot$longitude, ips_to_plot$latitude))
p <- p + scale_y_continuous(limits=c(-90,90), expand=c(0,0))
p <- p + scale_x_continuous(expand=c(0,0))
p <- p + theme(axis.ticks=element_blank(), axis.title=element_blank(),
      axis.text=element_blank(), panel.grid = element_blank())
p <- p + geom_polygon(data=world_data, mapping=aes(x=long, y=lat, group=group), fill='grey')
p <- p + borders("world", colour = "white", size = 0.025)
p <- p + geom_point(aes(colour=country_name, stroke = 0), alpha=7/10, size = 1)
p <- p + coord_fixed()
p <- p + ggsave("ip_plot_world_small.pdf", width = 20, height = 10)


UK_data <- map_data('worldHires',
		c('UK', 'Ireland', 'Isle of Man','Isle of Wight'),
		xlim=c(-11,2), ylim=c(49,60.9))


# Plot for UK only

just_UK<-filter(ips_to_plot, country_code != "IE")

p <- ggplot(just_UK, aes(just_UK$longitude, just_UK$latitude))
p <- p + scale_y_continuous(limits=c(49,60.9), expand=c(0,0))
p <- p + scale_x_continuous(limits=c(-11,2), expand=c(0,0))
p <- p + theme(axis.ticks=element_blank(), axis.title=element_blank(),
      axis.text=element_blank(), legend.position="none", panel.grid = element_blank())
p <- p + geom_polygon(data=UK_data, mapping=aes(x=long, y=lat, group=group), fill='grey')
p <- p + geom_point(aes(colour=city, stroke = 0), size = 4, colour = "darkorange2", alpha=7/10 )
p <- p + coord_fixed()
p <- p + ggsave("ip_plot_UK.pdf", width = 20, height = 10)
p
