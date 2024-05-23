create database if not exists gyoungmin;

use gyoungmin;

create table if not exists FAMILY(
    family_id int primary key,
    user_id int not null
);

create table if not exists USER(
	user_id int not null primary key auto_increment,
    name varchar(10) not null,
    phone_number char(13) not null,
    birth int(6) not null,
    point int not null default 0,
    family_id int,
    foreign key (family_id) references FAMILY (family_id) on delete set null
);

create table if not exists PAYMENT_METHOD(
	payment_info bigint(16) not null,
    user_id int not null,
    expiration_period date not null,
    cvc smallint(3) not null,
    password smallint(2) not null,
    primary key (payment_info, user_id),
    foreign key (user_id) references USER(user_id) on delete cascade
);

create table if not exists TAXI_CALL(
	call_id int primary key auto_increment,
    start_long double not null,
    start_lat double not null,
    end_long double not null,
    end_lat double not null,
    is_premium bool not null default false,
    apx_payment int not null default 0,
    call_time timestamp not null default current_timestamp,
    user_id int not null,
    foreign key (user_id) references USER(user_id) on delete no action
);
/*
사용자 삭제 시, TAXI CALL 데이터를 남기는 방법이 없다.
- 데이터를 null로 만들어서 삭제된 사용자라는 것을 표시해야 한다.
- Default Value로 -1과 같은 특이한 값을 주어서 삭제된 사용자라는 것을 표시한다.
- 삭제가 되는 경우, 함께 삭제한다.
*/

create table if not exists REGION(
	region varchar(20) primary key,
    dist varchar(20) not null
);

create table if not exists DRIVER(
	driver_id int primary key auto_increment,
    name varchar(20) not null,
    company varchar(100) not null,
    region varchar(20) not null,
    rating int,
    foreign key (region) references REGION (region) on update cascade
);

create table if not exists CAR(
	driver_id int not null,
    is_premium bool not null default False,
    car_num varchar(16) not null,
    car_type varchar(100) not null,
    foreign key (driver_id) references DRIVER (driver_id) on delete cascade
);

create table if not exists TAXI_CATCH(
	call_id int not null,
    driver_id int not null,
    region varchar(20) not null,
    comment varchar(100) not null,
    catch_time timestamp not null default current_timestamp,
    
    foreign key (call_id) references TAXI_CALL (call_id) on delete cascade,
    foreign key (driver_id) references DRIVER (driver_id) on delete no action,
    
    primary key (call_id, driver_id)
);

create table if not exists PAYMENT(
	call_id int not null,
    payment_result int,
    foreign key (call_id) references TAXI_CALL (call_id) on delete no action on update no action,
    primary key (call_id)
);

-- USER 테이블에 데이터 삽입
INSERT INTO USER (name, phone_number, birth, point, family_id) VALUES
('김수현', '010-1234-5678', 900101, 100, NULL),
('강동원', '010-8765-4321', 920202, 200, NULL),
('박정민', '010-1111-2222', 930303, 300, NULL),
('카리나', '010-3333-4444', 940404, 400, NULL),
('김민지', '010-5555-6666', 950505, 500, NULL);

-- FAMILY 테이블에 데이터 삽입
INSERT INTO FAMILY (family_id, user_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- FAMILY ID를 USER 테이블에 업데이트
UPDATE USER SET family_id = 1 WHERE user_id = 1;
UPDATE USER SET family_id = 2 WHERE user_id = 2;
UPDATE USER SET family_id = 3 WHERE user_id = 3;
UPDATE USER SET family_id = 4 WHERE user_id = 4;
UPDATE USER SET family_id = 5 WHERE user_id = 5;

-- PAYMENT_METHOD 테이블에 데이터 삽입
INSERT INTO PAYMENT_METHOD (payment_info, user_id, expiration_period, cvc, password) VALUES
(1234567890123456, 1, '2025-12-31', 123, 12),
(2345678901234567, 2, '2024-11-30', 456, 34),
(3456789012345678, 3, '2026-10-31', 789, 56),
(4567890123456789, 4, '2023-09-30', 321, 78),
(5678901234567890, 5, '2027-08-31', 654, 90);

-- TAXI_CALL 테이블에 데이터 삽입
INSERT INTO TAXI_CALL (start_long, start_lat, end_long, end_lat, is_premium, apx_payment, user_id) VALUES
(127.02758, 37.49794, 126.9784, 37.5665, FALSE, 15000, 1),
(127.03758, 37.49894, 126.9884, 37.5765, TRUE, 20000, 2),
(127.04758, 37.49994, 126.9984, 37.5865, FALSE, 25000, 3),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 30000, 4),
(127.06758, 37.50194, 127.0184, 37.6065, FALSE, 35000, 5),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 30000, 4),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 23000, 4),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 12000, 4),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 53000, 4),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 12000, 4),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 32000, 4),
(127.05758, 37.50094, 127.0084, 37.5965, TRUE, 54000, 4);


-- REGION 테이블에 데이터 삽입
INSERT INTO REGION (region, dist) VALUES
('서울', '중구'),
('부산', '해운대구'),
('대구', '달서구'),
('인천', '남동구'),
('광주', '북구');

-- DRIVER 테이블에 데이터 삽입
INSERT INTO DRIVER (name, company, region, rating) VALUES
('박기사', '서울택시', '서울', 5),
('최기사', '부산택시', '부산', 4),
('이기사', '대구택시', '대구', 4),
('김기사', '인천택시', '인천', 3),
('한기사', '광주택시', '광주', 5);

-- CAR 테이블에 데이터 삽입
INSERT INTO CAR (driver_id, is_premium, car_num, car_type) VALUES
(1, FALSE, '01가1234', '소나타'),
(2, TRUE, '02가5678', '그랜저'),
(3, FALSE, '03가9012', '아반떼'),
(4, TRUE, '04가3456', 'K5'),
(5, FALSE, '05가7890', '쏘렌토');

-- TAXI_CATCH 테이블에 데이터 삽입
INSERT INTO TAXI_CATCH (call_id, driver_id, region, comment) VALUES
(1, 1, '서울', '빠르게 도착했습니다.'),
(2, 2, '부산', '안전하게 도착했습니다.'),
(3, 3, '대구', '친절하게 모셨습니다.'),
(4, 4, '인천', '신속하게 이동했습니다.'),
(5, 5, '광주', '편안한 탑승이었습니다.');

-- PAYMENT 테이블에 데이터 삽입
INSERT INTO PAYMENT (call_id, payment_result) VALUES
(1, 15000),
(2, 20000),
(3, 25000),
(4, 30000),
(5, 35000);

-- TEST 쿼리
select * from USER;

-- 결제 시 필요한 데이터 쿼리
select 
	u.user_id,
    u.name,
	p.payment_info,
    p.cvc,
    p.password,
    u.birth
from (
	select user_id, birth, name from USER
    where user_id = 1
) as u,
PAYMENT_METHOD as p
where u.user_id = p.user_id;

-- 이용 기록 불러오기 쿼리
select
	t.call_id,
	u.user_id,
	u.name,
    concat('(', t.start_long, ',', t.start_lat, ')') as start_point,
    t.apx_payment
from (
	select * from USER
    where user_id = 4
) as u,
TAXI_CALL as t
where t.user_id = u.user_id;

-- 사용자 삭제 시 결제 방법 삭제 확인
select * from USER;
delete from USER where user_id = 5;

