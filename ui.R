######## Load library
library(shiny)

shinyUI(
  
  #Create a bootstrap fluid layout
  fluidPage(
    
    #Add a title
    titlePanel('Random Forest with First Two Principal Components','IrisApp'),
    p('This tool box aims to demonstrate result by using Random Forest to classifiy spieces based on the training data on "Iris" and 1st two principal components.  The user can switch the number of trees to grow and configure whether or not to display actual result.'),
    
    #Add a row for the main content
    fluidRow(
      
      # Display the Cluster Plot
      plotOutput('iris.rf.ggplot', width = "100%", height = "300px")
      
    ),
    
    #Create another row for User Input
    fluidRow(
      
      mainPanel(
        #Simple integer interval
        sliderInput("ntree", "Specify # of Trees:", 
                    min = 1, max = 150, value = 75),
        
        checkboxInput('showCorrectness', label = 'Show Correctness', 
                      value = FALSE),
        
        
        p(strong(em("Github repository:",a("Developing Data Products - Peer Assessment Project; Shiny App",href="https://github.com/gviglioni/DevelopingDataProducts/tree/gh-pages"))))
      ),
      
      sidebarPanel(
        actionButton("submit", "Submit")
      )
      
    )
    
  )
)
