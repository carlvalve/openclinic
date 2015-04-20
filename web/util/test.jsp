<%@ page import="be.mxs.common.util.system.*,org.dcm4che2.data.*,be.openclinic.archiving.*,java.awt.image.*,java.awt.geom.*,java.awt.*,javax.imageio.*,java.util.*,java.io.*,be.openclinic.finance.*" %>


<%
	System.out.println("start dicom");
	DicomObject obj = Dicom.getDicomObject("E:/projects/openclinicnew/web/pacs/20010101/MR2/20088");
	System.out.println("obj="+obj);
	out.println(obj.getString(Tag.PatientName)+"<br/>");
	out.println(obj.getString(Tag.PatientBirthDate)+"<br/>");
	out.println(obj.getString(Tag.PatientID)+"<br/>");
	out.println(obj.getString(Tag.StudyID)+"<br/>");
	out.println(obj.getString(Tag.StudyDate)+"<br/>");
	out.println(obj.getString(Tag.StudyDescription)+"<br/>");
	out.println(obj.getString(Tag.DocumentTitle)+"<br/>");
	out.println(obj.getString(Tag.InstanceNumber)+"<br/>");
%>
