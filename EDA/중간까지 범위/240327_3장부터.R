"""
3장 데이터변형
"""
#|3.1 들어가기-데이터 불러오기, 확인
install.packages("nycflights13")
library(nycflights13)# 2013년 뉴욕시 출발 항공편
library(tidyverse)

?flights
str(flights)
flights #tibble data: 보기 더 편함 , 열 이름 아래에 데이터 종류가 나옴 
'''[tibble에서 데이터형]
int     :정수
dbl     :더블형, 실수
chr     :문자형벡터, 문자열
dttm    :데이트-타임(tibble에서 편한 점)
lgl     :논리형
fctr    :펙터   
date    :데이트형
'''
view(flights)

#|3.1.3 dply 기초-원하는 행, 열 뽑기
'''
filter()    :값을 기준으로 선택 #순서 변경이 안됨
arrange()   :행 재정렬 #순서 변경 가능
select()    :이름으로 변수 선택 #ZoomIn 기능, 일부만 가져옴
mutate()    :기존 변수를 함수로 새 변수 생성
summarise() :많은 값 하나로 합침
'''

#|3.2 filter()로 행 필터링하기
filter(flights, month == 1, day == 1) #객체가 달라지고 변수는 그대로
jan1 <- filter(flights, month == 1, day == 1) #결과 저장
(dec25 <- filter(flights, month == 12,day == 25)) #저장 후 바로 출력

##비교연산, 논리연산
'''[비교]
==      :같다
!=      :같지 않다
near()  :정밀한 계산
'''
###near()
sqrt(2)^2 == 2 #근사값으로 계산-False
near(sqrt(2)^2, 2) #근사하지 판별
near(1 / 49 * 49 ,1)
'''[논리]
|       :or
&       :and
!       :not
%in%    :포함연산자
'''
filter(flights, month == 11 | month == 12)# 11월, 12월 모두 
###파이프연산 표현
flights %>% 
    filter(month == 11 | month == 12)

filter(flights, month == (11 | 12)) #1월을 출력((11|12)를 True로 변환하기 때문)

filter(flights, month %in% c(11, 12))

###드모르간법칙을 이용한 단순화

'''[드모르간]
!( x & y ) = !x | !y

!( x | y ) = !x & !y
'''

####출발 혹은 도착이 두 시간 이상 지연되지 않은 항공편 찾기
filter(flights, !(arr_delay >= 120 | dep_delay >=120))
flights %>% 
    filter(arr_delay < 120 & dep_delay <120) #두 개 같음 - 더 간결 
