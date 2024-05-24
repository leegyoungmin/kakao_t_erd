use kakao_dev;

-- 회원 가입 상황
insert into USER(name, phone_number, birth)
value ('윤수빈', '01019538118', '960626');

select * from USER
where name = '윤수빈' and birth = '960626';

-- 결재 정보를 추가하는 상황
insert into PAYMENT_METHOD(payment_info, user_id, expiration_period, cvc, password)
value ('5756408140393018', 1001000, '0130', '278', '34');

select * from PAYMENT_METHOD as p
where (
    select user_id from USER
    where name = '윤수빈' and birth = '960626'
) = p.user_id;

-- 사용자가 택시를 부르는 상황에서 CALL 테이블 생성
/*
{'start_lat': '34.8825',
 'start_long': '128.62667',
 'end_lat': '36.82167',
 'end_long': '128.63083',
 'is_premium': 0,
 'call_time': '2024-04-29 11:18:20',
 'user_id': 1000100}
*/

insert into TAXI_CALL(start_lat, start_long, end_lat, end_long, is_premium, user_id)
value (34.8825, 128.62667, 36.82167, 128.63083, 0, 1001000);

select * from TAXI_CALL as t
where (
    select user_id from USER
    where name = '윤수빈' and birth = '960626'
) = t.user_id;

-- 택시 기사가 콜을 잡은 상황에서 데이터 생성
/*
{'call_id': 1001, 'driver_id': 474, 'catch_time': '2024-04-29 22:50:02'}
 */

insert into TAXI_CATCH(call_id, driver_id)
value (1001, 474);

select * from TAXI_CATCH
where call_id = 1001;

-- 기사 회원 가입 상황
/*
 {'dirver_id': <function id(obj, /)>,
 'name': '박성수',
 'ssn': '4805131504552',
 'company': '유한회사 최윤이',
 'region': '고성군'}
 */

insert into DRIVER(name, ssn, company, region)
value ('박성수', '4805131504552', '유한회사 최윤이', '고성군');

select * from DRIVER
where ssn = '4805131504552';

-- 기사 차량 등록 상황
-- {'car_num': '충남27아1939', 'pay_type': 1, 'car_type': '벤티'}

insert into CAR(driver_id, car_num, pay_type, car_type)
value (1000, '충남27아1939', 1, '벤티');

select * from CAR
where driver_id = 1000;

-- 운행 가능 지역 추가
/*
 {'region': '제주도',
 'dist': ...}
 */
insert into REGION (region, dist)
value ('제주도', ST_GeomFromText('POLYGON((35.54634329989859 127.58703097979333, 38.202099584969154 128.80885533480398))'));

select region, ST_AsText(dist) from REGION
where region = '제주도';

-- 결제가 수행되는 경우
/*
카드 번호 : 5756 40** **** 3018
최종 결재 금액 : 34000
캐치 ID : 1000
 */

insert into PAYMENT(catch_id, card_num, payment_result)
value (1000, '575640******3018', 34000);

select * from PAYMENT
where catch_id = 1000;

UPDATE REGION
SET region = '고양특별시'
WHERE region = '고양시';

select * from REGION
where region = '고양특별시';