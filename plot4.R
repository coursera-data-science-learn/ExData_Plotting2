# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 4==========
# Across the United States, how have emissions from coal
# combustion-related sources changed from 1999–2008?

# ========Answer 4============
# They decreased.

# merge nei and scc
scc_merge <- scc[, c("SCC", "EI.Sector")]
nei_scc <- merge(nei, scc_merge, by = "SCC")

# subset only coal combustion lines
match <- grepl(".*comb.*coal.*", nei_scc$EI.Sector, ignore.case = TRUE)
coal <- nei_scc[match, ]

# aggregate data by year
coal_pm25 <- aggregate(list(Emissions = coal$Emissions), 
                            by = coal["year"],
                            FUN = sum)
coal_pm25$Emissions <- coal_pm25$Emissions/1000000

# making plot 4
png(filename = "plot4.png", width = 480, height = 480)
bp <- barplot(coal_pm25$Emissions, names.arg = coal_pm25$year,
              main = "Coal PM2.5 emissions in the USA",
              xlab = "Year", ylab = "PM2.5 emissions, mln tons",
              col = "mediumspringgreen", cex.lab=1)
text(bp, 0, round(coal_pm25$Emissions, 2),cex=1,pos=3)
dev.off()

# clear global environment
rm(list = ls())