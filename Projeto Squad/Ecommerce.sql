-- create database ecommerce;

create table categoria (
  id serial primary key,
  nome varchar(100) unique not null,
  descricao varchar(500) 
  );

create table funcionario (
  id serial primary key,
  nome varchar(255) not null unique,
  cpf varchar(11) unique not null
  );
  
create table produto (
  id serial primary key,
  nome varchar(100) unique not null,
  descricao varchar(500) not null,
  valor float not null,
  qtd_estoque int not null default 0,
  data_fab date not null,
  id_categoria int references categoria(id),
  id_funcionario int references funcionario(id)
  );
  
create table cliente(
  id serial primary key,
  nome varchar(255) unique not null,
  cpf varchar(11) unique not null,
  data_nasc date not null,
  endereco varchar(100),
  email varchar(255),
  nome_usuario varchar(20) unique not null
  );

create table pedido(
  id serial primary key,
  id_cliente int references cliente(id),
  data_pedido date not null
  );
  
create table notafiscal(
  id serial primary key,
  id_pedido int references pedido(id)
  );

create table pedido_item(
  id_pedido int references pedido(id),
  id_produto int references produto(id)
  );


------------------------------------;

-- CRIANDO AS CATEGORIAS

insert into categoria (nome, descricao) 
values
('Comida', 'Alimentos em geral.'), 
('Roupa', 'Artigos de vestuário feminino e masculino.'), 
('Eletrônicos', 'Eletrodomésticos e acessórios eletrônicos.'), 
('Utensilhos', 'Acessórios de uso doméstico.'), 
('Diversos', 'Tudo que não se enquadrar única e específicamente em alguma das outras categorias.');


SELECT * FROM categoria

------------------------------------;

-- CRIANDO OS FUNCIONARIOS

insert into funcionario (nome, cpf) values

('Andre', '11111111111'), 
('Gustavo', '22222222222'), 
('Higor', '33333333333'), 
('Rodrigo', '44444444444'), 
('Vanderson', '55555555555');


SELECT * FROM funcionario

------------------------------------;

-- INSERINDO OS PRODUTOS


insert into produto (nome, descricao, valor, qtd_estoque, data_fab, id_categoria, id_funcionario)
values
('Miojo', 'Macarrão instantâneo salvador de larica', 0.99, 10, '2021-09-15', 1, 1),
('Camisa do Flamengo', 'Camisa do melhor time do brasil', 249.99, 6, '2021-09-15', 2, 2),
('PC GAMER', 'Roda mais de 1000FPS', 9.999, 2, '2021-09-15', 3, 3),
('Potinho de marmita', 'Balde para alimentar pedreiros', 15.60, 5, '2021-09-15', 4, 4),
('Abridor de vinho', 'Melhor abridor de vinhos', 3.99, 3, '2021-09-15', 5, 5);


SELECT * FROM produto;

------------------------------------;

-- CRIANDO OS CLIENTES


insert into cliente (nome, cpf, data_nasc, endereco, nome_usuario)
values
('José', '11122233344', '1999-09-05', 'Rua Tenente Luis Meirelles, 123', 'ze_paulo'),
('Alfredo', '22233344455', '2000-09-05', 'Rua Buraco Quente, 132', 'alfredo_1980'),
('Josefina', '33344455566', '2003-09-05', 'Avenida Lucio Meira, 555', 'zefina'),
('Madalena', '44455566677', '1963-09-05', 'Avenida NS de Copacabana', 'lena_mada'),
('David Luiz', '55566677788', '1980-09-01', 'Ninho do Urubu, 6', 'davi_lu');


SELECT * FROM cliente;

------------------------------------;

--INSERINDO PEDIDOS

insert into pedido (id_cliente, data_pedido) values
(4, '2015-09-21'),
(5, '1977-07-21'),
(3, '1980-04-08'),
(1, '2001-04-03'),
(2, '2002-02-20'),
(4, '2005-04-20');

insert into pedido_item (id_pedido , id_produto) values
(1,5),
(1,5),
(1,3),
(1,3), 
(1,3),
(1,1),
(1,2),
(1,2),
(2,2),
(2,4),
(2,4),
(3,1),
(3,1),
(3,1),
(3,3),
(3,5),
(3,5),
(4,1),
(4,1),
(4,1),
(5,1),
(5,1),
(5,3),
(5,3),
(5,4),
(6,1),
(6,5),
(6,5),
(6,3);


------------------------------------;


-- MANIPULANDO DADOS NA TABELA E CONSULTA

-- ATUALIZANDO DADOS

-- (atualiza os produtos da categoria "eletrônicos", definindo um preço novo)
UPDATE produto 
	SET valor = 7.999
WHERE id_categoria = 3

-- (atualiza o cadastro do alfredo adicionando um endereço de email)
update cliente set email = 'alfredo@gmail.com' where id = '2'

-- DELETANDO 

-- deleta os pedidos da cliente josefina
delete from pedido_item pi where pi.id_pedido in(select pe.id from pedido pe where id_cliente = 3)

-- CONSULTANDO
SELECT * FROM produto 
	WHERE data_fab = '2021-09-15'
ORDER BY produto DESC;

--
SELECT * FROM cliente
ORDER BY data_nasc ASC;

--
SELECT * FROM cliente
ORDER by id DESC;

--
SELECT * FROM categoria
ORDER by nome DESC; 

--
SELECT COUNT (nome) as qtd_cliente FROM cliente;

--
SELECT nome, valor FROM produto
GROUP BY id

--
SELECT id, nome_usuario, email FROM cliente
GROUP BY id

-- 
SELECT id_funcionario, nome FROM produto
GROUP BY produto.id


------------------------------------;
-- JOIN
--

-- CONSULTAR QUANTOS DE CADA PRODUTO CADA CLIENTE COMPROU

select c.nome as nome_cliente, pr.nome as nome_produto, count(pr.nome) as quantidade 
    from pedido_item pi 
    join pedido pe on pe.id = pi.id_pedido
    join produto pr on pr.id = pi.id_produto
    join cliente c on c.id = pe.id_cliente
    group by c.nome, pr.nome
    order by c.nome

-- CONSULTAR QUANTOS PRODUTOS CADA CLIENTE COMPROU NO TOTAL

select c.nome as nome_cliente, count(pr.nome) as quantidade 
    from pedido_item pi 
    join pedido pe on pe.id = pi.id_pedido
    join produto pr on pr.id = pi.id_produto
    join cliente c on c.id = pe.id_cliente
    group by c.nome
    order by quantidade  

-- CONSULTAR O QUE FOI REGISTRADO POR CADA FUNCIONARIO

SELECT 
	funcionario.id,
    funcionario.nome as nome_funcionario,
    produto.nome as produto_registrado
    
FROM funcionario
	INNER JOIN produto
ON produto.id = funcionario.id

-- EXIBE A NOTA FISCAL DE UM DOS PEDIDOS DA MADALENA

select pe.id as codigo_pedido, pe.data_pedido as data, c.nome as comprador, count(pr) as qtd_itens, sum(pr.valor) as preco_total from pedido_item pi 
	join pedido pe on pe.id = pi.id_pedido
    join produto pr on pr.id = pi.id_produto
    join cliente c on c.id = pe.id_cliente
	where pe.id = 6
    group by c.nome, pe.id
