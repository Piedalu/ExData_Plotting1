##  plot1.R
#
# Purpose : Draw plot frequency of Global active power in 1-2 feb 2007 from the "Individual household electric power consumption Data Set"
##

##Install dplyr if necessary
plib <- installed.packages()
if (!any(plib[,"Package"] == "dplyr"))
{
    install.packages("dplyr")
}
library(dplyr)
library(datasets)


####################################################
## Step 1 : loading and cleaning the dataset      ##
####################################################

if (!file.exists("household_power_consumption.txt")){
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp, method="curl")
    unzip(temp)
    unlink(temp)
}
data <- read.table("household_power_consumption.txt", sep=";", comment.char = "")

#renaming columns
colnames(data) <- lapply(data[1,], as.character)

#filtering on two days of feb 2007
data <- filter(data, as.character(data$Date) %in% c("1/2/2007","2/2/2007"))

#converting vector labels to numeric
data$Gap <- as.numeric(as.character(data$Global_active_power))

####################################################
## Step 2 : drawing the plot                      ##
####################################################

png(file = "plot1.png")

graph.title <- "Global Active Power"
graph.xlab <- "Global Active Power (kilowatts)"
graph.color <- "red"


with(data, hist(Gap, main = graph.title, xlab = graph.xlab, col = graph.color))

dev.off()
