# Set context to Spark
mySparkCluster <- RxSpark(consoleOutput=TRUE) 
rxSetComputeContext(mySparkCluster)

# Get the data
hdfsFS <- RxHdfsFileSystem()
bigDataDirRoot <- "/iris"
inputDir <- file.path(bigDataDirRoot,"iris-multiclass.csv")
irisDataColInfo <- list(
  list(index = 1, type = "numeric", newName = "sepallength"),
  list(index = 2, type = "numeric", newName = "sepalwidth"),
  list(index = 3, type = "numeric", newName = "petallength"),
  list(index = 4, type = "numeric", newName = "petalwidth"),
  list(index = 5, type = "factor", newName = "class"))

irisDS <- RxTextData(file = inputDir, missingValueString = "M", colInfo = irisDataColInfo,
                     fileSystem = hdfsFS)
irisData <- rxImport(inData = irisDS)
rxGetInfo(irisDS, getVarInfo=TRUE)



# Run K-means
irisCluster <- rxKmeans(~ sepallength + sepalwidth + petallength, 
                        data = irisData, numClusters = 3, seed = 30)
irisCluster

# Install ggplot2
install.packages("ggplot2")

# Visualize the clusters
library(ggplot2)
irisClusterResult<- as.factor(irisCluster$cluster)
ggplot(irisData, aes(sepallength, petallength, color = irisClusterResult)) + geom_point()
