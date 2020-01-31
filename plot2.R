# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 2==========
# Have total emissions from PM2.5 decreased in the Baltimore City,
# Maryland (fips=="24510") from 1999 to 2008? Use the base plotting
# system to make a plot answering this question.

# ========Answer 2============
# Yes, they did.

# subset data for Baltimore City
total_pm25_bal <- nei[nei$fips == "24510",]

# group emissions by year
total_pm25_bal <- aggregate(list(Emissions = total_pm25_bal$Emissions), 
                                  by = total_pm25_bal["year"], FUN = sum)

# making plot 2
png(filename = "plot2.png", width = 480, height = 480)
bp <- barplot(total_pm25_bal$Emissions, names.arg = total_pm25_bal$year,
              main = "Total PM2.5 emissions in the Baltimore City",
              xlab = "Year", ylab = "PM2.5 emissions, tons",
              col = "darkorchid1", cex.lab=1)
text(bp, 0, round(total_pm25_bal$Emissions, 2),cex=1,pos=3)
dev.off()

# clear global environment
rm(list = ls())