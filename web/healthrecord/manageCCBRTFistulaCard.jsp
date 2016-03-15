<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission("occup.ccbrt.vvfrecord","select",activeUser)%>
<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran("Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" colspan="3">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","athomeliveswith",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_ATHOMELIVESWITH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_ATHOMELIVESWITH" translate="false" property="value"/>"/>
            </td>
            <td class="admin"><%=getTran("ccbrt","educationofpatient",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PATIENTEDUCATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PATIENTEDUCATION" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","occupation",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OCCUPATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OCCUPATION" translate="false" property="value"/>"/>
            </td>
            <td class="admin"><%=getTran("ccbrt","educationofpartner",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_EDUCATIONPARTNER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_EDUCATIONPARTNER" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","problems",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMURINE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMURINE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","problemwithurine",sWebLanguage) %>			            
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMFAECES" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMFAECES;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","problemwithfaeces",sWebLanguage) %>			            
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMLEAKAGE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMLEAKAGE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","canurinenormallyandleakage",sWebLanguage) %>			            
            </td>
            <td class="admin"><%=getTran("ccbrt","leakagestarted",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<%=ScreenHelper.writeDateField("leakagestart", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGESTART"), true, false, sWebLanguage, sCONTEXTPATH)%>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AFTERDELIVERY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AFTERDELIVERY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","afterdelivery",sWebLanguage) %>			            
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","ageatwhichfistuladeveloped",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AGEDEVELOPED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AGEDEVELOPED" translate="false" property="value"/>"/> <%=getTran("web","years",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran("ccbrt","durationofleakage",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATION" translate="false" property="value"/>"/> <%=getTran("web","years",sWebLanguage) %> <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATIONMONTHS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATIONMONTHS" translate="false" property="value"/>"/> <%=getTran("web","months",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","parityfistuladeveloped",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
			            <td class="admin2" width="30%">
			                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PARITYDEVELOPED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PARITYDEVELOPED" translate="false" property="value"/>"/>
			            </td>
			            <td class="admin" width="30%"><%=getTran("ccbrt","dateofdelivery",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
							<%=ScreenHelper.writeDateField("dateofdelivery", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DATEOFDELIVERY"), true, false, sWebLanguage, sCONTEXTPATH)%>
			            </td>
			        </tr>
			    </table>
			</td>
            <td class="admin"><%=getTran("ccbrt","causenonobstetricfistula",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CAUSENONOBSTETRIC" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CAUSENONOBSTETRIC" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","placeofdelivery",sWebLanguage)%>&nbsp;</td>
	        <td class="admin2" width="30%">
	            <select id="placeofdelivery" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PLACEOFDELIVERY" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect("vvf.placeofdelivery",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PLACEOFDELIVERY"),sWebLanguage,false,true) %>
	            </select>
	        </td>
	        <td class="admin" width="30%"><%=getTran("ccbrt","nameofhospital",sWebLanguage)%>&nbsp;</td>
	        <td class="admin2">
	            <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_NAMEHOSPITAL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_NAMEHOSPITAL" translate="false" property="value"/>"/>
	        </td>
		</tr>
		<tr>
            <td class="admin"><%=getTran("ccbrt","deliveredby",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="deliveredby" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DELIVEREDBY" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect("vvf.deliveredby",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DELIVEREDBY"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran("ccbrt","modeofdelivery",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="modeofdelivery" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MODEOFDELIVERY" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect("vvf.modeofdelivery",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MODEOFDELIVERY"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
       	<tr class="admin">
            <td colspan="4"><%=getTran("ccbrt","historyoflabour",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","durationofcontractionhome",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CONTRACTIONHOME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CONTRACTIONHOME" translate="false" property="value"/>"/> <%=getTran("web","hours",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran("ccbrt","timetofacility",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETOFACILITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETOFACILITY" translate="false" property="value"/>"/> <%=getTran("web","hours",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","timetillbirth",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETILLBIRTH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETILLBIRTH" translate="false" property="value"/>"/> <%=getTran("web","hours",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran("ccbrt","referral",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_REFERRED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_REFERRED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","referred",sWebLanguage) %>
       			| <%=getTran("ccbrt","timreferraltodelivery",sWebLanguage)%><input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEREFERRALTODELIVERY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEREFERRALTODELIVERY" translate="false" property="value"/>"/> <%=getTran("web","hours",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","totaltimeinlabor",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEINLABOR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEINLABOR" translate="false" property="value"/>"/> <%=getTran("web","hours",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran("ccbrt","comments",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="comment" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_COMMENT" translate="false" property="value"/></textarea>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","outcomeofbaby",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
			            <td class="admin2" width="30%">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_STILLBIRTH" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_STILLBIRTH;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","stillbirth",sWebLanguage) %>
			            </td>
			            <td class="admin" width="30%"><%=getTran("ccbrt","gender",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
							<%=ScreenHelper.writeDateField("gender", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYGENDER"), true, false, sWebLanguage, sCONTEXTPATH)%>
			            </td>
			        </tr>
			    </table>
			</td>
            <td class="admin"><%=getTran("ccbrt","babyweight",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYWEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYWEIGHT" translate="false" property="value"/>"/> kg
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","intervalleakage",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan="3">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_INTERVALLEAKAGE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_INTERVALLEAKAGE" translate="false" property="value"/>"/> <%=getTran("web","days",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","catheter",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HADCATHETER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HADCATHETER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","hadcatheter",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran("ccbrt","timewithcatheter",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEWITHCATHETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEWITHCATHETER" translate="false" property="value"/>"/> <%=getTran("web","days",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","numberofchildrenallive",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan="3">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CHILDRENALIVE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CHILDRENALIVE" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","leggweaknessafterdelivery",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSLEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSLEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","left",sWebLanguage) %>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","right",sWebLanguage) %>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRESOLVED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRESOLVED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","resolved",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran("ccbrt","menstruation",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MENSTRUATIONREGULAR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MENSTRUATIONREGULAR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","regular",sWebLanguage) %>
				| <%=getTran("web","LMP",sWebLanguage)%> <%=ScreenHelper.writeDateField("lmp", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LMP"), true, false, sWebLanguage, sCONTEXTPATH)%>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","medicalhistory",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan="3">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="history" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MEDICALHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MEDICALHISTORY" translate="false" property="value"/></textarea>
            </td>
        </tr>
       	<tr class="admin">
            <td colspan="4"><%=getTran("ccbrt","relevantexamination",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran("ccbrt","height",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
			            <td class="admin2" width="30%">
			                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HEIGHT" translate="false" property="value"/>"/> cm
			            </td>
			            <td class="admin" width="30%"><%=getTran("ccbrt","weight",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_WEIGHT" translate="false" property="value"/>"/> kg
			            </td>
			        </tr>
			    </table>
			</td>
            <td class="admin"><%=getTran("ccbrt","bloodpressure",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPSYS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPSYS" translate="false" property="value"/>"/> / <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPDIA" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPDIA" translate="false" property="value"/>"/> mmHg
            </td>
        </tr>
		<tr>
            <td class="admin"><%=getTran("ccbrt","generalcondition",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="generalcondition" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_GENERALCONDITION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect("vvf.generalcondition",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_GENERALCONDITION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran("ccbrt","fistulaclassification",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CLASSIFICATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CLASSIFICATION" translate="false" property="value"/>"/>
           	</td>
        </tr>
        <!- DRAWING ITEM-->
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran("web","diagram",sWebLanguage) %></td>
        	<td class='admin2' colspan='4'>
				<%=ScreenHelper.createDrawingDiv(request, "canvasDiv", "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING", transaction,"/_img/vvf_diagram.png") %>
        	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran("ccbrt","dyetest",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DYETEST" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DYETEST" translate="false" property="value"/>"/>
           	</td>
            <td class="admin"><%=getTran("ccbrt","concurrentlesions",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_RVF" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_RVF;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran("web","RVF",sWebLanguage) %>
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran("ccbrt","peronealright",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALRIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALRIGHT" translate="false" property="value"/>"/> / 5
           	</td>
            <td class="admin"><%=getTran("ccbrt","peronealleft",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALLEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALLEFT" translate="false" property="value"/>"/> / 5
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran("ccbrt","vaginalstenosis",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="vaginalstenosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VAGINALSTENOSIS" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect("vvf.vaginalstenosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VAGINALSTENOSIS"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran("ccbrt","vulvalexcoriation",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="vulvalexcoriation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VULVALEXCORIATION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect("vvf.vulvalexcoriation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VULVALEXCORIATION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran("ccbrt","primarydiagnosis",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="primarydiagnosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PRIMARYDIAGNOSIS" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect("vvf.primarydiagnosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PRIMARYDIAGNOSIS"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran("ccbrt","plan",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="plan" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PLAN" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PLAN" translate="false" property="value"/></textarea>
           	</td>
        </tr>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">&nbsp;</td>
            <td class="admin2" colspan="3">
				<%-- BUTTONS --%>
			    <%
			      	if (activeUser.getAccessRight("occup.ccbrt.vvfrecord.add") || activeUser.getAccessRight("occup.ccbrt.vvfrecord.edit")){
			    %>
			    	<INPUT class="button" type="button" name="saveButton" value="<%=getTranNoLink("Web.Occup","medwan.common.record",sWebLanguage)%>" onclick="doSubmit();"/>
			    <%
			      	}
			    %>
                <INPUT class="button" type="button" value="<%=getTranNoLink("Web","back",sWebLanguage)%>" onclick="if(checkSaveButton()){window.location.href='<c:url value="/main.do?Page=curative/index.jsp"/>&ts=<%=getTs()%>'}">
            </td>
        </tr>
    </table>
	<%=ScreenHelper.contextFooter(request)%>
</form>
<script>
    function doSubmit(){
        transactionForm.saveButton.disabled = true;
        document.transactionForm.submit();
    }
    
</script>
