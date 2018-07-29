<%@include file="/includes/validateUser.jsp"%>
<%
	String assessmentType = checkString(request.getParameter("assessmenttype"));
	if(assessmentType.equalsIgnoreCase("1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("2")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology2.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("3")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentTraumatology.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("4")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("5")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("6")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyAdult.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("7")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("99")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentOther.jsp"),pageContext);
	}
%>