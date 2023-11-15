<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import='java.util.* , java.io.*, java.lang.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%@include file="MaFunction.jsp"%>
<%
	String strParamDownURL = (String) session.getAttribute("strDownURL");
	String strParamPDFDownURL = (String) session.getAttribute("strPDFDownURL");
	String strParamCookie = (String) session.getAttribute("strCookie");
	String strParamPversion = (String) session.getAttribute("productversion");
	String strRtDataFilePath = (String) session.getAttribute("strRtDataFilePath");
	String strPdfFilePath = (String) session.getAttribute("strPdfFilePath");
	String strBase64PDFTotalURL = (String) session.getAttribute("strBase64PDFTotalURL");
	String strBase64PDFDownURL = (String) session.getAttribute("strBase64PDFDownURL");
	
	byte	byteCookieData[] = strParamCookie.getBytes ("utf-8"); 
	strParamCookie = MaBase64Utils.base64Encode( byteCookieData );
	String strParamSDownURL = strParamDownURL;
	byte	byteDownURLData[] = strParamSDownURL.getBytes ("utf-8"); 
	String strParam64DownURL = MaBase64Utils.base64Encode( byteDownURLData );

	int iTotal = 20;
	int iCnt = 0;
	boolean bValidVersion = false;

	while (true) {
		strParamPversion = (String) session.getAttribute("productversion");
		if (strParamPversion != null) {
			if (strParamPversion.indexOf(strAppSign) >= 0) {
				String strTemp = replaceAll(strParamPversion, strAppSign, "");
				int iServerVer = Integer.parseInt(strPVersion);
				int iSessionVer = Integer.parseInt(strTemp);

				if (iSessionVer >= iServerVer){
					bValidVersion = true;
				}	
				break;
			}
		}
		iCnt++;

		if (iTotal <= iCnt)
			break;

		Thread.sleep(500);
	}
	//out.println(strRtDataFilePath);
	if (!bValidVersion) //file delete
	{
		if( strRtDataFilePath != null ){
			deleteFile(strRtDataFilePath);
		}
		if( strPdfFilePath != null ){
			deleteFile(strPdfFilePath);
		}
		response.sendRedirect(strSudongInstallURL);
	}else{
%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>E-Certification</title>
<style>
.container {
	position: relative;
	margin: 0 auto;
}

#content {
	display: block;
	font-size: 11px;
	margin-top: 40px;
	text-align: center;
}

img {
	margin: 0 auto;
	display: block;
}
</style>
</head>
<body>
	<div class="container">
		<div id="content">
			<img src="<%=strImagePath%>/loading.gif"><br> <img
				src="<%=strImagePath%>/Ma_progressBar.gif"><br> <img
				src="<%=strImagePath%>/notice.png"><br>
		</div>
	</div>
</body>
</html>
<script src="<%=strJsWebHome%>/MaVerCheck.js" charset="utf-8"></script>
<script language="javascript">
	
	var vstrSudongInstallURL = "<%=strSudongInstallURL%>";
	var vSession = getCookie("JSESSIONID");
	var vstrSCookie = "<%=strParamCookie%>";
	var vpversion = "<%=strParamPversion%>";
	var vstrSDownURL = "<%=strParam64DownURL%>";
	var vstrPDFDownURL = "<%=strParamPDFDownURL%>";
	var iVersion  = "<%=strPVersion%>";
	var vstrApp = "<%=strApp%>"; 
	var viUsePDF 	= "<%=iUsePDF%>"; 
	var vstrSPDFTotalURL 	= "<%=strBase64PDFTotalURL%>";
	var vstrSPDFDownURL 	= "<%=strBase64PDFDownURL%>";
	
	window.resizeTo(550, 450);
<%
	if(iQuickSet == 0){
%>
		LaunchApp(vstrApp, "sockmeta");
<%
	}
	else if(iQuickSet == 1)
	{
		if( bValidVersion == false ){
		%>
			
			location.href = vstrSudongInstallURL;
		<%
		}else{
%>
		
		setTimeout(function(){messageDataSend()},3000);

<%
		}
	}
	}
%>
</script>