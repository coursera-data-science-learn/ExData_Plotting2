# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 3==========
# Of the four types of sources indicated by the type (point, nonpoint,
# onroad, nonroad) variable, which of these four sources have seen
# decreases in emissions from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.

# ========Answer 3============
# Increases:
#  - Point
# Decreases:
#  - Non-Road
#  - On-Road
#  - Non-Point

# load packages
library(ggplot2)

# subset data for Baltimore City
total_pm25_bal <- nei[nei$fips == "24510",]

# group emissions by year and type
total_pm25_bal <- aggregate(list(Emissions = total_pm25_bal$Emissions), 
                                  by = c(total_pm25_bal["year"], total_pm25_bal["type"]),
                                  FUN = sum)

# making plot 3
png(filename = "plot3.png", width = 480, height = 480)
ggplot(total_pm25_bal, aes(factor(year), Emissions, fill = type)) + 
    geom_bar(stat="identity", position = "dodge") + 
    scale_fill_brewer(palette = "Set1")+
    labs(title = "Total PM2.5 emissions in the Baltimore City \n by emissions source type",
         x = "Year", y = "PM2.5 emissions, tons", fill ='Source type') +
    theme(plot.title = element_text(hjust=0.5)) +
    geom_text(aes(label=round(Emissions,1)), position=position_dodge(width=0.9),
         vjust=-0.5, size = 3) # check_overlap = TRUE
dev.off()

# clear global environment
rm(list = ls())