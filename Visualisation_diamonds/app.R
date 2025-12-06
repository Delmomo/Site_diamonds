
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
  titlePanel("Exploration de la BDD Diamonds"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      radioButtons(inputId = "Bouton_rose",
                   label = "Colorier en rose ?",
                   choices = c("Oui", "Non"),
                   selected = "Non"),
      
      selectInput(inputId = "color",
                  label = "Choisir une couleur à filtrer :",
                  choices = levels(diamonds$color),
                  selected = "D"),
      
      sliderInput(inputId = "prix",
                  label = "Prix maximum :",
                  min = 0,
                  max = 20000,
                  value = 200),
      
      actionButton(inputId = "bouton", 
                   label = "Visualiser le graphiphe")
    ), 
    
    
    mainPanel(
      plotlyOutput("distPlot"),
      DTOutput("Tab")
    )
  ) 
)

# Server ----
server <- function(input, output) {
  
  rv <- reactiveValues(df = diamonds, choix_rose = "Non")
  
  observeEvent(input$bouton, {
    rv$df <- diamonds |> 
      filter(color == input$color) |> 
      filter(price <= input$prix)
    rv$choix_rose <- input$Bouton_rose
    
  })
  
  output$distPlot <- renderPlotly({
    couleur_point <- ifelse(rv$choix_rose == "Oui", "pink", "black")
    g <- ggplot(rv$df, aes(x = carat, y = price)) +
      geom_point(color = couleur_point) +
      theme_minimal() +
      labs(title = paste("Prix :", input$prix, "& Couleur :", input$color))
    ggplotly(g)
  })
  
  output$Tab <- renderDT({
    rv$df
  })
}

# Lancer l'Application Web ----

shinyApp(ui = ui, server = server)
