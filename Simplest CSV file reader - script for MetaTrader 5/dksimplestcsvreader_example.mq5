//+------------------------------------------------------------------+
//|                                 Example_CDKSimplestCSVReader.mq5 |
//|                                                  Denis Kislitsyn |
//|                                             httsp://kislitsyn.me |
//+------------------------------------------------------------------+
#property copyright "Denis Kislitsyn"
#property link      "https://kislitsyn.me"
#property version   "1.00"

#include <DKSimplestCSVReader.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
  string Filename = "filename.csv";
  
  CDKSimplestCSVReader CSVFile; // Create class object
  
  // Read file pass FILE_ANSI for ANSI files or another flag for another codepage.
  // Give values separator and flag of 1sr line header in the file 
  if (CSVFile.ReadCSV(Filename, FILE_ANSI, ";", true)) {
    PrintFormat("Successfully read %d lines from CSV file with %d columns: %s", 
                CSVFile.RowCount(),     // Return data lines count without header 
                CSVFile.ColumnCount(),  // Retuen columns count from 1st line of the file
                Filename);
    
    // Print all columns of the file from 1st line
    for (int i = 0; i < CSVFile.ColumnCount(); i++) {   
      PrintFormat("  Column Index=#%d; Name=%s", i, CSVFile.GetColumn(i));
    }         
                
    // Print values from all rows
    for (int i = 0; i < CSVFile.RowCount(); i++) {
      PrintFormat("Row %d: Value by column name: CSVFile.GetValue(i, ""Time"")=%s", i, CSVFile.GetValue(i, "Time")); // Get value from i line by column name
      PrintFormat("Row %d: Value by column index: CSVFile.GetValue(i, 0)=%s", i, CSVFile.GetValue(i, 0));            // Get value from i line by column index
    }    
  } 
  else
    PrintFormat("Error reading CSV file or file has now any rows: %s", Filename);   
}
//+------------------------------------------------------------------+
