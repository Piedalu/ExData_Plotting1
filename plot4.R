##  plot3.R
#
# Purpose : Draw plot Energy sub metering by time in 1-2 feb 2007 from the "Individual household electric power consumption Data Set"
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
data$Volt <- as.numeric(as.character(data$Voltage))
data$Sm1 <- as.numeric(as.character(data$Sub_metering_1))
data$Sm2 <- as.numeric(as.character(data$Sub_metering_2))
data$Sm3 <- as.numeric(as.character(data$Sub_metering_3))
data$Grp <- as.numeric(as.character(data$Global_reactive_power))

#calculating weekday
dateTime <- paste(as.character(data$Date), as.character(data$Time))
realdate <- strptime(dateTime , format = "%d/%m/%Y%T")
data$realdate <- realdate
data$weekday <- weekdays(realdate)

####################################################
## Step 2 : drawing the plot                      ##
####################################################

png(file = "plot4.png")

par(mfrow = c(2,2))


## first graph
graph1.type = "l"
graph1.xlab <- ""
graph1.ylab <- "Global Active Power"

with(data, plot(realdate, Gap, type = graph1.type, xlab = graph1.xlab, ylab = graph1.ylab))


## second graph
graph1.type = "l"
graph1.xlab <- "datetime"
graph1.ylab <- "Voltage"

with(data, plot(realdate, Volt, type = graph1.type, xlab = graph1.xlab, ylab = graph1.ylab))



## third graph
graph3.type = "l"
graph3.xlab <- ""
graph3.ylab <- "Energy sub metering"
graph3.legend <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

with(data, {
    plot(realdate,Sm1, type = graph3.type, xlab = graph3.xlab, ylab = graph3.ylab)
    with(data, lines(realdate,Sm2, col = "red"))
    with(data, lines(realdate,Sm3, col = "blue"))
    legend("topright", legend = graph3.legend, bty="n", lwd=1, col=c("black", "red", "blue"))
})


## fourth graph
graph4.type = "l"
graph4.xlab <- "datetime"
graph4.ylab <- "Global_reactive_power"

with(data, plot(realdate, Grp, type = graph4.type, xlab = graph4.xlab, ylab = graph4.ylab))

dev.off()
