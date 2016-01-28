###### Load libraries #######
library(shiny)
library(randomForest)
library(ggplot2)

###### Function #######
shinyServer(function(input, output, session) {
  
  buildForest <- eventReactive(input$submit, {
    
    data(iris)
    
    ntree <- input$ntree
    
    log.ir <- log(iris[, 1:4])
    ir.species <- iris[, 5]
    iris.pca <- prcomp(log.ir, center = TRUE, scale = TRUE)
    iris.pca.dat <- data.frame(PC1 = iris.pca$x[, 1], 
                               PC2 = iris.pca$x[, 2], 
                               Class = as.character(ir.species))
    
    iris.pca.rf <- randomForest(Class ~ PC1 + PC2,
                                data = iris.pca.dat, 
                                importance = FALSE,
                                proximity = FALSE,
                                ntree = ntree)
    
    iris.pca.dat$Pred.Class <- iris.pca.rf$predicted
    iris.pca.dat$Pred.Class <- as.character(iris.pca.dat$Pred.Class)
    iris.pca.dat$Pred.Class[is.na(iris.pca.dat$Pred.Class)] <- 'unknown'
    iris.pca.dat$Pred.Class  <- as.factor(iris.pca.dat$Pred.Class)
    iris.pca.dat$Pred.Class <- factor(iris.pca.dat$Pred.Class,  levels = c('setosa', 'versicolor', 'virginica', 'unknown'))
    iris.pca.dat$Correctness <- 'Correct'
    levels(iris.pca.dat$Class) <- c('setosa', 'versicolor', 'virginica', 'unknown')
    iris.pca.dat$Correctness[iris.pca.dat$Class != iris.pca.dat$Pred.Class] <- 'Incorrect' 
    
    iris.pca.dat
    
  })
  
  output$iris.rf.ggplot <- renderPlot({
    
    # par(mar = c(5.1, 4.1, 0, 1))
    isolate({
      showCorrectness.local <- input$showCorrectness
    })
    
    if(showCorrectness.local){
      
      iris.pca.dat.local <- data.frame(buildForest())
      ggplot(data = iris.pca.dat.local, mapping = aes(x = PC1, y = PC2, group = Correctness)) + 
        geom_point(aes(colour = Pred.Class), size = 4.5) +
        geom_point(data = iris.pca.dat.local,
                   aes(colour = Class, shape = Correctness), size = 7) +
        scale_shape_manual(values = c('Correct' = 1, 'Incorrect' = 4))
      
    }else{
      
      iris.pca.dat.local <- data.frame(buildForest())
      ggplot(data = iris.pca.dat.local, mapping = aes(x = PC1, y = PC2, group = Correctness)) + 
        geom_point(aes(colour = Pred.Class), size = 4.5)
      
    }
        
  }) 
  
})
