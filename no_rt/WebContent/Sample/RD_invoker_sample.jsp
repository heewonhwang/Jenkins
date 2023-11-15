<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*, m2soft.ers.invoker.InvokerException, m2soft.ers.invoker.http.ReportingServerInvoker" %>
<%@ page import="com.markany.futils.*"%>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>RD_Invoker_TEST</title>
</head>

<body>
	<!-- 
		[설명]마크애니의 증명서 발급 연동 테스트를 위해 사용하는 페이지입니다.
		
		해당 페이지는 오즈와 연동된 NonActiveX 테스트 페이지이나 오즈에서 데이터를 받았다고 가정하고
		샘플 데이터를 가지고 연동 되어 있습니다.
		이후 오즈의 가이드를 받아 동적 데이터 생성 및 연동은 진행하시면 됩니다.
		
		마크애니의 증명서 발급을 위해 필요한 데이터는 Forcs 에서 생성되며, 
		필요한 파일은 발급될 증명서의 pdf, Ozr,증명서의 문서타입(가로, 세로)입니다.
		
		사이트 담당자의 연동사항으로는 어떠한 형태로 마크애니 뷰어를 사용할 지를 선택하는 옵션이 있으니 
		형태에 맞는 옵션을 선택하여 호출해 주시기 바랍니다.
	
	 -->
	<%
	
	ReportingServerInvoker invoker = new ReportingServerInvoker("http://192.168.3.19:8080/ReportingServer/service");

	invoker.setCharacterEncoding("utf-8");   //캐릭터셋
	invoker.setReconnectionCount(3);        //재접속 시도 회수
	invoker.setConnectTimeout(5);           //커넥션 타임아웃
	invoker.setReadTimeout(30);             //송수신 타임아웃

	invoker.addParameter("opcode", "502");
	invoker.addParameter("mrd_path", "http://192.168.3.19:8080/ReportingServer/mrd/ESM_BKG_0109_OBL_A4_ma.mrd");
	invoker.addParameter("mrd_param", "/rv form_bkgNo[( 'BKK527293200' )] form_type[4] form_dataOnly[N] form_manifest[] form_usrId[2012509] form_mainOnly[N] form_hiddeData[N] form_level[(1)] form_remark[] form_Cntr[1] form_CorrNo[] form_his_cntr[BKG_CONTAINER] form_his_bkg [BKG_BOOKING] form_his_mkd[BKG_BL_MK_DESC] form_his_xpt[BKG_XPT_IMP_LIC] form_his_bl[BKG_BL_DOC] /rp [] /riprnmargin /rmatchprndrv [3] /rlobopt [1]");
	invoker.addParameter("export_type", "certpdf");
	invoker.addParameter("protocol", "sync");

	String responseStr = null;
	try
	{
	   responseStr = invoker.invoke();   //요청전송 응답받기
		System.out.println(responseStr);
	}
	catch(InvokerException e)
	{
	   e.printStackTrace();
	}

	//String certInfo[] = responseStr.split("\\|"); // [1]: PDF경로, [2]: 원문데이터경로, [3]: 세로-0/가로-1, [4]: 바코드 Width, [5]: 바코드 Height, [6]: 바코드 XPos, [7]: 바코드 YPos, [8]: 복사방지코드 Width, [9]: 복사방지코드 Height, [10]: 복사방지코드 XPos, [11]: 복사방지코드 YPos
	MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
	//String samplePath = "/usr/local/apache/htdocs/FPS/NOAX_RT/Data/";
	//String responseStr = "0|" + samplePath + "NIIED_TEST.pdf|" + samplePath + "NIIED_TEST.pdf.mml|0|15|2|10|274.8|838|264|165.2|274.8";

	String certInfo[] = responseStr.split("\\|"); // [1]: PDF경로, [2]: 원문데이터경로, [3]: 세로-0/가로-1, [4]: 바코드 Width, [5]: 바코드 Height, [6]: 바코드 XPos, [7]: 바코드 YPos, [8]: 복사방지코드 Width, [9]: 복사방지코드 Height, [10]: 복사방지코드 XPos, [11]: 복사방지코드 YPos
	
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
