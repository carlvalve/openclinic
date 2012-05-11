<%@ page import="be.openclinic.finance.Debet,java.util.*,be.openclinic.finance.Prestation,be.openclinic.adt.Encounter,be.mxs.common.util.system.HTMLEntities" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
    private String addDebets(Vector vDebets, String sClass, String sWebLanguage) {
        String sReturn = "";

        if (vDebets != null) {
            Debet debet;
            Encounter encounter=null;
            Prestation prestation=null;
            String sEncounterName, sPrestationDescription, sDebetUID, sPatientName;
            String sCredited;
            Hashtable hSort = new Hashtable();

            for (int i = 0; i < vDebets.size(); i++) {
                sDebetUID = checkString((String) vDebets.elementAt(i));

                if (sDebetUID.length() > 0) {
					System.out.println("sDebetUID="+sDebetUID+"*");
                    debet = Debet.get(sDebetUID);

                    if (debet != null) {
                        sEncounterName = "";
                        sPatientName = "";
						System.out.println("debet.getEncounterUid()="+debet.getEncounterUid());

                        if (checkString(debet.getEncounterUid()).length() > 0) {
                            encounter = debet.getEncounter();
    						System.out.println("encounter="+encounter);

                            if (encounter != null) {
                                sEncounterName = encounter.getEncounterDisplayName(sWebLanguage);
                            	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                                sPatientName = ScreenHelper.getFullPersonName(encounter.getPatientUID(), ad_conn);
                                try{
                                	ad_conn.close();
                                }
                                catch(Exception e){
                                	e.printStackTrace();
                                }
                            }
                        }

                        sPrestationDescription = "";

                        if (checkString(debet.getPrestationUid()).length() > 0) {
                            prestation = debet.getPrestation();

                            if (prestation != null) {
                                sPrestationDescription = checkString(prestation.getDescription());
                            }
                        }

                        sCredited = "";

                        if (debet.getCredited() > 0) {
                            sCredited = getTran("web.occup", "medwan.common.yes", sWebLanguage);
                        }
						System.out.println("1");
						System.out.println("sPatientName.toUpperCase()="+sPatientName.toUpperCase());
						System.out.println("debet.getDate().getTime()="+debet.getDate().getTime());
						System.out.println("sEncounterName="+sEncounterName);
						System.out.println("MedwanQuery.getInstance().getUser(debet.getUpdateUser())="+MedwanQuery.getInstance().getUser(debet.getUpdateUser()));
						System.out.println("debet.getUpdateUser().getPersonVO().getFullName()="+MedwanQuery.getInstance().getUser(debet.getUpdateUser()).getPersonVO().getFullName());
						System.out.println("debet.getQuantity()="+debet.getQuantity());
						System.out.println("debet.getUid()="+debet.getUid());
						System.out.println("prestation="+prestation);
						System.out.println("HTMLEntities.htmlentities(sPrestationDescription)="+HTMLEntities.htmlentities(sPrestationDescription));
						System.out.println("1");
						System.out.println("1");
                        hSort.put(sPatientName.toUpperCase() + "=" + debet.getDate().getTime() + "=" + debet.getUid(), " onclick=\"setDebet('" + debet.getUid() + "');\">"
                                + "<td>" + ScreenHelper.getSQLDate(debet.getDate()) + "</td>"
                                + "<td>" + HTMLEntities.htmlentities(sEncounterName) + " ("+MedwanQuery.getInstance().getUser(debet.getUpdateUser()).getPersonVO().getFullName()+")</td>"
                                + "<td>" + debet.getQuantity()+" x "+HTMLEntities.htmlentities(sPrestationDescription) + "</td>"
                                + "<td "+(checkString(debet.getExtraInsurarUid()).length()>0?"style='text-decoration: line-through'":"")+">" + (debet.getAmount()+debet.getExtraInsurarAmount()) + " " + MedwanQuery.getInstance().getConfigParam("currency", "�") + "</td>"
                                + "<td>" + sCredited + "</td>"
                                + "</tr>");
						System.out.println("2");
                    }
                }
            }

            Vector keys = new Vector(hSort.keySet());
            Collections.sort(keys);
            Collections.reverse(keys);
            Iterator it = keys.iterator();

            while (it.hasNext()) {
                if (sClass.equals("")) {
                    sClass = "1";
                } else {
                    sClass = "";
                }
                sReturn += "<tr class='list" + sClass
                        + "' onmouseover=\"this.className='list_select';\" onmouseout=\"this.className='list" + sClass + "';\"" + hSort.get((String) it.next());
            }
        }
        return sReturn;
    }
%>
<table width="100%" cellspacing="0">
    <tr class="admin">
        <td width="80"><%=HTMLEntities.htmlentities(getTran("web","date",sWebLanguage))%></td>
        <td><%=HTMLEntities.htmlentities(getTran("web.finance","encounter",sWebLanguage))%></td>
        <td width="200"><%=HTMLEntities.htmlentities(getTran("web","prestation",sWebLanguage))%></td>
        <td width="100"><%=HTMLEntities.htmlentities(getTran("web","amount",sWebLanguage))%></td>
        <td width="50"><%=HTMLEntities.htmlentities(getTran("web","canceled",sWebLanguage))%></td>
    </tr>
    <tbody onmouseover='this.style.cursor="hand"' onmouseout='this.style.cursor="default"'>
<%
    String sFindDateBegin = checkString(request.getParameter("FindDateBegin")),
           sFindDateEnd = checkString(request.getParameter("FindDateEnd")),
           sFindAmountMin = checkString(request.getParameter("FindAmountMin")),
           sFindAmountMax = checkString(request.getParameter("FindAmountMax"));

    Vector vUnassignedDebets;
    if ((sFindDateBegin.length()==0)&&(sFindDateEnd.length()==0)&&(sFindAmountMin.length()==0)&&(sFindAmountMax.length()==0)){
        vUnassignedDebets = Debet.getUnassignedPatientDebets(activePatient.personid);
    }
    else {
        vUnassignedDebets = Debet.getPatientDebets(activePatient.personid,sFindDateBegin,sFindDateEnd,sFindAmountMin, sFindAmountMax);
    }
    out.print(addDebets(vUnassignedDebets, "", sWebLanguage));
%>
    </tbody>
</table>