require(ggplot2)
require(dlstats)
x <- cran_stats("changepoint")
head(x)
tail(x)

ggplot(x, aes(end, downloads, group = package, color=package)) +
  geom_line() + geom_point(aes(shape=package))
