# 카카오 T ERD PROJECT
## 🧮 프로젝트 소개
- 카카오 T 택시 서비스에 대한 ERD를 작성합니다.
- ERD 작성과 관련된 sql 구문을 작성합니다.

## 📍 목차
#### 1. [팀원](#🧑🏻‍💻-1-팀원)
#### 2. [파일 정보](#🔖-2-파일-정보)

## 🧑🏻‍💻 1. 팀원
#### 대장 : 서용원
#### 서용수
#### 최서우
#### 주현범
#### 이경민

## 🔖-2-파일-정보

```bash
.
├── README.md
├── coordinator.tsv (지역 정보 생성을 위한 파일)
├── table_data (Generated Fake Data)
│   ├── car_table_data.csv
│   ├── credict_card_table_data.csv
│   ├── driver_table_data.csv
│   ├── payment_result_table_data.csv
│   ├── payment_table_data.csv
│   ├── region_table_data.csv
│   ├── taxi_call_table_data.csv
│   ├── taxi_catch_table_data.csv
│   └── user_table_fake_data.csv
└── workspace
    ├── faker_data_generator.ipynb (Fake Data 생성 스크립트)
    ├── create_database.sql (DB 및 테이블 생성 SQL 구문)
    └── insert_test.sql (테이블 내 데이터 생성 SQL 구문)
```

# 프로젝트 실행 순서
create_database.sql -> insert_test.sql