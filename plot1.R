# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 1==========
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# ========Answer 1============
# Yes, they did.

# group emissions by year
total_pm25 <- aggregate(list(Emissions = nei$Emissions), by = nei["year"], FUN = sum)
total_pm25$Emissions <- total_pm25$Emissions/1000000

# making plot 1
png(filename = "plot1.png", width = 480, height = 480)
bp <- barplot(total_pm25$Emissions, names.arg = total_pm25$year,
        main = "Total PM2.5 emissions in the USA",
        xlab = "Year", ylab = "PM2.5 emissions, mln tons",
        col = "cadetblue", cex.lab=1)
text(bp, 0, round(total_pm25$Emissions, 2),cex=1,pos=3)
dev.off()

# clear global environment
rm(list = ls())