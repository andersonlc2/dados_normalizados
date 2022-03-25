create sequence op_disp_deb_sequence start with 100;
create sequence op_disp_cre_sequence start with 200;

-- Insere os produtos disponivel dos cartoes de credito do governo
insert into operacao_disponivel (
	especie,
	id_operacao_disponivel,
	id_produto,
	nome,
	prefixo,
	tipo_operacao
)
values 
	(false, nextval('op_disp_deb_sequence'), 1, 'COMP A/V-SOL DISP C/CLI-R$ ANT VENC', 'CAVS', 2 ),
	(false, nextval('op_disp_deb_sequence'), 1, 'COMPRA A/V - INT$ - APRES', 'CINT', 2 ),
	(false, nextval('op_disp_deb_sequence'), 1, 'COMPRA A/V - R$ - APRES', 'CNAC', 2 ),
	(false, nextval('op_disp_deb_sequence'), 1, 'CPP LOJISTA TRF P/FATURA - real', 'CPPL', 2 ),
	(true, nextval('op_disp_deb_sequence'), 1, 'SAQUE MANUAL-CARTOES BB NA AGENCIA', 'SMCA', 2 ),
	(true, nextval('op_disp_deb_sequence'), 1, 'SAQUE BB B24HORAS-SOL C/CLIENTE', 'SBBH', 2 ),
	(true, nextval('op_disp_deb_sequence'), 1, 'SAQUE - INT$ - APRES', 'SAIP', 2 ),
	(true, nextval('op_disp_deb_sequence'), 1, 'SAQUE CASH/ATM BB', 'SATB', 2 ),
	(false, nextval('op_disp_cre_sequence'), 2, 'RECEBIMENTO SALARIO', 'RECS', 1 )
;

select * from operacao_disponivel od ;

