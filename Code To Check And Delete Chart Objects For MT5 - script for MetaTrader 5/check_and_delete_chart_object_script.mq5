//+------------------------------------------------------------------+
//|                         Check And Delete Chart Object Script.mq5
//+------------------------------------------------------------------+
#property copyright "Chika E. Anumba"
#property link      "anumbachika@yahoo.com"
#property version   "1.00"
#property description "THE SCRIPT SCANS THROUGH THE CURRENT CHART FOR ANY AVAILABLE CHART OBJECTS, COUNTS THEM AND DELETE THEM ACCORDINGLY"

/*
Code To Check And Delete Chart Objects For MT5:
- The script scans through the current chart for any available chart objects,
- Counts and delete them accordingly
- And log the the names of the objects on the chart rspectively.


*/
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(" ");
   Print(" ");
//calling the function to delete any Chart Object from the current chart
   CheckAndDeleteChartObject(_Symbol, _Period);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CheckAndDeleteChartObject() Function                                                                |
//+------------------------------------------------------------------+
void CheckAndDeleteChartObject(string gSymbol, ENUM_TIMEFRAMES TF)
  {
   long chartID =ChartID(); //declaring the chargt id

   Print("Total Number of Objects on the Current Chart before deletion = ", ObjectsTotal(chartID)); //log the total number of chart objects, if any

   for(int i=ObjectsTotal(chartID)-1;i>=0;i--) //loop through the existing objects on the chart.
     {
      string OBJECTname =ObjectName(chartID,i);  //obtaining the name of a selected object
      Print("Object name on the current chart '", gSymbol, " ", EnumToString(TF), "' = ", OBJECTname); //log the name of the selected chart object

      if(ObjectsTotal(chartID) >0) //if chart object exists
        {
         Print("Chart Object '", OBJECTname, "' is about to be deleted..."); //log the the name of the object for deletion from the chart

         if(ObjectDelete(0, OBJECTname)) //if an object is deleted from the current chart
           {
            Print("Chart Object '", OBJECTname, ", Deleted Successfully "); //log the deletion of the named chart object
           }
         else
           {
            ResetLastError();
            Print("Chart Object '", OBJECTname, ", COULD NOT BE Deleted due to Error# ", GetLastError(), "!!!"); //log the non-deletion of the chart object and obtain the error number
           }
        }

      Print("Total Number of Chart Objects Remianing after deletion = ", ObjectsTotal(chartID)); //log the total number of the chart objects remaining
      Print(" ");
     }
  }//END of void CheckAndDeleteChartObject(string gSymbol, ENUM_TIMEFRAMES TF)
//+------------------------------------------------------------------+
