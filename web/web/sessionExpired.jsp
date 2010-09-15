<%@include file="/includes/helper.jsp" %>
<%// title
    String sTmpAPPDIR = ScreenHelper.checkString(ScreenHelper.getCookie("activeProjectDir", request)),
            sTmpAPPTITLE = ScreenHelper.checkString(ScreenHelper.getCookie("activeProjectTitle", request));
    if (sTmpAPPTITLE == null) sTmpAPPTITLE = "OpenClinic";%>
<html>
<head>
    <%=sCSSNORMAL%><%=sJSCOOKIE%><%=sJSDROPDOWNMENU%><%=sIcon%>
    <script>
        if (window.history.forward(1) != null) {
            window.history.forward(1);
        }
        function escBackSpace() {
            if (window.event && enterEvent(event, 8)) {
                window.event.keyCode = 123; // F12
            }
        }
        function goToLogin() {
            window.location.href = "<%=sCONTEXTPATH%>/<%=sTmpAPPDIR%>";
        }
    </script>
    <title><%=sWEBTITLE + " " + sTmpAPPTITLE%>
    </title>
</head>
<body class="Geenscroll login" onkeydown="escBackSpace();if(enterEvent(event,13)){goToLogin();}">
<div id="login" class="withoutfields">
    <div id="logo">
        <img src="<%=sTmpAPPDIR%>_img/logo.jpg" border="0">
    </div>
    <div id="version">
        &nbsp;
    </div>
    <div id="fields">
        <table>
            <tr>
                <td>
                    <br><br> Session expired <br>
                </td>
            </tr>
            <tr>
                <td>
                    <br> Your session expired.<br>Please relogin
                    <a href="<%=sCONTEXTPATH%>/<%=sTmpAPPDIR%>" onMouseOver="window.status='';return true;">here</a>.
                </td>
            </tr>
        </table>
    </div>
    <div id="messages" class="messagesnofields">
        GA Open Source Edition by:        <% if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("rw")) { %>
        <img src="_img/rwandaflag.jpg" height="15px" width="30px" alt="Rwanda"/>
        <a href="http://mxs.rwandamed.org" target="_new"><b>MXS Central Africa SARL</b></a>
        <BR/> PO Box 3242 - Kigali Rwanda Tel +250 07884 32 435 -
        <a href="mailto:mxs@rwandamed.org">mxs@rwandamed.org</a>
        <% } else { %>
        <img src="_img/belgiumflag.jpg" height="10px" width="20px" alt="Belgium"/>
        <a href="http://www.mxs.be" target="_new"><b>MXS SA/NV</b></a>
        <BR/> Pastoriestraat 50, 3370 Boutersem Belgium Tel: +32 16 721047 -
        <a href="mailto:mxs@rwandamed.org">info@mxs.be</a>
        <% } %>
    </div>
</div>
</body>
</html>

