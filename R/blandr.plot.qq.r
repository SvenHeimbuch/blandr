#' @title Bland-Altman differences QQ plot
#'
#' @description Generates a QQ plot for Bland-Altman differences
#'
#' @author Deepankar Datta <deepankardatta@nhs.net>
#'
#' @param statistics.results A list of statistics generated by the blandr.statistics function: see the function's return list to see what variables are passed to this function
#'
#' @include blandr.statistics.r
#'
#' @export

blandr.plot.qq <- function( statistics.results ) {

    # We could do a histogram and density plot by the following
    # hist( statistics.results$differences )
    # plot( density( statistics.results$differences ) )
    # qqnorm( results$differences )
    # qqline( results$differences, col = 2 )
    # However ggplot2 is so much more customisable

    # ggplot can't use lists, so need to convert the results to a dataframe
    results <- data.frame( statistics.results$differences )
    # and rename
    names(results)[1] <- "differences"

    # Create QQ plot
    qq.plot <- ggplot( results , aes( sample=differences ) ) +
      stat_qq() +
      ylab( "Sample quantiles" ) +
      xlab( "Theoretical quantiles") +
      ggtitle("QQ plot of differences")

    # Calculates line for QQ Plot
    # Find the slope and intercept of the line that passes through the 1st and 3rd
    # quartile of the normal q-q plot
    y     <- quantile( results$differences , c(0.25, 0.75) , type=5 )  # Find the 1st and 3rd quartiles
    x     <- qnorm( c(0.25, 0.75) )                        # Find the matching normal values on the x-axis
    slope <- diff(y) / diff(x)                             # Compute the line slope
    int   <- y[1] - slope * x[1]                           # Compute the line intercept

    # Adds QQ Plot line
    qq.plot <- qq.plot + geom_abline( intercept=int , slope=slope , colour="red" )

    return(qq.plot)

    # END OF FUNCTION
}
