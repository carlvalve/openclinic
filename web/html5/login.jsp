<%@include file="/mobile/_common/helper.jsp"%>
<meta name="viewport" content="width=device-width, max-width=480, initial-scale=1.0">
<center>
	<iframe id='ocframe' style='display: ; padding: 0;width: 100%; height: 100%' src="<%=request.getParameter("page")==null?"loginPage.jsp?searchpersonid="+checkString(request.getParameter("searchpersonid"))+"&logoff="+checkString(request.getParameter("logoff")):request.getParameter("page")+"?searchpersonid="+checkString(request.getParameter("searchpersonid"))%>" frameborder="0">
	</iframe>
</center>
<script>
	document.getElementById('ocframe').style.maxWidth=480;
</script>