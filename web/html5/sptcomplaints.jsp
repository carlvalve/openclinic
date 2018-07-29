<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	boolean checkArguments(Element element, Hashtable signs){
		int nPositive=0;
		Iterator arguments = element.elementIterator("arguments");
		if(arguments.hasNext()){
			while(arguments.hasNext()){
				Element eArguments = (Element)arguments.next();
				boolean bCheck = checkArguments(eArguments,signs);
				if(bCheck){
					nPositive++;
					if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
						if(nPositive>=Integer.parseInt(element.attributeValue("select"))){
							return true;
						}
					}
				}
				else {
					if(!element.getName().equalsIgnoreCase("arguments") || element.attributeValue("select").equalsIgnoreCase("all")){
						return false;
					}
				}
			}
			if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
				return false;
			}
		}
		arguments = element.elementIterator("argument");
		while(arguments.hasNext()){
			Element eArgument = (Element)arguments.next();
			boolean bCheck=false;
			if(eArgument.attributeValue("type").equalsIgnoreCase("ikirezi")){
				Hashtable hSigns = (Hashtable)signs.get("ikirezi");
				if(hSigns!=null){
					Integer iArgument = (Integer)(hSigns.get(Integer.parseInt(eArgument.attributeValue("id"))));
					bCheck = iArgument!=null && ((eArgument.attributeValue("value").equalsIgnoreCase("yes") && iArgument==1) || (eArgument.attributeValue("value").equalsIgnoreCase("no") && iArgument!=1));
				}
			}
			else if(eArgument.attributeValue("type").equalsIgnoreCase("spt")){
				Hashtable hSigns = (Hashtable)signs.get("spt");
				if(hSigns!=null){
					String sArgument = (String)(hSigns.get(eArgument.attributeValue("id")));
					bCheck = sArgument!=null && sArgument.equalsIgnoreCase(eArgument.attributeValue("value"));
				}
			}
			else if(eArgument.attributeValue("type").equalsIgnoreCase("icpc2")){
				Hashtable hSigns = (Hashtable)signs.get("icpc2");
				if(hSigns!=null){
					String[] codes = eArgument.attributeValue("id").split(",");
					for(int n=0;n<codes.length;n++){
						bCheck = hSigns.get(codes[n])!=null;
						if(bCheck){
							break;
						}
					}
				}
			}
			else if(eArgument.attributeValue("type").equalsIgnoreCase("icd10")){
				Hashtable hSigns = (Hashtable)signs.get("icd10");
				if(hSigns!=null){
					String[] codes = eArgument.attributeValue("id").split(",");
					for(int n=0;n<codes.length;n++){
						bCheck = hSigns.get(codes[n])!=null;
						if(bCheck){
							break;
						}
					}
				}
			}
			else if(eArgument.attributeValue("type").equalsIgnoreCase("ageinmonths")){
				Hashtable hSigns = (Hashtable)signs.get("patient");
				if(hSigns!=null){
					Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
					if(ageinmonths!=null){
						if(eArgument.attributeValue("compare").equalsIgnoreCase("greaterthan")){
							bCheck = ageinmonths>Integer.parseInt(eArgument.attributeValue("value"));
						}
						else if(eArgument.attributeValue("compare").equalsIgnoreCase("lessthan")){
							bCheck = ageinmonths<Integer.parseInt(eArgument.attributeValue("value"));
						}
						else if(eArgument.attributeValue("compare").equalsIgnoreCase("notlessthan")){
							bCheck = ageinmonths>=Integer.parseInt(eArgument.attributeValue("value"));
						}
						else if(eArgument.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
							bCheck = ageinmonths<=Integer.parseInt(eArgument.attributeValue("value"));
						}
					}
				}
			}
			else if(eArgument.attributeValue("type").equalsIgnoreCase("gender")){
				Hashtable hSigns = (Hashtable)signs.get("patient");
				if(hSigns!=null){
					String gender = (String)hSigns.get("gender");
					if(gender!=null){
						bCheck = gender.equalsIgnoreCase(eArgument.attributeValue("value"));
					}
				}
			}
			if(bCheck){
				nPositive++;
				if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
					if(nPositive>=Integer.parseInt(element.attributeValue("select"))){
						return true;
					}
				}
			}
			else {
				if(!element.getName().equalsIgnoreCase("arguments") || element.attributeValue("select").equalsIgnoreCase("all")){
					return false;
				}
			}
		}		
		if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all") && nPositive<Integer.parseInt(element.attributeValue("select"))){
			return false;
		}
		return true;
	}
	
	String getLabel(Element element, String language){
		String label = null;
		Iterator labels = element.elementIterator("label");
		while(labels.hasNext()){
			Element eLabel = (Element)labels.next();
			if(checkString(eLabel.attributeValue("language")).equalsIgnoreCase(language)){
				label=eLabel.getText();
			}
		}
		if(label == null){
			if(element.element("label")!=null){
				label = element.element("label").getText();
			}
			else{
				label = "";
			}
		}
		return label;
	}
%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","spt",sWebLanguage) %></title>
<html>
	<body>
		<table width='100%'>
			<tr>
				<td style='font-size:8vw;text-align: left'></td>
				<td style='font-size:8vw;text-align: right'>
					<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
					<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
				</td>
			</tr>
		<%
		session.setAttribute(sAPPTITLE+"WebLanguage","fr");
		String gender=checkString(request.getParameter("gender"));	
		int age=240;
		try{
			age=Integer.parseInt(checkString(request.getParameter("age")));
		}
		catch(Exception e){}
			//Initialize sptconcepts
			Hashtable sptSigns = (Hashtable)session.getAttribute("sptconcepts");
			if(sptSigns==null){
				sptSigns=new Hashtable();
			}
			Hashtable signs = new Hashtable();
			signs.put("spt",sptSigns);
			//Then collect patient specific parameters
			Hashtable patientSigns = new Hashtable();
			patientSigns.put("ageinmonths",age);
			patientSigns.put("gender",gender);
			signs.put("patient",patientSigns);
			session.setAttribute("sptpatient",patientSigns);
		
			if(checkString(request.getParameter("sptaction")).equalsIgnoreCase("reset")){
				sptSigns=new Hashtable();
				session.setAttribute("sptconcepts",sptSigns);
				session.setAttribute("spt",new Hashtable());
			}
			else if(checkString(request.getParameter("sptaction")).equalsIgnoreCase("spt")){
				//First clear all spt concepts
				sptSigns=new Hashtable();
				String sDoc = request.getParameter("doc");
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				Element complaints = root.element("complaints");
				if(complaints!=null){
					Iterator sections = complaints.elementIterator("section");
					while(sections.hasNext()){
						Element section = (Element)sections.next();
						Iterator concepts = section.elementIterator("concept");
						while(concepts.hasNext()){
							Element concept = (Element)concepts.next();
							sptSigns.remove(concept.attributeValue("id"));
						}
					}
				}
				//Add selected spt concepts
				Enumeration parameters = request.getParameterNames();
				while(parameters.hasMoreElements()){
					String parameterName = (String)parameters.nextElement();
					if(parameterName.startsWith("concept.") && request.getParameter(parameterName).length()>0){
						sptSigns.put(parameterName.replaceAll("concept.",""),request.getParameter(parameterName));
					}
				}
				//Store spt concepts in session
				session.setAttribute("sptconcepts", sptSigns);
				out.println("<script>window.location.href='"+sCONTEXTPATH+"/html5/spt.jsp';</script>");
				out.flush();
			}
			else if(checkString(request.getParameter("sptaction")).equalsIgnoreCase("patient")){
				//First clear all spt concepts
				sptSigns=new Hashtable();
				String sDoc = request.getParameter("doc");
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				Element complaints = root.element("complaints");
				if(complaints!=null){
					Iterator sections = complaints.elementIterator("section");
					while(sections.hasNext()){
						Element section = (Element)sections.next();
						Iterator concepts = section.elementIterator("concept");
						while(concepts.hasNext()){
							Element concept = (Element)concepts.next();
							sptSigns.remove(concept.attributeValue("id"));
						}
					}
				}
				//Add selected spt concepts
				Enumeration parameters = request.getParameterNames();
				while(parameters.hasMoreElements()){
					String parameterName = (String)parameters.nextElement();
					if(parameterName.startsWith("concept.") && request.getParameter(parameterName).length()>0){
						sptSigns.put(parameterName.replaceAll("concept.",""),request.getParameter(parameterName));
					}
				}
				//Store spt concepts in session
				session.setAttribute("sptconcepts", sptSigns);
			}
		%>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='doc' value='<%=request.getParameter("doc")%>'/>
			<input type='hidden' name='sptaction' id='sptaction'/>
			<table width='100%'>
		<%
			int cols=2;
			String sDoc = request.getParameter("doc");
			SAXReader reader = new SAXReader(false);
			Document document = reader.read(new URL(sDoc));
			Element root = document.getRootElement();
			out.println("<tr><td class='mobileadmin' style='font-size:6vw;' colspan='"+(cols*2)+"'>"+getLabel(root,sWebLanguage)+"</td></tr>");
			out.println("<tr><td class='mobileadmin' style='font-size:6vw;' colspan='"+(cols*2)+"'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/knowledge.png' onclick='document.getElementById(\"sptaction\").value=\"spt\";transactionForm.submit();'/>&nbsp;&nbsp;&nbsp;&nbsp;<img src='"+sCONTEXTPATH+"/_img/icons/mobile/delete.png' onclick='document.getElementById(\"sptaction\").value=\"reset\";transactionForm.submit();'/></td></tr>");
			out.println("<tr><td class='mobileadmin' colspan='"+(cols)+"'><select style='font-size:6vw;' name='age' onchange='document.getElementById(\"sptaction\").value=\"patient\";transactionForm.submit();'><option style='font-size:6vw;' value='1' "+(age==1?"selected":"")+"><12m</option><option style='font-size:6vw;' value='24' "+(age==24?"selected":"")+">12m-60m</option><option style='font-size:6vw;' value='120' "+(age==120?"selected":"")+">5-15y</option><option style='font-size:6vw;' value='240' "+(age==240?"selected":"")+">>15y</option></select></td>");
			out.println("<td class='mobileadmin' colspan='"+(cols)+"'><select style='font-size:6vw;' name='gender' onchange='document.getElementById(\"sptaction\").value=\"patient\";transactionForm.submit();'><option style='font-size:6vw;' value='m' "+(gender.equals("m")?"selected":"")+">M</option><option style='font-size:6vw;' value='f' "+(gender.equals("f")?"selected":"")+">F</option></select></td></tr>");
			Element complaints = root.element("complaints");
			if(complaints!=null){
				Iterator sections = complaints.elementIterator("section");
				while(sections.hasNext()){
					Element section = (Element)sections.next();
					out.println("<tr><td class='mobileadmin' style='font-size:5vw;' colspan='"+(cols*2)+"'>"+getLabel(section,sWebLanguage)+"</td></tr>");
					Iterator concepts = section.elementIterator("concept");
					int counter=0;
					while(concepts.hasNext()){
						Element concept = (Element)concepts.next();
						if(counter % cols ==0){
							out.println("<tr valign='top'>");
						}
						if(checkArguments(concept, signs)){
							out.println("<td width='1%'><input style='transform: scale(1.5);' name='concept."+concept.attributeValue("id")+"' type='checkbox' value='"+concept.attributeValue("value")+"' "+(checkString((String)sptSigns.get(concept.attributeValue("id"))).equalsIgnoreCase(concept.attributeValue("value"))?"checked":"")+"/></td><td width='"+(100/cols-1)+"%' style='font-size:5vw;'>"+getLabel(concept,sWebLanguage)+"</td>");
						}
						else{
							out.println("<td width='1%'><input style='transform: scale(1.5);' disabled type='checkbox'/></td><td width='"+(100/cols-1)+"%' style='font-size:5vw;color: lightgrey'>"+getLabel(concept,sWebLanguage)+"</td>");
						}
						if(counter % cols ==cols-1){
							out.println("</tr>");
						}
						counter++;
					}
					if(counter % cols !=0){
						out.println("<td colspan='"+(cols-(counter%cols))+"'/></tr>");
					}
				}
			}
		%>
			</table>
		</form>	
	</body>
</html>