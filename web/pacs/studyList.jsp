<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@ page import="be.mxs.common.util.db.*" %>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran(request,"web", "date", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "studyid", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "modality", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "preview", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "description", sWebLanguage) %></td>
	</tr>
<%
	try{
		//Find the list of all TRANSACTION_TYPE_PACS transactions for this patient
		MedwanQuery.getInstance().setObjectCache(new ObjectCache());
		Vector pacstran = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
		SortedMap pacstransorted=new TreeMap(Collections.reverseOrder());
		for (int n=0;n<pacstran.size();n++){
			TransactionVO tran = (TransactionVO)pacstran.elementAt(n);
			if(tran!=null){
				String seriesid="00000000000"+checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID"));
				pacstransorted.put(new SimpleDateFormat("yyyyMMdd").format(tran.getUpdateDateTime())+"."+checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID"))+
						"."+seriesid.substring(seriesid.length()-11), tran);
			}
		}

		Iterator ipacs = pacstransorted.keySet().iterator();
		while(ipacs.hasNext()){
			String key = (String)ipacs.next();
			TransactionVO tran =(TransactionVO)pacstransorted.get(key);
			%>
				<tr>
					<td class="admin" nowrap>
						<input class='text' type='checkbox' id='cb.<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>_<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>'/>
						<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE") %>&nbsp;
					</td>
					<td class="admin2"><a href='javascript: view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID") %></a><br/>
						<%=getTran(request,"web", "seriesid", sWebLanguage) %>: <%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>
					</td>
					<td class="admin2"><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY") %></td>
					<td class="admin2"> <center><img onclick='view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>")' style='max-width: 60px; max-height:60px;' src='<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>'/></center></td>
					<td class="admin2"><a href='javascript: view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION") %></a></td>
				</tr>
			<%
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
</table>
<IFRAME style="display:none" name="hidden-form"></IFRAME>

<%	if(MedwanQuery.getInstance().getConfigInt("enableRemoteWeasis", 1)==1){ %>
		<input type='button' class='button' name='viewselected' value='<%=getTranNoLink("web","viewselected",sWebLanguage) %>' onclick='viewselected()'/>
<%
	}
	if(MedwanQuery.getInstance().getConfigInt("enableLocalWeasis", 0)==1){
%>
		<input type='button' class='button' name='viewselectedlocal' value='<%=getTranNoLink("web","viewselectedlocal",sWebLanguage) %>' onclick='viewselectedlocal()'/>
<%
	}
%>

<script>

function viewselected(){
	var studies='';
	var series='';
	var elements=document.getElementsByTagName("*");
	for(n=0;n<elements.length;n++){
		if(elements[n].id && elements[n].id.startsWith("cb.") && elements[n].checked){
			if(studies.length>0){
				studies+="_";
				series+="_";
			}
			studies+=elements[n].id.split('_')[0].substring(3);
			series+=elements[n].id.split('_')[1];
		}
	}
	if(studies.length>0){
	    var url = "<c:url value='/pacs/viewStudy.jsp'/>?studyuid="+studies+"&seriesid="+series;
	    window.open(url,"hidden-form");
	    //window.setTimeout("window.close();","2000");
	}
}

function viewselectedlocal(){
	var studies='';
	var series='';
	var elements=document.getElementsByTagName("*");
	for(n=0;n<elements.length;n++){
		if(elements[n].id && elements[n].id.startsWith("cb.") && elements[n].checked){
			if(studies.length>0){
				studies+="_";
				series+="_";
			}
			studies+=elements[n].id.split('_')[0].substring(3);
			series+=elements[n].id.split('_')[1];
		}
	}
	if(studies.length>0){
	    var url = "<c:url value='/pacs/viewStudyLocal.jsp'/>?studyuid="+studies+"&seriesid="+series;
	    window.open(url,"hidden-form");
	    //window.setTimeout("window.close();","2000");
	}
}

function view(studyuid,seriesid){
	<%
		if(MedwanQuery.getInstance().getConfigInt("enableRemoteWeasis", 1)==1){
	%>
    	var url = "<c:url value='/pacs/viewStudy.jsp'/>?studyuid="+studyuid+"&seriesid="+seriesid;
    <%
		}
		else{
    %>
		var url = "<c:url value='/pacs/viewStudyLocal.jsp'/>?studyuid="+studyuid+"&seriesid="+seriesid;
    <%
		}
    %>
    window.open(url,"hidden-form");
    //window.setTimeout("window.close();","2000");
}

</script>