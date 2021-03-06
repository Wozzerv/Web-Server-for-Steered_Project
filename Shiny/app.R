# Calling upon the Shiny Library
library(shiny)

# Reading in the csv files which contain all the results to be utilised in the App
rsem_rn4_untrimmed <- read.csv(file="/home/srp2017a/ShinyApps/rsem_rn4_untrimmed.csv", header=TRUE, sep="\t")
rsem_rn4_trimmed <- read.csv(file="/home/srp2017a/ShinyApps/rsem_rn4_trimmed.csv", header=TRUE, sep="\t")
rsem_rn6_untrimmed <- read.csv(file="/home/srp2017a/ShinyApps/rsem_rn6_untrimmed.csv", header=TRUE, sep="\t")
rsem_rn6_trimmed <- read.csv(file="/home/srp2017a/ShinyApps/rsem_rn6_trimmed.csv", header=TRUE, sep="\t")

tophat_rn4_untrimmed <- read.csv(file="/home/srp2017a/ShinyApps/tophat_rn4_untrimmed.csv", header=TRUE, sep="\t")
tophat_rn4_trimmed <- read.csv(file="/home/srp2017a/ShinyApps/tophat_rn4_trimmed.csv", header=TRUE, sep="\t")
tophat_rn6_untrimmed <- read.csv(file="/home/srp2017a/ShinyApps/tophat_rn6_untrimmed.csv", header=TRUE, sep="\t")
tophat_rn6_trimmed <- read.csv(file="/home/srp2017a/ShinyApps/tophat_rn4_trimmed.csv", header=TRUE, sep="\t")

# Perform ordering by logFC so that functionality in regards to most and least expressed genes can be viewed
attach(tophat_rn4_trimmed)
tophat_rn4_trimmed_sorted<-tophat_rn4_trimmed[order(logFC,decreasing=TRUE),]
detach(tophat_rn4_trimmed)
attach(tophat_rn4_untrimmed)
tophat_rn4_untrimmed_sorted<-tophat_rn4_untrimmed[order(logFC,decreasing=TRUE),]
detach(tophat_rn4_untrimmed)
attach(tophat_rn6_trimmed)
tophat_rn6_trimmed_sorted<-tophat_rn6_trimmed[order(logFC,decreasing=TRUE),]
detach(tophat_rn6_trimmed)
attach(tophat_rn6_untrimmed)
tophat_rn6_untrimmed_sorted<-tophat_rn6_untrimmed[order(logFC,decreasing=TRUE),]
detach(tophat_rn6_untrimmed)

attach(rsem_rn4_trimmed)
rsem_rn4_trimmed_sorted<-rsem_rn4_trimmed[order(logFC,decreasing=TRUE),]
detach(rsem_rn4_trimmed)
attach(rsem_rn4_untrimmed)
rsem_rn4_untrimmed_sorted<-rsem_rn4_untrimmed[order(logFC,decreasing=TRUE),]
detach(rsem_rn4_untrimmed)
attach(rsem_rn6_trimmed)
rsem_rn6_trimmed_sorted<-rsem_rn6_trimmed[order(logFC,decreasing=TRUE),]
detach(rsem_rn6_trimmed)
attach(rsem_rn6_untrimmed)
rsem_rn6_untrimmed_sorted<-rsem_rn6_untrimmed[order(logFC,decreasing=TRUE),]
detach(rsem_rn6_untrimmed)


ui <- fluidPage(
  
# Create columns which provide user control over the data
  fluidRow(
    column(2,
           h4("Volcano plot"),
           br(),
    radioButtons("choice", "Data_type:",
                 c("tophat_rn4_untrimmed" = "tophat_rn4_untrimmed",
                   "tophat_rn4_trimmed" = "tophat_rn4_trimmed",
                   "tophat_rn6_untrimmed" = "tophat_rn6_untrimmed",
                   "tophat_rn6_trimmed" = "tophat_rn6_trimmed",
                   "rsem_rn4_untrimmed" = "rsem_rn4_untrimmed",
                   "rsem_rn4_trimmed" = "rsem_rn4_trimmed",
                   "rsem_rn6_untrimmed" = "rsem_rn6_untrimmed",
                   "rsem_rn6_trimmed" = "rsem_rn6_trimmed"))
    ),
    fluidRow(
      column(4,
      # Allow the user to exclude points outside selected range    
      checkboxInput("showdots", label = "Only show from selected range?", value = FALSE),
      # ALlow user to control number of genes to display and whether they wish to see
      # up regulated or down regulated genes
      numericInput("genes", label = h3("Genes to Display"), value = 20000),
      checkboxInput("both", label = "both up and down", value = FALSE),
      checkboxInput("up", label = "Show up regulated genes", value = TRUE)
  
      )),
    br(),
    fluidRow(
      column(8,
             # Allow the user to moduly logFC and pvalue 
             numericInput("logfc", label = h3("LogFC"), value = 1.5),
             numericInput("pvalue", label = h3("P value"), value = 0.05)
             )),
    fluidRow(
      column(10, offset =  1,
             #Space on page to plot graph
             plotOutput("volcano")    )
    )
      )
 
)

  



server <- function(input, output) {
  output$volcano <- renderPlot ({
    # Select dataset
    ifelse(input$both ,data_type <- switch (input$choice,
                                            "tophat_rn4_untrimmed" = tophat_rn4_untrimmed,
                                            "tophat_rn4_trimmed" = tophat_rn4_trimmed,
                                            "tophat_rn6_untrimmed" = tophat_rn6_untrimmed,
                                            "tophat_rn6_trimmed" = tophat_rn6_trimmed,
                                            "rsem_rn4_untrimmed" = rsem_rn4_untrimmed,
                                            "rsem_rn4_trimmed" = rsem_rn4_trimmed,
                                            "rsem_rn6_untrimmed" = rsem_rn6_untrimmed,
                                            "rsem_rn6_trimmed" = rsem_rn6_trimmed),
    data_type <- switch (input$choice,
                         "tophat_rn4_untrimmed" = tophat_rn4_untrimmed_sorted,
                         "tophat_rn4_trimmed" = tophat_rn4_trimmed_sorted,
                         "tophat_rn6_untrimmed" = tophat_rn6_untrimmed_sorted,
                         "tophat_rn6_trimmed" = tophat_rn6_trimmed_sorted,
                         "rsem_rn4_untrimmed" = rsem_rn4_untrimmed_sorted,
                         "rsem_rn4_trimmed" = rsem_rn4_trimmed_sorted,
                         "rsem_rn6_untrimmed" = rsem_rn6_untrimmed_sorted,
                         "rsem_rn6_trimmed" = rsem_rn6_trimmed_sorted))
    
    
   # Control whether up or down regulated
    ifelse(input$both,out<-head(data_type,n=input$genes), ifelse(input$up,out<-head(data_type,n=input$genes),out<-tail(data_type,n=input$genes))) 
  
    # code to plot volcano plot
    plot(out$logFC, -log10(out$P.Value), pch=19, cex=0.2, col=ifelse(out$logFC < -input$logfc & out$P.Value<input$pvalue, "blue", ifelse(out$logFC > input$logfc & out$P.Value<input$pvalue, "red",if (input$showdots){"white"}else{"black"})), xlab = "logFC",main ="logFC vs -log10(P value) for ", ylab = "-log10(P-Val)",xlim=c(-10,10),ylim=c(0,10))
    abline(h=-log10(input$pvalue), col="blue")
    text(9,-log10(input$pvalue)+0.5,paste("P value",input$pvalue))
    abline(v=c(-input$logfc,input$logfc), col="green")
    text(-input$logfc,10,paste("LogFC",-input$logfc) )
    text(input$logfc,10,paste("LogFC",input$logfc))
    })
  
}

shinyApp(ui = ui, server = server)
