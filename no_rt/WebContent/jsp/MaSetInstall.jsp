<%@ page import='java.util.* , java.io.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%@include file="MaFunction.jsp"%>
<%
	String param = request.getParameter("param");
	param = safetyFileNameCheck(param);
	if ( param != null && !"".equals(param) ) {
		if( param.indexOf("MARKANYREPORT") >= 0){
			session.setAttribute("productversion", param); 
		}
	}
%>