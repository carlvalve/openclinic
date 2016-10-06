package be.mxs.common.util.system;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Hashtable;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

import be.mxs.common.util.db.MedwanQuery;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.Result;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.itextpdf.text.BadElementException;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.Barcode39;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfWriter;

public class PdfBarcode {

	public static String decode(BufferedImage image, Map<DecodeHintType, Object> hints) throws Exception {
		if (image == null)
	        throw new IllegalArgumentException("Could not decode image.");
	    LuminanceSource source = new BufferedImageLuminanceSource(image);
	    BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));
	    MultiFormatReader barcodeReader = new MultiFormatReader();
	    Result result;
	    String finalResult="";
	    try {
	        if (hints != null && ! hints.isEmpty())
	            result = barcodeReader.decode(bitmap, hints);
	        else
	            result = barcodeReader.decode(bitmap);
	        // setting results.
	        finalResult = String.valueOf(result.getText());
	    } catch (Exception e) {
	        //e.printStackTrace();
	        //throw new BarcodeEngine().new BarcodeEngineException(e.getMessage());
	    }
	    return finalResult;
	}

	public static String getBarcodeFromDocument(File file){
		String barcode="";
		try{
			System.setProperty("org.apache.pdfbox.baseParser.pushBackSize", "10000000");
			PDDocument document = PDDocument.loadNonSeq(file, null);
			java.util.List<PDPage> pdPages = document.getDocumentCatalog().getAllPages();
			int mypage = 0;
			for (PDPage pdPage : pdPages)
			{ 
			    ++mypage;
		    	boolean bExit=false;
			    Debug.println("Analyzing page "+mypage);
			    BufferedImage bim = pdPage.convertToImage(BufferedImage.TYPE_BYTE_GRAY, 300);
			    File f = new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/IMG_"+mypage+".png");
			    if(f.exists()){
			    	f.delete();
			    }
			    ImageIO.write(bim, "PNG", f);
	            Map<DecodeHintType,Object> tmpHintsMap = new EnumMap<DecodeHintType, Object>(DecodeHintType.class);
	            tmpHintsMap.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
	            tmpHintsMap.put(DecodeHintType.POSSIBLE_FORMATS, EnumSet.allOf(BarcodeFormat.class));
	            tmpHintsMap.put(DecodeHintType.PURE_BARCODE, Boolean.FALSE);
			    barcode=decode(bim,tmpHintsMap);
			    if(barcode.length()>0){
			    	Debug.println("Found barcode value "+barcode+" on page "+mypage);
					break;		    	
			    }
			    else {
				    for(int n=0;n<bim.getHeight()*9/10;n+=bim.getHeight()/10){
					    BufferedImage cropedImage = bim.getSubimage(0, n, bim.getWidth(), bim.getHeight()/10);
					    barcode=decode(cropedImage,tmpHintsMap);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage);
					    	bExit=true;
							break;		    	
					    }
				    }
				    if(bExit) break;
			    }
			    if(bExit) break;
			}
			document.close();
		}
		catch(Exception e){
			Debug.println(e.getMessage());
		}
		return barcode;
	}

	public static Image getBarcode(String text, PdfWriter docWriter){
        if(MedwanQuery.getInstance().getConfigString("preferredBarcodeType","Code39").equalsIgnoreCase("QRCode")){
        	return getQRCode(text, docWriter,MedwanQuery.getInstance().getConfigInt("preferredQRCodeSize", 60));
        }
        else {
        	return getCode39(text, docWriter,MedwanQuery.getInstance().getConfigInt("preferredCode39TextSize", 8),MedwanQuery.getInstance().getConfigInt("preferredCode39Baseline", 10),MedwanQuery.getInstance().getConfigInt("preferredCode39Height", 20));
        }
	}
	
	public static Image getBarcode(String text, String alttext, PdfWriter docWriter){
        if(MedwanQuery.getInstance().getConfigString("preferredBarcodeType","Code39").equalsIgnoreCase("QRCode")){
        	return getQRCode(text, docWriter,MedwanQuery.getInstance().getConfigInt("preferredQRCodeSize", 60));
        }
        else {
        	return getCode39(text, alttext, docWriter,MedwanQuery.getInstance().getConfigInt("preferredCode39TextSize", 8),MedwanQuery.getInstance().getConfigInt("preferredCode39Baseline", 10),MedwanQuery.getInstance().getConfigInt("preferredCode39Height", 20));
        }
	}
	
	public static Image getCode39(String text, PdfWriter docWriter,int size, int baseline, int barheight){
        PdfContentByte cb = docWriter.getDirectContent();
        Barcode39 barcode39 = new Barcode39();
        barcode39.setCode(text);
        barcode39.setSize(size);
        barcode39.setBaseline(baseline);
        barcode39.setBarHeight(barheight);
        return barcode39.createImageWithBarcode(cb,null,null);
	}
	
	public static Image getQRCode(String text, PdfWriter docWriter,int size){
        Image image=null;
        try {
            PdfContentByte cb = docWriter.getDirectContent();
            Hashtable<EncodeHintType, ErrorCorrectionLevel> hintMap = new Hashtable<EncodeHintType, ErrorCorrectionLevel>();
            hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix byteMatrix = qrCodeWriter.encode(text,BarcodeFormat.QR_CODE, size, size, hintMap);
            int CrunchifyWidth = byteMatrix.getWidth();
            BufferedImage bimage = new BufferedImage(CrunchifyWidth, CrunchifyWidth,
                    BufferedImage.TYPE_INT_RGB);
            bimage.createGraphics();
 
            Graphics2D graphics = (Graphics2D) bimage.getGraphics();
            graphics.setColor(Color.WHITE);
            graphics.fillRect(0, 0, CrunchifyWidth, CrunchifyWidth);
            graphics.setColor(Color.BLACK);
 
            for (int i = 0; i < CrunchifyWidth; i++) {
                for (int j = 0; j < CrunchifyWidth; j++) {
                    if (byteMatrix.get(i, j)) {
                        graphics.fillRect(i, j, 1, 1);
                    }
                }
            }
            image=Image.getInstance(cb, bimage, 1);
        } catch (Exception e) {
            e.printStackTrace();
		}
        return image;
	}
	
	public static Image getCode39(String text, String alttext, PdfWriter docWriter,int size, int baseline, int barheight){
        PdfContentByte cb = docWriter.getDirectContent();
        Barcode39 barcode39 = new Barcode39();
        barcode39.setCode(text);
        barcode39.setSize(size);
        barcode39.setBaseline(baseline);
        barcode39.setBarHeight(barheight);
        barcode39.setAltText(alttext);
        return barcode39.createImageWithBarcode(cb,null,null);
	}
	
}
