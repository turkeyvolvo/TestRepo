#additional EDA Script
par(mfrow=c(2,2))
plotCorFunc <- function(x){
  for (i in (x)){
  plot(x$i,xaxt="n", yaxt="n", pch=19,col="blue")
  axis(1, labels = Names2, at=1:6, las=2, col="blue")
  axis(2, ylab="Correlation", col = "blue")
  
  }
}

plot(AEPICorNumbers, xaxt="n", pch=19,col="blue")
axis(1, labels = Names2, at=1:6, las=2, col="blue")