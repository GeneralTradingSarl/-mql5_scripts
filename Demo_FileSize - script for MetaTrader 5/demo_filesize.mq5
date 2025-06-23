//+------------------------------------------------------------------+
//|                                                Demo_FileSize.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//--- show the window of input parameters when launching the script
#property script_show_inputs
//--- input parameters
input ulong  InpThresholdSize=20;        // file threshold size in kilobytes
input string InpBigFolderName="big";     // folder for large files
input string InpSmallFolderName="small"; // folder for small files
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   string   file_name;      // variable for storing file names
   string   filter="*.csv"; // filter for searching the files
   ulong    file_size=0;    // file size in bytes
   int      size=0;         // number of files
//--- print the path to the file we are going to work with
   PrintFormat("Working in %s\\Files\\ folder",TerminalInfoString(TERMINAL_COMMONDATA_PATH));
//--- receive the search handle in common folder's root of all terminals
   long search_handle=FileFindFirst(filter,file_name,FILE_COMMON);
//--- check if FileFindFirst() has been executed successfully
   if(search_handle!=INVALID_HANDLE)
     {
      //--- move files in the loop according to their size
      do
        {
         //--- open the file
         ResetLastError();
         int file_handle=FileOpen(file_name,FILE_READ|FILE_CSV|FILE_COMMON);
         if(file_handle!=INVALID_HANDLE)
           {
            //--- receive the file size
            file_size=FileSize(file_handle);
            //--- close the file
            FileClose(file_handle);
           }
         else
           {
            PrintFormat("Failed to open %s file, Error code = %d",file_name,GetLastError());
            continue;
           }
         //--- print the file size
         PrintFormat("Size of %s file is equal to %d bytes",file_name,file_size);
         //--- define the path for moving the file
         string path;
         if(file_size>InpThresholdSize*1024)
            path=InpBigFolderName+"//"+file_name;
         else
            path=InpSmallFolderName+"//"+file_name;
         //--- move the file
         ResetLastError();
         if(FileMove(file_name,FILE_COMMON,path,FILE_REWRITE|FILE_COMMON))
            PrintFormat("%s file is moved",file_name);
         else
            PrintFormat("Error, code = %d",GetLastError());
        }
      while(FileFindNext(search_handle,file_name));
      //--- close the search handle
      FileFindClose(search_handle);
     }
   else
      Print("Files not found!");
  }
//+------------------------------------------------------------------+
