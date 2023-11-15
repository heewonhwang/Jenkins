<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*"%>
<%@ page import="com.markany.futils.*"%>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	// 증명서 생성 시 필요한 데이터 정보 3가지 ( pdf파일경로, ozr파일경로, 가로세로파라미터 )
	String	strPdfDataType = request.getParameter("strPdfDataType");		  //가로세로여부 0-Portrait(세로),1-Landscape(가로) 
	//String	strPdfDataType = "1";		
	String	strPrintOptions	= request.getParameter("strPrintOptions");
	
	String strBrokerOptions = request.getParameter("strBrokerOptions");
	
	String	strRtDataPath ="";
	String	strPdfFilePath ="";
	MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
	//********************* 샘플데이터 물리적 패스 ************************//
	
	if(strPdfDataType.equals("0")){
		strRtDataPath 		= "C:/java_warkspace/noax_oz/WebContent/Sample/OZ_1Page.dat";   //data 파일경로
		strPdfFilePath 		= "C:/java_warkspace/noax_oz/WebContent/Sample/OZ_1Page.pdf";   //pdf 파일경로
	}else{
		strRtDataPath 		= "C:/java_warkspace/noax_oz/WebContent/Sample/OZ_REX_garo_2page.dat";   //data 파일경로
		strPdfFilePath 		= "C:/java_warkspace/noax_oz/WebContent/Sample/OZ_REX_garo_2page.pdf";   //pdf 파일경로
	}
	strRtDataPath = maEncUtil.strUrlRdEncode( strRtDataPath );
	strPdfFilePath = maEncUtil.strUrlRdEncode( strPdfFilePath );
	
	%>
	
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>E-Certification</title>
	<style></style>
	<script language="javascript">
	  function init()
	  {
	    var form = document.forms[0];
	    form.action = "../jsp/MaFpsTail_Noax.jsp";
	    form.submit();	  
	  }
	</script>
	</head>
	<body onLoad="init();">
	  <form id="thisF" method="post">
  	  <input type="hidden" name ="RtData" value="<%=strRtDataPath%>">
  	  <input type="hidden" name ="PdfFilePath" value="<%=strPdfFilePath%>">
  	  <input type="hidden" name ="PdfDataType" value="<%=strPdfDataType%>">
  	  <input type="hidden" name ="PrintOptions" value="<%=strPrintOptions%>">
	  <input type="hidden" name ="BrokerOptions" value="<%=strBrokerOptions%>">
	  </form>  	  	  	  
	</body>
</html>