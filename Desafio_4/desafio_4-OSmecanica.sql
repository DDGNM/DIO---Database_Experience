-- implementação do banco de dados de um oficina mecânica
-- drop database mecanica; -- drop database mecanica; -- drop database mecanica; -- drop database mecanica;
-- CRIAR A BASE DE DADOS --
create database mecanica;
use mecanica;

-- CRIAR TABELAS DO BD MECÂNICA -- 

-- Tabela Cliente
create table cliente(
	idcliente int auto_increment primary key,
    cnome varchar(30) not null,
    cendereco varchar(100)not null,
    ctelefone varchar(20)not null,
    ccarro varchar (30) not null
    );
    
alter table cliente auto_increment=1;

-- Tabela produtos
create table produtos(
	idprodutos int auto_increment primary key,
    pdescricao varchar(100),
    pvalor float    
    );
    
-- Tabela fornecedor
create table fornecedor(
	idfornecedor int auto_increment primary key,
    fnome varchar(30) not null,
    fCNPJ varchar(30) not null,
    ftelefone varchar(30) not null,
    femail varchar(30),
    constraint unique_CNPJ unique(fCNPJ)    
    );
    
-- Tabela serviços
create table servicos(
	idservicos int auto_increment primary key,
    sdescricao varchar(100),
    svalor float    
    );
    
-- Tabela funcionários
create table funcionario(
	idfuncionario int auto_increment primary key,
    funome varchar(30) not null,
    fuendereco varchar(50)not null,
    fuespecialidade enum("mecanica","eletrica", "funilaria") not null,
    fusalario float not null
    );
    
    
    -- Tabela Equipe técnica
create table equipet(
	idequipet int,  
    idfuncionario int,
    primary key (idequipet,idfuncionario),
    constraint fk_equipet_funcionario foreign key (idfuncionario) references funcionario (idfuncionario)
    );
    
-- Tabela de ordem de serviço
create table ordem_servico(
	idordem_servico int auto_increment primary key,
    data_abertura datetime not null,
    osstatus enum("cancelada", "em processamento", "finalizada", "aguardando") default ("aguardando"),
    osdescricao varchar (100),
    data_conclusao datetime, 
    idequipet int,
    constraint fk_ordem_servico_equipet foreign key (idequipet) references equipet (idequipet),
    idcliente int,
    constraint fk_ordem_servico_cliente foreign key (idcliente) references cliente (idcliente)
    );

-- TABELAS DE RELACIONAMENTOS --


    
-- Tabela relação funcionario x serviços
create table oferta_servico(
	idfuncionario int,
    idservicos int,
    primary key (idfuncionario, idservicos),
    constraint fk_oferta_servico_funcionario foreign key (idfuncionario) references funcionario (idfuncionario),
    constraint fk_oferta_servico_servicos foreign key (idservicos) references servicos (idservicos)
    );
    
-- Tabela relação fornecedor x produto
create table disponibiliza_produto(
	idfornecedor int,
    idprodutos int,
    primary key (idfornecedor,idprodutos),
    constraint fk_disponibiliza_produto_fornecedor foreign key (idfornecedor) references fornecedor (idfornecedor),
    constraint fk_oferta_servico_produtos foreign key (idprodutos) references produtos (idprodutos)
    );

-- Tabela de relação produto x ordem de serviço
create table produto_os(
	idprodutos int,
    idordem_servico int,
    primary key (idprodutos,idordem_servico),
    constraint fk_produto_os_produtos foreign key (idprodutos) references produtos (idprodutos),
    constraint fk_produto_os_ordem_servico foreign key (idordem_servico) references ordem_servico (idordem_servico)
    );

-- Tabela de relação serviço x ordem de serviço
create table servico_os(
	idservicos int,
    idordem_servico int,
    primary key (idservicos,idordem_servico),
    constraint fk_servico_os_servico foreign key (idservicos) references servicos (idservicos),
    constraint fk_servico_os_ordem_servico foreign key (idordem_servico) references ordem_servico (idordem_servico)
    );

-- POPULANDO BASES --

INSERT INTO Cliente (cnome,cendereco,ctelefone,ccarro)
		VALUES("Beatriz","Rua 24 norte","987568972","Fiat uno"),
			  ("Luan","Asa sul 308","978451236","Fiat Marea"),
              ("Cintia","Guará qd 15","965328974","Volkswagen Gol"),
              ("Carlos","Guariroba qd 35","978456325","Renalt Kwid"),
              ("Layanne","Samambaia qd 408","987453322","Fiat argo");

INSERT INTO produtos (pdescricao,pvalor)
			VALUES ("Rebimboca da parafuseta", 56.89),
				   ("motor de partida", 850.65),
                   ("Injeção eletrônica", 158.78),
                   ("Oléo de freio", 70.00),
                   ("Oleo de motor", 45.78);

INSERT INTO fornecedor (fnome,fCNPJ,ftelefone,femail )
			VALUES("Exxon Mobil","11.751.254/0001-68","35975896","exxon@mobil.com"),
				  ("Commando","15.149.443/0001-16","34568975","commando@pecas"),
                  ("Xevron","37.726.224/0001-95","35974596","xevron@oil.com"),
                  ("Shell","65.618.584/0001-09","398567485","Shell@shell.com");

INSERT INTO servicos (sdescricao,svalor)
			VALUES ("Troca de óleo", 85.00),
				   ("Manutenção de fitro", 112.56),
                   ("Mão de obra padrão", 100.00),
                   ("Aperto de parafuso", 30.00);

INSERT INTO funcionario (funome,fuendereco,fuespecialidade,fusalario)
			VALUES("Tales Rodrigues","Rua 25 norte","mecanica", 3000),
				  ("Jorge Almeida"," QnR 514 samambaia","eletrica", 2500),
                  ("Rodrigo Sampaio","Qn 408 conjunto B","mecanica", 3500),
                  ("Pedro Alvarez","Asa norte 515","funilaria", 3000),
                  ("Anna Barros"," Sobradinho qd 04","mecanica", 2500);

INSERT INTO equipet (idequipet,idfuncionario)
			VALUES("1","1"),
				  ("2","5"),
                  ("1","4"),
                  ("2","3"),
                  ("1","2");

INSERT INTO ordem_servico (data_abertura,osstatus,osdescricao,data_conclusao,idequipet,idcliente)
			VALUES("2021-08-01 00:00:01","em processamento","Aguardando peça do fornecedor",null,"1","1"),
				  ("2022-05-01 00:00:01","em processamento","Troca de motor completa",null,"2","2"),
                  ("2022-05-08 00:00:01","cancelada","Troca de óleo","2022-05-09 00:00:01","2","3"),
                  ("2022-07-04 00:00:01","finalizada","Calibrar pneus","2022-07-04 00:15:01","1","4"),
                  ("2022-07-09 00:00:01","aguardando","Trocar rodas",null,"2","2");




INSERT INTO oferta_servico (idfuncionario,idservicos)
			VALUES("1","4"),
				  ("2","1"),
                  ("3","2"),
                  ("4","3"),
                  ("4","4");

INSERT INTO disponibiliza_produto (idfornecedor,idprodutos)
			VALUES("1","4"),
				  ("2","1"),
                  ("3","2"),
                  ("4","3"),
                  ("3","4");

  INSERT INTO produto_os (idprodutos,idordem_servico)
			VALUES("1","5"),
				  ("2","1"),
                  ("3","2"),
                  ("4","3"),
                  ("2","4");  
            
INSERT INTO servico_os (idservicos,idordem_servico)
			VALUES("1","5"),
				  ("2","1"),
                  ("3","2"),
                  ("4","3"),
                  ("1","4");  
                  
 -- QUERIES VARIADAS -- 
 
 
 select idordem_servico,osstatus,osdescricao,cnome,ccarro from ordem_servico as os
		left join cliente as c
        on os.idcliente = c.idcliente;
  
  select idordem_servico,osstatus,osdescricao,cnome,ccarro from ordem_servico as os
		left join cliente as c
        on os.idcliente = c.idcliente
        where cnome = "Beatriz";
        