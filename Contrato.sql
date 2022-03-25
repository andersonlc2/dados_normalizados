create sequence contrato_sequence start with 10000;


-- Insere contratos do cartao de crédito do governo
insert into proc_contrato (
	categoria,
	codigo,
	documento_contraparte,
	dt_entrada,
	dt_vencimento,
	id_proc_cliente,
	id_proc_contrato,
	id_produto,                    
	moeda,
	nome_contraparte,
	outros,
	pais,
	produto,
	relacionado,
	relacionamento,
	status,
	valor,
	valor_entrada,
	valor_mensal
)
select 
	null,
	pc.codigo,
	null,
	pc.dt_entrada,
	null,
	pc.id_proc_cliente,
	nextval('contrato_sequence'),
	p.id_produto,
	null,
	null,
	'{}',
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null
from 
	proc_cliente pc 
inner join
	produto p 
	on p.id_produto = 1
where 
	pc.id_sistema = 1
;

-- Insere os contratos de conta salário
insert into proc_contrato (
	categoria,
	codigo,
	documento_contraparte,
	dt_entrada,
	dt_vencimento,
	id_proc_cliente,
	id_proc_contrato,
	id_produto,                    
	moeda,
	nome_contraparte,
	outros,
	pais,
	produto,
	relacionado,
	relacionamento,
	status,
	valor,
	valor_entrada,
	valor_mensal
)
select 
	null,
	pc.codigo,
	null,
	pc.dt_entrada,
	null,
	pc.id_proc_cliente,
	nextval('contrato_sequence'),
	p.id_produto,
	null,
	null,
	'{}',
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null
from 
	proc_cliente pc 
inner join
	produto p 
	on p.id_produto = 2
where 
	pc.id_sistema = 2
;


select * from proc_contrato pc  ;
