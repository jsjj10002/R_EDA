##Chapter 1. 데이터 시각화

## 준비하기
#install.packages("tidyverse")
library(tidyverse)

## mpg 데이터프레임
ggplot2::mpg
?mpg

## ggplot 생성하기
#install.packages(c("ggplot2", "plyr"))
library(ggplot2)

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy))


## 연습1.2.4
ggplot(data = mpg)+ 
geom_point(mapping = aes(x = hwy, y = cyl))

## 연습1.2.5
ggplot(data = mpg)+ 
geom_point(mapping = aes(x = class, y = drv))

## 심미성 매핑
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

## 색깔로 구분: class
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
## 이상갑 다수가 2인승차임..

## 점의 크기로 구분: size
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

## 점의 투명도로 구분: alpha 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

## 점의 모양으로 구분: shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
## 한번에 6개의 모양만 처리됨.

## 속성 수동 설정.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), 
             color = "blue")
## 플롯 외양만 변경
## 변수에 대한 정보 전달 없음.


## 연습 1.3.1
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, color = "blue"))

## 연습 1.3.3
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, shape = class, color = cty, size = trans))

## 연습 1.3.4
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy), color = 'blue', size = 3)


## 연습 1.3.5
## stroke : 획두께..
?geom_point
ggplot(data = mpg) +
  geom_point( mapping = aes(x = displ, hwy), shape = 0, stroke = 5, color = "black", fill = "white", size = 5) 


## 연습 1.3.6
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 6))

## 면분할: Facets
## 각 서브셋을 표시하는 하위플롯으로 나뉘도록...

## 면분할: 이산형 변수로... 
## facet_wrap
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow =2)   

## facet_grid ~ : 두 변수 조합으로 면분할
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)  


## facet_grid ~ : . 면분할 원하지 않을때...
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +       
  facet_grid(. ~ cyl)

## 위와 동일..
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +       
  facet_wrap( ~ cyl, nrow = 1)


## 연습 1.5.1
str(mpg)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cyl, nrow = 1)

## 연습 1.5.2
## geom_point : 산점도니까...
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(dvr ~ cyl)

## 연습 1.5.3
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)



## 연습 1.5.4
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = 'green') + 
  facet_wrap(~ class, nrow = 2)

?facet_wrap
dim(mpg)  #차원반환
length(mpg)   #길이반환

## 1.6 기하 객체

## 산점도
## geom_point함수 + mapping 인수 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) 

## 추세선
## geom_smooth함수 + mapping 인수 
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

## geom_smooth함수 + mapping 인수 + linetype 인수 
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

## 두개의 geom 동시에....
## geom_point함수 + mapping 인수 
## geom_smooth함수 + mapping 인수  
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(linetype = drv))


## geom_smooth함수 + mapping 인수 + group 인수   
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

## geom_smooth함수 + mapping 인수 + color 인수 + show.legend 인수
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), 
              show.legend = FALSE)

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), 
              show.legend = TRUE)

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv))


## 여러개의 지옴 함수 동시 사용시 중복문제....
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

## 아래처럼 전역매핑으로 한번만 가능함. 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

## 서로 다른 심미성 표현 가능함. 
## geom_point함수에만 mapping = 인수에 color 만 가능함.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth() 


## 같은 원리로 레이어마다 서로 다른 데이터 지정 가능함. 
## geom_point함수에만 mapping = 인수에 color 설정.
## geom_smooth함수에는 class == "subcompact"만 조건 설정 가능함.
library(ggplot2)
library(dplyr)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)    ## filter() 은 다음 장에.. 원하는 행만 선택..

## se = TRUE? 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = TRUE) 

## 연습 1.6.2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

## 연습 1.6.5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))


## 1.7 통계적 변환
?diamonds
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

?geom_bar
## 스탯 : 통계 계산 알고리즘
## stat_count() 같은 페이지...
## Computed variables
## stat(count) + stat(prop)
## 지옴과 스탯을 서로 바꿔서 사용할 수 있다.
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))


demo <- tribble( 
  ~cut, ~freq, 
  "Fair", 1610, 
  "Good", 4906, 
  "Very Good", 12082,
  "Premium", 13791, 
  "Ideal", 21551 )

## geom_bar함수 + stat 인수 "identity"
## y변수의 데이터 원값.
ggplot(data = demo) + 
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

## geom_bar함수 + stat(prop)
## y변수의 비율..
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))


## stat_summary함수 + mapping 인수
?stat_summary
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median)

## 연습 1.7.5
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..)) 

## 1.8 위치 조정
## geom_bar함수 + color 인수 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, color = cut))

## geom_bar함수 + fill 인수
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

## 막대 누적..
## fill = clarity
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))


## geom_bar함수 + position 인수
## position = "identity"
## alpha추가
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

## fill = NA
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) +   geom_bar(fill = NA, position = "identity")

## geom_bar함수 + position 인수
## position = "fill"
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity), position = "fill")

## geom_bar함수 + position 인수
## position = "dodge"
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

## 오버플로팅
## 격자 위에 많은 점이 서로 겹쳐 있음.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

## 오버플로팅 피하려면?
## position = “jitter
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")


## 연습 1.8.1
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()

## 1.9 좌표계
## coord_flip() : 수평박스 
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()


## 여러가지 옵션 추가.
bar <- ggplot(data = diamonds) +   geom_bar(
  mapping = aes(x = cut, fill = cut), 
  show.legend = FALSE,
  width = 1) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()

## coord_polar()
## Coxcomb차트 : 장미 차트.
bar + coord_polar()

