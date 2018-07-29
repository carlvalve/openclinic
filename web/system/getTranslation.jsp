<%@page import="be.mxs.common.util.system.*,be.mxs.common.util.db.*,be.mxs.common.util.io.*"%>
<%
	String sourcelanguage = request.getParameter("sourcelanguage");
	String targetlanguage = request.getParameter("targetlanguage");
	String labeltype = request.getParameter("labeltype");
	String labelid = request.getParameter("labelid");
	String sourcelabel = ScreenHelper.getTranNoLink(labeltype, labelid, sourcelanguage);
	if(sourcelabel.equalsIgnoreCase(labelid)){
		sourcelabel = ScreenHelper.getTranNoLink(labeltype, labelid, "fr");
		sourcelanguage="fr";
	}
	String translation = GoogleTranslate.translate(MedwanQuery.getInstance().getConfigString("googleTranslateKey","AIzaSyAPk18gciaKdwl3Z2rmFSog4ZwBbmfhByg"),sourcelanguage,targetlanguage,sourcelabel);
	if(sourcelabel.substring(0, 1)==sourcelabel.substring(0, 1).toUpperCase()){
		translation=translation.substring(0,1).toUpperCase()+(translation.length()<=1?"":translation.substring(1));
	}
%>
{
"translation":"<%=translation%>"
}