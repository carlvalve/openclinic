<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	String loadonly    = checkString(request.getParameter("loadonly")),
           drugbarcode = checkString(request.getParameter("DrugBarcode")),
           druguid = checkString(request.getParameter("DrugUid")),
           comment = checkString(request.getParameter("Comment")),
           encounteruid = checkString(request.getParameter("EncounterUid")),
	       sQuantity   = checkString(request.getParameter("Quantity"));
	
	int quantity = 1;
	try{
		quantity = Integer.parseInt(sQuantity);
	}
	catch(Exception e){
		e.printStackTrace();
	}
	
	String servicestock = checkString(request.getParameter("ServiceStock"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n******************** pharmacy/addDrugsOutBarcode.jsp ******************");
    	Debug.println("loadonly    : "+loadonly);
    	Debug.println("drugbarcode : "+drugbarcode);
    	Debug.println("comment     : "+comment);
    	Debug.println("encounteruid: "+encounteruid);
    	Debug.println("sQuantity   : "+sQuantity+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
	// search product
	ProductStock productstock = null;
    if(druguid.length()==0){
    	productstock= ProductStock.getByBarcode(drugbarcode,servicestock);
    }
    else{
    	Vector stocks =ProductStock.find(servicestock, druguid, "", "", "", "", "", "", "", "", "", "OC_STOCK_OBJECTID", "ASC");
    	if(stocks.size()>0){
    		productstock=(ProductStock)stocks.elementAt(0);
    	}
    }

    int reservedQuantity=0;
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = null;
	ResultSet rs = null;
	if(productstock!=null){
		ps = conn.prepareStatement("SELECT sum(OC_LIST_QUANTITY) reserved FROM OC_DRUGSOUTLIST WHERE OC_LIST_PATIENTUID=?"+
	            " AND OC_LIST_PRODUCTSTOCKUID=?");
		ps.setString(1,activePatient.personid);
		ps.setString(2,productstock.getUid());
		rs = ps.executeQuery();
		if(rs.next()){
			reservedQuantity=rs.getInt("reserved");
		}
		rs.close();
		ps.close();
	}

	if(loadonly.length()==0 && (servicestock.length()==0 || productstock==null)){
		out.print("{\"message\":\""+getTranNoLink("web","productstock.does.not.exist",sWebLanguage)+"\"}");
	}
	else if(loadonly.length()==0 && productstock.getLevel()<(quantity+reservedQuantity)){
		out.print("{\"message\":\""+getTranNoLink("web","insufficient.stock",sWebLanguage)+"\"}");
	}
	else{
		// load-only
		
		if(loadonly.length()==0){
			// aflevering toevoegen aan oc_drugsoutlist
			String batchuid = "";
			int tofind = quantity;
			
			Vector batches = Batch.getActiveBatches(productstock.getUid());
			//Info: the active batches are ordered by expiry date, nearest expiry date first
			for(int n=0; n<batches.size(); n++){
				Batch batch = (Batch)batches.elementAt(n);
				System.out.println("batch="+batch.getUid()+" ("+tofind+")");
				int nBatchReserved = 0;
				ps = conn.prepareStatement("SELECT sum(OC_LIST_QUANTITY) reserved FROM OC_DRUGSOUTLIST WHERE OC_LIST_PATIENTUID=?"+
                        " AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=?");
				ps.setString(1,activePatient.personid);
				ps.setString(2,productstock.getUid());
				ps.setString(3,batch.getUid());
				rs = ps.executeQuery();
				
				if(rs.next()){
					nBatchReserved=rs.getInt("reserved");
				}
				rs.close();
				ps.close();
				
				if(batch.getLevel()>nBatchReserved){
					//The remaining quantity is more than the already reserved quantity
					//Update the batchrequest
					//Calculate the quantity that can be delivered from this batch
					int nToDeliver=0;
					if(batch.getLevel()-nBatchReserved>=tofind){
						nToDeliver=tofind;
					}
					else{
						nToDeliver=batch.getLevel()-nBatchReserved;
					}
						
					ps = conn.prepareStatement("SELECT * FROM OC_DRUGSOUTLIST WHERE OC_LIST_PATIENTUID=?"+
				                               " AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=?");
					ps.setString(1,activePatient.personid);
					ps.setString(2,productstock.getUid());
					ps.setString(3,batch.getUid());
					ps.setString(4,encounteruid);
					rs = ps.executeQuery();
					
					if(rs.next()){
						rs.close();
						ps.close();
						//There already is a batch request, update the requested level
						ps = conn.prepareStatement("update OC_DRUGSOUTLIST set OC_LIST_QUANTITY=OC_LIST_QUANTITY+?"+
						                           " where  OC_LIST_PATIENTUID=? AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=?");
						ps.setInt(1,nToDeliver);
						ps.setString(2,activePatient.personid);
						ps.setString(3,productstock.getUid());
						ps.setString(4,batch.getUid());
						ps.setString(5,encounteruid);
						ps.execute();
						ps.close();
					}
					else{
						rs.close();
						ps.close();
						
						ps = conn.prepareStatement("insert into OC_DRUGSOUTLIST(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,"+
						                           "OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID) values(?,?,?,?,?,?,?,?)");
						ps.setInt(1,MedwanQuery.getInstance().getConfigInt("serverId"));
						ps.setInt(2,MedwanQuery.getInstance().getOpenclinicCounter("DRUGSOUT"));
						ps.setString(3,activePatient.personid);
						ps.setString(4,productstock.getUid());
						ps.setInt(5,nToDeliver);
						ps.setString(6,batch.getUid());
						ps.setString(7,comment);
						ps.setString(8,encounteruid);
						ps.execute();
						ps.close();
					}
					tofind = tofind-nToDeliver;
				}
				if(tofind==0){
					break;
				}
			}
			
			if(tofind > 0){
				//There still is a quantity to deliver, but no more batches are available
				//Deliver the quantity from unbatched stock
				ps = conn.prepareStatement("select * from OC_DRUGSOUTLIST where OC_LIST_PATIENTUID=?"+
			                               " AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=?");
				ps.setString(1,activePatient.personid);
				ps.setString(2,productstock.getUid());
				ps.setString(3,"");
				ps.setString(4,encounteruid);
				rs = ps.executeQuery();
				
				if(rs.next()){
					rs.close();
					ps.close();
					
					ps = conn.prepareStatement("update OC_DRUGSOUTLIST set OC_LIST_QUANTITY=OC_LIST_QUANTITY+?"+
					                           " where OC_LIST_PATIENTUID=? AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=?");
					ps.setInt(1,tofind);
					ps.setString(2,activePatient.personid);
					ps.setString(3,productstock.getUid());
					ps.setString(4,"");
					ps.setString(5,encounteruid);
					ps.execute();
					ps.close();
				}
				else{
					rs.close();
					ps.close();
					
					ps = conn.prepareStatement("insert into OC_DRUGSOUTLIST(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,"+
					                           " OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID) values(?,?,?,?,?,?,?,?)");
					ps.setInt(1,MedwanQuery.getInstance().getConfigInt("serverId"));
					ps.setInt(2,MedwanQuery.getInstance().getOpenclinicCounter("DRUGSOUT"));
					ps.setString(3,activePatient.personid);
					ps.setString(4,productstock.getUid());
					ps.setInt(5,tofind);
					ps.setString(6,"");
					ps.setString(7,comment);
					ps.setString(8,encounteruid);
					ps.execute();
					ps.close();
				}
			}
		}

		// lijst maken van oc_drugsoutlist producten in wacht voor pati�nt
	    String drugs = "<table width='100%' class='list' cellpadding='0' cellspacing='1'>";
		
		ps = conn.prepareStatement("select * from oc_drugsoutlist where OC_LIST_PATIENTUID=? order by OC_LIST_PRODUCTSTOCKUID");
		ps.setString(1,activePatient.personid);
		rs = ps.executeQuery();
		int count = 0;
		
		ProductStock stock;
		while(rs.next()){
			stock = ProductStock.get(rs.getString("OC_LIST_PRODUCTSTOCKUID"));

			if(stock!=null && stock.getProduct()!=null){
				int level = stock.getUnbatchedLevel();

				Batch batch = Batch.get(rs.getString("OC_LIST_BATCHUID"));
				String sBatch = "";
				String sExpires = "";
				if(batch!=null){
					sBatch = batch.getBatchNumber();
					level = batch.getLevel();
					sExpires = ScreenHelper.formatDate(batch.getEnd());
				}

				// header
				if(count==0){
					drugs+= "<tr class='admin'>"+
				             "<td/>"+
							 "<td>ID</td>"+
				             "<td>"+getTran(request,"web","code",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","product",sWebLanguage)+"</td>"+
							 "<td>"+getTran(request,"web","quantity",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","batch",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","level",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","expires",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","comment",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","encounter",sWebLanguage)+"</td>"+
							"</tr>";
				}
				count++;

				// one row
				String stocklabel="";
				if(!stock.getServiceStockUid().equalsIgnoreCase(servicestock)){
					stocklabel=" <font style='font-size: 8' color='darkgrey'>&nbsp;<img height='10' src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>("+stock.getServiceStock().getName()+")</font>";
				}
				int nBatch=rs.getInt("OC_LIST_QUANTITY");
				drugs+= "<tr>"+
				         "<td class='admin2'>"+
				         (activeUser.getAccessRight("fastdrugsprescription.delete")?
				          "<a href='javascript:doDelete(\\\""+rs.getInt("OC_LIST_SERVERID")+"."+rs.getInt("OC_LIST_OBJECTID")+"\\\");'>"+
				           "<img src='_img/icons/icon_delete.png' class='link' title='"+getTranNoLink("web","delete",sWebLanguage)+"'/></a>"
				          :"")+
				         "</td>"+
				         "<td class='admin2'>"+stock.getUid()+"</td>"+
				         "<td class='admin2'><b>"+stock.getProduct().getCode()+"</b></td>"+
				         "<td class='admin2'><b><span id='drugname."+stock.getUid()+"'>"+stock.getProduct().getName()+"</span></b>"+stocklabel+"</td>"+
				         "<td class='admin2'><b>"+nBatch+"</b></td>"+
				         "<td class='admin2'>"+sBatch+"</td>"+
				         "<td class='admin2'>"+level+(level<nBatch?" <NODELIVERY><img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/>":"")+"</td>"+
				         "<td class='admin2'>"+sExpires+"</td>"+
				         "<td class='admin2'><b>"+checkString(rs.getString("OC_LIST_COMMENT"))+"</b></td>"+
				         "<td class='admin2'>"+checkString(rs.getString("OC_LIST_ENCOUNTERUID"))+"</td>"+
				        "</tr>";
			}
		}
		rs.close();
		ps.close();
		conn.close();

		drugs+= "</table>";
		
		out.print("{\"drugs\":\""+drugs+"\"}");
	}
%>