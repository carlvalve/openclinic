<%@page import="java.util.Iterator,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,org.apache.http.client.methods.*,
org.apache.http.impl.client.*,org.apache.http.message.*,org.apache.http.client.entity.*"%>
<%@page import="org.dom4j.*,java.net.*"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="java.io.File,java.util.*"%>
<%@page import="be.mxs.common.util.db.MedwanQuery,java.sql.*,be.openclinic.assets.*"%>
<%
	String service="MSPLS";
	//****************************************
	//Test checkin procedure
	//****************************************
	int nGmaoServerId = MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100);
	out.println("1. Retrieving all assets for service "+service+" from server...");
	out.flush();
	String url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/getUnlockedAssetsForServiceUid.jsp";
	CloseableHttpClient client = HttpClients.createDefault();
	HttpPost httpPost = new HttpPost(url);
	List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
    params.add(new BasicNameValuePair("serviceid", service));
    httpPost.setEntity(new UrlEncodedFormEntity(params));	
    CloseableHttpResponse xml = client.execute(httpPost);
	String xmlIn=new BasicResponseHandler().handleResponse(xml);
	out.println("Done</br>2. Storing content in local database ...");
	out.flush();
	StringBuffer sb = new StringBuffer();
	sb.append(xmlIn);
	Asset.storeXml(sb);
	out.println("Done</br>3. Checking out assets on remote server ...");
	out.flush();
	url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/checkOutAssetsForServiceUid.jsp";
	client = HttpClients.createDefault();
	httpPost = new HttpPost(url);
	params = new ArrayList<org.apache.http.NameValuePair>();
    params.add(new BasicNameValuePair("serviceid",service));
    params.add(new BasicNameValuePair("serverid",nGmaoServerId+""));
    httpPost.setEntity(new UrlEncodedFormEntity(params));	
    xml = client.execute(httpPost);
    xmlIn=new BasicResponseHandler().handleResponse(xml);
    if(xmlIn.contains("<OK>")){
		out.println("Done<br/>4. Checking-out assets on local server #"+nGmaoServerId+"...");
		out.flush();
		Asset.checkOutAssetsForService(service,nGmaoServerId);
		out.println("Done<br/>");
		out.flush();
	}
	else {
		out.println("ERROR!<br/>NOT Checking-out records on local server #"+nGmaoServerId+"...");
		out.flush();
	}
%>