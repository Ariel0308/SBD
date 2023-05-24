SELECT * FROM departamento
SELECT * FROM empregado
SELECT * FROM tipo_empregado
--1) a) Recupere o número de empregados cadastrados no BD.
SELECT COUNT(*) FROM empregado

--- b)Que tipos de empregados estão presentes em um ou mais departamentos? 
--(i.e. em qualquer departamento ou em toda a empresa)

SELECT tipo_empregado FROM empregado 
WHERE depto IS NOT NULL

--c) Recupere a média dos salários dos departamentos em que a média dos salários é maior que $1200,00.
SELECT AVG(salario) as media
FROM empregado
WHERE depto IN (SELECT depto
			   FROM empregado
			   GROUP BY depto, cpf
			   HAVING AVG(salario)>1200)


--2) Construa uma stored procedure que retorne o número de EMPREGADOS de um DEPARTAMENTO (com o nome fornecido como parâmetro).
--O parâmetro do nome_dpto, quando não especificado, usa um padrão predefinido: nomes que começam com o prefixo ’In’

CREATE OR REPLACE FUNCTION pq_numEmpr(text) RETURNS integer AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM EMPREGADO INNER JOIN departamento ON depto = cod
    WHERE nome_depto ILIKE $1);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM pq_numEmpr('rh')
SELECT * FROM pq_numEmpr('informatica')
DROP FUNCTION pq_numEmpr


/*3) a)
ROW TYPE: É um tipo de variável especial, que é um tipo de "tupla" vazia relacionado a uma tabela, 
assim criasse um tipo de dado semelhante a uma struct com os tipos do elementos da tupla determinada.



%TYPE:  É um tipo de dados que copia/tem sua tipo igual ao tipo de uma coluna.



RECORD: É um tipo de dado usando quando não se sabe previamente o tipo dos dados usados, 
funcionando assim como um tipo coringa ou um tipo void.*/

/*b) Construa uma stored procedure que retorne os EMPREGADOS de um DEPARTAMENTO (com o nome fornecido como parâmetro), s
eus salários e a descrição de TIPO_EMPREGADO.

O parâmetro do nome_dpto, quando não especificado, usa um padrão predefinido: nomes que começam com o prefixo ’In’*/

CREATE OR REPLACE FUNCTION pq_Empr(text) RETURNS setof RECORD AS $$
BEGIN
    RETURN QUERY (SELECT * FROM EMPREGADO INNER JOIN departamento ON depto = cod
    WHERE nome_depto ILIKE $1);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM pq_Empr('rh') as (cpf varchar, nome_empregado varchar, salario numeric, tipo_empregado integer, depto integer,cod integer, nome_depto varchar);
DROP FUNCTION pq_Empr

-- 9)Construa uma view para retornar o número de empregados de todos os departamentos. 
--Esta visão é atualizável?


CREATE VIEW numEmpr AS
SELECT COUNT(*)
FROM empregado
WHERE depto IS NOT NULL

SELECT * FROM numEmpr
INSERT INTO empregado
VALUES (92345678919,'Vand', 65.0, 10, 10);
SELECT * FROM numEmpr

--23) a) Construa uma visão que reúna os seguintes campos: nome do empregado, descrição do departamento, 
--descrição do tipo empregado e salário do empregado.

CREATE VIEW dados_empr AS
SELECT nome_empregado, nome_depto, descricao, salario
FROM empregado E INNER JOIN departamento D ON E.depto = D.cod 
INNER JOIN tipo_empregado T ON E.tipo_empregado = T.cod

SELECT * FROM dados_empr

INSERT INTO dados_empr
VALUES ('Ariel', 'financeiro', 'contador', 107.34);
 --b) Selecione a descrição dos departamentos que possuem algum empregado com salário > R$500.
SELECT descricao, salario FROM dados_empr
WHERE salario>500