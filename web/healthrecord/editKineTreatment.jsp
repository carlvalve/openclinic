<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sNew = checkString(request.getParameter("new"));
	String sRow = checkString(request.getParameter("row"));
	String sDate = checkString(request.getParameter("date"));
	if(sDate.length()==0){
		sDate=ScreenHelper.getDate();
	}
	String sAct1 = checkString(request.getParameter("act1"));
	String sAct2 = checkString(request.getParameter("act2"));
	String sAct3 = checkString(request.getParameter("act3"));
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
			<td class='admin'><%=getTran(request,"web","act",sWebLanguage) %></td>
			<td class='admin2'>
	            <select id="act1" class="text" name="act1">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"cnrkr.acts",sAct1,sWebLanguage,false,true) %>
	            </select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","act",sWebLanguage) %></td>
			<td class='admin2'>
	            <select id="act2" class="text" name="act2">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"cnrkr.acts",sAct1,sWebLanguage,false,true) %>
	            </select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","act",sWebLanguage) %></td>
			<td class='admin2'>
	            <select id="act3" class="text" name="act3">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"cnrkr.acts",sAct1,sWebLanguage,false,true) %>
	            </select>
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
			window.opener.addTreatment(document.getElementById('date').value,document.getElementById('act1').value,document.getElementById('act2').value,document.getElementById('act3').value,document.getElementById('comment').value);
		<%}
		  else if(sRow.length()>0){%>
			window.opener.editTreatment(<%=sRow%>,document.getElementById('date').value,document.getElementById('act1').value,document.getElementById('act2').value,document.getElementById('act3').value,document.getElementById('comment').value);
		<%}%>
		window.close();
	}
</script>
