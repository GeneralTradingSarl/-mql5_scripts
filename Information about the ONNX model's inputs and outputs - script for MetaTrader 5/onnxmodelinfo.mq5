//+------------------------------------------------------------------+
//|                                                OnnxModelInfo.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#define UNDEFINED_REPLACE 1

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   string file_names[];
   if(FileSelectDialog("Open ONNX model",NULL,"ONNX files (*.onnx)|*.onnx|All files (*.*)|*.*",FSD_FILE_MUST_EXIST,file_names,NULL)<1)
      return;

   PrintFormat("Create model from %s with debug logs",file_names[0]);

   long session_handle=OnnxCreate(file_names[0],ONNX_DEBUG_LOGS);
   if(session_handle==INVALID_HANDLE)
     {
      Print("OnnxCreate error ",GetLastError());
      return;
     }

   OnnxTypeInfo type_info;

   long input_count=OnnxGetInputCount(session_handle);
   Print("model has ",input_count," input(s)");
   for(long i=0; i<input_count; i++)
     {
      string input_name=OnnxGetInputName(session_handle,i);
      Print(i," input name is ",input_name);
      if(OnnxGetInputTypeInfo(session_handle,i,type_info))
         PrintTypeInfo(i,"input",0,type_info);
     }

   long output_count=OnnxGetOutputCount(session_handle);
   Print("model has ",output_count," output(s)");
   for(long i=0; i<output_count; i++)
     {
      string output_name=OnnxGetOutputName(session_handle,i);
      Print(i," output name is ",output_name);
      if(OnnxGetOutputTypeInfo(session_handle,i,type_info))
         PrintTypeInfo(i,"output",0,type_info);
     }

   OnnxRelease(session_handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintTypeInfo(const long num,const string layer,const int level,const OnnxTypeInfo& type_info)
  {
   if(level==0)
      Print("   type ",EnumToString(type_info.type));

   switch(type_info.type)
     {
      case ONNX_TYPE_TENSOR :
         PrintTensorTypeInfo(num,layer,level,type_info.tensor);
         break;
      case ONNX_TYPE_MAP :
         PrintMapTypeInfo(num,layer,level,type_info.map);
         break;
      case ONNX_TYPE_SEQUENCE :
         PrintSequenceTypeInfo(num,layer,level,type_info.sequence);
         break;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintTensorTypeInfo(const long num,const string layer,const int level,const OnnxTensorTypeInfo& tensor)
  {
   Print("   data type ",EnumToString(tensor.data_type));

   if(tensor.dimensions.Size()>0)
     {
      bool   dim_defined=(tensor.dimensions[0]>0);
      string dimensions=IntegerToString(tensor.dimensions[0]);
      for(long n=1; n<tensor.dimensions.Size(); n++)
        {
         if(tensor.dimensions[n]<=0)
            dim_defined=false;
         dimensions+=", ";
         dimensions+=IntegerToString(tensor.dimensions[n]);
        }
      Print("   shape [",dimensions,"]");
      //--- not all dimensions defined
      if(level==0 && !dim_defined)
         PrintFormat("   %I64d %s shape must be defined explicitly before model inference",num,layer);
      //--- reduce shape
      uint reduced=0;
      long dims[];
      for(long n=0; n<tensor.dimensions.Size(); n++)
        {
         long dimension=tensor.dimensions[n];
         //--- replace undefined dimension
         if(dimension<=0)
            dimension=UNDEFINED_REPLACE;
         //--- 1 can be reduced
         if(dimension>1)
           {
            ArrayResize(dims,reduced+1);
            dims[reduced++]=dimension;
           }
        }
      //--- all dimensions assumed 1
      if(reduced==0)
        {
         ArrayResize(dims,1);
         dims[reduced++]=1;
        }
      //--- shape was reduced
      if(reduced<tensor.dimensions.Size())
        {
         dimensions=IntegerToString(dims[0]);
         for(long n=1; n<dims.Size(); n++)
           {
            dimensions+=", ";
            dimensions+=IntegerToString(dims[n]);
           }
         string sentence="";
         if(!dim_defined)
            sentence=" if undefined dimension set to "+(string)UNDEFINED_REPLACE;
         PrintFormat("   shape of %s data can be reduced to [%s]%s",layer,dimensions,sentence);
        }
     }
   else
      PrintFormat("   no dimensions defined for %I64d %s",num,layer);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintMapTypeInfo(const long num,const string layer,const int level,const OnnxMapTypeInfo& map)
  {
   Print("   map key type ",EnumToString(map.key_type));
   Print("   map value type ",EnumToString(map.value_type.type));
   PrintTypeInfo(num,layer,level+1,map.value_type);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintSequenceTypeInfo(const long num,const string layer,const int level,const OnnxSequenceTypeInfo& sequence)
  {
   Print("   sequence type ",EnumToString(sequence.value_type.type));
   PrintTypeInfo(num,layer,level+1,sequence.value_type);
  }
//+------------------------------------------------------------------+
