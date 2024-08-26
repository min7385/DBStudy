SELECT MEM_NAME,
       MEM_JOB,
       MEM_LIKE,
       MEM_MILEAGE
       CASE WHEN MEM_MILEAGE < 5000 THEN 'Silver'
            WHEN MEM_MILEAGE >= 5000 AND MEM_MILEAGE < 8000 THEN 'Gold'
         ELSE 'VIP'
       END as 등급
FROM MEMBER;
WHERE MEM_JOB = '주부' or '회사원' or '자영업'
order by 4desc;

-- 테이블 코멘트
COMMENT ON TABLE tb_info IS '우리반';
-- 컬럼 코멘트
COMMENT ON COLUMN tb_info.info_no IS '출석부 번호';
COMMENT ON COLUMN tb_info.pc_no IS '컴퓨터 번호';
COMMENT ON COLUMN tb_info.nm IS '이름';
COMMENT ON COLUMN tb_info.email IS '이메일';
COMMENT ON COLUMN tb_info.hobby IS '취미';

SELECT table_name, comments
FROM all_tab_comments -- 테이블 정보 조회
WHERE table_name = 'TB_INFO';

-- NULL 조건식과 놀리 조건식(AND, OR, NOT)
SELECT *
FROM departments
WHERE parent_id IS NULL; -- null을 조회할때는 IS or IS NOT

SELECT *
FROM departments
WHERE parent_id IS NOT NULL; -- null이 아닌

-- IN 조건식(여러개 or이 필요할 때)
-- 30, 50, 60, 80 부서 조회
SELECT *
FROM employees
WHERE department_id IN (30, 50, 60, 80); -- 30 or 50 or 60 or 80
-- LIKE 검색(문자열 패턴 검색)
SELECT *
FROM tb_info
WHERE nm LIKE '이%' -- '이'로 시작하는 모든 문자열

SELECT *
FROM tb_info
WHERE nm LIKE '%호' -- '호'로 시작하는 모든 문자열

SELECT *
FROM tb_info
WHERE nm LIKE '%민%' -- '민'이 포함되어 있는 문자열

SELECT *
FROM tb_info
WHERE nm LIKE '%' || : param_val || '%'; -- 매개변수 입력 테스트 : param_val는 이름 아무렇게 지어도 무관

-- 학생 중에 이메일 주소가 naver인 학생을 조회하시오.
SELECT *
FROM tb_info
WHERE email like '%naver%';

SELECT *
FROM tb_info
WHERE email NOT LIKE '%gmail%'
    AND email NOT LIKE '%naver%';
    
-- 문자열 함수 LOWER(소문자로 변경), UPPER(대문자로 변경)
SELECT LOWER('i LIke Mac') as lowers,
       upper('i LIke Mac') as upper
FROM dual;  -- <-- dual 임시 테이블 형태 (Sql select문법을 맞추기 위함)

SELECT emp_name, UPPER(emp_name), employee_id
FROM employees;
-- employees 테이블에서 -> william이 포함된 직원을 모두 조회하시오.
SELECT emp_name, UPPER(emp_name)
FROM employees
WHERE UPPER(emp_name) LIKE '%' || UPPER('william') || '%';
-- LIKE 검색에서 길이까지 징확하게 찾고 싶을 때
INSERT INTO TB_INFO (info_no, pc_no, nm, email)
VALUES (19, 30, '팽수', '팽수@email.com');
INSERT INTO TB_INFO (info_no, pc_no, nm, email)
VALUES (21, 27, '김팽', '팽수@email.com');
INSERT INTO TB_INFO (info_no, pc_no, nm, email)
VALUES (25, 32, '김팽수다', '팽수@email.com');
SELECT *
FROM tb_info
WHERE nm LIKE '%팽_%';    -- _는 모든 하나
-- 문자열 자르기 SUBSTR(char, pos, len) 대상 문자열 char의 pos번째부터 len길이 만큼 자름
SELECT SUBSTR('ABCD EFG', 1, 4) as ex1, -- pos에 0이오면 디포트 1
        SUBSTR('ABCD EFG', 4) as ex2,   -- 입력값이 2개일 경우 해당 인덱스부터 끝까지
        SUBSTR('ABCD EFG', -3, -) as ex3 -- 시작이 음수이면 뒤에서부터
FROM dual;
-- 문자열 위치 찾기 INSTR(p1, p2, p3, p4) p1: 대상문자열, p2: 찾을 문자열 p3: 시작 p4: 번째
SELECT INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕') as ex1, -- p3, p4 디폴트 1
        INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕', 5) as ex2,
        INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕', 1, 2) as ex3, -- 두번째 안녕 시작 위치
        INSTR('안녕 만나서 반가워, 안녕은 hi', 'hello') as ex4  -- 없으면 0
FROM dual;

-- tb_info 학생의 이름과 이메일 주소를 출력하시오
-- 단 이메일 주소는 id, domain 분리하여 출력
-- ex) pangsu@gmail.com -> id: pangsu , domain: gmail.com
SELECT nm,
        email,
        INSTR(email, '@'),
        SUBSTR(email, 1, INSTR(email, '@')-1) as 아이디,
        SUBSTR(email, 1, INSTR(email, '@')+1) as 도메인 -- 얘 처리해
FROM tb_info;

--  공백제거 TRIM, LTRIM, RTRIM
SELECT LTRIM(' ABC ') as ex1,  -- 왼쪽 공백 제거
        RTRIM(' ABC ') as ex2, -- 오른쪽 공백 제거
        TRIM(' ABC ') as ex3 -- 양쪽 공백 제거
FROM dual;
-- 문자열 패딩 LPAD, RPAD       ex) 학번만들 때 사용
SELECT LPAD(123, 5, '0') as ex1,      -- (대상, 길이, 표현값) LPAD는 왼쪽부터 채움
        LPAD(1, 5, '0') as ex2,       
        LPAD(123456, 5, '0') as ex3,  -- 넘어서면 제거됨(주의)
        LPAD(2, 5, '*') as ex4        -- R은 오른쪽부터
FROM dual;
-- 문자열 변경 REPLACE(대상문자열, 찾는값, 변경값)
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as ex1,
    -- replace는 단어 정확하게 매칭, translate는 한글자씩 매칭
    TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as ex2
FROM dual;

desc member;
-- member 계정의 member 테이블을 조회하시오
-- 검색조건: 대전의 중구에 사는 여자
-- 주소는 mem_add
-- 성별은 mem_regno2(홀수 남자, 짝수 여자)

SELECT mem_id,
        mem_name,
        mem_regno1 || '-' || SUBSTR(mem_regno2, 1, 1) || '******' as regno,
        mem_add1, mem_add2, mem_job
FROM member
WHERE mem_add1 LIKE '%대전%'
    AND mem_add1 LIKE '%중구%'
    AND SUBSTR(mem_regno2, 1, 1) = '2';
















