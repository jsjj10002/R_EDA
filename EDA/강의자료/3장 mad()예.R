dt1 <- c(1,2,3,4,5,6,7,8,9,10)
dt2 <- c(1,2,3,4,5,6,7,8,9,100)

mad(dt2)
sd(dt2)
IQR(dt2)
dt_dev <- c(mad(dt1),mad(dt2),
            sd(dt1), sd(dt2),
            IQR(dt1), IQR(dt2))
names(dt_dev) <- rep(c("dt1","dt2"),3)


barplot(dt_dev, beside=T,
        col=c("red","red","blue","blue","green","green")) 
legend("topleft",
  legend = c("MAD", "sd", "IQR"), fill = c("red","blue","green"), cex=1.2
)
