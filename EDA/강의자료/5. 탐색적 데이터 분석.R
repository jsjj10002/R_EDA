#################################
### 5장 탐색적 데이터 분석 ######
#################################

#install.packages("tidyverse")
library(tidyverse)

# 5.3.1 분포 시각화
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>%
  count(cut)

# carat : 무게(0.2–5.01)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

# dplyr::count()와 ggplot2::cut_width()를 결합하면 값을 직접 계산할 수 있다.

diamonds %>%
  count(cut_width(carat, 0.5)) 


# 예를 들어 3캐럿 미만의 다이아몬드로 범위를 줄이고 
# 더 작은 빈 너비를 선택하는 경우
# 3캐럿 미만의 다이아몬드 +  binwidth : 간격의 폭
smaller <- diamonds %>%
  filter(carat < 3)

diamonds %>%
  filter(carat < 3) %>% 
  ggplot(
    mapping = aes(x = carat)
    )+
  geom_histogram(binwidth = 0.1)

ggplot(dat = smaller, mapping = aes(x = carat)) +
  geom_freqpoly(binwidth = 0.1)


# 여러 개의 히스토그램을 겹쳐서 그리고 싶다면? 
# geom_freqpoly() 
ggplot(dat = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)


# 5.3.2 일반적인 값

## binwidth = 0.01
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)


# 아래 히스토그램은 Yellowstone 국립공원의 Old Faithful Geyser(올드 페이스풀 간헐 온천)에서 발생한 272번의 화산 분출을 분 단위로 나타낸 것이다. 

ggplot(data = faithful, 
       mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)


# 짧은 분출(약 2분)과 긴 분출(4-5분)이 있고, 그 중간에는 값이 거의 없기 때문에 분출 시간은 2개의 그룹으로 묶인 것처럼 보인다.


## 5.3.3 이상값
# 이상값? 패턴과 맞지 않는 데이터 값으로 비정상적인 관측값.

# 예를 들어 다이아몬드 데이터셋에서 y변수의 분포를 그리는 경우, 이상값의 유일한 단서는 y축의 범위가 매우 넓다는 것이다.
ggplot(diamonds) + 
  geom_histogram(
    mapping = aes(x = y), 
    binwidth =  0.5)


# 이상값들을 쉽게 확인하기 하려면? 
# coord_cartesian() : y축의 작은 값들을 확대가능.
ggplot(diamonds) +
  geom_histogram(
    mapping = aes(x = y), 
    binwidth = 0.5) +
  coord_cartesian(
    ## ylim 인수  : y축의 작은 값
    ylim = c(0, 50) 
    )

unusual <- diamonds %>%
  # 세 개의 이상값은 0,~30 및 ~60 근방의 값 필터.
  filter(y < 3 | y > 20) %>%
  select(price, x, y, z) %>%
  arrange(y)
unusual


# 5.4 결측값

#이상값이 포함된 행 전체를 삭제: 비추
# filter() + between()
diamonds2 <- diamonds %>%
  filter(between(y, 3, 20))


# 이상값을 결측값으로 변경
# mutate()
diamonds2 <- diamonds %>%
  mutate(y < 3 | y > 20, NA, y)
diamonds2

diamonds2 <- diamonds %>%
  mutate(y= ifelse(y < 3 | y > 20, NA, y))
diamonds2


### 결측치가 데이터 내에 있는 경우 경고메시지.
# 연속형 변수 : geom_point()
ggplot(
  data = diamonds2, 
  mapping = aes(x = x, y = y)) +
  geom_point()


# 경고 표시를 숨기려면, na.rm = TRUE
ggplot(
  data = diamonds2, 
  mapping = aes(x = x, y = y)) +
  # na.rm = TRUE
  geom_point(na.rm = TRUE)


## 결측값과 기록된 값의 차이 비교.
## 예를 들어 취소된 비행기의 예정 출발 시각과 취소되지 않은 비행기의 출발 시각을 비교하고자 한다. 
# is.na()를 사용하여 새로운 변수를 생성
nycflights13::flights %>%
  mutate(
    # 취소된 비행기의 예정 출발 시각
    cancelled = is.na(dep_time),
    # sched_dep_time : 취소되지 않은 비행기의 출발 시각
    sched_hour = sched_dep_time %/% 100,# 시간
    sched_min = sched_dep_time %% 100,# 분
    sched_dep_time = sched_hour + sched_min / 60
  ) %>%
  ggplot(
    mapping = aes(sched_dep_time)) +
  geom_freqpoly(
    mapping = aes(color = cancelled),
    binwidth = 1/4
  )


# 5.5 공변동

# "범주형 변수로 구분된 연속형 변수의 분포"
# geom_freqpoly()
# 컷팅(cut, 품질)에 따른 다이아몬드의 가격(price) 분포

ggplot(
  data = diamonds, 
  mapping = aes(x = price)) +
  geom_freqpoly(
    mapping = aes(color = cut), binwidth = 500)


ggplot(diamonds) +
  geom_bar(
    mapping = aes(x = cut))


# 빈도수로 나타내는 대신 빈도 다각형 아래의 영역이 1이 되도록...
## y = ..density..
ggplot(
  data = diamonds,
  mapping = aes(x = price, y = ..density..)
) +
  geom_freqpoly(
    mapping = aes(color = cut),
    binwidth = 500)



# geom_boxplot()을 사용하여 컷팅에 따른 가격 분포
# cut 변수 : 순서가 있는 팩터형 변수
ggplot(
  data = diamonds, 
  mapping = aes(x = cut, y = price)) +
  geom_boxplot()



# 자동차 종류(class)에 따라 고속도로 주행 거리(hwy)
ggplot(
  data = mpg, 
  mapping = aes(x = class, y = hwy)) +
  geom_boxplot()


# 추세를 더욱 쉽게 파악하기 위해 hwy 변수의 중간값을 기준으로 class 변수의 순서를 변경 
# reorder()함수 : 순서 변경 
## ? reorder
# reorder(변수 , 기준변수, FUN= mean)
ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median), 
      y = hwy
    )
  )


# 변수의 이름이 긴 경우 
# coord_flip() : geom_boxplot() 90° 회전, 수평으로 상자그림 
ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    )
  ) +
  coord_flip() # 90° 회전, 옆으로 


# 5.5.2 두 개의 범주형 변수
# 컷팅(cut)에 따른 색상(color) 분포
ggplot(data = diamonds) +
  geom_count(
    mapping = aes(x = cut, y = color))
# 원의 크기는 각 값의 조합에서 발생한 관측값의 수
# 특정 x값과 y값 사이에 강한 상관관계


# 색상(color), 컷팅(cut)별로 빈도수 
diamonds %>%
  count(color, cut)


# geom_tile() 함수+ fill 심미성 
diamonds %>%
  count(color, cut) %>%
  ggplot(
    mapping = aes(x = color, y = cut)
    ) +
  geom_tile(mapping = aes(fill = n))


# 5.5.3 두 개의 연속형 변수

# 산점도 : geom_point()
# 캐럿의 크기(carat)와 다이아몬드의 가격(price)간의 관계
ggplot(data = diamonds) +
  geom_point(
    mapping = aes(x = carat, y = price))
## 덜 유용해 보임..

# 투명도 추가 : alpha 심미성
# geom_point() + alpha  
ggplot(data = diamonds) +
  geom_point(
    mapping = aes(x = carat, y = price),
    alpha=1/100
  )


# 캐럿의 크기(carat)와 다이아몬드의 가격(price)간의 관계
smaller <- diamonds %>%
  # 3캐럿 미만의 다이아몬드
  filter(carat < 3)   

ggplot(data = smaller) +
  geom_bin2d(
    mapping = aes(x = carat, y = price))

# geom_hex()를 사용하기 위해서는 hexbin 패키지를 설치해야 한다.
# install.packages("hexbin")
library(hexbin)
ggplot(data = smaller) +
  geom_hex(
    mapping = aes(x = carat, y = price))


# carat 변수를 그룹화한 후, 각 그룹에 대해 박스 플롯
# cut_width(x, width) : x를 width로 나눔
ggplot(
  data = smaller, 
  mapping = aes(x = carat, y = price)
  ) +
  geom_boxplot(
    mapping = aes(group = cut_width(carat, 0.1)))


# cut_number()를 사용하면 된다.
ggplot(
  data = smaller, 
  mapping = aes(x = carat, y = price)) +
  geom_boxplot(
    mapping = aes(group = cut_number(carat, 20)))

# 5.6 패턴과 모델

# Old Faithful 분출 시간과 분출 사이의 시간 사이의 산점도
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))

#install.packages("modelr")
library(modelr)

# 캐럿의 크기(carat)와 다이아몬드의 가격(price)간의 관계
mod <- lm(log(price) ~ log(carat), data = diamonds) # 모델

diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid = exp(resid))

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))


# 커팅과 가격의 상관관계
ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))

# 5.7 ggplot2 표현
# Old Faithful 분출 시간
ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_freqpoly(binwidth = 0.25)

#위의 플롯을 좀 더 간결하게 작성하면..
ggplot(faithful, aes(eruptions)) +
  geom_freqpoly(binwidth = 0.25)


diamonds %>%
  count(cut, clarity) %>%
  ggplot(aes(clarity, cut, fill = n)) + 
  geom_tile()

