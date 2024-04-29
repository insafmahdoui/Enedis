add_treemap <- function(data,title_lb="") {



  fig <- plot_ly(
    type="treemap",

    labels=data$label,
    parents=rep("",nrow(data)),
    values=data$pct,
    marker = list(colors=c("#0B9BAD",
                           "#0064D0",
                           "#63A10F",
                           "#D19403",
                           "#AD0BA5",
                           "#BEBDBD")

    ),
    text =paste0(data$type,": ",format(round(data$value/1000,1),big.mark=" ")," Twh",'<br>',
                          "%",data$type,": ",round(100*data$pct),"%",'<br>'),
    hovertemplate =paste0(data$type," ",data$label,": ",format(round(data$value/1000,1),big.mark=" ")," Twh",'<br>',
      "%",data$type,": ",round(100*data$pct),"%",'<br><extra></extra>'))%>%
    layout(title=title_lb)
  fig
}

