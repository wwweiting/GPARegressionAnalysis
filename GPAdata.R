###2024 Data Mining-Regression

#Part 1 查看資料集
data <- read.csv("Student_Performance_Data_updated.csv")
View(data)


#Part 2 敘述統計-繪圖

### Base Plotting System 
plot(x = data$StudyTimeWeekly, y = data$GPA, pch = 2,
     xlab = "study hours", ylab = "GPA score")  #畫出離散 >> 了解相關性（正 or 負）

### Lattice 
require(lattice)
install.packages('lattice')
library(lattice)
xyplot(GPA~StudyTimeWeekly, data=data)

### ggplot2 
require(ggplot2)
install.packages('ggplot2')
library(ggplot2)
ggplot(data=data) +
  geom_point(aes(x=StudyTimeWeekly,
                 y=GPA)) +
  theme_bw() 


### Base Plotting System 
plot(x=data$StudyTimeWeekly, y=data$GPA,pch=16)

### Lattice 
require(lattice)
xyplot(GPA~StudyTimeWeekly, data=data)

### ggplot2 
require(ggplot2)
ggplot(data=data) +                       
  geom_point(aes(x=StudyTimeWeekly,          
                 y=GPA)) +
  theme_bw()                              



### Base Plotting System 
plot(x=data$StudyTimeWeekly, y=data$GPA,pch=16)

d1 <- data[data$ParentalSupport=="High", ]
points(x=d1$StudyTimeWeekly, y=d1$GPA,pch=16, col="green")

d2 <- data[data$ParentalSupport=="Moderate", ]
points(x=d2$StudyTimeWeekly, y=d2$GPA,pch=16, col="red")

d3 <- data[data$ParentalSupport=="Low", ]
points(x=d3$StudyTimeWeekly, y=d3$GPA,pch=16, col="blue")

legend("topleft", pch=16,
       legend=c("High","Moderate","Low"), 
       col=c("green", "red", "blue")
       )


### Lattice 
require(lattice)
xyplot(GPA~StudyTimeWeekly, 
       data=data, 
       pch=16,
       group=ParentalSupport, 
       auto.key=list(space="top",
                     columns=3, 
                     cex.title=1, 
                     title="Parental Support",
                     pch=16)  
      )

### ggplot2 
require(ggplot2)
ggplot(data=data) +                       
  geom_point(aes(x=StudyTimeWeekly,           
                 y=GPA,
                 color=ParentalSupport)) +         
  
  theme_bw()                               


### Base Plotting System 
# 重新定義順序
data$ParentalSupport <- factor(data$ParentalSupport, levels = c("None", "Low", "Moderate", "High", "Very High"))

boxplot(StudyTimeWeekly~ParentalSupport, data=data, xlab="Parental Support", ylab="Study Time Weekly")  #在讀書時數上是否離群
boxplot(GPA~ParentalSupport, data=data, xlab="Parental Support", ylab="GPA")  #在成績上是否離群

### ggplot2 
require(ggplot2)
qplot(x=StudyTimeWeekly,      
      y=GPA, 
      data=data, 
      geom="boxplot",    # graph type is boxplot
      color=ParentalSupport)


#Part 3 資料預處理
table(is.na(data))  

summary(data$StudyTimeWeekly)
summary(data$GPA)


#Part 4  迴歸分析

# Step 1: 檢查資料結構，確保 ParentalSupport 是因子類別
str(data)
data$ParentalSupport <- factor(data$ParentalSupport, levels = c("None", "Low", "Moderate", "High", "Very High"))

# Step 2: 建立多元線性迴歸模型
# 將 ParentalSupport 的基準組設為 "None"
data$ParentalSupport <- relevel(data$ParentalSupport, ref = "None")
# 設定 GPA 為因變量，StudyTimeWeekly 為連續自變量，ParentalSupport 為分類自變量
model <- lm(GPA ~ ParentalSupport, data = data)
summary(model)

# Step 3: 模型診斷
# 查看模型物件的名稱
names(model)

# 殘差
model$residuals

# Shapiro-Wilk 正態性檢定（檢查殘差的正態性）
shapiro.test(model$residuals)

# Durbin-Watson 自相關性檢定（檢查殘差的獨立性）
require(car)
install.packages('car')
library(car)
durbinWatsonTest(model)

# 非定常變異檢定（檢查異方差性）
ncvTest(model)

# Step 4: 預測
# 建立一筆新數據，模擬不同的每週讀書時數和父母支持度，預測 GPA
new.data <- data.frame(StudyTimeWeekly = 15, ParentalSupport = "High")
predict(model, new.data)

# Step 5: 共線性檢查
# 檢查多重共線性，尤其是父母支持度的虛擬變數
# vif(model)

# 結束：結合變異數分析，檢查不同父母支持度的平均 GPA 是否顯著不同
anova(model)


