CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);
ALTER TABLE 교수
ADD CONSTRAINT

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);
ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역_수강내역번호 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목내역_과목번호 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수_교수번호 PRIMARY KEY (교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT PK_강의내역번호 PRIMARY KEY (강의내역번호);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_과목_과목번호 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_교수_교수번호 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_과목_과목번호2 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);
SELECT *
FROM 학생;
SELECT *
FROM 수강내역;

/* 1. 내부조인 INNER JOIN or 동등조인 EQUI-JOIN이라함
   WHERE절에서 = 등호 연산자 사용
   A와 B테이블에 공통된 값을 가진 컬럼을 연결해 조인조건이 참(True)일 경우
   즉 두 컬럼의 값이 같은 행을 추출 */
SELECT 이름,
        주소,
        과목번호
        -- , 학번 -- 열정의가 애매함. 테이블 명필요
        , 학생.학번
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
AND 학생.학번 = '1997131542';

SELECT a. 이름,
        a. 주소,
        b. 과목번호,
        a. 학번          -- from에 테이블 별칭을 사용하면 컬럼에 별칭을 사용해야 함.
FROM 학생 a, 수강내역 b -- 테이블 별칭
WHERE a.학번 = b.학번;
-- 최숙경씨의 수강내역 조회(과목명까지)

SELECT a. 이름, a. 주소, a. 평점,
        c. 과목이름,
        c. 학점
FROM 학생 a, 수강내역 b, 과목 C
WHERE a.학번 = b.학번
AND b. 과목번호 = c. 과목번호
AND a. 이름 = '최숙경';

/*2. 외부조인 OUTER JOIN
    NULL값을*/
SELECT 학생.이름,
        학생.학번,
        수강내역.학번,
        수강내역.수강내역번호,
        수강내역.과목번호
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+);
-- 학생별 수강내역 건수를 조회하시오!
SELECT 학생.이름,
        학생.학번,
        COUNT(수강내역.수강내역번호) as 수강건수,
        count(*)
FROM 학생, 수강내역
WHERE 학생.학번=수강내역.학번(+)
GROUP BY 학생.이름, 학생.학번;

-- 수강학점 출력
SELECT 학생.이름,
        학생.학번,
        수강내역.수강내역번호,
        과목.학점
FROM 학생, 수강내역, 과목
WHERE 학생.학번=수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+); -- outer 조인은 모든 조인에 걸어줘야함

-- 모든 교수의 강의수를 출력하시오.
SELECT 교수.교수이름, 교수.교수번호,
        COUNT(강의내역.강의내역번호) as 강의건수
FROM 교수, 강의내역
WHERE 교수.교수번호 = 강의내역.교수번호(+)
GROUP BY 교수.교수이름, 교수.교수번호;

/* sub query(쿼리 안에 쿼리)
1. 스칼라 서브쿼리(select절)
2. 인라인 뷰 (from절)
3. 중첩쿼리(where절)

-- 스칼라 서브쿼리는 단일행 반환
-- 주의할 점은 메인 쿼리테이블의 행 건수 만큼 조회하기 때문
-- 건수가 많은 테이블이라면 조인을 하는게 더 좋음. */

SELECT a.emp_name,
        a.department_id,
        (SELECT department_name -- 1개의 컬럼만 가능 1=1 부서번호=부서명
        FROM departments          -- 부서테이블의 부서 아이디는 pk 유니크함.
        WHERE department_id = a.department_id) as dep_name,
        (SELECT job_title
        FROM jobs
        WHERE job_id = a.job_id) as job_title
FROM employees a;

-- 중첩 서브쿼리(where절)
-- 특정 값이 필요할 때
-- 직원 중 salary가 전체평균보다 높은 직원을 출력하시오.
SELECT AVG(salary)
FROM employees;
-- 6461.831775700934579439252336448598130841
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                FROM employees);
-- 샐러리가 가장 높은 직원을 출력하시오.
SELECT MAX(salary)
FROM employees;
-- 24000
SELECT emp_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary)
                FROM employees);
-- 수강이력이 있는 학생의 이름을 조회하시오
SELECT 이름
FROM 학생
WHERE 학번 IN (SELECT 학번
                FROM 수강내역);
SELECT 이름
FROM 학생
WHERE 학번 IN (1997131542, 1998131205, 1999232102, 2001110131, 2001211121, 2002110110, 1999232102);

-- 평점이 가장 높은 학생의 수강내역을 출력하시오.
SELECT MAX(평점)
FROM 학생;
--
SELECT 
FROM 학생
WHERE 학번 IN(SELECT MAX(평점)
            FROM 학생);
--
SELECT 학생.이름,
        학생.학번,
        과목.과목이름
FROM 학생, 수강내역, 과목
WHERE 학생.학번=수강내역.학번
AND 수강내역.과목번호=과목.과목번호
AND 학생.평점 = (SELECT MAX(평점)
                FROM 학생);
                
-- 고객의 구매이력을 출력하시오.(member, cart) 테이블 사용
-- 1개의 카트에는 여러 개 상품이 기록될 수 있음.
-- 고객아이디, 고객명, 카트사용횟수(이력수), 구매상품 품목수, 상품구매수량
-- 정렬은(총 성퓸구매수량 내림차순)
SELECT *
FROM cart;
--
SELECT *
FROM member;
--
SELECT member.mem_id,
        member.mem_name,
        cart.cart_member,
        COUNT(cart.cart_no) as 카트사용횟수
FROM member, cart
WHERE member.mem_id = cart.cart_member(+)
GROUP BY member.mem_name, member.mem_id;

--
SELECT COUNT(cart.cart_no)
FROM cart;

