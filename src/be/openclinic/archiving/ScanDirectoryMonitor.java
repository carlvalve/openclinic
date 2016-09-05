package be.openclinic.archiving;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.dcm4che2.data.DicomObject;
import org.dcm4che2.data.Tag;
import org.dcm4che2.data.VR;

import be.mxs.common.model.vo.IdentifierFactory;
import be.mxs.common.model.vo.healthrecord.ItemContextVO;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.model.vo.healthrecord.util.TransactionFactory;
import be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.MessageReader.User;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.AdminPerson;

public class ScanDirectoryMonitor implements Runnable{
	private boolean stopped = false;
	private int runCounter;
	private Thread thread;
	
	// config-values
	public static String SCANDIR_URL, SCANDIR_BASE, SCANDIR_FROM, SCANDIR_TO, SCANDIR_ERR, SCANDIR_DEL,SCAN_PREFIX;		
	public static int FILES_PER_DIRECTORY;
	public static long MONITORING_INTERVAL;
	public static String EXCLUDED_EXTENSIONS;
		
	private static final String ALPHABET = "abcdefghijklmnopqrstuvwxyz"; 
	private boolean OK_TO_START;
	private static Hashtable files = new Hashtable();
	
	
	//--- CONSTRUCTOR -----------------------------------------------------------------------------
	public ScanDirectoryMonitor(){
	}
	
	//--- ACTIVATE --------------------------------------------------------------------------------
	public void activate(){
		OK_TO_START = true;
		loadConfig();
		
		if(Debug.enabled){
			Debug.println("\n******************************************************************************************");
			Debug.println("******************************** ScanDirectoryMonitor ************************************");
			Debug.println("******************************************************************************************");
			Debug.println("'scanDirectoryMonitor_basePath'                   : "+SCANDIR_BASE);
			Debug.println("'scanDirectoryMonitor_dirFrom'                    : "+SCANDIR_FROM);
			Debug.println("'scanDirectoryMonitor_dirTo'                      : "+SCANDIR_TO);
			Debug.println("'scanDirectoryMonitor_dirError'                   : "+SCANDIR_ERR);
			Debug.println("'scanDirectoryMonitor_dirDeleted'                 : "+SCANDIR_DEL);
		    Debug.println("'scanDirectoryMonitor_filesPerDirectory'          : "+FILES_PER_DIRECTORY);
		    Debug.println("'scanDirectoryMonitor_interval'                   : "+MONITORING_INTERVAL+" millis");
		    Debug.println("'scanDirectoryMonitor_notScannableFileExtensions' : "+EXCLUDED_EXTENSIONS);
		    Debug.println("'scanDirectoryMonitor_url'                        : "+SCANDIR_URL);
		    Debug.println("'scanDirectoryMonitor_prefix'                     : "+SCAN_PREFIX);
		}
		
		runCounter = 0;

        // check dir BASE
		if(SCANDIR_BASE.length()==0){
		    Debug.println("WARNING : 'scanDirectoryMonitor_basePath' is not configured");
		    OK_TO_START = false;
	    }
		else{
	    	File scanDir = new File(SCANDIR_BASE);
	    	if(!scanDir.exists()){	
	    		scanDir.mkdir();
	    		Debug.println("INFO : 'scanDirectoryMonitor_basePath' created");
	    	}
	    }
		
        // check dir FROM
		if(SCANDIR_FROM.length()==0){
		    Debug.println("WARNING : 'scanDirectoryMonitor_dirFrom' is not configured");
		    OK_TO_START = false;
	    }
		else{
	    	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_FROM);
	    	if(!scanDir.exists()){	
	    		scanDir.mkdir();
	    		Debug.println("INFO : 'scanDirectoryMonitor_dirFrom' created");
	    	}
	    }

        // check dir TO
		if(SCANDIR_TO.length()==0){
		    Debug.println("WARNING : 'scanDirectoryMonitor_dirTo' is not configured");
		    OK_TO_START = false;
	    }
		else{
	    	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_TO);
	    	if(!scanDir.exists()){	
	    		scanDir.mkdir();
	    		Debug.println("INFO : 'scanDirectoryMonitor_dirTo' created");
	    	}
	    }

        // check dir ERR
		if(SCANDIR_ERR.length()==0){
		    Debug.println("WARNING : 'scanDirectoryMonitor_dirError' is not configured");
		    OK_TO_START = false;
	    }
		else{
	    	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_ERR);
	    	if(!scanDir.exists()){	
	    		scanDir.mkdir();
	    		Debug.println("INFO : 'scanDirectoryMonitor_dirError' created");
	    	}
	    }
		
        // check dir DEL
		if(SCANDIR_DEL.length()==0){
		    Debug.println("WARNING : 'scanDirectoryMonitor_dirDeleted' is not configured");
		    OK_TO_START = false;
	    }
		else{
	    	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_DEL);
	    	if(!scanDir.exists()){	
	    		scanDir.mkdir();
	    		Debug.println("INFO : 'scanDirectoryMonitor_dirDeleted' created");
	    	}
	    }
    	
		Debug.println("******************************************************************************************\n");
		//*** start thread ***
    	if(OK_TO_START){
			thread = new Thread(this);
			thread.start();
			
    		Debug.println("ScanDirectoryMonitor is active");
    	}
    	else{
    		Debug.println("ScanDirectoryMonitor NOT ACTIVE due to previous errors");
    	}
	}
	
	//--- LOAD CONFIG -----------------------------------------------------------------------------
	public static void loadConfig(){
		SCANDIR_URL  = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_url","scan");
		SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
		SCANDIR_FROM = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirFrom","from");
	    SCANDIR_TO   = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
	    SCANDIR_ERR  = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirError","error");
	    SCANDIR_DEL  = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirDeleted","deleted");
	    SCAN_PREFIX  = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_prefix","SCAN_");
				
		FILES_PER_DIRECTORY = MedwanQuery.getInstance().getConfigInt("scanDirectoryMonitor_filesPerDirectory",1024);
		MONITORING_INTERVAL = MedwanQuery.getInstance().getConfigInt("scanDirectoryMonitor_interval",30*1000);
	    EXCLUDED_EXTENSIONS = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_notScannableFileExtensions","").toLowerCase();
	}
			
	//--- IS ACTIVE -------------------------------------------------------------------------------
	public boolean isActive(){
		return !isStopped();
	}
	
	//--- STOPPED ---------------------------------------------------------------------------------
	public boolean isStopped(){
		return stopped;
	}

	public void setStopped(boolean stopped){
		this.stopped = stopped;
	}
	
	//--- RUN SCHEDULER ---------------------------------------------------------------------------
	public static void runScheduler(){	
        try{        
        	int acceptedFilesInRun = 0, faultyFilesInRun = 0, deniedFilesInRun = 0, skippedFilesInRun=0;
        	if(files.size()>5000){
        		files=new Hashtable();
        	}
        	Debug.enabled=MedwanQuery.getInstance().getConfigString("Debug","Off").equalsIgnoreCase("on");
        	Debug.println("File cache size: "+files.size());
        	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_FROM);
        	Debug.println("Scanning "+scanDir);
        	ScannableFileFilter fileFilter = new ScannableFileFilter(EXCLUDED_EXTENSIONS);        	
        	File[] scannableFiles = scanDir.listFiles(fileFilter); 
        	if(scannableFiles!=null && scannableFiles.length > 0){
	        	Debug.println(" ScannableFiles in 'scanDirectoryMonitor_dirFrom' : "+scannableFiles.length);
	        	for(int i=0; i<scannableFiles.length; i++){
	        		File file = (File)scannableFiles[i];
	        		long lastSize=0;
	        		boolean bSkip=!isFileUnlocked(file);
	        		if(bSkip){
	        			Debug.println("Skipping file "+file.getName()+" because a process may still be writing to it.");
	        			skippedFilesInRun++;
	        		}
	        		else {
		        		int result = storeFileInDB(file,(i+1));
		        		
		        	    if(result > 0){
		        	    	acceptedFilesInRun++;
		        	    }
		        	    else if(result < 0){
		        	    	faultyFilesInRun++;
		        	    }
	        	    	files.remove(file.getName());
	        		}
	        	}

	        	Debug.println("===> "+skippedFilesInRun+" skipped files");
	        	Debug.println("===> "+acceptedFilesInRun+" accepted files");
	        	Debug.println("===> "+faultyFilesInRun+" faulty files");
        	}
        	
        	// move files which are not scannable
        	deniedFilesInRun = moveNotScannableFiles();  
        	if(deniedFilesInRun > 0){
        	    Debug.println("===> "+deniedFilesInRun+" denied files");
        	}
        	
        	// remove files which were deleted more than a week ago, by using the double-scan-files-module 
        	removeOldDeletedFiles();
        }
        catch(Exception e){
            e.printStackTrace();
        }
	}
    
    //--- STORE FILE IN DataBase ------------------------------------------------------------------
    // meta-data in DB
    // file itself as file in 'scanDirectoryTo'
    public static int storeFileInDB(File file, int fileIdx){
        return storeFileInDB(file,false,fileIdx);	
    }
    
    public static int storePdfDocument(File file){
		//****************************************************************************
		// Find out if it is a Pdf document with a valid QR code inside
		//****************************************************************************
    	try{
	    	String barcode = PdfBarcode.getBarcodeFromDocument(file);
	    	if(barcode.length()==11){
	    		String sUDI = barcode;
	    		if(validUDI(sUDI)){
	        		//*** CONDITIONAL READ ******************************************
		        	// check existence of archive-document
		        	ArchiveDocument existingDoc = ArchiveDocument.get(sUDI);
	        		if(existingDoc!=null){
			        	// check existence of linked file
	        			if(existingDoc.storageName.length() > 0){
	                        File existingFile = new File(SCANDIR_BASE+"/"+SCANDIR_TO+"/"+existingDoc.storageName);
			        		if(existingFile.exists()){
			        			//*** ARCH_DOC FOUND, WITH EXISTING LINKED FILE ***
				        	    Debug.println("WARNING : A file '"+existingDoc.storageName+"' exists for the archive-document with UDI '"+existingDoc.udi+"'."+
				        	                  " --> incoming file '"+file.getName()+"' is a double file.");
				        	    
				        	    // must be read by a person before overwriting the existing file
					        	File errFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/DOUBLE_"+file.getName().replaceAll(SCAN_PREFIX,""));
				        	    moveFile(file,errFile);
						        Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
						        return -1; // err
			        		}
			        		else{
			        			//*** ARCH_DOC FOUND, WITHOUT EXISTING LINKED FILE ***
				        	    Debug.println("INFO : An archive-document with UDI '"+existingDoc.udi+"' exists, but its linked file does not."+
			        		                  " --> saved incoming file as file for the archive-document");
				        	    acceptIncomingFile(sUDI,file);
				        	    return 1; // acc
			        		}
		        		}
		        		else{
		        			//*** ARCH_DOC FOUND, WITHOUT REGISTERED LINKED FILE ***
			        	    Debug.println("INFO : An archive-document with UDI '"+existingDoc.udi+"' exists and it has no linked file."+
		        		                  " --> saved incoming file as file for the archive-document");
			        	    acceptIncomingFile(sUDI,file);
			        	    return 1; // acc
		        		}
	        		}
	        		else{
	        			//*** NO ARCH_DOC FOUND ***
		        	    Debug.println("WARNING : No archive-document with UDI '"+sUDI+"' found."+
	 		        	              " --> incoming file '"+file.getName()+"' is an orphan. Register an archive-document first.");
		        	    
		        	    // an archive-document, to attach the scan to, must be created first
			        	File errFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/ORPHAN_"+file.getName().replaceAll(SCAN_PREFIX,""));
		        	    moveFile(file,errFile);
				        Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
				        return -1; // err
	        		}
	    		}
	    		else{
	    			//*** UDI NOT VALID ***
	        	    Debug.println("WARNING : UDI '"+sUDI+"' is not valid (~ 9 first digit MOD 97 = last 2 digits).");
	        	    
		        	File errFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/INVUDI_"+file.getName().replaceAll(SCAN_PREFIX,""));
	        	    moveFile(file,errFile);
			        Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
			        return -1; // err
	    		}
	    	}
		}
		catch(Exception e){
			e.printStackTrace();
		}
    	return -1;
    }
    
    public static int storeGenericDocument(File file, boolean forced){
		//****************************************************************************
		// Find out if the filename is a valid identifier
		//****************************************************************************
        try{
    	    String sUDI = "00000000000"+file.getName();
	        Debug.println("--> UDI1 : "+sUDI);
    	    //Remove extension
	        if(sUDI.lastIndexOf(".")>0){
	        	sUDI=sUDI.substring(0,sUDI.lastIndexOf("."));
	        }
	        Debug.println("--> UDI2 : "+sUDI);
    	    //Only take last 11 characters
	        if(sUDI.length()>=11){
	        	sUDI=sUDI.substring(sUDI.length()-11);
	        }
	        Debug.println("--> UDI3 : "+sUDI);
	        
	        if(sUDI.length()==11){
        		if(validUDI(sUDI)){
		        	if(!forced){	
		        		//*** CONDITIONAL READ ******************************************
			        	// check existence of archive-document
			        	ArchiveDocument existingDoc = ArchiveDocument.get(sUDI);
		        		if(existingDoc!=null){
				        	// check existence of linked file
		        			if(existingDoc.storageName.length() > 0){
		                        File existingFile = new File(SCANDIR_BASE+"/"+SCANDIR_TO+"/"+existingDoc.storageName);
				        		if(existingFile.exists()){
				        			//*** ARCH_DOC FOUND, WITH EXISTING LINKED FILE ***
					        	    Debug.println("WARNING : A file '"+existingDoc.storageName+"' exists for the archive-document with UDI '"+existingDoc.udi+"'."+
					        	                  " --> incoming file '"+file.getName()+"' is a double file.");
					        	    
					        	    // must be read by a person before overwriting the existing file
						        	File errFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/DOUBLE_"+file.getName().replaceAll(SCAN_PREFIX,""));
					        	    moveFile(file,errFile);
							        Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
							        return -1; // err
				        		}
				        		else{
				        			//*** ARCH_DOC FOUND, WITHOUT EXISTING LINKED FILE ***
					        	    Debug.println("INFO : An archive-document with UDI '"+existingDoc.udi+"' exists, but its linked file does not."+
				        		                  " --> saved incoming file as file for the archive-document");
					        	    acceptIncomingFile(sUDI,file);
					        	    return 1; // acc
				        		}
			        		}
			        		else{
			        			//*** ARCH_DOC FOUND, WITHOUT REGISTERED LINKED FILE ***
				        	    Debug.println("INFO : An archive-document with UDI '"+existingDoc.udi+"' exists and it has no linked file."+
			        		                  " --> saved incoming file as file for the archive-document");
				        	    acceptIncomingFile(sUDI,file);
				        	    return 1; // acc
			        		}
		        		}
		        		else{
		        			//*** NO ARCH_DOC FOUND ***
			        	    Debug.println("WARNING : No archive-document with UDI '"+sUDI+"' found."+
         		        	              " --> incoming file '"+file.getName()+"' is an orphan. Register an archive-document first.");
			        	    
			        	    // an archive-document, to attach the scan to, must be created first
				        	File errFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/ORPHAN_"+file.getName().replaceAll(SCAN_PREFIX,""));
			        	    moveFile(file,errFile);
					        Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
					        return -1; // err
		        		}
		        	}
		        	else{
		        		//*** UN-CONDITIONAL READ ***************************************
	        			acceptIncomingFile(sUDI,file);
	        			return -1; // acc
		        	}
        		}
        		else{
        			//*** UDI NOT VALID ***
	        	    Debug.println("WARNING : UDI '"+sUDI+"' is not valid (~ 9 first digit MOD 97 = last 2 digits).");
	        	    
		        	File errFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/INVUDI_"+file.getName().replaceAll(SCAN_PREFIX,""));
	        	    moveFile(file,errFile);
			        Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
			        return -1; // err
        		}
	        }
	        else{
	        	//*** INVALID UDI ***
	        	Debug.println("WARNING : Invalid UDI; length must be 11");
	        	
		        File noscanFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/INVUDI_"+file.getName().replaceAll(SCAN_PREFIX,""));
		    	moveFile(file,noscanFile);
			    Debug.println("--> moved file to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
			    return -1; // err
	        }
        }
        catch(Exception e){
        	Debug.printStackTrace(e);
        }
        return 0;
    }
    
    public static boolean isFileUnlocked(File file){
    	boolean bUnlocked=false;
    	String originalFileName = file.getAbsolutePath();
    	File newFile = new File(originalFileName+".renamed");
    	Debug.println("Original absolute file path: "+file.getAbsolutePath());
    	Debug.println("Destination absolute file path: "+newFile.getAbsolutePath());
    	Debug.println("Renaming file "+file.getName()+" to "+newFile.getName());
    	if(file.renameTo(newFile)){
        	Debug.println("Successfull, renaming file "+newFile.getName()+" to "+originalFileName);
    		if(newFile.renameTo(new File(originalFileName))){
            	Debug.println("Successfull, file is unlocked");
    			bUnlocked=true;
    		}
    		else {
            	Debug.println("Unsuccessfull, file is locked");
    		}
    	}
		else {
        	Debug.println("Unsuccessfull, file is locked");
		}
    	return bUnlocked;
    }
    
    public static int storeDICOMDocument(File file){
		//****************************************************************************
		// Find out if the file is a valid DICOM file
		//****************************************************************************
		int err=0;
    	DicomObject obj = Dicom.getDicomObject(file);
    	Debug.println("DICOM object: "+obj);
    	if(obj!=null){
        	Debug.println("Patient ID: "+obj.getString(Tag.PatientID));
        	int n = -1;
        	try{
        		n=Integer.parseInt(obj.getString(Tag.PatientID));
        	}
        	catch(Exception t){}
        	AdminPerson person = new AdminPerson();
        	if(n>-1){
        		person=AdminPerson.getAdminPerson(obj.getString(Tag.PatientID));
        	}
        	Debug.println("Patient Name: "+person.getFullName());
        	if(person.lastname.trim().length()>0){
	    		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	    		PreparedStatement ps=null;
	    		ResultSet rs=null;
	    		try{
		    		String studyUid=obj.getString(Tag.StudyInstanceUID);
		    		String seriesUid=obj.getString(Tag.SeriesNumber);
		    		if(seriesUid==null || seriesUid.trim().length()==0){
		    			seriesUid="1";
		    		}
		    		String sequence=obj.getString(Tag.InstanceNumber);
		    		if(sequence==null || sequence.trim().length()==0){
		    			sequence=file.getName();
		    		}
		    		//First check if file does not exist yet, do nothing if it exists 
		    		ps =conn.prepareStatement("select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? and OC_PACS_SEQUENCE=?");
		    		ps.setString(1, studyUid);
		    		ps.setString(2, seriesUid);
		    		ps.setString(3, sequence);
		    		rs =ps.executeQuery();
		    		if(rs.next()){
		    			Debug.println("Instance number "+sequence+" for study "+studyUid+" already exists");
		    			err=0;
		    			file.delete();
		    		}
		    		else {
		    			//file does not exist yet, insert it
		    			rs.close();
		    			ps.close();
		    			
		    			//check if study already exists, if not create a new TRANSACTION_TYPE_PACS document
			    		ps =conn.prepareStatement("select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=?");
			    		ps.setString(1, studyUid);
			    		ps.setString(2, seriesUid);
			    		rs =ps.executeQuery();
			    		if(!rs.next()){
			    			//Study does not exist, create the document
			    			TransactionVO transaction = new TransactionFactoryGeneral().createTransactionVO(MedwanQuery.getInstance().getUser(MedwanQuery.getInstance().getConfigString("defaultPACSuser","4")),"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS",false); 
			    			transaction.setCreationDate(new java.util.Date());
			    			transaction.setStatus(1);
			    			transaction.setTransactionId(MedwanQuery.getInstance().getOpenclinicCounter("TransactionID"));
			    			transaction.setServerId(MedwanQuery.getInstance().getConfigInt("serverId",1));
			    			transaction.setTransactionType("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
			    			transaction.setUpdateTime(new SimpleDateFormat("yyyyMMdd").parse(obj.getString(Tag.StudyDate)));
			    			transaction.setUser(MedwanQuery.getInstance().getUser(MedwanQuery.getInstance().getConfigString("defaultPACSuser","4")));
			    			transaction.setVersion(1);
			    			transaction.setItems(new Vector());
			    			ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
			    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID",studyUid,new Date(),itemContextVO));
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
			    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID",seriesUid,new Date(),itemContextVO));
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			String sDescription=ScreenHelper.checkString(obj.getString(Tag.StudyDescription));
			    			if(sDescription.trim().length()==0){
				    			sDescription=ScreenHelper.checkString(obj.getString(Tag.AcquisitionDeviceProcessingDescription));
			    			}
			    			if(sDescription.trim().length()==0){
				    			sDescription=ScreenHelper.checkString(obj.getString(Tag.CodeMeaning));
			    			}
			    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
			    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION",sDescription.replaceAll("\\^", ", "),new Date(),itemContextVO));
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			try{
				    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
				    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE",ScreenHelper.formatDate(new SimpleDateFormat("yyyyMMdd").parse(obj.getString(Tag.StudyDate))),new Date(),itemContextVO));
			    			}
			    			catch(Exception er){er.printStackTrace();}
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			try{
				    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
				    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESDATE",ScreenHelper.formatDate(new SimpleDateFormat("yyyyMMdd").parse(obj.getString(Tag.SeriesDate))),new Date(),itemContextVO));
			    			}
			    			catch(Exception er){er.printStackTrace();}
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
			    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY",ScreenHelper.checkString(obj.getString(Tag.Modality))+" - "+ScreenHelper.checkString(obj.getString(Tag.Manufacturer)),new Date(),itemContextVO));
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
			    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_PATIENTPOSITION",ScreenHelper.checkString(obj.getString(Tag.PatientPosition)),new Date(),itemContextVO));
			    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
			    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_REFMED",ScreenHelper.checkString(obj.getString(Tag.ReferringPhysicianName)),new Date(),itemContextVO));
	
			    			if(MedwanQuery.getInstance().getConfigInt("pacsTestLoad",0)==0){
			    				MedwanQuery.getInstance().updateTransaction(Integer.parseInt(obj.getString(Tag.PatientID)),transaction);
			    			}
			    			else{
			    				MedwanQuery.getInstance().updateTransaction(9966,transaction);
			    			}
			    		}
	
			    		String filename=ArchiveDocument.generateUDI(MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS"));
		    			filename = acceptIncomingDICOMFile(filename, file);
		    			
		    			ps=conn.prepareStatement("insert into OC_PACS(OC_PACS_STUDYUID,OC_PACS_SERIES,OC_PACS_SEQUENCE,OC_PACS_FILENAME,OC_PACS_UPDATETIME) values(?,?,?,?,?)");
			    		ps.setString(1, studyUid);
			    		ps.setString(2, seriesUid);
			    		ps.setString(3, sequence);
			    		ps.setString(4, filename);
			    		ps.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
			    		ps.execute();
			    		err=1;
		    		}
		    		rs.close();
		    		ps.close();
	    		}
	    		catch (Exception e){
	    			e.printStackTrace();
	    			err=-1;
	    		}
	    		finally{
	    			try{
	    				if(rs!=null) rs.close();
	    				if(ps!=null) ps.close();
	    				if(conn!=null) conn.close();
	    			}
	    			catch(Exception es){
	    				es.printStackTrace();
	    				err=-1;
	    			}
	    		}
        	}
        	else {
    			Debug.println("Patient ID "+obj.getString(Tag.PatientID)+" provided by DICOM file does not exist in the database");
    			err=-1;
        	}
    	}
    	else {
    		err= -1;
    	}
    	return err;
    }
    
    public static int storeFileInDB(File file, boolean forced, int fileIdx){
    	if(Debug.enabled){
	        Debug.println("\n*******************************************************************");	
	        Debug.println("************************ storeFileInDB ("+fileIdx+") ************************");	
	        Debug.println("*******************************************************************");	
	        Debug.println("file : "+file.getName()+" ("+(file.length()/1024)+"kb)");	        
	        if(forced) Debug.println("forced : "+forced);
    	}
    	
    	int result = -1; // -1 = 'faulty file', +1 = 'file accepted', 0 = 'file denied'
    	
    	if(MedwanQuery.getInstance().getConfigInt("enableArchiveDICOMFiles",1)==1){
    		result=storeDICOMDocument(file);
    		if(result<0){
    	        Debug.println("***NOT A VALID DICOM FILE***");	
    		}
    	}
    	if(result<0 && MedwanQuery.getInstance().getConfigInt("enableArchiveBarcodePDFFiles",1)==1){
    		result=storePdfDocument(file);
    		if(result<0){
    	        Debug.println("***NOT A PDF FILE WITH VALID BARCODE***");	
    		}
    	}
    	if(result<0){
    		result=storeGenericDocument(file, forced);
    	}
		if(result<0){
	        Debug.println("***NOT A VALID ARCHIVE DOCUMENT***");	
		}
    	
      	return result;
    }
    
    //--- ACCEPT INCOMING FILE --------------------------------------------------------------------
    private static void acceptIncomingFile(String sUDI, File file) throws Exception {
    	if(Debug.enabled){
	        Debug.println("\n********************** acceptIncomingFile **********************");	
	        Debug.println("file : "+file.getName()+" ("+(file.length()/1024)+"kb)"); 	
	        Debug.println("sUDI : "+sUDI+"\n"); 	
    	}
    	
        String sOrigExt = file.getName().substring(file.getName().lastIndexOf(".")+1);
        
    	String sPathAndName = getFilePathAndName(sUDI,sOrigExt);
   		String sDir = sPathAndName.substring(0,sPathAndName.lastIndexOf("/"));
		createDirs(SCANDIR_BASE+"/"+SCANDIR_TO,sDir);
		
    	File toFile = new File(SCANDIR_BASE+"/"+SCANDIR_TO+"/"+sPathAndName);
        moveFile(file,toFile);	        
        Debug.println("--> moved file to '"+SCANDIR_BASE+"/"+SCANDIR_TO+"/"+sPathAndName+"'");
        
        ArchiveDocument.setStorageName(sUDI,sPathAndName);
    }
    
    //--- ACCEPT INCOMING FILE --------------------------------------------------------------------
    private static String acceptIncomingDICOMFile(String sUDI, File file) throws Exception {
    	if(Debug.enabled){
	        Debug.println("\n********************** acceptIncomingDICOMFile **********************");	
	        Debug.println("file : "+file.getName()+" ("+(file.length()/1024)+"kb)"); 	
	        Debug.println("sUDI : "+sUDI+"\n"); 	
    	}
    	
        String sOrigExt = "DCM";
        
    	String sPathAndName = getFilePathAndName(sUDI,sOrigExt);
   		String sDir = sPathAndName.substring(0,sPathAndName.lastIndexOf("/"));
		createDirs(SCANDIR_BASE+"/"+SCANDIR_TO,sDir);
		
		if(MedwanQuery.getInstance().getConfigInt("pacsTestLoad",0)==1){
			DicomObject obj = Dicom.getDicomObject(file);
			obj.putString(Tag.PatientName, VR.PN, "VERBEKE^FRANK");
			obj.putString(Tag.PatientAge, VR.AS, "51");
			obj.putString(Tag.PatientID, VR.LO, "9966");
			obj.putString(Tag.PatientSex, VR.LO, "M");
	    	File toFile = new File(SCANDIR_BASE+"/"+SCANDIR_TO+"/"+sPathAndName);
	    	Dicom.writeDicomObject(obj, toFile);
			file.delete();
		}
		else {
			File toFile = new File(SCANDIR_BASE+"/"+SCANDIR_TO+"/"+sPathAndName);
	        moveFile(file,toFile);
		}
	    Debug.println("--> moved DICOM file to '"+SCANDIR_BASE+"/"+SCANDIR_TO+"/"+sPathAndName+"'");
        return sPathAndName;
    }
    
    //--- CREATE DIRS -----------------------------------------------------------------------------
    private static void createDirs(String sBaseDir, String sPath){
        File tempDir = new File(sBaseDir+"/"+sPath);

        if(!tempDir.exists()){
            tempDir.mkdirs();
        }
    }
	
    //--- GET FILE PATH AND NAME ------------------------------------------------------------------
    private static String getFilePathAndName(String sUDI, String sOrigExt){
    	/*
    	if(Debug.enabled){
    	    Debug.println("\n********************* getFilePathAndName ******************");
    	    Debug.println("sUDI     : "+sUDI);
    	    Debug.println("sOrigExt : "+sOrigExt);
    	}
    	*/
    	
    	//int numberOfFile = deMod(sUDI);
    	int numberOfFile = MedwanQuery.getInstance().getOpenclinicCounter("archiveDocumentStoreCount");
    	Debug.println("numberOfFiles : "+numberOfFile); 
    	String sPath = getDir(numberOfFile).toUpperCase();  
    	String sPathAndName = sPath+"/"+sUDI+"."+sOrigExt.toLowerCase();
    	
    	Debug.println("--> sPathAndName : "+sPathAndName);    	
    	return sPathAndName;
    }
    
    //--- VALID UDI -------------------------------------------------------------------------------
    // laatste 2 cijfers = 97 - (9 eerste cijfers mod 97)
    private static boolean validUDI(String sUDI){
    	if(sUDI.length()!=11) return false;    	
    	boolean udiValid = true;
    	
    	int iPart1 = -1,
    		iPart2 = -2;
    	try{
    		iPart1=Integer.parseInt(sUDI.substring(0,9));
        	iPart2=Integer.parseInt(sUDI.substring(9,11));
    	}
    	catch(Exception e){
    	}
    	udiValid = (iPart2==97-(iPart1%97));
    	
    	
    	return udiValid;
    }
    
    //--- DE-MOD ----------------------------------------------------------------------------------
    // reverse modulo
    //
    // '00012347209' --> 123472 / 09
    //  --> 09 = 97 - (123472%97)
    //  --> 09 = 97 - 88
    //  --> 09 = 09
    //
    private static int deMod(String sUDI){
    	if(Debug.enabled){
	    	Debug.println("\n***************************** deMod ***********************");
	    	Debug.println("sUDI : "+sUDI);
    	}
    	    	
    	String part1 = sUDI.substring(0,sUDI.length()-2); // first 9 digits
    	while(part1.startsWith("0")) part1 = part1.substring(1); // trim zeroes
    	    	
    	Debug.println("--> orig number : "+part1);
    	
    	return Integer.parseInt(part1);
    }
        
    //--- GET DIR NAME ----------------------------------------------------------------------------
    public static String getDirName(String sDirName, int numberOfFile){    	
    	//int remainder = numberOfFile%1024;
    	numberOfFile = numberOfFile/1024;
    	
    	if(numberOfFile > 1024){
        	sDirName+= "/"+numberToDirName(sDirName,numberOfFile)+"/"+getDirName(sDirName,numberOfFile);
    	}
    	else{    			
    	    sDirName+= "/"+numberToDirName(sDirName,numberOfFile);
        }
   	  	
    	return sDirName;
    }
    
    public static String getDir(int number){
    	String dir="";
    	int maxfilesperdirectory=MedwanQuery.getInstance().getConfigInt("archiveMaxFilesPerDirectory",512);
    	if(number >= maxfilesperdirectory*26){
    		dir = getDir(number/(maxfilesperdirectory*26)-1)+"/";
    	}
    	dir = dir + alfabetise((number % (maxfilesperdirectory*26)) % 26);
    	return dir;
    }
    
    //--- NUMBER TO DIR NAME ----------------------------------------------------------------------
    // number means 'numberOfFile'
    private static String numberToDirName(String sDirName, int number){
    	int remainder = number%26;
    	number = number/26;
    	
    	if(number >= 26){
    		sDirName = numberToDirName(sDirName,number);
    	}
    	else{
    	    sDirName = alfabetise(number)+"/"+alfabetise(remainder);
    	}
    	
    	return sDirName;
    }
    
    //--- ALFABETISE ------------------------------------------------------------------------------
    //  0 --> A
    // 25 --> Z
    private static String alfabetise(int number){
    	String sLetter = Character.toString(ALPHABET.charAt(number));
    	sLetter = sLetter.toString().toUpperCase();
    	return sLetter;
    }
    
    //--- MOVE FILE -------------------------------------------------------------------------------
    public static String moveFile(File srcFile, File dstFile) throws IOException {
    	if(srcFile.exists()){
	        InputStream in = new FileInputStream(srcFile);
	        OutputStream out = new FileOutputStream(dstFile);
	
	        byte[] buf = new byte[1024];
	        int len;
	        while((len = in.read(buf)) > 0){
	            out.write(buf,0,len);
	        }
	
	        in.close();
	        out.close();
	        
	        // preserve original datetime
	        dstFile.setLastModified(srcFile.lastModified());
	        
	        srcFile.delete();
	        
	        return "moved file '"+srcFile.getName()+"' from '"+srcFile.getAbsolutePath()+"' to '"+dstFile.getAbsolutePath()+"'";
    	}
    	else {
    		return "tried to move non-existing file '"+srcFile.getAbsolutePath()+"'";
    	}
    }
    
    //--- REMOVE OLD DELETED FILES ----------------------------------------------------------------
    // really remove files which are in the 'scanDirectoryMonitor_dirDeleted', when they are one week old
    private static int removeOldDeletedFiles(){
    	int filesDeleted = -1;

        try{        	
        	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_DEL);        	   
        	File[] files = scanDir.listFiles(); 
        	File tmpFile;
        		        	
        	if(files!=null){
	        	for(int i=0; i<files.length; i++){
		       		tmpFile = (File)files[i];
		       		
		    		if(tmpFile.isFile()){	        		
		        	    if(tmpFile.lastModified() < (new java.util.Date().getTime()-(7*24*3600*1000))){ // millis in week
		        	    	tmpFile.delete();
		        	    	filesDeleted++;
		        	    }
		        	}
	    		}
        	}
        }
        catch(Exception e){
            e.printStackTrace();
        }

        if(filesDeleted > 0){
       		Debug.println("\n************************ removeOldDeletedFiles ***********************");
			Debug.println("--> "+filesDeleted+" files, older than one week,"+
			              " permanently removed from 'scanDirectoryMonitor_dirDeleted' : "+SCANDIR_BASE+"/"+SCANDIR_DEL);
        }
        
    	return filesDeleted;
    }
    
    //--- MOVE NOT SCANNABLE FILES ----------------------------------------------------------------
    // move files which are in the 'scanDirectoryMonitor_dirFrom', when they do not have a scannable extension (and are not created just now)
    private static int moveNotScannableFiles(){
   		int filesMoved = 0;

        try{        	
        	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_FROM);        	 
        	File[] files = scanDir.listFiles(); // all files 
        	File tmpFile, movedFile;
        	
        	for(int i=0; i<files.length; i++){
        		tmpFile = (File)files[i];
        		
        		if(tmpFile.isFile()){
        			String sExt = tmpFile.getName().substring(tmpFile.getName().lastIndexOf(".")+1);
        			if(EXCLUDED_EXTENSIONS.indexOf(sExt) > -1){
		        	    if(tmpFile.lastModified() < (new java.util.Date().getTime()-(60*1000))){ // millis in minute
		            		movedFile = new File(SCANDIR_BASE+"/"+SCANDIR_ERR+"/"+tmpFile.getName().replaceAll(SCAN_PREFIX,"INVEXT_"));
		            	    moveFile(tmpFile,movedFile);
		            	    filesMoved++;
		        	    }
	        	    }
        		}
        	}
        }
        catch(Exception e){
            e.printStackTrace();
        }

        if(filesMoved > 0){
       		Debug.println("\n************************ moveNotScannableFiles ***********************");
			Debug.println("--> "+filesMoved+" files with extensions other than '"+EXCLUDED_EXTENSIONS+"'"+
			              " moved to 'scanDirectoryMonitor_dirError' : "+SCANDIR_BASE+"/"+SCANDIR_ERR);
        }
        
    	return filesMoved;
    }
     	
	//--- RUN -------------------------------------------------------------------------------------
	public void run(){		
        try{
        	while(!isStopped()){
        		if(MedwanQuery.getInstance().getConfigInt("scanDirectoryMonitorEnabled",1)==1){
	        		Debug.println("Running scan-directory-monitor.. ("+(++runCounter)+")");
        			runScheduler();
        		}
        		Thread.sleep(MedwanQuery.getInstance().getConfigInt("scanDirectoryMonitor_interval",30*1000)); // default : each minute
        	}
		}
        catch(InterruptedException e){
			e.printStackTrace();
		}
	}
	
}
