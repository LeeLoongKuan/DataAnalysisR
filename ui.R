library(shiny)
library(shinyjs)
library(markdown)
library(plotly)

loadDataFile <- sidebarLayout(
  sidebarPanel(
    useShinyjs(),
    fileInput("file.arff", "Arff data file", multiple = TRUE, accept = ".arff") ,
    hr(),
    wellPanel(id = "timeline.panel",
        
    selectInput("timeline.type", 
                "Type of Drift Timeline", 
                c("Fixed Window Stream" = "stream", 
                  "Chunks" = "stream_chunk",
                  "Moving Chunk" = "moving_chunk")
                ),
    uiOutput("attribute.subset.length"),
    fluidRow(
        column(6, actionButton("length.confirm", label = "Add Length")),
        column(6, actionButton("length.reset", label = "Reset Lengths"))
        ),
    textOutput("subset.length.recorded"),
    hr(),
    uiOutput("chunk.attribute"),
    textOutput("chunk.attribute.num.vals"),
    uiOutput("window.input"),
    hr(),
    uiOutput("chunk.input"),
    fluidRow(
        column(6, actionButton("size.confirm", label = "Add Size")),
        column(6, actionButton("size.reset", label = "Reset Sizes"))
        ),
    textOutput("size.recorded"),
    actionButton("run.timeline", label = "Run Timeline Analysis")
    )
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Welcome", includeHTML("./Introduction.html")),
      tabPanel("Results", dataTableOutput("result.files"))
    )
    )
  )

analysePage <- fluidPage(verticalLayout(
))

timelinePlotPage <- fluidPage(verticalLayout(
    useShinyjs(),
    wellPanel(id = "timeline.plot",
              fluidRow(
                  column(6, 
                         uiOutput("timeline.plot.data"),
                         uiOutput("timeline.plot.type")
                         ),
                  column(6,
                         uiOutput("timeline.plot.drift.type"),
                         uiOutput("timeline.plot.sizes"),
                         uiOutput("timeline.plot.subset.length"),
                         uiOutput("timeline.plot.attributes")
                         )
              ),
              actionButton("timeline.plot.run", "Plot Timeline")),
    plotlyOutput("timeline.plot.plot"),
    wellPanel(id = "analyse.plot",
              selectInput("analyse.type", 
                          "Select Analyse Type", 
                          c("Drift Analysis" = "analysis", "Compare Distributions" = "compare")),
              fluidRow(
                  column(3, uiOutput("start.index.1")),
                  column(3, uiOutput("end.index.1")),
                  column(3, uiOutput("start.index.2")),
                  column(3, uiOutput("end.index.2"))
              ),
              selectInput("analyse.drift.type", 
                          "Select Drift Type",
                          c("COVARIATE", "JOINT", "LIKELIHOOD", "POSTERIOR")),
              actionButton("analyse.plot.run", "Run Analysis")),
    plotOutput("analysis.plot"),
    fluidRow(
    column(8, 
           plotlyOutput("analysis.2att.plot"),
           div(style = "height:150px"))
    ),
    fluidRow(
      column(8,
             plotlyOutput("analysis.detailed.plot"))
    ),
    textOutput("debug")
))

shinyUI(fluidPage(
  navbarPage("Drift Analysis",
             tabPanel("Data Selection", loadDataFile),
             tabPanel("Analyse", timelinePlotPage)
)
))


