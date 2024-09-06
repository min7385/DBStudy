/*
    분석함수
    테이블에 있는 row에 대해 특정 그룹별로 집계 값을 산출할 때 사용함.
    GROUP BY절을 사용하는 집계함수와 다른 점은 row 손실 없이 집계값을 산출할 수 있다.
    
    분석함수는 자원을 많이 소비하는 경향이 있어, 여러 분석함수를 동시에 사용할 경우,
    최대한 메인 쿼리에서 사용하는 것이 좋음.(인라인 뷰에서 사용하기보단..)
    분석함수(매개변수) OVER(PARTITION BY expr1, expr2..
                          ORDER BY expr3...
                          WINDOW 절)
    AVG, SUM, MAX, COUNT, CUM_DIST, DENSE_RANK, RANK, PERCENT_RANK, FIRST, LAST, LAG.
    PATITION BY: 계산 대상 그룹을 정함.
    ORDER BY   : 대상 그룹에 대한 정렬 수행
    WINDOW     : 파티션으로 분할된 그룹에 대해서 더 상세한 그룹으로 분할 row or range
*/
-- 부서별 이름순으로 순번 출력
SELECT ROWNUM as rnum
     , department_id, emp_name
     , ROW_NUMBER() OVER(PARTITION BY department_id
                        ORDER BY emp_name) dep_rownum
FROM employees;
-- RANK 동일 순위 건너뜀
-- DENSE_RANK() 건너뛰지 않음.
SELECT department_id, emp_name, salary
     , RANK() OVER(PARTITION BY department_id
                   ORDER BY salary DESC) as rnk
     , DENSE_RANK() OVER(PARTITION BY department_id
                   ORDER BY salary DESC) as debse_rnk
FROM employees;
-- 위에서 부서별 1등만 조회 인라인 뷰
SELECT *
FROM(SELECT department_id, emp_name, salary
           , RANK() OVER(PARTITION BY department_id
                       ORDER BY salary DESC) as rnk
          , DENSE_RANK() OVER(PARTITION BY department_id
                     ORDER BY salary DESC) as debse_rnk
    FROM employees)
WHERE rnk=1;

-- 직원의 부서별 월급 합계와 전체 합계출력
SELECT emp_name, salary, department_id
     , SUM(salary) OVER (PARTITION BY department_id) as 부서별합계
     , MAX(salary) OVER (PARTITION BY department_id) as 부서최대
     , MIN(salary) OVER (PARTITION BY department_id) as 부서최소
     , COUNT(*) OVER (PARTITION BY department_id) as 부서직원수
     , SUM(salary) OVER () as 전체합계
FROM employees;
-- 모든 학생들의 전공별 평점을 기준으로(내림차순) 순위를 출력하시오.
SELECT 이름
     , 전공
     , 평점
     , RANK() OVER(PARTITION BY 전공
                   ORDER BY 평점 DESC) as 전공별순위
     , RANK() OVER(ORDER BY 평점 DESC) as 전체순위
FROM 학생
ORDER BY 2, 4;
-- 전공별 학생 수를 기준으로 순위를 구하시오(학생수가 많으면 1, ...)
SELECT 전공, COUNT(*) as 학생수
FROM 학생
GROUP BY 전공;
--
SELECT 전공, 학생수
     , RANK() OVER(ORDER BY 학생수 DESC) as 순위
FROM (SELECT 전공, COUNT(*) as 학생수
      FROM 학생
      GROUP BY 전공
);
-- 또는
SELECT 전공
     , COUNT(*) as 학생수
     , RANK() OVER(ORDER BY COUNT(*) DESC) as 순위
FROM 학생
GROUP BY 전공;
/* LAG 선행 로우의 값을 반환
   LEAD 후행 로우의 값을 가져와서 반환
*/
SELECT emp_name, department_id, salary
     -- current행보다 1행 앞선 행의 emp_name 출력, 없으면 '가장 높음' 출력
     , LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) lags
     , LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) leads
FROM employees
WHERE department_id IN(30, 60);

-- 전공별로 각 학생의 평점보다 한단계 높은 학생과의 평점 차이를 출력하시오
-- 1. 전공별로 각 학생의 평점 조회
-- 2. LAG 사용
-- 3. 평점차이 계산
SELECT 이름
     , 전공
     , 평점 as 나의평점
     , LAG(이름, 1, '1등') OVER(PARTITION BY 전공
                              ORDER BY 평점 DESC) as 바로위
     , LAG(평점, 1, 평점) OVER(PARTITION BY 전공
                              ORDER BY 평점 DESC) - 평점 as 차이
FROM 학생;
/* WINDOW절
   ROW: 로우 단위로 WINDOW절을 지정
   RANGE: 논리적인 범위로 WINDOW절 지정
   BETWEEN ~ AND: WINDOW절의 시작과 끝 지점을 명시한다.
                  BETWEEN을 명시하지 않고 두번쨰 옵션만 지정하면 이지점이 시작이되고
                  끝 지점은 현재 로우가 됨.
   UNBOUNDED PRECEDING: 파티션으로 구분된 첫번째 로우가 시작점
   UNBOUNDED FOLLOWING: 파티션으로 구분된 마지막 로우가 끝 지점이 됨.
   CURRENT ROW: 시작 및 끝 지점이 현재 로우
   expr PRECEDING: 끝 지점일 경우, 시작점은 expr
   expr FOLLOWING: 시작점일 경우 끝지점은 expr
*/
SELECT department_id, emp_name, hire_date, salary
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING
                        AND CURRENT ROW) as preceding_curr
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW
                        AND UNBOUNDED FOLLOWING) as curr_following
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING
                        AND CURRENT ROW) as junl_curr
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING
                        AND 1 FOLLOWING) as junl_daum1
    -- RANGE 논리적 범위(숫자와 날짜의 형태로 범위를 줄 수 있음)
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                       RANGE 365 PRECEDING) as years
FROM employees;
-- study
-- 월별 전체 누적매출을 출력하시오
SELECT *
FROM order_info;
--
SELECT SUBSTR(a.reserv_date, 1, 6) as 년월
     , SUM(b.sales) as 월매출
FROM reservation a, order_info b
WHERE a.reserv_no = b.reserv_no
GROUP BY SUBSTR(a.reserv_date, 1, 6)
ORDER BY 1;
---- + 누적집계
SELECT t1.*
     , SUM(t1.월매출) OVER(ORDER BY 년월
                          ROWS BETWEEN UNBOUNDED PRECEDING
                          AND CURRENT ROW) as 누적집계
FROM (SELECT SUBSTR(a.reserv_date, 1, 6) as 년월
           , SUM(b.sales) as 월매출
        FROM reservation a, order_info b
        WHERE a.reserv_no = b.reserv_no
        GROUP BY SUBSTR(a.reserv_date, 1, 6)
        ORDER BY 1
    ) t1;
---- 전체 중 차지하는 비율
SELECT t1.*
     , SUM(t1.월매출) OVER(ORDER BY 년월
                          ROWS BETWEEN UNBOUNDED PRECEDING
                          AND CURRENT ROW) as 누적집계
     , ROUND(RATIO_TO_REPORT(t1.월매출) OVER() * 100,2) || '%' as 비율
FROM (SELECT SUBSTR(a.reserv_date, 1, 6) as 년월
           , SUM(b.sales) as 월매출
        FROM reservation a, order_info b
        WHERE a.reserv_no = b.reserv_no
        GROUP BY SUBSTR(a.reserv_date, 1, 6)
        ORDER BY 1
    ) t1;
-- 201210 ~ 201212
-- 지역별, 대출종류별, 월별, 대출잔액과 지역별 파티션 대출종류별 대출잔액의 %를 구하시오.
-- 1. 지역, 구분, 각 년월에 해당되는 컬럼 출력 select문 작성
-- 2. 지역별, 구분별 합계
-- 3. 2에서 구한 합계와 구분별 (비율)을 출력

-- 1. 지역, 구분, 각 년월에 해당되는 컬럼 출력 select문 작성
/*
SELECT region
     , gubun
     , period
FROM kor_loan_status;
-- 2. 지역별, 구분별 합계
SELECT region
     , gubun
     , SUM(CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END) AS "201210"
     , SUM(CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END) AS "201211"
     , SUM(CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END) AS "201212"
FROM kor_loan_status
GROUP BY region, gubun
ORDER BY region, gubun;
*/