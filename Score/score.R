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

df$Homework.1 <- hw1.score(df$Homework.1)

# convert character to numeric
df[, 5:17] <- sapply(df[, 5:17], as.numeric)
# convert into same scale
df[, 5:13] <- df[, 5:13] / 100
# the scores of Presentation and Report are currently NAs, 
# temporarily fill them with 0
df[is.na(df)] <- 0

weight <- matrix(c(rep(0.02, 10), 0.1, 0.3, 0.4), 
                 dimnames = list(names(df)[4:16], "weight"))

df$Score <- round(as.matrix(df[, 4:16]) %*% weight * 100, 0)
table(df$Score)

write.csv(df, "DAE_scores.csv", row.names = F, quote = F)
