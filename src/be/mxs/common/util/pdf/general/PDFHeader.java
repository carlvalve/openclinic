package be.mxs.common.util.pdf.general;

import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.*;

import javax.servlet.http.HttpServletRequest;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.Miscelaneous;


/**
 * User: Dave
 * Date: 30-sep-2005
 */
public class PDFHeader {

    //--- PRINT ------------------------------------------------------------------------------------
    public PdfPTable print(HttpServletRequest request, String sPrintLanguage, String sContextPath){
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        PdfPCell cell = null;

        // logo
        String sURL = request.getRequestURL().toString();
        sURL = sURL.substring(0,sURL.indexOf("openclinic",10));
        try{
            cell = new PdfPCell(Miscelaneous.getImage("logo_chuk.gif",""));
            cell.setBorder(Cell.NO_BORDER);
            cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            table.addCell(cell);
        }
        catch(Exception e){
            e.printStackTrace();
        }

        // address
        Paragraph par = null;
        if(sPrintLanguage.equalsIgnoreCase("N")){
            par = new Paragraph("OpenClinic ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD));
            par.add(new Chunk(", Nr ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("ABC123\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
            par.add(new Chunk("Pastoriestraat 58, 3370 Boutersem\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("Tel. (016) 72 10 47",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
        }
        else if(sPrintLanguage.equalsIgnoreCase("F")){
            par = new Paragraph("OpenClinic ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD));
            par.add(new Chunk(", "+ScreenHelper.getTran("pdf","header.knownas",sPrintLanguage)+" ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("ABC123\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
            par.add(new Chunk("Pastoriestraat 58, 3370 Boutersem\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("T�l. (016) 72 10 47",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
        }

        cell = new PdfPCell(par);
        cell.setBorder(Cell.NO_BORDER);
        table.addCell(cell);

        return table;
    }

    //--- PRINT ------------------------------------------------------------------------------------
    public PdfPTable print(HttpServletRequest request, String sPrintLanguage, String sContextPath, String sProject){
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        PdfPCell cell = null;

        // logo
        String sURL = request.getRequestURL().toString();
        sURL = sURL.substring(0,sURL.indexOf("openclinic",10));
        try{
            Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
            img.scalePercent(50);
            cell = new PdfPCell(img);
            cell.setBorder(Cell.NO_BORDER);
            cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            table.addCell(cell);
        }
        catch(Exception e){
            e.printStackTrace();
        }

        // address
        Paragraph par = null;
        if(sPrintLanguage.equalsIgnoreCase("N")){
            par = new Paragraph("OpenClinic ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD));
            par.add(new Chunk(", Nr ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("ABC123\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
            par.add(new Chunk("Pastoriestraat 58, 3370 Boutersem\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("Tel. (016) 72 10 47",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
        }
        else if(sPrintLanguage.equalsIgnoreCase("F")){
            par = new Paragraph("OpenClinic ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD));
            par.add(new Chunk(", "+ScreenHelper.getTran("pdf","header.knownas",sPrintLanguage)+" ",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("ABC123\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
            par.add(new Chunk("Pastoriestraat 58, 3370 Boutersem\n",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
            par.add(new Chunk("T�l. (016) 72 10 47",FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
        }

        cell = new PdfPCell(par);
        cell.setBorder(Cell.NO_BORDER);
        table.addCell(cell);

        return table;
    }
}