#install.packages("tidyverse")
library(tidyverse)
#install.packages("nycflights13")
library(nycflights13)

### 결측치
x <- NA
y <- NA

x == y # NA- 모름 

is.na(x) #결측치인지 확인하는 법

df <- tibble(x= c( 1, NA, 3))
filter(df, x>1)
filter(df, is.na(x)| x>1)

df %>% filter(is.na(x)| x>1)


#| 3.3 arrange()로 행 정렬하기
 
#### 기본은 오름차순 
arrange(flights, year, month, day)

flights %>% 
    arrange(flights, year, month, day)

a <- flights %>% 
    arrange(flights, year, month, day)
view(a)

#### 내림차순으로 정렬
flights %>% arrange(desc(dep_delay)) 

df <- tibble(x=c(5,2,NA))
arrange(df,x)#결측값은 항상 마지막에 정렬


#| 3.4 select()로 열 선책하기 - 실제로 관심있는 데이터 위주로 줌인 
"""[기억해두기]
is.character
"""

select(flights, year, month, day) #조건으로 넣은 변수만 선택됨 

select(flights, year: day) #두 변수 사이 모든 열 선택 
select(flights, -(year:day)) #제외한 열 선택


flights %>%
    select(where(is.character)) #문자인 변수만 출발 

##select함수는 언급하지 않은 변수 누락 
#### 언급하지 않은 변수 유지 - rename 
flights %>%
    rename(tail_num = tailnum)
#### everything()사용- 누락 안하고 언급한 변수 앞으로
flights %>% 
    select(time_hour, air_time, everything())
#### 셀렉트 + 에브리띵 - relocate()
flights %>% 
    relocate(time_hour, air_time)

#|3.5 mutate()로 새로운 변수 추가
"""위치 설정에도 사용된다."""
flights %>%
    select(year:day,
           ends_with("delay"),
           distance,
           air_time) %>% 
    mutate(gain = arr_delay - dep_delay,
           speed = distance / air_time*60) #새롭게 추가된 변수는 뒤에 들어옴

### 뮤테이트에서 위치 바꾸기
flights %>%
    select(year:day,
           ends_with("delay"),
           distance,
           air_time) %>% 
    mutate(gain = arr_delay - dep_delay,
           speed = distance / air_time*60,
           .before = 1) #새로운 변수 맨 앞에 

### 생성한 열을 그대로 참조 
flights %>%
    select(year:day,
           ends_with("delay"),
           distance,
           air_time) %>% 
    mutate(gain = arr_delay - dep_delay,
           hours = air_time / 60,
           gain_per_hour = gain / hours,
           .before = 1)
### after 이용해 위치 바꾸기 
flights %>%
    select(year:day,
           ends_with("delay"),
           distance,
           air_time) %>% 
    mutate(gain = arr_delay - dep_delay,
           hours = air_time / 60,
           gain_per_hour = gain / hours,
           .after = day) #변수 뒤에 새 변수 위치

### 계산의 입력된 변수와 출력을 표시- mutate()
flights %>%
    select(year:day,
           ends_with("delay"),
           distance,
           air_time) %>% 
    mutate(gain = arr_delay - dep_delay,
           hours = air_time / 60,
           gain_per_hour = gain / hours,
           .keep = "used" ) # 나머지 변수는 사라짐

### 새 변수만을 남기고 싶다면 transmute()를 사용
transmute(
    flights, 
    gain = dep_delay - arr_delay,   
    hours = air_time / 60,  
    gain_per_hour = gain / hours)

flights %>% 
    transmute(gain = dep_delay - arr_delay,
              hours = air_time / 60,
              gain_per_hour = gain / hours)

## 3.5.1 유용한 생성함수 

### 모듈러연산자 -%/%(몫, 정수나누기), %%(나머지)- 정수를 조각으로 나눌 수 있어 편함 
flights%>%
    transmute(dep_time,
              hour = dep_time %/% 100,
              minute = dep_time %% 100) #목, 나머지로 시간, 분 분해
### 오프셋 - 벡터를 앞으로 당기거나 뒤로 민다. - 시간데이터에서 이용 
(x <-  1:100)
lag(x)
lead(x)

### 누적 및 롤링 집계
(x <- 1:10)
cumsum(x) #누적 합계
cummean(x) #누적 평균

### 랭킹
y <- c(1,2,2,NA,3,4)
rank(y) #일반적인 랭킹함수 - 소수점표시
min_rank(y) #동일한 값 동일하게 
min_rank(desc(y))

row_number(y) #동일한 값이라도 라는 순위 부여- 순서대로
dense_rank(y) #동일한 값 하나로 취급
percent_rank(y) #퍼센트
cume_dist(y) #누적퍼센트 

#| 3.6 summarize()로 그룹화 요약하기 
""" 하나의 행으로 축약 """

flights %>% 
    summarise(delay = mean(dep_delay)) #NA 
#NA 없애기 
flights %>% 
    summarise(delay = mean(dep_delay, na.rm = T))

### group_by와 함께 사용하기- 가장 빈번히 사용
flights %>%
    group_by(year, month, day) %>%
    summarise(delay = mean(dep_delay, na.rm = T)) #날짜별 평균 지연시간


