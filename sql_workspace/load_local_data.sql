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

