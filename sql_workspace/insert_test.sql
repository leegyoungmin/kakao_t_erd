USE KAKAO_T;

-- 회원 가입 상황
INSERT INTO USER(NAME, PHONE_NUMBER, BIRTH)
VALUE ('윤수빈', '01019538118', '960626');

SELECT * FROM USER
WHERE NAME = '윤수빈' AND BIRTH = '960626';

-- 결재 정보를 추가하는 상황
INSERT INTO PAYMENT_METHOD(PAYMENT_INFO, USER_ID, EXPIRATION_PERIOD, CVC, PASSWORD)
    VALUE ('5756408140393018', 1001000, '0130', '278', '34');

SELECT * FROM PAYMENT_METHOD AS P
WHERE (
          SELECT USER_ID FROM USER
          WHERE NAME = '윤수빈' AND BIRTH = '960626'
      ) = P.USER_ID;

-- 사용자가 택시를 부르는 상황에서 CALL 테이블 생성
/*
{'START_LAT': '34.8825',
 'START_LONG': '128.62667',
 'END_LAT': '36.82167',
 'END_LONG': '128.63083',
 'IS_PREMIUM': 0,
 'CALL_TIME': '2024-04-29 11:18:20',
 'USER_ID': 1000100}
*/

INSERT INTO TAXI_CALL(START_LAT, START_LONG, END_LAT, END_LONG, IS_PREMIUM, USER_ID)
    VALUE (34.8825, 128.62667, 36.82167, 128.63083, 0, 1001000);

SELECT * FROM TAXI_CALL AS T
WHERE (
          SELECT USER_ID FROM USER
          WHERE NAME = '윤수빈' AND BIRTH = '960626'
      ) = T.USER_ID;

-- 택시 기사가 콜을 잡은 상황에서 데이터 생성
/*
{'CALL_ID': 1001, 'DRIVER_ID': 474, 'CATCH_TIME': '2024-04-29 22:50:02'}
 */

INSERT INTO TAXI_CATCH(CALL_ID, DRIVER_ID)
    VALUE (1001, 474);

SELECT * FROM TAXI_CATCH
WHERE CALL_ID = 1001;

-- 기사 회원 가입 상황
/*
 {'DIRVER_ID': <function id(obj, /)>,
 'NAME': '박성수',
 'SSN': '4805131504552',
 'COMPANY': '유한회사 최윤이',
 'REGION': '고성군'}
 */

INSERT INTO DRIVER(NAME, SSN, COMPANY, REGION)
    VALUE ('박성수', '4805131504552', '유한회사 최윤이', '고성군');

SELECT * FROM DRIVER
WHERE SSN = '4805131504552';

-- 기사 차량 등록 상황
-- {'CAR_NUM': '충남27아1939', 'PAY_TYPE': 1, 'CAR_TYPE': '벤티'}

INSERT INTO CAR(DRIVER_ID, CAR_NUM, PAY_TYPE, CAR_TYPE)
    VALUE (1000, '충남27아1939', 1, '벤티');

SELECT * FROM CAR
WHERE DRIVER_ID = 1000;

-- 운행 가능 지역 추가
/*
 {'REGION': '제주도',
 'DIST': ...}
 */
INSERT INTO REGION (REGION, DIST)
    VALUE ('제주도', ST_GEOMFROMTEXT('POLYGON((35.54634329989859 127.58703097979333, 38.202099584969154 128.80885533480398))'));

SELECT REGION, ST_ASTEXT(DIST) FROM REGION
WHERE REGION = '제주도';

-- 결제가 수행되는 경우
/*
카드 번호 : 5756 40** **** 3018
최종 결재 금액 : 34000
캐치 ID : 1000
 */

INSERT INTO PAYMENT(CATCH_ID, CARD_NUM, PAYMENT_RESULT)
    VALUE (1000, '575640******3018', 34000);

SELECT * FROM PAYMENT
WHERE CATCH_ID = 1000;