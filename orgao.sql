-- Cria a tabela orgao 
create table normalizado.orgao(
	codigo_orgao integer,
	nome_orgao varchar(255),
	codigo_orgao_superior integer,
	primary key (codigo_orgao),
	constraint fk_orgao_orgao_superior 
		foreign key (codigo_orgao_superior) 
		references orgao_superior(codigo_orgao_superior)
);

-- Cria um index para a foreign key
create index orgao_fkey on normalizado.orgao(codigo_orgao_superior);

-- Popula a tabela orgao
insert into 
	normalizado.orgao
select distinct on(codigo_orgao) 
	codigo_orgao, 
	nome_orgao, 
	codigo_orgao_superior 
from public.final_cpgf 
order by codigo_orgao, "data" desc 
;

-- Faz um select dessa tabela
select * from normalizado.orgao o ;

-- Formas alternativas de selects para popular a tabela orgao
select distinct on(codigo_orgao) codigo_orgao, nome_orgao, codigo_orgao_superior from public.final_cpgf order by codigo_orgao ;
select codigo_orgao, max(nome_orgao), max(codigo_orgao_superior)  from public.final_cpgf fc group by codigo_orgao order by codigo_orgao ;
