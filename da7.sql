CREATE TABLE ���ǳ��� (
     ���ǳ�����ȣ NUMBER(3)
    ,������ȣ NUMBER(3)
    ,�����ȣ NUMBER(3)
    ,���ǽ� VARCHAR2(10)
    ,����  NUMBER(3)
    ,�����ο� NUMBER(5)
    ,��� date
);

CREATE TABLE ���� (
     �����ȣ NUMBER(3)
    ,�����̸� VARCHAR2(50)
    ,���� NUMBER(3)
);

CREATE TABLE ���� (
     ������ȣ NUMBER(3)
    ,�����̸� VARCHAR2(20)
    ,���� VARCHAR2(50)
    ,���� VARCHAR2(50)
    ,�ּ� VARCHAR2(100)
);
ALTER TABLE ����
ADD CONSTRAINT

CREATE TABLE �������� (
    ����������ȣ NUMBER(3)
    ,�й� NUMBER(10)
    ,�����ȣ NUMBER(3)
    ,���ǽ� VARCHAR2(10)
    ,���� NUMBER(3)
    ,������� VARCHAR(10)
    ,��� DATE 
);

CREATE TABLE �л� (
     �й� NUMBER(10)
    ,�̸� VARCHAR2(50)
    ,�ּ� VARCHAR2(100)
    ,���� VARCHAR2(50)
    ,������ VARCHAR2(500)
    ,������� DATE
    ,�б� NUMBER(3)
    ,���� NUMBER
);
ALTER TABLE �л� ADD CONSTRAINT PK_�л�_�й� PRIMARY KEY (�й�);
ALTER TABLE �������� ADD CONSTRAINT PK_��������_����������ȣ PRIMARY KEY (����������ȣ);
ALTER TABLE ���� ADD CONSTRAINT PK_���񳻿�_�����ȣ PRIMARY KEY (�����ȣ);
ALTER TABLE ���� ADD CONSTRAINT PK_����_������ȣ PRIMARY KEY (������ȣ);
ALTER TABLE ���ǳ��� ADD CONSTRAINT PK_���ǳ�����ȣ PRIMARY KEY (���ǳ�����ȣ);

ALTER TABLE �������� 
ADD CONSTRAINT FK_�л�_�й� FOREIGN KEY(�й�)
REFERENCES �л�(�й�);

ALTER TABLE �������� 
ADD CONSTRAINT FK_����_�����ȣ FOREIGN KEY(�����ȣ)
REFERENCES ����(�����ȣ);

ALTER TABLE ���ǳ��� 
ADD CONSTRAINT FK_����_������ȣ FOREIGN KEY(������ȣ)
REFERENCES ����(������ȣ);

ALTER TABLE ���ǳ��� 
ADD CONSTRAINT FK_����_�����ȣ2 FOREIGN KEY(�����ȣ)
REFERENCES ����(�����ȣ);
SELECT *
FROM �л�;
SELECT *
FROM ��������;

/* 1. �������� INNER JOIN or �������� EQUI-JOIN�̶���
   WHERE������ = ��ȣ ������ ���
   A�� B���̺� ����� ���� ���� �÷��� ������ ���������� ��(True)�� ���
   �� �� �÷��� ���� ���� ���� ���� */
SELECT �̸�,
        �ּ�,
        �����ȣ
        -- , �й� -- �����ǰ� �ָ���. ���̺� ���ʿ�
        , �л�.�й�
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�
AND �л�.�й� = '1997131542';

SELECT a. �̸�,
        a. �ּ�,
        b. �����ȣ,
        a. �й�          -- from�� ���̺� ��Ī�� ����ϸ� �÷��� ��Ī�� ����ؾ� ��.
FROM �л� a, �������� b -- ���̺� ��Ī
WHERE a.�й� = b.�й�;
-- �ּ��澾�� �������� ��ȸ(��������)

SELECT a. �̸�, a. �ּ�, a. ����,
        c. �����̸�,
        c. ����
FROM �л� a, �������� b, ���� C
WHERE a.�й� = b.�й�
AND b. �����ȣ = c. �����ȣ
AND a. �̸� = '�ּ���';

/*2. �ܺ����� OUTER JOIN
    NULL����*/
SELECT �л�.�̸�,
        �л�.�й�,
        ��������.�й�,
        ��������.����������ȣ,
        ��������.�����ȣ
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�(+);
-- �л��� �������� �Ǽ��� ��ȸ�Ͻÿ�!
SELECT �л�.�̸�,
        �л�.�й�,
        COUNT(��������.����������ȣ) as �����Ǽ�,
        count(*)
FROM �л�, ��������
WHERE �л�.�й�=��������.�й�(+)
GROUP BY �л�.�̸�, �л�.�й�;

-- �������� ���
SELECT �л�.�̸�,
        �л�.�й�,
        ��������.����������ȣ,
        ����.����
FROM �л�, ��������, ����
WHERE �л�.�й�=��������.�й�(+)
AND ��������.�����ȣ = ����.�����ȣ(+); -- outer ������ ��� ���ο� �ɾ������

-- ��� ������ ���Ǽ��� ����Ͻÿ�.
SELECT ����.�����̸�, ����.������ȣ,
        COUNT(���ǳ���.���ǳ�����ȣ) as ���ǰǼ�
FROM ����, ���ǳ���
WHERE ����.������ȣ = ���ǳ���.������ȣ(+)
GROUP BY ����.�����̸�, ����.������ȣ;

/* sub query(���� �ȿ� ����)
1. ��Į�� ��������(select��)
2. �ζ��� �� (from��)
3. ��ø����(where��)

-- ��Į�� ���������� ������ ��ȯ
-- ������ ���� ���� �������̺��� �� �Ǽ� ��ŭ ��ȸ�ϱ� ����
-- �Ǽ��� ���� ���̺��̶�� ������ �ϴ°� �� ����. */

SELECT a.emp_name,
        a.department_id,
        (SELECT department_name -- 1���� �÷��� ���� 1=1 �μ���ȣ=�μ���
        FROM departments          -- �μ����̺��� �μ� ���̵�� pk ����ũ��.
        WHERE department_id = a.department_id) as dep_name,
        (SELECT job_title
        FROM jobs
        WHERE job_id = a.job_id) as job_title
FROM employees a;

-- ��ø ��������(where��)
-- Ư�� ���� �ʿ��� ��
-- ���� �� salary�� ��ü��պ��� ���� ������ ����Ͻÿ�.
SELECT AVG(salary)
FROM employees;
-- 6461.831775700934579439252336448598130841
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                FROM employees);
-- �������� ���� ���� ������ ����Ͻÿ�.
SELECT MAX(salary)
FROM employees;
-- 24000
SELECT emp_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary)
                FROM employees);
-- �����̷��� �ִ� �л��� �̸��� ��ȸ�Ͻÿ�
SELECT �̸�
FROM �л�
WHERE �й� IN (SELECT �й�
                FROM ��������);
SELECT �̸�
FROM �л�
WHERE �й� IN (1997131542, 1998131205, 1999232102, 2001110131, 2001211121, 2002110110, 1999232102);

-- ������ ���� ���� �л��� ���������� ����Ͻÿ�.
SELECT MAX(����)
FROM �л�;
--
SELECT 
FROM �л�
WHERE �й� IN(SELECT MAX(����)
            FROM �л�);
--
SELECT �л�.�̸�,
        �л�.�й�,
        ����.�����̸�
FROM �л�, ��������, ����
WHERE �л�.�й�=��������.�й�
AND ��������.�����ȣ=����.�����ȣ
AND �л�.���� = (SELECT MAX(����)
                FROM �л�);
                
-- ���� �����̷��� ����Ͻÿ�.(member, cart) ���̺� ���
-- 1���� īƮ���� ���� �� ��ǰ�� ��ϵ� �� ����.
-- �����̵�, ����, īƮ���Ƚ��(�̷¼�), ���Ż�ǰ ǰ���, ��ǰ���ż���
-- ������(�� ��Ǿ���ż��� ��������)
SELECT *
FROM cart;
--
SELECT *
FROM member;
--
SELECT member.mem_id,
        member.mem_name,
        cart.cart_member,
        COUNT(cart.cart_no) as īƮ���Ƚ��
FROM member, cart
WHERE member.mem_id = cart.cart_member(+)
GROUP BY member.mem_name, member.mem_id;

--
SELECT COUNT(cart.cart_no)
FROM cart;

