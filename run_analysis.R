library(tidyverse,dplyr)
# Establish paths for reading the files that corresponds to the project; establish the id of each group.
setwd("~/R/COURSERA/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
dir1<-dir()
act_labels<-read.table(dir1[1])
colnames(act_labels)[2]<-"activity"
features<-read.table(dir1[2])
path_test<-"C:/Users/gog/OneDrive/Documentos/R/COURSERA/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test"
path_train<-"C:/Users/gog/OneDrive/Documentos/R/COURSERA/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train"
# Reading test files
setwd(path_test)
test_files<-dir(path_test)
dir_test<-dir(test_files)
sub_test<-read.table(test_files[2],quote = "\"",comment.char = "")
colnames(sub_test)<-"id"
x_test<-as_tibble(read.table(test_files[3],quote = "\"",comment.char = ""))
y_test<-as_tibble(read.table(test_files[4],quote = "\"",comment.char = ""))
# Code to assign features and Activity Labels
colnames(x_test)<-features[,2]
colnames(y_test)<-"tlabels"
# reading train files
setwd(path_train)
train_files<-dir(path_train)
dir_train<-dir(train_files)
sub_train<-as_tibble(read.table(train_files[2], quote = "\"",comment.char = ""))
colnames(sub_train)<-"id"
x_train<-as_tibble(read.table(train_files[3],quote = "\"",comment.char = ""))
colnames(x_train)<-features[,2]
y_train<-as_tibble(read.table(train_files[4],quote = "\"",comment.char = ""))
colnames(y_train)<-"tlabels"
path_data_test<-"~/R/COURSERA/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Inertial Signals/"
path_data_train<-"~/R/COURSERA/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Inertial Signals/"
# joining activity names corresponding to the activity file labels (act_labels)
y_test<-merge(y_test, act_labels,by.x="tlabels",by.y="V1",sort=FALSE)
y_train<-merge(y_train, act_labels,by.x="tlabels",by.y="V1",sort=FALSE)
x_test<-cbind.data.frame(sub_test,y_test,x_test)
x_train<-cbind.data.frame(sub_train,y_train,x_train)
# Resulting Tidy Databases
# merge the x_train and x_test sets into the "data_base"
data_base<-as_tibble(rbind.data.frame(x_train,x_test),.name_repair = make.names)
#Extraction of the measurements of the mean and standard deviation for each measurement
mean_std<-as_tibble(select(data_base,id,tlabels,activity,contains(c("mean","std"))),.name_repair = make.names)
# Dont know if it was required to join the "inertial signals" files into two-data bases (test and train).
# these codes makes a tibble the 9 files of each of the training and test sets. The resulting data frames have
# 128 observations on the nine files wher each row corresponds to the measurements of each of the individuals
setwd(path_data_test)
data_signals_test<-as_tibble(sapply(dir_test,read.table),.name_repair=make.names)
setwd(path_data_train)
data_signals_train<-as_tibble(sapply(dir_train,read.table),.name_repair=make.names)
# Independent tidy data set with the average of each variable for each activity and each subject.
data_of_means<-select(mean_std,id,tlabels,activity,contains("mean"))
means_by_id<-aggregate.data.frame(aux2[,4:56],aux2[,1],mean)
means_by_activity<-aggregate.data.frame(aux2[,4:56],aux2[,c(2,3)],mean)
tidy_data_means<-merge.data.frame(means_by_id,means_by_activity,all=TRUE)