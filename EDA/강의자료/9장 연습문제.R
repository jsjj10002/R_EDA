#### 강의교재 9장 강의안 1. 연습문제 9.2.1의 #2번  
#2. table2 와 table4a + table4b 에서 비율(rate)을 계산하라. 다음의 네 가지 작업을 수행해야 한다.

#a. 연도별, 국가별로 결핵 사례수(case)를 추출하라.
#b. 연도별, 국가별로 해당하는 인구를 추출하라.
#c. 사례수를 인구로 나누고 10,000 을 곱하라.
#d. 적절한 곳에 다시 저장하라.
## pivot_wider()을 이용하면 한번에 가능함.

table2

library(tidyverse)

## table2 에서
table2 %>%
  pivot_wider(names_from = type, values_from = count) %>%
  mutate(rate = cases / population,
         rate2 = cases / population * 10000) 

## table4a + table4b 에서
table4a
table4b

tidy4a <- table4a %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "cases"
  ) %>%
  mutate(year = parse_integer(year))
tidy4b <- table4b %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "population"
  ) %>%
  mutate(year = parse_integer(year))
left_join(tidy4a, tidy4b, by = c("country", "year")) %>%
  mutate(rate = cases / population,
         rate2 = cases / population * 10000) 

## pivot_longer()를 사용하지 않고 tibble()함수를 이용해서 계산가능..
## 비효율적...
tibble(
    country = table4a$country,
    `1999` = table4a[["1999"]] / table4b[["1999"]] * 10000,
    `2000` = table4a[["2000"]] / table4b[["2000"]] * 10000
  )

 
#2. 연습문제 9.3.3의  #1.3번 
#### 9.3.3 연습문제
 
#1. pivot_longer() 와 pivot_wider() 가 완벽하게 대칭이 아닌 이유는 무엇인가? 다음 예제를 주의 깊게 살펴보라.

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks
# A tibble: 4 x 3
#   year  half return
#   <dbl> <dbl>  <dbl>
#1  2015     1   1.88
## 원데이터 모두 double형

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")


stocks %>%
  pivot_wider(names_from = year, values_from = return) 
# A tibble: 2 x 3
#    half `2015` `2016`
#   <dbl>  <dbl>  <dbl>
#1     1   1.88   0.92
## pivot_wider() 사용시.  모두 double형

stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")
# A tibble: 4 x 3
#   half year  return
#   <dbl> <chr>  <dbl>
#1     1 2015    1.88
## pivot_longer() 사용시.  year변수가 chr형으로 변환됨. 
## 즉 티블 데이터프레임이 와이드에서 롱으로 변환될때.
## 열 유형 정보가 손실됨. 따라서 완벽한 대칭 아님~~~


## 방법1: names_ptype = 인수 사용...
stocks %>%
  pivot_wider(names_from = year, values_from = return)%>%
  pivot_longer(`2015`:`2016`, 
               names_to = "year",
               values_to = "return") %>%
  mutate(year = parse_integer(year))

## 방법2: names_ptype = 인수 사용...(교재 힌트)
stocks %>%
  pivot_wider(names_from = year, values_from = return)%>%
  pivot_longer(`2015`:`2016`, names_to = "year", 
               values_to = "return",
               names_ptype = list(year = double()))
## double형 에러


?pivot_longer
## 방법3: values_transform = 인수 사용...
stocks %>%
  pivot_wider(names_from = year, values_from = return)%>%
  pivot_longer(`2015`:`2016`, names_to = "year", 
               values_to = "return",
               names_transform = list(year = as.numeric))

## numeric형 ok!!


#3. 티블을 펼치는 다음의 코드는 왜 에러가 나는가? 새로운 열을 추가해서 어떻게 문제를 해결할 수 있는가?
  
 
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people

people %>% 
  pivot_wider(names_from="key", values_from = "value")
###  "Phillip Woods"의 key에서 age가 2개 행임..

 
### 행을 구분하는 변수를 추가하기
people %>%
  group_by(name, key) %>%  ## 중복이 되는 변수(열)기준으로 그룹화.
  mutate(obs = row_number()) %>% 
  pivot_wider(names_from="key", values_from = "value")
## 에러 X


#3. 연습문제 9.4.3의 #1.2번 
#### 9.4.3 연습문제

#1. separate()의 extra 인수와 fill 인수의 역할은 무엇인가? 다음 두 개의 토이 데이터셋에 다양한 옵션을 실험해보라.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"))

?separate()
## extra =인수 
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "warn") # 디폴트.
# 추가 열 있는 경우 warning메시지와 함께 출력.

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "drop") 
# 추가 열 있는 경우 warning메시지 없이 자동 삭제

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "merge")
# 추가 열 있는 경우 분할없이 마지막 열에 출력.


## fill =인수

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "warn") # 디폴트.
# 열 갯수가 적은 경우 warning메시지와 함께 출력.
# 누락된 값은 NA 출력.

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right")
# 열 갯수가 적은 경우 warning메시지와 함께 출력.
# right 오른쪽에 누락된 값은 NA 출력.


tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "left")
# 열 갯수가 적은 경우 warning메시지와 함께 출력.
# left 왼쪽에 누락된 값은 NA 출력.


#2. unite()와 separate() 에는 모두 remove 인수가 있다. 이 인수의 역할은 무엇인가? 왜 FALSE로 설정하겠는가?
?unite()
?separate()
# remove = TRUE 인수 
#If TRUE, remove input column from output data frame.
## remove = TRUE이면, 데이터프레임에서 입력열을 제거함.
## 따라서 새 변수를 만들때 이전 변수들이 삭제됨.. 

tidyr::table5
table5 %>%
  unite(new, century, year, remove = TRUE) # 디폴트 

table5 %>%
  unite(new, century, year, remove = FALSE) ## 기존 변수 유지 원할때.

table3
table3 %>%  
  separate(rate, 
           into = c("cases", "population"), 
           remove = TRUE) # 디폴트

table3 %>%  
  separate(rate, 
           into = c("cases", "population"), 
           remove = FALSE) ## 기존 변수 유지 원할때.
