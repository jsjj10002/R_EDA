#준비하기
library(tidyverse)

# 티블생성하기
as_tibble(iris)

tibble(
  x = 1:5,
  y = 1, #길이가 1인 입력을 자동으로 재사용
  z = x ^ 2 + y #방금 만든 변수를 참조
)

tb <- tibble(
  ':)' = "스마일",
  ' ' = "스페이스",
  '2000' = "숫자"
)
tb

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,   ## 주석넣기 
  "b", 1, 8.5
)

# 화면출력
# lubridate : idyverse 계열이기는 하지만, 날짜와 시간 데이터를 처리할 때 유용
lubridate::now()
# runif : 일정구간에서 확률값이 같은 확률분포인 균일분포 난수 생성..
# sample(letters, 1e3, replace = TRUE) : 데이터프레임 또는 벡터에서 지정된 크기만큼 데이터를 무작위로 추출

?lubridate
lubridate::now()
sample(letters, 1e3, replace = TRUE)

tibble(
  a = lubridate::now() + runif(1e3) * 86400, 
  b = lubridate::today() + runif(1e3) *30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)



nycflights13::flights %>%
  print(n = 10, width = Inf)

## view()
nycflights13::flights %>%
  view()


#서브셋하기

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
#이름으로추출
df$x
df[["x"]]

#위치로추출
df[[1]]


#파이프 연산자
df %>% 
  .$x
df %>% 
  .[["x"]]

class(as.data.frame(tb))

#### 7.4.1 연습문제
#2
df <- data.frame(abc = 1, xyz = "a")
df$x

df[, "xyz"]             # "xyz"열의 모든 값 출력
df[, c("abc", "xyz")]   # c("abc", "xyz")열값 모두 출력


#4.d
tibble::enframe

enframe(list(one = 1, two = 2:3, three = 4:6))

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length('1'))
)

#5
tibble::enframe()
enframe(1:3)
enframe(c(a = 5, b = 7))
enframe(list(one = 1, two = 2:3, three = 4:6))
