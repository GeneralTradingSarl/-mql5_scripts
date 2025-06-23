//+------------------------------------------------------------------+
//|                                                 WININET_TEST.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
// Here is an example that shows how to download file from Internet
// using the Windows library wininet.dll
// It's a modified version of code, published by Integer 
// in MQL4.CodeBase: http://codebase.mql4.com/ru/1064
//+------------------------------------------------------------------+
#property copyright "2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Imported functions description                                   |
//+------------------------------------------------------------------+
#import "wininet.dll"
int InternetAttemptConnect(int x);
int InternetOpenW(string sAgent,int lAccessType,
                  string sProxyName="",string sProxyBypass="",
                  int lFlags=0);
int InternetOpenUrlW(int hInternetSession,string sUrl,
                     string sHeaders="",int lHeadersLength=0,
                     int lFlags=0,int lContext=0);
int InternetReadFile(int hFile,uchar &sBuffer[],int lNumBytesToRead,
                     int &lNumberOfBytesRead[]);
int HttpQueryInfoW(int hRequest,int dwInfoLevel,
                   uchar &lpvBuffer[],int &lpdwBufferLength,int &lpdwIndex);
int InternetCloseHandle(int hInet);
#import
#define HTTP_QUERY_CONTENT_LENGTH 5
//+------------------------------------------------------------------+
//| Script input parameters                                          |
//+------------------------------------------------------------------+
#property script_show_inputs
input string URL="http://google.com"; // URL
input string FileToSave="google.htm"; // File name
//+------------------------------------------------------------------+
//| The function loads file from URL specified in parameter addr     |
//| and saves it in subfolder \MQL5\Files of the client terminal     |
//+------------------------------------------------------------------+
int FileLoadFromInternet(string addr,string filename)
  {
   int rv = InternetAttemptConnect(0);
   if(rv != 0)
     {
      Print("Error in call of InternetAttemptConnect()");
      return(-1);
     }

   int hInternetSession=InternetOpenW("Microsoft Internet Explorer",0,"","",0);
   if(hInternetSession<=0)
     {
      Print("Error in call of InternetOpenW()");
      return(-2);
     }

   int hURL=InternetOpenUrlW(hInternetSession,addr,"",0,0,0);
   if(hURL<=0)
     {
      Print("Error in call of InternetOpenUrlW()");
      InternetCloseHandle(hInternetSession);
      return(-3);
     }

//---- Here we are trying to get information about size of file, 
//---- that we will download using the function InternetReadFile.
//---- To get Content length we use the function HttpQueryInfo 
//---- and store result in variable ContentSize_HttpQueryInfoW
//---- If it's equal to zero, it means that content length
//---- hasn't been reported by server
   int BufLen=2048;
   int ind=0;
   uchar buf0[2048];
   string s="";
   int ContentSize_HttpQueryInfoW=0;
   int iRes;

   iRes=HttpQueryInfoW(hURL,HTTP_QUERY_CONTENT_LENGTH,buf0,BufLen,ind);
   if(iRes<=0)
     {
      Print("Error in call of HttpQueryInfoW()");
     }
   else
     {
      s="";
      for(int k=0;k<BufLen;k++) { s=s+CharToString(buf0[k]);}
      if(StringLen(s)>0) ContentSize_HttpQueryInfoW=(int)StringToInteger(s);
     }

   if(ContentSize_HttpQueryInfoW>0)
     {
      Print("Content length=",ContentSize_HttpQueryInfoW);
     }
   else
     {
      Print("Content length is unknown");
     }

   int dwBytesRead[1];
   bool flagret=true;
   uchar buffer[1024];
   int cnt=0;

   int h=FileOpen(filename,FILE_BIN|FILE_WRITE);
   if(h<=0)
     {
      Print("Error in call of FileOpen(), file name",filename,"error=",GetLastError());
      InternetCloseHandle(hInternetSession);
      return(-4);
     }

   while(!IsStopped())
     {
      bool bResult=InternetReadFile(hURL,buffer,1024,dwBytesRead);
      cnt+=dwBytesRead[0];
      if(dwBytesRead[0]==0) break;
      FileWriteArray(h,buffer,0,dwBytesRead[0]);
     }

   if(h>0) FileClose(h);

   if(cnt==0) FileDelete(filename);

   if(cnt==0)
     {
      Print("There isn't any data from url:",addr);
      InternetCloseHandle(hInternetSession);
      return(-5);
     }
   InternetCloseHandle(hInternetSession);

   return(0);
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
  {
//---
   if(TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)==false)
     {
      Alert("Allow DLL import in options of the client terminal.");
      return(-1);
     }

   int iRes=FileLoadFromInternet(URL,FileToSave);
   if(iRes==0)
     {
      Alert("The page from URL",URL,"has been saved to file",FileToSave);
     }
   else
     {
      Alert("Download error. See details in tab Experts.");
     }

   return(0);
  }
//+------------------------------------------------------------------+
