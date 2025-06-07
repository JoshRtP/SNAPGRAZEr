library(shiny)

# load functions from package
func_files <- list.files("../R", pattern="\\.R$", full.names = TRUE)
lapply(func_files, source)

ui <- fluidPage(
  titlePanel("SNAPGRAZEr GUI"),
  sidebarLayout(
    sidebarPanel(
      numericInput("SAND", "Sand (%)", value = 50),
      numericInput("RAIN", "Annual Rainfall (mm)", value = 500),
      numericInput("MAT", "Mean Annual Temperature (C)", value = 20),
      numericInput("FIRE", "Fire factor (0-1)", value = 0),
      numericInput("LIGCELL", "Lignin + Cellulose (%)", value = 30),
      numericInput("Sk", "Sk (NA for default)", value = NA),
      numericInput("S0", "S0 (NA for default)", value = NA),
      numericInput("Edays", "Edays", value = 30),
      numericInput("Ddays", "Ddays", value = 3),
      numericInput("Fdays", "Fdays", value = 100),
      numericInput("Gdays", "Gdays (NA for default)", value = NA),
      numericInput("d", "Stocking density", value = 2),
      numericInput("n", "Number of pastures", value = 4),
      numericInput("W", "Average weight", value = 400),
      numericInput("Cg", "Daily consumption (NA for default)", value = NA),
      numericInput("r", "Growth rate r", value = 0.05),
      checkboxInput("APCcorrection", "APC correction", value = FALSE),
      checkboxInput("lowSOC", "Low SOC", value = FALSE),
      numericInput("DEPTH", "Depth (cm)", value = 30),
      actionButton("run", "Run Model")
    ),
    mainPanel(
      verbatimTextOutput("result")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$run, {
    args <- list(
      SAND = input$SAND,
      RAIN = input$RAIN,
      MAT = input$MAT,
      FIRE = input$FIRE,
      LIGCELL = input$LIGCELL,
      Sk = if(is.na(input$Sk)) NA else input$Sk,
      S0 = if(is.na(input$S0)) NA else input$S0,
      Edays = input$Edays,
      Ddays = input$Ddays,
      Fdays = input$Fdays,
      Gdays = if(is.na(input$Gdays)) NA else input$Gdays,
      d = input$d,
      n = input$n,
      W = input$W,
      Cg = if(is.na(input$Cg)) NA else input$Cg,
      r = input$r,
      APCcorrection = input$APCcorrection,
      lowSOC = input$lowSOC,
      DEPTH = input$DEPTH
    )
    result <- do.call(SNAPGRAZE, args)
    output$result <- renderPrint(result)
  })
}

shinyApp(ui, server)
