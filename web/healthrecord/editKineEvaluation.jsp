<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sNew = checkString(request.getParameter("new"));
	String sRow = checkString(request.getParameter("row"));
	String sDate = checkString(request.getParameter("date"));
	if(sDate.length()==0){
		sDate=ScreenHelper.getDate();
	}
	String sObjectives = checkString(request.getParameter("objectives")).replaceAll("<BR/>","\n");
	String sFunctional = checkString(request.getParameter("functional")).replaceAll("<BR/>","\n");
	String sComment = checkString(request.getParameter("comment")).replaceAll("<BR/>","\n");
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","physiotherapytreatment",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDateField("date", "transactionForm", sDate, true, false, sWebLanguage, sCONTEXTPATH)%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","objectivesreached",sWebLanguage) %></td>
			<td class='admin2'>
		    	<textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" class="text" cols="40" rows="1" name="objectives" id="objectives"><%=sObjectives %></textarea>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","functionalevaluation",sWebLanguage) %></td>
			<td class='admin2'>
		    	<textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" class="text" cols="40" rows="1" name="functional" id="functional"><%=sFunctional %></textarea>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
			<td class='admin2'>
		    	<textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" class="text" cols="40" rows="1" name="comment" id="comment"><%=sComment %></textarea>
			</td>
		</tr>
		<tr>
			<td class='admin' colspan='2'>
				<center>
					<input type='button' class='button' name='savebutton' value='<%=getTranNoLink("web","save",sWebLanguage) %>' onclick='save()'/>
					<input type='button' class='button' name='cancelbutton' value='<%=getTranNoLink("web","cancel",sWebLanguage) %>' onclick='cancel()'/>
				</center>
			</td>
		</tr>
	</table>
</form>

<script>
	function cancel(){
		window.close();
	}
</script>
<script>
	function save(){
		<%if(sNew.equalsIgnoreCase("true")){%>
			window.opener.addEvaluation(document.getElementById('date').value,document.getElementById('objectives').value,document.getElementById('functional').value,document.getElementById('comment').value);
		<%}
		  else if(sRow.length()>0){%>
			window.opener.editEvaluation(<%=sRow%>,document.getElementById('date').value,document.getElementById('objectives').value,document.getElementById('functional').value,document.getElementById('comment').value);
		<%}%>
		window.close();
	}
</script>
