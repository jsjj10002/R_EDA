install.packages("tidyverse")
library(tidyverse)
###1.5 facet-면분할
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_wrap(~ class, nrow=2) #행의 수= 2, 이산형 변수여야함,변수하나

#두 변수 조합으로 면분할- facet_grid
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_grid(drv ~ cyl) #두 개의 범주형 범주 ,왼쪽 y축, 오른쪽 X축 
# 변수 하나 에서 열이나 행으로 면분할 하고싶지 않을때 
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_grid(. ~ class)  
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_grid(class ~ .)

str(mpg)
###연습문제
#1 연속형도 가능
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_grid(. ~ hwy)
#2 산점도는기본 연속형             
ggplot(mpg)+
    geom_point(mapping= aes(x=drv, y=cyl))+
    facet_grid(drv ~ cyl)
#3
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_grid(drv ~ .)

ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy))+
    facet_grid(. ~ drv)

#4
ggplot(mpg)+
    geom_point(mapping= aes(x=displ, y=hwy), color="green")+
    facet_wrap( ~ class, nrow = 2)

#5
?facet_wrap


###1.6 기하객체 geom_smooth-추세선

ggplot(mpg)+
    geom_smooth(mapping = aes(x=displ, y = hwy, linetype =drv)) #선의 유형 설정가능, 모양은설정불가

#여러개 지옴함수 동시에 그리기
ggplot(mpg)+
    geom_smooth(mapping = aes(x=displ, y = hwy, linetype =drv))+
    geom_point(mapping=aes(x=displ, y = hwy , color =drv))

#범주 
ggplot(mpg)+
    geom_smooth(mapping = aes(x=displ, y = hwy, color =drv), show.legend = T)


#전역매핑
ggplot(mpg, mapping = aes(x=displ, y = hwy))+
    geom_smooth()+
    geom_point(mapping= aes(color=class))

ggplot(mpg, mapping = aes(x=displ, y = hwy))+
    geom_point(mapping= aes(color=class))+
    geom_smooth(data=filter(mpg,class=="compact"),se=T)
