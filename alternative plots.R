# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 2==========
# Of the four types of sources indicated by the type (point, nonpoint,
# onroad, nonroad) variable, which of these four sources have seen
# decreases in emissions from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.

# ========Answer 2============
# Increases:
#  - Point
# Decreases:
#  - Non-Road
#  - On-Road
#  - Non-Point

# subset data for Baltimore City
total_pm25_bal <- nei[nei$fips == "24510",]

# group emissions by year and type
total_pm25_bal <- aggregate(list(Emissions = total_pm25_bal$Emissions), 
                            by = c(total_pm25_bal["year"], total_pm25_bal["type"]),
                            FUN = sum)

# making plot 3
png(filename = "plot3.png", width = 480, height = 480)
# https://www.learnbyexample.org/r-bar-plot-base-graph/
# barplot(total_pm25_bal[, c()], main="Total PM2.5 emissions in the Baltimore City by type",
#         xlab="PM2.5 emissions, tons", ylab = "Year",
#         col=c("indianred1","khaki2"),
#         legend = rownames(total_pm25_bal))
dev.off()