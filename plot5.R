# read the files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# ========Question 5==========
# How have emissions from motor vehicle sources changed from
# 1999–2008 in Baltimore City?

# ========Answer 5============
# They decreased.

# subset data for Baltimore City
pm25_bal <- nei[nei$fips == "24510",]

# merge nei and scc
scc_merge <- scc[, c("SCC", "EI.Sector")]
nei_scc <- merge(pm25_bal, scc_merge, by = "SCC")

# subset only motor vehicle lines
# for the purposes of our analysis let's assume these are "Mobile"
# lines excluding "Aircraft", "Commercial Marine Vessels", and "Locomotives" 
match <- grepl(".*mobile.*", nei_scc$EI.Sector, ignore.case = TRUE) & 
    !grepl("(.*mobile.*)(.*aircraft.*|.*locomotives.*|.*commercial marine vessels.*)",
    nei_scc$EI.Sector, ignore.case = TRUE)
motor <- nei_scc[match, ]

# aggregate data by year
motor_pm25_bal <- aggregate(list(Emissions = motor$Emissions), 
                       by = motor["year"],
                       FUN = sum)

# making plot 5
png(filename = "plot5.png", width = 480, height = 480)
bp <- barplot(motor_pm25_bal$Emissions, names.arg = motor_pm25_bal$year,
              main = "Motor vehicles PM2.5 emissions in the Baltimore City",
              xlab = "Year", ylab = "PM2.5 emissions, tons",
              col = "violet", cex.lab=1)
text(bp, 0, round(motor_pm25_bal$Emissions, 2),cex=1,pos=3)
dev.off()

# clear global environment
rm(list = ls())