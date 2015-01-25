
#1 loading and merging of files, both the test and training ones
#we give one column name 'activ' to avoid duplicates
file1 <-read.table("subject_test.txt", comment.char = "",col.names = "activ", colClasses="character")
file2 <-read.table("X_test.txt", comment.char = "", colClasses = "numeric")
file3 <-read.table("y_test.txt", comment.char = "",col.names = "index")
file4 <-read.table("subject_train.txt", comment.char = "",col.names = "activ", colClasses="character")
file5 <-read.table("X_train.txt", comment.char = "", colClasses = "numeric")
file6 <-read.table("y_train.txt", comment.char = "",col.names = "index")

#we put the pieces together
nfile <- cbind(file1, file2, file3)
nfile2 <- cbind(file4, file5, file6)
data <- rbind(nfile, nfile2)

library(dplyr)
#2 extract the mean and sd data, drop obsolete columns
selection <- select(data, -(8:562))


#3 add description activity
act_names <-read.table("activity_labels.txt",comment.char = "")
for (i in 1:10299) if (selection$activ[i] ==1) (selection$activ[i] <- "WALKING")
for (i in 1:10299) if (selection$activ[i] ==2) (selection$activ[i] <- "WALKING_UPSTAIRS")
for (i in 1:10299) if (selection$activ[i] ==3) (selection$activ[i] <- "WALKING_DOWNSTAIRS")
for (i in 1:10299) if (selection$activ[i] ==4) (selection$activ[i] <- "SITTING")
for (i in 1:10299) if (selection$activ[i] ==5) (selection$activ[i] <- "STANDING")
for (i in 1:10299) if (selection$activ[i] ==6) (selection$activ[i] <- "LAYING")

#4 labels for the dataset
colnames(selection) <- c("activ","tBodyAcc-mean()-X","tBodyAcc-mean()-Y","tBodyAcc-mean()-Z",
    "tBodyAcc-std()-X","tBodyAcc-std()-Y","tBodyAcc-std()-Z","subject"        )

#5 make the file with average per activity and subject
final <- ddply(selection(tidy, id.vars=c("subject", "activ")), .(subject, activ), summarise, MeanSamples=mean(value))

selection <- filter(selection, selection$subject < 6)
write.table(selection,file="result.txt", row.names=FALSE)
