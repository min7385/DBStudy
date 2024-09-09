/*  PL/SQL(Procedural Language/SQL
    집합적 언어와 절차적 언어의 특징을 모두 가지고 있다.
    일반 프로그래밍 언어와 다른 점은 모든 코드가 DB 내부에서 만들어져
    처리되므로 수행 속도와 안정성 측면에서 큰 장점이 있다.
    하지만, 해석과 디버깅이 어려움.
*/
-- 기본 단위를 블록이라고 하며, 블록은 이름부, 선언부, 실행부, 예외처리부로 구성됨.
-- 1. 이름부는 블록의 명칭이 오는데 생략할 때는 익명 블록이됨. (테스트용 저장되지 않음)
SET SERVEROUTPUT ON;
DECLARE
  vi_num NUMBER;  -- 변수(선언부에서 선언을 할 수 있으며 실행부에서 사용 가능)
  vi_pi CONSATANT NUMBER := 3.14; -- 상수
BEGIN
  -- vi_pi := 1; <-- 오류남 상수는 변경 불가.
  DBMS_OUTPUT.PUT_LINE(vi_num); -- 초기밧을 할당하지 않으면 타입 상관없이 NULL
  vi_num := 100;
  DBMS_OUTPUT.PUT_LINE(vi_num);
END;
-- 실행은 모든 블럭을 선택한 뒤 ctrl + enter
-- 결과값만 보려면 [보기 - DBMS출력 - 실행계정 접속]

DECLARE
  vs_emp_name VARCHAR2(80);
  vs_dep_name departments.department_name%TYPE;
BEGIN
  SELECT a.emp_name, b.department_name
  INTO vs_emp_name, vs_dep_name -- 조회결과를 변수에 할당(타입, 순서) 맞아야함.
  FROM employees a
     , departments b
  WHERE a.department_id = b.department_id
  AND   a.employee_id = 100;
DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name);
END;
-- 선언이 필요 없으면 BEGIN만 사용 가능
BEGIN
  DBMS_OUTPUT.PUT_LINE('3 * 2 = ' || 3 * 2); -- 연산자 사용 가능
END;
-- IF문
DECLARE
  vn_num1 NUMBER := 10;
  vn_num2 NUMBER := :a;
BEGIN
  IF vn_num1 > vn_num2 THEN
    DBMS_OUTPUT.put_LINE(vn_num1 || '이 큰 수');
  ELSIF vn_num1 = vn_num2 THEN
    DBMS_OUTPUT.put_LINE('같음');
  ELSIF vn_num2 BETWEEN 11 AND 20 THEN
    DBMS_OUTPUT.PUT_LINE('11~20사이');
  ELSE
    NULL; -- 아무것도 실행구문 없을 때
  END if;
END;
/* 신입생이 들어왔습니다. ^^
   입력값은 '이름', '전공'
   신입생의 학번을 생성하여 학생 테이블에 INSERT 하세요
   - 학번은 기존 학번의 앞자리 4자리가 올해년도라면 +1
   - 아니라면 올해년도 + 000001
*/

-- 1. 올해년도 변수
-- 2. 마지막 학번 변수
-- 3. 생성학번 변수
-- 실행부
--      마지막 학번 조회
--      조건식 (올해 년도와 비교)
--      학생 테이블 INSERT
DECLARE
    vn_year VARCHAR2(4) := TO_CHAR(sysdate, 'YYYY');
    vn_make_no NUMBER := 0;
    vn_max_no NUMBER := 0;
BEGIN
    -- 마지막 학번 조회
    SELECT MAX(학번)
      INTO vn_max_no
    FROM 학생;
    -- 조건식 (올해 년도와 비교)
    IF vn_year = SUBSTR(vn_max_no, 1, 4) THEN
       vn_make_no := vn_max_no +1;
    ELSE
       vn_make_no := vn_year || '000001';
    END IF;
    
    INSERT INTO 학생(학번, 이름, 전공)
    VALUES (vn_make_no, :이름, :전공);
    COMMIT;
END;

SELECT *
FROM 학생;

-- LOOP문
DECLARE
    dan NUMBER := 3;
    vn_i NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(dan || '*' || vn_i || '=' || (dan*vn_i));
        vn_i := vn_i+1;
        EXIT WHEN vn_i > 9; -- 단순LOOP는 탈출조건 필수!
    END LOOP;
END;

-- 단순 LOOP문으로 2~9단 출력
DECLARE
    dan NUMBER := 2;
    vn_i NUMBER :=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(dan || '단 =====');
        vn_i := 1;
            LOOP
                DBMS_OUTPUT.PUT_LINE(dan || '*' || vn_i || '=' || (dan*vn_i));
                vn_i := vn_i+1;
                EXIT WHEN vn_i > 9;
            END LOOP;
            dan := dan+1;
            EXIT WHEN dan > 9;
    END LOOP;
END;

-- WHILE문
DECLARE
    dan NUMBER := 2;
    su NUMBER := 1;
BEGIN
    WHILE su <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE(dan*su);
        su := su +1;
    END LOOP;
END;

-- FOR문
DECLARE
    dan NUMBER := 3;
BEGIN
--    FOR i IN 1..9 -- i는 1씩 증가 변경불가, 참조가능
    FOR i IN REVERSE 1..9 -- 9부터 1씩 감소
        LOOP
            CONTINUE WHEN i = 5; -- 해당 조건일 때 아래 건너뜀
            DBMS_OUTPUT.PUT_LINE(dan*i);
        END LOOP;
END;

-- MOD 함수를 사용자 정의함수로 구현
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
    RETURN NUMBER -- 반환타입
IS
    vn_remainder NUMBER := 0; -- 반환할 나머지
    vn_quotient NUMBER := 0; -- 몫
BEGIN
    vn_quotient := FLOOR(num1/num2);
    vn_remainder := num1 - (num2 * vn_quotient);
    RETURN vn_remainder;
END;

SELECT mod(4,2) as oracle_mod
     , my_mod(4,2) as my
FROM dual;

-- 학생의 이름을 입력받아 이수학점을 리턴하는 함수를 작성하시오(이름이 있는 학생으로만)
-- 함수명: fn_my_credits
-- input: 이름
-- output: 학점합계
CREATE OR REPLACE FUNCTION fn_my_credits()
    RETURN NUMBER
IS
    RETURN
BEGIN
END;

SELECT 이름, fn_my_credits(이름) as 이수학점
FROM 학생
ORDER BY 2 DESC;
--
SELECT 이름
     , 학번
FROM 학생;
SELECT 과목번호
FROM 수강내역;
SELECT 과목번호
     , 학점
FROM 과목;

SELECT b.과목번호
     , SUM(c.학점) as 이수학점
FROM  수강내역 b, 과목 c
WHERE b.과목번호 = c.과목번호
GROUP BY b.과목번호;

SELECT
FROM
WHERE 
