<%@page import="java.io.*,org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=sJSPROTOTYPE %>

<%
	
	String sAction = checkString(request.getParameter("action"));
	String sDocumentName = "";
	String sSelectedDocument = "";
	byte[] document=null;
	
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (!isMultipart) {
		Debug.println("NOT MULTIPART");
	}
	else{
	    FileItemFactory factory = new DiskFileItemFactory();
	    ServletFileUpload upload = new ServletFileUpload(factory);
	    List items = null;
	    try {
	        items = upload.parseRequest(request);
        } catch (FileUploadException e) {
             e.printStackTrace();
        }
	    Iterator itr = items.iterator();
	    while (itr.hasNext()) {
	        FileItem item = (FileItem) itr.next();
	        if (item.isFormField()) {
	        	if(item.getFieldName().equalsIgnoreCase("action")){
	        		sAction = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("documentname")){
	        		sDocumentName = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("selectedDocument")){
	        		sSelectedDocument = item.getString();
	        	}
	        } else {
	        	try {
	        		if(item.getFieldName().equalsIgnoreCase("documentfile")){
	        			document=item.get();
	        		}
	            } catch (Exception e) {
	                 e.printStackTrace();
	            }
	      	}
		}
	 }	

	
	if(sAction.equalsIgnoreCase("save")){
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps;
		if(sSelectedDocument.length()>0){
			if(document==null || document.length==0){
				//Update name only
				ps = conn.prepareStatement("update WordDocuments set name=? where name=?");
				ps.setString(1,sDocumentName);
				ps.setString(2,sSelectedDocument);
				ps.execute();
				ps.close();
			}
			else {
				//Update name and document
				ps = conn.prepareStatement("delete from WordDocuments where name=?");
				ps.setString(1,sSelectedDocument);
				ps.execute();
				ps.close();
				ps = conn.prepareStatement("insert into WordDocuments(name,document) values(?,?)");
				ps.setString(1,sDocumentName);
				ps.setBytes(2,document);
				ps.execute();
				ps.close();
			}
		}
		else {
			System.out.println(3);
			//New document
			ps = conn.prepareStatement("insert into WordDocuments(name,document) values(?,?)");
			ps.setString(1,sDocumentName);
			ps.setBytes(2,document);
			ps.execute();
			ps.close();
		}
	}
	else if(sAction.equalsIgnoreCase("delete")){
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps = conn.prepareStatement("delete from WordDocuments where name=?");
		ps.setString(1,sDocumentName);
		ps.execute();
		ps.close();
	}
%>
<form name='transactionForm' method='post' enctype='multipart/form-data'>
	<input type='hidden' name='action' id='action' value=''/>
	<table width='100%'>
		<tr class='admin'><td colspan='4'><%=getTran("web.manage","manageworddocuments",sWebLanguage) %></td></tr>
		<tr>
			<td>
				<table width='100%'>
					<tr>
						<td class='admin' width='10%' rowspan='2' nowrap><%=getTran("web","document",sWebLanguage) %></td>
						<td class='admin2'>
							<select class='text' name='selectedDocument' id='selectedDocument' onchange='document.getElementById("documentname").value=this.value;'>
								<option value=''><%=getTran("web","new",sWebLanguage) %></option>
								<%
									Connection conn = MedwanQuery.getInstance().getAdminConnection();
									PreparedStatement ps = conn.prepareStatement("select name from WordDocuments order by name");
									ResultSet rs = ps.executeQuery();
									while(rs.next()){
										String name=rs.getString("name");
										out.println("<option value='"+name+"'>"+name+"</option>");
									}
								%>
							</select>
							<input type='button' class='button' name='savebutton' value='<%=getTran("web","save",sWebLanguage) %>' onclick='document.getElementById("action").value="save";transactionForm.submit();'/>
							<input type='button' class='button' name='deletebutton' value='<%=getTran("web","delete",sWebLanguage) %>' onclick='document.getElementById("action").value="delete";transactionForm.submit();'/>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<input type='text' class='text' name='documentname' id='documentname' size='80'/>
						</td> 
					</tr>
				</table>
			</td>
			<td class='admin2'>
				<table width='100%'>
					<tr><td><%=getTran("web","document",sWebLanguage) %>: <input class='button' type='file' name='documentfile'/></td></tr>
				</table>
			</td>
		</tr>
	</table>
</form>

