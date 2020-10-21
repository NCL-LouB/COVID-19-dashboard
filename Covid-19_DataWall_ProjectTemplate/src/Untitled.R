span(h5(" Do you have data for the North East of England?"), style="color:#FFC312"),

("England" = "#c8102e", "Northern Ireland" = "#FFC312", 
 "Scotland" = "#012169", "Wales" = "#00AD36")

("County Durham" = "#fad390", "Darlington" = "#f6b93b", 
  "Gateshead" = "#e55039", "Hartlepool" = "#b71540", 
  "Middlesbrough" = "#1e3799", "Newcastle upon Tyne" = "#57606f", 
  "North Tyneside" = "#079992", "Northumberland" = "#6a89cc",
  "Redcar and Cleveland" = "#b8e994", "South Tyneside" = "#3B4C84",
  "Stockton-on-Tees" = "#F6B93B", "Sunderland" = "#009999")


output$NELocalAuthorities = renderPlotly({
  
  NELocalAuthorities = ggplot(data = filter(NEltlaCases, name %in% c(input$NELA1, input$NELA2))) +
    geom_line(mapping = aes(x = date, y = cases.daily, color = name)) +
    theme_classic() +
    theme(
      axis.text.x = element_text(color = "black", angle=60, hjust=1),
      axis.text.y = element_text(color = "black")) +
    scale_color_manual(values = c("County Durham" = "#001F3F", "Darlington" = "#7FDBFF", 
                                  "Hartlepool" = "#01FF70", "Middlesbrough" = "#AAAAAA",
                                  "Redcar and Cleveland" = "#B10DC9", "Stockton-on-Tees" = "#FF851B",
                                  "Sunderland" = "#0074D9", "Gateshead" = "#FFDC00", 
                                  "South Tyneside" = "#2ECC40", "North Tyneside" = "#FF4136", 
                                  "Newcastle upon Tyne" = "#F012BE", "Northumberland" = "#85144B"),
                       name = "") +
    scale_x_date(date_labels = "%b-%d",
                 breaks = "1 month") +
    ylab("Cases daily") +
    xlab("Date") +
    labs(color = "Local Authority")
  
  
  
  ggplotly(NELocalAuthorities)
  
})