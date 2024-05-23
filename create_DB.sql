drop database KAKAO_T;
create database if not exists KAKAO_T;
use KAKAO_T;

create table if not exists FAMILY
(
    family_id int primary key,
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
    foreign key (user_id) references USER (user_id)
);

create table if not exists TAXI_CALL
(
    call_id int primary key ,
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
    region    varchar(20)  not null,
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
    catch_id int primary key,
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
    foreign key (catch_id) references TAXI_CATCH (catch_id)
);

-- INSERT INTO --
INSERT INTO FAMILY (family_id, user_id) VALUES
(1, 1000001),
(2, 1000002),
(3, 1000003),
(4, 1000004),
(5, 1000005),
(6, 1000006),
(7, 1000007),
(8, 1000008),
(9, 1000009),
(10, 1000010);

INSERT INTO USER (user_id, name, phone_number, birth, point, family_id) VALUES
(1000001, 'Alice', '123-456-7890', '900101', 100, 1),
(1000002, 'Bob', '234-567-8901', '920202', 200, 2),
(1000003, 'Charlie', '345-678-9012', '930303', 150, 3),
(1000004, 'David', '456-789-0123', '940404', 180, 4),
(1000005, 'Eve', '567-890-1234', '950505', 220, 5),
(1000006, 'Frank', '678-901-2345', '960606', 140, 6),
(1000007, 'Grace', '789-012-3456', '970707', 160, 7),
(1000008, 'Hank', '890-123-4567', '980808', 170, 8),
(1000009, 'Ivy', '901-234-5678', '990909', 190, 9),
(1000010, 'Jack', '012-345-6789', '000101', 210, 10);

INSERT INTO PAYMENT_METHOD (payment_info, user_id, expiration_period, cvc, password) VALUES
('1234567812345678', 1000001, '1225', '123', '12'),
('2345678923456789', 1000002, '1124', '456', '34'),
('3456789034567890', 1000003, '1023', '789', '56'),
('4567890145678901', 1000004, '0922', '012', '78'),
('5678901256789012', 1000005, '0821', '345', '90'),
('6789012367890123', 1000006, '0720', '678', '12'),
('7890123478901234', 1000007, '0619', '901', '34'),
('8901234589012345', 1000008, '0518', '234', '56'),
('9012345690123456', 1000009, '0417', '567', '78'),
('0123456701234567', 1000010, '0316', '890', '90');


INSERT INTO TAXI_CALL (call_id, start_long, start_lat, end_long, end_lat, is_premium, apx_payment, user_id) VALUES
(1, 37.5665, 126.9780, 37.5675, 126.9790, FALSE, 10000, 1000001),
(2, 37.5775, 126.9890, 37.5785, 126.9900, TRUE, 20000, 1000002),
(3, 37.5885, 127.0000, 37.5895, 127.0010, FALSE, 15000, 1000003),
(4, 37.5995, 127.0110, 37.6005, 127.0120, TRUE, 25000, 1000004),
(5, 37.6105, 127.0220, 37.6115, 127.0230, FALSE, 12000, 1000005),
(6, 37.6215, 127.0330, 37.6225, 127.0340, TRUE, 22000, 1000006),
(7, 37.6325, 127.0440, 37.6335, 127.0450, FALSE, 14000, 1000007),
(8, 37.6435, 127.0550, 37.6445, 127.0560, TRUE, 24000, 1000008),
(9, 37.6545, 127.0660, 37.6555, 127.0670, FALSE, 13000, 1000009),
(10, 37.6655, 127.0770, 37.6665, 127.0780, TRUE, 23000, 1000010);

INSERT INTO REGION (region, dist) VALUES
('Seoul', ST_GeomFromText('POLYGON((126.9780 37.5665, 127.9780 37.5665, 127.9780 37.6765, 126.9780 37.6765, 126.9780 37.5665))')),
('Busan', ST_GeomFromText('POLYGON((129.0756 35.1796, 130.0756 35.1796, 130.0756 35.2896, 129.0756 35.2896, 129.0756 35.1796))')),
('Incheon', ST_GeomFromText('POLYGON((126.7052 37.4563, 127.7052 37.4563, 127.7052 37.5663, 126.7052 37.5663, 126.7052 37.4563))')),
('Daegu', ST_GeomFromText('POLYGON((128.6025 35.8722, 129.6025 35.8722, 129.6025 35.9822, 128.6025 35.9822, 128.6025 35.8722))')),
('Gwangju', ST_GeomFromText('POLYGON((126.8526 35.1595, 127.8526 35.1595, 127.8526 35.2695, 126.8526 35.2695, 126.8526 35.1595))'));

INSERT INTO DRIVER (driver_id, name, ssn, company, region, rating) VALUES
(1, 'David', '8001011234567', 'TaxiCo', 'Seoul', 4.5),
(2, 'Eve', '8102022345678', 'TaxiCo', 'Busan', 4.7),
(3, 'Frank', '8203033456789', 'TaxiCo', 'Incheon', 4.6),
(4, 'Grace', '8304044567890', 'TaxiCo', 'Daegu', 4.8),
(5, 'Hank', '8405055678901', 'TaxiCo', 'Gwangju', 4.9),
(6, 'Ivy', '8506066789012', 'TaxiCo', 'Seoul', 4.4),
(7, 'Jack', '8607077890123', 'TaxiCo', 'Busan', 4.3),
(8, 'Karen', '8708088901234', 'TaxiCo', 'Incheon', 4.2),
(9, 'Leo', '8809099012345', 'TaxiCo', 'Daegu', 4.1),
(10, 'Mia', '8910100123456', 'TaxiCo', 'Gwangju', 4.0);


INSERT INTO CAR (driver_id, pay_type, car_num, car_type) VALUES
(1, FALSE, '11가1234', 'Sedan'),
(2, TRUE, '22나5678', 'SUV'),
(3, FALSE, '33다9012', 'Van'),
(4, TRUE, '44라3456', 'Truck'),
(5, FALSE, '55마7890', 'Minivan'),
(6, TRUE, '66바1234', 'Sedan'),
(7, FALSE, '77사5678', 'SUV'),
(8, TRUE, '88아9012', 'Van'),
(9, FALSE, '99자3456', 'Truck'),
(10, TRUE, '00차7890', 'Minivan');


INSERT INTO TAXI_CATCH (catch_id, call_id, driver_id, rating, comment) VALUES
(1, 1, 1, 4.0, 'Good service'),
(2, 2, 2, 4.5, 'Very comfortable ride'),
(3, 3, 3, 4.3, 'Nice driver'),
(4, 4, 4, 4.7, 'Smooth ride'),
(5, 5, 5, 4.2, 'Friendly driver'),
(6, 6, 6, 4.6, 'Clean car');