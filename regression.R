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


# Perform simple linear regression
linRegSepalPetallength <- rxLinMod(formula = sepallength ~ petallength, data = irisDS)
linRegSepalPetallength

# Plot regression
plot( irisData$petallength, irisData$sepallength,
      pch = as.integer(irisData$class), cex = 1.3,
      col = "green",
      main = "Petal length AGAINST Sepal length",
      xlab = "Petal length", ylab = "Sepal length")
abline(linRegSepalPetallength)
