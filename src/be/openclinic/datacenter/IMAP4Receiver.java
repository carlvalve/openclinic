package be.openclinic.datacenter;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.Date;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;

public class IMAP4Receiver extends Receiver {

	public void receive(){
        String host = MedwanQuery.getInstance().getConfigString("datacenterPOP3Host","localhost");
        String username = MedwanQuery.getInstance().getConfigString("datacenterPOP3Username","");
        String password = MedwanQuery.getInstance().getConfigString("datacenterPOP3Password","");
        Debug.println("logging in to "+host+" with "+username+"/"+password);
    	Properties props=System.getProperties();
    	if(Debug.enabled){
    		//props.put("mail.debug","true");
    	}
	    try {
	        Session session = Session.getInstance(props, null);
	    	Store store = session.getStore("imap");
			store.connect(host, username, password);
		    Folder folder = store.getFolder("INBOX");
		    folder.open(Folder.READ_WRITE);
		    Message message[] = folder.getMessages();
		    Debug.println("Found "+message.length+" messages");
		    for (int i=0, n=message.length; i<n; i++) {
		    	boolean deletemessage=false;
		    	if(message[i].getSubject().startsWith("datacenter.content")){
		    		Debug.println("Subject: "+message[i].getSubject());
			    	//Store the message in the oc_imports database here and delete it if successful
		            SAXReader reader = new SAXReader(false);
		            try{
		            	String theMessage = new String(message[i].getContent().toString());
		            	if(theMessage.indexOf("</message>")>-1 && theMessage.indexOf("</message>")<theMessage.length()-10){
		            		theMessage = theMessage.substring(0,theMessage.indexOf("</message>")+10);
		            	}
						Document document = reader.read(new ByteArrayInputStream(theMessage.getBytes()));
						Element root = document.getRootElement();
						Iterator msgs = root.elementIterator("data");
						Vector ackMessages=new Vector();
						while(msgs.hasNext()){
							Element data = (Element)msgs.next();
							Debug.println("data = "+data.asXML());
					    	ImportMessage msg = new ImportMessage(data);
							msg.setType(root.attributeValue("type"));
							Debug.println("type = "+root.attributeValue("type"));
					    	msg.setReceiveDateTime(new java.util.Date());
					    	msg.setRef("SMTP:"+message[i].getFrom()[0]);
							Debug.println("ref = "+"SMTP:"+message[i].getFrom()[0]);
					    	try {
					    		Debug.println("Storing...");
								msg.store();
								Debug.println("Stored");
								deletemessage=true;
						    	ackMessages.add(msg);
								Debug.println("ACK Added");
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
				    	//Set ackDateTime for all received messages in mail
						ImportMessage.sendAck(ackMessages);
		            }
		            catch(MessagingException e){
		            	Debug.println(e.getMessage());
		            } catch (UnsupportedEncodingException e) {
		            	Debug.println(e.getMessage());
		    		} catch (DocumentException e) {
		            	Debug.println(e.getMessage());
		    		} catch (IOException e) {
		            	Debug.println(e.getMessage());
		    		}
		    	}
		    	else if (message[i].getSubject().startsWith("datacenter.ack")){
		            SAXReader reader = new SAXReader(false);
		            try{
			            Document document = reader.read(new ByteArrayInputStream(message[i].getContent().toString().getBytes("UTF-8")));
						Element root = document.getRootElement();
						Iterator msgs = root.elementIterator("data");
						while(msgs.hasNext()){
							Element data = (Element)msgs.next();
					    	AckMessage msg = new AckMessage(data);
					    	if(msg.serverId==MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)){
					    		ExportMessage.updateAckDateTime(msg.getObjectId(), msg.getAckDateTime());
					    	}
					    	else {
					    		//TODO: send warning to system administrator 
					    		//ACK received addressed to other server!
					    		if(MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)>=0 && msg.getServerId()>0){
						    		String error="Server "+MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)+" received SMTP ACK message intended for server "+msg.getServerId();
						    		SMTPSender.sendSysadminMessage(error, msg);
					    		}
					    	}
						}
				    	deletemessage=true;
		            }
		            catch(MessagingException e){
		            	Debug.println(e.getMessage());
		            } catch (UnsupportedEncodingException e) {
		            	Debug.println(e.getMessage());
		    		} catch (DocumentException e) {
		            	Debug.println(e.getMessage());
		    		} catch (IOException e) {
		            	Debug.println(e.getMessage());
		    		}
		    	}
		    	else if (message[i].getSubject().startsWith("datacenter.importack")){
		            SAXReader reader = new SAXReader(false);
		            try{
			            Document document = reader.read(new ByteArrayInputStream(message[i].getContent().toString().getBytes("UTF-8")));
						Element root = document.getRootElement();
						Iterator msgs = root.elementIterator("data");
						while(msgs.hasNext()){
							Element data = (Element)msgs.next();
					    	ImportAckMessage msg = new ImportAckMessage(data);
					    	if(msg.serverId==MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)){
					    		ExportMessage.updateImportAckDateTime(msg.getObjectId(), msg.getImportAckDateTime());
					    		ExportMessage.updateImportDateTime(msg.getObjectId(), msg.getImportDateTime());
					    		ExportMessage.updateErrorCode(msg.getObjectId(), msg.getError());
					    	}
					    	else {
					    		//TODO: send warning to system administrator 
					    		//Import ACK received addressed to other server!
					    		if(MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)>=0 && msg.getServerId()>0){
						    		String error="Server "+MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)+" received SMTP ACK message intended for server "+msg.getServerId();
						    		SMTPSender.sendSysadminMessage(error, msg);
					    		}
					    	}
						}
				    	deletemessage=true;
		            }
		            catch(MessagingException e){
		            	Debug.println(e.getMessage());
		            } catch (UnsupportedEncodingException e) {
		            	Debug.println(e.getMessage());
		    		} catch (DocumentException e) {
		            	Debug.println(e.getMessage());
		    		} catch (IOException e) {
		            	Debug.println(e.getMessage());
		    		}
		    	}
			    if(deletemessage){
					try{
						message[i].setFlag(Flags.Flag.DELETED, true);
						Debug.println("DELETED");
					}
					catch(javax.mail.FolderClosedException a){
						a.printStackTrace();
					}
			    }
		    }
	
		    // Close connection 
		    folder.close(true);
		    store.close();
		} catch (MessagingException e1) {
			// TODO Auto-generated catch block
			Debug.println(e1.getMessage());
		}
	}
}
