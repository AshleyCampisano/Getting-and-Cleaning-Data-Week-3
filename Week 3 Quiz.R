#Week 3 - Quiz

#1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url,"./getdata%2Fdata%2Fss06hid.csv")
dat <- read_csv("./getdata%2Fdata%2Fss06hid.csv")
head(dat)

agricultureLogical <- dat$ACR == 3 & dat$AGS == 6
head(which(agricultureLogical), 3)

#2
library(jpeg)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", 'jeff.jpg')
pic <- jpeg::readJPEG('jeff.jpg', native = TRUE)

quantile(pic,probs = c(.3, .8))


#3
library(data.table)

GDP <- data.table::fread('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
                          , skip=4
                          , nrows = 190
                          , select = c(1, 2, 4, 5)
                          , col.names=c("CountryCode", "Rank", "Economy", "Total")
)

Country <- data.table::fread('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
)

merge <- merge(GDP, Country, by = 'CountryCode')

nrow(merge)

merge[order(-Rank)][13,.(Economy)]


#4
# "High income: OECD" 
merge[`Income Group` == "High income: OECD"
         , lapply(.SD, mean)
         , .SDcols = c("Rank")
         , by = "Income Group"]

# Answer:
#
#         Income Group     Rank
# 1: High income: OECD 32.96667

# "High income: nonOECD"
merge[`Income Group` == "High income: nonOECD"
         , lapply(.SD, mean)
         , .SDcols = c("Rank")
         , by = "Income Group"]

#5
library('dplyr')

breaks <- quantile(merge[, Rank], probs = seq(0, 1, 0.2), na.rm = TRUE)
merge$quantileGDP <- cut(merge[, Rank], breaks = breaks)
merge[`Income Group` == "Lower middle income", .N, by = c("Income Group", "quantileGDP")]
