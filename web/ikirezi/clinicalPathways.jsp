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
	class Sheet {
		String id;
		String href;
		String text;
	}
	
	class Concept {
		String[] values;
		String text;
	}
	
	class Treatment {
		String id;
		String document;
		String text;
		Vector sheets;
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
			if(element.element("argument")==null && element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
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

	boolean isPathwayApplicable(Element pathway, Hashtable signs){
		Iterator rootNodes = pathway.elementIterator("node");
		while(rootNodes.hasNext()){
			Element rootNode = (Element)rootNodes.next();
			if(checkArguments(rootNode,signs)){
				return true;
			}
		}
		return false;
	}
	
	HashSet getMissingArguments(Element argumentsElement, Hashtable signs){
		Hashtable sptSigns = (Hashtable)signs.get("spt");
		HashSet hInformation=new HashSet();
		Iterator childArguments = argumentsElement.elementIterator("arguments");
		while(childArguments.hasNext()){
			Element childArgumentsElement = (Element)childArguments.next();
			HashSet hSubInformation = getMissingArguments(childArgumentsElement,signs);
			Iterator iSubInformation = hSubInformation.iterator();
			while(iSubInformation.hasNext()){
				hInformation.add(iSubInformation.next());
			}
		}
		Iterator childArgumentElements = argumentsElement.elementIterator("argument");
		while(childArgumentElements.hasNext()){
			Element childArgumentElement = (Element)childArgumentElements.next();
			if(childArgumentElement.attributeValue("type").equalsIgnoreCase("spt") && sptSigns!=null && sptSigns.get(childArgumentElement.attributeValue("id"))!=null){
				if((!argumentsElement.getName().equalsIgnoreCase("arguments") || argumentsElement.attributeValue("select").equalsIgnoreCase("all")) && !childArgumentElement.attributeValue("value").equalsIgnoreCase((String)sptSigns.get(childArgumentElement.attributeValue("id")))){
					return(new HashSet());
				}
			}
			else if(childArgumentElement.attributeValue("type").equalsIgnoreCase("spt") && (sptSigns==null || sptSigns.get(childArgumentElement.attributeValue("id"))==null)){
				if(checkString(childArgumentElement.attributeValue("equivalent")).length()>0){
					//Check that equivalents do not exist
					String[] equivalents=childArgumentElement.attributeValue("equivalent").split(",");
					for(int n=0;n<equivalents.length;n++){
						Hashtable tSigns = (Hashtable)signs.get(equivalents[n].split(";")[0]);
						if(tSigns.get(equivalents[n].split(";")[1])==null){
							hInformation.add(childArgumentElement.attributeValue("id"));
							break;
						}
					}
				}
				else{
					hInformation.add(childArgumentElement.attributeValue("id"));
				}
			}
		}
		return hInformation;
	}
	
	Vector getNodePath(Element node,Hashtable signs,String language){
		Vector paths=new Vector();
		getNodePath(node,"",signs,paths,language);
		return paths;
	}

	void getNodePath(Element node,String prefix, Hashtable signs,Vector paths,String language){
		if(checkArguments(node, signs)){
			if(prefix.length()>0){
				prefix+=">";
			}
			prefix+=getLabel(node, language);
			if(node.element("treatment")!=null){
				prefix+="$"+node.element("treatment").attributeValue("id");
			}
			Iterator nodes = node.elementIterator("node");
			if(nodes.hasNext()){
				while(nodes.hasNext()){
					Element childNode = (Element)nodes.next();
					getNodePath(childNode, prefix, signs, paths, language);
				}
			}
			else{
				paths.add(prefix+"|");
			}
		}
		else{
			HashSet missingArguments = getMissingArguments(node, signs);
			String sMissingArguments="";
			Iterator iArguments = missingArguments.iterator();
			while(iArguments.hasNext()){
				if(sMissingArguments.length()>0){
					sMissingArguments+=";";
				}
				sMissingArguments+=iArguments.next();
			}
			paths.add(prefix+"|"+sMissingArguments);
		}
	}
	
	String formatTitle(String title){
		String sTitle="";
		if(title.indexOf(">")>-1){
			for(int n=0;n<title.split(">").length;n++){
				if(n>0){
					sTitle+=">";
				}
				if(n<title.split(">").length-1){
					sTitle+=title.split(">")[n].split("\\$")[0];
				}
				else{
					sTitle+="<b>"+title.split(">")[n].split("\\$")[0]+"</b>";
				}
			}
		}
		else{
			sTitle="<b>"+title.split("\\$")[0]+"</b>";
		}
		return sTitle;
	}
	
	String formatTitleNoBold(String title){
		String sTitle="";
		if(title.indexOf(">")>-1){
			for(int n=0;n<title.split(">").length;n++){
				if(n>0){
					sTitle+=">";
				}
				sTitle+=title.split(">")[n].split("\\$")[0];
			}
		}
		else{
			sTitle=title.split("\\$")[0];
		}
		return sTitle;
	}
	
	boolean hasLaterNode(SortedMap hPaths,String path){
		Iterator iPaths = hPaths.keySet().iterator();
		while(iPaths.hasNext()){
			String iPath = (String)iPaths.next();
			if(iPath.startsWith(path+">")){
				return true;
			}
		}
		return false;
	}
	
%>
<form name="transactionForm" id="transactionForm" method="post">
	<table width="100%">
<%
	//Initialize sptconcepts
	Hashtable sptSigns = (Hashtable)session.getAttribute("sptconcepts");
	if(sptSigns==null || request.getParameter("resetButton")!=null){
		sptSigns=new Hashtable();
	}
	long timestamp = new java.util.Date().getTime();
	//Add selected spt concepts
	Enumeration parameters = request.getParameterNames();
	while(parameters.hasMoreElements()){
		String parameterName = (String)parameters.nextElement();
		if(parameterName.startsWith("concept.")){
			if(request.getParameter(parameterName).length()>0){
				sptSigns.put(parameterName.replaceAll("concept.",""),request.getParameter(parameterName)+";"+timestamp);
			}
		}
	}
	if(request.getParameter("undoButton")!=null){
		//Revert one step in added sptconcepts, don't touch the automatically added ones
		//First find the maximum timestamp
		long maxtimestamp = 0;
		Enumeration eSigns = sptSigns.keys();
		while(eSigns.hasMoreElements()){
			String key = (String)eSigns.nextElement();
			String value = (String)sptSigns.get(key);
			if(value.split(";").length>1){
				long ts = Long.parseLong(value.split(";")[1]);
				if(ts>maxtimestamp){
					maxtimestamp=ts;
				}
			}
		}
		//Now remove all items that have been added at maxtimestamp
		eSigns = sptSigns.keys();
		while(eSigns.hasMoreElements()){
			String key = (String)eSigns.nextElement();
			String value = (String)sptSigns.get(key);
			if(value.split(";").length>1){
				long ts = Long.parseLong(value.split(";")[1]);
				if(ts==maxtimestamp){
					sptSigns.remove(key);
				}
			}
		}		
	}
	//Store spt concepts in session
	session.setAttribute("sptconcepts", sptSigns);
	//Remove timestamps from spt concepts to work with
	Hashtable cleanedSptSigns = new Hashtable();
	Enumeration eSigns = sptSigns.keys();
	while(eSigns.hasMoreElements()){
		String key = (String)eSigns.nextElement();
		String value = (String)sptSigns.get(key);
		cleanedSptSigns.put(key,value.split(";")[0]);
	}
	Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
	if(activeEncounter!=null){
		//First collect all clinical signs for the encounter
		Hashtable signs = new Hashtable();
		Hashtable ikireziSigns = Ikirezi.getEncounterSymptoms(activeEncounter.getUid());
		signs.put("ikirezi",ikireziSigns);
		eSigns = ikireziSigns.keys();
		while(eSigns.hasMoreElements()){
			Integer key=(Integer)eSigns.nextElement();
		}
		//Then collect patient specific parameters
		Hashtable patientSigns = new Hashtable();
		patientSigns.put("ageinmonths",activePatient.getAgeInMonths());
		patientSigns.put("gender",activePatient.gender);
		signs.put("patient",patientSigns);
		if(cleanedSptSigns.get("drh.3")!=null && cleanedSptSigns.get("drhe.3")==null){
			cleanedSptSigns.put("drhe.3",sptSigns.get("drh.3"));
		}
		if(cleanedSptSigns.get("drhe.3")!=null && cleanedSptSigns.get("drh.3")==null){
			cleanedSptSigns.put("drh.3",cleanedSptSigns.get("drhe.3"));
		}
		signs.put("spt",cleanedSptSigns);
		
		//Run through all clinical pathways in order to check which ones are applicable
		String[] pathwayFiles = MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml").split(",");
		for(int n=0;n<pathwayFiles.length;n++){
			String pathwayFile = pathwayFiles[n];
			String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + pathwayFile;
			SAXReader reader = new SAXReader(false);
			Document document = reader.read(new URL(sDoc));
			Element root = document.getRootElement();
			//Load documents, concepts and treatments
			Hashtable sheets = new Hashtable();
			if(root.element("documents")!=null){
				Iterator iSheets = root.element("documents").elementIterator("document");
				while(iSheets.hasNext()){
					Element sheet = (Element)iSheets.next();
					Sheet c = new Sheet();
					c.id = checkString(sheet.attributeValue("id"));
					c.href = checkString(sheet.attributeValue("href"));
					c.text = getLabel(sheet,sWebLanguage);
					sheets.put(c.id,c);
				}
			}
			Hashtable concepts = new Hashtable();
			if(root.element("concepts")!=null){
				Iterator iConcepts = root.element("concepts").elementIterator("concept");
				while(iConcepts.hasNext()){
					Element concept = (Element)iConcepts.next();
					Concept c = new Concept();
					c.values = checkString(concept.attributeValue("values")).split(",");
					c.text = getLabel(concept,sWebLanguage);
					concepts.put(concept.attributeValue("id"),c);
				}
			}
			Hashtable treatments = new Hashtable();
			if(root.element("treatments")!=null){
				Iterator iTreatments = root.element("treatments").elementIterator("treatment");
				while(iTreatments.hasNext()){
					Element treatment = (Element)iTreatments.next();
					Treatment t = new Treatment();
					if(treatment.element("document")!=null){
						t.document = checkString(treatment.element("document").attributeValue("href"));
					}
					t.text = getLabel(treatment,sWebLanguage);
					t.id = treatment.attributeValue("id");
					treatments.put(t.id,t);
					t.sheets = new Vector();
					Iterator iSheets = treatment.elementIterator("document");
					while(iSheets.hasNext()){
						t.sheets.add(checkString(((Element)iSheets.next()).attributeValue("id")));
					}
				}
			}
			
			out.println("<tr class='admin'><td>"+getLabel(root,sWebLanguage)+"</td><td><table width='100%'><tr><td><input type='button' name='complaintButton' onclick='showComplaints(\""+sDoc+"\");' class='button' value='"+getTranNoLink("web","complaints",sWebLanguage)+"'/></td><td><input type='submit' name='submitButton' class='button' value='"+getTranNoLink("web","update",sWebLanguage)+"'/><input type='submit' name='undoButton' class='button' value='"+getTranNoLink("web","undo",sWebLanguage)+"'/><input type='submit' name='resetButton' class='button' value='"+getTranNoLink("web","reset",sWebLanguage)+"'/></td></tr></table></td></tr>");
			Iterator pathways = root.elementIterator("pathway");
			while(pathways.hasNext()){
				Element pathway = (Element)pathways.next();
				if(isPathwayApplicable(pathway,signs)){
					sptSigns.put(pathway.attributeValue("complaint"), pathway.attributeValue("value"));
					out.println("<tr class='admin'><td colspan='2'>"+getLabel(pathway,sWebLanguage)+"</td></tr>");
					Iterator childNodes = pathway.elementIterator("node");
					while(childNodes.hasNext()){
						Element childNode = (Element)childNodes.next();
						SortedMap hPaths = new TreeMap();
						Vector paths = getNodePath(childNode, signs, sWebLanguage);
						for(int i=0;i<paths.size();i++){
							String title = ((String)paths.elementAt(i)).split("\\|")[0];
							if(hPaths.get(title)==null){
								hPaths.put(title,new TreeSet());
							}
							if(((String)paths.elementAt(i)).split("\\|").length>1){
								String[] missing = ((String)paths.elementAt(i)).split("\\|")[1].split(";");
								SortedSet hMissing = (SortedSet)hPaths.get(title);
								//for(int j=0;j<missing.length;j++){
								for(int j=0;j<1;j++){
									System.out.println("title="+title+": "+missing[j]);
									hMissing.add(missing[j]);
								}
							}
						}
						boolean bHasTreatments = false;
						Iterator iPaths = hPaths.keySet().iterator();
						boolean bTitlePrinted=false;
						StringBuffer sPrintSigns = new StringBuffer();
						while(iPaths.hasNext()){
							String title = (String)iPaths.next();
							SortedSet hMissing = (SortedSet)hPaths.get(title);
							if(hMissing.size()>0){
								if(!bTitlePrinted){
									sPrintSigns.append("<tr><td width='60%'><b><font style='color: grey'>"+getTran(request,"spt","complaint",sWebLanguage)+"</font></b></td><td><b><font style='color: grey'>"+getTran(request,"web","informationneeded",sWebLanguage)+"</font></b></td></tr>");
									bTitlePrinted=true;
								}
								sPrintSigns.append("<tr><td class='admin2'>"+formatTitle(title)+"</td><td  style='border: none;' class='admin2'><table width='100%'>");
								String sMissing = "";
								Iterator iMissing = hMissing.iterator();
								while(iMissing.hasNext()){
									String sConceptId=(String)iMissing.next();
									Concept concept = (Concept)concepts.get(sConceptId);
									sMissing+="<tr><td width='50%'><b>"+concept.text+"</b></td><td><select onchange='updatePathway()' name='concept."+sConceptId+"' id='concept."+sConceptId+"' onchange='updateAll(\"concept."+sConceptId+"\",this.value)'><option/>";
									String[] values = concept.values;
									if(values!=null){
										for(int k=0;k<values.length;k++){
											sMissing+="<option value='"+concept.values[k]+"'>"+getTranNoLink("web",concept.values[k],sWebLanguage)+"</option>";
										}
									}
									sMissing+="</select></td></tr>";
									
								}
								sPrintSigns.append(sMissing+"</table></td></tr>");
							}
							if(title.split("\\$").length>1){
								bHasTreatments=true;
							}
						}
						if(bHasTreatments){
							out.println("<tr><td colspan='2' style='border: 1px solid black;'><table width='100%'><tr><td colspan='2'><b><font style='color: grey'>"+getTran(request,"web","treatments",sWebLanguage)+"</font></b></td></tr>");
							iPaths = hPaths.keySet().iterator();
							while(iPaths.hasNext()){
								String title = (String)iPaths.next();
								if(!hasLaterNode(hPaths, title)){
									String lastpart=title.split(">")[title.split(">").length-1];
									if(lastpart.split("\\$").length>1 && treatments.get(lastpart.split("\\$")[1])!=null){
										out.println("<tr><td class='admin2'>"+formatTitle(title)+"</td><td class='admin2'><b>");
										String sTreatment="";
										Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
										if(treatment!=null){
											sTreatment=treatment.text;
											if(!treatment.id.contains(".")){
												sTreatment+=" ("+treatment.id.toUpperCase()+") ";
											}
										}
										out.println("<font style='color: red'>"+sTreatment+"</font></b></td></tr>");
										if(treatment.sheets!=null && treatment.sheets.size()>0){
											out.println("<tr><td/><td><table cellpadding='3'><tr>");
											for(int q=0;q<treatment.sheets.size();q++){
												Sheet sheet = (Sheet)sheets.get(treatment.sheets.elementAt(q));
												if(sheet!=null){
													out.println("<td nowrap style='border: 1px solid black;'><font style='color: red'><a href='javascript:showSheet(\""+sheet.href+"\")'>"+checkString(sheet.text)+"</a></font></td>");
												}
											}
											out.println("</tr></table></td></tr>");
										}
									}
								}
								else{
									String lastpart=title.split(">")[title.split(">").length-1];
									if(lastpart.split("\\$").length>1){
										out.println("<tr><td class='admin2'><i><font style='color: grey;'>"+formatTitleNoBold(title)+"</font></i></td><td class='admin2'><i>");
										String sTreatment="";
										Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
										if(treatment!=null){
											sTreatment=treatment.text;
										}
										out.println("<font style='color: grey;'>"+sTreatment+" ("+getTran(request,"web","ended",sWebLanguage)+")</font></i></td></tr>");
										if(treatment.sheets!=null && treatment.sheets.size()>0){
											out.println("<tr><td/><td><table cellpadding='3'><tr>");
											for(int q=0;q<treatment.sheets.size();q++){
												Sheet sheet = (Sheet)sheets.get(treatment.sheets.elementAt(q));
												if(sheet!=null){
													out.println("<td nowrap style='border: 1px solid black;'><font style='color: grey'><a href='javascript:showSheet(\""+sheet.href+"\")'>"+checkString(sheet.text)+"</a></font></td>");
												}
											}
											out.println("</tr></table></td></tr>");
										}
									}
								}
							}
							out.println("</table></td></tr>");
						}
						out.println(sPrintSigns);
					}
				}
			}
			session.setAttribute("sptconcepts", sptSigns);
		}
	}
%>
	</table>
</form>

<script>
	function showComplaints(doc){
	    openPopup("/ikirezi/pathwayComplaints.jsp&doc="+doc+"&ts=<%=getTs()%>",800,400).focus();
	}
	function showSheet(doc){
	    window.open("<c:url value="/"/>documents/"+doc,"Document","toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=1,height=1,menubar=no").resizeTo(800,600).focus();
	}
	function updateAll(id,value){
		for(n=0;n<document.getElementsByName(id).length;n++){
			document.getElementsByName(id)[n].value=value;
		}
	}
	function updatePathway(){
		document.getElementById("transactionForm").submit();	
	}
</script>