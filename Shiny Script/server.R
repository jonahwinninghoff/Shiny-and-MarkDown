shinyServer(function(input,output){
    
    data(CO2)
    set.seed(345)
    inTrain <- createDataPartition(CO2$Treatment,p=.6,list=F)
    training <- CO2[inTrain,]
    testing <- CO2[-inTrain,]
    modFit <- train(Treatment ~ ., method="gbm",data=training,verbose=FALSE)

    newt <- select(testing,uptake,conc)
    newt <- reactiveVal()
    
    observeEvent(event_data("plotly_hover"), {
        newo <- event_data("plotly_hover")$customdata
        testing_old_new <- c(newt(),newo)
        newt(unique(testing_old_new))
    })
    observeEvent(event_data("plotly_doubleclick"), {
        newt(NULL)
    })
    output$plot1 <- renderPlotly({
        plot_ly(training,x=~uptake,y=~conc,color=~Treatment, type="scatter", mode = "markers",size=2,
        colors = c("rosybrown","coral"))%>%
        layout(xaxis = list(title="uptake rates (umol/m^2 sec)"),yaxis=list(title = "CO2 concentrations (mL/L)"))
    })
    output$plot2 <- renderPlotly({
        plot_ly(testing,x=~uptake,y=~conc,color=~Treatment, type="scatter",mode = "markers",size=2,
        colors = c("rosybrown","coral"))%>%
        layout(xaxis = list(title="uptake rates (umol/m^2 sec)"),
        yaxis=list(title = "CO2 concentrations (mL/L)"))
    })
    output$plot3 <- renderPlotly({
        
        cols <- ifelse(row.names(testing)%in% newt(),"rosybrown","coral")
        
        testing%>% 
            plot_ly(x=~uptake,y=~conc, 
                    customdata=row.names(testing),marker = list(color=cols),
                    size=2)%>%add_markers()%>%
            layout(xaxis = list(title="uptake rates (umol/m^2 sec)"),
                   yaxis=list(title = "CO2 concentrations (mL/L)")) 
    })
    output$Accuracy2 <- renderTable({
        filter(testing, row.names(testing) %in% newt())
    })
    output$Accuracy1 <- renderTable({
        filter(testing,Treatment == "nonchilled")
    })
    output$Summary1 <- renderText({
        "The machine learning that uses a simple, yet powerful algorithm called Boosting can produce precise prediction, and with appropriate datasets, without any single error. The one would abbreviate it GBM. This algorithm possesses a pre-mature form of artificial intelligence that can predict which Echinochloa crus-galli does not receive treatment. 

Experiment with your ability to predict under ‘Make Your Prediction’ main section with “Your Table” sidebar. Your goal is to click every point that indicates ‘nonchilled’ under column called Treatment under your table. If you get all right answers, you are as smart as Machine Learning!
"})
})
