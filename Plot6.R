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

normalize <- function(x) {(x-min(x)) / (max(x)-min(x))}

##Get Baltimore data
##Subset data by fips == "24510"
BAemission <- NEI[(NEI$fips == "24510") & (NEI$type == "ON-ROAD"),]

##Get Los Angeles data
##Subset data by fips == "06037"
LAemission <- NEI[(NEI$fips == "06037") & (NEI$type =="ON-ROAD"),]

BAemission <- aggregate(Emissions ~ year, data=BAemission, FUN=sum)
LAemission <- aggregate(Emissions ~ year, data=LAemission, FUN=sum)

BAemission$City <- "Baltimore"
LAemission$City <- "Los Angeles"

##rbind Baltimore and Los Angeles data
remissions <- rbind (BAemission, LAemission)

names(remissions) <- c('Year', 'Emissions', 'City')

str(remissions)

##plot 6
png(filename="plot6.png", width=480, height=480)


ggplot(remissions, aes(x=factor(Year), y=Emissions, fill=City)) +
        geom_bar(stat="identity") +
        facet_grid(.~City) +
        guides(fill=FALSE) + theme_bw() +
        labs(x="Year", y=expression("Total PM"[2.5]*" Emission")) + 
        labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

dev.off()

