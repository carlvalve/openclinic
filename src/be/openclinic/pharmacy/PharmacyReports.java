package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import be.dpms.medwan.webapp.wo.common.system.SessionContainerWO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.webapp.wl.session.SessionContainerFactory;
import be.openclinic.adt.Encounter;
import be.openclinic.finance.Debet;
import be.openclinic.finance.PatientInvoice;
import net.admin.AdminPrivateContact;
import net.admin.Service;
import net.admin.User;

public class PharmacyReports {

	public static Vector getConsumptionReport(String serviceStockUid, java.util.Date begin, java.util.Date end, String language){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="POSTING DATE;";
		reportline+="ITEM NO;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="QUANTITY;";
		reportline+="STOCK PRICE;";
		reportline+="TOTAL;";
		reportline+="COST CENTER;";
		reportline+="ISSUED TO;";
		reportline+="LOCATION;";
		reportline+="GROUP DESCRIPTION;";
		reportline+="GROUP CATGEORY;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Hashtable pumps = new Hashtable();
				Hashtable encounters = new Hashtable();
				Vector operations = ProductStockOperation.getServiceStockDeliveries(serviceStockUid, begin, end, "OC_OPERATION_DATE", "ASC");
				for (int n=0;n<operations.size();n++){
					long time = new java.util.Date().getTime();
					ProductStockOperation operation = (ProductStockOperation)operations.elementAt(n);
					Product product=null;
					if(operation.getProductStock()!=null){
						product=operation.getProductStock().getProduct();
					}
					if((operation.getUnitsChanged()-operation.getUnitsReceived()!=0) && product!=null){
						if(pumps.get(product.getUid()+"."+ScreenHelper.formatDate(operation.getDate()))==null){
							pumps.put(product.getUid()+"."+ScreenHelper.formatDate(operation.getDate()),product.getLastYearsAveragePrice(operation.getDate()));
						}
						double pump = (Double)pumps.get(product.getUid()+"."+ScreenHelper.formatDate(operation.getDate()));
						reportline=ScreenHelper.formatDate(operation.getDate())+";";
						reportline+=product.getCode()+";";
						reportline+=product.getName()+";";
						reportline+=(operation.getUnitsChanged()-operation.getUnitsReceived())+";";
						reportline+=ScreenHelper.getPriceFormat(pump)+";";
						reportline+=ScreenHelper.getPriceFormat((operation.getUnitsChanged()-operation.getUnitsReceived())*pump)+";";
						if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient")){
							if(encounters.get(operation.getEncounterUID())==null){
								encounters.put(operation.getEncounterUID(), Encounter.get(operation.getEncounterUID()));
							}
							Encounter encounter = (Encounter)encounters.get(operation.getEncounterUID());
							if(encounter!=null){
								Service service = Service.getService(encounter.getServiceUID(operation.getDate()));
								if(service!=null){
									reportline+=service.getLabel(language);
								}
							}
							reportline+=";";
						}
						else{
							reportline+=";";
						}
						reportline+=ScreenHelper.getTranNoLink("productstockoperation.medicationdelivery", operation.getDescription(), language)+";";
						reportline+=operation.getProductStock().getServiceStock().getName()+";";
						reportline+=ScreenHelper.getTranNoLink("product.productgroup",product.getProductGroup(),language)+";";
						reportline+=ScreenHelper.getTranNoLink("drug.category",product.getProductSubGroup(),language)+";\n";
						report.add(reportline);

					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getInventoryAnalysisReport(String serviceStockUid, java.util.Date date){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="STOCK BALANCE;";
		reportline+="UNIT COST;";
		reportline+="STOCK VALUE;";
		reportline+="MINIMUM LEVEL;";
		reportline+="1 MONTH;";
		reportline+="3 MONTHS;";
		reportline+="6 MONTHS;";
		reportline+="LAST PURCHASE;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productStocks = serviceStock.getProductStocks();
				for(int n=0;n<productStocks.size();n++){
					ProductStock productStock = (ProductStock)productStocks.elementAt(n);
					if(productStock!=null && productStock.getProduct()!=null){
						reportline="";
						double level = productStock.getLevel(date);
						double cost = productStock.getProduct().getLastYearsAveragePrice(date);
						reportline+=productStock.getProduct().getCode()+";";
						reportline+=productStock.getProduct().getName()+";";
						reportline+=level+";";
						reportline+=cost+";";
						reportline+=level*cost+";";
						reportline+=productStock.getMinimumLevel()+";";
						reportline+=productStock.getTotalUnitsOutForPeriod(Miscelaneous.addMonthsToDate(date,-1),date)+";";
						reportline+=productStock.getTotalUnitsOutForPeriod(Miscelaneous.addMonthsToDate(date,-3),date)+";";
						reportline+=productStock.getTotalUnitsOutForPeriod(Miscelaneous.addMonthsToDate(date,-6),date)+";";
						reportline+=Pointer.getLastPointer("PHARMA.PRODUCT.PURCHASE."+productStock.getProductUid())+";";
						reportline+="\r\n";
						report.add(reportline);
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getSpecialOrderReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="P/O DATE&TIME;";
		reportline+="PRODUCTION DOC NR;";
		reportline+="FG ITEM CODE;";
		reportline+="RM ITEM CODE;";
		reportline+="RM ITEM DESCRIPTION;";
		reportline+="RM ITEM COMMENT;";
		reportline+="SALES ORDER NR;";
		reportline+="ESTIMATED DELIVERY;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null && product.getCode().startsWith(MedwanQuery.getInstance().getConfigString("specialOrderPrefix","SO"))){
							//Now we search for all raw materials
							Vector materials = productionOrder.getMaterials();
							if(materials.size()==0){
								reportline="";
								reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
								reportline+=productionOrder.getId()+";";
								reportline+=product.getCode()+";;;;";
								if(productionOrder.getDebetUid()!=null){
									Debet debet = Debet.get(productionOrder.getDebetUid());
									if(debet!=null){
										reportline+=debet.getPatientInvoiceUid()+";";
										PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
										if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
											reportline+=invoice.getEstimatedDeliveryDate()+";";
										}
										else{
											reportline+=";";
										}
									}
									else{
										reportline+=";;";
									}
								}
								else{
									reportline+=";;";
								}
								report.add(reportline+"\r\n");
							}
							else{
								for(int q=0;q<materials.size();q++){
									reportline="";
									ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(q);
									if(q==0){
										reportline="";
										reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
										reportline+=productionOrder.getId()+";";
										reportline+=product.getCode()+";";
									}
									else{
										reportline+=";;;";
									}
									//Add material data
									if(material.getProductStock()!=null && material.getProductStock().getProduct()!=null){
										reportline+=material.getProductStock().getProduct().getCode()+";";
										reportline+=material.getProductStock().getProduct().getName()+";";
										reportline+=material.getComment()+";";
									}
									else{
										reportline+="?;?;?;";
									}
									if(q==0){
										if(productionOrder.getDebetUid()!=null){
											Debet debet = Debet.get(productionOrder.getDebetUid());
											if(debet!=null){
												reportline+=debet.getPatientInvoiceUid()+";";
												PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
												if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
													reportline+=invoice.getEstimatedDeliveryDate()+";";
												}
												else{
													reportline+=";";
												}
											}
											else{
												reportline+=";;";
											}
										}
										else{
											reportline+=";;";
										}
									}
									else{
										reportline+=";;";
									}
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getProductionReport(String serviceStockUid, java.util.Date begin, java.util.Date end, String language){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="P/O DATE&TIME;";
		reportline+="PRODUCTION DOC NR;";
		reportline+="FG ITEM CODE;";
		reportline+="RM ITEM CODE;";
		reportline+="RM ITEM DESCRIPTION;";
		reportline+="RM ITEM QUANTITY;";
		reportline+="RM ITEM COMMENT;";
		reportline+="SALES ORDER NR;";
		reportline+="ESTIMATED DELIVERY;";
		reportline+="TECHNICIAN NAME;";
		reportline+="SHOP NAME;";
		reportline+="P/O CLOSED;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null){
							//Now we search for all raw materials
							Vector materials = productionOrder.getMaterialsSummary();
							if(materials.size()==0){
								reportline="";
								reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
								reportline+=productionOrder.getId()+";";
								reportline+=product.getCode()+";;;;;";
								if(productionOrder.getDebetUid()!=null){
									Debet debet = Debet.get(productionOrder.getDebetUid());
									if(debet!=null){
										reportline+=debet.getPatientInvoiceUid()+";";
										PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
										if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
											reportline+=invoice.getEstimatedDeliveryDate()+";";
										}
										else{
											reportline+=";";
										}
									}
									else{
										reportline+=";;";
									}
								}
								else{
									reportline+=";;";
								}
								reportline+=ScreenHelper.getTranNoLink("productiontechnician",productionOrder.getTechnician(),language)+";";
								reportline+=ScreenHelper.getTranNoLink("productiondestination",productionOrder.getDestination(),language)+";";
								reportline+=ScreenHelper.formatDate(productionOrder.getCloseDateTime());
								report.add(reportline+"\r\n");
							}
							else{
								for(int q=0;q<materials.size();q++){
									reportline="";
									ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(q);
									reportline="";
									reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
									reportline+=productionOrder.getId()+";";
									reportline+=product.getCode()+";";
									//Add material data
									if(material.getProductStock()!=null && material.getProductStock().getProduct()!=null){
										reportline+=material.getProductStock().getProduct().getCode()+";";
										reportline+=material.getProductStock().getProduct().getName()+";";
										reportline+=material.getQuantity()+";";
										reportline+=material.getComment()+";";
									}
									else{
										reportline+="?;?;?;?;";
									}
									if(productionOrder.getDebetUid()!=null){
										Debet debet = Debet.get(productionOrder.getDebetUid());
										if(debet!=null){
											reportline+=debet.getPatientInvoiceUid()+";";
											PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
											if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
												reportline+=invoice.getEstimatedDeliveryDate()+";";
											}
											else{
												reportline+=";";
											}
										}
										else{
											reportline+=";;";
										}
									}
									else{
										reportline+=";;";
									}
									reportline+=ScreenHelper.getTranNoLink("productiontechnician",productionOrder.getTechnician(),language)+";";
									reportline+=ScreenHelper.getTranNoLink("productiondestination",productionOrder.getDestination(),language)+";";
									reportline+=ScreenHelper.formatDate(productionOrder.getCloseDateTime());
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getSalesOrderReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="DATE;";
		reportline+="SALES ORDER DOC NR;";
		reportline+="IP NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="CUSTOMER PHONE;";
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="UNIT AMOUNT;";
		reportline+="TOTAL AMOUNT;";
		reportline+="AMOUNT PAID;";
		reportline+="BALANCE AMOUNT;";
		reportline+="INVOICE STATUS;\r\n";
		report.add(reportline);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct oc_patientinvoice_objectid as invoiceuid,oc_patientinvoice_date from oc_debets,oc_prestations,oc_patientinvoices,oc_productionorders,oc_productstocks"
							+ " where"
							+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_prestation_code like ? and"
							+ " oc_debet_patientinvoiceuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_PATIENTINVOICE_OBJECTID")+" and"
							+ " oc_productionorder_debetuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_DEBET_OBJECTID")+" and"
							+ " oc_patientinvoice_date >= ? and"
							+ " oc_patientinvoice_date <? and"
							+ " oc_stock_objectid=replace(oc_productionorder_targetproductstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_stock_servicestockuid=?"
							+ " ORDER BY oc_patientinvoice_date,oc_patientinvoice_objectid");
			ps.setString(1, MedwanQuery.getInstance().getConfigString("finishedGoodsPrefix","FG")+"%");
			ps.setDate(2, new java.sql.Date(begin.getTime()));
			ps.setDate(3, new java.sql.Date(end.getTime()));
			ps.setString(4, serviceStockUid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String invoiceuid = rs.getString("invoiceuid");
				PatientInvoice invoice = PatientInvoice.get(invoiceuid);
				if(invoice!=null){
					reportline=ScreenHelper.formatDate(invoice.getDate())+";";
					reportline+=invoice.getInvoiceNumber()+";";
					reportline+=invoice.getPatientUid()+";";
					if(invoice.getPatient()!=null){
						reportline+=invoice.getPatient().getFullName()+";";
						if(invoice.getPatient().getActivePrivate()!=null){
							reportline+=((AdminPrivateContact)invoice.getPatient().getActivePrivate()).telephone+";";
						}
						else{
							reportline+=";";
						}
					}
					else{
						reportline+=";;";
					}
					boolean bHasFinishedGoods=false;
					Vector debets = invoice.getDebets();
					for(int n=0;n<debets.size();n++){
						Debet debet = (Debet)debets.elementAt(n);
						if(debet.getPrestation()!=null && debet.getQuantity()>0 && debet.getPrestation().getCode().startsWith(MedwanQuery.getInstance().getConfigString("finishedGoodsPrefix","FG"))){
							reportline+=debet.getPrestation().getCode()+";";
							reportline+=debet.getPrestation().getDescription()+";";
							reportline+=invoice.getPatientAmount()/debet.getQuantity()+";";
							bHasFinishedGoods=true;
							break;
						}
					}
					if(!bHasFinishedGoods){
						reportline+=";;;";
					}
					reportline+=invoice.getPatientAmount()+";";
					reportline+=invoice.getAmountPaid()+";";
					reportline+=invoice.getBalance()+";";
					reportline+=invoice.getStatus()+";\r\n";
					report.add(reportline);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return report;
	}

	public static Vector getDeliveryReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ORDER DATE;";
		reportline+="ISSUED DATE;";
		reportline+="IP NR;";
		reportline+="SALES ORDER NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="CUSTOMER PHONE;";
		reportline+="TOTAL AMOUNT;";
		reportline+="AMOUNT PAID;";
		reportline+="BALANCE AMOUNT;";
		reportline+="ESTIMATED DELIVERY;\r\n";
		report.add(reportline);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct oc_patientinvoice_objectid as invoiceuid,oc_patientinvoice_date,oc_operation_date from oc_debets,oc_prestations,oc_patientinvoices,oc_productionorders,oc_productstockoperations,oc_productstocks"
							+ " where"
							+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_prestation_code like ? and"
							+ " oc_debet_patientinvoiceuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_PATIENTINVOICE_OBJECTID")+" and"
							+ " oc_productionorder_debetuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_DEBET_OBJECTID")+" and"
							+ " oc_patientinvoice_date >= ? and"
							+ " oc_patientinvoice_date <? and"
							+ " oc_operation_productstockuid=oc_productionorder_targetproductstockuid and"
							+ " oc_stock_objectid=replace(oc_productionorder_targetproductstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_stock_servicestockuid=? and"
							+ " oc_operation_description like 'medicationdelivery%' and"
							+ " oc_operation_srcdesttype='patient' and"
							+ " oc_operation_srcdestuid=oc_patientinvoice_patientuid and"
							+ " oc_operation_date>=oc_productionorder_createdatetime"
							+ " ORDER BY oc_patientinvoice_date,oc_patientinvoice_objectid");
			ps.setString(1, MedwanQuery.getInstance().getConfigString("finishedGoodsPrefix","FG")+"%");
			ps.setDate(2, new java.sql.Date(begin.getTime()));
			ps.setDate(3, new java.sql.Date(end.getTime()));
			ps.setString(4, serviceStockUid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String invoiceuid = rs.getString("invoiceuid");
				PatientInvoice invoice = PatientInvoice.get(invoiceuid);
				if(invoice!=null){
					reportline=ScreenHelper.formatDate(invoice.getDate())+";";
					reportline+=ScreenHelper.formatDate(rs.getDate("oc_operation_date"))+";";
					reportline+=invoice.getPatientUid()+";";
					reportline+=invoice.getInvoiceNumber()+";";
					if(invoice.getPatient()!=null){
						reportline+=invoice.getPatient().getFullName()+";";
						if(invoice.getPatient().getActivePrivate()!=null){
							reportline+=((AdminPrivateContact)invoice.getPatient().getActivePrivate()).telephone+";";
						}
						else{
							reportline+=";";
						}
					}
					else{
						reportline+=";;";
					}
					reportline+=invoice.getPatientAmount()+";";
					reportline+=invoice.getAmountPaid()+";";
					reportline+=invoice.getBalance()+";";
					reportline+=invoice.getEstimatedDeliveryDate()+";\r\n";
					report.add(reportline);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return report;
	}

	public static Vector getInsuranceReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ORDER DATE;";
		reportline+="SALES ORDER NR;";
		reportline+="INSURANCE NR;";
		reportline+="INSURANCE NAME;";
		reportline+="CUSTOMER NAME;";
		reportline+="IP NR;";
		reportline+="ITEM CODE;";
		reportline+="TOTAL AMOUNT;";
		reportline+="INVOICE STATUS;";
		reportline+="SALES EMPLOYEE;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null){
							reportline="";
							reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
							if(productionOrder.getDebetUid()!=null){
								Debet debet = Debet.get(productionOrder.getDebetUid());
								if(debet!=null && debet.getPatientInvoice()!=null && debet.getPrestation()!=null && debet.getInsurarAmount()>0 && debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
									reportline+=debet.getPatientInvoiceUid()+";";
									reportline+=debet.getInsurance().getInsurarUid()+";";
									reportline+=debet.getInsurance().getInsurar().getName()+";";
									reportline+=debet.getPatientInvoice().getPatient().getFullName()+";";
									reportline+=debet.getPatientInvoice().getPatientUid()+";";
									reportline+=debet.getPrestation().getCode()+";";
									reportline+=debet.getPatientInvoice().getInsurarAmount()+";";
									reportline+=debet.getPatientInvoice().getStatus()+";";
									reportline+=User.getFullUserName(debet.getUpdateUser())+";";
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getSalesAnalysisReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ORDER DATE;";
		reportline+="SALES ORDER NR;";
		reportline+="IP NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="UNIT AMOUNT;";
		reportline+="TOTAL AMOUNT;";
		reportline+="PATIENT AMOUNT;";
		reportline+="PATIENT AMOUNT PAID;";
		reportline+="PATIENT BALANCE AMOUNT;";
		reportline+="INVOICE STATUS;";
		reportline+="COST OF SALE;";
		reportline+="GROSS PROFIT;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null){
							reportline="";
							reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
							if(productionOrder.getDebetUid()!=null){
								Debet debet = Debet.get(productionOrder.getDebetUid());
								if(debet!=null && debet.getPatientInvoice()!=null && debet.getPrestation()!=null){
									reportline+=debet.getPatientInvoiceUid()+";";
									reportline+=debet.getPatientInvoice().getPatientUid()+";";
									reportline+=debet.getPatientInvoice().getPatient().getFullName()+";";
									reportline+=debet.getPrestation().getCode()+";";
									reportline+=debet.getPrestation().getDescription()+";";
									double totalamount=debet.getPatientInvoice().getPatientAmount()+debet.getPatientInvoice().getInsurarAmount()+debet.getPatientInvoice().getExtraInsurarAmount()+debet.getPatientInvoice().getExtraInsurarAmount2();
									reportline+=(totalamount)/debet.getQuantity()+";";
									reportline+=totalamount+";";
									reportline+=debet.getPatientInvoice().getPatientAmount()+";";
									double paid = debet.getPatientInvoice().getAmountPaid();
									if(paid>totalamount){
										paid=totalamount;
									}
									reportline+=paid+";";
									reportline+=(debet.getPatientInvoice().getPatientAmount()-paid)+";";
									reportline+=debet.getPatientInvoice().getStatus()+";";
									//Now we must calculate the cost of the raw materials
									double cost = 0;
									Vector materials = productionOrder.getMaterials();
									for(int q=0;q<materials.size();q++){
										ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(q);
										if(material!=null && material.getProductStock()!=null && material.getProductStock().getProduct()!=null){
											cost+=material.getQuantity()*material.getProductStock().getProduct().getLastYearsAveragePrice();
										}
									}									
									reportline+=cost+";";
									reportline+=(totalamount-cost)+";";
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}

}
