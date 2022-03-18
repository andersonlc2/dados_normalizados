-- Cria a tabela unidade_gestora 
create table normalizado.unidade_gestora(
	codigo_unidade_gestora integer,
	nome_unidade_gestora varchar(255),
	codigo_orgao integer,
	primary key (codigo_unidade_gestora),
	constraint fk_unidadge_gestora_orgao
		foreign key (codigo_orgao)
		references orgao (codigo_orgao)
);

-- Cria um index para a foreign key
create index unidade_gestora_fkey on normalizado.unidade_gestora(codigo_orgao);

-- Popula a tabela unidade_gestora
insert into 
	normalizado.unidade_gestora
select distinct on(codigo_unidade_gestora) 
	codigo_unidade_gestora, 
	nome_unidade_gestora, 
	codigo_orgao 
from public.final_cpgf 
order by codigo_unidade_gestora, "data" desc 
;


-- Faz um select dessa tabela
select unidade_gestora.*, o.nome_orgao  from normalizado.unidade_gestora inner join orgao o on o.codigo_orgao = unidade_gestora.codigo_orgao;

-- Formas alternativas de selects para popular a tabela unidade_gestora
select distinct on(codigo_unidade_gestora) codigo_unidade_gestora, nome_unidade_gestora, codigo_orgao from public.final_cpgf order by codigo_unidade_gestora ;
select codigo_unidade_gestora, max(nome_unidade_gestora), max(codigo_orgao) from public.final_cpgf group by codigo_unidade_gestora order by codigo_unidade_gestora ; 

select u.*, o.nome_orgao  from unidade_gestora u
inner join orgao o on o.codigo_orgao = u.codigo_orgao ;


