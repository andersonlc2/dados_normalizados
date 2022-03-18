-- Cria a tabela portador 
create table normalizado.portador(
	codigo_portador integer,
	nome_portador varchar(255),
	cpf varchar(14),
	codigo_unidade_gestora integer,
	primary key (codigo_portador),
	constraint fk_portador_unidade_gestora
		foreign key (codigo_unidade_gestora)
		references unidade_gestora (codigo_unidade_gestora)
);

-- Cria um index para as foreign key
create index portador_unidade_gestora_fkey on portador(codigo_unidade_gestora);


-- Cria um sequence para o codigo_portador OBS: NÃO USEI AQUI
drop sequence portador_sequence ;
create sequence portador_sequence 
	start with 10000;
-- Vincula a sequence ao campo codigo_portador
alter table normalizado.portador alter column codigo_portador set default nextval('portador_sequence'); 

-- Popula a tabela portador sómente com os portadores sigilosos e seus respectivos orgãos
insert into
	normalizado.portador(nome_portador, cpf, codigo_unidade_gestora)
select 
	nome_portador, 
	cpf_portador,
	u.codigo_unidade_gestora 
from 
	public.final_cpgf cp 
inner join 
	unidade_gestora u on u.codigo_unidade_gestora = cp.codigo_unidade_gestora 
where 
	documento_favorecido = '-11' 
group by 
	nome_portador, cpf_portador, u.codigo_unidade_gestora
order by nome_portador;

-- Popula a tabela portador com os portadores que não são sigilosos
insert into
	normalizado.portador(nome_portador, cpf, codigo_unidade_gestora)
select 
	distinct on(nome_portador, cpf_portador) 
	nome_portador, 
	cpf_portador, 
	u.codigo_unidade_gestora
from 
	public.final_cpgf cp 
inner join 
	unidade_gestora u on u.codigo_unidade_gestora = cp.codigo_unidade_gestora 
where 
	documento_favorecido <> '-11' 
order by 
	nome_portador, cpf_portador, "data" desc
;

-- Faz um select dessa tabela
select count(*) from portador p;

-- Formas alternativas de selects para popular a tabela portador
-- Sigilosos
select 
	distinct on(nome_portador, cpf_portador) nome_portador, cpf_portador, codigo_orgao, codigo_unidade_gestora
	from public.final_cpgf cp 
	where documento_favorecido = '-11' 
	order by nome_portador, cpf_portador, "data" desc
;

select distinct(nome_portador), cpf_portador, max(codigo_orgao), codigo_unidade_gestora from public.final_cpgf cp where documento_favorecido = '-11' group by nome_portador, cpf_portador, codigo_unidade_gestora  order by nome_portador;

-- Não sigiloses
select count(*) from (select distinct on(nome_portador, cpf_portador) nome_portador, cpf_portador, codigo_orgao, codigo_unidade_gestora from public.final_cpgf cp where documento_favorecido <> '-11' order by nome_portador) as foo ;
select count(*) from (select 
	nome_portador, 
	cpf_portador, 
	max(codigo_orgao), 
	max(codigo_unidade_gestora)
from public.final_cpgf cp 
where documento_favorecido <> '-11' 
group by nome_portador, cpf_portador
order by nome_portador) as foo;
