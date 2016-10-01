<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission("occup.ecg","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
    
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRANSACTION_RESULT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRANSACTION_RESULT" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>

    <table width="100%" class="list" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" width="800">
            <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur='checkDate(this)'>
            <script>writeTranDate();</script>
            </td>
        </tr>

        <%-- NOTHING TO MENTION (checkbox) --%>
        <tr id='parenttd'>
            <td class="admin" colspan="2">
                <%=getLabel(request,"Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"ecg-c1")%>
                <input type="checkbox" id="ecg-c1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RAS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RAS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="toggleECG(this);">
            </td>
        </tr>

        <%-- HIDDEN PART -----------------------------------------------------------------------------%>
        <tr>
            <td colspan="2" width="100%">
                <table width="100%" border="0" cellspacing="1" cellpadding="0" id="ecg-details">
                    <%-- NORMAL - ANORMAL --%>
                    <tr>
                        <td rowspan="13" width="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"Web.Occup","medwan.common.result",sWebLanguage)%>&nbsp;</td>
                        <td class='admin2' colspan="4">
                            <input type="radio" onDblClick="uncheckRadio(this);" id="r1" <%=setRightClick("ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL")%>
                             name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL" property="itemId"/>]>.value"
                             <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL;value=medwan.common.true" property="value" outputString="checked"/>
                             value="medwan.common.true"
                            ><%=getLabel(request,"Web.Occup","medwan.common.normal",sWebLanguage,"r1")%>

                            <input type="radio" onDblClick="uncheckRadio(this);" id="r2" <%=setRightClick("ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL")%>
                             name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL" property="itemId"/>]>.value"
                             <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL;value=medwan.common.false" property="value" outputString="checked"/>
                             value="medwan.common.false"
                            ><%=getLabel(request,"Web.Occup","medwan.common.anormal",sWebLanguage,"r2")%>
                        </td>
                    </tr>

                    <%-- CHECKBOXES --%>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_ISCHEMIE")%> type="checkbox" id="ecg-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_ISCHEMIE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_ISCHEMIE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.ischemia",sWebLanguage,"ecg-c2")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_OLD_STROKE")%> type="checkbox" id="ecg-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_OLD_STROKE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_OLD_STROKE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.old_stroke",sWebLanguage,"ecg-c3")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_RECENT_STROKE")%> type="checkbox" id="ecg-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RECENT_STROKE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RECENT_STROKE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.recent_stroke",sWebLanguage,"ecg-c4")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_PRINZMETAL")%> type="checkbox" id="ecg-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PRINZMETAL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PRINZMETAL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.prinzmetal",sWebLanguage,"ecg-c5")%></td>
                    </tr>
                    <tr>
                        <td class="admin2" colspan="4"><hr/></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_PACEMAKER")%> type="checkbox" id="ecg-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PACEMAKER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PACEMAKER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.pacemaker",sWebLanguage,"ecg-c6")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_JUNCTIONRYTHM")%> type="checkbox" id="ecg-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_JUNCTIONRYTHM" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_JUNCTIONRYTHM;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.junctionrythm",sWebLanguage,"ecg-c7")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_PAT")%> type="checkbox" id="ecg-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PAT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PAT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.pat",sWebLanguage,"ecg-c8")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_AUR_FLUTTER")%> type="checkbox" id="ecg-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AUR_FLUTTER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AUR_FLUTTER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.aur_flutter",sWebLanguage,"ecg-c9")%></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_AUR_EXTRASYSTOLE")%> type="checkbox" id="ecg-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AUR_EXTRASYSTOLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AUR_EXTRASYSTOLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.aur_extrasystole",sWebLanguage,"ecg-c10")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_AUR_FIBRILLATION")%> type="checkbox" id="ecg-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AUR_FIBRILLATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AUR_FIBRILLATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.aur_fibrillation",sWebLanguage,"ecg-c11")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_SINUS_ARYTHMIA")%> type="checkbox" id="ecg-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_SINUS_ARYTHMIA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_SINUS_ARYTHMIA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.sinus_arythmia",sWebLanguage,"ecg-c12")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_JUNC_EXTRASYSTOLE")%> type="checkbox" id="ecg-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_JUNC_EXTRASYSTOLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_JUNC_EXTRASYSTOLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.junc_extrasystole",sWebLanguage,"ecg-c13")%></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL")%> type="checkbox" id="ecg-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_WANDERING_PACEMAKER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_WANDERING_PACEMAKER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.wandering_pacemaker",sWebLanguage,"ecg-c14")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL")%> type="checkbox" id="ecg-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PJT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_PJT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.pjt",sWebLanguage,"ecg-c15")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL")%> type="checkbox" id="ecg-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_1" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_1;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.avblock_1",sWebLanguage,"ecg-c16")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL")%> type="checkbox" id="ecg-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_2" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_2;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.avblock_2",sWebLanguage,"ecg-c17")%></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_WENKEBACH")%> type="checkbox" id="ecg-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_WENKEBACH" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_WENKEBACH;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.wenkebach",sWebLanguage,"ecg-c18")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_WPW")%> type="checkbox" id="ecg-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_WPW" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_WPW;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.wpw",sWebLanguage,"ecg-c19")%></td>
                        <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_TOTAL")%> type="checkbox" id="ecg-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_TOTAL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_AVBLOCK_TOTAL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.avblock_total",sWebLanguage,"ecg-c20")%></td>
                    </tr>
                    <tr>
                        <td class="admin2" colspan="4"><hr/></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_RVENTR_EXTRASYSTOLE")%> type="checkbox" id="ecg-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RVENTR_EXTRASYSTOLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RVENTR_EXTRASYSTOLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.rventr_extrasystole",sWebLanguage,"ecg-c21")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_LVENTR_EXTRASYSTOLE")%> type="checkbox" id="ecg-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LVENTR_EXTRASYSTOLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LVENTR_EXTRASYSTOLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.lventr_extrasystole",sWebLanguage,"ecg-c22")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_VENTR_PAROX_EXTRASYSTOLE")%> type="checkbox" id="ecg-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_VENTR_PAROX_EXTRASYSTOLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_VENTR_PAROX_EXTRASYSTOLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.ventr_parox_extrasystole",sWebLanguage,"ecg-c23")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_VENTR_FLUTTER")%> type="checkbox" id="ecg-c24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_VENTR_FLUTTER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_VENTR_FLUTTER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.ventr_flutter",sWebLanguage,"ecg-c24")%></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_LBBB_INCOMPLETE")%> type="checkbox" id="ecg-c25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LBBB_INCOMPLETE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LBBB_INCOMPLETE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.lbbb_incomplete",sWebLanguage,"ecg-c25")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_LBBB_COMPLETE")%> type="checkbox" id="ecg-c26" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LBBB_COMPLETE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LBBB_COMPLETE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.lbbb_complete",sWebLanguage,"ecg-c26")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_RBBB_INCOMPLETE")%> type="checkbox" id="ecg-c27" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RBBB_INCOMPLETE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RBBB_INCOMPLETE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.rbbb_incomplete",sWebLanguage,"ecg-c27")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_RBBB_COMPLETE")%> type="checkbox" id="ecg-c28" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RBBB_COMPLETE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RBBB_COMPLETE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.rbbb_complete",sWebLanguage,"ecg-c28")%></td>
                    </tr>
                    <tr>
                        <td class="admin2" colspan="4"><hr/></td>
                    </tr>
                    <tr>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_HIS_REENTRY")%> type="checkbox" id="ecg-c29" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_HIS_REENTRY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_HIS_REENTRY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.his_reentry",sWebLanguage,"ecg-c29")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_LAHB")%> type="checkbox" id="ecg-c30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LAHB" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LAHB;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.lahb",sWebLanguage,"ecg-c30")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_RAHB")%> type="checkbox" id="ecg-c31" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RAHB" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RAHB;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.rahb",sWebLanguage,"ecg-c31")%></td>
                        <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_LVENTR_HYPERTROPHY")%> type="checkbox" id="ecg-c32" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LVENTR_HYPERTROPHY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_LVENTR_HYPERTROPHY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.lventr_hypertrophy",sWebLanguage,"ecg-c32")%></td>
                    </tr>
                    <tr>
                        <td class="admin2" colspan="4"><input <%=setRightClick("ITEM_TYPE_ECG_DIAGNOSIS_RVENTR_HYPERTROPHY")%> type="checkbox" id="ecg-c33" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RVENTR_HYPERTROPHY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_DIAGNOSIS_RVENTR_HYPERTROPHY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"><%=getLabel(request,"Web.Occup","be.mxs.healthrecord.ecg.diagnosis.rventr_hypertrophy",sWebLanguage,"ecg-c33")%></td>
                    </tr>

                    <%-- REMARK --%>
                    <tr>
                        <td class="admin" style="vertical-align:top;padding-top:5px;"><%=getTran(request,"Web.Occup","medwan.common.remark",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2" style="vertical-align:top;padding-top:5px;" colspan="2">
                            <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" class="text" <%=setRightClick("ITEM_TYPE_ECG_REMARK")%> rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_REMARK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_REMARK" property="value"/></textarea>
                        </td>
                        <td class="admin2" colspan="2">
                            <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>                    
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ecg",sWebLanguage)%>
    <%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- TOGGLE ECG --%>
  function toggleECG(checkBox){
    if(checkBox.checked){ 
      if(navigator.appName=="Netscape"){ // FireFox
        document.getElementById("ecg-details").style.visibility = "hidden";
      }
      else{
      	document.getElementById("ecg-details").style.display = "none";  
      }
    }
    else{
      if(navigator.appName=="Netscape"){ // FireFox
        document.getElementById("ecg-details").style.visibility = "visible";
      }
      else{
        document.getElementById("ecg-details").style.display = "block";
      }
    }
  }

  <%-- SUBMIT FORM --%>
  function submitForm(){
    if(document.getElementById('encounteruid').value==''){
      alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
      searchEncounter();
	}	
    else{
	  var result = "";
	  if(document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RAS" property="itemId"/>]>.value')[0].checked){
	    result = "medwan.common.RAS";
	  }
	  else if(document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL" property="itemId"/>]>.value')[0].checked){
	    result = "medwan.common.normal";
	  }
	  else if(document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ECG_RESULT_NORMAL_ABNORMAL" property="itemId"/>]>.value')[1].checked){
	    result = "medwan.common.anormal";
	  }
	
	  document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRANSACTION_RESULT" property="itemId"/>]>.value')[0].value=result;
	  document.getElementById("buttonsDiv").style.visibility = "hidden";
	  var temp = Form.findFirstElement(transactionForm);   // for ff compatibility
	  <%
	      SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	      out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
	  %>
    }
  }
  
  <%-- SEARCH ENCOUNTER --%>
  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID" property="itemId"/>]>.value&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if(document.getElementById('encounteruid').value==''){
	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
	searchEncounter();
  }
  
  window.setInterval('document.getElementById("ecg-c1").onclick()','200');
</script>

<%=writeJSButtons("transactionForm","saveButton")%>