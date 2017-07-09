package be.openclinic.assets;

import be.openclinic.common.OC_Object;
import be.openclinic.util.Nomenclature;
import net.admin.Service;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;


public class Asset extends OC_Object {
    public int serverId;
    public int objectId;    

    public String code;
    public String gmdncode;
    public String parentUid;
    public String description; // OC_LABELS.OC_LABEL_ID
    public String serialnumber;
    public double quantity;
    public String assetType;
    public String supplierUid;
    public java.util.Date purchaseDate;
    public double purchasePrice;
    public String receiptBy;
    public String purchaseDocuments;
    public String writeOffMethod;
    public int writeOffPeriod; // years
    public String annuity;
    public String serviceuid;
    public String characteristics;
    public String accountingCode;
    public String gains; // xml : date, value
    public String losses; // xml : date, value
    public String residualValueHistory; // calculated, not in DB
    
    //*** loan ***
    public java.util.Date loanDate;
    public double loanAmount;
    public String loanInterestRate;
    public String loanReimbursementPlan; // date,capital,interest,totalAmount
    public double loanReimbursementAmount; // calculated, not in DB
    public String loanComment;
    public String loanDocuments;
    public String nomenclature;
    public String comment1;
    public String comment2;
    public String comment3;
    public String comment4;
    public String comment5;
    public String comment6;
    public String comment7;
    public String comment8;
    public String comment9;
    public String comment10;
    public String comment11;
    public String comment12;
    public String comment13;
    public String comment14;
    public String comment15;
    public String comment16;
    public String comment17;
    public String comment18;
    public String comment19;
    public String comment20;
    
    public java.util.Date saleDate;
    public double saleValue;
    public String saleClient;
    
    // search-criteria
    public java.util.Date purchasePeriodBegin, purchasePeriodEnd;
    
    
    //--- CONSTRUCTOR ---
    public Asset(){
        serverId = -1;
        objectId = -1;

        code = "";
        gmdncode ="";
        parentUid = "";
        description = "";
        serialnumber = "";
        quantity = 1; // default
        assetType = "";
        supplierUid = "";
        purchaseDate = null;
        purchasePrice = 0;
        receiptBy = "";
        purchaseDocuments = "";
        writeOffMethod = "";
        writeOffPeriod = 0;
        annuity = "";
        characteristics = "";
        accountingCode = "";
        gains = "";
        losses = "";
        serviceuid="";
        residualValueHistory = "";
        
        //*** loan ***
        loanDate = null;
        loanAmount = 0;
        loanInterestRate = ""; // text !
        loanReimbursementPlan = "";
        loanReimbursementAmount = 0;
        loanComment = "";
        loanDocuments = "";
        
        saleDate = null;
        saleValue = 0;
        saleClient = "";       
        nomenclature ="";
        comment1="";
        comment2="";
        comment3="";
        comment4="";
        comment5="";
        comment6="";
        comment7="";
        comment8="";
        comment9="";
        comment10="";
        comment11="";
        comment12="";
        comment13="";
        comment14="";
        comment15="";
        comment16="";
        comment17="";
        comment18="";
        comment19="";
        comment20="";
    }
    
    public String getComponentsString(String sWebLanguage){
	    String[] sComponents = ScreenHelper.checkString(getComment15()).split(";");
	    String sReturn="";
		for(int n=0;n<sComponents.length;n++){
			Nomenclature nomenclature = Nomenclature.get("assetcomponent", sComponents[n]);
			if(nomenclature!=null){
				sReturn+=nomenclature.getFullyQualifiedName(sWebLanguage)+"\n";
			}
		}
		return sReturn;
    }
    
    public boolean isAuthorizedUser(String userid){
    	Service service = getService();
    	return service==null || service.isAuthorizedUser(userid);
    }
    
    public String getServiceuid() {
		return serviceuid;
	}
    
    public Service getService(){
    	return Service.getService(getServiceuid());
    }
    
	public void setServiceuid(String serviceuid) {
		this.serviceuid = serviceuid;
	}

	public String getComment16() {
		return comment16;
	}

	public void setComment16(String comment16) {
		this.comment16 = comment16;
	}

	public String getComment17() {
		return comment17;
	}

	public void setComment17(String comment17) {
		this.comment17 = comment17;
	}

	public String getComment18() {
		return comment18;
	}

	public void setComment18(String comment18) {
		this.comment18 = comment18;
	}

	public String getComment19() {
		return comment19;
	}

	public void setComment19(String comment19) {
		this.comment19 = comment19;
	}

	public String getComment20() {
		return comment20;
	}

	public void setComment20(String comment20) {
		this.comment20 = comment20;
	}

	public int getServerId() {
		return serverId;
	}

	public void setServerId(int serverId) {
		this.serverId = serverId;
	}

	public int getObjectId() {
		return objectId;
	}

	public void setObjectId(int objectId) {
		this.objectId = objectId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getGmdncode() {
		return gmdncode;
	}

	public void setGmdncode(String gmdncode) {
		this.gmdncode = gmdncode;
	}

	public String getParentUid() {
		return parentUid;
	}

	public void setParentUid(String parentUid) {
		this.parentUid = parentUid;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getSerialnumber() {
		return serialnumber;
	}

	public void setSerialnumber(String serialnumber) {
		this.serialnumber = serialnumber;
	}

	public double getQuantity() {
		return quantity;
	}

	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}

	public String getAssetType() {
		return assetType;
	}

	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	public String getSupplierUid() {
		return supplierUid;
	}

	public void setSupplierUid(String supplierUid) {
		this.supplierUid = supplierUid;
	}

	public java.util.Date getPurchaseDate() {
		return purchaseDate;
	}

	public void setPurchaseDate(java.util.Date purchaseDate) {
		this.purchaseDate = purchaseDate;
	}

	public double getPurchasePrice() {
		return purchasePrice;
	}

	public void setPurchasePrice(double purchasePrice) {
		this.purchasePrice = purchasePrice;
	}

	public String getReceiptBy() {
		return receiptBy;
	}

	public void setReceiptBy(String receiptBy) {
		this.receiptBy = receiptBy;
	}

	public String getPurchaseDocuments() {
		return purchaseDocuments;
	}

	public void setPurchaseDocuments(String purchaseDocuments) {
		this.purchaseDocuments = purchaseDocuments;
	}

	public String getWriteOffMethod() {
		return writeOffMethod;
	}

	public void setWriteOffMethod(String writeOffMethod) {
		this.writeOffMethod = writeOffMethod;
	}

	public int getWriteOffPeriod() {
		return writeOffPeriod;
	}

	public void setWriteOffPeriod(int writeOffPeriod) {
		this.writeOffPeriod = writeOffPeriod;
	}

	public String getAnnuity() {
		return annuity;
	}

	public void setAnnuity(String annuity) {
		this.annuity = annuity;
	}

	public String getCharacteristics() {
		return characteristics;
	}

	public void setCharacteristics(String characteristics) {
		this.characteristics = characteristics;
	}

	public String getAccountingCode() {
		return accountingCode;
	}

	public void setAccountingCode(String accountingCode) {
		this.accountingCode = accountingCode;
	}

	public String getGains() {
		return gains;
	}

	public void setGains(String gains) {
		this.gains = gains;
	}

	public String getLosses() {
		return losses;
	}

	public void setLosses(String losses) {
		this.losses = losses;
	}

	public String getResidualValueHistory() {
		return residualValueHistory;
	}

	public void setResidualValueHistory(String residualValueHistory) {
		this.residualValueHistory = residualValueHistory;
	}

	public java.util.Date getLoanDate() {
		return loanDate;
	}

	public void setLoanDate(java.util.Date loanDate) {
		this.loanDate = loanDate;
	}

	public double getLoanAmount() {
		return loanAmount;
	}

	public void setLoanAmount(double loanAmount) {
		this.loanAmount = loanAmount;
	}

	public String getLoanInterestRate() {
		return loanInterestRate;
	}

	public void setLoanInterestRate(String loanInterestRate) {
		this.loanInterestRate = loanInterestRate;
	}

	public String getLoanReimbursementPlan() {
		return loanReimbursementPlan;
	}

	public void setLoanReimbursementPlan(String loanReimbursementPlan) {
		this.loanReimbursementPlan = loanReimbursementPlan;
	}

	public double getLoanReimbursementAmount() {
		return loanReimbursementAmount;
	}

	public void setLoanReimbursementAmount(double loanReimbursementAmount) {
		this.loanReimbursementAmount = loanReimbursementAmount;
	}

	public String getLoanComment() {
		return loanComment;
	}

	public void setLoanComment(String loanComment) {
		this.loanComment = loanComment;
	}

	public String getLoanDocuments() {
		return loanDocuments;
	}

	public void setLoanDocuments(String loanDocuments) {
		this.loanDocuments = loanDocuments;
	}

	public String getNomenclature() {
		return nomenclature;
	}

	public void setNomenclature(String nomenclature) {
		this.nomenclature = nomenclature;
	}

	public String getComment1() {
		return comment1;
	}

	public void setComment1(String comment1) {
		this.comment1 = comment1;
	}

	public String getComment2() {
		return comment2;
	}

	public void setComment2(String comment2) {
		this.comment2 = comment2;
	}

	public String getComment3() {
		return comment3;
	}

	public void setComment3(String comment3) {
		this.comment3 = comment3;
	}

	public String getComment4() {
		return comment4;
	}

	public void setComment4(String comment4) {
		this.comment4 = comment4;
	}

	public String getComment5() {
		return comment5;
	}

	public void setComment5(String comment5) {
		this.comment5 = comment5;
	}

	public String getComment6() {
		return comment6;
	}

	public void setComment6(String comment6) {
		this.comment6 = comment6;
	}

	public String getComment7() {
		return comment7;
	}

	public void setComment7(String comment7) {
		this.comment7 = comment7;
	}

	public String getComment8() {
		return comment8;
	}

	public void setComment8(String comment8) {
		this.comment8 = comment8;
	}

	public String getComment9() {
		return comment9;
	}

	public void setComment9(String comment9) {
		this.comment9 = comment9;
	}

	public String getComment10() {
		return comment10;
	}

	public void setComment10(String comment10) {
		this.comment10 = comment10;
	}

	public String getComment11() {
		return comment11;
	}

	public void setComment11(String comment11) {
		this.comment11 = comment11;
	}

	public String getComment12() {
		return comment12;
	}

	public void setComment12(String comment12) {
		this.comment12 = comment12;
	}

	public String getComment13() {
		return comment13;
	}

	public void setComment13(String comment13) {
		this.comment13 = comment13;
	}

	public String getComment14() {
		return comment14;
	}

	public void setComment14(String comment14) {
		this.comment14 = comment14;
	}

	public String getComment15() {
		return comment15;
	}

	public void setComment15(String comment15) {
		this.comment15 = comment15;
	}

	public boolean isInactive(){
		return isInactive(new java.util.Date());
	}
	
	public boolean isInactive(java.util.Date date){
		return getSaleDate()!=null && !getSaleDate().after(date);
	}
	
	public java.util.Date getSaleDate() {
		return saleDate;
	}

	public void setSaleDate(java.util.Date saleDate) {
		this.saleDate = saleDate;
	}

	public double getSaleValue() {
		return saleValue;
	}

	public void setSaleValue(double saleValue) {
		this.saleValue = saleValue;
	}

	public String getSaleClient() {
		return saleClient;
	}

	public void setSaleClient(String saleClient) {
		this.saleClient = saleClient;
	}

	public java.util.Date getPurchasePeriodBegin() {
		return purchasePeriodBegin;
	}

	public void setPurchasePeriodBegin(java.util.Date purchasePeriodBegin) {
		this.purchasePeriodBegin = purchasePeriodBegin;
	}

	public java.util.Date getPurchasePeriodEnd() {
		return purchasePeriodEnd;
	}

	public void setPurchasePeriodEnd(java.util.Date purchasePeriodEnd) {
		this.purchasePeriodEnd = purchasePeriodEnd;
	}

	//--- GET CODE --------------------------------------------------------------------------------
    public static String getCode(String sAssetUID){
    	String sAssetCode = "";

        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_ASSET_CODE FROM OC_ASSETS"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUID.substring(0,sAssetUID.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUID.substring(sAssetUID.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
            	sAssetCode = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
    	return sAssetCode;
    }
    
    public boolean existDefaultMaintenancePlans(){
    	boolean bExist =false;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps=null;
    	ResultSet rs=null;
    	try{
            if(ScreenHelper.checkString(getNomenclature()).length()>0){
            	ps=conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=?");
            	ps.setString(1, getNomenclature());
            	rs=ps.executeQuery();
            	if(rs.next()){
            		bExist=true;
            	}
            }
    	}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
    	return bExist;
    }
    
    public void setDefaultMaintenancePlans(){
    	if(!existDefaultMaintenancePlans()){
    		return;
    	}
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps=null;
    	ResultSet rs=null;
    	try{
            if(ScreenHelper.checkString(getNomenclature()).length()>0){
                //Add the default maintenance plans to this new asset
                ps=conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_enddate=? where oc_maintenanceplan_assetuid=? and oc_maintenanceplan_enddate is null");
                ps.setDate(1, new java.sql.Date(new java.util.Date().getTime()));
                ps.setString(2, getUid());
                ps.execute();
                ps.close();
                ps=conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=?");
                ps.setString(1, getNomenclature());
                rs=ps.executeQuery();
                while(rs.next()){
                	MaintenancePlan plan = new MaintenancePlan();
                	plan.setUid("-1");
                	plan.setAssetUID(getUid());
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
                	plan.setCreateDateTime(new java.util.Date());
                	plan.setFrequency(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                	plan.setInstructions(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                	plan.setName(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                	plan.setOperator(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                	plan.setPlanManager(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                	plan.setStartDate(new java.util.Date());
                	plan.setType(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                	plan.setVersion(1);
                	plan.store(getUpdateUser());
                }
            }
    	}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
    }
        
    //--- STORE -----------------------------------------------------------------------------------
    public boolean store(String userUid){
        boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSql;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                
        try{            
            if(getUid().equals("-1")){                  
                // insert new asset
                sSql = "INSERT INTO oc_assets(OC_ASSET_SERVERID,OC_ASSET_OBJECTID,OC_ASSET_CODE,"+
                       " OC_ASSET_PARENTUID,OC_ASSET_DESCRIPTION,OC_ASSET_SERIAL,OC_ASSET_QUANTITY,OC_ASSET_TYPE,"+
                       " OC_ASSET_SUPPLIERUID,OC_ASSET_PURCHASEDATE,OC_ASSET_PURCHASEPRICE,OC_ASSET_PURCHASERECEIPTBY,"+
                       " OC_ASSET_PURCHASEDOCS,OC_ASSET_WRITEOFFMETHOD,OC_ASSET_WRITEOFFPERIOD,OC_ASSET_ANNUITY,OC_ASSET_CHARACTERISTICS,"+
                       " OC_ASSET_ACCOUNTINGCODE,OC_ASSET_GAINS,OC_ASSET_LOSSES,OC_ASSET_LOANDATE,OC_ASSET_LOANAMOUNT,"+
                       " OC_ASSET_LOANINTERESTRATE,OC_ASSET_LOANREIMBURSEMENTPLAN,OC_ASSET_LOANCOMMENT,OC_ASSET_LOANDOCS,"+
                       " OC_ASSET_SALEDATE,OC_ASSET_SALEVALUE,OC_ASSET_SALECLIENT,OC_ASSET_UPDATETIME,OC_ASSET_UPDATEID,OC_ASSET_GMDNCODE,"
                       + "OC_ASSET_NOMENCLATURE,OC_ASSET_COMMENT1,OC_ASSET_COMMENT2,OC_ASSET_COMMENT3,OC_ASSET_COMMENT4,OC_ASSET_COMMENT5"
                       + ",OC_ASSET_COMMENT6,OC_ASSET_COMMENT7,OC_ASSET_COMMENT8,OC_ASSET_COMMENT9,OC_ASSET_COMMENT10,OC_ASSET_COMMENT11"
                       + ",OC_ASSET_COMMENT12,OC_ASSET_COMMENT13,OC_ASSET_COMMENT14,OC_ASSET_COMMENT15,OC_ASSET_COMMENT16,OC_ASSET_COMMENT17"
                       + ",OC_ASSET_COMMENT18,OC_ASSET_COMMENT19,OC_ASSET_COMMENT20,OC_ASSET_SERVICE)"+
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // 31
                ps = oc_conn.prepareStatement(sSql);
                
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId"),
                    objectId = MedwanQuery.getInstance().getOpenclinicCounter("OC_ASSETS");
                this.setUid(serverId+"."+objectId);
                                
                int psIdx = 1;
                ps.setInt(psIdx++,serverId);
                ps.setInt(psIdx++,objectId);
                ps.setString(psIdx++,code);
                ps.setString(psIdx++,parentUid);
                ps.setString(psIdx++,description);
                ps.setString(psIdx++,serialnumber);
                ps.setDouble(psIdx++,quantity);
                ps.setString(psIdx++,assetType);
                ps.setString(psIdx++,supplierUid);

                // purchaseDate date might be unspecified
                if(purchaseDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(purchaseDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,purchasePrice);
                ps.setString(psIdx++,receiptBy);
                ps.setString(psIdx++,purchaseDocuments);
                ps.setString(psIdx++,writeOffMethod);
                ps.setInt(psIdx++,writeOffPeriod);
                ps.setString(psIdx++,annuity);
                ps.setString(psIdx++,characteristics);
                ps.setString(psIdx++,accountingCode);
                ps.setString(psIdx++,gains);
                ps.setString(psIdx++,losses);
                
                //*** loan ***
                // loanDate date might be unspecified
                if(loanDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(loanDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,loanAmount);
                ps.setString(psIdx++,loanInterestRate);
                ps.setString(psIdx++,loanReimbursementPlan);
                //ps.setDouble(psIdx++,loanReimbursementAmount); // calculated
                ps.setString(psIdx++,loanComment);
                ps.setString(psIdx++,loanDocuments);
                                
                // saleDate date might be unspecified
                if(saleDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(saleDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }

                ps.setDouble(psIdx++,saleValue);
                ps.setString(psIdx++,saleClient);
                     
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setString(psIdx++,gmdncode);
                ps.setString(psIdx++,nomenclature);
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setString(psIdx++,comment6);
                ps.setString(psIdx++,comment7);
                ps.setString(psIdx++,comment8);
                ps.setString(psIdx++,comment9);
                ps.setString(psIdx++,comment10);
                ps.setString(psIdx++,comment11);
                ps.setString(psIdx++,comment12);
                ps.setString(psIdx++,comment13);
                ps.setString(psIdx++,comment14);
                ps.setString(psIdx++,comment15);
                ps.setString(psIdx++,comment16);
                ps.setString(psIdx++,comment17);
                ps.setString(psIdx++,comment18);
                ps.setString(psIdx++,comment19);
                ps.setString(psIdx++,comment20);
                ps.setString(psIdx,serviceuid);

                ps.executeUpdate();
            } 
            else{
                // update existing record
                sSql = "UPDATE oc_assets SET"+
                       "  OC_ASSET_CODE = ?, OC_ASSET_PARENTUID = ?, OC_ASSET_DESCRIPTION = ?, OC_ASSET_SERIAL = ?,"+
                       "  OC_ASSET_QUANTITY = ?, OC_ASSET_TYPE = ?, OC_ASSET_SUPPLIERUID = ?, OC_ASSET_PURCHASEDATE = ?,"+
                       "  OC_ASSET_PURCHASEPRICE = ?, OC_ASSET_PURCHASERECEIPTBY = ?, OC_ASSET_PURCHASEDOCS = ?,"+
                       "  OC_ASSET_WRITEOFFMETHOD = ?, OC_ASSET_WRITEOFFPERIOD = ?, OC_ASSET_ANNUITY = ?, OC_ASSET_CHARACTERISTICS = ?,"+
                       "  OC_ASSET_ACCOUNTINGCODE = ?, OC_ASSET_GAINS = ?, OC_ASSET_LOSSES = ?, OC_ASSET_LOANDATE = ?,"+
                       "  OC_ASSET_LOANAMOUNT = ?, OC_ASSET_LOANINTERESTRATE = ?, OC_ASSET_LOANREIMBURSEMENTPLAN = ?,"+
                       "  OC_ASSET_LOANCOMMENT = ?, OC_ASSET_LOANDOCS = ?, OC_ASSET_SALEDATE = ?, OC_ASSET_SALEVALUE = ?,"+
                       "  OC_ASSET_SALECLIENT = ?, OC_ASSET_UPDATETIME = ?, OC_ASSET_UPDATEID = ?, OC_ASSET_GMDNCODE=?"+ 
                       "  , OC_ASSET_NOMENCLATURE = ?, OC_ASSET_COMMENT1=?, OC_ASSET_COMMENT2=?, OC_ASSET_COMMENT3=?, OC_ASSET_COMMENT4=?"+
                       "  , OC_ASSET_COMMENT5=?, OC_ASSET_COMMENT6=?, OC_ASSET_COMMENT7=?, OC_ASSET_COMMENT8=?, OC_ASSET_COMMENT9=?"+
                       "  , OC_ASSET_COMMENT10=?, OC_ASSET_COMMENT11=?, OC_ASSET_COMMENT12=?, OC_ASSET_COMMENT13=?, OC_ASSET_COMMENT14=?"+
                       "  , OC_ASSET_COMMENT15=?, OC_ASSET_COMMENT16=?, OC_ASSET_COMMENT17=?, OC_ASSET_COMMENT18=?, OC_ASSET_COMMENT19=?"+
                       "  , OC_ASSET_COMMENT20=?, OC_ASSET_SERVICE=?"+// update-info
                       " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)"; // identification
                ps = oc_conn.prepareStatement(sSql);

                int psIdx = 1;
                ps.setString(psIdx++,code);
                ps.setString(psIdx++,parentUid);
                ps.setString(psIdx++,description);
                ps.setString(psIdx++,serialnumber);
                ps.setDouble(psIdx++,quantity);
                ps.setString(psIdx++,assetType);
                ps.setString(psIdx++,supplierUid);

                // purchaseDate date might be unspecified
                if(purchaseDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(purchaseDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,purchasePrice);
                ps.setString(psIdx++,receiptBy);
                ps.setString(psIdx++,purchaseDocuments);
                ps.setString(psIdx++,writeOffMethod);
                ps.setInt(psIdx++,writeOffPeriod);
                ps.setString(psIdx++,annuity);
                ps.setString(psIdx++,characteristics);
                ps.setString(psIdx++,accountingCode);
                ps.setString(psIdx++,gains);
                ps.setString(psIdx++,losses);

                //*** loan ***
                // loanDate date might be unspecified
                if(loanDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(loanDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,loanAmount);
                ps.setString(psIdx++,loanInterestRate);
                ps.setString(psIdx++,loanReimbursementPlan);
                //ps.setDouble(psIdx++,loanReimbursementAmount); // calculated
                ps.setString(psIdx++,loanComment);
                ps.setString(psIdx++,loanDocuments);

                // saleDate date might be unspecified
                if(saleDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(saleDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }

                ps.setDouble(psIdx++,saleValue);
                ps.setString(psIdx++,saleClient);

                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setString(psIdx++,gmdncode);
                ps.setString(psIdx++,nomenclature);
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setString(psIdx++,comment6);
                ps.setString(psIdx++,comment7);
                ps.setString(psIdx++,comment8);
                ps.setString(psIdx++,comment9);
                ps.setString(psIdx++,comment10);
                ps.setString(psIdx++,comment11);
                ps.setString(psIdx++,comment12);
                ps.setString(psIdx++,comment13);
                ps.setString(psIdx++,comment14);
                ps.setString(psIdx++,comment15);
                ps.setString(psIdx++,comment16);
                ps.setString(psIdx++,comment17);
                ps.setString(psIdx++,comment18);
                ps.setString(psIdx++,comment19);
                ps.setString(psIdx++,comment20);
                ps.setString(psIdx++,serviceuid);
                
                // where
                ps.setInt(psIdx++,Integer.parseInt(getUid().substring(0,getUid().indexOf("."))));
                ps.setInt(psIdx,Integer.parseInt(getUid().substring(getUid().indexOf(".")+1)));
                
                ps.executeUpdate();
            }           
        }
        catch(Exception e){
            errorOccurred = true;
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
        
        return errorOccurred;
    }
    
    //--- DELETE ----------------------------------------------------------------------------------
    public static boolean delete(String sAssetUid){
        boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "DELETE FROM oc_assets"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));
            
            ps.executeUpdate();
        }
        catch(Exception e){
            errorOccurred = true;
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return errorOccurred;
    }
    
    //--- GET -------------------------------------------------------------------------------------
    public static Asset get(Asset asset){
        return get(asset.getUid());
    }
       
    public static Asset get(String sAssetUid){
        Asset asset = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM oc_assets"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_SERVERID")+"."+rs.getString("OC_ASSET_OBJECTID"));
                asset.serverId = Integer.parseInt(rs.getString("OC_ASSET_SERVERID"));
                asset.objectId = Integer.parseInt(rs.getString("OC_ASSET_OBJECTID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.gmdncode              = ScreenHelper.checkString(rs.getString("OC_ASSET_GMDNCODE"));
                asset.parentUid         = ScreenHelper.checkString(rs.getString("OC_ASSET_PARENTUID"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.serialnumber      = ScreenHelper.checkString(rs.getString("OC_ASSET_SERIAL"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                asset.purchaseDate      = rs.getDate("OC_ASSET_PURCHASEDATE");
                asset.purchasePrice     = rs.getDouble("OC_ASSET_PURCHASEPRICE");                
                asset.receiptBy         = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASERECEIPTBY"));
                asset.purchaseDocuments = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASEDOCS"));
                asset.writeOffMethod    = ScreenHelper.checkString(rs.getString("OC_ASSET_WRITEOFFMETHOD"));
                asset.writeOffPeriod    = rs.getInt("OC_ASSET_WRITEOFFPERIOD");
                asset.annuity           = ScreenHelper.checkString(rs.getString("OC_ASSET_ANNUITY"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                asset.accountingCode    = ScreenHelper.checkString(rs.getString("OC_ASSET_ACCOUNTINGCODE"));
                asset.gains             = ScreenHelper.checkString(rs.getString("OC_ASSET_GAINS"));
                asset.losses            = ScreenHelper.checkString(rs.getString("OC_ASSET_LOSSES"));
                //asset.residualValueHistory = calculateResidualValueHistory();
                
                //*** loan ***
                asset.loanDate              = rs.getDate("OC_ASSET_LOANDATE");
                asset.loanAmount            = rs.getDouble("OC_ASSET_LOANAMOUNT");
                asset.loanInterestRate      = rs.getString("OC_ASSET_LOANINTERESTRATE");
                asset.loanReimbursementPlan = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANREIMBURSEMENTPLAN"));
                //asset.loanReimbursementAmount = calculateReimbursementAmount();
                asset.loanComment           = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANCOMMENT"));
                asset.loanDocuments         = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANDOCS"));
                
                asset.saleDate   = rs.getDate("OC_ASSET_SALEDATE");
                asset.saleValue  = rs.getDouble("OC_ASSET_SALEVALUE");
                asset.saleClient = ScreenHelper.checkString(rs.getString("OC_ASSET_SALECLIENT")); 
                
                // update-info
                asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
                asset.setServiceuid(rs.getString("OC_ASSET_SERVICE"));
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return asset;
    }
        
    //--- GET LIST --------------------------------------------------------------------------------
    public static List<Asset> getList(){
        return getList(new Asset());         
    }
    
    public static List<Asset> getList(Asset findItem){
        List<Asset> foundObjects = new LinkedList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyyMMdd");
        
        try{
            //*** compose query ***************************
            String sSql = "SELECT * FROM oc_assets WHERE 1=1"; // 'where' facilitates further composition of query

            // search-criteria 
            if(findItem.code.length() > 0){
                sSql+= " AND (OC_ASSET_CODE = '"+findItem.code+"' or OC_ASSET_SERVERID||'.'||OC_ASSET_OBJECTID = '"+findItem.code+"')";
            }
            if(ScreenHelper.checkString(findItem.description).length() > 0){
                sSql+= " AND OC_ASSET_DESCRIPTION LIKE '%"+findItem.description+"%'";
            }
            if(ScreenHelper.checkString(findItem.serviceuid).length() > 0){
                sSql+= " AND OC_ASSET_SERVICE LIKE '"+findItem.serviceuid+"%'";
            }
            if(ScreenHelper.checkString(findItem.serialnumber).length() > 0){
                sSql+= " AND OC_ASSET_SERIAL LIKE '%"+findItem.serialnumber+"%'";
            }
            if(ScreenHelper.checkString(findItem.assetType).length() > 0){
                sSql+= " AND OC_ASSET_TYPE = '"+findItem.assetType+"'";
            }
            if(ScreenHelper.checkString(findItem.comment9).length() > 0){
                sSql+= " AND OC_ASSET_COMMENT9 = '"+findItem.comment9+"'";
            }
            if(ScreenHelper.checkString(findItem.nomenclature).length() > 0){
                sSql+= " AND OC_ASSET_NOMENCLATURE LIKE '"+findItem.nomenclature+"%'";
            }
            if(ScreenHelper.checkString(findItem.nomenclature).length() > 0){
                sSql+= " AND OC_ASSET_NOMENCLATURE LIKE '"+findItem.nomenclature+"%'";
            }
            if(ScreenHelper.checkString(findItem.comment15).length() > 0){
                sSql+= " AND OC_ASSET_COMMENT15 LIKE '%"+findItem.comment15+";%'";
            }
            if(ScreenHelper.checkString(findItem.comment16).length() > 0){
                sSql+= " AND EXISTS (select * from OC_ASSETCOMPONENTS where OC_COMPONENT_ASSETUID=OC_ASSET_SERVERID||'.'||OC_ASSET_OBJECTID and OC_COMPONENT_NOMENCLATURE like '"+(ScreenHelper.checkString(findItem.comment15).length()==0?"%":findItem.comment15)+"' and OC_COMPONENT_STATUS='"+findItem.comment16+"')";
            }
            if(ScreenHelper.checkString(findItem.supplierUid).length() > 0){
                sSql+= " AND OC_ASSET_SUPPLIERUID = '"+findItem.supplierUid+"'";
            }

            // purchase date
            if(findItem.purchasePeriodBegin!=null && findItem.purchasePeriodEnd!=null){
                sSql+= " AND ("+
                       "  OC_ASSET_PURCHASEDATE BETWEEN '"+sqlDateFormat.format(findItem.purchasePeriodBegin)+"' AND"+
                       "                                '"+sqlDateFormat.format(findItem.purchasePeriodEnd)+"'"+
                       " )";
            }
            else if(findItem.purchasePeriodBegin!=null){
                sSql+= " AND (OC_ASSET_PURCHASEDATE >= '"+sqlDateFormat.format(findItem.purchasePeriodBegin)+"')";
            }
            else if(findItem.purchasePeriodEnd!=null){
                sSql+= " AND (OC_ASSET_PURCHASEDATE < '"+sqlDateFormat.format(findItem.purchasePeriodEnd)+"')";
            }
            
            Debug.println("\n"+sSql+"\n");
            sSql+= " ORDER BY OC_ASSET_CODE ASC";
            
            ps = oc_conn.prepareStatement(sSql);
            
                        
            //*** execute query ***************************
            rs = ps.executeQuery();
            Asset asset;
            
            while(rs.next()){
                asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_SERVERID")+"."+rs.getString("OC_ASSET_OBJECTID"));
                asset.serverId = Integer.parseInt(rs.getString("OC_ASSET_SERVERID"));
                asset.objectId = Integer.parseInt(rs.getString("OC_ASSET_OBJECTID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.gmdncode              = ScreenHelper.checkString(rs.getString("OC_ASSET_GMDNCODE"));
                asset.parentUid         = ScreenHelper.checkString(rs.getString("OC_ASSET_PARENTUID"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.serialnumber      = ScreenHelper.checkString(rs.getString("OC_ASSET_SERIAL"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                asset.purchaseDate      = rs.getDate("OC_ASSET_PURCHASEDATE");
                asset.purchasePrice     = rs.getDouble("OC_ASSET_PURCHASEPRICE");                
                asset.receiptBy         = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASERECEIPTBY"));
                asset.purchaseDocuments = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASEDOCS"));
                asset.writeOffMethod    = ScreenHelper.checkString(rs.getString("OC_ASSET_WRITEOFFMETHOD"));
                asset.writeOffPeriod    = rs.getInt("OC_ASSET_WRITEOFFPERIOD");
                asset.annuity           = ScreenHelper.checkString(rs.getString("OC_ASSET_ANNUITY"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                asset.accountingCode    = ScreenHelper.checkString(rs.getString("OC_ASSET_ACCOUNTINGCODE"));
                asset.gains             = ScreenHelper.checkString(rs.getString("OC_ASSET_GAINS"));
                asset.losses            = ScreenHelper.checkString(rs.getString("OC_ASSET_LOSSES"));
                //asset.residualValueHistory = calculateResidualValueHistory();
                
                //*** loan ***
                asset.loanDate              = rs.getDate("OC_ASSET_LOANDATE");
                asset.loanAmount            = rs.getDouble("OC_ASSET_LOANAMOUNT");
                asset.loanInterestRate      = rs.getString("OC_ASSET_LOANINTERESTRATE");
                asset.loanReimbursementPlan = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANREIMBURSEMENTPLAN"));
                //asset.loanReimbursementAmount = calculateReimbursementAmount();
                asset.loanComment           = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANCOMMENT"));
                asset.loanDocuments         = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANDOCS"));
                
                asset.saleDate   = rs.getDate("OC_ASSET_SALEDATE");
                asset.saleValue  = rs.getDouble("OC_ASSET_SALEVALUE");
                asset.saleClient = ScreenHelper.checkString(rs.getString("OC_ASSET_SALECLIENT")); 
                
                // update-info
                asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
                asset.setServiceuid(rs.getString("OC_ASSET_SERVICE"));
                
                foundObjects.add(asset);
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return foundObjects;
    }
    
    //--- CALCULATE RESIDUAL VALUE HISTORY --------------------------------------------------------
    // todo : OPTIMIZE ALGORITHM ?????????!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public String calculateResidualValueHistory(String sWebLanguage){
        String sHistory = "";
        
        if(this.purchaseDate!=null && this.purchasePrice > 0 && this.writeOffPeriod > 0){
            double writeOffAmount = this.purchasePrice / this.writeOffPeriod;
            DecimalFormat deci = new DecimalFormat("0.00");
            		
            sHistory = "<table cellpadding='1' cellspacing='1' border='0' style='background:#fff;'>";
            
            // 1st day of every fiscal year until value=0
            double value = this.purchasePrice;
            int startYear = Integer.parseInt(new SimpleDateFormat("yyyy").format(this.purchaseDate));
            int year = startYear;
            
            int colCount = 0;
            int maxColCount = MedwanQuery.getInstance().getConfigInt("assets.residualvaluehistory.maxcolcount",4);
            while(value >= writeOffAmount && colCount <= this.writeOffPeriod){
                value-= writeOffAmount;
                year++;

                if(colCount%maxColCount==0){
                	colCount = 0;
                	sHistory+= "<tr>"; // new row when 4 columns have been drawn
                }
                colCount++;

	            sHistory+= "<td style='background:#ccc'>&nbsp;"+year+"&nbsp;:&nbsp;</td>"+
	                       "<td style='background:#C3D9FF;text-align:right;width:90px'>"+ScreenHelper.padLeft(deci.format(value)," ",8)+" "+MedwanQuery.getInstance().getConfigParam("currency","")+"</td>";

	            // add empty 'cols'
	            if(writeOffAmount > value){
		            for(int i=0; i<(maxColCount-colCount); i++){
		                sHistory+= "<td style='background:#C3D9FF;'>&nbsp;</td>";
		            }
	            }
	            
                if(colCount%maxColCount==0){
                	sHistory+= "</tr>";
                }
            }

            // fill last row, if needed
            if(colCount > 0){
	            for(int i=0; i<(maxColCount-colCount); i++){
	                sHistory+= "<td style='background:#C3D9FF;'>&nbsp;</td>";
	            }
            }
            
            sHistory+= "</table>";
        }
        
        return sHistory;
    }
    
    //--- CALCULATE REIMBURSEMENT TOTALS ----------------------------------------------------------
    public double[] calculateReimbursementTotals(){
        double capitalTotal = -1, interestTotal = -1, totalAmount = -1;
        
        if(this.loanReimbursementPlan.length() > 0){
        	// init
        	capitalTotal = 0;
        	interestTotal = 0;
        	totalAmount = 0;
            
            // sum the total amount of each part of the reimbursement plan
            Vector plans = parseLoanReimbursementPlans(this.loanReimbursementPlan);
 
            String sCapital, sInterest;
            double capital, interest, planAmount;
            Element planElem;
            
            for(int i=0; i<plans.size(); i++){
                planElem = (Element)plans.get(i);
    
                sCapital  = ScreenHelper.checkString(planElem.elementText("Capital"));
                sInterest = ScreenHelper.checkString(planElem.elementText("Interest"));
                
                // single plan
                capital = Double.parseDouble(sCapital);
                interest = Double.parseDouble(sInterest);                
                planAmount = (capital+interest);
                
                // all plans
                capitalTotal+= Double.parseDouble(sCapital);
                interestTotal+= Double.parseDouble(sInterest);
                totalAmount+= planAmount;
            }
        }
        
        return new double[]{capitalTotal,interestTotal,totalAmount};
    }
    
    //--- PARSE LOAN REIMBURSEMENT PLANS ----------------------------------------------------------
    /*
        <ReimbursementPlans>
            <Plan>
                <Date>01/05/2013</Date>
                <Capital>20000</Capital>
                <Interest>3.25</Interest>
            </Plan>
        </ReimbursementPlans>
    */    
    private Vector parseLoanReimbursementPlans(String sLoanReimbursementPlans){
        Vector plans = new Vector();

        if(sLoanReimbursementPlans.length() > 0){
            try{
                // parse plans from xml           
                SAXReader reader = new SAXReader(false);
                Document document = reader.read(new StringReader(sLoanReimbursementPlans));
                Element plansElem = document.getRootElement();
         
                if(plansElem!=null){  
                    Iterator plansIter = plansElem.elementIterator("Plan");
        
                    String sTmpDate, sTmpCapital, sTmpInterest;
                    Element planElem;
                    String[] plan;
                    
                    while(plansIter.hasNext()){
                        planElem = (Element)plansIter.next();
                                                
                        //sTmpDate     = ScreenHelper.checkString(planElem.elementText("Date"));
                        //sTmpCapital  = ScreenHelper.checkString(planElem.elementText("Capital"));
                        //sTmpInterest = ScreenHelper.checkString(planElem.elementText("Interest"));
                        
                        //plan = new String[]{sTmpDate,sTmpCapital,sTmpInterest};
                        //plans.add(plan);
                        
                        plans.add(planElem);
                    }
                }
            }
            catch(Exception e){
                if(Debug.enabled) e.printStackTrace();
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }
                
        return plans;
    }

    public String getSupplierName(){
    	return getSupplierName(getSupplierUid());
    }
    
    //--- GET SUPPLIER NAME -----------------------------------------------------------------------
    public String getSupplierName(String sSupplierUid){
        if(ScreenHelper.checkString(sSupplierUid).length()==0){
        	return "";
        }
        String sSupplierName = ""; 
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_SUPPLIER_NAME"+
                          " FROM oc_suppliers"+
                          "  WHERE (OC_SUPPLIER_SERVERID = ? AND OC_SUPPLIER_OBJECTID = ?)";            
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sSupplierUid.substring(0,sSupplierUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sSupplierUid.substring(sSupplierUid.indexOf(".")+1)));
            
            rs = ps.executeQuery();            
            if(rs.next()){
                sSupplierName = ScreenHelper.checkString(rs.getString("OC_SUPPLIER_NAME"));
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return sSupplierName;
    }
    
    //--- GET PARENT CODE -------------------------------------------------------------------------
    public String getParentCode(String sAssetUid){
        String sParentCode = ""; 
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_ASSET_CODE"+
                          " FROM oc_assets"+
                          "  WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";            
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));
            
            rs = ps.executeQuery();            
            if(rs.next()){
                sParentCode = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return sParentCode;
    }
    
}
