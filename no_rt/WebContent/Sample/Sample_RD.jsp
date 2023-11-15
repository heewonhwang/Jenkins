<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*"%>
<%@ page import="com.markany.futils.*"%>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
	String samplePath = "C:/Users/hwanghw/eclipse-workspace/no_rt/WebContent/Sample/RD/";
	//String responseStr = "0|" + samplePath + "RD_Sample.pdf|" + samplePath + "RD_Sample.mml|0|300|110|30|260|528|260|5|260";
	String responseStr = "0|" + samplePath + "RD_Sample.pdf|" + samplePath + "RD_Sample.mml|0|16|2|0|0|528|260|5|260";
	
	String certInfo[] = responseStr.split("\\|");
	// [1]: PDF경로,         [2]: 데이터 파일 경로 , [3]: 세로-0/가로-1 
	// [4]: 바코드 Width,     [5]: 바코드 Height, [6]: 바코드 XPos, [7]: 바코드 YPos
	// [8]: 복사방지코드 Width, [9]: 복사방지코드 Height, [10]: 복사방지코드 XPos, [11]: 복사방지코드 YPos
	
	// PDF 및 MML 경로
	String  strMakePDFMML			= new String("");
	String	strPdfFilePath 			= new String("");
	String	strRtDataPath 			= new String("");
	// 가로 세로 옵션
	String	strPdfDataType 			= new String("");
	
	// 2D 바코드 사이즈, 위치 및 복사방지마크 옵션 
	int    	ivCellBlockCount 		= 0;
	int 	ivCellBlockRow 			= 0;
	String 	strMAConfigData 		= new String("");
	String 	strConfingEncodeData 	= new String("");
	//세부 값
	String  str2DXvalue				= new String("");
	String  str2DYvalue				= new String("");
	String  strCPXvalue				= new String("");
	String  strCPYvalue				= new String("");
	String  strCPWvalue				= new String("");
	String  strCPHvalue				= new String("");
	// NULL
	String 	strConfigFilePath 		= new String("");
	String	strPrintOptions			= "0";
	boolean	strValueTrue			= false;
	File CheckFilePdfData = new File("");
	File CheckFileRtData = new File("");
	try{
		strMakePDFMML				= certInfo[0];
		if(strMakePDFMML.length() > 1){   // 0번 값이 1보다 큰 경우 정상적인 데이터가 아닙니다.
			out.println("PDF & MML 데이터 생성 실패입니다. (M2soft 문의)"+ "<br><br>");
			strValueTrue			= false;
		}else{
			CheckFilePdfData 			= new File(certInfo[1]);
			CheckFileRtData 			= new File(certInfo[2]);
		}
		
		if(CheckFilePdfData.isFile() && CheckFileRtData.isFile()){
			strPdfFilePath			= certInfo[1];
			strRtDataPath         	= certInfo[2];
			strRtDataPath = maEncUtil.strUrlRdEncode( strRtDataPath );
			strPdfFilePath = maEncUtil.strUrlRdEncode( strPdfFilePath );
			strPdfDataType 			= certInfo[3];
			ivCellBlockCount		= Integer.parseInt(certInfo[4]);
			ivCellBlockRow		 	= Integer.parseInt(certInfo[5]);
			//2D바코드 x좌표^2D바코드 y좌표^복사방지 x좌표^복사방지 y좌표^복사방지 Width^복사방지 Heigth^		
			str2DXvalue				= certInfo[6];
			str2DYvalue				= certInfo[7];
			strCPXvalue				= certInfo[10];
			strCPYvalue				= certInfo[11];
			strCPWvalue				= certInfo[8];
			strCPHvalue				= certInfo[9];
			
			//if(!str2DXvalue.equals("0") && !str2DYvalue.equals("0") && !strCPXvalue.equals("0") && !strCPYvalue.equals("0") && !strCPWvalue.equals("0") && !strCPHvalue.equals("0"))
			if(!("0").equals(str2DXvalue) && !("0").equals(str2DYvalue) && !("0").equals(strCPXvalue) && !("0").equals(strCPYvalue) && !("0").equals(strCPWvalue) && !("0").equals(strCPHvalue))
			{
				//2D바코드 x좌표^2D바코드 y좌표^복사방지 x좌표^복사방지 y좌표^복사방지 Width^복사방지 Heigth^		
				strMAConfigData	   			= new String(str2DXvalue+"^"+str2DYvalue+"^"+strCPXvalue+"^"+strCPYvalue+"^"+strCPWvalue+"^"+strCPHvalue+"^Internet^COPY^4^280^70^0^0^3^");  
				strConfingEncodeData 		= MaBase64Utils.base64Encode( strMAConfigData.getBytes("euc-kr") );
				strValueTrue			= true;
			}else{
				strValueTrue			= false;
				out.println("바코드 및 복사방지마크에 대한 옵션 값이 없습니다. (정상적인 위변조 증명서가 아닙니다. M2soft 문의)" + "<br><br>");
			}
			if((ivCellBlockCount == 0) || (ivCellBlockRow == 0))
			{
				strValueTrue			= false;
				out.println("바코드 사이즈 Fail / mrd파일에 바코드 오브젝트가 없습니다. (정상적인 위변조 증명서가 아닙니다. M2soft 문의)" + "<br><br>");
			}
			
		}else{
			strValueTrue			= false;
			out.println("PDF & MML 데이터 경로 Fail (M2soft 문의)" + "<br><br>");
		}
	}catch(Exception e){
		strValueTrue			= false;
		out.println("정상적인 위변조 증명서가 아닙니다. M2soft 문의");
	}
	if(strValueTrue == true){
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
  	  <input type="hidden" name ="BlockCount" value="<%=ivCellBlockCount%>">
  	  <input type="hidden" name ="BlockRow" value="<%=ivCellBlockRow%>">
  	  <input type="hidden" name ="ConfigFilePath" value="<%=strConfigFilePath%>">
  	  <input type="hidden" name ="ConfingEncodeData" value="<%=strConfingEncodeData%>">
	  </form>  	  	  	  
	</body>

</html>	
<%
	}else{
		//out.println("정상적인 위변조 증명서가 아닙니다. M2soft 문의");
	}
%>

