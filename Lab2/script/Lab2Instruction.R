### Part I
# set your working directory to Lab2
setwd("your/path/to/Lab2")
getwd()

list.files()
# extract file information for those files
file.info(list.files())
# list only directories under current working directory
list.dirs()
# find all R scripts under Lab2 and give their full path names (or absolute paths)
list.files(recursive = TRUE, pattern = ".R$", full.names = TRUE)

if(!dir.exists("data/CMDSSS"))
  dir.create("data/CMDSSS", recursive = TRUE)

# create a temporary directory under script
if(!dir.exists("script/tmp")) dir.create("script/tmp")
# create a temporary R script under tmp to say Hello World, Hello R!
file.create("script/tmp/tmp.R")

cat("print('Hello World, Hello R!')", file = "script/tmp/tmp.R")
source("script/tmp/tmp.R")

# copy tmp.R as helloworld.R in a differnt place
file.copy("script/tmp/tmp.R", "script/helloworld.R")
list.files("script", recursive = TRUE)
# rename helloworld.R to hello.R
file.rename("script/helloworld.R", "script/hello.R")
list.files("script", recursive = TRUE)

# delete all R scripts under script directory except for Lab2Instruction.R
# attempt to delete inexistent helloworld.R
file.remove(c("script/hello.R", "script/helloworld.R"))

list.files("script", recursive = TRUE)
# delete the temporary directory that is not empty.
unlink("script/tmp", recursive = TRUE)
list.files("script")

?files

### Part II
# divert R output to CO2.txt under data
sink(file = "data/CO2.txt")
# load R built-in dataset CO2. type ?CO2 to see the decription about CO2 dataset.
data("CO2")
# divert the first 14 rows of CO2
head(CO2, 14)
# end the divertion
sink()

1:10
x <- capture.output(1:10)
x

capture.output(head(CO2, 14), file = "data/CO2.txt")

### Part III
# read data in Plain Text
txt <- read.table(file = "data/CO2.txt")
str(txt)

Qn1 <- subset(txt, Plant == "Qn1")
# save Qn1 to .txt. 
# Though the file extension is .txt, the data is actually stored in a CSV format.
write.table(Qn1, file = "data/CO2-Qn1.txt", row.names = FALSE, quote = FALSE, sep = ",")

# save Qn1 to .csv
write.csv(Qn1, file = "data/CO2-Qn1.csv", row.names = FALSE, quote = FALSE)
# use read.csv to read CO2-Qn1.csv
csv <- read.csv(file = "data/CO2-Qn1.csv", header = TRUE, sep = ",", 
                fileEncoding = "utf-8", stringsAsFactors = FALSE)
str(csv)

# install xlsx package
install.packages("xlsx")
# load xlsx pacakage
library(xlsx)
# write Qn1 to .xls
write.xlsx(Qn1, file = "data/CO2-Qn1.xls", sheetName = "Sheet1", col.names = TRUE, 
           row.names = FALSE)
# use read.xlsx to read CO2-Qn1.xls 
xlsx <- read.xlsx(file = "data/CO2-Qn1.xls", sheetName = "Sheet1")
str(xlsx)

# install foreign package
install.packages("foreign")
# load foreign pacakage
library(foreign)
# write Qn1 to .dbf
write.dbf(Qn1, file = "data/CO2-Qn1.dbf")
# use read.dbf to read CO2-Qn1.dbf
dbf <- read.dbf(file = "data/CO2-Qn1.dbf")
str(dbf)

# list objects in current environment
ls()
# save txt, csv, xlsx and dbf .RData or .rda
save(txt, csv, xlsx, dbf, file = "data/format.RData")
rm(txt, csv, xlsx, dbf)
ls()
load(file = "data/format.RData")
ls()

### Part III Demostration
# use read.table to read dataset in TXT
data <- read.table(file = "data/CMDSSS/SURF_CLI_CHN_MUL_DAY-TEM-12001-201409.TXT")
str(data)
# V1: station id
# V2: latitude, the last two digits are minitue and the remaining digits are degrees
# V3: longitude, the last two digits are minitue and the remaining digits are degrees
# V4: altitude in 0.1 meter. When the station altitude is estimated rather than 
#     measured, 100000 is added.
# V5: year
# V6: month
# V7: days of the month
# V8: average temperature in 0.1 degree Celsius
# V9: daily maximum temperature in 0.1 degree Celsius
# V10: daily minimum temperature in 0.1 degress Celsius.
#      When the actual temperature is higher than the higher limit of the instrument 
#      measuring range, 10000 is added; When the actual temperature is lower than the 
#      lower limit, 10000 is subtracted.
#      32766 indicates observations are not available (NA).
# V11: quality control code of average temperature
# V12: quality control code of daily maximum temperature
# V13: quality control code of daily minimum temperature

colnames(data) <- c("id", "lat", "lng", "alt", "year", "month", "day", "meanT", 
                    "maxT", "minT", "meanQC", "maxQC", "minQC")
colnames(data)

str(data[[1]])
str(data[1])

str(data[, 8:10])
str(data[, c("meanT", "maxT", "minT")])

# extract temperatures collected from Miyun station whose id is 54416
Miyun.TEM <- data[data$id == 54416, c("meanT", "maxT", "minT")]
str(Miyun.TEM)

# summaries of meanT, maxT, and minT
summary(Miyun.TEM)
Miyun.TEM <- Miyun.TEM * 0.1
summary(Miyun.TEM)

save(Miyun.TEM, file = "data/Miyun-TEM-201409.RData")