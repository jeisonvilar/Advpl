/*/{Protheus.doc} YIMPORT
	Função para importar arquivo CSV
	@type  Static Function
	@author Alan Vilar
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/ 
 Static Function YIMPORT(oMarkBrow)
	Local aRet := {}
	Local aParamBox := {}
	Local aCabec := {}
	Local cLinha := ""
	Local aLinha := {}
	Local aMedSPed := {}
	Local cQuery
	Local cQryZZR
	LOCAL cUpd := ""
	Local cNumAtual := ""
	Local cCliAtual := "" 
	Local cMedAtual := ""
	Local cFilAtual := ""
	Local cDtExAtual := SToD("")
	Local cTraAtual := ""
	Local cPrzAtual := ""
	Local cDtPrAtual := SToD("")
	Local aMedAux := {}
	Local oDlg
	Local nPosRecn := ""
	Local nPosTransp := ""
	Local nPosPrazo := ""
	Local nPosDtPre := ""
	Local nPosDtExp := ""
	Local lOk := .F.
	Local lMat := .T.
	Local aDeman := {}
	Local nDemanda :=0
	Local aPerg:={}
	Local aMedOkay := {}
	Local cNomeTran := ""
	Local cBloq := ""
	Private oBrowse

	Private aCloMed := {}
	aAdd(aParamBox,{6,"Buscar arquivo",Space(50),"","","",50,.F.,"Arquivos .CSV |*.CSV"}) // Pergunta que puxa 

	if ParamBox(aParamBox,"Importar arquivo de medição...",@aRet) // Mostrando a Tela de importação // o aRet é a variavel que fica o caminho
		//for i:=1 to Len(aRet)
			iF Empty(aRet[1])	// Se estiver vazio 
				MsgAlert("Aquivo não informado.")
			Else 
				FT_FUse(aRet[1])
				FT_FGotop()
				cLinha := FT_FReadLn()// Função para Ler a linha
				aCabec := StrTokArr(cLinha, ";") // Função que vai montrar o cabeçalho 
				aCloMed := ACLONE(aMedicao)
				aMedicao := {}
				aMedAux := {}
				FT_FSkip()
				
				While !FT_FEOF()
						//ProcRegua(!FT_FEOF())
						//IncProc("Importanto CSV")
						cLinha := Alltrim(FT_FReadLn())
						aLinha := StrTokArr(cLinha, ";")
						
						cNumAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_NUMERO"})],TamSX3("ZZ2_NUMERO")[1],'0') // Garantir que vai pegar os campos corretos, mesmo o usuário trocando as ordens
						cCliAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_CLIENT"})],TamSX3("ZZ2_CLIENT")[1],'0')
						cMedAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_MEDICA"})],TamSX3("ZZ2_MEDICA")[1],'0')
						cDtPrAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_DTPREV"})],TamSX3("ZZ2_DTPREV")[1],'0')
						cFilAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_FILIAL"})],TamSX3("ZZ2_FILIAL")[1],'0')
						cDtExAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_DTEXP"})],TamSX3("ZZ2_DTEXP")[1],'0')
						cTraAtual := PadR(aLinha[aScan(aCabec, {|x| x == "ZZ2_TRANSP"})],TamSX3("ZZ2_TRANSP")[1],'')
						cPrzAtual := Padl(aLinha[aScan(aCabec, {|x| x == "ZZ2_PRAZO"})],TamSX3("ZZ2_PRAZO")[1],'0')

						cQuery:= "SELECT ZZ2.ZZ2_FILIAL, ZZ2.R_E_C_N_O_ AS ZZ2_RECNO,														"
						cQuery+= "       ZZ2.ZZ2_MEDICA,														"
						cQuery+= "       ZZ2.ZZ2_CLIENT,														"
						cQuery+= "       ZZ2.ZZ2_LOJA,															"
						cQuery+= "       ZZ2.ZZ2_DTGER,															"
						cQuery+= "       ZZ2.ZZ2_DTMAX,															"
						cQuery+= "       ZZ2.ZZ2_STATOS,														"
						cQuery+= "       ZZ2.ZZ2_OBS,															"
						cQuery+= "       ZZ2.ZZ2_NUMERO,														"
						cQuery+= "       ZZ2.ZZ2_LOCEX,															"
						cQuery+= "       ZZ2.ZZ2_FATEXP,														"
						cQuery+= "       ZZ2.ZZ2_ETAPA,															"
						cQuery+= "       ZZ2.ZZ2_IMPRES,														"
						cQuery+= "       NULL AS OK,															"
						cQuery+= "       ZZ2.ZZ2_TRANSP,														"
						cQuery+= "       ZZ2.ZZ2_TIPO,															"
						cQuery+= "       ZZ2.ZZ2_PV01,															"
						cQuery+= "       ZZ2.ZZ2_PV01FL,														"
						cQuery+= "       ZZ2.ZZ2_PV01NF,														"
						cQuery+= "       ZZ2.ZZ2_STATUS,														"
						cQuery+= "       ZZ2.ZZ2_USERAL,														"
						cQuery+= "       ZZ2.ZZ2_NOMEAL,														"
						cQuery+= "       ZZ2.ZZ2_DTALTE,														"
						cQuery+= "       ZZ2.ZZ2_HORAAL,														"
						cQuery+= "       ZZ2.ZZ2_DTSOLI,														"
						cQuery+= "       ZZ2.ZZ2_DTCONF,														"
						cQuery+= "       ZZ2.ZZ2_DTPRET,														"
						cQuery+= "       ZZG.ZZG_ESPCTR,														"
						cQuery+= "       ZZG.ZZG_DESCRI,														"
						cQuery+= "       ZZL.ZZL_DESCR,															"
						cQuery+= "       SA1.A1_NOME,															"
						cQuery+= "       SA1.A1_EST,															"
						cQuery+= "       SA1.A1_MUN,															"
						cQuery+= "       SA1.A1_YDTBLQ,															"
						cQuery+= "       SA1.A1_YBLOQ,															"
						cQuery+= "	 ISNULL ( (																	"
						cQuery+= "	   SELECT TOP 1 E1_VENCREA FROM SE1010(NOLOCK)								"
						cQuery+= "		WHERE 																	"
						cQuery+= "		E1_YCONTRA = ZZ2_NUMERO AND E1_CLIENTE = ZZ2_CLNF01 					"
						cQuery+= "		AND E1_SALDO <> 0 				"
						cQuery+= "		AND E1_TIPO IN ('ADT','ACF','FT') AND E1_NUMBOR <>'' AND D_E_L_E_T_ = ''"
						cQuery+= "		ORDER BY E1_VENCREA														"
						cQuery+= "	   ),'') E1_VENCTOREAL														"
						cQuery+= "	  																			"
						cQuery+= "       ,ZZ2_DTEXP 															"
						cQuery+= "		 ,ZZ2_YPTPRG 															"
						cQuery+= "		 ,ZZ2_YDEMA 															"
						cQuery+= "FROM "+RetSqlName("ZZ2")+" ZZ2 (NOLOCK)										"
						cQuery+= "LEFT JOIN "+RetSqlName("ZZG")+" ZZG(NOLOCK) ON 								"
						cQuery+= "ZZG.ZZG_COD = ZZ2.ZZ2_TIPO													"
						cQuery+= "LEFT JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON 								"
						cQuery+= "SA1.A1_COD = ZZ2.ZZ2_CLIENT													"
						cQuery+= "AND SA1.A1_LOJA = ZZ2.ZZ2_LOJA												"
						cQuery+= "LEFT JOIN "+RetSqlName("ZZL")+" ZZL (NOLOCK) ON 								"
						cQuery+= "ZZL.ZZL_COD = ZZG.ZZG_ESPCTR													"
						cQuery+= "WHERE 																		"
						cQuery+= "ZZ2.D_E_L_E_T_ = ''															"
						cQuery+= "AND ZZL.D_E_L_E_T_ = ''														"
						cQuery+= "AND SA1.D_E_L_E_T_ = ''														"
						cQuery+= "AND ZZG.D_E_L_E_T_ = ''														"
						cQuery+= "AND ZZ2_FILIAL='"+cFilAtual+"' AND ZZ2_NUMERO='"+cNumAtual+"' 				"
						cQuery+= "AND ZZ2_CLIENT='"+cCliAtual+"' AND ZZ2_MEDICA='"+cMedAtual+"'					"


						If Select("T01")> 0  //Se o select for verdadeiro segue para popular o array
							T01->(DbCloseArea())
						ENDIF
							
						TcQuery cQuery New Alias T01
						IF !T01->(EoF())
							While !T01->(EoF()) // Populando o Array do Browse
								cBloq := POSICIONE("SA1",1,XFILIAL("SA1")+T01->ZZ2_CLIENT+T01->ZZ2_LOJA,"A1_YBLOQ")
								if T01->ZZ2_ETAPA>='20' .OR. (cBloq == "S" .AND. (ALLTRIM(T01->ZZ2_TIPO) $ GetMV("SA_LIBPCE"))) .OR. (ALLTRIM(T01->ZZ2_STATOS)=="CB" .OR. AllTrim(T01->ZZ2_STATOS)=="B")
									aAdd(aMedOkay,{cNumAtual,cCliAtual,cMedAtual})
									T01->(DBSkip())
								else 
									aAdd(aMedicao,{ALLTRIM(T01->ZZ2_FILIAL),;
										ALLTRIM(T01->ZZ2_MEDICA),;
										ALLTRIM(T01->ZZ2_CLIENT),;
										ALLTRIM(T01->ZZ2_LOJA),;
										ALLTRIM(T01->A1_NOME ) ,;//POSICIONE("SA1",1,XFILIAL("SA1")+T01->ZZ2_CLIENT+T01->ZZ2_LOJA ,"A1_NOME")
										STOD(ALLTRIM(T01->ZZ2_DTGER)) ,;
										STOD(ALLTRIM(T01->ZZ2_DTMAX)) ,;
										IIF(!EMPTY(T01->ZZ2_STATOS),Alltrim(T01->ZZ2_STATOS),"OK") ,; //ALLTRIM(cStatus)
										ALLTRIM(T01->ZZ2_OBS) ,;
										ALLTRIM(T01->ZZ2_NUMERO) ,;
										ALLTRIM(T01->ZZ2_LOCEX)  ,;
										"",;
										ALLTRIM(T01->ZZ2_ETAPA),;
										ALLTRIM(T01->ZZ2_IMPRES),;
										ALLTRIM(T01->ZZ2_TIPO),;//Tipo
										ALLTRIM(T01->ZZG_DESCRI),;//Descrição Tipo - POSICIONE("ZZG",1,XFILIAL("ZZG") + T01->ZZ2_TIPO, "ZZG->ZZG_DESCRI" )
										ALLTRIM(T01->ZZG_ESPCTR),;//Especie
										ALLTRIM(T01->ZZL_DESCR ),;//Descrição Especie - POSICIONE("ZZL",1,XFILIAL("ZZL") + cEspecie, "ZZL->ZZL_DESCR" )
										ALLTRIM(T01->ZZ2_TRANSP),;
										ALLTRIM(T01->A1_EST),;//posicione("SA1",1,xFilial("SA1") + T01->ZZ2_CLIENT + T01->ZZ2_LOJA,"A1_EST")
										T01->ZZ2_PV01,;
										T01->ZZ2_PV01FL,;
										T01->ZZ2_PV01NF,;
										T01->ZZ2_STATUS,;
										T01->ZZ2_USERAL ,;
										T01->ZZ2_NOMEAL ,;
										T01->ZZ2_DTALTE ,;
										T01->ZZ2_HORAAL ,;
										STOD(ALLTRIM(T01->ZZ2_DTSOLI)) ,;
										STOD(ALLTRIM(T01->ZZ2_DTCONF)) ,;
										T01->ZZ2_DTPRET ,;
										T01->A1_MUN ,;
										STOD(ALLTRIM(T01->A1_YDTBLQ)) ,;
										T01->A1_YBLOQ ,;
										STOD(ALLTRIM(T01->E1_VENCTOREAL)),;
										STOD(ALLTRIM(T01->ZZ2_DTEXP)) ,;
										T01->ZZ2_YPTPRG ,;
										IIF(!EMPTY(T01->ZZ2_YDEMA),Alltrim(T01->ZZ2_YDEMA),"") })
									aAdd(aMedAux,{T01->ZZ2_RECNO ,; //1
									STOD(ALLTRIM(cDtExAtual)) ,; //2
									cTraAtual ,;//3
									STOD(ALLTRIM(cDtPrAtual)),; //4
									Val(AllTrim(cPrzAtual))}) //5
									T01->(DBSkip())
								endif
							ENDDO
						else
							aAdd(aMedSPed,{cNumAtual,cCliAtual,cMedAtual}) // Se não achar pedido vai jogar no Array para Mostrar Posteiormente	
						ENDIF	
							
						FT_FSkip() // Depois que popular pula para próxima linha			
				ENDDO // End do While FTFEOF
				MsgInfo(aRet[1],"Arquivo Importado")
			ENDIF
		//next	
	endif 

	If len(aMedOkay)> 0
		DEFINE DIALOG oDlg TITLE "Medições em andamento ou Cliente Bloqueado" FROM 180,180 TO 600,600 PIXEL
		@ 01,01 BROWSE oBrowse SIZE 220,156 ;
			ON DBLCLICK MsgInfo('Medições em andamento') ;
			OF oDlg PIXEL
		oBrowse:SetArray(aMedOkay)
		ADD COLUMN TO oBrowse ARRAY ELEMENT 1 HEADER 'Contrato' SIZE 70
		ADD COLUMN TO oBrowse ARRAY ELEMENT 2 HEADER 'Cliente' SIZE 70
		ADD COLUMN TO oBrowse ARRAY ELEMENT 3 HEADER 'Medicao' SIZE 70 

		@ 170,90 BUTTON oBtn1 PROMPT "Continuar" SIZE 40,15 ; 
		ACTION (lOk := .T. , oDlg:End()) OF oDlg PIXEL 
		
		ACTIVATE DIALOG oDlg CENTERED
	endif
	
	// Mostrar Medições Sem pedido
	if len(aMedSPed) > 0
		DEFINE DIALOG oDlg TITLE "Medições sem Pedido" FROM 180,180 TO 600,600 PIXEL
		@ 01,01 BROWSE oBrowse SIZE 220,156 ;
			ON DBLCLICK MsgInfo('Medição sem Pedido') ;
			OF oDlg PIXEL
		oBrowse:SetArray(aMedSPed)
		ADD COLUMN TO oBrowse ARRAY ELEMENT 1 HEADER 'Contrato' SIZE 70
		ADD COLUMN TO oBrowse ARRAY ELEMENT 2 HEADER 'Cliente' SIZE 70
		ADD COLUMN TO oBrowse ARRAY ELEMENT 3 HEADER 'Medicao' SIZE 70 

		@ 170,90 BUTTON oBtn1 PROMPT "Continuar" SIZE 40,15 ; 
		ACTION (lOk := .T. , oDlg:End()) OF oDlg PIXEL 

		ACTIVATE DIALOG oDlg CENTERED
			If lOk = .F.
				aMedicao := aCloMed	
				aMedSPed := {}
				oMarkBrow:SetArray(@aMedicao)
				oMarkBrow:Refresh()
			Endif
	ENDIF

	/*
  	// Pegando posição para Futuro código
	nPosRecn	:= Ascan(aMedAux, { |x| x == "ZZ2_RECNO"})
	nPosTransp	:= Ascan(aMedAux, { |x| x == "ZZ2_TRANSP"})
	nPosDtExp	:= Ascan(aMedAux, { |x| x == "ZZ2_DTEXP"})
	nPosPrazo	:= Ascan(aMedAux, { |x| x == "ZZ2_PRAZO"})
	nPosDtPre	:= Ascan(aMedAux, { |x| x == "ZZ2_DTPREV"})  */
	if len(aMedAux)>0
		IF MsgYesNo("As medições anteriores não serão afetadas","Deseja prosseguir com a Mudança?")	
				DEFINE DIALOG oDlg TITLE "Medições que serão Alteradas" FROM 180,180 TO 600,600 PIXEL
			@ 01,01 BROWSE oBrowse SIZE 220,156 ;
				ON DBLCLICK MsgInfo('Medição') ;
				OF oDlg PIXEL
			oBrowse:SetArray(aMedicao)
			ADD COLUMN TO oBrowse ARRAY ELEMENT 1 HEADER 'Filial' SIZE 70
			ADD COLUMN TO oBrowse ARRAY ELEMENT 2 HEADER 'Medicao' SIZE 70
			ADD COLUMN TO oBrowse ARRAY ELEMENT 3 HEADER 'Cliente' SIZE 70 
			ADD COLUMN TO oBrowse ARRAY ELEMENT 10 HEADER 'Contrato' SIZE 70 

			@ 170,90 BUTTON oBtn1 PROMPT "Continuar" SIZE 40,15 ; 
			ACTION (lOk := .T. , oDlg:End()) OF oDlg PIXEL 

			ACTIVATE DIALOG oDlg CENTERED
			nDemanda := GETSX8NUM("ZZ2","ZZ2_YDEMA")
			ConfirmSx8()
			aAdd(aDeman,{1,"Demanda",nDemanda,"@",".F.",,".F.",40,.F.})
			aAdd(aDeman,{11,"Observação: ","",".T.",".T.",.F.})

			If ParamBox(aDeman ,"",@aPerg)
				cOBS := aPerg[2]
			EndIf

			Begin Transaction
				For n1:= 1 to Len(aMedAux)
					DbSelectArea("ZZ2")
					DBGoTo(aMedAux[n1][1])
					cNomeTran := POSICIONE("SA4",1,XFILIAL("SA4")+aMedAux[n1][3],"A4_NOME")
					RecLock("ZZ2", .F.)
						ZZ2->ZZ2_DTEXP := aMedAux[n1][2]  
						ZZ2->ZZ2_TRANSP := aMedAux[n1][3]
						ZZ2->ZZ2_DESTRA := cNomeTran
						ZZ2->ZZ2_PRAZO := aMedAux[n1][5]
						ZZ2->ZZ2_DTPREV := aMedAux[n1][4]
						ZZ2->ZZ2_YDEMA:= nDemanda
						ZZ2->ZZ2_OBSPCE := cOBS
						ZZ2_DTCONF := date()
						ZZ2->ZZ2_ETAPA := "20"
						ZZ2->ZZ2_STATOS := "OK"
					MsUnlock()
					ZZ2->(DBCloseArea())
					
				
					cQryZZR := "SELECT * FROM "+RetSqlName("ZZ2")+" ZZ2 (NOLOCK) WHERE R_E_C_N_O_="+cValToChar(aMedAux[n1][1])+"	"
					If Select("T06")> 0  
							T06->(DbCloseArea())
					ENDIF
							
					TcQuery cQryZZR New Alias T06

					// Montar Histórico
					dbSelectArea("ZZR")
					dbSetOrder(1)      // ZZR_FILIAL+ZZR_CONTRA+ZZR_MEDICA+ZZRETAPA
					RECLOCK("ZZR", .T.)

					ZZR_FILIAL := T06->ZZ2_FILIAL
					ZZR_CONTRA := T06->ZZ2_NUMERO
					ZZR_MEDICA := T06->ZZ2_MEDICA
					ZZR_EMISSA := POSICIONE("ZZ2",1,T06->ZZ2_FILIAL + T06->ZZ2_NUMERO + T06->ZZ2_MEDICA + T06->ZZ2_CLIENT + T06->ZZ2_LOJA,"ZZ2_DTGER")
					ZZR_CODCLI := T06->ZZ2_CLIENT
					ZZR_NOMECL := POSICIONE("SA1",1,xFilial("SA1")+T06->ZZ2_CLIENT+T06->ZZ2_LOJA,"A1_NOME")
					ZZR_CODUSE := RetCodUsr()
					ZZR_NOMUSE := UsrFullName(RetCodUsr())
					ZZR_ETAPA  := GETMV("SA_ETPMED")
					ZZR_NOMETP := "CONFIRMACAO PCE "//POSICIONE("SX5",1,XFILIAL("SX5")+"ZA"+GETMV("SA_ZZ2CONF"),"X5_DESCRI")
					ZZR_DATA   := date()
					ZZR_HORA   := time()
					ZZR_OBS    := "MEDICAO CONFIRMADA "

					MSUNLOCK()     // Destrava o registro

					dbSelectArea("SC5")
					dbSetOrder(1)      // SC5_FILIAL + SC5_NUM
					dbSeek(T06->ZZ2_PV01FL + T06->ZZ2_PV01  )     // Busca exata

					IF FOUND()    // Avalia o retorno da pesquisa realizada
						RECLOCK("SC5", .F.)

						C5_TRANSP := aMedAux[n1][3]

						MSUNLOCK()     // Destrava o registro
					ENDIF

					// PEDIDO 2
					dbSelectArea("SC5")
					dbSetOrder(1)      // SC5_FILIAL + SC5_NUM
					dbSeek(T06->ZZ2_PV02FL + T06->ZZ2_PV02  )     // Busca exata

					IF FOUND()    // Avalia o retorno da pesquisa realizada
						RECLOCK("SC5", .F.)

						C5_TRANSP := aMedAux[n1][3]

						MSUNLOCK()     // Destrava o registro
					ENDIF

					// PEDIDO 3
					dbSelectArea("SC5")
					dbSetOrder(1)      // SC5_FILIAL + SC5_NUM
					dbSeek(T06->ZZ2_PV03FL + T06->ZZ2_PV03  )     // Busca exata

					IF FOUND()    // Avalia o retorno da pesquisa realizada
						RECLOCK("SC5", .F.)

						C5_TRANSP := aMedAux[n1][3]

						MSUNLOCK()     // Destrava o registro
					ENDIF

					T06->(DbCloseArea()) 
				Next
			end Transaction	

			// Vai recarregar a tela com as medições atuais
			aMedicao := {}
			For n1:= 1 to Len(aMedAux)
				cQuery:= "SELECT ZZ2.ZZ2_FILIAL, ZZ2.R_E_C_N_O_ AS ZZ2_RECNO,														"
				cQuery+= "       ZZ2.ZZ2_MEDICA,														"
				cQuery+= "       ZZ2.ZZ2_CLIENT,														"
				cQuery+= "       ZZ2.ZZ2_LOJA,															"
				cQuery+= "       ZZ2.ZZ2_DTGER,															"
				cQuery+= "       ZZ2.ZZ2_DTMAX,															"
				cQuery+= "       ZZ2.ZZ2_STATOS,														"
				cQuery+= "       ZZ2.ZZ2_OBS,															"
				cQuery+= "       ZZ2.ZZ2_NUMERO,														"
				cQuery+= "       ZZ2.ZZ2_LOCEX,															"
				cQuery+= "       ZZ2.ZZ2_FATEXP,														"
				cQuery+= "       ZZ2.ZZ2_ETAPA,															"
				cQuery+= "       ZZ2.ZZ2_IMPRES,														"
				cQuery+= "       NULL AS OK,															"
				cQuery+= "       ZZ2.ZZ2_TRANSP,														"
				cQuery+= "       ZZ2.ZZ2_TIPO,															"
				cQuery+= "       ZZ2.ZZ2_PV01,															"
				cQuery+= "       ZZ2.ZZ2_PV01FL,														"
				cQuery+= "       ZZ2.ZZ2_PV01NF,														"
				cQuery+= "       ZZ2.ZZ2_STATUS,														"
				cQuery+= "       ZZ2.ZZ2_USERAL,														"
				cQuery+= "       ZZ2.ZZ2_NOMEAL,														"
				cQuery+= "       ZZ2.ZZ2_DTALTE,														"
				cQuery+= "       ZZ2.ZZ2_HORAAL,														"
				cQuery+= "       ZZ2.ZZ2_DTSOLI,														"
				cQuery+= "       ZZ2.ZZ2_DTCONF,														"
				cQuery+= "       ZZ2.ZZ2_DTPRET,														"
				cQuery+= "       ZZG.ZZG_ESPCTR,														"
				cQuery+= "       ZZG.ZZG_DESCRI,														"
				cQuery+= "       ZZL.ZZL_DESCR,															"
				cQuery+= "       SA1.A1_NOME,															"
				cQuery+= "       SA1.A1_EST,															"
				cQuery+= "       SA1.A1_MUN,															"
				cQuery+= "       SA1.A1_YDTBLQ,															"
				cQuery+= "       SA1.A1_YBLOQ,															"
				cQuery+= "	 ISNULL ( (																	"
				cQuery+= "	   SELECT TOP 1 E1_VENCREA FROM SE1010(NOLOCK)								"
				cQuery+= "		WHERE 																	"
				cQuery+= "		E1_YCONTRA = ZZ2_NUMERO AND E1_CLIENTE = ZZ2_CLNF01 					"
				cQuery+= "		AND E1_SALDO <> 0 				"
				cQuery+= "		AND E1_TIPO IN ('ADT','ACF','FT') AND E1_NUMBOR <>'' AND D_E_L_E_T_ = ''"
				cQuery+= "		ORDER BY E1_VENCREA														"
				cQuery+= "	   ),'') E1_VENCTOREAL														"
				cQuery+= "	  																			"
				cQuery+= "       ,ZZ2_DTEXP 															"
				cQuery+= "		 ,ZZ2_YPTPRG 															"
				cQuery+= "		 ,ZZ2_YDEMA 															"				
				cQuery+= "FROM "+RetSqlName("ZZ2")+" ZZ2 (NOLOCK)										"
				cQuery+= "LEFT JOIN "+RetSqlName("ZZG")+" ZZG(NOLOCK) ON 								"
				cQuery+= "ZZG.ZZG_COD = ZZ2.ZZ2_TIPO													"
				cQuery+= "LEFT JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON 								"
				cQuery+= "SA1.A1_COD = ZZ2.ZZ2_CLIENT													"
				cQuery+= "AND SA1.A1_LOJA = ZZ2.ZZ2_LOJA												"
				cQuery+= "LEFT JOIN "+RetSqlName("ZZL")+" ZZL (NOLOCK) ON 								"
				cQuery+= "ZZL.ZZL_COD = ZZG.ZZG_ESPCTR													"
				cQuery+= "WHERE 																		"
				cQuery+= "ZZ2.D_E_L_E_T_ = ''															"
				cQuery+= "AND ZZL.D_E_L_E_T_ = ''														"
				cQuery+= "AND SA1.D_E_L_E_T_ = ''														"
				cQuery+= "AND ZZG.D_E_L_E_T_ = ''														"
				cQuery+= "AND ZZ2.R_E_C_N_O_="+cValToChar(aMedAux[n1][1])+" 				"
				If Select("T01")> 0  //Se o select for verdadeiro segue para popular o array
					T01->(DbCloseArea())
				ENDIF
				TcQuery cQuery New Alias T01
				While !T01->(EoF()) // Populando o Array do Browse
					aAdd(aMedicao,{ALLTRIM(T01->ZZ2_FILIAL),;
						ALLTRIM(T01->ZZ2_MEDICA),;
						ALLTRIM(T01->ZZ2_CLIENT),;
						ALLTRIM(T01->ZZ2_LOJA),;
						ALLTRIM(T01->A1_NOME ) ,;//POSICIONE("SA1",1,XFILIAL("SA1")+T01->ZZ2_CLIENT+T01->ZZ2_LOJA ,"A1_NOME")
						STOD(ALLTRIM(T01->ZZ2_DTGER)) ,;
						STOD(ALLTRIM(T01->ZZ2_DTMAX)) ,;
						IIF(!EMPTY(T01->ZZ2_STATOS),Alltrim(T01->ZZ2_STATOS),ALLTRIM(cStatus)) ,; //ALLTRIM(cStatus)
						ALLTRIM(T01->ZZ2_OBS) ,;
						ALLTRIM(T01->ZZ2_NUMERO) ,;
						ALLTRIM(T01->ZZ2_LOCEX)  ,;
						"",;
						ALLTRIM(T01->ZZ2_ETAPA),;
						ALLTRIM(T01->ZZ2_IMPRES),;
						ALLTRIM(T01->ZZ2_TIPO),;//Tipo
						ALLTRIM(T01->ZZG_DESCRI),;//Descrição Tipo - POSICIONE("ZZG",1,XFILIAL("ZZG") + T01->ZZ2_TIPO, "ZZG->ZZG_DESCRI" )
						ALLTRIM(T01->ZZG_ESPCTR),;//Especie
						ALLTRIM(T01->ZZL_DESCR ),;//Descrição Especie - POSICIONE("ZZL",1,XFILIAL("ZZL") + cEspecie, "ZZL->ZZL_DESCR" )
						ALLTRIM(T01->ZZ2_TRANSP),;
						ALLTRIM(T01->A1_EST),;//posicione("SA1",1,xFilial("SA1") + T01->ZZ2_CLIENT + T01->ZZ2_LOJA,"A1_EST")
						T01->ZZ2_PV01,;
						T01->ZZ2_PV01FL,;
						T01->ZZ2_PV01NF,;
						T01->ZZ2_STATUS,;
						T01->ZZ2_USERAL ,;
						T01->ZZ2_NOMEAL ,;
						T01->ZZ2_DTALTE ,;
						T01->ZZ2_HORAAL ,;
						STOD(ALLTRIM(T01->ZZ2_DTSOLI)) ,;
						STOD(ALLTRIM(T01->ZZ2_DTCONF)) ,;
						T01->ZZ2_DTPRET ,;
						T01->A1_MUN ,;
						STOD(ALLTRIM(T01->A1_YDTBLQ)) ,;
						T01->A1_YBLOQ ,;
						STOD(ALLTRIM(T01->E1_VENCTOREAL)),;
						STOD(ALLTRIM(T01->ZZ2_DTEXP)) ,;
						T01->ZZ2_YPTPRG,;
						T01->ZZ2_YDEMA })
					T01->(DBSkip())
				ENDDO
			NEXT
			If Select("T01")> 0  //Se o select for verdadeiro segue para popular o array
				T01->(DbCloseArea())
			ENDIF
			oMarkBrow:SetArray(@aMedicao)
			oMarkBrow:Refresh()
			//oBrowse:Refresh()	
		else
			// Volta para tela de inicio 
			aMedicao := aCloMed	
			aMedSPed := {}
			oMarkBrow:SetArray(@aMedicao)
			oMarkBrow:Refresh()
			//oBrowse:Refresh()
		ENDIF
	else 	
		MsgAlert("Não existe medições a serem alteradas", "Processamento abortado")
		aMedicao := aCloMed	
		aMedSPed := {}
		oMarkBrow:SetArray(@aMedicao)
		oMarkBrow:Refresh()
	ENDIF	
Return 



