# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 6==========
# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in Los Angeles County,
# California (fips=="06037"). Which city has seen greater changes
# over time in motor vehicle emissions?

# ========Answer 6============
# Los Angeles.

# load packages
library(ggplot2)
library(gridExtra)

# subset data for Baltimore City and Los Angeles
pm25_bal_la <- nei[nei$fips %in% c("24510","06037"), ]

# merge nei and scc
scc_merge <- scc[, c("SCC", "EI.Sector")]
nei_scc <- merge(pm25_bal_la, scc_merge, by = "SCC")

# subset only motor vehicle lines
# for the purposes of our analysis let's assume these are "Mobile"
# lines excluding "Aircraft", "Commercial Marine Vessels", and "Locomotives" 
match <- grepl(".*mobile.*", nei_scc$EI.Sector, ignore.case = TRUE) & 
    !grepl("(.*mobile.*)(.*aircraft.*|.*locomotives.*|.*commercial marine vessels.*)",
           nei_scc$EI.Sector, ignore.case = TRUE)
motor <- nei_scc[match, ]

# aggregate data by year
motor_pm25_bal_la <- aggregate(list(Emissions = motor$Emissions), 
                            by = c(motor["year"], motor["fips"]),
                            FUN = sum)

# calculate difference in emissions compared to base year 1999
# https://stackoverflow.com/questions/31719799/adding-a-base-year-index-to-r-dataframe-with-multiple-groups
motor_pm25_bal_la <- unsplit(lapply(split(motor_pm25_bal_la, motor_pm25_bal_la$fips), 
                                    function(x) transform(x, 
                                    Difference = Emissions - Emissions[year==1999])),
                             motor_pm25_bal_la$fips)

# add city name
motor_pm25_bal_la$city[motor_pm25_bal_la$fips == "24510"] <- "Baltimore"
motor_pm25_bal_la$city[motor_pm25_bal_la$fips == "06037"] <- "Los Angeles"

# making plot 5
png(filename = "plot6.png", width = 1200, height = 480)

bp1 <- ggplot(motor_pm25_bal_la, aes(factor(year), Emissions, fill = city)) + 
    geom_bar(stat="identity", position = "dodge") + 
    scale_fill_brewer(palette = "Set1")+
    labs(title = "Motor PM2.5 emissions in the Baltimore City \n and Los Angeles",
         x = "Year", y = "PM2.5 emissions, tons", fill ='City') +
    theme(plot.title = element_text(hjust=0.5)) +
    geom_text(aes(label=round(Emissions,1)), position=position_dodge(width=0.9),
              vjust=-0.5, size = 3)

bp2 <- ggplot(motor_pm25_bal_la[motor_pm25_bal_la$year != "1999", ], aes(factor(year), Difference, fill = city)) + 
    geom_bar(stat="identity", position = "dodge") + 
    scale_fill_brewer(palette = "Set1")+
    labs(title = "Motor PM2.5 emissions in the Baltimore City \n and Los Angeles",
         x = "Year", y = "Cumulative change in PM2.5 emissions compared to 1999, tons",
         fill ='City') +
    theme(plot.title = element_text(hjust=0.5)) +
    geom_text(aes(label=round(Difference,1)), position=position_dodge(width=0.9),
              vjust=-0.5, size = 3)

grid.arrange(bp1, bp2, ncol=2)

dev.off()

# clear global environment
rm(list = ls())