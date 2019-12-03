# Exploring LPI 2016 spatial data in a Shiny app
# John Godlee (johngodlee@gmail.com)
# 2017-5-02

# Packages ----
library(shiny)
library(dplyr)
library(ggmap)

# Load data ----
load("Data/LPIdata_Feb2016.RData", envir = .GlobalEnv)
map_world <- borders("world", colour="black", fill = "gray28")

# ui.R ----
ui <- fluidPage(title = "Living Planet Index",
								verticalLayout(titlePanel("The spatial distribtion of records used to generate the 2016 Living Planet index (www.livingplanetindex.org)"),
									plotOutput("global_map", height = "700px"),
									wellPanel(selectInput(inputId = "realm_map", 
															label = "Choose realm", 
															choices = unique(LPIdata_Feb2016$realm),
															selected = unique(LPIdata_Feb2016$realm)[1],
															multiple = TRUE
															)
														)
									)
								)

# server.R ----
server <- function(input, output) {
	
	# Plot map
	output$global_map <- renderPlot(
		ggplot() + 
			map_world +
			geom_point(aes(x = Decimal_Longitude, 
										 y = Decimal_Latitude, 
										 colour = realm), 
								 data = LPIdata_Feb2016[LPIdata_Feb2016$realm == input$realm_map,]) + 
			theme(axis.title = element_blank(), 
						axis.text = element_blank(),
						axis.ticks = element_blank(),
						axis.line = element_blank(),
						panel.border = element_rect(colour="black", fill = NA, size=1),
						panel.background = element_rect(fill="#FCFCFC"),
						legend.position = "bottom",
						legend.title = element_blank(),
						legend.text = element_text(size = 15)) +
			guides(colour = guide_legend(override.aes = list(size = 10)))
	)
	}

# Run app ----
shinyApp(ui = ui, server = server)
