#Include "TOTVS.CH" 
#Include "RWMAKE.CH"
#include 'parmtype.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#include "apwizard.ch"
#include "TOPCONN.ch"
#Include "Protheus.CH"
#include 'tcbrowse.ch'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 04/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function PROCSTR()

   Processa({|| TRFMASS()}, "Aguarde, processando...")
    
Return 


/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function TRFMASS()
    Local aRet  := {}
    Local aParamBox := {}
    Local aAuto := {}
    Local aLinha := {}
    Local cLinha := {}
    Local nLinha := 0
    Local cCodProd := ""
    Local cDescProd := ""
    Local cArmaOri := ""
    Local aCabec := {}
    Local nOpcAuto:= 0
    Local cFilClone :=""
    Local aLinha := {}
    Local aIndi := {}
    Local aSemSaldo := {}
    Local aEspel := {} 
    Local cDocumen:= ""
    Local nSaldo := 0
    Local lContinua := .T.
    Local cLog := ""
    Local oDlg
    PRIVATE lMsErroAuto := .F.
    Private lMsHelpAuto   := .F.
    Private lAutoErrNoFile:= .T.
    Private oBrowse




    cFilClone := cFilAnt 
    aAdd(aParamBox,{6,"Buscar arquivo",Space(50),"","","",50,.F.,"Arquivos .CSV |*.CSV"}) // Pergunta que puxa 
    if ParamBox(aParamBox,"Importar arquivo de transferência...",@aRet) // Mostrando a Tela de importação // o aRet é a variavel que fica o caminho
        FT_FUse(aRet[1])
				FT_FGotop()
				cLinha := FT_FReadLn()// Função para Ler a linha
				aCabec := StrTokArr(cLinha, ";") // Função que vai montrar o cabeçalho 
                FT_FSkip()
                i:=0
                DbSelectArea("SB1")
                SB1->(DbSetOrder(1))
                cDocumen := GetSxeNum("SD3","D3_DOC")
                aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho
                DbSelectArea("SB2")
                SB2->(DbSetOrder(1))
                nLinha:=1
                While !FT_FEOF()    
                    cLinha := Alltrim(FT_FReadLn())
					aIndi := StrTokArr(cLinha, ";")
                    nLinha++
                    
                    cCodProd :=  PadR(alltrim(aIndi[aScan(aCabec, {|x| x == "B1_COD"})]),TamSX3("B1_COD")[1],'') // Garantir que vai pegar os campos corretos, mesmo o usuário trocando as ordens
                   // cDescProd := Padl(aIndi[aScan(aCabec, {|x| x == "B1_DESC"})],TamSX3("B1_DESC")[1],'') 
                    cArmaOri := Padl(aIndi[aScan(aCabec, {|x| x == "B2_LOCAL"})],TamSX3("B2_LOCAL")[1],'0') 
                    cArmaDes :=  Padl(aIndi[aScan(aCabec, {|x| x == "DESTINO"})],TamSX3("B2_LOCAL")[1],'0') 
                    nQntTran :=  val(aIndi[aScan(aCabec, {|x| x == "B2_QATU"})]) 
                    cFilAnt := Padl(aIndi[aScan(aCabec, {|x| x == "B2_FILIAL"})],TamSX3("B2_FILIAL")[1],'0') 

                    
                    IF SB1->(DBSeek(xFilial("SB1")+cCodProd))
                        SB2->(DBSeek(xFilial("SB2")+cCodProd+cArmaOri))
                            If len(aEspel)==0
                                AAdd(aEspel,{cFilAnt+cCodProd+cArmaOri,nQntTran})
                                nNumer := nQntTran
                            else 
                                nPos := AScan(aEspel,{|x| x[1] == cFilAnt+cCodProd+cArmaOri})
                                if nPos>0
                                    aEspel[nPos,2] +=nQntTran
                                    nNumer := aEspel[nPos,2]
                                else
                                    AAdd(aEspel,{cFilAnt+cCodProd+cArmaOri,nQntTran})
                                    nNumer := nQntTran
                                endif
                            ENDIF
                            nSaldo := SaldoSB2()
                        IF SaldoSB2()>=nNumer
                            i++
                            // Origem
                            aLinha := {}
                            aadd(aLinha,{"ITEM",Padl(cvaltochar(i),3,"0"),Nil})
                            aadd(aLinha,{"D3_COD",SB1->B1_COD, Nil}) //Cod Produto origem
                            aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
                            aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
                            aadd(aLinha,{"D3_LOCAL", cArmaOri, Nil}) //armazem origem
                            aadd(aLinha,{"D3_LOCALIZ","",Nil}) // Coloco o que aqui???
                            
                            // Destino
                            DBSeek(xFilial("SB1")+cCodProd)
                            aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
                            aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
                            aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
                            aadd(aLinha,{"D3_LOCAL", cArmaDes, Nil}) //armazem destino
                            aadd(aLinha,{"D3_LOCALIZ", "",Nil}) //Colocar o que aqui? 

                            aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
                            aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
                            aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
                            aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
                            aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
                            aadd(aLinha,{"D3_QUANT", nQntTran, Nil}) //Quantidade
                            aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
                            aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
                            aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
                            
                            aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
                            aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
                            aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
                            aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
                            
                            aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
                            aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
                            
                            aAdd(aAuto,aLinha)
                         else 
                            aAdd(aSemSaldo,{nLinha,cFilAnt,cCodProd,cArmaOri,nQntTran,nSaldo,nNumer}) 
                         ENDIF   
                    ENDIF
                    FT_FSkip()
                ENDDO    
                SB1->(DBCloseArea())
                SB2->(DBCloseArea())
                nOpcAuto := 3 // Inclusao
                If len(aSemSaldo)>0
                    DEFINE DIALOG oDlg TITLE "Produtos sem saldo" FROM 180,180 TO 600,600 PIXEL
                    @ 01,01 BROWSE oBrowse SIZE 220,156 ;
                        ON DBLCLICK MsgInfo('') ;
                        OF oDlg PIXEL
                    oBrowse:SetArray(aSemSaldo)
                    
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 1 HEADER 'Linha da Planilha' SIZE 70
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 2 HEADER 'Filial' SIZE 70
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 3 HEADER 'Produto' SIZE 70
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 4 HEADER 'Amazem de origem' SIZE 70 
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 5 HEADER 'Quantidade Pedida' SIZE 70 
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 6 HEADER 'Quantidade atual' SIZE 70 
                    ADD COLUMN TO oBrowse ARRAY ELEMENT 7 HEADER 'Total Solicitado em Planilha' SIZE 70 

                    @ 170,90 BUTTON oBtn1 PROMPT "Continuar" SIZE 40,15 ; 
                    ACTION (lOk := .T. , oDlg:End()) OF oDlg PIXEL 
                    
                    ACTIVATE DIALOG oDlg CENTERED
                    MsgAlert("Remova ou altere as transferencias sem saldo","Processamento abortado")
                else    
                    MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
                    if lMsErroAuto 
                        aLog := GetAutoGRLog()
                        For nZ:= 1 to len(aLog)
                            cLog += aLog[nZ]+chr(13)+chr(10)
                        Next

                        MsgInfo(cLog,"Erro")
                            lContinua := .F.
                    else
                        MsgInfo("O Número do Documento é: "+cDocumen,"Relatório")
                        MsgInfo("Finalizado","Processo encerrado")
                        lContinua := .T.
                EndIf
                ENDIF    
                
                cFilAnt := cFilClone
    ENDIF
Return 
