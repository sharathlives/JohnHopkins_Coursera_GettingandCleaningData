
#Read in features and activity data sets
features  <-  read.table("./features.txt",header=FALSE)
activity_type <- read.table ("./activity_labels.txt", header = FALSE) 

#Set up traning set
subject_train <- read.table("./train/subject_train.txt",header=FALSE)
xtrain <- read.table("./train/X_train.txt",header=FALSE)
ytrain <- read.table("./train/y_train.txt",header=FALSE)

#Rename columns
colnames(activity_type) <- c("activity_ID", "activity_type")
colnames(subject_train) <- "subject_id"

colnames (xtrain) <- features [,2]
colnames (ytrain) <- "activity_ID"

#Set up the training data set
training_data <- cbind(xtrain, ytrain, subject_train)
#training_data$identifier <- "training_data"

# Set up test test set
subject_test <- read.table("./test/subject_test.txt",header=FALSE)
xtest <- read.table("./test/X_test.txt",header=FALSE)
ytest <- read.table("./test/y_test.txt",header=FALSE)

# Rename columns in the test set
colnames (xtest) <- features [,2]
colnames (ytest) <- "activity_ID"
colnames(subject_test) <- "subject_id"

# Set up test set
test_data <- cbind(xtest, ytest, subject_test)
#test_data$identifier <- "test_data"

#Combine training and test datasets
final_data <- rbind(training_data, test_data)

#Filter the columns to include only sd and mean columns
filter_features<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
filter_features<-grepl("mean\\(\\)|std\\(\\)", features$V2)
final_data_processed <- final_data [, filter_features]
data <- final_data_processed

#Appropriately label the datasets
#names(final_data_processed)

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

#Create a tidy dataset
data<-aggregate(. ~subject_id + activity_ID, data, mean, na.action = na.omit)

#Mergebased on activity_id
data <- merge(data, activity_type, by="activity_ID")

# Write filter
write.table(data, file = "finaldata.txt",row.name=FALSE)




