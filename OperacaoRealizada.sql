create sequence ope_realizada_sequence start with 10000 ;



-- Insere operações do cartao
insert into proc_operacao_realizada (
	cep,
	codigo,
	complemento,
	documento_contraparte,
	dt_operacao,
	especie,
	hr_operacao,
	id_operacao_disponivel,
	id_proc_cliente,
	id_proc_contrato,
	id_proc_operacao_realizada,
	id_produto,
	nome_contraparte,
	outros,
	patrimonio,
	renda,
	tipo_operacao,
	valor,
	valor_esperado
)
select 
	null,
	od.prefixo || '_' || c.codigo_compra,
	null,
	c.documento_favorecido,
	c."data",
	od.especie,
	null,
	od.id_operacao_disponivel,
	pc.id_proc_cliente ,
	pc.id_proc_contrato ,
	nextval('ope_realizada_sequence'),
	pc.id_produto,	
	c.nome_favorecido,
	'{}',
	pcl.patrimonio,
	pcl.renda,	
	od.tipo_operacao,
	c.valor,
	null
from 
	normalizado.cartao c 
inner join 
	operacao_disponivel od 
	on od.nome = c.transacao
inner join 
	proc_contrato pc 
	on pc.id_proc_cliente = c.codigo_portador 
inner join 
	proc_cliente pcl 
	on pcl.id_proc_cliente = pc.id_proc_cliente 
where 
	c.nome_favorecido <> 'Sigiloso' and pcl.id_sistema = 1
;


-- Insere operações dos servidores
insert into proc_operacao_realizada (
	cep,
	codigo,
	complemento,
	documento_contraparte,
	dt_operacao,
	especie,
	hr_operacao,
	id_operacao_disponivel,
	id_proc_cliente,
	id_proc_contrato,
	id_proc_operacao_realizada,
	id_produto,
	nome_contraparte,
	outros,
	patrimonio,
	renda,
	tipo_operacao,
	valor,
	valor_esperado
)
select 
	null,
	od.prefixo || '_' || nextval('ope_realizada_sequence'),
	null,
	'',
	cast(fsr.ano || '/' || fsr.mes || '/' || 01 as date),
	od.especie,
	null,
	od.id_operacao_disponivel,
	pc.id_proc_cliente ,
	pc.id_proc_contrato ,
	nextval('ope_realizada_sequence'),
	pc.id_produto,	
	'',
	'{}',
	pcl.patrimonio,
	pcl.renda,	
	od.tipo_operacao ,
	fsr."total_remuneracoes_r$" + fsr."total_remuneracoes_u$" ,
	null
from 
	final_servidores_remu fsr
inner join 
 	proc_cliente  pcl
	on split_part(pcl.codigo, '_', 2) = fsr.id_servidor_portal 
inner join 
	proc_contrato  pc
	on pc.id_proc_cliente = pcl.id_proc_cliente 
inner join 
	operacao_disponivel od 
	on od.id_operacao_disponivel = 200
where 
	pcl.id_sistema = 2 
;




select * from proc_operacao_realizada por 
inner join 
	proc_cliente pc on pc.id_proc_cliente = por.id_proc_cliente 
where p

= '84414247';

select count(*) from final_servidores_remu tsr  ;

select count(*) from proc_cliente pc ;
