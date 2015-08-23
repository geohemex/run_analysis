#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##FILE DOWNLOADING & SETTING DIRECTORY
if(!file.exists("./Final")){dir.create("./Final")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "getdata-projectfiles-UCI-HAR-Dataset.zip"
download.file(fileUrl, destfile=paste("Final", destfile, sep="/"))
list.files("C:/Users/Geovanni/Desktop/Coursera/Getting and Cleaning Data/Q1")
unzip(paste("Final", destfile, sep="/"), exdir="Final")
dir <- setdiff(dir("Final"), destfile)

## PASTE LABELS
activity_lab <- read.table(paste("Final", dir, "activity_labels.txt", sep="/"), 
                     col.names=c("code","activity"))


## IMPORTING FEATURES
features <- read.table(paste("Final", dir, "features.txt", sep="/"))
indices <- grep("mean\\(|std\\(", features[,2])



## IMPORTING TRAINING SET
folder_trn <- paste("Final", dir, "train", sep="/")
trn_sbj <- read.table(paste(folder_trn, "subject_train.txt", sep="/"), 
                               col.names = "subject")
trn_data <- read.table(paste(folder_trn, "X_train.txt", sep="/"),
                            col.names = features[,2], check.names=FALSE)
trn_data <- trn_data[,indices]
trn_lab <- read.table(paste(folder_trn, "y_train.txt", sep="/"),
                              col.names = "labelcode")
final_trn = cbind(trn_lab, trn_sbj, trn_data)
  
## IMPORTING TEST
folder_tst <- paste("Final", dir, "test", sep="/")
tst_sbj <- read.table(paste(folder_tst, "subject_test.txt", sep="/"), 
                           col.names = "subject")
tst_data <- read.table(paste(folder_tst, "X_test.txt", sep="/"),
                        col.names = features[,2], check.names=FALSE)
tst_data <- tst_data[,indices]

tst_lab <- read.table(paste(folder_tst, "y_test.txt", sep="/"),
                          col.names = "labelcode")
final_tst = cbind(tst_lab, tst_sbj, tst_data)
names(final_tst)
names(final_trn)
## MERGING & RE-LABELING
final <- rbind(final_trn, final_tst)
final = merge(activity_lab, final, by.x="code", by.y="labelcode")

## RESHAPING

melt_final <- melt(final, id = c("activity", "subject"))

## FINAL 
tidy_data <- dcast(melt_final, activity + subject ~ variable, mean)


##WRITE TABLE
write.table(tidy_data, file = "./tidy_data_fin.txt", row.name=FALSE)




