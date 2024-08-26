SELECT MEM_NAME,
       MEM_JOB,
       MEM_LIKE,
       MEM_MILEAGE
       CASE WHEN MEM_MILEAGE < 5000 THEN 'Silver'
            WHEN MEM_MILEAGE >= 5000 AND MEM_MILEAGE < 8000 THEN 'Gold'
         ELSE 'VIP'
       END as ���
FROM MEMBER;
WHERE MEM_JOB = '�ֺ�' or 'ȸ���' or '�ڿ���'
order by 4desc;

-- ���̺� �ڸ�Ʈ
COMMENT ON TABLE tb_info IS '�츮��';
-- �÷� �ڸ�Ʈ
COMMENT ON COLUMN tb_info.info_no IS '�⼮�� ��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '��ǻ�� ��ȣ';
COMMENT ON COLUMN tb_info.nm IS '�̸�';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';

SELECT table_name, comments
FROM all_tab_comments -- ���̺� ���� ��ȸ
WHERE table_name = 'TB_INFO';

-- NULL ���ǽİ� � ���ǽ�(AND, OR, NOT)
SELECT *
FROM departments
WHERE parent_id IS NULL; -- null�� ��ȸ�Ҷ��� IS or IS NOT

SELECT *
FROM departments
WHERE parent_id IS NOT NULL; -- null�� �ƴ�

-- IN ���ǽ�(������ or�� �ʿ��� ��)
-- 30, 50, 60, 80 �μ� ��ȸ
SELECT *
FROM employees
WHERE department_id IN (30, 50, 60, 80); -- 30 or 50 or 60 or 80
-- LIKE �˻�(���ڿ� ���� �˻�)
SELECT *
FROM tb_info
WHERE nm LIKE '��%' -- '��'�� �����ϴ� ��� ���ڿ�

SELECT *
FROM tb_info
WHERE nm LIKE '%ȣ' -- 'ȣ'�� �����ϴ� ��� ���ڿ�

SELECT *
FROM tb_info
WHERE nm LIKE '%��%' -- '��'�� ���ԵǾ� �ִ� ���ڿ�

SELECT *
FROM tb_info
WHERE nm LIKE '%' || : param_val || '%'; -- �Ű����� �Է� �׽�Ʈ : param_val�� �̸� �ƹ����� ��� ����

-- �л� �߿� �̸��� �ּҰ� naver�� �л��� ��ȸ�Ͻÿ�.
SELECT *
FROM tb_info
WHERE email like '%naver%';

SELECT *
FROM tb_info
WHERE email NOT LIKE '%gmail%'
    AND email NOT LIKE '%naver%';
    
-- ���ڿ� �Լ� LOWER(�ҹ��ڷ� ����), UPPER(�빮�ڷ� ����)
SELECT LOWER('i LIke Mac') as lowers,
       upper('i LIke Mac') as upper
FROM dual;  -- <-- dual �ӽ� ���̺� ���� (Sql select������ ���߱� ����)

SELECT emp_name, UPPER(emp_name), employee_id
FROM employees;
-- employees ���̺��� -> william�� ���Ե� ������ ��� ��ȸ�Ͻÿ�.
SELECT emp_name, UPPER(emp_name)
FROM employees
WHERE UPPER(emp_name) LIKE '%' || UPPER('william') || '%';
-- LIKE �˻����� ���̱��� ¡Ȯ�ϰ� ã�� ���� ��
INSERT INTO TB_INFO (info_no, pc_no, nm, email)
VALUES (19, 30, '�ؼ�', '�ؼ�@email.com');
INSERT INTO TB_INFO (info_no, pc_no, nm, email)
VALUES (21, 27, '����', '�ؼ�@email.com');
INSERT INTO TB_INFO (info_no, pc_no, nm, email)
VALUES (25, 32, '���ؼ���', '�ؼ�@email.com');
SELECT *
FROM tb_info
WHERE nm LIKE '%��_%';    -- _�� ��� �ϳ�
-- ���ڿ� �ڸ��� SUBSTR(char, pos, len) ��� ���ڿ� char�� pos��°���� len���� ��ŭ �ڸ�
SELECT SUBSTR('ABCD EFG', 1, 4) as ex1, -- pos�� 0�̿��� ����Ʈ 1
        SUBSTR('ABCD EFG', 4) as ex2,   -- �Է°��� 2���� ��� �ش� �ε������� ������
        SUBSTR('ABCD EFG', -3, -) as ex3 -- ������ �����̸� �ڿ�������
FROM dual;
-- ���ڿ� ��ġ ã�� INSTR(p1, p2, p3, p4) p1: ����ڿ�, p2: ã�� ���ڿ� p3: ���� p4: ��°
SELECT INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�') as ex1, -- p3, p4 ����Ʈ 1
        INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�', 5) as ex2,
        INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�', 1, 2) as ex3, -- �ι�° �ȳ� ���� ��ġ
        INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', 'hello') as ex4  -- ������ 0
FROM dual;

-- tb_info �л��� �̸��� �̸��� �ּҸ� ����Ͻÿ�
-- �� �̸��� �ּҴ� id, domain �и��Ͽ� ���
-- ex) pangsu@gmail.com -> id: pangsu , domain: gmail.com
SELECT nm,
        email,
        INSTR(email, '@'),
        SUBSTR(email, 1, INSTR(email, '@')-1) as ���̵�,
        SUBSTR(email, 1, INSTR(email, '@')+1) as ������ -- �� ó����
FROM tb_info;

--  �������� TRIM, LTRIM, RTRIM
SELECT LTRIM(' ABC ') as ex1,  -- ���� ���� ����
        RTRIM(' ABC ') as ex2, -- ������ ���� ����
        TRIM(' ABC ') as ex3 -- ���� ���� ����
FROM dual;
-- ���ڿ� �е� LPAD, RPAD       ex) �й����� �� ���
SELECT LPAD(123, 5, '0') as ex1,      -- (���, ����, ǥ����) LPAD�� ���ʺ��� ä��
        LPAD(1, 5, '0') as ex2,       
        LPAD(123456, 5, '0') as ex3,  -- �Ѿ�� ���ŵ�(����)
        LPAD(2, 5, '*') as ex4        -- R�� �����ʺ���
FROM dual;
-- ���ڿ� ���� REPLACE(����ڿ�, ã�°�, ���氪)
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as ex1,
    -- replace�� �ܾ� ��Ȯ�ϰ� ��Ī, translate�� �ѱ��ھ� ��Ī
    TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as ex2
FROM dual;

desc member;
-- member ������ member ���̺��� ��ȸ�Ͻÿ�
-- �˻�����: ������ �߱��� ��� ����
-- �ּҴ� mem_add
-- ������ mem_regno2(Ȧ�� ����, ¦�� ����)

SELECT mem_id,
        mem_name,
        mem_regno1 || '-' || SUBSTR(mem_regno2, 1, 1) || '******' as regno,
        mem_add1, mem_add2, mem_job
FROM member
WHERE mem_add1 LIKE '%����%'
    AND mem_add1 LIKE '%�߱�%'
    AND SUBSTR(mem_regno2, 1, 1) = '2';
















