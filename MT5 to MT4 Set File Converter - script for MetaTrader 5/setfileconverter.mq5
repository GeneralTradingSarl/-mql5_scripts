//+------------------------------------------------------------------+
//|                                             SetFileConverter.mq5 |
//|                                                  Richard Gunning |
//|                                            https://rjgunning.com |
//+------------------------------------------------------------------+
#property copyright "Richard Gunning"
#property link      "https://rjgunning.com"
#property version   "1.00"
#property description "Script for converting set files from MT5 format to MT4 format."
#property description "Set files must be in Files Folder or a SubDirectory."

#property script_show_inputs

#include <Files/FileTxt.mqh>

//--- input parameters
input string   File=""; // SetFile Name to Convert (Leave blank to convert all)
input string   SubDirectory=""; // SubDirectory of Files Folder in which to search
input string   Directory="MT4-Output-Setfiles"; //Output Directory Name (Not Blank)

//--- Create Global Variables
CFileTxt *output=new CFileTxt;
CFileTxt *file=new CFileTxt;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   long m_handle;
   bool m_file_found=true;
   string searchString="*.set";
   string thisDirectory=Directory;
   string src_path;
   string dst_path;

//--- Create Output Directory
   if(thisDirectory==""){thisDirectory="MT4-Output-Setfiles";}
   if(!output.FolderCreate(thisDirectory))
     {
      Print("Error Creating Destination Folder");
      delete output;
      delete file;
      return;
     }

//--- Set Search String and Find First Matching file in Directory
   if(File!=""){searchString=File;}
   if(SubDirectory=="")
     {
      m_handle=file.FileFindFirst(searchString,src_path);
     }
   else
     {
      m_handle=file.FileFindFirst(SubDirectory+"//"+searchString,src_path);
     }

//--- Loop through matching files and run conversion
   while(m_handle!=INVALID_HANDLE && m_file_found)
     {
      StringConcatenate(dst_path,thisDirectory,"//",src_path);
      StringReplace(dst_path,".set","-MT4.set");
      if(output.Open(dst_path,FILE_WRITE|FILE_REWRITE)!=INVALID_HANDLE && 
         file.Open(src_path,FILE_READ)!=INVALID_HANDLE)
        {
         Convert();
        }
      //--- Close SetFiles
      output.Close();
      file.Close();

      //--- Get Next SetFile
      m_file_found=file.FileFindNext(m_handle,src_path);

     }
//--- Delete Global objects
   delete output;
   delete file;
  }
//+------------------------------------------------------------------+
//|  Parse MT5 Set File Line By Line and Write Output Set File       |
//+------------------------------------------------------------------+
void Convert()
  {
   string line,str;
   string values[];
   string split[];
   int opt;

   while(!file.IsEnding())
     {
      line=file.ReadString();
      StringSplit(line,'=',values);
      StringSplit(values[1],'|',split);
      if(ArraySize(split)==0){ArrayResize(split,1);}
      for(int i=0,count=0;i<ArraySize(split);i++)
        {
         if(split[i]==""){continue;}

         if(count==0)
           {
            str=StringFormat("%s=%s",values[0],split[i]);
           }
         else if(count<4)
           {
            str=StringFormat("%s,%d=%s",values[0],count,split[i]);
           }
         else
           {
            opt=(split[i]=="Y")?1:0;
            str=StringFormat("%s,F=%d",values[0],opt);
           }
         output.WriteString(str+"\r\n");

         count++;
        }
     }

  }
//+------------------------------------------------------------------+
