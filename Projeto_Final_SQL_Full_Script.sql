--- ALUNO: Allan Christian Dantas Gomes
--- DISCIPLINA: Banco de dados (IMD0402)
--- FACULDADE: UFRN - Universidade Federal do Rio Grande do Norte
--- DEPARTAMENTO: IMD - Instituto Metropole Digital
-- Data: 17/06/2022 -> 02/07/2022
-- Arquivo: Projeto_Final_SQL_Full_Script.sql

--Criação do banco de dados
CREATE DATABASE Projeto_Final
	WITH OWNER = postgres
	TEMPLATE = postgres
	ENCODING = 'UTF8'
	TABLESPACE = pg_default
	CONNECTION LIMIT = -1


-- ################################################################# CRIAÇÃO DAS TABELAS #####################################################################
CREATE TABLE Municipio (
  idMunicipio SERIAL   NOT NULL ,
  nomeMunicipio VARCHAR(40)   NOT NULL ,
PRIMARY KEY(idMunicipio));

CREATE TABLE Telefone (
  idTelefone SERIAL   NOT NULL ,
  ddd VARCHAR(2)   NOT NULL ,
  numero VARCHAR(10)   NOT NULL ,
  tipo VARCHAR(5) CHECK(tipo = 'Móvel' or tipo = 'Fixo') ,
PRIMARY KEY(idTelefone));

CREATE TABLE Bairro (
  idBairro SERIAL   NOT NULL ,
  idMunicipio INTEGER   NOT NULL ,
  nomeBairro VARCHAR(40)   NOT NULL ,
PRIMARY KEY(idBairro)  ,
  FOREIGN KEY(idMunicipio)
    REFERENCES Municipio(idMunicipio));

CREATE TABLE Pessoa (
  idPessoa SERIAL   NOT NULL ,
  idTelefone INTEGER   NOT NULL ,
  idBairro INTEGER   NOT NULL ,
  nomePessoa VARCHAR(50)   NOT NULL ,
  cpfPessoa VARCHAR(14)   NOT NULL ,
  logradouroPessoa VARCHAR(50)      ,
PRIMARY KEY(idPessoa)    ,
  FOREIGN KEY(idBairro)
    REFERENCES Bairro(idBairro),
  FOREIGN KEY(idTelefone)
    REFERENCES Telefone(idTelefone));

CREATE TABLE Fornecedor (
  idFornecedor SERIAL   NOT NULL ,
  idTelefone INTEGER   NOT NULL ,
  idBairro INTEGER   NOT NULL ,
  nomeFornecedor VARCHAR(50)   NOT NULL ,
  cnpjFornecedor VARCHAR(18)   NOT NULL ,
  logradouroFornecedor VARCHAR(50)      ,
PRIMARY KEY(idFornecedor)    ,
  FOREIGN KEY(idBairro)
    REFERENCES Bairro(idBairro),
  FOREIGN KEY(idTelefone)
    REFERENCES Telefone(idTelefone));

CREATE TABLE Funcionario (
  idFuncionario SERIAL   NOT NULL ,
  idPessoa INTEGER   NOT NULL ,
  dataAdmissao VARCHAR(10)    ,
  dataDemissao VARCHAR(10)    ,
  estado VARCHAR(7) CHECK(estado='Ativo' or estado='Inativo') ,
PRIMARY KEY(idFuncionario)  ,
  FOREIGN KEY(idPessoa)
    REFERENCES Pessoa(idPessoa));

CREATE TABLE Produto (
  idProduto SERIAL   NOT NULL ,
  idFornecedor INTEGER   NOT NULL ,
  nomeProduto VARCHAR(40)   NOT NULL ,
  valorProduto FLOAT   NOT NULL ,
  dataCompra VARCHAR(10)    ,
PRIMARY KEY(idProduto)  ,
  FOREIGN KEY(idFornecedor)
    REFERENCES Fornecedor(idFornecedor));

CREATE TABLE ItensProduto (
  idItensProduto SERIAL   NOT NULL ,
  idProduto INTEGER   NOT NULL ,
  quantidadeItens INTEGER   NOT NULL ,
PRIMARY KEY(idItensProduto)  ,
  FOREIGN KEY(idProduto)
    REFERENCES Produto(idProduto));

CREATE TABLE Cliente  (
  idCliente  SERIAL   NOT NULL ,
  idPessoa INTEGER   NOT NULL   ,
PRIMARY KEY(idCliente )  ,
  FOREIGN KEY(idPessoa)
    REFERENCES Pessoa(idPessoa));

CREATE TABLE Estoque (
  idEstoque SERIAL   NOT NULL ,
  idProduto INTEGER   NOT NULL ,
  quantidadeEstoque INTEGER   NOT NULL   ,
PRIMARY KEY(idEstoque)  ,
  FOREIGN KEY(idProduto)
    REFERENCES Produto(idProduto));

CREATE TABLE Atendimento (
  idAtendimento SERIAL   NOT NULL ,
  idCliente  INTEGER   NOT NULL ,
  idFuncionario INTEGER   NOT NULL ,
  tipoAtendimento VARCHAR(13) CHECK(tipoAtendimento='Venda' or tipoAtendimento='Serviço' or tipoAtendimento='Venda/Serviço') ,
  dataAtendimento VARCHAR(10)   NOT NULL ,
PRIMARY KEY(idAtendimento)    ,
  FOREIGN KEY(idFuncionario)
    REFERENCES Funcionario(idFuncionario),
  FOREIGN KEY(idCliente )
    REFERENCES Cliente (idCliente ));

CREATE TABLE Servico (
  idServico SERIAL   NOT NULL ,
  idAtendimento INTEGER   NOT NULL ,
  descricaoServico VARCHAR(150)   NOT NULL ,
  marcaAparelho VARCHAR(15)    ,
  modeloAparelho VARCHAR(20)    ,
  imeiAparelho VARCHAR(15)    ,
  numeroSerie VARCHAR(11)    ,
  valorServico FLOAT   NOT NULL ,
PRIMARY KEY(idServico)  ,
  FOREIGN KEY(idAtendimento)
    REFERENCES Atendimento(idAtendimento));

CREATE TABLE Pagamento (
  idPagamento SERIAL   NOT NULL ,
  idItensProduto INTEGER   NOT NULL ,
  idServico INTEGER   NOT NULL ,
  dataPagamento VARCHAR(10)    ,
  statusPagamento VARCHAR(9) CHECK(statusPagamento='Efetuado' or statusPagamento='Cancelada' or statusPagamento='Pendente') ,
  formaPagamento VARCHAR(8) CHECK(formaPagamento='Dinheiro' or formaPagamento='Cartão') ,
  valorTotal FLOAT    NOT NULL ,
PRIMARY KEY(idPagamento)  ,
  FOREIGN KEY(idServico)
    REFERENCES Servico(idServico),
  FOREIGN KEY(idItensProduto)
    REFERENCES ItensProduto(idItensProduto));

-- ############################################################ CONSTRAINTS IMPORTANTES ###################################################################
-- Não permite inserir pessoas com mesmo cpf
CREATE UNIQUE INDEX duplicated_cpfPessoa
  ON Pessoa (cpfPessoa);

-- Não permite inserir fornecedores com o mesmo cnpj
CREATE UNIQUE INDEX duplicated_cnpjFornecedor
  ON Fornecedor (cnpjFornecedor)

-- Garante que cada estoque está associado a um único item
CREATE UNIQUE INDEX Estoque_Produto 
  ON Estoque (idProduto);

-- ############################################################### INSERTS NAS TABELAS #####################################################################

INSERT INTO Municipio (idMunicipio, nomeMunicipio) VALUES (1, 'Natal');
INSERT INTO Municipio (idMunicipio, nomeMunicipio) VALUES (2, 'Parnamirim');


INSERT INTO Bairro (idBairro, idMunicipio, nomeBairro) VALUES (1, 1, 'Neópolis');
INSERT INTO Bairro (idBairro, idMunicipio, nomeBairro) VALUES (2, 1, 'Capim Macio');
INSERT INTO Bairro (idBairro, idMunicipio, nomeBairro) VALUES (3, 2, 'Coophab');


INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (1, '84','99999-0001', 'Móvel');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (2, '84','99999-0002', 'Móvel');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (3, '84','99999-0003', 'Móvel');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (4, '84','3000-0004', 'Fixo');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (5, '84','3000-0005', 'Fixo');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (6, '84','3000-0006', 'Fixo');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (7, '84','3000-0007', 'Fixo');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (8, '84','99999-0008', 'Móvel');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (9, '84','99999-0009', 'Móvel');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (10, '84','99999-0010', 'Móvel');
INSERT INTO Telefone (idTelefone, ddd, numero, tipo) VALUES (11, '84','99999-0011', 'Móvel');


INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (1, 1, 1, 'Pessoa 1', '111.111.111-01', 'Rua 01');
INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (2, 2, 2, 'Pessoa 2', '222.222.222-02', 'Rua 02');
INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (3, 3, 3, 'Pessoa 3', '333.333.333-03', 'Rua 03');
INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (4, 8, 1, 'Pessoa 4', '444.444.444-04', 'Rua 04');
INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (5, 9, 2, 'Pessoa 5', '555.555.555-05', 'Rua 05');
INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (6, 10, 3, 'Pessoa 6', '666.666.666-06', 'Rua 06');
INSERT INTO Pessoa(idPessoa, idTelefone, idBairro, nomePessoa, cpfPessoa, logradouroPessoa)
							VALUES (7, 11, 3, 'Pessoa 7', '777.777.777-07', 'Rua 07');


INSERT INTO Funcionario(idFuncionario, idPessoa, dataAdmissao, dataDemissao, estado)
								VALUES (1, 1, '11/01/2020', '05/02/2022', 'Inativo');
INSERT INTO Funcionario(idFuncionario, idPessoa, dataAdmissao, dataDemissao, estado)
								VALUES (2, 2, '12/02/2020', null, 'Ativo');
INSERT INTO Funcionario(idFuncionario, idPessoa, dataAdmissao, dataDemissao, estado)
								VALUES (3, 3, '13/03/2020', null, 'Ativo');								


INSERT INTO Cliente(idCliente, idPessoa) VALUES (1, 4);
INSERT INTO Cliente(idCliente, idPessoa) VALUES (2, 5);
INSERT INTO Cliente(idCliente, idPessoa) VALUES (3, 6);
INSERT INTO Cliente(idCliente, idPessoa) VALUES (4, 7);


INSERT INTO Fornecedor(idFornecedor, idTelefone, idBairro, nomeFornecedor,cnpjFornecedor, logradouroFornecedor)
								VALUES (1, 4, 1, 'Fornecedor padrão', 'XX.XXX.XXX/0001-00', 'Rua 08');
INSERT INTO Fornecedor(idFornecedor, idTelefone, idBairro, nomeFornecedor,cnpjFornecedor, logradouroFornecedor)
								VALUES (2, 5, 2, 'Fornecedor 1', '01.111.111/0001-01', 'Rua 09');
INSERT INTO Fornecedor(idFornecedor, idTelefone, idBairro, nomeFornecedor,cnpjFornecedor, logradouroFornecedor)
								VALUES (3, 6, 3, 'Fornecedor 2', '02.222.222/0001-02', 'Rua 10');
INSERT INTO Fornecedor(idFornecedor, idTelefone, idBairro, nomeFornecedor,cnpjFornecedor, logradouroFornecedor)
								VALUES (4, 7, 3, 'Fornecedor 3', '03.333.333/0001-03', 'Rua 11');


INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(1, 1, 'Produto generico', 00.00, '27/05/2022');
INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(2, 2, 'Produto 01', 10.00, '27/05/2022');
INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(3, 2, 'Produto 02', 20.00, '27/05/2022');
INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(4, 3, 'Produto 03', 30.00, '27/05/2022');
INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(5, 3, 'Produto 04', 40.00, '27/05/2022');
INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(6, 4, 'Produto 05', 50.00, '27/05/2022');
INSERT INTO Produto(idProduto, idFornecedor, nomeProduto, valorProduto, dataCompra)
								VALUES(7, 4, 'Produto 06', 60.00, '27/05/2022');


INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (1, 1, 100);
INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (2, 2, 20);
INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (3, 3, 30);
INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (4, 4, 40);
INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (5, 5, 50);
INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (6, 6, 60);
INSERT INTO Estoque(idEstoque, idProduto, quantidadeEstoque) VALUES (7, 7, 70);


INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (1, 1, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (2, 1, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (3, 2, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (4, 3, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (5, 4, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (6, 5, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (7, 6, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (8, 7, 1); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (9, 2, 2); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (10, 3, 2); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (11, 4, 2); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (12, 5, 2); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (13, 6, 2); 
INSERT INTO ItensProduto(idItensProduto, idProduto, quantidadeItens) VALUES (14, 7, 2);


INSERT INTO Atendimento(idAtendimento, idCliente, idFuncionario, tipoAtendimento, dataAtendimento)
									VALUES(1, 1, 2, 'Serviço', '10/06/2022');
INSERT INTO Atendimento(idAtendimento, idCliente, idFuncionario, tipoAtendimento, dataAtendimento)
									VALUES(2, 2, 3, 'Venda/Serviço', '10/06/2022');
INSERT INTO Atendimento(idAtendimento, idCliente, idFuncionario, tipoAtendimento, dataAtendimento)
									VALUES(3, 3, 2, 'Venda', '11/06/2022');
INSERT INTO Atendimento(idAtendimento, idCliente, idFuncionario, tipoAtendimento, dataAtendimento)
									VALUES(4, 4, 3, 'Venda', '11/06/2022');
INSERT INTO Atendimento(idAtendimento, idCliente, idFuncionario, tipoAtendimento, dataAtendimento)
									VALUES(5, 1, 2, 'Venda', '12/06/2022');
INSERT INTO Atendimento(idAtendimento, idCliente, idFuncionario, tipoAtendimento, dataAtendimento)
									VALUES(6, 2, 3, 'Venda', '12/06/2022');


INSERT INTO Servico(idServico, idAtendimento, descricaoServico, marcaAparelho, modeloAparelho, imeiAparelho, numeroSerie, valorServico)
									VALUES(1, 1, 'Servico 01 - Manutenção' , 'Samsung', 'S20FE', '350000000000001', 'AB1CD1E1FGH', 100.00); -- Serviço 
INSERT INTO Servico(idServico, idAtendimento, descricaoServico, marcaAparelho, modeloAparelho, imeiAparelho, numeroSerie, valorServico)
									VALUES(2, 2, 'Servico 02 - Manutenção simples / Venda 03' , 'Apple', 'Iphone XR', '350000000000002', 'AB2CD2E2FGH', 200.00); -- Serviço/Venda
INSERT INTO Servico(idServico, idAtendimento, descricaoServico, marcaAparelho, modeloAparelho, imeiAparelho, numeroSerie, valorServico)
									VALUES(3, 3, 'Servico 03 - Manutenção complexa / Venda 04' , 'Apple', 'Iphone 11', '350000000000003', 'AB3CD3E3FGH', 300.00); -- Serviço/Venda
INSERT INTO Servico(idServico, idAtendimento, descricaoServico, marcaAparelho, modeloAparelho, imeiAparelho, numeroSerie, valorServico)
									VALUES(4, 4, 'Venda 05' , null, null, null, null, 00.00); -- Venda
INSERT INTO Servico(idServico, idAtendimento, descricaoServico, marcaAparelho, modeloAparelho, imeiAparelho, numeroSerie, valorServico)
									VALUES(5, 5, 'Venda 06' , null, null, null, null, 00.00); -- Venda
INSERT INTO Servico(idServico, idAtendimento, descricaoServico, marcaAparelho, modeloAparelho, imeiAparelho, numeroSerie, valorServico)
									VALUES(6, 6, 'Venda 07' , null, null, null, null, 00.00); -- Venda							


INSERT INTO Pagamento(idPagamento, idItensProduto, idServico, dataPagamento, statusPagamento, formaPagamento, valorTotal)
									VALUES(1, 1, 1, '11/06/2022', null, null, 00.00);
INSERT INTO Pagamento(idPagamento, idItensProduto, idServico, dataPagamento, statusPagamento, formaPagamento, valorTotal)
									VALUES(2, 3, 2, '11/06/2022', null, null, 00.00);
INSERT INTO Pagamento(idPagamento, idItensProduto, idServico, dataPagamento, statusPagamento, formaPagamento, valorTotal)
									VALUES(3, 5, 4, '12/06/2022', null, null, 00.00);
INSERT INTO Pagamento(idPagamento, idItensProduto, idServico, dataPagamento, statusPagamento, formaPagamento, valorTotal)
									VALUES(4, 6, 5, '12/06/2022', null, null, 00.00);
INSERT INTO Pagamento(idPagamento, idItensProduto, idServico, dataPagamento, statusPagamento, formaPagamento, valorTotal)
									VALUES(5, 7, 6, '13/06/2022', null, null, 00.00);


-- ################################################################## FUNÇÕES & TRIGGERS ###################################################################

-- INSERT em Pagamento -> UPDATE em Pagamento (statusPagamento='Pendente' e atualizar o valorTotal com o valor do serviço e dos itens)
CREATE FUNCTION iniciando_pagamento() RETURNS trigger AS $iniciando_pagamento$
  BEGIN
    UPDATE Pagamento SET statusPagamento='Pendente'
    WHERE NEW.idPagamento = idPagamento;
    
    UPDATE Pagamento SET valorTotal = S.valorServico + P.valorProduto*(I.quantidadeItens) 
    FROM Servico S, Produto P, ItensProduto I
    WHERE NEW.idServico = S.idServico AND NEW.idItensProduto = I.idItensProduto AND I.idProduto = P.idProduto AND NEW.idPagamento = idPagamento;            
  RETURN NEW;
  END;
  $iniciando_pagamento$ LANGUAGE plpgsql;
  
  CREATE TRIGGER iniciando_pagamento AFTER INSERT
  ON Pagamento
  FOR EACH ROW EXECUTE
  PROCEDURE iniciando_pagamento();


--UPDATE em ItensProduto -> SE (Atualizou o idProduto E/OU a quantidadeItens)
--                          ENTÃO UPDATE em Pagamento para correção do valorTotal

CREATE OR REPLACE FUNCTION change_itemProduto() RETURNS trigger AS $change_itemProduto$
  BEGIN
    UPDATE Pagamento 
    SET valorTotal = 
    (SELECT S.valorServico FROM Servico S, Pagamento P WHERE NEW.idItensProduto = P.idItensProduto AND P.idServico = S.idServico)
    + (SELECT P.valorProduto FROM Produto P WHERE NEW.idProduto = P.idProduto)
    * NEW.quantidadeItens
    WHERE NEW.idItensProduto = idItensProduto;
  RETURN NEW;
  END;
  $change_itemProduto$ LANGUAGE plpgsql;

CREATE TRIGGER change_itemProduto AFTER UPDATE
ON ItensProduto
FOR EACH ROW
WHEN (pg_trigger_depth() = 0)
EXECUTE PROCEDURE change_itemProduto();


--UPDATE em Pagamento -> SE (formaPagamento='Dinheiro' ou formaPagamento='Cartão')
--                       ENTÃO UPDATE em Pagamento -> StatusPagamento como Efetuado | dataPagamento | formaPagamento como no UPDATE
--                       ENTÃO UPDATE em Estoque -> remover itens do estoque
--                       SE (statusPagamento='Cancelado')
--                       ENTÃO UPDATE em Pagamento -> dataPagamento(DataDoCancelamento)
--                       ENTÃO UPDATE em Estoque -> Retorna os itens ao estoque

CREATE OR REPLACE FUNCTION update_pagamento() RETURNS trigger AS $update_pagamento$
  BEGIN
    -- PAGAMENTO
    IF (NEW.formaPagamento = 'Dinheiro' OR NEW.formaPagamento = 'Cartão') AND OLD.statusPagamento = 'Pendente' THEN     
      UPDATE Pagamento SET statusPagamento='Efetuado', dataPagamento='SetDataPAG', formaPagamento = NEW.formaPagamento
      WHERE NEW.idPagamento = idPagamento;
    
    UPDATE Estoque SET quantidadeEstoque = quantidadeEstoque - (SELECT I.quantidadeItens FROM ItensProduto I WHERE idItensProduto=NEW.idItensProduto)
    WHERE idEstoque = (SELECT E.idEstoque FROM Estoque E, Produto P, ItensProduto I, Pagamento PG
              WHERE E.idProduto = P.idProduto AND P.idProduto = I.idProduto AND 
                  I.idItensProduto = PG.idItensProduto AND PG.idPagamento = NEW.idPagamento);
    END IF;

    -- CANCELAMENTO 
    IF NEW.statusPagamento = 'Cancelada' AND OLD.statusPagamento = 'Efetuado' THEN     
      UPDATE Pagamento SET dataPagamento='SetDataCAN'
      WHERE NEW.idPagamento = idPagamento;
    
    UPDATE Estoque SET quantidadeEstoque = quantidadeEstoque + (SELECT I.quantidadeItens FROM ItensProduto I WHERE idItensProduto=NEW.idItensProduto)
    WHERE idEstoque = (SELECT E.idEstoque FROM Estoque E, Produto P, ItensProduto I, Pagamento PG
              WHERE E.idProduto = P.idProduto AND P.idProduto = I.idProduto AND 
                  I.idItensProduto = PG.idItensProduto AND PG.idPagamento = NEW.idPagamento);
    END IF;

    -- CANCELAMENTO SEM PAGAMENTO
    IF NEW.statusPagamento = 'Cancelada' AND OLD.statusPagamento = 'Pendente' THEN
      UPDATE Pagamento SET dataPagamento = 'SetDataCAN'
      WHERE NEW.idPagamento = idPagamento;
    END IF;
  RETURN NEW;
  END;
  $update_pagamento$ LANGUAGE plpgsql;

CREATE TRIGGER update_pagamento AFTER UPDATE
ON Pagamento
FOR EACH ROW
WHEN (pg_trigger_depth() = 0)
EXECUTE PROCEDURE update_pagamento();


-- INSERT/UPDATE em Pagamento -> Checa se o serviço está cadastrado em outro pagamento

CREATE OR REPLACE FUNCTION Servico_em_pagamento() RETURNS trigger AS $Servico_em_pagamento$
  BEGIN
    IF EXISTS(SELECT NEW.idServico FROM Pagamento) THEN
    RAISE EXCEPTION 'Este serviço já está cadastrado em outro pagamento!';
    END IF;
  RETURN NEW;
  END;
  $Servico_em_pagamento$ LANGUAGE plpgsql;

CREATE TRIGGER Servico_em_pagamento AFTER INSERT OR UPDATE
ON Pagamento
FOR EACH ROW
WHEN (pg_trigger_depth() = 0)
EXECUTE PROCEDURE Servico_em_pagamento();


-- ########################################################################## VIEWS ####################################################################

-- VIEW Simples para a visualização dos dados completos dos clientes cadastrados
CREATE VIEW vw_AllDataForClients AS
  SELECT P.idPessoa AS ID_CLIENTE,
  P.nomePessoa AS NOME, 
  CONCAT('(',T.ddd,')', T.numero) AS TELEFONE,
  P.cpfPessoa AS CPF,
  P.logradouroPessoa AS RUA,
  B.nomeBairro AS Bairro,
  M.nomeMunicipio AS Municipio
  FROM Pessoa P
  JOIN Cliente C ON C.idPessoa = P.idPessoa
  JOIN Telefone T ON P.idTelefone = T.idTelefone
  JOIN Bairro B ON B.idBairro = P.idBairro
  JOIN Municipio M ON M.idMunicipio = B.idMunicipio
  WHERE P.idPessoa > 0;

  SELECT * FROM vw_AllDataForClients;


  -- VIEW Simples para a visualização dos dados completos dos funcionario cadastrados (Ativos e inativos)
CREATE VIEW vw_AllDataForEmployees AS
  SELECT P.nomePessoa AS NOME, 
  CONCAT('(',T.ddd,')', T.numero) AS TELEFONE,
  P.cpfPessoa AS CPF,
  P.logradouroPessoa AS RUA,
  B.nomeBairro AS BAIRRO,
  M.nomeMunicipio AS MUNICIPIO,
  F.estado AS STATUS,
  F.dataAdmissao,
  F.dataDemissao
  FROM Pessoa P
  JOIN Funcionario F ON F.idPessoa = P.idPessoa
  JOIN Telefone T ON P.idTelefone = T.idTelefone
  JOIN Bairro B ON B.idBairro = P.idBairro
  JOIN Municipio M ON M.idMunicipio = B.idMunicipio
  WHERE F.idFuncionario > 0;

  SELECT * FROM vw_AllDataForEmployees;

-- VIEW MATERIALIZADA para a visualização de todas as informações referente a Fornecedores
CREATE MATERIALIZED VIEW vw_allDataForProviders AS
  SELECT F.cnpjFornecedor AS CNPJ,
  F.nomeFornecedor,
  CONCAT('(',T.ddd,')', T.numero) AS TELEFONE,
  F.logradouroFornecedor AS ENDEREÇO,
  B.nomeBairro AS BAIRRO,
  M.nomeMunicipio AS MUNICIPIO
  FROM Fornecedor F
  JOIN Telefone T ON T.idTelefone = F.idTelefone
  JOIN Bairro B ON B.idBairro = F.idBairro
  JOIN Municipio M ON M.idMunicipio = B.idMunicipio
  WHERE F.idFornecedor > 0;  

  SELECT * FROM vw_allDataForProviders;


-- VIEW Simples para a visualização de todas as informações referente a estoque
CREATE VIEW vw_allDataForProducts AS
  SELECT P.nomeProduto,
  E.quantidadeEstoque,
  P.valorProduto AS Valor_Unitario,
  (P.valorProduto * E.quantidadeEstoque) AS Valor_Total,
  F. nomeFornecedor,
  P.dataCompra
  FROM Produto P
  JOIN Estoque E ON E.idProduto = P.idProduto
  JOIN Fornecedor F ON F.idFornecedor = P.idFornecedor
  WHERE P.idProduto > 0;

  SELECT * FROM vw_allDataForProducts;


-- VIEW Materializada para a visualização de todas as vendas e suas informações detalhadas
CREATE MATERIALIZED VIEW vw_allSalesData AS
  SELECT DISTINCT PG.idPagamento AS COD_PAGAMENTO,
  PG.idServico AS COD_SERVIÇO,
  (SELECT P.nomePessoa FROM Pessoa P WHERE F.idPessoa = P.idPessoa) AS NOME_FUNCIONARIO,
  (SELECT P.nomePessoa FROM Pessoa P WHERE C.idPessoa = P.idPessoa) AS NOME_CLIENTE,
  S.marcaAparelho,
  S.modeloAparelho,
  S.descricaoServico,
  S.valorServico,
  PR.nomeProduto,
  I.quantidadeItens,
  PR.valorProduto,
  PG.valorTotal,
  A.dataAtendimento,
  PG.dataPagamento,
  PG.statusPagamento
  FROM Pagamento PG
  JOIN ItensProduto I ON PG.idItensProduto = I.idItensProduto
  JOIN Produto PR ON PR.idProduto = I.idProduto
  JOIN Servico S ON S.idServico = PG.idServico
  JOIN Atendimento A ON A.idAtendimento = S.idServico
  JOIN Funcionario F ON F.idFuncionario = A.idFuncionario
  JOIN Cliente C ON C.idCliente = A.idCliente
  JOIN Pessoa P ON P.idPessoa = F.idPessoa OR P.idPessoa = C.idPessoa
  WHERE PG.idPagamento > 0
  ORDER BY PG.idPagamento ASC

  SELECT * FROM vw_allSalesData;


                                          /* Documento finalizado em 02/07/2022 às 16 horas e 08 minutos (GMT -3) */