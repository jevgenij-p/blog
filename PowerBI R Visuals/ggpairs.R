
names(dataset) <- gsub(" ", ".",names(dataset))

if (!require("ggplot2")) {
  install.packages("ggplot2")
}
if (!require("GGally")) {
  install.packages("GGally")
}

library(ggplot2)
library(GGally)

point_fn <- function(data, mapping, method="loess", ...){
  ggplot(data = data, mapping = mapping) + 
    geom_point(colour = "steelblue", size = 1) + 
    geom_smooth(method=method, colour = "red", ...)
}

cor_fn <- function(data, mapping, color = I("black"), sizeRange = c(1, 5), ...) {
  
  x <- eval(mapping$x, data)
  y <- eval(mapping$y, data)
  
  cortest <- cor.test(x, y)
  
  r <- unname(cortest$estimate)
  corval <- as.character(format(round(r, 2))[1])
  
  max.pal <- 11
  half.pal <- round((max.pal + 1) / 2)
  pal <- RColorBrewer::brewer.pal(n=max.pal, name="RdYlBu")[1:max.pal]
  
  idx <- (sign(r) * round(((abs(r) * max.pal) + 1) / 2)) + half.pal
  if (idx > max.pal) idx <- max.pal
  if (idx < 1) idx <- 1
  
  ggally_text(label=corval, mapping=aes(), 
              xP=0.5, yP=0.5, size=6, color=color, ...) +
    theme(panel.background = element_rect(linetype = "dashed", fill = pal[idx]))
}

ggpairs(dataset, axisLabels='show',
        upper = list(continuous = cor_fn),
        lower = list(continuous = point_fn),
        diag=list(continuous=wrap("barDiag", fill = "steelblue", colour = "steelblue4"))) +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), 
        axis.ticks = element_blank(), 
        panel.border = element_rect(linetype = "dashed", colour = "black", fill = NA))
