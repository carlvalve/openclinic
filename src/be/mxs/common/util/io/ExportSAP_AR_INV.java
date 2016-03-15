package be.mxs.common.util.io;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Mail;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.finance.Insurar;

public class ExportSAP_AR_INV {

	public static void setExchangeRate(String currency,String date,String exchangerate){
		setExchangeRate(currency, ScreenHelper.getSQLDate(date), Double.parseDouble(exchangerate));
	}
	
	public static void setExchangeRate(String currency,java.util.Date date,double exchangerate){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("delete from OC_EXCHANGERATES where OC_EXCHANGERATE_DATE=? and OC_EXCHANGERATE_CURRENCY=?");
			ps.setDate(1, new java.sql.Date(date.getTime()));
			ps.setString(2, currency);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement("insert into OC_EXCHANGERATES(OC_EXCHANGERATE_DATE,OC_EXCHANGERATE_CURRENCY,OC_EXCHANGERATE_RATE) values(?,?,?)");
			ps.setDate(1, new java.sql.Date(date.getTime()));
			ps.setString(2, currency);
			ps.setDouble(3, exchangerate);
			ps.execute();
			if(ps!= null) ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static double getExchangeRate(String currency,java.util.Date date){
		return getExchangeRate(currency,date,true);
	}
	
	public static double getExchangeRate(String currency,java.util.Date date,boolean last){
		double exchangerate=-1;
		java.util.Date currdate = ScreenHelper.getSQLDate(ScreenHelper.getSQLDate(date));
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select OC_EXCHANGERATE_RATE from OC_EXCHANGERATES where OC_EXCHANGERATE_DATE=? and OC_EXCHANGERATE_CURRENCY=?");
			ps.setDate(1, new java.sql.Date(currdate.getTime()));
			ps.setString(2, currency);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				exchangerate=rs.getDouble("OC_EXCHANGERATE_RATE");
			}
			else {
				try{
					if(MedwanQuery.getInstance().getConfigString("SAPDatabaseClass","").length()>0){
					    Class.forName(MedwanQuery.getInstance().getConfigString("SAPDatabaseClass"));			
					    Connection sapconn =  DriverManager.getConnection(MedwanQuery.getInstance().getConfigString("SAPDatabaseURL"));
				    	PreparedStatement pssap = sapconn.prepareStatement("select Rate from ORTT where Currency=? and RateDate=?");
				    	pssap.setString(1, currency);
				    	pssap.setDate(2, new java.sql.Date(currdate.getTime()));
				    	ResultSet rssap = pssap.executeQuery();
				    	if(!rssap.next()){
				    		System.out.print("MISSING EXCHANGE RATE FOR "+new SimpleDateFormat("dd/MM/yyyy").format(currdate)+" - ABORTING PROCESS");
				    		if(last){
								rs.close();
								ps.close();
								ps = conn.prepareStatement("select OC_EXCHANGERATE_RATE from OC_EXCHANGERATES where OC_EXCHANGERATE_DATE<? and OC_EXCHANGERATE_CURRENCY=? order by OC_EXCHANGERATE_DATE DESC");
								ps.setDate(1, new java.sql.Date(currdate.getTime()));
								ps.setString(2, currency);
								rs = ps.executeQuery();
								if(rs.next()){
									exchangerate=rs.getDouble("OC_EXCHANGERATE_RATE");
								}
				    		}
				    	}
				    	else{
				    		exchangerate=rssap.getDouble("Rate");
							rs.close();
							ps.close();
					    	ps = conn.prepareStatement("insert into OC_EXCHANGERATES(OC_EXCHANGERATE_DATE,OC_EXCHANGERATE_CURRENCY,OC_EXCHANGERATE_RATE) values(?,?,?)");
							ps.setDate(1, new java.sql.Date(currdate.getTime()));
							ps.setString(2, currency);
							ps.setDouble(3, exchangerate);
							ps.execute();
				    	}
				    	if(rssap !=null) rssap.close();
				    	if(pssap !=null) pssap.close();
				    	sapconn.close();
					}
					else if(last){
						rs.close();
						ps.close();
						ps = conn.prepareStatement("select OC_EXCHANGERATE_RATE from OC_EXCHANGERATES where OC_EXCHANGERATE_DATE<? and OC_EXCHANGERATE_CURRENCY=? order by OC_EXCHANGERATE_DATE DESC");
						ps.setDate(1, new java.sql.Date(currdate.getTime()));
						ps.setString(2, currency);
						rs = ps.executeQuery();
						if(rs.next()){
							exchangerate=rs.getDouble("OC_EXCHANGERATE_RATE");
						}
					}
				}
				catch(Exception s){
					if(Debug.enabled) s.printStackTrace();
					if(last){
						rs.close();
						ps.close();
						ps = conn.prepareStatement("select OC_EXCHANGERATE_RATE from OC_EXCHANGERATES where OC_EXCHANGERATE_DATE<? and OC_EXCHANGERATE_CURRENCY=? order by OC_EXCHANGERATE_DATE DESC");
						ps.setDate(1, new java.sql.Date(currdate.getTime()));
						ps.setString(2, currency);
						rs = ps.executeQuery();
						if(rs.next()){
							exchangerate=rs.getDouble("OC_EXCHANGERATE_RATE");
						}
					}
				}
			}
			if(rs!=null) rs.close();
			if(ps!= null) ps.close();
			conn.close();
		}
		catch(Exception e){
			if(Debug.enabled) e.printStackTrace();
		}
		return exchangerate;
	}
	
	public static void main(String[] args) {
		StringBuffer exportfile = new StringBuffer();
		long month=30*24*3600;
		month=month*1000;

		try{
			// This will load the MySQL driver, each DB has its own driver
		    System.out.println("driver="+args[0]);
		    System.out.println("url="+args[1]);
		    Class.forName(args[0]);			
		    Connection conn =  DriverManager.getConnection(args[1]);
		    Class.forName(args[2]);			
		    Connection sapconn =  DriverManager.getConnection(args[3]);
			Date lastexport = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse("19000101000000000");
			PreparedStatement ps = conn.prepareStatement("select oc_value from oc_config where oc_key='lastSAP_AR_INV_lastexport'");
		    ResultSet rs = ps.executeQuery();
		    if(rs.next()){
				lastexport = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(rs.getString("oc_value"));
		    }
		    System.out.println("lastSAP_AR_INV_export="+lastexport);
		    rs.close();
		    ps.close();
		    String exportSAPFolder_Documents="/temp";
		    ps = conn.prepareStatement("select oc_value from oc_config where oc_key='exportSAPFolder_Documents'");
		    rs = ps.executeQuery();
		    if(rs.next()){
		    	exportSAPFolder_Documents = rs.getString("oc_value");
		    }
		    rs.close();
		    ps.close();
		    String exportSAPFolder_DocumentLines="/temp";
		    ps = conn.prepareStatement("select oc_value from oc_config where oc_key='exportSAPFolder_DocumentLines'");
		    rs = ps.executeQuery();
		    if(rs.next()){
		    	exportSAPFolder_DocumentLines = rs.getString("oc_value");
		    }
		    rs.close();
		    ps.close();
		    java.util.Date mindate=new java.util.Date();
		    java.util.Date maxdate=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1990");
		    StringBuffer sDocuments = new StringBuffer();
		    StringBuffer sDocumentLines = new StringBuffer();
		    
		    //***********************
		    //STEP 1: cash invoices *
		    //***********************
		    //First find the patient income, everything will be combined in 1 document with 1 document line per product class
		    String sql = 	"select max(oc_patientinvoice_updatetime) maxdate,max(oc_patientinvoice_date) maxinvoicedate,sum(oc_debet_amount) amount,oc_prestation_invoicegroup from oc_patientinvoices i,oc_debets d,oc_prestations p"
		    				+ " where"
		    				+ " oc_patientinvoice_updatetime>? and"
		    				+ " oc_patientinvoice_updatetime<? and"
		    				+ " oc_patientinvoice_status='closed' and"
		    				+ " oc_debet_patientinvoiceuid='1.'+convert(varchar,oc_patientinvoice_objectid) and"
		    				+ " (oc_debet_extrainsuraruid2 is null or oc_debet_extrainsuraruid2='') and"
		    				+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','')"
		    				+ " group by oc_prestation_invoicegroup";
		    ps = conn.prepareStatement(sql);
		    ps.setTimestamp(1, new java.sql.Timestamp(lastexport.getTime()));
		    ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
		    rs = ps.executeQuery();
		    boolean bInitialized=false;
		    int nDocNum=0;
		    int linecounter=0;
		    double totalamount=0;
		    java.util.Date dDate=null;
		    java.util.Date dMaxInvoiceDate=null;
		    while(rs.next()){
		    	if(!bInitialized){
		    		//Print a cash payment line to Documents
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCurrency;DocRate;Reference1;Series\r\n");
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCur;DocRate;Ref1;Series\r\n");
		    		nDocNum=getOpenclinicCounter(conn,"OC_INVOICES");
		    		
		    		sDocumentLines.append("ParentKey;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		sDocumentLines.append("DocNum;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		bInitialized=true;
		    	}
		    	String incomeclass=rs.getString("oc_prestation_invoicegroup");
		    	Double amount = rs.getDouble("amount");
		    	sDocumentLines.append(nDocNum+";");
		    	sDocumentLines.append(linecounter+";");
		    	linecounter++;
		    	sDocumentLines.append(rs.getString("oc_prestation_invoicegroup")+";");
		    	sDocumentLines.append("1;");
		    	sDocumentLines.append(amount+";");
		    	sDocumentLines.append("TZS;1\r\n");
		    	
		    	dDate = rs.getTimestamp("maxdate");
		    	dMaxInvoiceDate= rs.getDate("maxinvoicedate");
		    	//Check existance of exchange rate in sap
		    	PreparedStatement pssap = sapconn.prepareStatement("select * from ORTT where Currency=? and RateDate=?");
		    	pssap.setString(1, args[4]);
		    	pssap.setDate(2, new java.sql.Date(dMaxInvoiceDate.getTime()));
		    	ResultSet rssap = pssap.executeQuery();
		    	if(!rssap.next()){
		    		System.out.print("MISSING EXCHANGE RATE FOR "+new SimpleDateFormat("dd/MM/yyyy").format(dMaxInvoiceDate)+" - ABORTING PROCESS");
		    		Thread.sleep(5000);
		    		return;
		    	}
		    	rssap.close();
		    	pssap.close();
		    	if(maxdate.before(dDate)){
		    		maxdate=dDate;
		    	}
		    	totalamount+=amount;
		    }
		    rs.close();
		    ps.close();
		    if(bInitialized){
	    		sDocuments.append(nDocNum+";");
	    		sDocuments.append("dDocument_Items;");
	    		sDocuments.append("tYES;");
	    		sDocuments.append("psYes;");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
	    		sDocuments.append(totalamount+";");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
		    	sDocuments.append(getConfigValue(conn,"SAP_AR_CashCardCode","noop")+";");
	    		sDocuments.append("TZS;1;");
	    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
	    		sDocuments.append("-1\r\n");
		    }
		    
		    //**************************
		    //STEP 2: insurer invoices *
		    //**************************
		    sql = 	"select oc_insurarinvoice_insuraruid,oc_insurarinvoice_updatetime,oc_insurarinvoice_date,sum(oc_debet_insuraramount) amount,oc_insurarinvoice_objectid,oc_prestation_invoicegroup from oc_insurarinvoices i,oc_debets d,oc_prestations p"
    				+ " where"
    				+ " oc_insurarinvoice_updatetime>? and"
    				+ " oc_insurarinvoice_updatetime<? and"
    				+ " oc_insurarinvoice_status='closed' and"
    				+ " oc_debet_insurarinvoiceuid='1.'+convert(varchar,oc_insurarinvoice_objectid) and"
    				+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','')"
    				+ " group by oc_insurarinvoice_insuraruid,oc_insurarinvoice_updatetime,oc_insurarinvoice_date,oc_insurarinvoice_objectid,oc_prestation_invoicegroup";
		    int activeinsurarinvoice=-1;
		    ps = conn.prepareStatement(sql);
		    ps.setTimestamp(1, new java.sql.Timestamp(lastexport.getTime()));
		    ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
		    rs = ps.executeQuery();
		    totalamount=0;
		    linecounter=0;
		    String insuraruid="";
		    while(rs.next()){
		    	if(!bInitialized){
		    		//Print a cash payment line to Documents
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCurrency;DocRate;Reference1;Series\r\n");
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCur;DocRate;Ref1;Series\r\n");
		    		
		    		sDocumentLines.append("ParentKey;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		sDocumentLines.append("DocNum;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		bInitialized=true;
		    	}
		    	int insurarinvoice = rs.getInt("oc_insurarinvoice_objectid");
		    	if(activeinsurarinvoice==-1){
		    		activeinsurarinvoice=insurarinvoice;
		    	}
		    	if(activeinsurarinvoice!=insurarinvoice){
		    		//We have to add a document
		    		sDocuments.append(activeinsurarinvoice+";");
		    		sDocuments.append("dDocument_Items;");
		    		sDocuments.append("tYES;");
		    		sDocuments.append("psYes;");
		    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
		    		sDocuments.append(totalamount+";");
		    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
		    		Insurar insurar = Insurar.get(conn,insuraruid);
			    	sDocuments.append((insurar==null?"noop":insurar.getAccountingCode())+";");
		    		sDocuments.append("TZS;1;");
		    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
		    		sDocuments.append("-1\r\n");
		    		activeinsurarinvoice=insurarinvoice;
		    		linecounter=0;
		    	}
		    	insuraruid=rs.getString("oc_insurarinvoice_insuraruid");
		    	String incomeclass=rs.getString("oc_prestation_invoicegroup");
		    	Double amount = rs.getDouble("amount");
		    	sDocumentLines.append(activeinsurarinvoice+";");
		    	sDocumentLines.append(linecounter+";");
		    	linecounter++;
		    	sDocumentLines.append(rs.getString("oc_prestation_invoicegroup")+";");
		    	sDocumentLines.append("1;");
		    	sDocumentLines.append(amount+";");
		    	sDocumentLines.append("TZS;1\r\n");
		    	
		    	dDate = rs.getTimestamp("oc_insurarinvoice_updatetime");
		    	dMaxInvoiceDate=rs.getDate("oc_insurarinvoice_date");
		    	//Check existance of exchange rate in sap
		    	PreparedStatement pssap = sapconn.prepareStatement("select * from ORTT where Currency=? and RateDate=?");
		    	pssap.setString(1, args[4]);
		    	pssap.setDate(2, new java.sql.Date(dMaxInvoiceDate.getTime()));
		    	ResultSet rssap = pssap.executeQuery();
		    	if(!rssap.next()){
		    		System.out.print("MISSING EXCHANGE RATE FOR "+new SimpleDateFormat("dd/MM/yyyy").format(dMaxInvoiceDate)+" - ABORTING PROCESS");
		    		Thread.sleep(5000);
		    		return;
		    	}
		    	rssap.close();
		    	pssap.close();
		    	if(maxdate.before(dDate)){
		    		maxdate=dDate;
		    	}
		    	totalamount+=amount;
		    }
		    if(activeinsurarinvoice>-1){
	    		//We have to add a document
	    		sDocuments.append(activeinsurarinvoice+";");
	    		sDocuments.append("dDocument_Items;");
	    		sDocuments.append("tYES;");
	    		sDocuments.append("psYes;");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
	    		sDocuments.append(totalamount+";");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
	    		Insurar insurar = Insurar.get(conn,insuraruid);
		    	sDocuments.append((insurar==null?"noop":insurar.getAccountingCode())+";");
	    		sDocuments.append("TZS;1;");
	    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
	    		sDocuments.append("-1\r\n");
		    }
		    
		    //********************************
		    //STEP 3: extra insurer invoices *
		    //********************************
		    sql = 	"select oc_insurarinvoice_insuraruid,oc_insurarinvoice_updatetime,sum(oc_debet_extrainsuraramount) amount,oc_insurarinvoice_objectid,oc_prestation_invoicegroup from oc_extrainsurarinvoices i,oc_debets d,oc_prestations p"
    				+ " where"
    				+ " oc_insurarinvoice_updatetime>? and"
    				+ " oc_insurarinvoice_updatetime<? and"
    				+ " oc_insurarinvoice_status='closed' and"
    				+ " oc_debet_extrainsurarinvoiceuid='1.'+convert(varchar,oc_insurarinvoice_objectid) and"
    				+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','')"
    				+ " group by oc_insurarinvoice_insuraruid,oc_insurarinvoice_updatetime,oc_insurarinvoice_objectid,oc_prestation_invoicegroup";
		    activeinsurarinvoice=-1;
		    ps = conn.prepareStatement(sql);
		    ps.setTimestamp(1, new java.sql.Timestamp(lastexport.getTime()));
		    ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
		    rs = ps.executeQuery();
		    totalamount=0;
		    linecounter=0;
		    insuraruid="";
		    while(rs.next()){
		    	if(!bInitialized){
		    		//Print a cash payment line to Documents
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCurrency;DocRate;Reference1;Series\r\n");
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCur;DocRate;Ref1;Series\r\n");
		    		
		    		sDocumentLines.append("ParentKey;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		sDocumentLines.append("DocNum;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		bInitialized=true;
		    	}
		    	int insurarinvoice = rs.getInt("oc_insurarinvoice_objectid");
		    	if(activeinsurarinvoice==-1){
		    		activeinsurarinvoice=insurarinvoice;
		    	}
		    	if(activeinsurarinvoice!=insurarinvoice){
		    		//We have to add a document
		    		sDocuments.append(activeinsurarinvoice+";");
		    		sDocuments.append("dDocument_Items;");
		    		sDocuments.append("tYES;");
		    		sDocuments.append("psYes;");
		    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
		    		sDocuments.append(totalamount+";");
		    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
		    		Insurar insurar = Insurar.get(conn,insuraruid);
			    	sDocuments.append((insurar==null?"noop":insurar.getAccountingCode())+";");
		    		sDocuments.append("TZS;1;");
		    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
		    		sDocuments.append("-1\r\n");
		    		activeinsurarinvoice=insurarinvoice;
		    		linecounter=0;
		    	}
		    	insuraruid=rs.getString("oc_insurarinvoice_insuraruid");
		    	String incomeclass=rs.getString("oc_prestation_invoicegroup");
		    	Double amount = rs.getDouble("amount");
		    	sDocumentLines.append(activeinsurarinvoice+";");
		    	sDocumentLines.append(linecounter+";");
		    	linecounter++;
		    	sDocumentLines.append(rs.getString("oc_prestation_invoicegroup")+";");
		    	sDocumentLines.append("1;");
		    	sDocumentLines.append(amount+";");
		    	sDocumentLines.append("TZS;1\r\n");
		    	
		    	dDate = rs.getTimestamp("oc_insurarinvoice_updatetime");
		    	dMaxInvoiceDate=rs.getDate("oc_insurarinvoice_date");
		    	//Check existance of exchange rate in sap
		    	PreparedStatement pssap = sapconn.prepareStatement("select * from ORTT where Currency=? and RateDate=?");
		    	pssap.setString(1, args[4]);
		    	pssap.setDate(2, new java.sql.Date(dMaxInvoiceDate.getTime()));
		    	ResultSet rssap = pssap.executeQuery();
		    	if(!rssap.next()){
		    		System.out.print("MISSING EXCHANGE RATE FOR "+new SimpleDateFormat("dd/MM/yyyy").format(dMaxInvoiceDate)+" - ABORTING PROCESS");
		    		Thread.sleep(5000);
		    		return;
		    	}
		    	rssap.close();
		    	pssap.close();
		    	if(maxdate.before(dDate)){
		    		maxdate=dDate;
		    	}
		    	totalamount+=amount;
		    }
		    if(activeinsurarinvoice>-1){
	    		//We have to add a document
	    		sDocuments.append(activeinsurarinvoice+";");
	    		sDocuments.append("dDocument_Items;");
	    		sDocuments.append("tYES;");
	    		sDocuments.append("psYes;");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
	    		sDocuments.append(totalamount+";");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
	    		Insurar insurar = Insurar.get(conn,insuraruid);
		    	sDocuments.append((insurar==null?"noop":insurar.getAccountingCode())+";");
	    		sDocuments.append("TZS;1;");
	    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
	    		sDocuments.append("-1\r\n");
		    }
		    
		    //***********************************
		    //STEP 4: patient coverage invoices *
		    //***********************************
		    sql = 	"select oc_insurarinvoice_insuraruid,oc_insurarinvoice_updatetime,sum(oc_debet_amount) amount,oc_insurarinvoice_objectid,oc_prestation_invoicegroup from oc_extrainsurarinvoices2 i,oc_debets d,oc_prestations p"
    				+ " where"
    				+ " oc_insurarinvoice_updatetime>? and"
    				+ " oc_insurarinvoice_updatetime<? and"
    				+ " oc_insurarinvoice_status='closed' and"
    				+ " oc_debet_extrainsurarinvoiceuid2='1.'+convert(varchar,oc_insurarinvoice_objectid) and"
    				+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','')"
    				+ " group by oc_insurarinvoice_insuraruid,oc_insurarinvoice_updatetime,oc_insurarinvoice_objectid,oc_prestation_invoicegroup";
		    activeinsurarinvoice=-1;
		    ps = conn.prepareStatement(sql);
		    ps.setTimestamp(1, new java.sql.Timestamp(lastexport.getTime()));
		    ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
		    rs = ps.executeQuery();
		    totalamount=0;
		    linecounter=0;
		    insuraruid="";
		    while(rs.next()){
		    	if(!bInitialized){
		    		//Print a cash payment line to Documents
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCurrency;DocRate;Reference1;Series\r\n");
		    		sDocuments.append("DocNum;DocType;HandWritten;Printed;DocDate;DocTotal;DocDueDate;CardCode;DocCur;DocRate;Ref1;Series\r\n");
		    		
		    		sDocumentLines.append("ParentKey;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		sDocumentLines.append("DocNum;LineNum;ItemCode;Quantity;Price;Currency;Rate\r\n");
		    		bInitialized=true;
		    	}
		    	int insurarinvoice = rs.getInt("oc_insurarinvoice_objectid");
		    	if(activeinsurarinvoice==-1){
		    		activeinsurarinvoice=insurarinvoice;
		    	}
		    	if(activeinsurarinvoice!=insurarinvoice){
		    		//We have to add a document
		    		sDocuments.append(activeinsurarinvoice+";");
		    		sDocuments.append("dDocument_Items;");
		    		sDocuments.append("tYES;");
		    		sDocuments.append("psYes;");
		    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
		    		sDocuments.append(totalamount+";");
		    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
		    		Insurar insurar = Insurar.get(conn,insuraruid);
			    	sDocuments.append((insurar==null?"noop":insurar.getAccountingCode())+";");
		    		sDocuments.append("TZS;1;");
		    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
		    		sDocuments.append("-1\r\n");
		    		activeinsurarinvoice=insurarinvoice;
		    		linecounter=0;
		    	}
		    	insuraruid=rs.getString("oc_insurarinvoice_insuraruid");
		    	String incomeclass=rs.getString("oc_prestation_invoicegroup");
		    	Double amount = rs.getDouble("amount");
		    	sDocumentLines.append(activeinsurarinvoice+";");
		    	sDocumentLines.append(linecounter+";");
		    	linecounter++;
		    	sDocumentLines.append(rs.getString("oc_prestation_invoicegroup")+";");
		    	sDocumentLines.append("1;");
		    	sDocumentLines.append(amount+";");
		    	sDocumentLines.append("TZS;1\r\n");
		    	
		    	dDate = rs.getTimestamp("oc_insurarinvoice_updatetime");
		    	dMaxInvoiceDate=rs.getDate("oc_insurarinvoice_date");
		    	//Check existance of exchange rate in sap
		    	PreparedStatement pssap = sapconn.prepareStatement("select * from ORTT where Currency=? and RateDate=?");
		    	pssap.setString(1, args[4]);
		    	pssap.setDate(2, new java.sql.Date(dMaxInvoiceDate.getTime()));
		    	ResultSet rssap = pssap.executeQuery();
		    	if(!rssap.next()){
		    		System.out.print("MISSING EXCHANGE RATE FOR "+new SimpleDateFormat("dd/MM/yyyy").format(dMaxInvoiceDate)+" - ABORTING PROCESS");
		    		Thread.sleep(5000);
		    		return;
		    	}
		    	rssap.close();
		    	pssap.close();
		    	if(maxdate.before(dDate)){
		    		maxdate=dDate;
		    	}
		    	totalamount+=amount;
		    }
		    if(activeinsurarinvoice>-1){
	    		//We have to add a document
	    		sDocuments.append(activeinsurarinvoice+";");
	    		sDocuments.append("dDocument_Items;");
	    		sDocuments.append("tYES;");
	    		sDocuments.append("psYes;");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(dMaxInvoiceDate)+";");
	    		sDocuments.append(totalamount+";");
	    		sDocuments.append(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date(dMaxInvoiceDate.getTime()+month))+";");
	    		Insurar insurar = Insurar.get(conn,insuraruid);
		    	sDocuments.append((insurar==null?"noop":insurar.getAccountingCode())+";");
	    		sDocuments.append("TZS;1;");
	    		sDocuments.append(new SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date())+";");
	    		sDocuments.append("-1\r\n");
		    }
		    
		    
		    if(bInitialized){
	    		String fileid = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date());
	    		String filename = exportSAPFolder_Documents+"/OINV."+fileid+".csv";
				System.out.println("sending message to: "+filename);
				BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(filename));
				bufferedWriter.write(sDocuments.toString());
				bufferedWriter.flush();
				bufferedWriter.close();
				System.out.println("Message successfully sent");
				
	    		filename = exportSAPFolder_DocumentLines+"/INV1."+fileid+".csv";
	    		System.out.println("sending message to: "+filename);
				bufferedWriter = new BufferedWriter(new FileWriter(filename));
				bufferedWriter.write(sDocumentLines.toString());
				bufferedWriter.flush();
				bufferedWriter.close();
				System.out.println("Message successfully sent");
				
			    ps = conn.prepareStatement("update oc_config set oc_value=? where oc_key='lastSAP_AR_INV_lastexport'");
			    ps.setString(1,new SimpleDateFormat("yyyyMMddHHmmssSSS").format(maxdate));
			    if(getConfigValue(conn, "enableLastSAP_AR_INV_lastexportUpdate", "1").equalsIgnoreCase("1")){
			    	ps.execute();
			    }
			    ps.close();
				System.out.println("lastSAP_AR_INV_lastexport set to "+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(maxdate));

		    }
		    else{
		    	System.out.println("Nothing to do!");
		    }
		    
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	private static String getConfigValue(Connection conn, String key, String defaultValue) throws SQLException{
		String result=defaultValue;
		PreparedStatement ps = conn.prepareStatement("select oc_value from oc_config where oc_key=?");
		ps.setString(1,key);
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			result=rs.getString("oc_value");
		}
		rs.close();
		ps.close();
		return result;
	}
	
    public static int getOpenclinicCounter(Connection oc_conn, String name){
        int newCounter = 0;
        PreparedStatement ps=null;
        ResultSet rs=null;
        try{
        	ps = oc_conn.prepareStatement("select OC_COUNTER_VALUE from OC_COUNTERS where OC_COUNTER_NAME=?");
            ps.setString(1, name);
            rs = ps.executeQuery();
            if(rs.next()){
                newCounter = rs.getInt("OC_COUNTER_VALUE");
                if(newCounter==0){
                	newCounter=1;
                }
                rs.close();
                ps.close();
            } 
            else{
                rs.close();
                ps.close();
                newCounter = 1;
                ps = oc_conn.prepareStatement("insert into OC_COUNTERS(OC_COUNTER_NAME,OC_COUNTER_VALUE) values(?,1)");
                ps.setString(1, name);
                ps.execute();
                ps.close();
            }
            ps = oc_conn.prepareStatement("update OC_COUNTERS set OC_COUNTER_VALUE=? where OC_COUNTER_NAME=?");
            ps.setInt(1, newCounter+1);
            ps.setString(2, name);
            ps.execute();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
        	try{
        		if(rs!=null) rs.close();
        		if(ps!=null) ps.close();
        	}
        	catch(Exception e2){
        		e2.printStackTrace();
        	}
        }
       
        return newCounter;
    }

}
