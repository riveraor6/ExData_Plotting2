##Setting library
library(plyr)
library(ggplot2)
library(data.table)

dir <- setwd("D:/Users/Mad Labs PR/Documents/Exploratory_2")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename1 <- "exdata-data-NEI_data.zip"
filename2 <- "Source_Classification_Code.rds"
filename3 <- "summarySCC_PM25.rds"

##Download the data is file does not exist in the working directory
if (!file.exists(filename1)) {
        download.file(url, paste("./",filename1))
        unzip(filename1, overwrite = TRUE, exdir = dir)
}

##Unzip file if rds file is not in working directory
if (!file.exists(filename2)) {
        unzip(filename1, overwrite = TRUE, exdir = dir)
}

##Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Aggreate emission per year
Yearly_Emissions <- with(NEI, aggregate(Emissions, by = list(year), sum))

##Plot1
png(filename = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")

plot(Yearly_Emissions, type = "l", col = "dark red", ylab = "Total PM2.5 Emmision From All Sources Between 1999-2008", xlab = "Year", main = "Annual Emissions")
axis(1, at=as.integer(Yearly_Emissions$year), las=1)
dev.off()