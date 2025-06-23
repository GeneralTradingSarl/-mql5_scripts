//+------------------------------------------------------------------+
//|                                                     mql5pack.mq5 |
//|                                    Copyright (c) 2020, Marketeer |
//|                          https://www.mql5.com/en/users/marketeer |
//|                               https://www.mql5.com/en/code/27955 |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2020, Marketeer"
#property link "https://www.mql5.com/en/users/marketeer"
#property version "1.1"
#property description "This is MQL5 project packer: assemble all source and resource files from dependencies into a single ZIP."

#property script_show_inputs


// NB: first level folder name is assumed to be created virtual root (real-MQL5 container)
input string VirtualRootFolder = "MQL5";
// by default this script will pack itself with all dependencies
input string MainSourceFile = "Scripts/mql5pack.mq5";
// by default (if PackedFile is empty) zip-filename will be source-file-name.mq*.zip
input string PackedFile = "";
// optionally specify a text file with elements to exclude from process (1 element per line)
input string ExceptionListFilename = "mql5pack.txt";

      string IncludesFolder; // must include trailing slash
      string SourceFile = NULL;
const bool LoadIncludes = true;

// Basic support for icons
// Please load this file from the page https://www.mql5.com/en/code/27955
// Strangely, the codebase does not support ico/png files uploading
// #property icon "mql5pack.png"

// Basic support for Images and Sounds (uncomment for demonstration purpose only)
// #resource "\\Images\\euro.bmp";
// #resource "\\Images\\dollar.bmp";

// this is shell command to create symlink to terminal's data folder with
// all source and resource folders inside MQL5/Files/[pseudo-MQL5-link]
// rename this txt-file to makelink.bat (bat-files can not be added as resources!)
#resource "\\Files\\makelink.txt" as string __cmd1Folder

// example with exception list (standard included files)
#resource "\\Files\\mql5pack.txt" as string __exceptionListExample


// #define UNICODE_WARNING
#include <mql5/FileReader.mqh>
#include <Zip/Zip.mqh>


CZip Zip;      // Create empty zip archive.

bool ProcessTarget(const string name, string &result[])
{
  Preprocessor loader(name, IncludesFolder, LoadIncludes);
  if(!loader.run())
  {
    Print("Loader failed for ", name);
    return false;
  }
  
  Print("Files processed: ", loader.scannedFilesCount());
  Print("Source length: ", loader.totalCharactersCount());
  
  const uint n = loader.scannedFilesCount();
  ArrayResize(result, n);
  
  for(uint i = 0; i < n; i++)
  {
    result[i] = loader.scannedFilename(i);
  }
  return true;
}

string TimeStamp(const datetime now = 0)
{
  string result = TimeToString(now == 0 ? TimeLocal() : now, TIME_DATE|TIME_MINUTES|TIME_SECONDS);
  StringReplace(result, ".", "");
  StringReplace(result, ":", "");
  StringReplace(result, " ", "");
  return result;
}

void OnStart()
{
  Print("\n");

  IncludesFolder = VirtualRootFolder + "/Include/";

  string exceptions[];
  int ex = 0;
  
  if(StringLen(ExceptionListFilename) > 0)
  {
    int h = FileOpen(ExceptionListFilename, FILE_READ | FILE_TXT | FILE_ANSI | FILE_SHARE_READ | FILE_SHARE_WRITE, 0, CP_UTF8);
    if(h == INVALID_HANDLE)
    {
      Print("Can't open ", ExceptionListFilename, " ", GetLastError());
    }
    else
    {
      while(!FileIsEnding(h))
      {
        string line = FileReadString(h);
        if(StringLen(line) > 0)
        {
          StringToLower(line);
          ArrayResize(exceptions, ex + 1);
          exceptions[ex++] = line;
        }
      }
      FileClose(h);
    }
  }
  

  Print("Scanning...");

  string targets[];
  string all[];
  int duplicates = 0;
  int processed = 0;
  const int m = StringSplit(MainSourceFile, ';', targets);
  for(int i = 0; i < m; i++)
  {
    if(StringLen(targets[i]) == 0) continue;

    if(SourceFile == NULL) SourceFile = VirtualRootFolder + "/" + targets[i];

    string result[];
    if(ProcessTarget(VirtualRootFolder + "/" + targets[i], result))
    {
      processed++;

      const int p = ArraySize(all);
      ArrayCopy(all, result, p);
      
      // check for duplicates
      for(int j = p; j < ArraySize(all); j++) // candidates
      {
        for(int k = 0; k < p; k++)            // existing
        {
          if(StringCompare(all[j], all[k]) == 0)
          {
            all[j] = NULL;
            duplicates++;
            break;
          }
        }
      }
    }
  }
  
  if(processed > 1)
  {
    Print("Multiple targets: ", processed);
  }

  if(duplicates > 0)
  {
    Print("Shared files count: ", duplicates);
  }
  

  string root = VirtualRootFolder;
  StringToLower(root);

  int added = 0, j;
  const uint n = ArraySize(all);
  string listing = "";

  if(n > 0)
  {
    Print("Packing...");
  }
  
  for(uint i = 0; i < n; i++)
  {
    string name = all[i];
    
    if(name == NULL) continue;
    
    for(j = 0; j < ex; j++)
    {
      string _name = name;
      StringToLower(_name);
      if(StringFind(_name, root + "/" + exceptions[j]) == 0)
      {
        Print(" - ", name);
        listing += " - " + name + "\n";
        break;
      }
    }
    
    if(j < ex) continue;
    
    Print(" + ", name);
    listing += " + " + name + "\n";
    CZipFile *file = new CZipFile();
    if(!file.AddFile(name)
    || !Zip.AddFile(file))
    {
      delete file;
    }
    else
    {
     added++;
    }
  }
  
  if(added > 0)
  {
    string target = processed > 1 ? "Multi_Target_Archive_" + TimeStamp() : SourceFile;
    string dirfile = target + ".log";
    StringReplace(dirfile, "/", "_");
    uchar array[];
    StringToCharArray(listing, array, 0, WHOLE_ARRAY, CP_UTF8);
    CZipFile *dir = new CZipFile(dirfile, array);
    Zip.AddFile(dir);
    
    const string archive = (PackedFile != "" ? PackedFile : target) + ".zip";
    if(Zip.SaveZipToFile(archive))
    {
      Print("Packed file saved: ", archive);
    }
  }
  else
  {
    Print("No files added.");
    Print("Make sure to create pseudo-MQL5-link in the real MQL5/Files folder by running makelink.bat:");
    Print(__cmd1Folder);
  }
}

