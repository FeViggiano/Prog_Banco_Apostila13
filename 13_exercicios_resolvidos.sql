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
	RAISE NOTICE 'O número de estudantes maiores de 18 anos é de %', numero_estudantes;

END;
$$ LANGUAGE plpgsql;

-- Chamando a Procedure
CALL sp_estudante_maior_idade();

	
	
-- 1.4.2 Exibe o percentual de estudantes de cada sexo.

-- Criando a Procedure
CREATE OR REPLACE PROCEDURE sp_estudante_sexo()
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
    
    percentual_estudante_f := quantidade_estudante_f * 100.0 / 145;
    
    SELECT COUNT(*) INTO quantidade_estudante_m
    FROM tb_alunos
    WHERE gender = 2;
    
    percentual_estudante_m := quantidade_estudante_m * 100.0 / 145;
    
    RAISE NOTICE 'O percentual de alunas (f) é de %, o percentual de alunos (m) é de %', percentual_estudante_f, percentual_estudante_m;
END;
$$ LANGUAGE plpgsql;


-- Chamando a Procedure
CALL sp_estudante_sexo();



-- 1.4.3 Recebe um sexo como parâmetro em modo IN e utiliza oito parâmetros em modo OUT
-- para dizer qual o percentual de cada nota (variável grade) obtida por estudantes daquele
-- sexo.
DROP PROCEDURE IF EXISTS notas_por_sexo();

CREATE OR REPLACE PROCEDURE notas_por_sexo(IN gender INT, INOUT Fail INT, INOUT DD INT, INOUT DC INT, INOUT CC INT, INOUT CB INT, INOUT BB INT, INOUT BA INT, INOUT AA INT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(grade) INTO Fail FROM tb_alunos
    WHERE grade = 0;
    SELECT COUNT(grade) INTO DD FROM tb_alunos
    WHERE grade = 1;
    SELECT COUNT(grade) INTO DC FROM tb_alunos
    WHERE grade = 2;
    SELECT COUNT(grade) INTO CC FROM tb_alunos
    WHERE grade = 3;
    SELECT COUNT(grade) INTO CB FROM tb_alunos
    WHERE grade = 4;
    SELECT COUNT(grade) INTO BB FROM tb_alunos
    WHERE grade = 5;
    SELECT COUNT(grade) INTO BA FROM tb_alunos
    WHERE grade = 6;
    SELECT COUNT(grade) INTO AA FROM tb_alunos
    WHERE grade = 7;
    
    RAISE NOTICE '%', Fail;
    RAISE NOTICE '%', DD;
    RAISE NOTICE '%', DC;
    RAISE NOTICE '%', CC;
    RAISE NOTICE '%', CB;
    RAISE NOTICE '%', BB;
    RAISE NOTICE '%', BA;
    RAISE NOTICE '%', AA;
END;
$$;

CALL notas_por_sexo(1);
CALL notas_por_sexo(2);

CREATE OR REPLACE PROCEDURE notas_por_sexo2(IN gender INT, INOUT Fail INT, INOUT DD INT, INOUT DC INT, INOUT CC INT, INOUT CB INT, INOUT BB INT, INOUT BA INT, INOUT AA INT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO Fail FROM tb_alunos
    WHERE grade = 0;
    SELECT COUNT(*) INTO DD FROM tb_alunos
    WHERE grade = 1;
    SELECT COUNT(*) INTO DC FROM tb_alunos
    WHERE grade = 2;
    SELECT COUNT(*) INTO CC FROM tb_alunos
    WHERE grade = 3;
    SELECT COUNT(*) INTO CB FROM tb_alunos
    WHERE grade = 4;
    SELECT COUNT(*) INTO BB FROM tb_alunos
    WHERE grade = 5;
    SELECT COUNT(*) INTO BA FROM tb_alunos
    WHERE grade = 6;
    SELECT COUNT(*) INTO AA FROM tb_alunos
    WHERE grade = 7;
    
    RAISE NOTICE '%', Fail;
    RAISE NOTICE '%', DD;
    RAISE NOTICE '%', DC;
    RAISE NOTICE '%', CC;
    RAISE NOTICE '%', CB;
    RAISE NOTICE '%', BB;
    RAISE NOTICE '%', BA;
    RAISE NOTICE '%', AA;
END;
$$;

-- Criando Bloco Anõnimo

DO $$
DECLARE
    gender INT := 1;
BEGIN
    CALL notas_por_sexo2(Gender);
    RAISE NOTICE '%', Gender;
END;
$$



-- 1.5 Escreva as seguintes functions (incluindo um bloco anônimo de teste para cada uma):

-- 1.5.1 Responde (devolve boolean) se é verdade que todos os estudantes de renda acima de
-- 410 são aprovados (grade > 0).

-- Criando a Função
CREATE OR REPLACE FUNCTION f_alunos_aprovados_renda()
RETURNS BOOLEAN AS $$

DECLARE

    n_estudantes INT;
    n_aprovados INT;
    percentual_renda_alunos_aprovados FLOAT;
	
BEGIN

    SELECT COUNT(*) INTO n_estudantes
    FROM tb_alunos
    WHERE salary > 4;
    
    SELECT COUNT(*) INTO n_aprovados
    FROM tb_alunos
    WHERE salary > 4 AND grade > 0;
	
	percentual_renda_alunos_aprovados := n_aprovados * 100 / n_estudantes;
	
	
	IF percentual_renda_alunos_aprovados = 100.0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;



-- Criando Bloco Anônimo
DO
$$
DECLARE

resultado BOOLEAN;

BEGIN
	
	resultado := f_alunos_aprovados_renda();
	RAISE NOTICE 'É verdade que todos os estudantes de renda acima de 410 são aprovados: %', resultado;

END;
$$



-- 1.5.2 Responde (devolve boolean) se é verdade que, entre os estudantes que fazem
-- anotações pelo menos algumas vezes durante as aulas (notes >= 2) , pelo menos 70% são aprovados
-- (grade > 0).

-- Criando a Função
CREATE OR REPLACE FUNCTION f_estudantes_aprovados()
RETURNS BOOLEAN AS $$

DECLARE

    total_estudantes INT;
    estudantes_aprovados INT;
    percentual_aprovados FLOAT;
	
BEGIN

    SELECT COUNT(*) INTO total_estudantes
    FROM tb_alunos
    WHERE notes >= 2;
    
    SELECT COUNT(*) INTO estudantes_aprovados
    FROM tb_alunos
    WHERE notes >= 2 AND grade > 0;
    
    percentual_aprovados := estudantes_aprovados * 100.0 / total_estudantes;
    
    IF percentual_aprovados >= 70.0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Criando o Bloco Anônimo
DO $$
DECLARE
    resultado BOOLEAN;
BEGIN
    resultado := f_estudantes_aprovados();
    RAISE NOTICE 'Entre os estudantes que fazem anotações pelo menos algumas vezes durante as aulas, pelo menos 70(percentual) são aprovados, A resposta é: %', resultado;
END;
$$




-- 1.5.3 Devolve o percentual de alunos que se preparam pelo menos um pouco para os
-- “midterm exams” e que são aprovados (grade > 0).

-- Criando a Função
CREATE OR REPLACE FUNCTION f_estudantes_midterm_aprovados()
RETURNS BOOLEAN AS $$

DECLARE

    total_estudantes INT;
    estudantes_aprovados INT;
    percentual_aprovados FLOAT;
	
BEGIN

    SELECT COUNT(*) INTO total_estudantes
    FROM tb_alunos
    WHERE prep_exam < 3;
    
    SELECT COUNT(*) INTO estudantes_aprovados
    FROM tb_alunos
    WHERE prep_exam < 3 AND grade > 0;
    
    percentual_aprovados := estudantes_aprovados * 100.0 / total_estudantes;
	
	RAISE NOTICE 'O percentual de estudantes que estudaram pelo menos um pouco para o exame e foram aprovados é de %', percentual_aprovados;
    
END;
$$ LANGUAGE plpgsql;


-- Criando o Bloco Anônimo
DO $$
BEGIN

    RAISE NOTICE '%', f_estudantes_midterm_aprovados();
	
END;
$$