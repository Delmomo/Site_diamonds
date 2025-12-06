
# Imporation des packages ----

library(shiny)
library(dplyr)
library(ggplot2)
library(shinylive)
library(DT)
library(bslib)
library(thematic)
library(plotly)

# Visualisation de la Data ----

data("diamonds")


# UI ----
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "minty"),
  
  # Application title
  titlePanel("Exploration de la BDD Diamonds"),
  
  # Sidebar with inputs
  sidebarLayout(
    sidebarPanel(
      # Ajout du Bouton_rose
      radioButtons(inputId = "Bouton_rose",
                   label = "Colorier en rose ?",
                   choices = c("Oui", "Non"),
                   selected = "Non"),
      
      # Le slider original
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    
    # Détermine la couleur des barres basée sur le Bouton_rose
    couleur_barres <- ifelse(input$Bouton_rose == "Oui", "deeppink", "darkgray")
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, 
         col = couleur_barres, # Utilisation de la variable de couleur
         border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

# Lancer l'Application Web ----

shinyApp(ui = ui, server = server)
