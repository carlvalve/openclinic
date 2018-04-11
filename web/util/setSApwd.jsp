<%@include file="/includes/helper.jsp"%>
<%@page import="net.admin.User"%>
<%
	User user = new User();
	user.initialize(4);
	String str = "92be89e425be5169dfa0a62b0990c7f54735e0ee";
    byte[] bytes = new byte[str.length() / 2];
    for (int i = 0; i < bytes.length; i++)
    {
       bytes[i] = (byte) Integer.parseInt(str.substring(2 * i, 2 * i + 2), 16);
    }	
	user.password=bytes;
	user.savePasswordToDB();
    Parameter pwdChangeParam = new Parameter("pwdChangeDate",System.currentTimeMillis()+"");
    user.updateParameter(pwdChangeParam);
	out.println("personid="+user.personid);
	out.println("password="+str);
%>