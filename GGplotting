library(ggplot2)
install.packages("patchwork")
library(patchwork)
newsense<-subset(sense2, sample==1|sample==2)
wilcox.test(scorec~sample, data = sense, exact=FALSE) #dependent var~sample designation

aggregate(scorem~sample, data = sense2, FUN = function(x) c(mean=mean(x), sd=sd(x), freq=length(x), med=median(x), iqr=IQR(x)))

scoreb.labs <- c("None", "1-5", "6-10", "11-20", "21-30", "21-30", "30+")
names(scoreb.labs)<-c("1","2", "3", "4", "5", "6")

d<-ggplot(sense, aes(x=factor(sample), y=scored)) +
  geom_violin(aes(fill = factor(sample)), colour="black") +
  geom_boxplot(width=0.1, fill="white", outlier.colour = "white")+
  ggtitle("Not Turn in an Assignment")+
  #ylim(0,4)+
  labs(x="", y="")+
  theme_bw()+
  #theme(axis.text.x = element_text(angle = -30, vjust = 1, hjust = 0, face = "bold", size = 12))+
  theme(plot.title = element_text(face="bold"))+
  theme(legend.position = "none")+
  
