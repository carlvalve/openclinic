<%@ page import="java.io.*,org.dom4j.*,org.dom4j.io.*,sun.misc.*,be.mxs.common.util.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.finance.*,net.admin.*,java.util.*,java.text.*,be.openclinic.adt.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private Vector getRxNormCodes(String sKey){
		//Clean key, only keep letters
		byte[] bytes = sKey.getBytes();
		for(int n=0;n<bytes.length;n++){
			if("abcdefghijklmnopqrstuvwxzABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(bytes[n])==-1){
				bytes[n]=32;				
			}
		}
		sKey=new String(bytes);
		Vector codes = new Vector();
		try{
			HttpClient client = new HttpClient();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormCode","http://rxnav.nlm.nih.gov/REST/rxcui");
			String[] keys = sKey.split(" ");
			for(int n=0;n<keys.length;n++){
				GetMethod method = new GetMethod(url);
				method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
				NameValuePair nvp1= new NameValuePair("name",keys[n]);
				method.setQueryString(new NameValuePair[]{nvp1});
				int statusCode = client.executeMethod(method);
				BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
				SAXReader reader=new SAXReader(false);
				org.dom4j.Document document=reader.read(br);
				Element root = document.getRootElement();
				if(root.getName().equalsIgnoreCase("rxnormdata")){
					Iterator i = root.elementIterator("idGroup");
					while(i.hasNext()){
						String code="";
						Element idgroup = (Element)i.next();
						if(idgroup.element("name")!=null){
							code+=idgroup.element("name").getText();
							if(idgroup.element("rxnormId")!=null){
								code+=";"+idgroup.element("rxnormId").getText();
								codes.add(code);
							}
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return codes;
	}
%>
<%
	String key=checkString(request.getParameter("key"));
	if(key.length()==0 && request.getParameter("submit")==null){
		key=checkString(request.getParameter("initkey"));
	}
%>
<form name="transactionForm" method="post">
	<input type='text' class='text' size='80' name='key' value='<%=key%>'/>
	<input type='submit' name='submit' value='<%=getTran("web","find",sWebLanguage) %>'/>
	
	<table width="100%">
		<tr class='admin'>
			<td><%=getTran("web","drugname",sWebLanguage) %></td>
			<td><%=getTran("web","rxnormcode",sWebLanguage) %></td>
		</tr>
	<%
		Vector codes=getRxNormCodes(key);
		for(int i=0;i<codes.size();i++){
			String code=(String)codes.elementAt(i);
			%>
			<tr>
				<td class='admin'><%=code.split(";")[0]%></td>
				<td class='admin2' valign='top'><input class='text' type='checkbox' name='chkrxnorm<%=i%>' id='<%=code.split(";")[1]%>'/><%=code.split(";")[1]%></td>
			</tr>
			
			<%	
		}
		
	%>
	</table>
	<%
		if(request.getParameter("returnField")!=null){
	%>
		<input type='button' class='button' name='transfer' value='<%=getTranNoLink("web","copydata",sWebLanguage) %>' onclick='copyData();'/>
	<%
		}
	%>
</form>

<script>
	function copyData(){
		var codes="";
		for(n=0;n<document.all.length;n++){
			if(document.all[n].name && document.all[n].name.startsWith("chkrxnorm") && document.all[n].checked){
				if(codes.length>0){
					codes=codes+";";
				}
				codes=codes+document.all[n].id;
			}
		}		
		window.opener.<%=request.getParameter("returnField")%>.value=codes;
		window.close();
	}
</script>