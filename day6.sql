-- ROLLUP
-- �׷캰 �Ұ�� �Ѱ踦 ������
-- ǥ������ ������ n�̸� n+1 ��������, ���� �������� ���� ���� ������
-- �����Ͱ� �����

-- ������ ���ϸ����� �հ�� ��ü �հ� ���
SELECT mem_job,
        sum(mem_milage) as ���ϸ�����
FROM member
GROUP BY ROLLUP(mem_job);
-- ������ ������ ����
-- ī�װ�, ���� ī�װ��� ��ǰ ��
SELECT prod_category,
        prod_subcategory,
        COUNT(prod_id) as ��ǰ��
FROM products;
GROUP BY ROLLUP(prod_category,
        prod_subcategory);
        

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');

-- ����� ���� UNION, UNION ALL, MINUS, INTERSECT
SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '�ѱ�';
UNION -- �ߺ� ����
SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '�Ϻ�';
ORDER BY seq; -- ������ select������ ��� ����

SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '�ѱ�';
UNION ALL -- �� select ��� ��
SELECT goods, seq
FROM exp_goods_asia;
WHERE country = '�Ϻ�';

SELECT goods
FROM exp_goods_asia;
WHERE country = '�ѱ�';
MINUS -- ������
SELECT goods
FROM exp_goods_asia;
WHERE country = '�Ϻ�';

SELECT goods
FROM exp_goods_asia;
WHERE country = '�ѱ�';
INTERSECT -- ������
SELECT goods
FROM exp_goods_asia;
WHERE country = '�Ϻ�'
UNION
SELECT '����'
FROM dual;
-- ���� ����� �÷��� ���� Ÿ���� ��ġ�ϸ� ��� ����

SELECT gubun,
        sum(loan_jan_amt) as ������
FROM kor_loan_status
GROUP BY gubun;
SELECT '�հ�', SUM(loan_jan_amt)
FROM kor_loan_status;


/*
 ����ǥ���� oracle 10g���� ��� ���� REGEXP_ <-�� �����ϴ� �Լ�
 .(dot) or [] <-- ��� ���� 1���ڸ� �ǹ���.
 ^����, $�� [^] <-- ���ȣ ���� ^ not�� �ǹ���.
 {n}: n�� �ݺ�, {n,}: n�̻� �ݺ�, {n,m} n �̻� m ���� �ݺ�
*/
-- REGEXP_LIKE: ���Խ� ���� �˻�
SELECT mem_name, mem_comtel
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');

-- mem_mail ������ �� ������ 3~5�ڸ� �̸��� �ּ� ���� ����
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{3,5}@');
-- mem_add2 �ּҿ��� �ѱ۷� ������ ������ �ּҸ� �����Ͻÿ�
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[��-��]$');
-- ���� ������ �ּҸ� ��ȸ�Ͻÿ�
-- �ѱ� + ���� + ���� ex)����Ʈ 5��
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[��-��][0-9]');
-- �ѱ۸� �ִ� �ּ� �˻�
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[��-��]+$');
-- �ѱ��� ���� �ּҸ� �˻��Ͻÿ�!
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[^ ��-��]+$');
-- �Ǵ�
SELECT mem_name, mem_add2
FROM member
WHERE NOT REGEXP_LIKE(mem_add2, '[��-��]');
-- |: �Ǵ� (): �׷�
-- J�� �����ϸ�, ����° ���ڰ� m or n�� �����̸� ��ȸ
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^j.(m|n)');
-- REGEXP_SUBSTR ����ǥ���� ���ϰ� ��ġ�ϴ� ���ڿ��� ��ȯ
-- �̸��� �������� �� �� ���
SELECT mem_mail,
        REGEXP_SUBSTR(mem_mail, '[^@], 1, 1') as ���̵�,
        REGEXP_SUBSTR(mem_mail, '[^@], 1, 2') as ������
FROM member;


SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 1) as ex1,
        REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 2) as ex1,
        REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 3) as ex1,
        REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 4) as ex1
FROM dual;

-- mem_add1���� ������ �������� ù��° �ܾ ����Ͻÿ�.
SELECT REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 1) as �õ�,
        REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 2) as ����
FROM member;

-- REGEXP_REPLACE ��� ���ڿ�����
-- ���� ǥ���� ������ �����Ͽ� �ٸ� ������ ��ü
SELECT REGEXP_REPLACE('Ellen Hidi Smith', '(.*) (.*) (.*)', '\3, \1 \2') as re
FROM dual;
-- ������ �ּҵ��� ��� '����'���� �ٲ㼭 ����Ͻÿ� id: p001����
-- ���������� -> ����
-- ������    -> ����
SELECT mem_add1,
        REGEXP_REPLACE(mem_add1, '(.{1,5}) (.*)', '���� \2') as �ּ�
FROM member
WHERE mem_add1 LIKE '%����%'
    AND mem_id != 'p001';

-- �� ǥ��� \w = [a-zA-Z0-9], \d = [0-9]
-- ��ȭ��ȣ ���ڸ����� ������ ��ȣ�� �ݺ��Ǵ� ��� ��ȸ
SELECT emp_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$');
-- (\d\d)\1$' (���ڼ���) \1 ù��° �׷� ĸó �׷��� �ٽ� ����

-- ^\d*\.?\d{0,2}
-- � �����ϱ��?
-- ^ ����
-- \d = 0-9
-- *
-- \. ���ڷμ��� .
-- ? �տ� �ݺ�
-- \d{0,2} �����Է�{�Ҽ��� ��°�ڸ�����}