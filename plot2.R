##  plot2.R
#
# Purpose : Draw plot Global active power by time in 1-2 feb 2007 from the "Individual household electric power consumption Data Set"
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

#calculating weekday
dateTime <- paste(as.character(data$Date), as.character(data$Time))
realdate <- strptime(dateTime , format = "%d/%m/%Y%T")
data$realdate <- realdate
data$weekday <- weekdays(realdate)

####################################################
## Step 2 : drawing the plot                      ##
####################################################

graph.type = "l"
graph.xlab <- ""
graph.ylab <- "Global Active Power (kilowatts)"

with(data, plot(realdate,Gap, type = graph.type, main = graph.title, xlab = graph.xlab, ylab = graph.ylab))


####################################################
## Step 3 : creating the pdf                      ##
####################################################

