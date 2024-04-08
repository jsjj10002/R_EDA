"""[중간고사]
1시간30분
20문제// 절반: 과제에에 나온 데이터, 절반: 새로운 데이터
새로운 데이터셋 관한 정보는 미제공
오픈북 아님 
?함수만 가능, 인터넷 금지
24일 수업 없음 (비대면 수업)-28일까지 듣기
4.10일 수업(비대면)-11까지 듣기기
범위: 4.17일 배운 범위까지 
방식: (가능한)인터넷 포털로 코딩하거나 A4에서 손으로 쓰기 
답: 가장 빠른 비행기 넘버 구하기, 티블 행 개수 구하기 등.
"""

## 3.6.4 유용한 함수 
"""
위치 측정값
mean()      :평균
median()    :중앙값
산포 측정값
sd()        :표준편차
IQR()       :사분위범위위
mad()       :중위절대편차 E[|x_i-mu|]
순위 측정값
min()       :최소
quantile(, ):분위수
max()       :최대 
자리 측정값
first()     :첫번째 측정값값
nth()       :n번째 측정값
last()      :마지막 측정값 
카운트
n()             :그룹 크기 
sum(!is.na())   :결측값 없는 값 개수 
n_distinct()    :유일한 값
논리형 값의 카운트와 그 비율 
sum(조건)   :True 개수
mean(조건)  :True 비율
"""
not_cancelled <- flights %>% 
    filter(!is.na(dep_delay), !is.na(arr_delay))
#평균을 구해서 새로운 변수로 만듦 
not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarize(
        avg_delay1 = mean(arr_delay),
        avg_delay2 = mean(arr_delay[arr_delay >0])
    )
#거리 편차 구하기기
not_cancelled %>% 
    group_by(dest) %>% 
    summarize(distance_sd = sd(distance)) %>% 
    arrange(desc(distance_sd))
#산포측정 
dt1 <- c(1,2,3,4,5,6,7,8,9,10)
dt2 <- c(1,2,3,4,5,6,7,8,9,100)

#순위 측정정
not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarize(
        first = min(dep_time),
        quantile_1 = quantile(dep_time, 0.25),
        mean = mean(dep_time),
        quantile_3 = quantile(dep_time, 0.75)
    )
#자리측정값 
not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarize(
        first_dep = first(dep_time),
        last_dep = last(dep_time)
    )
#순위별로 필터링 
not_cancelled %>% 
    group_by(year, month, day) %>% 
    mutate(r= min_rank(desc(dep_time))) %>% 
    filter(r %in% range(r))

#카운트- 어느 목적지에 항공사가 가장 많은지 
not_cancelled %>% 
    group_by(dest) %>% 
    summarise(carriers = n_distinct(carrier)) %>% 
    arrange(desc(carriers))
#단순하게 수행- 그룹바이와 서머라이즈 생략(그루핑 하나만 할 경우만 사용 가능)
not_cancelled %>% 
    count(dest)

#가중치 변수를 선택적으로 지정
not_cancelled %>% 
    count(tailnum, wt=distance)#마일수를 카운팅 = sum()기능 
#다르게 표현하기 
not_cancelled %>% 
    group_by(tailnum) %>% 
    summarise(sum_dis = sum(distance, na.rm = T))
#운항 거리가 가장 긴 항공 번호 찾기
not_cancelled %>% 
    group_by(tailnum) %>% 
    summarise(sum_dis = sum(distance, na.rm = T)) %>% 
    arrange(desc(sum_dis))
#아침 5시 이전 항공편 개수 
not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(n_early = sum(dep_time<500)) #True 조건만 개수 셈 
#도착 지연 1시간 이상인 항공편 비율
not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(hour_prop = mean(arr_delay<60)) %>% 
    arrange(desc(hour_prop))
"""
.groups = "drop"        :그룹 해제 
.groups = "drop_last"   :마지막만 그룹 해제제
.groups = "keep"        :그룹 유지지
"""
daily <- flights %>% group_by(year, month, day)
#그룹바이 경고 없애기
daily %>% summarise(n = n(),
                    .groups = "drop")
daily %>% summarise(n = n(),
                    .groups = "keep")
daily %>% summarise(n = n(),
                    .groups = "drop_last")
#그룹화 해제제
daily %>% summarise(n = n()) %>% 
    ungroup() %>% 
    summarise( flights = n())

## 3.6.5 여러 변수로 그룹화
daily <- flights %>% group_by(year, month, day)
(per_day <- daily %>% summarise(flights = n()))
#= 
flights %>% group_by(year, month, day) %>% 
    summarise(flights = n()) %>% 
    summarise(filghts =sum(flights)) %>% 
    summarise(filghts =sum(flights))


#|3.7 그룹화 뮤테이트와 필터링 
