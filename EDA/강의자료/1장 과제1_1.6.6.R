#6. 다음의 그래프들을 생성하는 데 필요한 R코드를 다시 작성하라.
 
#산점도 + 추세선
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(stroke = 3)) +
  geom_smooth(se = FALSE)
 

# 산점도 + 추세선 (그룹별 drv)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(stroke = 3)) +
  geom_smooth(mapping = aes(group = drv), se = FALSE)
 

# 산점도 + color(그룹별 drv)
# +  추세선 + color(그룹별 drv)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(color = drv), se = FALSE) 
 

# 산점도 + color(그룹별 drv)
# +  추세선(se = FALSE) 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(se = FALSE) 
 

# 산점도 + color(그룹별 drv)
# +  추세선(se = FALSE)  + linetype(그룹별 drv)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE) 
 

# 쉬운버전
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv), se = FALSE)
 

library(ggplot2)
# 산점도 + color(그룹별 drv)
## fill + stroke + color
ggplot(data = mpg, mapping = aes(x = displ, y = hwy )) +
  geom_point( mapping = aes(fill = drv), shape = 21, stroke = 3, color = "white", size = 5)


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, fill = drv),
    color = "white", stroke = 3, shape = 21, size = 5
  )

