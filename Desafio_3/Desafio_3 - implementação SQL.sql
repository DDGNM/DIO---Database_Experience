-- Criação do banco de dados para e-commerce
-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- CRIAÇÃO DE TABELAS BASE --

-- Tabela Cliente
create table Cliente(
	idClient int auto_increment primary key,
    cName varchar(20) not null,
    cAdress varchar(30) not null,
	cemail varchar(50)
);
alter table cliente auto_increment=1;
-- Tabela CPF e CNPJ --
create table CPF(
	idCPF int auto_increment primary key,
    Fname varchar(20) not null, 
    Mname varchar(3),
    Lname varchar(20),
    CPF varchar(11) not null,
    idClient int,
    constraint unique_CPF_client unique(CPF),
    constraint fk_client_idclient foreign key ( idClient ) references Cliente ( idClient )
);	
-- alter table CPF auto_increment=1;
-- eName corresponde a razão social e IE correnponde a inscrição estadual
create table CNPJ(
	idCNPJ int auto_increment primary key,
    eName varchar(45) not null,
    CNPJ varchar(14),
    IE varchar(10),
    idClient int,
    constraint unique_CNPJ_client unique(CNPJ),
    constraint fk_client_CNPJ foreign key (idClient) references Cliente (idClient)
);
-- alter table CNPJ auto_increment=1;
-- Tabela Fornecedores -- 
create table supplier(
	idsupplier int auto_increment primary key,
    sName varchar(45),
    sCNPJ varchar(20),
    idproduct int
    -- constraint fk_product_supplier foreign key (idproduct) references product (idproduct)
    );
-- alter table supplier auto_increment=1;
-- Tabela de Terceiro vendedor --
create table third_party_seller(
	idthird_party_seller int auto_increment primary key,
    tName varchar(45),
    tCNPJ varchar(20),
    idproduct int
    -- constraint fk_product_third_party_seller foreign key (idproduct) references product (idproduct)
    );
-- alter table third_party_seller auto_increment=1;
-- Tabela Produtos --
create table product(
	idproduct int auto_increment primary key,
	pName varchar ( 20) not null,
    pDescription varchar (45),
    category enum ( "Eletrônico" , "Vestimenta" , "Brinquedos" , "Alimentos" , "Moveis" ) not null,
    pevaluation float default 0,
    pvalue float
    -- idOrder int,
    -- constraint fk_order_product foreign key (idOrder) references Orders (idOrder),
   --  idstorage int,
    -- constraint fk_storage_product foreign key (idstorage) references storagelocation (idstorage),
   --  idsupplier int,
    -- constraint fk_supplier_product foreign key (idsupplier) references supplier (idsupplier),
    -- idthird_party_seller int
	-- constraint fk_third_party_seller_product foreign key (idthird_party_seller) references third_party_seller (idthird_party_seller)
    );
-- alter table product auto_increment=1;
 -- Tabela de estoque --
create table productstorage(
	idstorage int auto_increment primary key,
    location varchar(20)
);
-- alter table productstorage auto_increment=1;
-- Tabela de Entrega --
create table delivery(
	idDelivery int auto_increment primary key,
    tracking_code varchar(10),
    deliveryStatus enum ( "Cancelado" , "Confirmado" , "Em processamento" )
    );
-- alter table delivery auto_increment=1;
 -- Tabela de Pagamentos --
create table Payments(
	idPayments int auto_increment primary key,
    Paycategory enum ("boleto", "cartão debito", "cartão crédito", "dinheiro"),
    linitAvailable float
    -- idOrder int,
    -- constraint fk_order_payments foreign key (idOrder) references Orders (idOrder)
) ;
 -- alter table Payments auto_increment=1;

 -- CRIAÇÃO DE TABELAS DE RELAÇÕES
 
  -- Tabela Pedido --
 create table Orders(
	idOrder int auto_increment primary key ,
    OrderStatus enum ( "Cancelado" , "Confirmado" , "Em processamento")  not null,
    amount int not null,
    OrderDescription varchar ( 255 ) ,
    deliveryvalue float default 10 ,
    paymentbol bool default false,
    idOrderClient int,
    constraint fk_orders_client foreign key (idOrderClient) references cliente (idClient),
    idDelivery int,
	constraint fk_delivery_order foreign key ( idDelivery) references delivery (idDelivery)
);
alter table Orders auto_increment=1;
 -- Tabela de relação Terceiros e Produtos -- 
 create table third_party_sales(
	idthird_party_seller int ,
    idproduct int ,
    primary key (idthird_party_seller , idproduct),
    constraint fk_third_party_seller_third_party_sales foreign key (idthird_party_seller) references third_party_seller (idthird_party_seller) ,
	constraint fk_product_third_party_sales foreign key (idproduct) references product (idproduct)
);

 -- Tabela relação Fornecerdor e Produto   
create table supplier_product(
	idsupplier int,
    idproduct int,
    primary key (idsupplier, idproduct),
    constraint fk_supplier_product_supplier foreign key (idsupplier) references supplier (idsupplier) ,
	constraint fk_supplier_product_product foreign key (idproduct) references product (idproduct)
);

-- Tabela de relação Estoque/produto --
create table storagelocation (
    idproduct int,
    idstorage int,
    location varchar ( 255 ) not null,
    primary key ( idproduct , idstorage ),
    constraint fk_storage_location_product foreign key (idproduct) references product (idProduct) ,
	constraint fk_storage_location_storage foreign key (idstorage) references productStorage (idstorage)
);

-- Tabela de relação pedido e pagamentos --
create table order_payments(
	idOrder int,
    idPayments int,
    Primary key (idOrder, idPayments),
    constraint fk_order_payments_orders foreign key (idOrder) references Orders (idOrder),
    constraint fk_order_payments_Payments foreign key (idPayments) references Payments (idPayments)
    );

-- POPULANDO AS TABELAS --

INSERT INTO Cliente (cName, cAdress, cemail)
		values("Beatriz","Rua Primeiro de maio ","bea@triz.com"),
			  ("Esther","Vinte de março 9730 ", "esther@cardoso"),
              ("Ana Carolina","São Francisco de Assis ", "anac@lima.com"),
              ("Clarice","802 rua 10","clarices@sales.com" ),
              ("Maria Clara","São josé 982 rua 15","maria@rocha.com"),
              ("Araujo Atacadista","Abreu 34 rua 10","atacadista@araujo.com"),
              ("Mazon IT", "Rua 12 vicente P", "mazon@it.com");

INSERT INTO CPF (Fname, Mname, Lname,CPF, idClient)
		values("Beatriz", "M", "Magalhaes", "40537213503","1"),
			  ("Esther","J","Cardoso","16308533130","2"),
              ("Ana Carolina","A","Rochedo","83015473247","3"),
              ("Clarisse","P","Linspector","04265218890","4"),
              ("Maria Clara","K","Martins","88439526415","5");

INSERT INTO CNPJ (ename, CNPJ, IE, idClient)
			values("Araujo atacadista", "66810474000107", "248699466", "6"),
				  ("Mazon IT e DEV","74285788000166" ,"399982-46", "7");

INSERT INTO supplier (sName, sCNPJ, idproduct)
				values("Mazzo vitorino", "24778134000104","1"),
					  ("Danna moveis","07534772000152","2");
    
INSERT INTO third_party_seller (tName, tCNPJ, idproduct)
			VALUES("Regina confecções","54985520000120","2"),
				  ("Martins Móveis","75171350000110","1"),
                  ("Atlata revenda","65497841000100","3");

INSERT INTO product ( pName, pDescription, category,pvalue, pevaluation)
			VALUES( "Cadeira Giratória","Cadeira que gira e tem roda","Moveis", 520.50, 4.75),
				  ("Carro FIAT","Uno modelo 2020","Eletrônico",2500.00, 4.85),
                  ("Liquidificador", "Liquidificador industrial", "Eletrônico", 587.41, 3.85);

INSERT INTO productstorage (location)
			VALUES(	"Taguatinga"),
				  ("Gama");

  INSERT INTO  delivery (tracking_code, deliveryStatus)
				VALUES("AD85TR", "Confirmado"),
					  ("TR96WE", "Em processamento"),
                      ("HG45PO", "Confirmado");
     
     INSERT INTO Payments(Paycategory,  linitAvailable)
				VALUES("boleto",10000),
					  ("cartão crédito",50000),
                      ("dinheiro", 10000000);

INSERT INTO Orders(OrderStatus, amount, OrderDescription, deliveryvalue, paymentbol, idOrderClient)
		VALUES("Confirmado", 52000, "VENDA GRANDE DE UM PRODUTO", 50, true, "1"),
			  ("Cancelado", 35000, "venda bem descrita", 100, false, "1"),
              ("Confirmado", 879, "descrição loren ipsun", 50, true, "2"),
              ("Em processamento", 4521, "ipsum lorem", 38, false, "3"),
              ("Em processamento", 1000, "Descrição ipsum",20, false, "6"),
              ("Em processamento", 852, "Lorem descrição",20, false,"7");

INSERT INTO third_party_sales(idthird_party_seller, idproduct )
		VALUES("2","1"),
			  ("1","3"),
              ("2","2");
              
INSERT INTO supplier_product(idsupplier, idproduct)
		VALUES("1","2"),
			  ("2","1"),
              ("2","3");

INSERT INTO storagelocation (idproduct, idstorage, location)
			VALUES("2","1", "Local Taguatinga"),
				  ("3","1", "Local taguating"),
                  ("1","2", "Local gama");

INSERT INTO order_payments(idOrder, idPayments)
		VALUES("2","1"),
			  ("3","2"),
              ("1","2");

-- TESTE DE QUERIES COM CLAUSULAS VARIADAS --

select count(*) from cliente;

select idcliente, cAdress, cemail, CPF, CNPJ from cliente
	inner join 
