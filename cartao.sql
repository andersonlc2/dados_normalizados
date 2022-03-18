-- Cria a tabela cartao 
create table normalizado.cartao(
	codigo_compra integer,
	codigo_portador integer,
	codigo_unidade_compra integer,
	documento_favorecido varchar(20),
	nome_favorecido varchar(255),
	transacao varchar(255),
	valor decimal(13,2),
	"data" date,
	primary key (codigo_compra),
	constraint fk_cartao_portador
		foreign key (codigo_portador)
		references portador (codigo_portador),
	constraint fk_cartao_unidade_compra
		foreign key (codigo_unidade_compra)
		references unidade_gestora (codigo_unidade_gestora)
);

-- Cria um index para as foreign key
create index cartao_portador_fkey on cartao(codigo_portador);
create index cartao_unidade_fkey on cartao(codigo_unidade_compra);

-- Cria um sequence para o cartao
create sequence cartao_sequence start with 10000;
alter table normalizado.cartao alter column codigo_compra set default nextval('cartao_sequence'::regclass) ;


-- Popula a tabela cartao
insert into 
	cartao (codigo_portador, codigo_unidade_compra, documento_favorecido, nome_favorecido, transacao, valor, "data")
select 
	p.codigo_portador,
	ug.codigo_unidade_gestora  ,
	cp.documento_favorecido, 
	cp.nome_favorecido,
	cp.transacao,
	cp.valor,
	cp."data" 
from 
	public.final_cpgf cp 
inner join 
	portador p on p.cpf = cp.cpf_portador and p.nome_portador = cp.nome_portador 
inner join 
	unidade_gestora ug on ug.codigo_unidade_gestora = cp.codigo_unidade_gestora
where 
	cp.documento_favorecido <> '-11'
order by "data"
;

-- Popula a tabela cartao SOMENTE OS SIGILOSOS
insert into 
	cartao (codigo_portador, codigo_unidade_compra, documento_favorecido, nome_favorecido, transacao, valor, "data")
select 
	p.codigo_portador,
	cp.codigo_unidade_gestora  ,
	cp.documento_favorecido, 
	cp.nome_favorecido,
	cp.transacao,
	cp.valor,
	cp."data" 
from 
	public.final_cpgf cp 
inner join 
	portador p on p.nome_portador = cp.nome_portador  
inner join 
	unidade_gestora ug on ug.codigo_unidade_gestora = cp.codigo_unidade_gestora
where 
	p.codigo_unidade_gestora = ug.codigo_unidade_gestora and
	cp.documento_favorecido = '-11'
order by "data"
;

-- Faz um select dessa tabela 455352
select count(*) from cartao ;




-- Formas alternativas de selects para popular a tabela cartao
-- sigilosos
select count(*) from (
select 
	(select codigo_portador from portador p where p.cpf =cp.cpf_portador and p.nome_portador = cp.nome_portador and p.codigo_unidade_gestora =cp.codigo_unidade_gestora  group by codigo_portador), 
	cp.documento_favorecido, 
	cp.nome_favorecido,
	cp.transacao,
	cp.valor,
	cp."data" 
from public.final_cpgf cp 
where documento_favorecido = '-11'
) as foo;


-- não sigilosos
select count(*) from (
select 
	(select codigo_portador from portador p where p.cpf =cp.cpf_portador and p.nome_portador = cp.nome_portador group by codigo_portador), 
	cp.documento_favorecido, 
	cp.nome_favorecido,
	cp.transacao,
	cp.valor,
	cp."data" 
from public.final_cpgf cp 
where documento_favorecido <> '-11'
) as foo;


-- Consultas do teste 
select sum(valor) from final_cpgf;
-- 266352493.66
select sum(valor) from cartao;

select sum(valor) from final_cpgf where documento_favorecido = '-11';
-- 133732792.78
select sum(valor) from cartao where documento_favorecido = '-11'; 

select count(*) as qtd, sum(valor), codigo_orgao, nome_orgao from final_cpgf where documento_favorecido = '-11' group by nome_orgao, codigo_orgao order by qtd desc limit 1;
-- 64716 R$55657258,49 orgao 30108 Departamento de Polícia Federal
select count(*) as qtd, sum(valor), ug.codigo_orgao, o.nome_orgao 
from cartao c
inner join portador p on p.codigo_portador = c.codigo_portador
inner join unidade_gestora ug on ug.codigo_unidade_gestora = p.codigo_unidade_gestora 
inner join orgao o on o.codigo_orgao = ug.codigo_orgao 
where documento_favorecido = '-11' 
group by ug.codigo_orgao, o.nome_orgao  order by qtd desc limit 1;

select count(*) as qtd, sum(valor), nome_portador, nome_orgao from final_cpgf where transacao ilike '%saque%' group by nome_portador, nome_orgao  order by qtd desc limit 1;
-- 295 210775.00 JOAO LUIZ DA COSTA Ministério da Agricultura, Pecuária e Abastecimento - Unidades com vínculo direto
select
	count(*) as qtd,
	sum(valor),
	c.codigo_portador,
	p.nome_portador,
	o.nome_orgao 
from 
	cartao c 
inner join 
	portador p on p.codigo_portador = c.codigo_portador 
inner join 
	unidade_gestora ug on ug.codigo_unidade_gestora = p.codigo_unidade_gestora 
inner join 
	orgao o on o.codigo_orgao = ug.codigo_orgao 
where 
	transacao
ilike 
	'%saque%'
group by 
	c.codigo_portador,
	p.nome_portador,
	o.nome_orgao
order by
	qtd
	desc
limit 1
;

select count(*) as qtd, nome_favorecido  from final_cpgf
where documento_favorecido <> '-11' and documento_favorecido <> '-2' and documento_favorecido <> '-1'
group by nome_favorecido  order by qtd desc limit 1;
-- 3103  KALUNGA COMERCIO E INDUSTRIA GRAFICA LTDA


select * from final_cpgf ;

select 
	count(*)
	from (
select 
	c.codigo_compra, 
	os.codigo_orgao_superior, 
	os.nome_orgao_superior,
	o.codigo_orgao ,
	o.nome_orgao ,
	p.codigo_unidade_gestora,
	ug.nome_unidade_gestora ,
	p.cpf ,
	p.nome_portador ,
	c.documento_favorecido ,
	c.nome_favorecido ,
	c.transacao ,
	c."data" ,
	c.valor 
from cartao c
inner join portador p on p.codigo_portador = c.codigo_portador 
inner join unidade_gestora ug  on ug.codigo_unidade_gestora  = p.codigo_unidade_gestora  
inner join orgao o on o.codigo_orgao = ug.codigo_orgao 
inner join orgao_superior os on os.codigo_orgao_superior = o.codigo_orgao_superior 
-- where documento_favorecido <> '-11'
order by "data" DESC
) as foo ;


select count(c.nome_portador) as qtd, c.nome_portador , c.codigo_unidade_gestora, c.nome_unidade_gestora
from final_cpgf c 
-- where c.nome_portador  = 'AISLAN BACHA'
group by c.codigo_unidade_gestora , c.nome_portador, c.nome_unidade_gestora
order by c.nome_portador  desc
;

select distinct codigo_orgao, nome_orgao, codigo_unidade_gestora , nome_unidade_gestora, "data" from final_cpgf 
group by codigo_orgao, nome_orgao, codigo_unidade_gestora, nome_unidade_gestora, "data" order by "data"  ;

-- verifica a quantidade de unidades gestoras com orgao diferentes
select count( codigo_unidade_gestora), codigo_unidade_gestora  from (
select codigo_unidade_gestora , nome_unidade_gestora ,codigo_orgao from final_cpgf 
group by codigo_unidade_gestora, codigo_orgao,nome_unidade_gestora order by codigo_unidade_gestora desc) as foo 
group by codigo_unidade_gestora order by count desc;

select codigo_unidade_gestora, nome_unidade_gestora , codigo_orgao  from final_cpgf where codigo_unidade_gestora = '170069' group by codigo_unidade_gestora, codigo_orgao, nome_unidade_gestora  ;

-- verifica a quantidade de orgao com orgao superiores diferentes
select count( codigo_orgao), codigo_orgao  from (
select codigo_orgao  , nome_orgao  ,codigo_orgao_superior  from final_cpgf 
group by codigo_orgao  , nome_orgao  ,codigo_orgao_superior order by codigo_orgao desc) as foo 
group by codigo_orgao order by count desc; 

select codigo_orgao , nome_orgao , codigo_orgao_superior , nome_orgao_superior from final_cpgf where codigo_orgao = '24216'
group by codigo_orgao , nome_orgao , codigo_orgao_superior , nome_orgao_superior;

-- verifica a quantidade de portador com unidade gestoras diferentes
select count(*), cpf_portador, nome_portador   from (
select nome_portador, cpf_portador , codigo_unidade_gestora 
from final_cpgf 
group by nome_portador, cpf_portador , codigo_unidade_gestora 
) as foo
group by cpf_portador, nome_portador  order by count desc;

select nome_portador, cpf_portador from final_cpgf 
where nome_portador = 'JOSE MARIA DA SILVA'
group by nome_portador, cpf_portador ;

select nome_portador, cpf_portador, codigo_unidade_gestora, nome_unidade_gestora, "data"  from final_cpgf 
where cpf_portador = '***.195.783-**'
group by nome_portador, cpf_portador, codigo_unidade_gestora, nome_unidade_gestora, "data"
order by "data" desc;

