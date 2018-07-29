<%@page import="be.openclinic.reporting.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	response.setContentType("application/octet-stream");
	ServletOutputStream os = response.getOutputStream();
	StringBuffer sOutput = new StringBuffer();
	String sLanguage = checkString(request.getParameter("language"));
	String sBegindate = checkString(request.getParameter("begindate"));
	String sEnddate = checkString(request.getParameter("enddate"));
	String id = checkString(request.getParameter("id"));
    String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "registers.xml";
    SAXReader reader = new SAXReader(false);
    Document document = reader.read(new URL(sDoc));
    Iterator registers = document.getRootElement().elementIterator("register");
    while(registers.hasNext()){
    	Element register = (Element)registers.next();
    	if(checkString(register.attributeValue("id")).equalsIgnoreCase(id)){
    		response.setHeader("Content-Disposition", "Attachment;Filename=\""+getTran(request,"web.occup",register.attributeValue("transactiontype"),sLanguage)+"_" + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + ".csv\"");
    		Iterator columns = register.element("columns").elementIterator("column");
			while(columns.hasNext()){
				Element column = (Element)columns.next();
				sOutput.append(getTranNoLink(column.attributeValue("labelid").split(";")[0],column.attributeValue("labelid").split(";")[1],sLanguage)+";");
			}
			sOutput.append("\n");
    		//This is the register that is needed
    		String transactiontype = register.attributeValue("transactiontype");
    		//We first construct the register query
    		String sSql="select h.personid, t.* from healthrecord h, transactions t where"+
    					" h.healthrecordid=t.healthrecordid and"+
    					" t.transactiontype=? and"+
    					" t.updatetime>=? and"+
    					" t.updatetime<=? and"+
    					" t.serverid=?"+
    					" order by t.updatetime,t.transactionid";
    		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    		PreparedStatement ps = conn.prepareStatement(sSql);
    		ps.setString(1,transactiontype);
    		ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(sBegindate).getTime()));
    		ps.setDate(3,new java.sql.Date(ScreenHelper.parseDate(sEnddate).getTime()));
    		ps.setInt(4,MedwanQuery.getInstance().getConfigInt("serverId"));
    		ResultSet rs = ps.executeQuery();
    		int counter=0;
    		while(rs.next()){
    			//Each result is a row in the registry
    			//Now we will browse through the columns in order to compose the register line
    			Register reg = new Register(MedwanQuery.getInstance().getConfigInt("serverId"), rs.getInt("transactionid"),rs.getInt("personid"),sLanguage);
    			reg.setCounter(counter);
    			counter++;
    			columns = register.element("columns").elementIterator("column");
    			while(columns.hasNext()){
    				Element column = (Element)columns.next();
    				sOutput.append(reg.getValue(column.attributeValue("source"), column.attributeValue("name"), column.attributeValue("translateresult"))+";");
    			}
    			sOutput.append("\n");
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    }
    byte[] b = sOutput.toString().getBytes();
    for (int n=0;n<b.length;n++) {
        os.write(b[n]);
    }
    os.flush();
    os.close();
%>
