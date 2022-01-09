library(lubridate)

# Sets the working directory to the directory of the source file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Reads the data and seperates it using ;
data <- read.table("specdata/household_power_consumption_data/household_power_consumption.txt", sep=";")
names(data) <- data[1, ]
data <- data[-1, ]

# Subset the data using the date range
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data <- data[data$Date >="2007-02-01" & data$Date <="2007-02-02", ]

#------------------------------Plot 1------------------------------#
plot1 <- function(){
  # Opens the file to write to
  png("plot1.png")
  # Create histogram
  hist(as.numeric(data$Global_active_power), main="Global Active Power", col="red", xlab="Global Active Power (kilowatts)")
  # Save file
  dev.off() 
}

#------------------------------Plot 2------------------------------#
plot2 <- function(){
  # Opens the file to write to
  png("plot2.png")
  # Initialize x-axis labels
  days <- c("Thu", "Fri", "Sat")
  # Create plot
  plot(as.numeric(data$Global_active_power), type="l", ylab="Global Active Power (kilowatts)", xaxt = "n", xlab="Day of the Week")
  # Assign x-axis labels
  axis(1, at = c(0, nrow(data)/2, nrow(data)), labels = days)
  # Save file
  dev.off() 
}

#------------------------------Plot 3------------------------------#
plot3 <- function(){
  # Opens the file to write to
  png("plot3.png")
  # Initialize x-axis labels
  days <- c("Thu", "Fri", "Sat")
  # Create plot
  plot(as.numeric(data$Sub_metering_1), type="l", ylab="Energy sub metering", xaxt = "n", xlab="Day of the Week", col="black")
  # Add lines for sub_metering_2 & sub_metering_3
  lines(as.numeric(data$Sub_metering_2), type="l", col="red")
  lines(as.numeric(data$Sub_metering_3), type="l", col="blue")
  # Add legend
  legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, cex=1)
  # Assign x-axis labels
  axis(1, at = c(0, nrow(data)/2, nrow(data)), labels = days)
  # Save file
  dev.off() 
}

#------------------------------Plot 4------------------------------#
plot4 <- function(){
  # Opens the file to write to
  png("plot4.png")
  # Initialize x-axis labels
  days <- c("Thu", "Fri", "Sat")
  
  # Create 2 by 2 row of figures
  attach(mtcars)
  par(mfrow=c(2,2))
  # Combining 4 plots
  # First plot
  plot(as.numeric(data$Global_active_power), type="l", ylab="Global Active Power (kilowatts)", xaxt = "n", xlab="Day of the Week")
  axis(1, at = c(0, nrow(data)/2, nrow(data)), labels = days)
  
  # Second plot
  plot(as.numeric(data$Voltage), type="l", ylab="Voltage", xaxt = "n", xlab="Day of the Week", col="black")
  axis(1, at = c(0, nrow(data)/2, nrow(data)), labels = days)
  
  # Third plot
  plot(as.numeric(data$Sub_metering_1), type="l", ylab="Energy sub metering", xaxt = "n", xlab="Day of the Week", col="black")
  lines(as.numeric(data$Sub_metering_2), type="l", col="red")
  lines(as.numeric(data$Sub_metering_3), type="l", col="blue")
  legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, cex=1)
  axis(1, at = c(0, nrow(data)/2, nrow(data)), labels = days)
  
  # Fourth plot
  plot(as.numeric(data$Global_reactive_power), type="l", ylab="Voltage", xaxt = "n", xlab="Day of the Week", col="black")
  axis(1, at = c(0, nrow(data)/2, nrow(data)), labels = days)
  
  # Save file
  dev.off() 
}