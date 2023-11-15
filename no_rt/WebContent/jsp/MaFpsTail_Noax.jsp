<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="../jsp/MaFpsCommon.jsp"%>
<%@include file="./MaFunction.jsp"%>
<%
	//Get RT Jsp ( PDF, rtdata, doc Type)
	String strRtData = request.getParameter("RtData");
	String strPdfFilePath = request.getParameter("PdfFilePath");
	String strPdfDataType = request.getParameter("PdfDataType");
	int iPrintOptions = Integer.parseInt(request.getParameter("PrintOptions"));	
	
	// cjkang 20190403 추가 민원용
	if(request.getParameter("BrokerOptions") != null){
	iQuickSet = Integer.parseInt(request.getParameter("BrokerOptions"));
	}
	
	strRtData = maEncUtil.strUrlRdDecode( strRtData );
	strPdfFilePath = maEncUtil.strUrlRdDecode( strPdfFilePath );
	
	HttpSession session1 = request.getSession(false);
	if (session1 == null) {
		session1 = request.getSession(true);
	}
	// ksk
	String strOrgFilePath = str2DGenUrl + strRtData + "&PdfType=" + strPdfDataType;

	//RD인경우 Invoker에서 파라미터로 받음
	if ( iMAServerPort == 18300 && iRdConfigDataUse == 1){
		try{
	iCellBlockCount							= Integer.parseInt( request.getParameter("BlockCount") );
	iCellBlockRow							= Integer.parseInt( request.getParameter("BlockRow") );
	strConfigFilePath 						= request.getParameter("ConfigFilePath"); 
	strConfingEncodeData					= request.getParameter("ConfingEncodeData");
		}catch(Exception e){
	out.println("바코드를 생성하기 위한 파라미터가 잘 못 설정되었습니다.");
		}
	}

	//가로문서이고 RD리포팅이 아닐경우 strMAConfigData값 세팅
	if(strPdfDataType.equals("1") && iMAServerPort != 18300){ 
		strMAConfigData	 						= "31^177^3^177^528^264^인터넷발급^사본^4^280^70^0^0^0^"; // 가로
		strConfingEncodeData 					= MaBase64Utils.base64Encode(strMAConfigData.getBytes("euc-kr"));
	}
	
	/* 프린터	선택옵션 */
	// iPrintOptions - 0:	default
	//iPrintOptions = 10;
	switch (iPrintOptions) {
		case 1 : //view-manualprint-defaultprinter
	//마크애니 뷰어로	미리보기가 가능하며, 인쇄버튼을	누르면 기본프린터로	인쇄되는 옵션
	DEFAULTPRT = "1";
	break;
		case 2 : //view-autoprint-printerselect
	//마크애니 뷰어로	미리보기 되자마자, 프린터선택창이	바로 뜨는	옵션
	AUTOPRINT = "1";
	break;
		case 3 : //view-autoprint-defaultprinter
	//마크애니 뷰어로	미리보기 되자마자, 기본프린터로	자동 인쇄되는	옵션
	AUTOPRINT = "1";
	DEFAULTPRT = "1";
	break;
		case 4 : //view
	//마크애니 뷰어로	미리보기만 가능함	(인쇄버튼	없음)
	HIDEPRTBUTTON = "1";
	break;

		case 10 : //notView_autoPrint_printerselect
	//마크애니 뷰어가	뜨지않고,	프린터선택창이 바로	뜨는 옵션
	HIDEFRAME = "1";
	AUTOPRINT = "1";
	break;
		case 11 : //notView_autoPrint_defaultPrinter
	//마크애니 뷰어가	뜨지않고,	기본프린터로 바로	출력되는 옵션
	HIDEFRAME = "1";
	AUTOPRINT = "1";
	DEFAULTPRT = "1";
	break;
	}
	
	String strPdfParam = strPdfFilePath;
	if (iUsePDF == 1)
		strPdfParam = "NONE";

	String strMetaData = "";
	String strRetCode = "";
	String strRetData = "";
	int iRetCode = 0;
	
	// 생성 시간 선언
	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS");
	String today = formatter.format(new java.util.Date());
	
	
	//RD or other Reporting Create 2D bacode
	// ksk
	if (iUsePDF < 2) {
		if( iMAServerPort == 18300 ){ //RD
	MaMakeCode clMaMakeCode = new MaMakeCode();
	strMetaData =  clMaMakeCode.strInsert2DCodeDataFileNonActive(
									strMAServerIP,
									iMAServerPort,
									strRtData, 
									"0", 
									strConfigFilePath, 
									iCellBlockCount, 
									iCellBlockRow,
									"", 
									strConfingEncodeData,
									strPdfFilePath, 
									strPdfDataType,
									strMobileCodeData.getBytes("utf-8"),
									"",
									"",
									"",
									"",
									"" );
	
	strRetCode = strMetaData.substring(0, 5);
	strRetData = strMetaData.substring(5);
	iRetCode = Integer.parseInt(strRetCode);

		} else if (iMAServerPort != 18300) { //other

	File FileRtData = new File(strRtData);
	byte byteRtData[] = new byte[(int) FileRtData.length()];

	if (FileRtData.isFile()) {
		try {
			BufferedInputStream fin = new BufferedInputStream(new FileInputStream(FileRtData));
			fin.read(byteRtData);
			fin.close();
		} catch (Exception e) {
			System.out.println("markany_RtData File Input Error (not find) _for Windows");
		}
	}

	MaFpsMake2DCode clMaFpsMake2DCode = new MaFpsMake2DCode();
	//cjkang 20200424 trycatch add
	try {
		strMetaData = clMaFpsMake2DCode.iGen2DCodeNonActive(strMAServerIP, iMAServerPort, strConfingEncodeData,
				iCellBlockCount, iCellBlockRow, byteRtData, strSignCompany, strReportCompany, 0, "", "", "",
				strPdfParam, strPdfDataType, strMobileCodeData.getBytes("utf-8"), strMobileCodeConfig, "");

		strRetCode = strMetaData.substring(0, 4);
		strRetData = strMetaData.substring(4);
		iRetCode = Integer.parseInt(strRetCode);
	} catch (Exception e) {
		out.println("[MarkAny Net Library] 2D Barcode Creation Error");
		return;
	}

		}
		//ePageSAFER Server Err Return
		if (iRetCode != 0) {
	//out.println("ERROR !! " + iRetCode);
	if (iRetCode == 1001 || iRetCode == 10001)
		out.println("Error code : " + iRetCode + " 마크애니 데몬프로세스를 구동해주세요.");
	else if (iRetCode == 9001 || iRetCode == 90001)
		out.println("Error code : " + iRetCode + " pdf 및 원본 데이터 경로가 정상적이지 않습니다.");
	else if (iRetCode == -450)
		out.println("Error code : " + iRetCode + " 설정되어 있는 2D바코드사이즈가 작습니다.");
	else if (iRetCode == 1020) //cjkang 20200424 add errorcode 1020 
		out.println("Error code : " + iRetCode + " 바코드 생성시간이 초과하였습니다.(대용량출력 - 관리자에게 문의)");
	else
		out.println("Error code : " + iRetCode);
	//out.close();
	return;
		}
	}

	int iAMetaDataSize = strRetData.length();
	String strMetaFilePath = "";
	String strAddData = "";
	int iRetBro = 0;
	String browsername = "";
	String browserversion = "";
	int iBrowserVer = 0;

	// ============================================ Cookie Set Start ==========================================
	String strCookie = "";
	//서버에서 request.getCookies 메서드로 클라이언트가 보낸 쿠키 정보 읽기
	Cookie[] cookies = request.getCookies();
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) { // 20180716
	//for( int i = cookies.length -1; i >=0; i--){
	for (int cN_i = 0; cN_i < registerCookieArr.length; cN_i++) {
		if (!cookies[i].getName().equals(registerCookieArr[cN_i])) {
			continue;
		}
		//getName(), getValue() 메서드를 이용하여 원하는 쿠키 정보 찾아오기
		strCookie += cookies[i].getName() + "=" + cookies[i].getValue() + ";";
	}
	//break; // 20180716
		}
	}
	strCookie = "Cookie: " + strCookie;

	byte byteCookieData[] = strCookie.getBytes("utf-8");
	String strBase64Cookie = MaBase64Utils.base64Encode(byteCookieData);
	// ============================================ Cookie Set E n d ==========================================

	// ====================================== EP Client Version Check Start ====================================
	int iSessionCheck = 0;

	session.setAttribute("productversion", strPVersion); //exe 버전
	String pversion = (String) session.getAttribute("productversion");
	if (pversion != null && pversion.indexOf("MARKANYREPORT") >= 0) {
		String strVersion = replaceAll(pversion, "MARKANYREPORT", "");
		int iCurrent = Integer.parseInt(strPVersion);
		int iSession = Integer.parseInt(strVersion);

		if (iSession >= iCurrent)
	iSessionCheck = 1;
	}

	// ====================================== EP Client Version Check End ====================================

	// ==================================== Window OS Add meta Data Start ==================================
	String info = request.getHeader("User-Agent");
	if (info != null) {
		String browserInfoArr[] = getBrowserInfo(info);
		browsername = browserInfoArr[0];
		browserversion = browserInfoArr[1];
		iBrowserVer = Integer.parseInt(browserversion.trim());

		if (info.indexOf("Windows") > 0) {
	if (iUsePDF != 2) {
		//MASetICP(m_hImgSf, pIcpInfo.wszText, pIcpInfo.wszFont, pIcpInfo.nICPPattern, pIcpInfo.nICPOpacity, pIcpInfo.nICPDegree, pIcpInfo.nICPTextPercent1, 
		//pIcpInfo.nICPPosXPercent1, pIcpInfo.nICPPosYPercent1, pIcpInfo.nICPTextPercent2, pIcpInfo.nICPPosXPercent2, pIcpInfo.nICPPosYPercent2);
		String strIcpParam = "1^PreView^Wide Latin^7^30^-40^10^0^0^0^0^0^";
		String ICP = MaBase64Utils.base64Encode(strIcpParam.getBytes()); //ICP Setting

		strAddData = "#IMGURL=http://" + strServerName + ":" + String.valueOf(iServerPort) + "/" + strImagePath;
		strAddData += "#META_SIZE=" + String.valueOf(iAMetaDataSize);
		strAddData += "#CPPARAM=" + "";
		strAddData += "#PRTPROTOCOL=" + request.getScheme(); //
		strAddData += "#PRTIP=" + strServerName;
		strAddData += "#PRTPORT=" + String.valueOf(iServerPort);
		strAddData += "#PRTPARAM=" + strPrintParam;
		strAddData += "#PRTURL=" + strPrintURL;
		strAddData += "#DOCTYPE=1";
		strAddData += "#PRTTYPE=" + PRTTYPE;
		strAddData += "#PRINTCOPIES=" + PRINTCOPIES;
		strAddData += "#PSSTRING=" + PSSTRING;
		strAddData += "#PSSTRING2=" + PSSTRING2;
		strAddData += "#FAQURL=" + FAQURL;
		//strAddData += "#CP2PARAM=" + CP2PARAM;
		strAddData += "#WMPARAM=" + WMPARAM;
		strAddData += "#TITLE=" + TITLE;
		strAddData += "#PRINTERDAT=" + strDataFileName;
		strAddData += "#PRINTERVER=" + PRINTERVER;
		strAddData += "#PRINTERUPDATE=" + PRINTERUPDATE;
		strAddData += "#HIDEPRTBUTTON=" + HIDEPRTBUTTON; //0 or default : show,  1 : hide //미리보기만
		strAddData += "#HIDEFRAME=" + HIDEFRAME; //0 or default : show,  1 : hide //바로출력 미리보기  x
		strAddData += "#DEFAULTPRT=" + DEFAULTPRT; //0 or default : printer selcet,  1 : default print//기본프린터 프린터선택창x
		strAddData += "#AUTOPRINT=" + AUTOPRINT; //0 or default : manual print,  1 : auto print  //HIDEFRAME 사용할경우 출력(세트옵션)
		strAddData += "#VIRTUAL=" + VIRTUAL; //가상허용
		//strAddData += "#RENDEROPTION=" + RENDEROPTION; // Renderer Option  0 : Renderer 안씀  3 : Renderer 사용
		strAddData += "#PAPERSIZE=" + PAPERSIZE; // Paper Size  9 : A4  ,  1 : Letter   				
		//strAddData += "#ICP=" + ICP;
		strAddData += "#PRINTCNT=" + PRINTCNT;
		strAddData += "#AUTOCLOSE=" + AUTOCLOSE;
		strAddData += "#HIDECD=" + HIDECD;
		strAddData += "#PRTDLGOPT=" + PRTDLGOPT; //0:default , 5:Partial print
		strAddData += "#CPFONTNAME=" + CPFONTNAME;
		strAddData += "#TRANSPARENCYIMG=" + TRANSPARENCYIMG;
		//rt 미리보기 (원노트)
		strAddData += "#SUPPORTPRTPORT=" + "TlVMfFNIUg==";

		//strAddData += "#SUPPORTPRTPORT=" + "UE9SVFBST01QVA==";
		//strAddData += "#_PRINTSTATUSDLG_=" + PRINTSTATUSDLG;
		
		//strAddData += "#SUPPORTPRTPORT=" + "Q1FNS1BSTjo=";
		strAddData += "#_PRINTCALLURLOPT_=" + PRINTCALLURLOPT;
		if (CONVERTIMAGEPRINT.equals("1")) {
			strAddData += "#_CONVERTIMAGEPRINT_=" + CONVERTIMAGEPRINT;
		}
		strAddData = replaceAll(strAddData, "\\n", "\n");

	}

	//File Server Setting
	String strSID = session.getId();
	String strEncFileServerIP = MaBase64Utils.base64Encode(strFileServerIp.getBytes("utf-8"));
	strMetaFilePath = strSID + today + ".matmprp";
	strDownFolder += "/" + strMetaFilePath; //저장해야 하는 경로에는 세션값을 넣고
	strDownURL += today; //보내야 할 URL에는 세션값이 빠진  날짜만 전송함

	if (iUseNas == 1) {
		BufferedWriter fw = null;
		try {
			fw = new BufferedWriter(new FileWriter(new File(strDownFolder)));
			fw.write(strRetData + strAddData); //파일에다 작성
			fw.flush();
		} catch (IOException e) {
			System.out.println("markany_filewrite buffer Error");
			//e.printStackTrace(System.err);
		} finally {
			if (fw != null) {
				fw.close(); //파일핸들 닫기
			}
		}

	} else {
		masavefile clMaSaveFile = new masavefile();
		strDownURL += "&fs=" + strEncFileServerIP;

		try {
			strRetCode = clMaSaveFile.strSaveMetaFile(strFileServerIp, iFileServerPort, strMetaFilePath,
					strRetData + strAddData, "", "");

			iRetCode = Integer.parseInt(strRetCode);

		} catch (UnsatisfiedLinkError e) {
			System.out.println("markany_filewrite buffer Error");
			//e.printStackTrace(System.err);
		}

	}

	String[] arrPDFName = strPdfFilePath.split(strIDECheck);
	String onlyPDF_FileName = arrPDFName[arrPDFName.length - 1];

	strPDFDownURL += onlyPDF_FileName.substring(0, onlyPDF_FileName.lastIndexOf("."));

	// ksk
	if (iUsePDF == 3) {
		strPDFDownURL += "#" + strOrgFilePath;
	}

	session.setAttribute("strDownURL", strDownURL);
	session.setAttribute("strCookie", strCookie);
	session.setAttribute("strPdfFilePath", strPdfFilePath);
	session.setAttribute("strRtDataFilePath", strRtData);
		}
	}

	String strBase64DownURL = MaBase64Utils.base64Encode(strDownURL.getBytes("utf-8"));
	String strBase64SessionURL = MaBase64Utils.base64Encode(strSessionURL.getBytes("utf-8"));
	String strBase64PDFDownURL = MaBase64Utils.base64Encode(strPDFDownURL.getBytes("utf-8"));
	String strSPDFTotalURL = strPDFDownURL + "#" + strDownURL;
	String strBase64PDFTotalURL = MaBase64Utils.base64Encode(strSPDFTotalURL.getBytes("utf-8"));
	session.setAttribute("strBase64PDFDownURL", strBase64PDFDownURL);
	session.setAttribute("strBase64PDFTotalURL", strBase64PDFTotalURL);

	String LaunchRegistAppCommand = "";
	if (iQuickSet == 1) {
		LaunchRegistAppCommand = "quickurl";
	} else if (iQuickSet == 0) {
		if (iSessionCheck == 0) {
	LaunchRegistAppCommand = "registapp";
		} else {
	LaunchRegistAppCommand = "sockmeta";
		}
	} else if (iQuickSet == 2) {
		LaunchRegistAppCommand = "sockmeta";
	}
%>
	<!DOCTYPE HTML>
	<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta charset="utf-8">
		<TITLE>::: 전자확인증 발급 :::</TITLE>
		<link rel="stylesheet" type="text/css" href="<%=strWebHome%>/css/MaCommon.css">
		
		<script src="<%=strJsWebHome%>/jquery-1.12.1.min.js" charset="utf-8"></script>
		<script src="<%=strJsWebHome%>/jQuery.XDomainRequest.js" charset="utf-8"></script>		
		<script src="<%=strJsWebHome%>/MaXHRControl.js?version=20180124" charset="utf-8"></script> 		
		<script src="<%=strJsWebHome%>/MaVerCheck.js?version=20180124" charset="utf-8"></script>
		<script>
			var vstrSCookie				= "<%=strBase64Cookie%>";
			var vstrSDownURL			= "<%=strBase64DownURL%>";
			var vstrSessionCheck		= "<%=strSessionCheck%>";
			var vstrSPDFTotalURL		= "<%=strBase64PDFTotalURL%>";
			var vstrSPDFDownURL			= "<%=strBase64PDFDownURL%>";
			var vstrSSessionURL			= "<%=strBase64SessionURL%>";
			var viUsePDF				= "<%=iUsePDF%>";
			var viQuickSet				= "<%=iQuickSet%>";
			var vstrApp					= "<%=strApp%>"; 
			// ihkang
			// XHR 설치 체크 시 exe 다운 경로  
			var vstrInstallFilePath		= "<%=strDownFileUrl%>";
			// Common Version
			var iVersion				= "<%=strPVersion%>";	
	
												//2.5.1.98		//prgramfi		//ePageSaferRT.exe				//MarkAny\maepsrt
			if (viQuickSet == 2 ){				
				var checkFileInfo_1 		= [iVersion			, 0x0026	, "y85/zv65HGcOkFXjRS2WVg=="	, "TWFya0FueVxtYWVwc3J0"			];
				var chkFileArray 			= new Array(checkFileInfo_1);
				
				var executeBinaryInfo_1		= [GetParamData(vstrApp)		, 0x0026	, "y85/zv65HGcOkFXjRS2WVg=="	, "TWFya0FueVxtYWVwc3J0"		];
				var executeBinaryArray 		= new Array(executeBinaryInfo_1);
				
				
			}else {
				
				var vstrIePopupURL			= "<%=strIePopupURL%>";
				var vpversion 				= "<%=pversion%>";
				var resize_height			= 450;
				var browserName				= <%=iSessionCheck%>===1?'installCheckSuccess':getBrowserName();
				switch (browserName){
					case "installCheckSuccess":
						resize_height = 500;
						break;
					case "Opera":
						resize_height = 600;
						break;
					case "Chrome":
						resize_height = 950;
						break;
					case "MSIE":
					case "Edge":
						resize_height = 500;
						break;
					case "Firefox":
						resize_height = 650;
						break;
				}			
				window.resizeTo(550, resize_height);
			}
			window.name 				= 'popWinC';
		</script>
	</head>
<%
	if( iQuickSet == 2 ){ 
%>
	<BODY LEFTMARGIN="0" TOPMARGIN="0" RIGHTMARGIN="0" bottommargin="0" marginwidth="0" marginheight="0">
		<div id="popLayer" style="display: none;">
			<h3>ePageSAFER</h3>
			<div id="installSection">
				<div id="ment">증명서의 안전한 출력을 위해 보안 프로그램의 설치체크 여부를 확인 중입니다.</div>
				<div id="progressbar">
					<img src="<%=strImagePath%>/loading_c.gif">
				</div>
			</div>
			<div id="btnSection">
				<button id="btn_maInstall" class="btn-class" disabled onclick="javascript:location.href='<%=strUrlHome%>/bin/Setup_ePageSaferRT.exe'">다운로드</button>
				<button id="btn_closePopLayer" class="btn-class" onclick="javascript:closeWindow()">닫기</button>
			</div>
		</div>
	</BODY>
	
	<script>
		showPopup();
	</script>
<%
	}else {
%>
	<BODY LEFTMARGIN="0" TOPMARGIN="0" RIGHTMARGIN="0" bottommargin="0" marginwidth="0" marginheight="0">
		<iframe id="hidpopWinC" name="hidpopWinC" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling="auto"></iframe>
		<div class="container">
			<div class="content">
				<div class="section" id="browserChkImgSection">
					<img id="browserChkImg">
				</div>
			</div>
			<div class="section">
				<p id="browserChkComment"></p>
					
				<div class="section" id="printBtnSection">
					<input type="button" onclick="location.href='<%=strJspHome%>/MaSessionCheck.jsp'" value="문서발급">
					<br><br>
				</div>
				
			</div>
		</div>
		
		<script>
		var browserChkImg			= document.getElementById("browserChkImg");
		var browserChkComment		= document.getElementById("browserChkComment");
		var browserChkImgSection	= document.getElementById("browserChkImgSection");
		var printBtnSection			= document.getElementById("printBtnSection");
		
		if( viQuickSet == 2){
				// ksk
				var vstrParam = GetParamData(vstrApp);
				InstallCheck(1);
				browserChkImgSection.innerHTML ='<img src="<%=strImagePath%>/loading.gif" id="browserChkImg"><br>'
												+'<img src="<%=strImagePath%>/Ma_progressBar.gif"><br>'
												; //+'<img src="<%=strImagePath%>/notice.png"><br>';
				//browserChkComment.innerHTML =  browserChkComment.innerHTML + '<br><br> *미설치 혹은 업데이트가 필요한 경우 10초 후 수동설치 페이지로 이동합니다';
				printBtnSection.style.display = "none";
		}
		else {
			LaunchRegistApp(vstrApp, "<%=LaunchRegistAppCommand%>", vstrIePopupURL); 
			
			document.oncontextmenu		= document.body.oncontextmenu = function() {return false;}
		
			switch (browserName){
			case "installCheckSuccess":
				browserChkImgSection.innerHTML ='<img src="<%=strImagePath%>/loading.gif" id="browserChkImg"><br>'
												+'<img src="<%=strImagePath%>/Ma_progressBar.gif"><br>'
												+'<img src="<%=strImagePath%>/notice.png"><br>';
				printBtnSection.style.display = "none";
				break;
			case "Opera":
				browserChkImg.src = "<%=strImagePath%>/check_guide_opera.png";
				browserChkComment.innerHTML = 	'* 외부 프로토콜 요청 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
												+ '<br> 1. [mareportsafer. 링크 항상 열기] 체크 합니다.'
												+ '<br> 2. [허용] 버튼을 누릅니다.';
				printBtnSection.style.display = "none";
				break;
			case "Chrome":
				browserChkImg.src = "<%=strImagePath%>/check_guide_chrome.png";
				browserChkComment.innerHTML = 	'* 외부 프로토콜 요청 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
												+ '<br> 1. [위와같은 유형의 모든 링크에 대해 내 선택을 기억합니다.] 체크 합니다.'
												+ '<br> 2. [어플리케이션 시작] 버튼을 누릅니다.';
				printBtnSection.style.display = "none";
				break;
			case "MSIE":
			case "Edge":
				browserChkImgSection.innerHTML ='<img src="<%=strImagePath%>/loading.gif" id="browserChkImg"><br>'
												+'<img src="<%=strImagePath%>/Ma_progressBar.gif"><br>'
												+'<img src="<%=strImagePath%>/notice.png"><br>';
				printBtnSection.style.display = "none";
				browserChkComment.innerHTML = 	'<br>1. 미설치 및 PC에 설치된 버전이 낮을 경우 10초 후 설치페이지로 이동합니다.'
												+ '<br> 2. Microsoft Internet Explorer 8 이하 버전인 경우 팝업 항상 허용을 눌러주십시오.';
				break;
			case "Firefox":
				browserChkImg.src = "<%=strImagePath%>/check_guide_firefox.png";
				printBtnSection.style.display = "none";
				browserChkComment.innerHTML = 	'* 프로그램 실행 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
												+ '<br> 1. [mareportsafer 링크에 대한 선택 사항을 기억 합니다.] 체크 합니다.'
												+ '<br> 2. [확인] 버튼을 누릅니다.';
												//+ '<br> 3. [문서발급] 버튼을 눌러 발급을 계속 진행합니다.';
				break;
			}
			
			if( browserName == 'Chrome' || browserName == 'Opera'){
				if( viQuickSet == "0"  ){
					browserChkComment.innerHTML =  browserChkComment.innerHTML + '<br> 3. [문서발급] 버튼을 눌러 발급을 계속 진행합니다.';
					printBtnSection.style.display = "block";
				}else {
					browserChkComment.innerHTML =  browserChkComment.innerHTML + '<br><br> *미설치 혹은 업데이트가 필요한 경우 10초 후 수동설치 페이지로 이동합니다';
				}				
			}
		}
		</script>
	</BODY>
</HTML>
	
	
	<script>
		function resize(resize_height){
			alert(resize_height);
			window.resizeTo(550, resize_height);
		}
		//resize(resize_height);
	</script>

<%
	}
%>
