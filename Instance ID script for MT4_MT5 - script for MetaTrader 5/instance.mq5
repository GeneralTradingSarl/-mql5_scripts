//|-----------------------------------------------------------------+
//|                                                    instance.mq5 |
//|                                   Copyright (c) 2019, marketeer |
//|                         https://www.mql5.com/en/users/marketeer |
//| Based on the code proposed by https://www.mql5.com/en/users/jjc |
//| at https://www.mql5.com/en/forum/149578/page2#comment_3752924   |
//|-----------------------------------------------------------------+
#property copyright "2019 (c) Marketeer"
#property link      "https://www.mql5.com/en/users/marketeer"
#property version   "1.1"
#property description "This script allows a user to find out instance_id of running MT4/MT5 instance"

// This script calculates instance_id for MT4/MT5 installations.
// The instance_id is used in the roaming folder names such as
// C:/Users/{username}/AppData/Roaming/MetaQuotes/Terminal/{instance_id}/.
// Find more details here:
// - MT4: https://www.metatrader4.com/en/trading-platform/help/userguide/start_comm#data_folder
// - MT5: https://www.metatrader5.com/en/terminal/help/start_advanced/start#guest

string instance_id(const string &strPath)
{
  string strTest = strPath;
  StringToUpper(strTest);

  // Convert the string to widechar Unicode array (it will include a terminating 0)
  ushort arrShort[];
  const int n = StringToShortArray(strTest, arrShort); // n includes terminating 0, and should be dropped
  
  // Convert data to uchar array for hashing
  uchar widechars[];
  ArrayResize(widechars, (n - 1) * 2);
  for(int i = 0; i < n - 1; i++)
  {
    widechars[i * 2] = (uchar)(arrShort[i] & 0xFF);
    widechars[i * 2 + 1] = (uchar)((arrShort[i] >> 8) & 0xFF);
  }

  // Do an MD5 hash of the uchar array, containing the Unicode string
  uchar dummykey[1] = {0};
  uchar result[];
  if(CryptEncode(CRYPT_HASH_MD5, widechars, dummykey, result) == 0)
  {
    Print("Error ", GetLastError());
    return NULL;
  }
  
  return arrayToHex(result);
}

string arrayToHex(uchar &arr[])
{ 
  string res = "";
  for(int i = 0; i < ArraySize(arr); i++)
  {
    res += StringFormat("%.2X", arr[i]);
  }
  return(res);
}

void OnStart()
{
  const string path = TerminalInfoString(TERMINAL_PATH);
  // const string data = TerminalInfoString(TERMINAL_DATA_PATH);
  // const string common = TerminalInfoString(TERMINAL_COMMONDATA_PATH);
  Print("Install folder = ", path);
  // Print("Data folder = ", data);
  // Print("Common folder = ", common);
  Print("Instance ID = ", instance_id(path));
}