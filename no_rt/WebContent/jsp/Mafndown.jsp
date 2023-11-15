<%@ page import='java.util.* , java.io.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%@include file="MaFunction.jsp"%>
<%

	String downloadFileName = null;
	String requestFileServerIp = null;
	String printDatName = null;
	String pdfFIleName = null;
	String metaFileName = null;
	String filePath = strDownFolder;						//default : MaFpsCommon.jsp set fnDirPath
	boolean prtDatUpdateFlag = false;

	printDatName = request.getParameter("prtdat");			//ex)MaPrintInfoEPSmain, only printDatFileName
	metaFileName = request.getParameter("fn");
	pdfFIleName = request.getParameter("fnpdf");
	String sessionId = session.getId();
	//out.println(sessionId);
	if ( printDatName != null && !printDatName.equals("") ){
		filePath = strPrtDatDownFolder;
		downloadFileName = safetyFileNameCheck(printDatName) + ".dat";
		prtDatUpdateFlag = true;
	}else if ( metaFileName != null && !metaFileName.equals("")){
		downloadFileName = sessionId + safetyFileNameCheck(metaFileName) + ".matmprp";
	}else if (pdfFIleName != null) {
		downloadFileName = safetyFileNameCheck(pdfFIleName) + ".pdf";
	}
	
	BufferedInputStream bis = null;
	BufferedOutputStream bos = null;
	File file = null;
	int iFileSize = 0;
	int iReadFileBuffer = 4096;
	int iReadDataSize = 0; 
	int iFinalReadFileBuffer = 0;
	
	if( iUseNas == 1 ) {
		try {
			file = new File(filePath, downloadFileName );
			if (file.isFile()) {
				iFileSize = (int) file.length();
				
				response.reset();
				response.setHeader("Content-Disposition", "attachment; fileName=" + lineCarriageEraser(downloadFileName) + ";");
				response.setContentLength((int) iFileSize);
				if( prtDatUpdateFlag == false ){
					response.setHeader("Content-Transfer-Encoding", "binary");
					response.setHeader("Pragma", "no-cache;");
					response.setHeader("Expires", "-1;");
					response.setContentType("application/x-msdownload");
				}
				
				if (iReadFileBuffer > iFileSize)
					iFinalReadFileBuffer = iFileSize;
				else
					iFinalReadFileBuffer = iReadFileBuffer;

				bis = new BufferedInputStream(new FileInputStream(file));
				bos = new BufferedOutputStream(response.getOutputStream());

				byte[] byteReadBuffer = new byte[iFinalReadFileBuffer];
				out.clear();
				out = pageContext.pushBody();

				while (true) {
					iReadDataSize = bis.read(byteReadBuffer);
					if (iReadDataSize < 0)
						break;
					bos.write(byteReadBuffer, 0, iReadDataSize);
				}
			}
		} catch (IOException e) {
			System.out.println("matmprp_filedown buffer Error");
			//e.printStackTrace(System.err);
		} finally {
			if (bis != null){
				bis.close();
			}
			if (bos != null){
				bos.close();
			}
			if (metaFileName != null || pdfFIleName != null){
				file.delete();
			}
		}
	} else {
		//strFileServerIp
		requestFileServerIp = request.getParameter("fs");
		byte[] byteIP = MaBase64Utils.base64Decode(requestFileServerIp);
		strFileServerIp = new String(byteIP);
		// create instance 
		masavefile clMaSaveFile = new masavefile();
		
		// Call Ma2DCode library
		try {
			String strRet = clMaSaveFile.strGetMetaFile(strFileServerIp, iFileServerPort, downloadFileName, "", "");

			String strRetCode = strRet.substring(0, 5);
			String strRetData = strRet.substring(5);
			int iRetCode = Integer.parseInt(strRetCode);
			bos = new BufferedOutputStream(response.getOutputStream());

			// Success ...
			if (iRetCode == 0) {
				
				out.clear();
				out = pageContext.pushBody();
				
				byte[] byteRetData = strRetData.getBytes();
				bos.write(byteRetData, 0, byteRetData.length);

			}
			
		} catch (IOException e) {
			System.out.println("matmprp_filedown buffer Error");
			//e.printStackTrace(System.err);
		} finally {
			if (bos != null){
				bos.close();
			}
		} 
	}
	
	String strRtDataFilePath = (String) session.getAttribute("strRtDataFilePath");
	String strPdfFilePath = (String) session.getAttribute("strPdfFilePath");
	
	if( strRtDataFilePath != null ){
		deleteFile(strRtDataFilePath);
	}
	if( strPdfFilePath != null ){
		deleteFile(strPdfFilePath);
	}
%>