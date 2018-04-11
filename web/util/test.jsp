<%@page import="java.sql.*,java.io.*"%><%@page import="org.dcm4che2.data.*,org.dcm4che2.io.*"%><%
	File dicomFile = new File("c:/temp/test.dcm");
	DicomObject dcmObj=new BasicDicomObject();
	DicomInputStream din = null;
	try {
	    din = new DicomInputStream(dicomFile);
	    din.setHandler(new StopTagInputHandler(Tag.PixelData));
	    dcmObj=din.readDicomObject();
	}
	catch (Exception e) {
		e.printStackTrace();
	    System.out.println(e.getMessage());
	}
	finally {
	    try {
	        din.close();
	    }
	    catch (Exception ignore) {
	    }
	}
%>