-- ROLLUP
-- 그룹별 소계와 총계를 집계함
-- 표현식의 갯수가 n이면 n+1 레벨까지, 하위 레벨에서 상위 레벨 순으로
-- 데이터가 집계됨

-- 직업별 마일리지의 합계와 전체 합계 출력
SELECT mem_job,
        sum(mem_milage) as 마일리지합
FROM member
GROUP BY ROLLUP(mem_job);
-- 연습용 계정에 있음
-- 카테고리, 서브 카테고리별 상품 수
SELECT prod_category,
        prod_subcategory,
        COUNT(prod_id) as 상품수
FROM products;
GROUP BY ROLLUP(prod_category,
        prod_subcategory);
        

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

-- 행단위 집합 UNION, UNION ALL, MINUS, INTERSECT
SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '한국';
UNION -- 중복 제거
SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '일본';
ORDER BY seq; -- 마지막 select문에만 사용 가능

SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '한국';
UNION ALL -- 각 select 결과 합
SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia;
WHERE country = '한국';
MINUS -- 차집합
SELECT goods
FROM exp_goods_asia;
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia;
WHERE country = '한국';
INTERSECT -- 교집합
SELECT goods
FROM exp_goods_asia;
WHERE country = '일본'
UNION
SELECT '내용'
FROM dual;
-- 집합 대상의 컬럼의 수와 타입이 일치하면 사용 가능

SELECT gubun,
        sum(loan_jan_amt) as 대출합
FROM kor_loan_status
GROUP BY gubun;
SELECT '합계', SUM(loan_jan_amt)
FROM kor_loan_status;


/*
 정규표현식 oracle 10g부터 사용 가능 REGEXP_ <-로 시작하는 함수
 .(dot) or [] <-- 모든 문자 1글자를 의미함.
 ^시작, $끝 [^] <-- 대괄호 안의 ^ not을 의미함.
 {n}: n번 반복, {n,}: n이상 반복, {n,m} n 이상 m 이하 반복
*/
-- REGEXP_LIKE: 정규식 패턴 검색
SELECT mem_name, mem_comtel
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');

-- mem_mail 데이터 중 영문자 3~5자리 이메일 주소 패턴 추출
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{3,5}@');
-- mem_add2 주소에서 한글로 끝나는 패턴의 주소를 추출하시오
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[가-힝]$');
-- 다음 패턴의 주소를 조회하시오
-- 한글 + 띄어쓰기 + 숫자 ex)아파트 5동
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[가-힝][0-9]');
-- 한글만 있는 주소 검색
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[가-힝]+$');
-- 한글이 없는 주소를 검색하시오!
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[^ 가-힝]+$');
-- 또는
SELECT mem_name, mem_add2
FROM member
WHERE NOT REGEXP_LIKE(mem_add2, '[가-힝]');
-- |: 또는 (): 그룹
-- J로 시작하며, 세번째 문자가 m or n인 직원이름 조회
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^j.(m|n)');
-- REGEXP_SUBSTR 정규표현식 패턴과 일치하는 문자열을 반환
-- 이메일 기준으로 앞 뒤 출력
SELECT mem_mail,
        REGEXP_SUBSTR(mem_mail, '[^@], 1, 1') as 아이디,
        REGEXP_SUBSTR(mem_mail, '[^@], 1, 2') as 도메인
FROM member;


SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 1) as ex1,
        REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 2) as ex1,
        REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 3) as ex1,
        REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 4) as ex1
FROM dual;

-- mem_add1에서 공백을 기준으로 첫번째 단어를 출력하시오.
SELECT REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 1) as 시도,
        REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 2) as 군구
FROM member;

-- REGEXP_REPLACE 대상 문자열에서
-- 정규 표현식 패턴을 적용하여 다른 패턴을 대체
SELECT REGEXP_REPLACE('Ellen Hidi Smith', '(.*) (.*) (.*)', '\3, \1 \2') as re
FROM dual;
-- 대전의 주소들을 모두 '대전'으로 바꿔서 출력하시오 id: p001제외
-- 대전광역시 -> 대전
-- 대전시    -> 대전
SELECT mem_add1,
        REGEXP_REPLACE(mem_add1, '(.{1,5}) (.*)', '대전 \2') as 주소
FROM member
WHERE mem_add1 LIKE '%대전%'
    AND mem_id != 'p001';

-- 펄 표기법 \w = [a-zA-Z0-9], \d = [0-9]
-- 전화번호 뒷자리에서 동일한 번호가 반복되는 사원 조회
SELECT emp_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$');
-- (\d\d)\1$' (숫자숫자) \1 첫번째 그룹 캡처 그룹을 다시 참조

-- ^\d*\.?\d{0,2}
-- 어떤 패턴일까요?
-- ^ 시작
-- \d = 0-9
-- *
-- \. 문자로서의 .
-- ? 앞에 반복
-- \d{0,2} 숫자입력{소수점 둘째자리까지}