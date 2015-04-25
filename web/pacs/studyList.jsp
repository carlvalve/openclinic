<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran("web", "date", sWebLanguage) %></td>
		<td><%=getTran("web", "studyid", sWebLanguage) %></td>
		<td><%=getTran("web", "modality", sWebLanguage) %></td>
		<td><%=getTran("web", "seriesid", sWebLanguage) %></td>
		<td><%=getTran("web", "description", sWebLanguage) %></td>
	</tr>
<%
	//Find the list of all TRANSACTION_TYPE_PACS transactions for this patient
	Vector pacstran = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
	SortedMap pacstransorted=new TreeMap(Collections.reverseOrder());
	for (int n=0;n<pacstran.size();n++){
		TransactionVO tran = (TransactionVO)pacstran.elementAt(n);
		String seriesid="00000000000"+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID");
		pacstransorted.put(new SimpleDateFormat("yyyyMMdd").format(tran.getUpdateDateTime())+"."+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+
				"."+(seriesid).substring(seriesid.length()-11), tran);
	}
	Iterator ipacs = pacstransorted.keySet().iterator();
	while(ipacs.hasNext()){
		String key = (String)ipacs.next();
		TransactionVO tran =(TransactionVO)pacstransorted.get(key);
		%>
			<tr>
				<td class="admin"><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE") %></td>
				<td class="admin2"><a href='javascript: view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID") %></a></td>
				<td class="admin2"><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY") %></td>
				<td class="admin2"><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %></td>
				<td class="admin2"><a href='javascript: view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION") %></a></td>
			</tr>
		<%
	}
%>
</table>

<script>

function view(studyuid,seriesid){
    var url = "<c:url value='/pacs/viewStudy.jsp'/>?studyuid="+studyuid+"&seriesid="+seriesid;
    window.open(url);
    window.setTimeout("window.close();","2000");
}

</script>