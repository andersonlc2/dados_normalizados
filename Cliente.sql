create sequence cliente_sequence start with 10000;


-- Popula a tabela proc_cliente com dados da tabela cartao
insert into 
	proc_cliente (
		aposentado,
		ativo,
		cep,
		cnae,
		codigo,
		codigo_localizador,
		documento,
		dt_atualizacao,
		dt_entrada,
		empresa,
		id_proc_cliente,
		id_sistema,
		nome,
		outros,
		patrimonio,
		profissao,
		renda,
		score,
		tipo_cadastro,
		validado
)
select
	false,
	true,
	'',
	'',
	sc.prefixo || '_' || np.codigo_portador as cod,
	'',
	np.cpf,
	dp.data_inicial,
	dp.data_inicial,
	nu.nome_unidade_gestora ,
	nextval('cliente_sequence') ,
	sc.id_sistema_cliente,
	np.nome_portador,
	'{' || 
	'"orgao"' || ': "' || nor.codigo_orgao || '", ' ||
	'"orgao_superior"' || ': "' || nos.codigo_orgao_superior || '"' ||
	'}',
	0,
	'',
	0,
	0,
	1,
	true
from 
	normalizado.portador np
inner join 
	sistema_cliente sc 
	on sc.id_sistema_cliente  = 1
inner join 
	(select 
		min(ca."data") as data_inicial,
		ca.codigo_portador 
	from 
		normalizado.cartao ca
	group by ca.codigo_portador) dp
		on dp.codigo_portador = np.codigo_portador 
inner join
	normalizado.unidade_gestora nu
	on nu.codigo_unidade_gestora = np.codigo_unidade_gestora 
inner join
	normalizado.orgao nor
	on nor.codigo_orgao = nu.codigo_orgao 
inner join 
	normalizado.orgao_superior nos
	on nos.codigo_orgao_superior = nor.codigo_orgao_superior
where 
	np.nome_portador <> 'Sigiloso'
order by 
	cod ;



-- Popula a tabela proc_cliente com dados da tabela servidores
insert into 
	proc_cliente (
		aposentado,
		ativo,
		cep,
		cnae,
		codigo,
		codigo_localizador,
		documento,
		dt_atualizacao,
		dt_entrada,
		empresa,
		id_proc_cliente,
		id_sistema,
		nome,
		outros,
		patrimonio,
		profissao,
		renda,
		score,
		tipo_cadastro,
		validado
)
select
	false,
	true,
	'',
	'',
	sc.prefixo || '_' || fsr.id_servidor_portal as cod,
	'',
	fsr.cpf ,
	fis.data_ingresso_orgao ,
	fis.data_ingresso_orgao ,
	'',
	nextval('cliente_sequence') ,
	sc.id_sistema_cliente,
	fsr.nome,
	'{' || 
	'"orgao"' || ': "' || fis.cod_org_lotacao || '", ' ||
	'"orgao_superior"' || ': "' || fis.cod_orgsup_lotacao || '" ' ||
	'}',
	0,
	fis.descricao_cargo  ,
	fsr.media ,
	0,
	1,
	true
from 
	(select 
		id_servidor_portal, 
		max(cpf) as cpf,
		max(nome) as nome,
		avg("total_remuneracoes_r$" + "total_remuneracoes_u$") as media
	from 
		final_servidores_remu f 
	group by 
		id_servidor_portal
	having 
		avg("total_remuneracoes_r$" + "total_remuneracoes_u$") > 0) as fsr
inner join 
	sistema_cliente sc
	on sc.id_sistema_cliente = 2
inner join 
	final_servidores fis
	on fis.id_servidor_portal = fsr.id_servidor_portal
order by 
	cod ;







-- total de dados 5795326 remu
-- total de servidores 689749
select count(*) from (
select distinct fsr.id_servidor_portal  from final_servidores_remu fsr ) as foo;
select * from final_servidores_remu fsr ;
select * from final_servidores fs2 ;
select * from proc_cliente where id_sistema = 2 order by id_proc_cliente ;

-- 566806
select id_servidor_portal, avg("total_remuneracoes_r$" + "total_remuneracoes_u$") from final_servidores_remu fsr where id_servidor_portal = '84414247' group by id_servidor_portal ;
-- GECIRLEI FRANCISCO DA SILVA ***.970.861-**
select * from final_servidores_remu fsr where id_servidor_portal = '84414247';
select * from proc_cliente pc ;



select * from proc_cliente pc where pc.nome = 'ABDON FERNANDES DE SOUZA' ;
-- SERV_83520864   223424
-- CPGF_10000       10000
select count(*) as qtd, pc.nome, pc.documento  from proc_cliente pc  group by pc.nome, pc.documento order by qtd desc  ;

select * from proc_operacao_realizada por where por.id_proc_cliente = 223424 or por.id_proc_cliente = 10000;

select * from proc_cliente pc where pc.id_sistema = 2 and profissao = null;

update proc_cliente set dt_atualizacao = '2020/01/01', dt_entrada = '2020/01/01'
where dt_atualizacao = '0001/01/01';

select * from proc_cliente pc where split_part(pc.codigo , '_', 2) = '74920858' ;
select * from proc_cliente pc where dt_atualizacao = '2020-01-01' ;

select count(*) from tmp_servidores tsr where tsr.data_ingresso_orgao = '' ;
select count(*) from final_servidores_remu fsr where fsr."total_remuneracoes_r$" + fsr."total_remuneracoes_u$" <= 0;

select * from proc_cliente pc where nome = 'LIAN RUIZ FERNANDEZ' ;

select count(*) from proc_cliente pc ;

select count(*) from (
select * from final_servidores s 
where 
	not exists (select 1 from final_servidores_remu fsr where fsr.id_servidor_portal = s.id_servidor_portal)) as foo;

select count(*) from final_servidores fs2 ; --689749
select count(distinct id_servidor_portal) from final_servidores_remu fsr ; --566806 
-- 


select count(distinct id_servidor_portal) from final_servidores_remu fsr where ("total_remuneracoes_r$" + "total_remuneracoes_u$") > 0.00 ;

-- diferença: 122943

-- Total de servidores com salário positivo.
-- 566715 
-- Total negativo ou zero
-- 666


select fsr.id_servidor_portal, fc.codigo_portador  from final_servidores_remu fsr 
	inner join normalizado.portador p 
		on p.nome_portador = fsr.nome 
	inner join normalizado.cartao fc 
		on p.codigo_portador = fc.codigo_portador 
group by fsr.id_servidor_portal, fc.codigo_portador 
having  (sum("total_remuneracoes_r$") + sum("total_remuneracoes_u$")) <= 0.00
;

-- 82916597	16429-LUCIANA JUREMA LOPES

select * from normalizado.cartao c where c.codigo_portador = 16429;
select * from tmp_servidores_remu fsr where nome = 'LUCIANA JUREMA LOPES';

---------------------------------------
select count(*) from proc_cliente pc where pc.dt_atualizacao  <= '01/01/1000';

update proc_cliente set dt_atualizacao = '2020-01-01', dt_entrada = '2020-01-01' where dt_atualizacao <= '0001-01-01';

select * from tmp_servidores fsr where fsr.data_ingresso_orgao = '';

