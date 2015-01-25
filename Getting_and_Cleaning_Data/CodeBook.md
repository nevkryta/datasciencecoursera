    Run_analysis.R  CodeBook
   
    There are 6 steps to transform original data into clean dataset.

   1. Download data from provided link
   2. Merges the training and the test sets to create one data set.
   3. Extracts only the measurements on the mean and standard deviation for each  
      measurement.
   4. Rename columns for descriptive activity names 
   5. Appropriately labels the data set with descriptive activity names.
   6. Creates a second, independent tidy data set with the average of each  
      variable for each activity and each subject.

    Before loading data library(plyr) added and new_name function created. This  
function will be  used to rename columns for  descriptive activity names in step 4. 
    Next block is creating data subfolder where source data would be loaded and  
loads and unzip  both test and train data.
    To read txt files read.table function was used and both sets were merged  
using cbind.
    From merged dataset only measurements on the mean and standard deviation for  
each measurement       have been selected.

Result file tidy.mean consist of three variables: subject, activity and  
MeanSamples. MeanSamples is mean of Subject and Activity from provided tidy set.