# BayesEcon

Source: Author's page [http://faculty.korea.ac.kr/kufaculty/kyuho/index.do]

-------------
# 세부 목차
## 1장 베이지안 계량경제학의 이해 1 
### 1.1 베이지안 통계분석의 기본 개념 . . . . . . . . . . . . . . . . . .. 4
####  1.1.1 사전 분포, 우도함수 그리고 사후 분포 . . . . . . . . .. 4
####  1.1.2 계량모형이란 무엇인가? . . . . . . . . . . . . . . . . . . . . 9
### 1.2 베이지안 추론 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 12
####  1.2.1 점추정치 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 12
####  1.2.2 신용구간 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 14
####  1.2.3 예측 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 16
####  1.2.4 모형 선택과 가설검정 . . . . . . . . . . . . . . . . . . . . . . 16
 
## 2장 깁스 샘플링 21 
### 2.1 다중선형회귀모형 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 21
####  2.1.1 Case 1. s 2 이 알려져 있는 경우 . . . . . . . . . . . . . 23
####  2.1.2 Case 2. b 가 알려져 있는 경우 . . . . . . . . . . . . . . . 27
####  2.1.3 Case 3. b 와 s 2 이 모두 알려져 있지 않은 경우 . .30
### 2.2 완전 조건부 분포와 깁스 샘플링 . . . . . . . . . . . . . . . . . 30
####  2.2.1 완전 조건부 분포 . . . . . . . . . . . . . . . . . . . . . . . . . .30
####  2.2.2 깁스 샘플링 알고리즘 . . . . . . . . . . . . . . . . . . . . . . 31
####  2.2.3 예: 유위험 이자율 평형식 추정 . . . . . . . . . . . . . . . 37
####  2.2.4 예: 우리나라 물가상승률 예측 모형 . . . . . . . . . . . .40
### 2.3 깁스 샘플링을 이용한 구조변화모형 추정 . . . . . . . . . . 43
####  2.3.1 모형설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 43
####  2.3.2 사후 분포 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . .44
####  2.3.3 예: 유위험 이자율 평형식의 구조변화시점 추정 . . 47
### 2.4 깁스 샘플링의 한계 . . . . . . . . . . . . . . . . . . . . . . . . . . . 48
 
## 3장 몬테 까를로 시뮬레이션 51 
### 3.1 Method of Composition . . . . . . . . . . . . . . . . . . . . . . . . 52
### 3.2 Probability Integral Transformation . . . . . . . . . . . . . . . 55
####  3.2.1 예: 절단된 정규 분포 샘플링 . . . . . . . . . . . . . . . . .56
### 3.3 Acceptance-Rejection Method . . . . . . . . . . . . . . . . . . .58
####  3.3.1 시뮬레이션 방법 . . . . . . . . . . . . . . . . . . . . . . . . . . 59
####  3.3.2 이론적 배경 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .62
####  3.3.3 예: 베타 분포 샘플링 . . . . . . . . . . . . . . . . . . . . . . .63
### 3.4 Importance 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . .65
####  3.4.1 시뮬레이션 방법 . . . . . . . . . . . . . . . . . . . . . . . . . . 66
####  3.4.2 이론적 배경 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .66
####  3.4.3 예: Importance 샘플링으로 EX [g(X)] 근사하기 . . 68
 
## 4장 Metropolis-Hastings 알고리즘 71 
### 4.1 Metropolis-Hastings 알고리즘의 소개 . . . . . . . . . . . . . 71
### 4.2 Metropolis-Hastings 알고리즘의 이해 . . . . . . . . . . . . . 75
####  4.2.1 마코프 체인 측면에서의 이해 . . . . . . . . . . . . . . . . 75
####  4.2.2 Acceptance-Rejection 측면에서의 이해 . . . . . . . . 77
### 4.3 임의보행 Metropolis-Hastings 알고리즘 . . . . . . . . . . . 80
####  4.3.1 임의보행 분산이 지나치게 작은 경우 . . . . . . . . . . 81
####  4.3.2 임의보행 분산이 지나치게 큰 경우 . . . . . . . . . . . . 81
####  4.3.3 임의보행 분산이 적절한 경우 . . . . . . . . . . . . . . . . 83
### 4.4 다블록 Metropolis-Hastings 알고리즘 . . . . . . . . . . . . . 84
####  4.4.1 다블록 M-H 기법의 소개 . . . . . . . . . . . . . . . . . . . .84
####  4.4.2 다블록 임의보행 M-H 기법 . . . . . . . . . . . . . . . . . . 87
####  4.4.3 다블록 M-H 기법이 유용한 경우와 이유 . . . . . . . . 88
####  4.4.4 블록을 나누는 기준 . . . . . . . . . . . . . . . . . . . . . . . .90
### 4.5 깁스 샘플링과 M-H 알고리즘의 관계 . . . . . . . . . . . . . .91
### 4.6 고급 Metropolis-Hastings 알고리즘: Tailored M-H 기법. . 92
####  4.6.1 Tailored Independent M-H method . . . . . . . . . . . . 92
####  4.6.2 Tailored Dependent M-H method . . . . . . . . . . . . . 95
### 4.7 예: M-H 기법을 이용한 선형회귀식 추정 . . . . . . . . . . . 98
####  4.7.1 임의보행 M-H 기법 . . . . . . . . . . . . . . . . . . . . . . . . 98
####  4.7.2 단블록 Tailored Independent M-H 기법 . . . . . . . . .100
####  4.7.3 단블록 Tailored Dependent M-H 기법 . . . . . . . . . .100
####  4.7.4 라플라스 근사 기법 . . . . . . . . . . . . . . . . . . . . . . . .101
####  4.7.5 추정결과 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .101
### 4.8 예: M-H 기법을 이용한 통화정책반응함수 추정 . . . . . 104
####  4.8.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 104
####  4.8.2 추정결과 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .106
 
## 5장 수렴여부 및 효율성 측정 109 
### 5.1 비효율성 계수 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 109
### 5.2 Geweke’s p-값 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .113
 
## 6장 응용 115
### 6.1 오차항이 스튜던트-t 분포인 다중선형회귀모형 . . . . . . 115
####  6.1.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 115
####  6.1.2 사후 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 116
####  6.1.3 예: 오차항이 스튜던트-t 분포인 유위험 이자율 평형설 추정 . . . 119
### 6.2 프라빗 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 120
####  6.2.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 120
####  6.2.2 사후 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .122
####  6.2.3 예: 취업 결정식 추정 . . . . . . . . . . . . . . . . . . . . . . .123
### 6.3 토빗 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 124
####  6.3.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 124
####  6.3.2 사후 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .126
####  6.3.3 예: 야구경기장 잔여석수 추정 . . . . . . . . . . . . . . . .128
### 6.4 Seemingly Unrelated Regression . . . . . . . . . . . . . . . . .129
####  6.4.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 129
####  6.4.2 사후 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 130
### 6.5 구조 벡터자기회귀모형 . . . . . . . . . . . . . . . . . . . . . . . . 131
####  6.5.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 131
####  6.5.2 충격반응함수 도출 . . . . . . . . . . . . . . . . . . . . . . . . 133
####  6.5.3 사후 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 135
####  6.5.4 예: Stock and Watson Recursive VAR . . . . . . . . . 141
### 6.6 GARCH . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 142
####  6.6.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 142
####  6.6.2 사후 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 145
####  6.6.3 변동성과 예측분포 . . . . . . . . . . . . . . . . . . . . . . . . 148
####  6.6.4 예: 주가변동성 추정과 예측 . . . . . . . . . . . . . . . . . 150
 
## 7장 모형선택과 주변 우도 계산 151
### 7.1 해석적인 방법 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 154
### 7.2 사전 분포 시뮬레이션 . . . . . . . . . . . . . . . . . . . . . . . . . . 155
### 7.3 Importance 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . . .156
### 7.4 라플라스 기법 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 157
### 7.5 베이지안 정보기준 . . . . . . . . . . . . . . . . . . . . . . . . . . . . .158
### 7.6 Deviance 정보기준 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 158
### 7.7 조화평균 기법 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 159
### 7.8 Chib 기법 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .161
####  7.8.1 단블록인 경우 . . . . . . . . . . . . . . . . . . . . . . . . . . . . .161
####  7.8.2 블록이 두 개인 경우 . . . . . . . . . . . . . . . . . . . . . . . . 162
####  7.8.3 블록이 세 개인 경우 . . . . . . . . . . . . . . . . . . . . . . . . 163
####  7.8.4 모형에 잠재 요인이 존재하는 경우 . . . . . . . . . . . . .165
### 7.9 Savage-Dickey Density Ratio . . . . . . . . . . . . . . . . . . . . 166
### 7.10 예: 유가의 우리나라 물가상승률 예측력 검증 . . . . . . . 168
####  7.10.1 라플라스 기법 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 169
####  7.10.2 Chib 기법 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 169
####  7.10.3 조화평균 기법 . . . . . . . . . . . . . . . . . . . . . . . . . . . .. 169
####  7.10.4 Savage-Dickey density ratio . . . . . . . . . . . . . . . . .. 170
####  7.10.5 주변 우도 추정결과 . . . . . . . . . . . . . . . . . . . . . . . .. 171
 
## 8장 예측 173
### 8.1 모형 확실성하의 예측 . . . . . . . . . . . . . . . . . . . . . . . . . . . 173
####  8.1.1 사후 예측 분포 시뮬레이션 . . . . . . . . . . . . . . . . . . .. 173
####  8.1.2 Mean Squared Error . . . . . . . . . . . . . . . . . . . . . . . .. 175
####  8.1.3 사후 예측 우도 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 176
### 8.2 모형 불확실성하의 예측 . . . . . . . . . . . . . . . . . . . . . . . . . 179
####  8.2.1 베이지안 모형 평균 . . . . . . . . . . . . . . . . . . . . . . . . . .179
####  8.2.2 사후 예측 우도를 이용한 예측 분포 조합 . . . . . . . . . 182
####  8.2.3 예: 우리나라 물가상승률 예측 . . . . . . . . . . . . . . . . . 183
 
## 9장 고급 시계열 모형 187
### 9.1 마코프-스위칭 모형 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 187
####  9.1.1 더미 변수 모형 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 187
####  9.1.2 사후 분포 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . .190
####  9.1.3 사후 예측 분포 샘플링과 사후 예측 밀도 . . . . . . . . 201
####  9.1.4 상태의 식별제약 . . . . . . . . . . . . . . . . . . . . . . . . . . . 203
####  9.1.5 구조변화 모형 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 204
####  9.1.6 예: 마코프-스위칭 변동성 모형 . . . . . . . . . . . . . . . . 205
####  9.1.7 예: 우리나라 물가상승률 구조변화 시점 추정 . . . . . 206
### 9.2 상태공간 모형 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .211
####  9.2.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 211
####  9.2.2 사후 분포 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . . 215
####  9.2.3 예: 동태적 넬슨-시겔 모형 . . . . . . . . . . . . . . . . . . . . 220
####  9.2.4 예: 시변 통화정책 반응함수 . . . . . . . . . . . . . . . . . . . 230
### 9.3 확률적 변동성 모형 . . . . . . . . . . . . . . . . . . . . . . . . . . . . .231
####  9.3.1 모형 설정 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 231
####  9.3.2 사후 분포 샘플링 . . . . . . . . . . . . . . . . . . . . . . . . . . .233
####  9.3.3 예: 주가 변동성 추정과 예측 . . . . . . . . . . . . . . . . . . 237
 
## A 확률 분포 241 
### A.1 이산확률분포 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 241
####  A.1.1 베르누이 분포 (Bernoulli) . . . . . . . . . . . . . . . . . . . . . 241
####  A.1.2 이항 분포 (Binomial) . . . . . . . . . . . . . . . . . . . . . . . . . 241
####  A.1.3 음이항 분포 (Negative Binomial) . . . . . . . . . . . . . . . 242
####  A.1.4 다항 분포 (Multinomial) . . . . . . . . . . . . . . . . . . . . . .. 242
####  A.1.5 포아송 분포 (Poisson) . . . . . . . . . . . . . . . . . . . . . . . 242
### A.2 연속확률분포 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .. 243
####  A.2.1 균일 분포(Uniform) . . . . . . . . . . . . . . . . . . . . . . . . . 243
####  A.2.2 감마 분포(Gamma) . . . . . . . . . . . . . . . . . . . . . . . . .. 243
####  A.2.3 지수 분포(exponential) . . . . . . . . . . . . . . . . . . . . . . 244
####  A.2.4 카이제곱 분포(Chi-square) . . . . . . . . . . . . . . . . . . .. 244
####  A.2.5 역감마 분포(Inverted or Inverse Gamma) . . . . . . . .. 244
####  A.2.6 베타 분포(Beta) . . . . . . . . . . . . . . . . . . . . . . . . . . . . 245
####  A.2.7 디리클레 분포(Dirichlet) . . . . . . . . . . . . . . . . . . . . . 246
####  A.2.8 정규 분포 (Normal or Gaussian) . . . . . . . . . . . . . . . 246
####  A.2.9 다변수 정규 분포(Multivariate Normal or Gaussian) . . 246
####  A.2.10 절단된 정규 분포(Truncated Normal) . . . . . . . . . . .247
####  A.2.11 스튜던트-t 분포(Student’s t) . . . . . . . . . . . . . . . . . .247
####  A.2.12 다변수 스튜던트-t 분포(Multivariate t) . . . . . . . . . . 248
####  A.2.13 위샤트 분포(Wishart) . . . . . . . . . . . . . . . . . . . . . . . 248
####  A.2.14 역위샤트 분포(Inverted or Inverse Wishart) . . . . . .249
 
## B 참고문헌 251
 
## C 찾아보기 253
