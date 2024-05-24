drop database kakao_dev;

create database if not exists kakao_dev;
use kakao_dev;

create table if not exists FAMILY
(
    family_id int primary key auto_increment,
    user_id   int not null
);

-- USER => 1_000_000
create table if not exists USER
(
    user_id      int primary key auto_increment,
    name         varchar(20) not null,
    phone_number char(12)    not null unique,
    birth        char(6)     not null,
    point        int         not null default 0,
    family_id    int,
    foreign key (family_id) references FAMILY (family_id) on delete set null
);

alter table USER auto_increment = 1000000;

create table if not exists PAYMENT_METHOD
(
    payment_info      char(16) primary key,
    user_id           int     not null,
    expiration_period char(4) not null,
    cvc               char(3) not null,
    password          char(2) not null,
    foreign key (user_id) references USER (user_id) on delete cascade
);

create table if not exists TAXI_CALL
(
    call_id int primary key auto_increment,
    start_long double not null,
    start_lat double not null,
    end_long double not null,
    end_lat double not null,
    is_premium bool not null default False,
    apx_payment int not null default 0,
    call_time timestamp not null default current_timestamp,
    user_id int,
    foreign key (user_id) references USER (user_id) on delete set null
);

create table if not exists REGION
(
    region varchar(20) primary key,
    dist   polygon     not null
);

-- 기사 및 사용자 ID 시작 번호 정하기
-- ID => 1
create table if not exists DRIVER
(
    driver_id int primary key auto_increment,
    name      varchar(20)  not null,
    ssn       char(13)     not null unique,
    company   varchar(100) not null default '개인',
    region    varchar(20),
    rating    double,
    is_quit   bool         not null default False,
    foreign key (region) references REGION (region)
);

create table if not exists CAR
(
    driver_id int primary key,
    pay_type  bool         not null default false,
    car_num   char(9)      not null unique,
    car_type  varchar(100) not null,
    foreign key (driver_id) references DRIVER (driver_id)
);

create table if not exists TAXI_CATCH
(
    catch_id int primary key auto_increment,
    call_id int not null,
    driver_id int not null,
    rating double,
    comment varchar(100),
    catch_time timestamp not null default current_timestamp,
    foreign key (call_id) references TAXI_CALL (call_id),
    foreign key (driver_id) references DRIVER (driver_id)
);

create table if not exists PAYMENT
(
    catch_id       int primary key,
    payment_result int default 0,
    payment_time timestamp default current_timestamp,
    foreign key (catch_id) references TAXI_CATCH (catch_id)
);

-- 사용자 정보 등록 확인
select * from USER;

-- 결제 수단 등록 확인
select * from PAYMENT_METHOD;

-- 사람이 여러개 등록한 경우 확인
select user_id, count(*) from PAYMENT_METHOD
group by user_id
having count(*) > 1;

select * from TAXI_CALL;

-- 택시 콜 테이블 user_id와 User의 user_id가 다른 경우 파악
select count(*) from TAXI_CALL as tc, USER as user
where tc.user_id = user.user_id;

select tc.user_id, u.user_id from TAXI_CALL as tc
left join USER as u
on tc.user_id = u.user_id
where u.user_id is null;

-- REGION 데이터 추가된지 확인
select region, ST_AsText(dist) from REGION;

-- DRIVER 데이터 추가 확인
/*
driver 계정이 삭제되는 경우에는 어떻게 처리할 것인가?
    - 기사 테이블에서 기사를 삭제하는 경우가 발생하지 않도록 한다.
    - 즉, 회원 탈퇴와 같은 경우는 퇴사 여부를 통해서 데이터를 업데이트 하도록 한다.
    - 보안 관련 측면에서 많은 부분을 준비하지 못한 것이 아쉬운 부분

그렇기 때문에 Foreign KEY에서 데이터가 변경되는 것에 대해서 RESTRICT 하도록 구성함.
*/
select * from DRIVER;

-- CARD 데이터 입력 확인
select * from CAR;

-- TAXI_CATCH 데이터 입력 확인
select * from TAXI_CATCH;

-- PAYMENT 데이터 입력 확인
select * from PAYMENT;













