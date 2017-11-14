#' Plot missing value rates
#' 
#' @param data a dataframe
#' @param seg a number of segments of the dataframe
#' @param col a pallete
#'
#' @return a ggplot object
#' 
plot_missing <- function(data, seg = 10, col = NULL) {
  
  library(ggplot2)
  library(reshape)
  
  columns <- colnames(data)
  ncols <- length(columns)
  nrows <- nrow(data)
  segments <- ifelse(seg > 0, seg, 1)
  
  missing_intensity <- matrix(0, ncols, (segments + 1))
  seg_size <- nrows / segments
  
  index <- seq(from = 0, to = nrows, by = seg_size)
  if (index[length(index)] < nrows) {
    index <- c(index, nrows)
  }
  
  index <- round(index)
  
  if (length(index) < (segments + 1)) {
    segments <- segments - 1
    missing_intensity <- matrix(0, ncols, (segments + 1))
  }
  
  for (i in 1:ncols) {
    index_i <- is.na(data[, columns[i]])
    missing_intensity[i, 1] <- sum(index_i) / nrows * 100
    for (j in 1:segments) {
      start_index <- index[j] + 1
      end_index <- index[j + 1]
      index_j <- is.na(data[start_index:end_index, columns[i]])
      missing_intensity[i, (j + 1)] <- sum(index_j) / (end_index - start_index + 1) * 100
    }
  }
  
  general_rate <- round(mean(missing_intensity[, 1]), 2)
  sort_index <- sort.int(-missing_intensity[, 1], index.return = T)$ix
  missing_intensity <- data.frame(missing_intensity)
  rownames(missing_intensity) <- columns
  colnames(missing_intensity) <- c('All', c(1:segments));
  missing_intensity <- missing_intensity[sort_index,]
  rnames <- factor(rownames(missing_intensity), levels = rev(rownames(missing_intensity)), ordered = F)
  
  missing_intensity <- cbind(Columns = rnames, missing_intensity)
  missvalues <- melt(missing_intensity, id = c('Columns'))
  
  new.palette <- colorRampPalette(c('royalblue4', 'seagreen3', 'yellow', 'orangered', 'black'))(100)
  
  if (!is.null(col))
    new.palette = col
  
  ggplot(missvalues, aes(x = variable, y = Columns, fill = value)) +
    geom_tile() +
    xlab('Segments') + 
    ggtitle(paste0('Missing Value Rate (', general_rate, '%)')) +
    scale_fill_gradientn(name = 'Missing\nvalue', colours = new.palette)
}
