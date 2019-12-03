# Exploring seedling traits across elevation in a Shiny app
# John Godlee (johngodlee@gmail.com)
# 2017-5-02

# Packages ----
library(shiny)
library(ggplot2)

# Loading data ----
seedlings <- read.csv("Data/Seedling_Elevation_Traits.csv")

# ui.R
ui <- fluidPage(
	titlePanel("Investigating Seedling Traits across Elevation"),
	sidebarLayout(
		sidebarPanel(
			checkboxGroupInput(inputId = "species",
												 label = "Species",
												 choices  = unique(seedlings$Species),
												 selected = unique(seedlings$Species)[1]
												 ),
			selectInput(inputId = 'trait', 
									label = 'Trait', 
									choices = c("Height (cm)" = "Height.cm", 
															"Number of leaves" = "Num.leaves", 
															"Mean leaf thickness (cm)" = "Leaf.thickness.mean.mm", 
															"Stem width (mm)" = "Width.mm"), 
									selected = NULL)),
		mainPanel(plotOutput("traitplot"))
		)
	)

# Define server logic required to draw a histogram
server <- function(input, output) {
	output$traitplot <- renderPlot(
		ggplot(data = seedlings[seedlings$Species %in% input$species,], 
					 aes_string(x = "Elevation.m", y = input$trait)) +
			geom_point(aes(colour = Species)) + theme_classic()
	)
	}

# Run the application 
shinyApp(ui = ui, server = server)

