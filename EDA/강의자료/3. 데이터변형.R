###########################
### 2장 워크플로/기초######
###########################
1 / 200 * 30
#> [1] 0.15
(59 + 73 + 2) / 3
#> [1] 44.7
sin(pi / 2)
#> [1] 1

x <- 3 * 4
primes <- c(1, 2, 3, 5, 7, 11, 13)
primes * 2
#> [1]  2  4  6 10 14 22 26
primes - 1
#> [1]  0  1  2  4  6 10 12


this_is_a_really_long_name <- 2.5
this_is_a_really_long_name

r_rocks <- 2 ^ 3
r_rock
R_rocks

seq(1, 10)
#>  [1]  1  2  3  4  5  6  7  8  9 10


x <- "hello world"

y <- seq(1, 10, length.out=5)
y
(y <- seq(1, 10, length.out=5))

### 연습2.3.1_1
my_variable <- 10
my_varıable
#> Error in eval(expr, envir, enclos): object 'my_varıable' not found

### 연습2.3.1_2
#> libary(tidyverse)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

### 연습2.3.1_3
## 단축키 모음임.


########################
### 3장 데이터변형######
########################

#install.packages("nycflights13")
#install.packages("tidyverse")
library(nycflights13)
library(tidyverse)

flights
#nycflights13::flights

## 데이터셋 전체보기
View(flights)

### 3.2 filter( )  : 조건에 만족하는 행 필터링하기 
#%>% : 파이프연산자

#RStudio 에서는 Ctrl + Shift + M 를 눌러서 파이프를 입력할 수 있다.
data %>% 
  filter(x == 1) %>% 
  mutate(
    y = x + 1  # mutate( ) : 새로운 변수 계산.
  )
#해석: 데이터를 가져와서, 그 다음 필터를 하고, 그 다음 변형을 하라


# 2시간 이상 도착지연(arr_delay)인 항공편 필터하기 
flights  %>%  
  filter(arr_delay > 120)
#> # A tibble: 10,034 × 19


## 1월 1일 항공편
filter(flights, month == 1,  day == 1)
# Flights that departed on January 1

## 위와 동일 결과...
## & : and 연산자 사용.. 
flights  %>%  
  filter(month == 1 & day == 1) ## 서로 다른 변수에 대해
#> # A tibble: 842 × 19

### 결과를 저장하여 변수로 할당.. 파이프 연산자 사용하기
## 역시 동일 결과....
jan1 <- filter(flights, month == 1,  day == 1)
jan1

jan1 <- flights %>%  
  filter(month == 1 & day == 1)
jan1


## 12월 25일 항공편
(dec25 <- filter(flights, month == 12,  day == 25))
# A tibble: 719 x 19

#비교연산자: (주의) == 같다
filter(flights, month = 1)
## "="에러
filter(flights, month == 1)

sqrt(2) ^ 2

sqrt(2) ^ 2 == 2
# [1] FALSE
1 / 49 * 49

1 / 49 * 49 == 1
# [1] FALSE

## near() : 근사값 출력하는 함수 
### 컴퓨터는 무한대수를 저장할 수 없음. 
## 유한 정밀도 산술 결과가 출력... 따라서 근사값으로 출력
near(sqrt(2) ^ 2, 2)
near(1 / 49 * 49, 1)


#### 논리 연산자 
## 11월과 12월 출발한 항공편 모두 : & , and 연산자.
# Flights that departed on November or December
flights %>% 
  filter(month == 11 & month == 12)  ## 서로 같은 변수에 대해
# A tibble: 0 x 19

# 부등호는 동일변수 가능.
## 가장 연착했고, 출발은 대략 정시에 한 항공편?
flights  %>%  
  filter(dep_delay <= 10 & dep_delay >= -10) %>% 
  arrange(desc(arr_delay))
# A tibble: 239,109 × 19


### 위 예.... (앞부분)
flights  %>%  
  filter(month == 11 & day == 1) ## 서로 다른 변수에 대해

## 강의안 예제...
## 11월과 12월 출발한 항공편 모두 : | , or 연산자.
# Flights that departed in January or February
filter(flights, month == 11 | month == 12)

# %>% 파이프 연산자 사용
flights  %>%  
  filter(month == 11 | month == 12)
#> # A tibble: 55,403 × 19

########### 주의!!!!!
filter(flights, month == (11|12))
#### month 중에 11월 12월이 있으니까 결과가 TRUE
### TRUE는 논리형에서 1을 의미... 고로 1월만 필터링됨...에러
### A tibble: 27,004 x 19

## 왜 1인 될까?
a <- filter(flights, month == (11|12))
a$month 
unique(a$month)

# %>% 파이프 연산자 사용
## 위와 같은 결과..
flights  %>%  
  filter(month == (11 | 12))
### A tibble: 27,004 x 19
## 결과가 TRUE=1이므로 1월만 출력
### 1월만 찾음 ~~ 곤란!!


#### 이런 오류를 피하려면 유용한 팁은 바로 
#### 벡터 내 특정 값 포함 여부 확인 연산자 : 포함연산자
# x %in% y
#이 연산자는 x가 y에 있는 값들 중 어느 하나인 행을 모두 반환.
## 위와 동일 결과...
flights %>% 
  filter(month %in% c(11, 12))
#> # A tibble: 55,403 x 19
 
## 변수에 넣기 
(nov_dec <- flights %>% 
    filter(month %in% c(11, 12)))
# A tibble: 55,403 x 19


## (출발 혹은 도착에서) 두 시간 이상 지연되지 않은 항공편 찾기
## 드 모르간 법칙 적용해봄. 
filter(flights, !(arr_delay > 120 | dep_delay > 120))

flights  %>%  
  filter(!(arr_delay > 120 | dep_delay > 120))
# A tibble: 316,050 x 19

## 위와 결과가 같음. 
filter(flights, arr_delay <= 120, dep_delay <= 120)

flights  %>%  
  filter(arr_delay <= 120 & dep_delay <= 120)
# A tibble: 316,050 x 19


## 결측값 
NA > 5
#[1] NA
10 == NA
#[1] NA

### 주의!!!
### NA가 포함된 연산은 결과가 무조건 NA
NA + 10
#[1] NA
NA / 2
#[1] NA


# x를 메리의 나이라고 하자, 우리는 그녀가 몇 살인지 모른다.
x <- NA
# y를 존의 나이라고 하자. 우리는 그가 몇 살인지 모른다.
y <- NA
# 존과 메리는 같은 나이인가?
x == y
# 우린 모른다!
### NA가 포함된 연산은 결과가 무조건 NA

### 결과적으로, NA가 있는 데이터는 제거해 줘야 함....
## na.omit( ) : NA가 있으면 제거해라...
x <- NA

### is.na( ) : 값이 결측치 인지 확인하고 할때
is.na(x)

df <- tibble(x=c(1, NA, 3))
## x가 1이상인 행만....
filter(df, x > 1)

##결측값들은 남기려면 명시적으로 요청
df %>% 
  filter(is.na(x) | x > 1) 

### 3.3 arrange()로 행 정렬하기
## 변수로만 정렬가능.
## 디폴트== 오름차순으로 정렬됨.
arrange(flights, year, month, day)
### A tibble: 336,776 x 19

## desc( ) : 내림차순으로 정렬
arrange(flights, desc(dep_delay))


df <- tibble(x = c(5, 2, NA))
arrange(df, x)  ## 오름차순
arrange(df, desc(x))

### 3.4 select()로 열 선택하기
# 이름으로 열 선택
select(flights, year, month, day)
# A tibble: 336,776 x 3

# year과 day 사이의(경계 포함) 열 모두 선택
select(flights, year:day)
# A tibble: 336,776 x 3


# year에서 day까지의(경계 포함) 열들을 제외한 열 모두 선택
select(flights, -(year:day))
# A tibble: 336,776 x 16

# 문자인 모든 열을 선택하기.
flights %>% 
  select(where(is.character))


## 변수명 변경하기 
### 비추....
select(flights, tail_num = tailnum)
# A tibble: 336,776 x 1

## 방법1 : select() 대신 rename()
### 언급하지 않은 모든 변수를 유지
rename(flights, tail_num = tailnum)
# A tibble: 336,776 x 19

## 방법2 : select() + 도우미 함수 everything()
## 변수 순서 옮길 때 유용.
## 후반부에 위치한 변수 앞으로 옮기기 : time_hour, air_time
str(flights)
select(flights, time_hour, air_time, everything())
# A tibble: 336,776 x 19

# 교재없음.. pdf파일 참조..
# relocate() : 변수를 여기저기 이동
flights %>% 
  relocate(time_hour, air_time)

flights %>% 
  relocate(year:dep_time, .after = time_hour)

### 3.5 mutate()로 새로운 변수 추가하기

flights_sml <- 
  select(flights, 
         year:day,
         ends_with("delay"),  ## 'delay'로 끝나는 이름의 변수 모두 
         distance, 
         air_time)

flights_sml
# A tibble: 336,776 x 7


# gain : 연착 비행기가 비행 중에 얼마나 따라 잡았는지를 나타냄 
# speed : 시간당 마일단위 
mutate(flights_sml, 
       gain = dep_delay - arr_delay, ## 연착비행기가 얼마나 따라잡았는지? = 실제 출발시간- 실제 도착시간
       speed = distance / air_time * 60)  ## 속도= 운항 거리/비행시간 *60
# A tibble: 336,776 x 9

#str(flights_sml)
#view(flights_sml)


## %>% 연산자로 정리하면?
flights %>% 
  select(year:day, 
         ends_with("delay"),
         distance,
         air_time) %>%
  mutate(gain = dep_delay - arr_delay, 
         speed = distance / air_time * 60
  )

# 방금 생성한 열을 참조할 수 있습니다.
# hours = 이륙후 착륙전 까지의 시간/60
# gain_per_hour = 연착비행시간 / hours
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)
# A tibble: 336,776 x 10



###### 
flights
# A tibble: 336,776 x 19
## .before 인수 :맨 앞으로, 즉 왼쪽부터 새로운 변수 추가됨.
flights  %>%  
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1  # .before = 위치
  )
# A tibble: 336,776 x 21

## .after 인수 : 원하는 변수 뒤에 새로운 변수 추가
### 여기서는 day 변수 뒤에 추가됨.
flights %>%
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day  # .after = 변수 
  )
### A tibble: 336,776 x 21

## .keep = "used" : 새로운 변수 생성에 사용된 변수+추가된 변수만 출력.
flights %>%
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used" # 계산의 입력된 변수와 출력를 표시
  )
### A tibble: 336,776 x 6


## 교재..
# 새 변수만을 남기고 싶다면 transmute()를 사용
transmute(
  flights, 
  gain = dep_delay - arr_delay,   
  hours = air_time / 60,  
  gain_per_hour = gain / hours
)
# A tibble: 336,776 x 3
#> gain hours gain_per_hour
 


### 모듈러 연산 %/%, %%
# 예를 들어 항공편 데이터셋의 dep_time으로부터 hour와 minute을 다음과 같이 계산할 수 있습니다.
### 시간 + 분으로 쪼개짐...
transmute(
  flights, 
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100
)
# A tibble: 336,776 x 3


## 오프셋 : 벡터를 앞으로 당기거나(leading), 뒤로 미는(lagging) 것
(x <- 1:10)
lead(x)
lag(x)


## 누적 및 롤링 집계
## cumsum(): 누적합계
## cummean(): 누적평균
(x <- 1:10)
cumsum(x) 
cummean(x)


## 랭킹
y <- c(1, 2, 2, NA, 3, 4)
## rank() 행 순서출력: 동일한 값일 경우 같은 등수로 표기.
rank(y)


## min_rank() : 기본값에서 가장 작은 값이 가장 낮은 순서가 됩니다.
min_rank(y)

# 가장 큰 값을 가장 낮은 순서로 만들고 싶다면 desc()를 사용합니다.
min_rank(desc(y))

## 추가예
y <- c(1, 2, 2, NA, 3, 4)
## row_number() : 동일한 값이라도 고유한 순위를 부여
row_number(y)
#[1]  1  2  3 NA  4  5

# dense_rank) : 동일한 순위를 하나의 건수로 취급
dense_rank(y)
#[1]  1  2  2 NA  3  4

# 현재 행보다 작거나 같은 건수에 대한 누적백분율
cume_dist(y) 
# [1] 0.2 0.6 0.6  NA 0.8 1.0

# 상대적 백분위수 출력..
percent_rank(y)
# [1] 0.00 0.25 0.25   NA 0.75 1.00

## Cars93 데이터프레임의 가격(Price)를 기준으로 정렬(ordering)이 된 상태에서 동일한 개수를 가진 4개의 sub group으로 나누려고 할 때 ntile() 함수
 
library(MASS) 

Cars93_quartile <- 
  Cars93[ ,c("Manufacturer", "Model", "Type", "Price")] %>%   
  mutate(quartile = ntile(Price, 4))
 

## 3.6 summarize()로 그룹화 요약하기

summarise(flights, 
          delay = mean(dep_delay, na.rm = TRUE))
#하나의 행으로 축약

## group_by() + summarise()
# 날짜로 그룹화된 데이터프레임에 정확히 같은 코드를 적용하면 날짜별 평균 지연시간이 나옵니다.
by_day <- group_by(
  flights, year, month, day)
by_day 

#날짜별 평균 지연시간(dep_delay)
summarise(by_day, 
          delay = mean(dep_delay, na.rm = TRUE))


# 각 위치에 대해 거리와 평균 지연 사이에 관계를 탐색하고 싶다면? 
# 세 단계로 이 데이터를 전처리합니다.
# 1. 목적지별(dest)로 항공편을 그룹화.
# 2. 항공편 수, 거리, 평균 도착 지연시간을 계산하여 요약.
### 기존 방식..
by_dest <- group_by(flights, dest)
# A tibble: 336,776 x 19
delay <- 
  summarise(by_dest,
            # 항공편수 
            count = n(), 
            # 평균거리
            dist = mean(distance, na.rm = TRUE), 
            # 평균 도착 지연시간
            delay = mean(arr_delay, na.rm = TRUE)  
)
delay
# A tibble: 105 x 4

# 3. 잡음이 많은 점과 호놀룰루 공항(다음으로 먼 공항보다 거의 두 배가 먼 공항)을 제거하는 필터링.
delay <- filter(delay, count > 20, dest != "HNL")
delay

## 실제 count > 20인지 체크해봄.
arrange(delay, count)

# 지연시간은 거리에 따라 750마일까지는 증가하다가 감소하는 것 같습니다.
# 항로가 길수록 비행 중에 지연시간을 만회할 여력이 더 있는 것인가? 
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


### %>% 연산자 이용시
# 그룹화하고, "그다음" 요약하고, "그다음" 필터링하라...
# %>% : "그다음"으로 읽는 것이 좋다. 
delays <- flights %>% 
  group_by(dest) %>%  # 그룹화
  summarise(          # 요약하고   
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")  #필터링...


##### 결측값
# na.rm 인수를 설정하지 않으면 결측값이 많이 생깁니다.
## 결측값이 제거되기 전... 결과는 모두 NA
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))


## 결측값이 제거된 후에야 계산이 됨...
## na.rm = TRUE
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))


### 취소된 항공편 제거한 데이터셋 만들기
# dep_delay/arr_delay = 실제 출발/도착 시간 결측치 제거
not_cancelled <- 
  flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))


#### 카운트 : n()
# 예를 들어 평균 지연시간이 가장 긴 항공기(꼬리 번호(tail number)로 식별)로 봅시다. 
# 어떤 항공기들은 평균 5시간(300분)이 지연된 걸 알 수 있습니다.
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
delays

## 평균 도착 지연시간이 가장 긴 항공사 번호 체크하기
arrange(delays, desc(delay))# N844MH


ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
# 비행이 적을 때 평균지연시간에 변동이 훨씬 더 크다. 


## 비행 횟수 대 평균 지연시간의 산점도
delays <- 
  not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE), # 평균지연시간
    n = n()    # 비행횟수 : 그룹크기 
  )
delays

## 평균 대 그룹 크기의 플롯을 그리면 표본의 크기가 커짐에 따라 변동이 줄어드는 것을 볼 수 있습니다. 
ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)


# 이를 수행하는 다음 코드는 ggplot2를 dplyr 플로에 통합하는 편리한 패턴도 보여줍니다.
delays %>% 
  filter(n > 25) %>%  # 필터링
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)


#########################
### Lahman 패키지 데이터
#########################
### 타자의 평균 능력치가 타석 수와 어떻게 관련되었는?
### 야구 선수의 타율(ba로 계산) = 안타수(H)합계/유효타석수(AB)합계
library(Lahman)
batting <- as_tibble(Lahman::Batting)

# playerID : 플레이어 ID 코드
# H : 안타(Hits)
# AB : 유효타석수
batters <- 
  batting %>% 
  # playerID 별로 그룹화하고
  group_by(playerID) %>% 
  # 요약하기 
  summarise(
    # ba : 야구 선수의 타율
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE), 
    # ab : 볼(안타)을 칠 기회횟수  
    ab = sum(AB, na.rm = TRUE) 
  )

batters

batters %>% 
  filter(ab > 100) %>%  # 안타칠기회수>100
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)


#단순히 desc(ba)로 정렬하면 평균 타율이 가장 높은 선수는 능력치가 좋은 것이 아니라 단순히 운이 좋은 선수들입니다.
batters %>% 
  arrange(desc(ba))


#### 유용한 요약 함수
## 위치측정값 
# 평균 : mean(x)
# 중앙값 : median(x)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    # 도착지연시간의 평균
    avg_delay1 = mean(arr_delay),
    # 도착지연시간이 양수인 경우만
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

 
# 산포 측정값: sd(x), IQR(x), mad(x)
# mad(x) : 중위절대편차
# 왜 어떤 목적지는 그곳까지의 거리가 다른 곳보다 더 변동성이 있는가?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# 순위 측정값 min(x), quntile(x, 0.25), max(x)
# quntile(x, 0.25) : 분위수
# 각 날짜의 처음과 마지막 항공편은 언제 출발하는가?
# dep_time : 실제 출발시간
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time),
    quartile_1 = quantile(dep_time, 0.25),  # 제 1사분위수
    mean = mean(dep_time),                  # 평균
    quartile_3 = quantile(dep_time, 0.75)   # 제 3사분위수 
  )

# 자리(position) 측정값 first(x), nth(x, 2), last(x)
# 각 날짜에 처음과 마지막 출발을 찾을 수 있습니다.
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

# min_rank() : 순위 index 반환... 동일값에 대해서는 '1,1,1,4,4,...'처리됨.
# range() : 최소값, 최대값 반환
not_cancelled %>% 
  group_by(year, month, day) %>%    # 그룹화하고,
  mutate(r = min_rank(desc(dep_time))) %>%  
  filter(r %in% range(r))           # 최소랭크, 최대랭크인 행만 필터링하기


#### 비교해 보기
aa <- not_cancelled %>% 
  group_by(year, month, day) %>%    # 그룹화하고,
  mutate(r = min_rank(desc(dep_time)))
aa 
# A tibble: 327,346 x 20


bb <- not_cancelled %>% 
  group_by(year, month, day) %>%    # 그룹화하고,
  mutate(r = min_rank(desc(dep_time))) %>%  
  filter(r %in% range(r))
bb
# A tibble: 770 x 20
# view(bb)
########################     


### 카운트 : n(), sum(!is.na(x)) , n_distinct(x)
# n() 인수가 없고 현재 그룹의 크기를 반환
# sum(!is.na(x)) 결측이 아닌 값의 수를 카운트
# n_distinct(x) 유일값 개수를 카운트
# 어느 목적지(dest, 도착공항)에 항공사(carrier)가 가장 많은가?
not_cancelled %>% 
  group_by(dest) %>% # 도착공항 별로 그룹화하기
  summarise(
    count = n(), # 현재인수인 dest그룹의 카운트, 목적지인 도착공항 빈도  
    carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

# 단순히 카운트만 원할 경우
not_cancelled %>% 
  count(dest)


# 항공기가 비행한 마일 수를 ’카운트(합)’
not_cancelled %>% 
  count(tailnum, wt = distance)


#### 논리형 값의 카운트와 비율 : sum(x > 10), mean(y == 0)
# 수치형 함수를 사용할 경우 TRUE=1로 FALSE=0으로
# sum(x)는 TRUE의 개수를, 
# mean(x)은 비율을 제공합니다.

# 아침 5시 이전 출발하는  항공편은 몇 편인가?
# (보통 전날 지연된 경우)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# 한 시간 이상 지연된 항공편의 비율은?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))

## 교재없음.. 이전 버전 pdf파일 참조..
# 데이터프레임을 다중변수로 그룹화할 수 있다:
daily <- flights %>% 
  group_by(year, month, day)
daily
# A tibble: 336,776 × 19

# 다중변수로 그룹화하면, 기본적으로 각 요약함수는 그룹의 한 수준을 벗겨내고 이 동작을 바꾸는 법을 출력한다.
daily %>% 
  summarise(
    n = n()
  )
# A tibble: 365 × 4

# 이러한 동작에 만족한다면, 메세지를 없애기 위해 명시적으로 정의할 수 있다:
daily %>% 
  summarise(
    n = n(), 
    .groups = "drop_last"
  )

# 다른 방법으로는, 이러한 기본동작을 다른 값을 설정하여 바꿀 수 있다. 예를 들어 "drop" 은 그룹의 모든 수준을 풀고 "keep" 은 daily 와 같은 그룹화 구조가 유지된다:
daily %>% 
  summarise(
    n = n(), 
    .groups = "drop"
  )
daily %>% 
  summarise(
    n = n(), 
    .groups = "keep"
  )

#### 다시 교재로 
### 여러 변수로 그룹화
daily <- 
  group_by(
    flights, year, month, day)
daily 
# A tibble: 336,776 x 19

## 일단위
(per_day   <- summarise(daily, flights = n()))
# A tibble: 365 x 4

## 월단위
(per_month   <- summarise(per_day, flights = sum(flights)))
# A tibble: 12 x 3

## 연단위
(per_year   <- summarise(per_month, flights = sum(flights)))
# A tibble: 1 x 2


### 그룹화 해제
daily %>% 
  ungroup() %>%             # date 기반 그룹화 해제
  summarise(flights = n())  # 모든 항공편


### 3.7 그룹화 뮤테이트(와 필터링)
# group_by() + mutate()와 filter()조합

# 각 그룹에서 최악의 멤버들을 찾아봅시다.
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
# A tibble: 3,306 x 7


# 기준값보다 큰 그룹을 모두 찾아봅시다.
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests
# A tibble: 332,577 x 19


# 그룹별 척도를 위해 표준화해봅시다.
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)
# A tibble: 131,106 x 6