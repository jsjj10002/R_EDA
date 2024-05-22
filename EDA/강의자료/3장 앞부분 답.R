#### 3.2.4 연습문제
# 1. 다음 조건을 만족하는 항공편을 모두 찾아라

library(nycflights13)
library(tidyverse)

flights
# A tibble: 336,776 x 19
## 데이터셋 전체보기
View(flights)
str(flights)

#a. 2시간 이상 도착지연.

flights %>% 
  filter(arr_delay>=120)
# A tibble: 10,200 x 19

#b. 휴스턴(IAH or HOU)으로 운항.
flights %>% 
  filter(dest=="IAH"| dest=="HOU")

flights %>% 
  filter(dest %in% c("IAH","HOU"))
# A tibble: 9,313 x 19
 
#c. 유나이티드항공(United), 아메리칸항공(American), 델타항공(Delta)이 운항.
unique(flights$carrier)
flights %>% 
  filter(carrier=="UA"| carrier=="AA" |carrier=="DL")

flights %>% 
  filter(carrier %in% c("US", "UA", "DL"))
# A tibble: 139,504 x 19

#d. 여름(7,8,9월)에 출발
flights %>% 
  filter(month==7| month==8 |month==9)

flights %>% 
  filter(month %in% c(7, 8, 9))
# A tibble: 86,326 x 19

#e. 2시간 이상 지연도착했지만, 지연출발하지는 않음.
 
flights$dep_delay
flights %>% 
  filter(arr_delay>=120 & dep_delay<=0)
# A tibble: 29 x 19



#f. 최소 한 시간 이상 지연출발했지만 운항 중 30분 이상 단축
flights$sched_arr_time - flights$arr_time
mutate(flights, short_30 = sched_arr_time - arr_time)
# A tibble: 336,776 x 20

flights %>% 
  mutate(short_30 = sched_arr_time - arr_time) %>% 
  filter(dep_delay>=60 & short_30>=30)
# A tibble: 4,608 x 20

#g. 자정과 6am(포함)사이에 출발.
#실제출발: dep_time
#예정출발: sched_dep_time
flights$sched_dep_time
summary(flights$dep_time)
summary(flights$sched_dep_time)

#실제출발: dep_time
flights %>% 
  filter(dep_time>=0 | dep_time<=600)
# A tibble: 328,521 x 19... 맞지 않음..

flights %>% 
  filter(dep_time<=600)
# A tibble: 8,730 x 19

#예정출발: sched_dep_time
flights %>% 
  filter(sched_dep_time<=600)
# A tibble: 8,970 x 19



#### 3.3.1 연습문제
library(nycflights13)
library(tidyverse)

flights
# A tibble: 336,776 x 19
## 데이터셋 전체보기
View(flights)
str(flights)


#1. arrange()를 사용하여 모든 결측값을 앞에 오도록 정렬하라(힌트:is.na()를 사용하라.)

is.na(flights)
sum(is.na(flights))

flights %>% 
  arrange(desc(is.na(flights)))
# A tibble: 336,776 x 19

#2. flights를 정렬하여 가장 지연된 항공편을 찾아라. 가장 일찍 출발한 항공편을 찾아라.
# arrange() + select()

flights %>% 
  arrange(desc(dep_delay)) 

flights %>% 
  arrange(desc(dep_delay)) %>% 
  select(dep_delay, carrier, everything())
## HA

flights %>% 
  arrange(dep_time) %>% 
  select(dep_time, carrier, everything())
## B6


#3. flights를 정렬하여 가장 속력이 빠른 항공편을 찾아라. 

flights %>% 
  select(carrier, year:day, ends_with("delay"), distance,air_time 
  ) %>% 
  mutate(
    speed = distance / air_time * 60, .before = 1) %>%  
  arrange(desc(speed))
## DL

flights %>%  
  mutate(
    speed = distance / air_time * 60, .before = 1) %>%  
  arrange(desc(speed))

#4. 어떤 항공편이 가장 멀리 운항했는가? 가장 짧게 운항한 항공편은? 

flights %>% 
  select(carrier, year:day, distance, air_time 
  ) %>% 
  arrange(desc(distance)) 
## HA


flights %>% 
  select(carrier, year:day, distance, air_time 
  ) %>% 
  arrange(distance) 
## EV

#### 3.4.1 연습문제

#1. flights에서 dep_time, dep_delay, arr_time, arr_delay를 선택할 수 있는, 가능한 모든 방법에 대해 브레인스토밍하라.
flights %>% 
  select(dep_time, dep_delay, arr_time, arr_delay)

flights %>% 
  select(dep_time, dep_delay, arr_time, arr_delay, everything())

flights %>% 
  select(ends_with(c("time", "delay")))

flights %>% 
  select(contains(c("time", "delay")))


#2. select() 호출에서 한 변수 이름을 여러 번 포함하면 어떻게 되는가?
#num_range("x", 1:3) x1, x2, x3에 매칭

x1 <- c(rep(1, 10))
x2 <- c(rep(1:2, 5))
x3 <- c(rep(1:5, 2))
df <- data.frame(x1, x2, x3)
df_t <- as_tibble(df)

df_t %>% 
  select(num_range("x", 1:3)) 

#3. one_of() 함수는 어떤 일을 하는가? 다음의 벡터와 함께 사용하면 도움이 되 는 이유는 무엇인가?
vars  <-  c("year", "month", "day", "dep_delay", "arr_delay")

flights %>% 
  select(one_of(vars))


#4. 다음 코드의 실행 결과는 예상과 같은가? 주어진 선택 도우미(select helpers) 는 기본적으로 이 경우를 어떻게 다루는가? 이 기본값 설정을 어떻게 바꾸겠는가?
  
select(flights, contains ("TIME"))


#### 3.5.2 연습문제

#1. 현재 dep_time과 sched_dep_time은 보기 편하지만 실제 연속형 숫자가 아니기 때문에 이들을 가지고 계산하기는 쉽지 않다. 이들을 편리한 표현식인 자정 이후 분으로 변환하라.

# dep_time
flights %>% 
transmute(
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100,
  sched_dep_time, 
  sched_hour = dep_time %/% 100,
  sched_minute = dep_time %% 100,
)

#2. air_time와 arr_time- dep_time을 비교하라. 무엇이 나올지 예상해보라. 무엇이 나왔는가? 문제를 해결하기 위해 어떻게 해야 하는가?

# air_time: 이륙후 착륙전 까지의 시간
# dep_time/arr_time :실제 출발/도착 시간 (로컬타임 적용)
flights %>% 
  transmute(
    air_time, 
    arr_time, dep_time,
    time = arr_time - dep_time)

#3. dep_time, sched_dep_time, dep_delay를 비교하라. 이 세 숫자가 어떻게 연결 되었겠는가?
flights %>% 
  transmute(
    dep_time, 
    sched_dep_time,
    dep_delay)


#4. 랭킹 함수를 사용하여 가장 지연된 10개의 항공편을 찾아라. 동점을 어떻게 하고 싶은가? min_rank()의 설명서를 주의 깊게 읽어라.

flights %>% 
  select(
    dep_delay, arr_delay, carrier
  ) %>% 
  mutate(
    gain = dep_delay - arr_delay,
    rank = min_rank(gain),
    desc_rank = min_rank(desc(gain))
  ) %>% 
  arrange(desc(gain))  %>% 
  head(10) 


#5. 1:3 + 1:10은 무엇을 반환하는가? 이유는?

1:3 + 1:10

#6. R에는 어떤 삼각함수들이 있는가?
  
  