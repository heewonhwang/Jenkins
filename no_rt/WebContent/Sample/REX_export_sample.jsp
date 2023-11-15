<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.markany.futils.*"%>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.clipsoft.clipreport.export.option.PDFOption"%>
<%@page import="com.clipsoft.clipreport.oof.connection.OOFConnectionHTTP"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="com.clipsoft.clipreport.server.service.ResultValue"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportPDFForMark"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportExport"%>
<%@include file="Property.jsp"%>

<%

	OOFDocument oof = OOFDocument.newOOF();
	OOFFile file = oof.addFile("crf.root", "%root%/crf/CLIPtoDRM.crf");

	//pdf 생성할 때 옵션
	PDFOption option = new PDFOption();
	//텍스트를 이미지로 표현할지 여부
	//option.setTextToImage(true);

	ResultValue result = ClipReportPDFForMark.create(request, propertyPath, oof, option);
	int errorCode = result.getErrorCode();
	//errorCode == 0 정상
	//errorCode == 1 리포트 서버  오류
	//errorCode == 2 oof 문서 오류
	//errorCode == 3 리포트 엔진 오류
	//errorCode == 4 결과물(document) 파일을 찾을 수 없을 때 오류
	//errorCode == 5 pdf, dat 생성시 오류

	//바코드로 만든 데이터 파일 위치
	//result.getDataFilePath();

	//생성된 pdf 파일 위치
	//result.getPdfFilePath();

	//바코드가 들어갈 좌표
	//result.getLeft();
	//result.getTop();

	//문서의 세로, 가로
	//세로 0
	//가로 1
	//int paperOrientation = result.getPaperOrientation();

	//임시 저장 삭제
	//ClipReportPDFForMark.delete(result);
	
	//-------------------------------------------------------------- for MarkAny -------------------------------
	int	strPdfDataType = result.getPaperOrientation();		  //가로세로여부 0-Portrait(세로),1-Landscape(가로) 
	String	strPrintOptions	= "0";
	String	strRtDataPath = result.getDataFilePath();
	String	strPdfFilePath = result.getPdfFilePath();
	
	/*
	MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
	// 증명서 생성 시 필요한 데이터 정보 3가지 ( pdf파일경로, ozr파일경로, 가로세로파라미터 )
	String	strPdfDataType = request.getParameter("strPdfDataType");		  //가로세로여부 0-Portrait(세로),1-Landscape(가로) 
	String	strPrintOptions	= request.getParameter("strPrintOptions");
	String	strRtDataPath ="";
	String	strPdfFilePath ="";
 
	//********************* 샘플데이터 물리적 패스 ************************//
	
	if(strPdfDataType.equals("0")){
		strRtDataPath 		= "/usr/local/apache/htdocs/FPS/NOAX_RT/Data/1455763711936.dat";   //data 파일경로
		strPdfFilePath 		= "/usr/local/apache/htdocs/FPS/NOAX_RT/Data/1455763711936.pdf";   //pdf 파일경로
		
	}else{
		strRtDataPath 		= "/usr/local/apache/htdocs/FPS/NOAX_RT/Data/gggg.dat";   //data 파일경로
		strPdfFilePath 		= "/usr/local/apache/htdocs/FPS/NOAX_RT/Data/gggg.pdf";   //pdf 파일경로
	}
	strRtDataPath = maEncUtil.strUrlRdEncode( strRtDataPath );
	strPdfFilePath = maEncUtil.strUrlRdEncode( strPdfFilePath );
	*/
	  
	//String strMAConfigData	 				= new String("35^265^7^265^528^264^인터넷발급^사본^4^280^70^0^0^3^"); 
	//String strConfingEncodeData 			= MaBase64Utils.base64Encode(strMAConfigData.getBytes("utf-8"));

	// ** debug ** //
	//out.println(strCurrentPath);
	//out.println(strOzDataPath);
	//out.println(strPdfFilePath);
	
	/* 마크애니 뷰어 옵션 
	    // 미리보기 지원
		- 0 : view-manualprint-printerselect (default)
		      마크애니 뷰어로 미리보기가 가능하며, 인쇄버튼을 누르면 프린터선택창을 지원하는 옵션 (미리보기 후 인쇄선택버튼 눌러 인쇄가능)
		- 1 : view-manualprint-defaultprinter
      		마크애니 뷰어로 미리보기가 가능하며, 인쇄버튼을 누르면 기본프린터로 인쇄되는 옵션
		- 2 : view-autoprint-printerselect
		      마크애니 뷰어로 미리보기 되자마자, 프린터선택창이 바로 뜨는 옵션
		- 3 : view-autoprint-defaultprinter
      		마크애니 뷰어로 미리보기 되자마자, 기본프린터로 자동 인쇄되는 옵션
		- 4 : view
          마크애니 뷰어로 미리보기만 가능함 (인쇄버튼 없음)
		      
		  // 미리보기 지원안함    
		- 10: notView_autoPrint_printerselect
		      마크애니 뷰어가 뜨지않고, 프린터선택창이 바로 뜨는 옵션
		- 11: notView_autoPrint_defaultPrinter	
        	마크애니 뷰어가 뜨지않고, 기본프린터로 바로 출력되는 옵션
	*/
	
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
	    form.action = "./MaFpsTail_Noax.jsp";
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
	  </form>  	  	  	  
	</body>
</html>