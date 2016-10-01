<%@page import="be.mxs.common.util.io.MessageReader,
                be.mxs.common.util.io.MessageReaderMedidoc,
                java.util.*,be.openclinic.finance.*,be.openclinic.pharmacy.*,
                javazoom.upload.MultipartFormDataRequest,
                javazoom.upload.UploadFile,org.dom4j.*,org.dom4j.io.*,be.openclinic.medical.*,
                java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.db.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	void storeAgeGender(String type,int id,double minAge, double maxAge, String gender, double minVal, double maxVal, String comment ){
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into AgeGenderControl(rowid,type,id,minAge,maxAge,gender,frequency,tolerance,updatetime,comment) values(?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1,MedwanQuery.getInstance().getOpenclinicCounter("AgeGenderControlID"));
			ps.setString(2,type);
			ps.setInt(3,id);
			ps.setDouble(4,minAge);
			ps.setDouble(5, maxAge);
			ps.setString(6, gender);
			ps.setDouble(7,	minVal);
			ps.setDouble(8, maxVal);
			ps.setTimestamp(9,new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(10,comment);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp") %>' />
    <jsp:setProperty name="upBean" property="parser" value="<%= MultipartFormDataRequest.DEFAULTPARSER	 %>"/>
  	<jsp:setProperty name="upBean" property="filesizelimit" value="8589934592"/>
  	<jsp:setProperty name="upBean" property="overwrite" value="true"/>
  	<jsp:setProperty name="upBean" property="dump" value="true"/>
    <jsp:setProperty name="upBean" property="parsertmpdir" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp") %>'/>
</jsp:useBean>
<%
	int lines=0;
	String message="";
	String sFileName = "";
	MultipartFormDataRequest mrequest;
	if (MultipartFormDataRequest.isMultipartFormData(request)) {
	    // Uses MultipartFormDataRequest to parse the HTTP request.
		mrequest = new MultipartFormDataRequest(request);
		if (mrequest.getParameter("ButtonReadfile")!=null){
	        try{
	            Hashtable files = mrequest.getFiles();
	            if (files != null && !files.isEmpty()){
	                UploadFile file = (UploadFile) files.get("filename");
	                sFileName= new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date())+".ext";
	                file.setFileName(sFileName);
	                upBean.store(mrequest, "filename");
					if(mrequest.getParameter("filetype").equalsIgnoreCase("prestationscsv")){
						if(mrequest.getParameter("erase")!=null){
							ObjectCacheFactory.getInstance().resetObjectCache();
							Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
							PreparedStatement ps = conn.prepareStatement("delete from OC_PRESTATIONS");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}
						int serverid=MedwanQuery.getInstance().getConfigInt("serverId"),objectid;
						String code,name,price,category,prestationclass,mfppct,mfpadmissionpct,tariffcode,tariffprice;
						//Read file as a prestations csv file
		                File f = new File(upBean.getFolderstore()+"/"+sFileName);
						BufferedReader reader = new BufferedReader(new FileReader(f));
						lines=0;
						while(reader.ready()){
							String[] line = reader.readLine().split(";");
							if(line.length<3){
								break;
							}
							else{
								prestationclass="";
								category="";
								mfppct="0";
								mfpadmissionpct="0";
								tariffcode="";
								tariffprice="";
								lines++;
								code=line[0].trim();
								name=line[1].trim();
								price=line[2].trim();
								if(line.length>3){
									category=line[3].trim();
									if(line.length>4){
										prestationclass=line[4].trim();
										if(line.length>5){
											mfppct=line[5];
											if(line.length>6){
												mfpadmissionpct=line[6];
												if(line.length>7){
													tariffcode=line[7];
													if(line.length>8){
														tariffprice=line[8];
													}
												}
											}
										}
									}
								}
								Prestation prestation = new Prestation();
								if(code!=null && code.length()>0 && !code.equalsIgnoreCase("#")){
									prestation = Prestation.getByCode(code);
									if(prestation==null){
										prestation=new Prestation();
									}
								}
								prestation.setCode(code);
								prestation.setDescription(name);
								prestation.setReferenceObject(new ObjectReference(category,""));
								prestation.setCategories("");
								prestation.setInvoicegroup(category);
								prestation.setPrestationClass(prestationclass);
								prestation.setPrice(Double.parseDouble(price));
								prestation.setType(category);
								prestation.setUpdateDateTime(new java.util.Date());
								prestation.setUpdateUser(activeUser.userid);
								prestation.setVersion(1);
								prestation.setMfpAdmissionPercentage(Integer.parseInt(mfpadmissionpct));
								prestation.setMfpPercentage(Integer.parseInt(mfppct));
								if(tariffcode.length()>0){
									prestation.setCategoryPrice(tariffcode, tariffprice);
								}
								prestation.store();
								if(code.equalsIgnoreCase("#")){
									prestation.setCode(category+"."+prestation.getUid().split("\\.")[1]);
									prestation.store();
								}
								MedwanQuery.getInstance().storeLabel("prestation.type", category, "fr", category, Integer.parseInt(activeUser.userid));
								MedwanQuery.getInstance().storeLabel("prestation.type", category, "en", category, Integer.parseInt(activeUser.userid));
							}
						}
						reader.close();
						reloadSingleton(session);
		                f.delete();
						message="<h3>"+lines+" " +getTran(request,"web","records.loaded",sWebLanguage)+"</h3>";
					}
					else if(mrequest.getParameter("filetype").equalsIgnoreCase("servicescsv")){
						if(mrequest.getParameter("erase")!=null){
							ObjectCacheFactory.getInstance().resetObjectCache();
							Connection conn = MedwanQuery.getInstance().getAdminConnection();
							PreparedStatement ps = conn.prepareStatement("delete from Services");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}
						String code,name,language,beds,visits,parentcode;
						//Read file as a prestations csv file
		                File f = new File(upBean.getFolderstore()+"/"+sFileName);
						BufferedReader reader = new BufferedReader(new FileReader(f));
						lines=0;
						while(reader.ready()){
							String[] line = reader.readLine().split(";");
							if(line.length<3){
								break;
							}
							else{
								parentcode="";
								beds="0";
								visits="0";
								lines++;
								code=line[0].trim();
								name=line[1].trim();
								language=line[2].trim();
								if(line.length>3){
									beds=line[3].trim();
									if(line.length>4){
										visits=line[4].trim();
										if(line.length>5){
											parentcode=line[5];
										}
									}
								}
								Service service = new Service();
								service.code=code;
								service.language=language;
								service.totalbeds=Integer.parseInt(beds);
								service.acceptsVisits=visits;
								service.parentcode=parentcode;
								service.updatetime= new java.sql.Date(new java.util.Date().getTime());
								service.updateuserid=activeUser.userid;
								service.store();
								MedwanQuery.getInstance().storeLabel("service", code, "fr", name, Integer.parseInt(activeUser.userid));
								MedwanQuery.getInstance().storeLabel("service", code, "en", name, Integer.parseInt(activeUser.userid));
							}
						}
						reader.close();
						reloadSingleton(session);
		                f.delete();
						message="<h3>"+lines+" " +getTran(request,"web","records.loaded",sWebLanguage)+"</h3>";
					}
					else if(mrequest.getParameter("filetype").equalsIgnoreCase("labelscsv")){
						String type,id,language,label;
						//Read file as a prestations csv file
		                File f = new File(upBean.getFolderstore()+"/"+sFileName);
						BufferedReader reader = new BufferedReader(new FileReader(f));
						lines=0;
						while(reader.ready()){
							String[] line = reader.readLine().split(";");
							if(line.length<4){
								break;
							}
							else{
								type=line[0].trim();
								id=line[1].trim();
								language=line[2].trim();
								label=line[3].trim();
								MedwanQuery.getInstance().updateLabel(type,id,language,label);
								lines++;
							}
						}
						reader.close();
						reloadSingleton(session);
		                f.delete();
						message="<h3>"+lines+" " +getTran(request,"web","records.loaded",sWebLanguage)+"</h3>";
					}
					else if(mrequest.getParameter("filetype").equalsIgnoreCase("pharmacyloadcsv")){
						//Imports can only be done to the central warehouse in OpenClinic
						if(MedwanQuery.getInstance().getConfigString("PEXOpenClinicServiceStock","").length()==0){
							message="<h3>The parameter PEXOpenClinicServiceStock must be defined and must point to a valid OpenClinic warehouse UID</h3>";
						}
						else {
							ServiceStock serviceStock = ServiceStock.get(MedwanQuery.getInstance().getConfigString("PEXOpenClinicServiceStock",""));
							if(serviceStock==null || !serviceStock.hasValidUid()){
								message="<h3>The parameter PEXOpenClinicServiceStock does not point to a valid OpenClinic warehouse UID</h3>";
							}
							else{
								String pex_uid,pex_date,pex_code,pex_name,pex_quantity,pex_price,pex_supplier,pex_batch,pex_expires,pex_comment ;
								//Read file as a pharmacy delivery csv file
				                File f = new File(upBean.getFolderstore()+"/"+sFileName);
								BufferedReader reader = new BufferedReader(new FileReader(f));
								lines=0;
								Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
								while(reader.ready()){
									String[] line = reader.readLine().split(";");
									if(line.length<10){
										break;
									}
									else{
										pex_uid=line[0].trim();
										pex_date=line[1].trim();
										pex_code=line[2].trim();
										pex_name=line[3].trim();
										pex_quantity=line[4].trim();
										pex_price=line[5].trim();
										pex_supplier=line[6].trim();
										pex_batch=line[7].trim();
										pex_expires=line[8].trim();
										pex_comment=line[9].trim();
										try{
											java.util.Date d = new SimpleDateFormat("yyyyMMdd").parse(pex_date);
										}
										catch(Exception e){
											pex_date=new SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
										}
										try{
											int n= Integer.parseInt(pex_quantity);
										}
										catch(Exception e){
											pex_quantity="0";
										}
										try{
											double n= Double.parseDouble(pex_price);
										}
										catch(Exception e){
											pex_price="0";
										}
										lines++;
										//Before importing the data, we first check if there already exists
										//an import transaction for this pex_uid/pex_code combination
										String receiveUid="PEX."+pex_uid+"."+pex_code;
										PreparedStatement ps = conn.prepareStatement("select * from oc_productstockoperations where oc_operation_receivecomment=?");
										ps.setString(1,receiveUid);
										ResultSet rs = ps.executeQuery();
										if(rs.next()){
											System.out.println(receiveUid+": The product has already been received. Will not process again");
										}
										else{
											//The product has not been received yet. Process now
											//First verify if the product exists
											Product product = null;
											Vector products = Product.findWithCode(pex_code, "", "", "", "", "", "", "", "", "OC_PRODUCT_OBJECTID", "ASC");
											for(int n=0; n<products.size();n++){
												Product candidateProduct = (Product)products.elementAt(n);
												if(candidateProduct.getCode().equalsIgnoreCase(pex_code)){
													product=candidateProduct;
													break;
												}
											}
											if(product==null){
												//The product doesn't exist yet, create a new one
												product = new Product();
												product.setUid("-1");
												product.setCode(pex_code);
												product.setName(pex_name);
												product.setUnit("");
												product.setCreateDateTime(new SimpleDateFormat("yyyyMMdd").parse(pex_date));
												product.setUpdateDateTime(new java.util.Date());
												product.setUpdateUser(activeUser.userid);
												product.store();
											}
											ProductStock productStock = null;
											//Now verify if the productstock exists
											Vector productStocks = ProductStock.find(serviceStock.getUid(), product.getUid(), "", "", "", "", "", "", "", "", "", "OC_STOCK_OBJECTID", "ASC");
											if(productStocks.size()>0){
												productStock = (ProductStock)productStocks.elementAt(0);
											}
											else{
												//The product stock doesn't exist yet, create a new one
												productStock = new ProductStock();
												productStock.setUid("-1");
												productStock.setBegin(new SimpleDateFormat("yyyyMMdd").parse(pex_date));
												productStock.setCreateDateTime(new SimpleDateFormat("yyyyMMdd").parse(pex_date));
												productStock.setLevel(0);
												productStock.setOrderLevel(0);
												productStock.setMaximumLevel(0);
												productStock.setMinimumLevel(0);
												productStock.setProductUid(product.getUid());
												productStock.setServiceStockUid(serviceStock.getUid());
												productStock.setUpdateDateTime(new java.util.Date());
												productStock.setUpdateUser(activeUser.userid);
												productStock.setVersion(1);
												productStock.setDefaultImportance("0");
												productStock.setSupplierUid("");
												productStock.store();
											}
											//Now we are sure that the product stock exists. Let's check if the batch exists
											if(pex_batch.length()>0){
												Batch batch = Batch.getByBatchNumber(productStock.getUid(), pex_batch);
												if(batch==null || !batch.hasValidUid()){
													batch= new Batch();
													batch.setUid("-1");
													batch.setBatchNumber(pex_batch);
													batch.setCreateDateTime(new SimpleDateFormat("yyyyMMdd").parse(pex_date));
													try{
														batch.setEnd(new SimpleDateFormat("yyyyMMdd").parse(pex_expires));
													}
													catch(Exception e){}
													batch.setLevel(0);
													batch.setProductStockUid(productStock.getUid());
													batch.setUpdateDateTime(new java.util.Date());
													batch.setUpdateUser(activeUser.userid);
													batch.setVersion(1);
													batch.setComment("");
													batch.store();
												}
											}
											//We can now create an incoming transaction for this product stock
											ProductStockOperation receiptOperation = new ProductStockOperation();
											receiptOperation.setUid("-1");
											try{
												receiptOperation.setBatchEnd(new SimpleDateFormat("yyyyMMdd").parse(pex_expires));
											}
											catch(Exception e){}
											receiptOperation.setBatchNumber(pex_batch);
											receiptOperation.setDate(new SimpleDateFormat("yyyyMMdd").parse(pex_date));
											receiptOperation.setDescription("medicationreceipt.4");
											receiptOperation.setProductStockUid(productStock.getUid());
											receiptOperation.setSourceDestination(new ObjectReference("supplier",pex_supplier));
											receiptOperation.setUnitsChanged(Integer.parseInt(pex_quantity));
											receiptOperation.setUpdateDateTime(new java.util.Date());
											receiptOperation.setUpdateUser(activeUser.userid);
											receiptOperation.setVersion(1);
											receiptOperation.setReceiveComment(receiveUid);
											receiptOperation.setComment(pex_comment);
											receiptOperation.store();
											if(Double.parseDouble(pex_price)>0){
							            		Pointer.deletePointers("drugprice."+productStock.getProduct().getUid()+"."+receiptOperation.getUid());
							            		Pointer.storePointer("drugprice."+productStock.getProduct().getUid()+"."+receiptOperation.getUid(),pex_quantity+";"+pex_price);
											}
										}
										rs.close();
										ps.close();
									}
								}
								reader.close();
								reloadSingleton(session);
				                f.delete();
				                conn.close();
				                message="<h3>"+lines+" " +getTran(request,"web","records.loaded",sWebLanguage)+"</h3>";
							}
						}
					}
					else if(mrequest.getParameter("filetype").equalsIgnoreCase("labxml")){
						if(mrequest.getParameter("erase")!=null){
							ObjectCacheFactory.getInstance().resetObjectCache();
							Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
							PreparedStatement ps = conn.prepareStatement("delete from Labanalysis");
							ps.execute();
							ps.close();
							ps = conn.prepareStatement("delete from oc_labels where oc_label_type in ('labanalysis','labprofiles','labprofile','labanalysis.short','labanalysis.group','labanalysis.refcomment')");
							ps.execute();
							ps.close();
							ps = conn.prepareStatement("delete from labprofiles");
							ps.execute();
							ps.close();
							ps = conn.prepareStatement("delete from labprofilesanalysis");
							ps.execute();
							ps.close();
							ps = conn.prepareStatement("delete from agegendercontrol where type='LabAnalysis'");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}	
						String type,id,language,label;
						//Read file as a prestations csv file
		                File f = new File(upBean.getFolderstore()+"/"+sFileName);
						BufferedReader br = new BufferedReader(new FileReader(f));
						SAXReader reader=new SAXReader(false);
						org.dom4j.Document document=reader.read(br);
						Element root = document.getRootElement();
						Iterator i = root.elementIterator("labanalysis");
						lines=0;
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							LabAnalysis analysis = new LabAnalysis();
							analysis.setLabcode(element.elementText("code"));
							analysis.setLabtype(element.elementText("type"));
							analysis.setMonster(element.elementText("sample"));
							analysis.setLabgroup(element.elementText("group"));
							analysis.setUnit(element.elementText("unit"));
							analysis.setEditor(element.elementText("editor"));
							analysis.setEditorparameters(element.elementText("modifiers"));
							analysis.setMedidoccode(element.elementText("loinc"));
							analysis.setUpdatetime(new Timestamp(new java.util.Date().getTime()));
							analysis.setUpdateuserid(Integer.parseInt(activeUser.userid));
							analysis.setLabId(MedwanQuery.getInstance().getOpenclinicCounter("LabAnalysisID"));
							analysis.insert();
							Iterator labels = element.elementIterator("label");
							while(labels.hasNext()){
								Element lbl = (Element)labels.next();
								MedwanQuery.getInstance().storeLabel("labanalysis", analysis.getLabId()+"", lbl.attributeValue("language"), lbl.getText(), Integer.parseInt(activeUser.userid));
								MedwanQuery.getInstance().storeLabel("labanalysis.short", analysis.getLabId()+"", lbl.attributeValue("language"), checkString(element.elementText("short")), Integer.parseInt(activeUser.userid));
								MedwanQuery.getInstance().storeLabel("labanalysis.refcomment", analysis.getLabId()+"", lbl.attributeValue("language"), checkString(lbl.elementText("refcomment")), Integer.parseInt(activeUser.userid));
							}
							//Now check the reference values
							Element refs = element.element("refs");
							if(refs != null){
								Iterator r = refs.elementIterator("ref");
								while(r.hasNext()){
									Element ref = (Element)r.next();
									storeAgeGender("LabAnalysis",analysis.getLabId(),Double.parseDouble(ref.attributeValue("minage")),Double.parseDouble(ref.attributeValue("maxage")),ref.attributeValue("gender"),Double.parseDouble(ref.elementText("minval")),Double.parseDouble(ref.elementText("maxval")),checkString(ref.elementText("comment")));
								}
							}
						}
						i = root.elementIterator("labprofile");
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							LabProfile profile = new LabProfile();
							profile.setProfilecode(element.elementText("code").toUpperCase());
							profile.setProfileID(MedwanQuery.getInstance().getOpenclinicCounter("LabProfileID"));
							profile.setUpdatetime(new Timestamp(new java.util.Date().getTime()));
							profile.setUpdateuserid(Integer.parseInt(activeUser.userid));
							profile.insert();
							Iterator as = element.elementIterator("labanalysis");
							while(as.hasNext()){
								Element analysisElement = (Element)as.next();
								LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(analysisElement.getText());
								if(analysis!=null){
									LabProfileAnalysis an = new LabProfileAnalysis();
									an.setLabID(analysis.getLabId());
									an.setProfileID(profile.getProfileID());
									an.setUpdatetime(new Timestamp(new java.util.Date().getTime()));
									an.setUpdateuserid(Integer.parseInt(activeUser.userid));
									an.insert();
								}
							}
							Iterator labels = element.elementIterator("label");
							while(labels.hasNext()){
								Element lbl = (Element)labels.next();
								MedwanQuery.getInstance().storeLabel("labprofiles", profile.getProfileID()+"", lbl.attributeValue("language"), lbl.getText(), Integer.parseInt(activeUser.userid));
							}
							
						}
						i = root.elementIterator("labanalysisgroup");
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							Iterator labels = element.elementIterator("label");
							while(labels.hasNext()){
								Element lbl = (Element)labels.next();
								MedwanQuery.getInstance().storeLabel("labanalysis.group", element.elementText("code")+"", lbl.attributeValue("language"), lbl.getText(), Integer.parseInt(activeUser.userid));
							}
						}
						br.close();
						reloadSingleton(session);
		                f.delete();
		                message="<h3>"+lines+" " +getTran(request,"web","records.loaded",sWebLanguage)+"</h3>";
					}					
					else if(mrequest.getParameter("filetype").equalsIgnoreCase("drugsxml")){
						if(mrequest.getParameter("erase")!=null){
							ObjectCacheFactory.getInstance().resetObjectCache();
							Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
							PreparedStatement ps = conn.prepareStatement("delete from oc_products");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}						
						String type,id,language,label;
						//Read file as a prestations csv file
		                File f = new File(upBean.getFolderstore()+"/"+sFileName);
						BufferedReader br = new BufferedReader(new FileReader(f));
						SAXReader reader=new SAXReader(false);
						org.dom4j.Document document=reader.read(br);
						Element root = document.getRootElement();
						Iterator i = root.elementIterator("drug");
						lines=0;
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							Product product = new Product();
							product.setUid("-1");
							product.setCreateDateTime(new Timestamp(new java.util.Date().getTime()));
							product.setName(element.elementText("name"));
							product.setPackageUnits(1);
							product.setProductGroup(element.elementText("group"));
							product.setProductSubGroup(element.elementText("category"));
							product.setSupplierUid("TEC.PHA");
							product.setUnit(element.elementText("form"));
							product.setUpdateDateTime(new Timestamp(new java.util.Date().getTime()));
							product.setUpdateUser(activeUser.userid);
							product.store();
						}
						i = root.elementIterator("drugcategory");
						if(i.hasNext() && mrequest.getParameter("erase")!=null){
							Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
							PreparedStatement ps = conn.prepareStatement("delete from DrugCategories");
							ps.execute();
							ps = conn.prepareStatement("delete from oc_labels where oc_label_type ='drug.category'");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							DrugCategory category = new DrugCategory();
							category.code=element.elementText("code");
							category.parentcode=element.elementText("parentcode");
							category.updatetime=new java.util.Date();
							category.updateuserid=activeUser.userid;
							category.saveToDB();
							Iterator labels = element.elementIterator("label");
							while(labels.hasNext()){
								Element lbl = (Element)labels.next();
								MedwanQuery.getInstance().storeLabel("drug.category", element.elementText("code")+"", lbl.attributeValue("language"),lbl.getText(),Integer.parseInt(activeUser.userid));
							}
						}
						i = root.elementIterator("drugform");
						if(i.hasNext() && mrequest.getParameter("erase")!=null){
							Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
							PreparedStatement ps = conn.prepareStatement("delete from oc_labels where oc_label_type ='product.unit'");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							Iterator labels = element.elementIterator("label");
							while(labels.hasNext()){
								Element lbl = (Element)labels.next();
								MedwanQuery.getInstance().storeLabel("product.unit", element.elementText("code")+"", lbl.attributeValue("language"), lbl.getText(), Integer.parseInt(activeUser.userid));
							}
						}
						i = root.elementIterator("druggroup");
						if(i.hasNext() && mrequest.getParameter("erase")!=null){
							Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
							PreparedStatement ps = conn.prepareStatement("delete from oc_labels where oc_label_type ='product.productgroup'");
							ps.execute();
							ps.close();
							conn.close();

					        UpdateSystem systemUpdate = new UpdateSystem();
					        systemUpdate.updateCounters();
						}
						while(i.hasNext()){
							lines++;
							Element element = (Element)i.next();
							Iterator labels = element.elementIterator("label");
							while(labels.hasNext()){
								Element lbl = (Element)labels.next();
								MedwanQuery.getInstance().storeLabel("product.productgroup", element.elementText("code")+"", lbl.attributeValue("language"), lbl.getText(), Integer.parseInt(activeUser.userid));
							}
						}
						br.close();
						reloadSingleton(session);
		                f.delete();
		                message="<h3>"+lines+" " +getTran(request,"web","records.loaded",sWebLanguage)+"</h3>";
					}
	            }
	        }
	        catch(Exception e){
	            e.printStackTrace();
	        }
		}
	}
	else {
	}
%>
<form name="readMessageForm" method="post" enctype="multipart/form-data">
	<table>
		<tr>
			<td class='admin'>
				<%=getTran(request,"web","filetype",sWebLanguage)%>
				<select name="filetype" id="filetype" class="text" onchange="showstructure();">
					<%if(!checkString(request.getParameter("pharmacyloadonly")).equalsIgnoreCase("1")){ %>
						<option value="prestationscsv"><%=getTran(request,"web","prestations.csv",sWebLanguage)%></option>
						<option value="servicescsv"><%=getTran(request,"web","services.csv",sWebLanguage)%></option>
						<option value="labelscsv"><%=getTran(request,"web","labels.csv",sWebLanguage)%></option>
						<option value="labxml"><%=getTran(request,"web","lab.xml",sWebLanguage)%></option>
						<option value="drugsxml"><%=getTran(request,"web","drugs.xml",sWebLanguage)%></option>
					<%} %>
					<option value="pharmacyloadcsv"><%=getTran(request,"web","pharmacyload.csv",sWebLanguage)%></option>
				</select>
			</td>
			<td class='admin2'><input class="hand" type="checkbox" name="erase" value="1"/> <%=getTran(request,"web","delete.table.before.load",sWebLanguage)%></td>
			<td class='admin2'><input class="hand" type="file" name="filename"/> <input class="button" type="submit" name="ButtonReadfile" value="<%=getTranNoLink("web","load",sWebLanguage)%>"/></td>
		</tr>
		<tr>
			<td colspan="2"><div id="structure"/></td>
		</tr>
    </table>
    <font color='red'><%=message %></font>
</form>

<script>
	function showstructure(){
		if(document.getElementById("filetype").value=="prestationscsv"){
			document.getElementById("structure").innerHTML="Required structure (* are mandatory):<br/><b>Code* (#=auto); Name* ; Price* ; Category ; Class; AMO % ; AMO Admission %</b>";
		}
		else if(document.getElementById("filetype").value=="pharmacyloadcsv"){
			document.getElementById("structure").innerHTML="Required structure (* are mandatory):<br/><b>PEX_UID* ; PEX_DATE* ; PEX_CODE* ; PEX_NAME ; PEX_QUANTITY* ; PEX_PRICE ; PEX_SUPPLIER ; PEX_BATCH ; PEX_EXPIRES ; PEX_COMMENT</b>";
		}
		else if(document.getElementById("filetype").value=="servicescsv"){
			document.getElementById("structure").innerHTML="Required structure (* are mandatory):<br/><b>Code* ; Name* ; Language* ; Beds ; Visits ; ParentCode</b>";
		}
		else if(document.getElementById("filetype").value=="labelscsv"){
			document.getElementById("structure").innerHTML="Required structure (* are mandatory):<br/><b>Type* ; ID* ; Language* ; Label*</b>";
		}
		else {
			document.getElementById("structure").innerHTML="";
		}
	}
	
	showstructure();
</script>