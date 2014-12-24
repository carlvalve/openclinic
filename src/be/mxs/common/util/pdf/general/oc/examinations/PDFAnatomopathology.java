package be.mxs.common.util.pdf.general.oc.examinations;

import be.mxs.common.util.pdf.general.PDFGeneralBasic;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;

public class PDFAnatomopathology extends PDFGeneralBasic {

    //--- ADD CONTENT -----------------------------------------------------------------------------
    protected void addContent(){
        try{
            if(transactionVO.getItems().size() >= minNumberOfItems){
                contentTable = new PdfPTable(1);
                table = new PdfPTable(5);
                
                // identificationumber
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_IDENTIFICATION_NUMBER");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","identificationumber"),itemValue);
                }
                
                //***** DATES *****************************                
                // row : reception date + reported date
                String sReceptionDate = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_SPECIMEN_RECEPTION_DATE"),
                       sReportedDate  = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_SPECIMEN_REPORTED_DATE");
                
                if(sReceptionDate.length() > 0 || sReportedDate.length() > 0){
	                // reception date
	                if(sReceptionDate.length() > 0){                    
	                    table.addCell(createItemNameCell(getTran("web.occup","specimen.reception.date"),1));
	                    table.addCell(createValueCell(sReceptionDate,1));
	                }
	                
	                // reported date                  
	                if(sReportedDate.length() > 0){  
		                table.addCell(createItemNameCell(getTran("web.occup","reported.date"),1));
		                table.addCell(createValueCell(sReportedDate,2));
	                }
                }

                //***** PHYSICIAN *************************
                // row : physician + address
                String sPhysician = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_PHYSICIAN"),
                       sAddress   = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_ADDRESS");
                
                if(sPhysician.length() > 0 || sAddress.length() > 0){
	                // physician
	                if(sPhysician.length() > 0){                    
	                    table.addCell(createItemNameCell(getTran("web","physician"),1));
	                    table.addCell(createValueCell(sPhysician,1));
	                }
	                
	                // address                  
	                if(sAddress.length() > 0){  
		                table.addCell(createItemNameCell(getTran("web","address"),1));
		                table.addCell(createValueCell(sAddress,2));
	                }
                }
                
				//***** LOCATION **************************
                String sLocationSite   = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_LOCATION_SITE"),
                       sLocationOrgan  = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_LOCATION_ORGAN"),
                       sLocationDetail = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_LOCATION_DETAIL");
                
                if(sLocationSite.length() > 0 || sLocationOrgan.length() > 0 || sLocationDetail.length() > 0){                    
                    PdfPTable locationTable = new PdfPTable(3);

                    // location site                
                    if(sLocationSite.length() > 0){
                        addItemRow(locationTable,getTran("web","anatomical.location.site"),getTran("location.site",sLocationSite));
                    }
                    
                    // location organ
                    if(sLocationOrgan.length() > 0){
                        addItemRow(locationTable,getTran("web","anatomical.location.organ"),getTran("location.site."+sLocationSite,sLocationOrgan));
                    }
                    
                    // location detail
                    if(sLocationDetail.length() > 0){
                        addItemRow(locationTable,getTran("web","anatomical.location.detail"),sLocationDetail);
                    }
                    
                    table.addCell(createItemNameCell(getTran("web","anatomical.location")));
                    table.addCell(createCell(new PdfPCell(locationTable),3,PdfPCell.ALIGN_LEFT,PdfPCell.BOX));
                }
                
				//***** PROCEDURE ************************* 
                // procedure type
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_PROCEDURE_TYPE");
                if(itemValue.length() > 0){
                	if(itemValue.equals("0")){
                		itemValue = getTran("web","other.procedure");
                	}
                	else{
                	    itemValue = getTran("procedure.type",itemValue);
                	}
                	
                    addItemRow(table,getTran("openclinic.chuk","procedure_type"),itemValue);
                }
                
                // procedure text
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_LOCATION_PROCEDURE_TEXT");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","procedure_type"),itemValue);
                }

                // history
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_HISTORY");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","clinical_data"),itemValue);
                }

                // gross description
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_GROSS_DESCRIPTION");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","gross.description"),itemValue);
                }
                
                // microscopic examination
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_MICROSCOPIC_EXAMINATION");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","microscopic.examination"),itemValue);
                }

                // result
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_RESULT");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","conclusion"),itemValue);
                }
                
                // canreg 
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_CANREG");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","canreg"),itemValue);
                }

                // declared valid
                itemValue = getItemValue(IConstants_PREFIX+"ITEM_TYPE_ANATOMOPATHOLOGY_DECLARED_VALID");
                if(itemValue.length() > 0){
                    addItemRow(table,getTran("openclinic.chuk","declared_valid"),itemValue);
                }

                // add transaction to doc
                if(table.size() > 0){
                    if(contentTable.size() > 0) contentTable.addCell(emptyCell());
                    contentTable.addCell(createCell(new PdfPCell(table),1,PdfPCell.ALIGN_CENTER,PdfPCell.BOX));
                    tranTable.addCell(new PdfPCell(contentTable));
                }

                // add transaction to doc
                addTransactionToDoc();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    
}

