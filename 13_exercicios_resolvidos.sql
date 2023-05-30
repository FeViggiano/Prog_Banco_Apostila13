/*
Descrição do Banco de Dados

Student Age (age) (1: 18-21, 2: 22-25, 3: above 26);

Sex (gender) (1: female, 2: male);

Total salary if available (salary) (1: USD 135-200, 2: USD 201-270, 3: USD 271-340, 4: USD 341-410, 5: above 410)

Preparation to midterm exams (prep_exam): (1: closest date to the exam, 2: regularly during the semester, 3: never);

Taking notes in classes (notes): (1: never, 2: sometimes, 3: always);

Grade (0: Fail, 1: DD, 2: DC, 3: CC, 4: CB, 5: BB, 6: BA, 7: AA)
*/


-- 1.2 Crie uma tabela apropriada para o armazenamento dos itens. Não se preocupe com a
-- normalização. Uma tabela basta.

CREATE TABLE tb_alunos(
	studentid SERIAL PRIMARY KEY,
	age INT,
	gender INT,
	salary INT,
	prep_exam INT,
	notes INT,
	grade INT

);

-- Analisando se o dados foram importados corretamente
SELECT * FROM tb_alunos;


-- 1.4 Escreva os seguintes stored procedures (incluindo um bloco anônimo de teste para cada
-- um):
-- 1.4.1 Exibe o número de estudantes maiores de idade.
-- Criando a Procedure
CREATE OR REPLACE PROCEDURE sp_estudante_maior_idade()

AS $$
DECLARE

	numero_estudantes INT;

BEGIN

	SELECT COUNT(*) INTO numero_estudantes
	FROM tb_alunos
	WHERE age >= 1;
	RAISE NOTICE 'O número de estudantes maior de 18 anos é de %', numero_estudantes;

END;
$$ LANGUAGE plpgsql;

-- Chamando a Procedure
CALL sp_estudante_maior_idade();

	
	
-- 1.4.2 Exibe o percentual de estudantes de cada sexo.
CREATE OR REPLACE PROCEDURE sp_estudante_sexo ()

AS $$
DECLARE

	quantidade_estudante_f INT;
	quantidade_estudante_m INT;
	percentual_estudante_f INT;
	percentual_estudante_m INT;

BEGIN

	SELECT COUNT(*) INTO quantidade_estudante_f
	FROM tb_alunos
	WHERE gender = 1;
	percentual_estudante_f = quantidade_estudante_f / 145 * 100;
	
	SELECT COUNT(*) INTO percentual_estudante_m
	FROM tb_alunos
	WHERE gender = 2;
	percentual_estudante_m = quantidade_estudante_m / 145 * 100;
	
	RAISE NOTICE 'O número de alunas (f) é de %, o número de alunos(m) é de %', percentual_estudante_f, percentual_estudante_m;

END;
$$ LANGUAGE plpgsql;

-- Chamando a Procedure
CALL sp_estudante_sexo();

-- 1.4.3 Recebe um sexo como parâmetro em modo IN e utiliza oito parâmetros em modo OUT
-- para dizer qual o percentual de cada nota (variável grade) obtida por estudantes daquele
-- sexo.
CREATE OR REPLACE sp_nota_idade_sexo (

)
LANGUAGE plpgsql;
AS $$
BEGIN

END;
$$


-- 1.5 Escreva as seguintes functions (incluindo um bloco anônimo de teste para cada uma):
-- 1.5.1 Responde (devolve boolean) se é verdade que todos os estudantes de renda acima de
-- 410 são aprovados (grade > 0).


-- 1.5.2 Responde (devolve boolean) se é verdade que, entre os estudantes que fazem
-- anotações pelo menos algumas vezes durante as aulas, pelo menos 70% são aprovados
-- (grade > 0).


-- 1.5.3 Devolve o percentual de alunos que se preparam pelo menos um pouco para os
-- “midterm exams” e que são aprovados (grade > 0).