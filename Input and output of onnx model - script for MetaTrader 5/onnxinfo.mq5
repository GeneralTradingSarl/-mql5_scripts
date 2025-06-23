//+------------------------------------------------------------------+
//|                                                     OnnxInfo.mq5 |
//|                                                   Copyright 2023 |
//|                          https://www.mql5.com/en/users/neverwolf |
//+------------------------------------------------------------------+

#property copyright "Neverwolf"
#property link "https://www.mql5.com/en/users/neverwolf"
#property version "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
// Prompt user to select an ONNX model file
   string file_names[];
   if(FileSelectDialog("Open ONNX model", NULL, "ONNX files (*.onnx)|*.onnx|All files (*.*)|*.*", FSD_FILE_MUST_EXIST, file_names, NULL) < 1)
      return;

// Display a message indicating the ONNX model file is being processed
   PrintFormat("Create model from %s with debug logs", file_names[0]);

// Create an ONNX session and handle any errors
   long session_handle = OnnxCreate(file_names[0], ONNX_DEBUG_LOGS);
   if(session_handle == INVALID_HANDLE)
     {
      Print("OnnxCreate error ", GetLastError());
      return;
     }

// Retrieve and print information about input in the ONNX model
   OnnxTypeInfo type_info;
   long input_count = OnnxGetInputCount(session_handle);
   Print("model has ", input_count, " input(s)");
   for(long i = 0; i < input_count; i++)
     {
      string input_name = OnnxGetInputName(session_handle, i);
      Print(i, " input name is ", input_name);
      if(OnnxGetInputTypeInfo(session_handle, i, type_info))
         PrintTypeInfo(i, "input", type_info);
     }

// Retrieve and print information about output in the ONNX model
   long output_count = OnnxGetOutputCount(session_handle);
   Print("model has ", output_count, " output(s)");
   for(long i = 0; i < output_count; i++)
     {
      string output_name = OnnxGetOutputName(session_handle, i);
      Print(i, " output name is ", output_name);
      if(OnnxGetOutputTypeInfo(session_handle, i, type_info))
         PrintTypeInfo(i, "output", type_info);
     }

// Release the ONNX session handle
   OnnxRelease(session_handle);
   Print("-----------------------------------------------------------");
  }
//+------------------------------------------------------------------+
//| PrintTypeInfo                                                    |
//+------------------------------------------------------------------+
void PrintTypeInfo(const long num, const string layer, const OnnxTypeInfo &type_info)
  {
// Print the type of the tensor
   Print("   type ", EnumToString(type_info.type));

// Check the type and use the corresponding substructure
   switch(type_info.type)
     {
      case ONNX_TYPE_TENSOR:
         // Print the data type of the tensor
         Print("   data type ", EnumToString(type_info.tensor.data_type));

         // Adjust the logic for dimensions based on the actual structure
         if(ArraySize(type_info.tensor.dimensions) > 0)
           {
            string dimensions = IntegerToString(type_info.tensor.dimensions[0]);
            for(long n = 1; n < ArraySize(type_info.tensor.dimensions); n++)
              {
               dimensions += ", ";
               dimensions += IntegerToString(type_info.tensor.dimensions[n]);
              }
            Print("   shape [", dimensions, "]");
           }
         else
           {
            PrintFormat("no dimensions defined for %I64d %s", num, layer);
           }
         break;

      case ONNX_TYPE_SEQUENCE:
         // Handle sequence type
         Print("   data type (adjust based on the actual structure for sequence)");
         Print("   sequence value type ", EnumToString(type_info.sequence.value_type.type));
         break;

      case ONNX_TYPE_MAP:
         // Handle map type
         Print("   data type (adjust based on the actual structure for map)");
         Print("   map key type ", EnumToString(type_info.map.key_type));
         Print("   map value type ", EnumToString(type_info.map.value_type.type));
         break;

      default:
         // Handle unknown type
         Print("   data type (unknown type, adjust based on the actual structure)");
     }
  }
//+------------------------------------------------------------------+
