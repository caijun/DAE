setwd("~/Documents/R/DAE/score")

library(xlsx)
raw <- read.xlsx("生态数据分析.xls", sheetIndex = 1)
raw[] <- lapply(raw, as.character)
str(raw)

# 未交按0分计
df <- data.frame(sapply(raw, gsub, pattern = "未交", replacement = 0), 
                 stringsAsFactors = F)

# process homework1: q is short for question, a is short for answer
hw1.score <- function(mqna) {
  # vectorize
  if (length(mqna) > 1) return(sapply(mqna, hw1.score))
  
  if (nchar(mqna) == 4) {
    hw1.sc <- 1
    mq = as.numeric(substring(mqna, 1, 1))
    na = as.numeric(substring(mqna, 3, 3))
    if (na >= 3) hw1.sc <- hw1.sc + 1
  }
  if (nchar(mqna) == 2) hw1.sc <- 1
  return(hw1.sc)
}

# convert into same scale
df$Homework.1 <- hw1.score(df$Homework.1) * 100

# convert character to numeric
df[, 5:20] <- sapply(df[, 5:20], as.numeric)
# calculate homework score
weight <- matrix(c(rep(0.02, 10), 0.1, 0.3, 0.4), 
                 dimnames = list(names(df)[4:16], "weight"))
df$Homework <- round(as.matrix(df[, 4:13]) %*% weight[1:10], 0)
# calculate attendance score
df$Attendance <- df$Attendance * 10
# calculate presention score by averaging three judges
df$Presentation <- round(rowMeans(df[, 18:20]))

df$Score <- df$Homework + df$Attendance + df$Presentation + df$Report
table(df$Score)

write.csv(df[, c(1:3, 21, 14:17)], "DAE_scores.csv", row.names = F, quote = F)
