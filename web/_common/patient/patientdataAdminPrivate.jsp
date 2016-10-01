<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    if(activePatient!=null && activePatient.personid.length()>0){
        AdminPrivateContact apc = ScreenHelper.getActivePrivate(activePatient);

        if(apc!=null){
            String sCountry = "&nbsp;";
            if(checkString(apc.country).trim().length()>0){
                sCountry = getTran(request,"Country",apc.country,sWebLanguage);
            }

            String sProvince = "&nbsp;";
            if(checkString(apc.province).trim().length()>0){
                sProvince = getTran(request,"province",apc.province,sWebLanguage);
            }
            
            %>
                <table width="100%" cellspacing="1" class="list" style="border-top:none;">
                    <%=
                        setRow("Web.admin","addresschangesince",apc.begin,sWebLanguage)+
                        (
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateCountry",1)==0?"":
                            setRow("Web","country",sCountry,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateDistrict",1)==0?"":
                            setRow("web","district",apc.district,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateZipcode",1)==0?"":
                            setRow("web","zipcode",apc.zipcode,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateProvince",1)==0?"":
                            setRow("web","province",sProvince,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateCity",1)==0?"":
                            setRow("web","city",apc.city,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateSector",1)==0?"":
                            setRow("web","sector",apc.sector,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateCell",1)==0?"":
                            setRow("web","cell",apc.cell,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateAddress",1)==0?"":
                            setRow("web","address",apc.address,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateEmail",1)==0?"":
                            setRow("web","email",apc.email,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateTelephone",1)==0?"":
                            setRow("web","telephone",apc.telephone,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateMobile",1)==0?"":
                            setRow("web","mobile",apc.mobile,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateFunction",1)==0?"":
                            setRow("web","function",apc.businessfunction,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateBusiness",1)==0?"":
                            setRow("web","business",apc.business,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateComment",1)==0?"":
                            setRow("web","comment",apc.comment,sWebLanguage)
                        )
					%>
                    <tr height='1'><td width='<%=sTDAdminWidth%>'/></tr>
                </table>
            <%
        }
        else{
        	%><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
        }
    }
%>

<%-- BUTTONS -------------------------------------------------------------------------------------%>
<%
    String sShowButton = checkString(request.getParameter("ShowButton"));
    if(!sShowButton.equals("false")){
        %>
            <%=ScreenHelper.alignButtonsStart()%>
                <input type="button" class="button" value="<%=getTranNoLink("Web","history",sWebLanguage)%>" name="ButtonHistoryPrivate" onclick="parent.location='patienthistory.do?ts=<%=getTs()%>&contacttype=private'">&nbsp;
                <%
                    if (activeUser.getAccessRight("patient.administration.edit")){
                        %><input type="button" class="button" onclick="window.location.href='<c:url value="/patientedit.do"/>?Tab=AdminPrivate&ts=<%=getTs()%>'" value="<%=getTranNoLink("Web","edit",sWebLanguage)%>"><%
                    }
                %>
            <%=ScreenHelper.alignButtonsStop()%>
        <%
    }
%>