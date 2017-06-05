package be.mxs.common.util.pdf.general.oc.examinations;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.util.pdf.general.PDFGeneralBasic;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.system.TransactionItem;

import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Font;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.awt.*;

public class PDFGenericTransaction extends PDFGeneralBasic {

    //--- ADD CONTENT ------------------------------------------------------------------------------
    protected void addContent(){    	
        try{
            contentTable = new PdfPTable(1);
            table = new PdfPTable(5);
            SortedMap sorteditems = new TreeMap();
            Iterator iterator = transactionVO.getItems().iterator();
            ItemVO item;
            while(iterator.hasNext()){
                item = (ItemVO)iterator.next();
                if(	item.getType().toLowerCase().startsWith(IConstants_PREFIX.toLowerCase()) &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_CONTEXT") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_DEPARTMENT") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_ENCOUNTERUID") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_PRIVATETRANSACTION") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_TRANSACTION_RESULT") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_RECRUITMENT_CONVOCATION_ID")){
                	TransactionItem ti = TransactionItem.selectTransactionItem(transactionVO.getTransactionType(), item.getType());
                	sorteditems.put(ScreenHelper.checkString(ti.getModifier())+";"+String.format("%010d", ti.getPriority())+";"+item.getType(),item);
                }
            }
            
            String activekey="";
            iterator = sorteditems.keySet().iterator();
            while(iterator.hasNext()){
            	String key = (String)iterator.next();
            	if(!activekey.equalsIgnoreCase(key.split(";")[0])){
            		//Print title
            		if(key.split(";")[0].length()>0 || activekey.length()>0){
	                    cell = new PdfPCell(new Phrase(getTran(transactionVO.getTransactionType(),key.split(";")[0]).toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)9*fontSizePercentage/100.0),Font.BOLD)));
	                    cell.setColspan(5);
	                    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	                    cell.setBorder(PdfPCell.BOX);
	                    cell.setBorderColor(BaseColor.LIGHT_GRAY);
	                    table.addCell(cell);
	            		activekey=key.split(";")[0];
            		}
            	}
            	item = (ItemVO)sorteditems.get(key);
                // itemType
                cell = new PdfPCell(new Phrase(getTran("web.occup",item.getType()).toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)7*fontSizePercentage/100.0),Font.NORMAL)));
                cell.setColspan(2);
                cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
                cell.setBorder(PdfPCell.BOX);
                cell.setBorderColor(BaseColor.LIGHT_GRAY);
                table.addCell(cell);

                // itemValue
                cell = new PdfPCell(new Phrase(getTran("web.occup",item.getValue()),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)7*fontSizePercentage/100.0),Font.NORMAL)));
                cell.setColspan(3);
                cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
                cell.setBorder(PdfPCell.BOX);
                cell.setBorderColor(BaseColor.LIGHT_GRAY);
                table.addCell(cell);
            }

            // add table
            if(table.size() >= 1){
                contentTable.addCell(createCell(new PdfPCell(table),1,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER));
                tranTable.addCell(createContentCell(contentTable));
            }
            addDiagnosisEncoding();

            // add transaction to doc
            addTransactionToDoc();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

}
