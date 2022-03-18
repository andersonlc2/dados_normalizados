-- Cria a tabela orgao_superior 
create table normalizado.orgao_superior(
	codigo_orgao_superior integer,
	nome_orgao_superior varchar(255),
	primary key (codigo_orgao_superior)
);

-- Popula a tabela criada
insert into 
	normalizado.orgao_superior 
select distinct 
	codigo_orgao_superior , nome_orgao_superior  
from 
	public.final_cpgf fc 
order by 
	codigo_orgao_superior
;

-- Faz um select dessa tabela
select * from normalizado.orgao_superior os ;

