//+------------------------------------------------------------------+
//|                                           vr_system_test_mt5.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
// Важно!!! Не рекомендуется вносить правки в скрипт без понимания последствий.
// Скрипт предназначен для оценки производительности ЭВМ (Планшет, Десктоп/Стационар, VPS/VDS серверы, Серверы).
// Скрипт тестирует ЭВМ в 45 тестах разной направленности в двух видах программирования: ООП и процедурном.
// Часть кода взята из открытых источников https://www.mql5.com/ru/forum/58241   Автор Renat Fatkhullin
// Программу собрал Vladimir Pastushak     https://www.mql5.com/ru/users/voldemar
// Основной показатель производительности - время. Чем меньше времени ушло на вычисления, тем более производительна ЭВМ и Терминал МetaТrader.
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp." 
#property link      "https://www.mql5.com"
#property version   "1.00" // 01/11/2015
#property strict
#import "shell32.dll" // Для удобства, открывает отчет после тестов
int ShellExecuteW(int hwnd,string lpOperation,string lpFile,string lpParameters,string lpDirectory,int nShowCmd);
#import
#include<Canvas/Canvas.mqh> CCanvas canvas;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SystemTest
  {
public:
   int               TestAckermann(int m,int n); const
   void              BubbleSort(int &arr[],int left,int right);
   void              TestCall(int n);
   long              TestFibo(long n);
   void              TestFloat();
   void              TestMatrix();
   double            TestRandom(double max);
   void              TestMoments();
   void              TestNestedLoop();
   bool              PiCalculate(const int digits);
   void              QuickSort(int &arr[],int left,int right);
   double            TestRandom_(double max);
   void              TestSieve();
   void              TestStrCat();
   void              TestString();
   void              TestStrPrep();
   void              TestStrRev();
   void              TestStrSum();
   bool              ButtonCreate(const long chart_ID=0,
                                  const string name="Button",
                                  const int sub_window=0,
                                  const int xx=0,
                                  const int yy=0,
                                  const int width=50,
                                  const int height=18,
                                  const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER,
                                  const string text="Button",
                                  const string font="Arial",
                                  const int font_size=10,
                                  const color clr=clrBlack,
                                  const color back_clr=C'236,233,216',
                                  const color border_clr=clrNONE,
                                  const bool state=false,
                                  const bool back=false,
                                  const bool selection=false,
                                  const bool hidden=true,
                                  const long z_order=0);

   bool              ButtonMove(const long   chart_ID=0,const string name="Button",const int xx=0,const int yy=0);
   bool              ButtonDelete(const long   chart_ID=0,const string name="Button");

   int               array_bubble[25000];
   int               x[32000],y[32000];
   int               m1[168][168],m2[168][168],mm[168][168];
   double            nums[5750];
   int               ArrayQuickSort[16000000];

                     SystemTest(){}
                    ~SystemTest(){}
  };
SystemTest test_oop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct system
  {
   string            name;
   uint              value;
   string            size;
  };
system sys[55];
uint StartTimeTest=0,TimeTest=0;
int    file_handleTES = NULL;
string file_nameTES   = NULL;

int    array_bubble[25000];
int    m1[168][168],m2[168][168],mm[168][168];
double nums[5750];
string txt="";
//+------------------------------------------------------------------+
//| Script program Init  function                                    |
//+------------------------------------------------------------------+
int Init()
  {
   txt="Start Testing";
   Comment(txt);
   sys[0].name="===TERMINAL INFO===";       sys[0].value=NULL;                                           sys[0].size="";      // Разделитель
   sys[1].name="TERMINAL_BUILD";            sys[1].value=TerminalInfoInteger(TERMINAL_BUILD);            sys[1].size="Build"; // Номер билда запущенного терминала
   sys[2].name="TERMINAL_CPU_CORES";        sys[2].value=TerminalInfoInteger(TERMINAL_CPU_CORES);        sys[2].size="Cores"; // Количество процессоров в системе
   sys[3].name="TERMINAL_DISK_SPACE";       sys[3].value=TerminalInfoInteger(TERMINAL_DISK_SPACE);       sys[3].size="Mb";    // Объем свободной памяти на диске для папки MQL4\Files терминала, в Mb
   sys[4].name="TERMINAL_MEMORY_PHYSICAL";  sys[4].value=TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL);  sys[4].size="Mb";    // Размер физической памяти в системе, в Mb
   sys[5].name="TERMINAL_MEMORY_TOTAL";     sys[5].value=TerminalInfoInteger(TERMINAL_MEMORY_TOTAL);     sys[5].size="Mb";    // Размер памяти, доступной процессу терминала, в Mb
   sys[6].name="TERMINAL_MEMORY_AVAILABLE"; sys[6].value=TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE); sys[6].size="Mb";    // Размер свободной памяти процесса терминала в Mb
   sys[7].name="TERMINAL_MEMORY_USED";      sys[7].value=TerminalInfoInteger(TERMINAL_MEMORY_USED);      sys[7].size="Mb";    // Размер памяти, использованной терминалом, в Mb
   sys[8].name="===TEST===";  sys[8].value=NULL;                                           sys[8].size="";      // Разделитель

   MathSrand(GetTickCount());

   for(int i=0; i<25000; i++)
      test_oop.array_bubble[i]=array_bubble[i]=rand();  // Заполним массив случайными числами для пузырьковой сортировки

   string file_name_="";
   StringConcatenate(file_name_,"System Test","\\big_file",".bin");
   int  file_handle_=FileOpen(file_name_,FILE_READ|FILE_WRITE|FILE_BIN);
   if(file_handle_!=INVALID_HANDLE)
     {
      for(int i=0; i<16000000; i++)
         if(FileWriteInteger(file_handle_,rand()*rand(),INT_VALUE)==0)
            Print(GetLastError());
     }
   else
      Print(GetLastError());
   FileClose(file_handle_);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Init();
   StartTimeTest=GetTickCount();
//+------------------------------------------------------------------+
//| Test Ackermann                                                   |
//+------------------------------------------------------------------+
   TimeTest=StartTimeTest;
   for(int i=0;i<12000;i++)
      TestAckermann(3,5);
   sys[9].value = GetTickCount()-TimeTest;
   sys[9].name  = "Test Ackermann";
   sys[9].size  = "MilSek";
   txt=" 45 Testing Ackermann "+IntegerToString(sys[9].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int i=0;i<12000;i++)
      test_oop.TestAckermann(3,5);
   sys[10].value = GetTickCount()-TimeTest;
   sys[10].name  = "Test Ackermann OOP";
   sys[10].size  = "MilSek";
   txt=" 44 Testing Ackermann OOP "+IntegerToString(sys[10].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Arrays                                                   |
//+------------------------------------------------------------------+
   static int x[32000],y[32000];
   TimeTest=GetTickCount(); int i,k;
   for(i=0;i<32000;i++)
      x[i]=i+1;
   for(k=0;k<32000;k++)
      for(i=32000-1; i>=0; i--)
         y[i]+=x[i];
   sys[11].value = GetTickCount()-TimeTest;
   sys[11].name  = "Test Arrays";
   sys[11].size  = "MilSek";
   txt=" 43 Testing Arrays "+IntegerToString(sys[11].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(i=0;i<32000;i++)
      test_oop.x[i]=i+1;
   for(k=0;k<32000;k++)
      for(i=32000-1; i>=0; i--)
         test_oop.y[i]+=test_oop.x[i];
   sys[12].value = GetTickCount()-TimeTest;
   sys[12].name  = "Test Arrays OOP";
   sys[12].size  = "MilSek";
   txt=" 42 Testing Arrays OOP "+IntegerToString(sys[12].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция BubbleSort                                               |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   BubbleSort(array_bubble,0,25000-1);
   sys[13].value= GetTickCount()-TimeTest;
   sys[13].name = "Test BubbleSort";
   sys[13].size = "MilSek";
   txt=" 41 Testing BubbleSort "+IntegerToString(sys[13].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   test_oop.BubbleSort(test_oop.array_bubble,0,25000-1);
   sys[14].value = GetTickCount()-TimeTest;
   sys[14].name  = "Test BubbleSort OOP";
   sys[14].size  = "MilSek";
   txt=" 40 Testing BubbleSort OOP "+IntegerToString(sys[14].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Call Function                                            |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int z=0;z<500000000;z++)
      TestCall(z);
   sys[15].value = GetTickCount()-TimeTest;
   sys[15].name  = "Test Call";
   sys[15].size  = "MilSek";
   txt=" 39 Testing Call "+IntegerToString(sys[15].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int z=0;z<500000000;z++)
      test_oop.TestCall(z);
   sys[16].value = GetTickCount()-TimeTest;
   sys[16].name  = "Test Call OOP";
   sys[16].size  = "MilSek";
   txt=" 38 Testing Call OOP "+IntegerToString(sys[16].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Fibo                                                     |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   long fib=0;
   for(i=0;i<40;i++)
      fib=TestFibo(i);
   sys[17].value = GetTickCount()-TimeTest;
   sys[17].name  = "Test Fibo";
   sys[17].size  = "MilSek";
   txt=" 37 Testing Fibo "+IntegerToString(sys[17].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   fib=0;
   for(i=0;i<40;i++)
      fib=test_oop.TestFibo(i);
   sys[18].value = GetTickCount()-TimeTest;
   sys[18].name  = "Test Fibo OOP";
   sys[18].size  = "MilSek";
   txt=" 36 Testing Fibo OOP "+IntegerToString(sys[18].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Float                                                    |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   TestFloat();
   sys[19].value = GetTickCount()-TimeTest;
   sys[19].name  = "Test Float";
   sys[19].size  = "MilSek";
   txt=" 35 Testing Float "+IntegerToString(sys[19].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   test_oop.TestFloat();
   sys[20].value = GetTickCount()-TimeTest;
   sys[20].name  = "Test Float OOP";
   sys[20].size  = "MilSek";
   txt=" 34 Testing Float OOP "+IntegerToString(sys[20].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Matrix                                                   |
//+------------------------------------------------------------------+
   int  q,j,n=1;
   TimeTest=GetTickCount();
   for(q=0;q<168;q++)
      for(j=0;j<168;j++)
        {
         m1[q][j]=n;
         m2[q][j]=n;
         n++;
        }
   for(q=0;q<168;q++)
      TestMatrix();
   sys[21].value = GetTickCount()-TimeTest;
   sys[21].name  = "Test Matrix";
   sys[21].size  = "MilSek";
   txt=" 32 Testing Matrix "+IntegerToString(sys[21].value)+"\n"+txt;
   Comment(txt);

   n=1;
   TimeTest=GetTickCount();
   for(q=0;q<168;q++)
      for(j=0;j<168;j++)
        {
         test_oop.m1[q][j]=n;
         test_oop.m2[q][j]=n;
         n++;
        }
   for(q=0;q<168;q++)
      test_oop.TestMatrix();
   sys[22].value = GetTickCount()-TimeTest;
   sys[22].name  = "Test Matrix OOP";
   sys[22].size  = "MilSek";
   txt=" 31 Testing Matrix OOP "+IntegerToString(sys[22].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Moments                                                  |
//+------------------------------------------------------------------+
   for(int ii=0;ii<5750;ii++)
      nums[ii]=TestRandom(1000000.0);
   TimeTest=GetTickCount();
   for(int ii=0;ii<5750;ii++)
      TestMoments();
   sys[23].value = GetTickCount()-TimeTest;
   sys[23].name  = "Test Moments";
   sys[23].size  = "MilSek";
   txt=" 30 Testing Moments "+IntegerToString(sys[23].value)+"\n"+txt;
   Comment(txt);

   for(int ii=0;ii<5750;ii++)
      test_oop.nums[ii]=test_oop.TestRandom(1000000.0);
   TimeTest=GetTickCount();
   for(int ii=0;ii<5750;ii++)
      test_oop.TestMoments();
   sys[24].value = GetTickCount()-TimeTest;
   sys[24].name  = "Test Moments OOP";
   sys[24].size  = "MilSek";
   txt=" 29 Testing Moments OOP "+IntegerToString(sys[24].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция NestedLoop                                               |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   TestNestedLoop();
   sys[25].value = GetTickCount()-TimeTest;
   sys[25].name  = "Test NestedLoop";
   sys[25].size  = "MilSek";
   txt=" 28 Testing NestedLoop "+IntegerToString(sys[25].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   test_oop.TestNestedLoop();
   sys[26].value = GetTickCount()-TimeTest;
   sys[26].name  = "Test NestedLoop OOP";
   sys[26].size  = "MilSek";
   txt=" 27 Testing NestedLoop OOP "+IntegerToString(sys[26].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция PiCalculate                                              |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   PiCalculate(22000);
   sys[27].value = GetTickCount()-TimeTest;
   sys[27].name  = "Test PiCalculate";
   sys[27].size  = "MilSek";
   txt=" 26 Testing PiCalculate "+IntegerToString(sys[27].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   test_oop.PiCalculate(22000);
   sys[28].value = GetTickCount()-TimeTest;
   sys[28].name  = "Test PiCalculate OOP";
   sys[28].size  = "MilSek";
   txt=" 25 Testing PiCalculate OOP "+IntegerToString(sys[28].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция QuickSort                                                |
//+------------------------------------------------------------------+
   int ArrayQuickSort[];
   string file_namel="";
   StringConcatenate(file_namel,"System Test","\\big_file",".bin");
   int file_handlel=FileOpen(file_namel,FILE_BIN|FILE_READ);
   TimeTest=GetTickCount();
   if(file_handlel!=INVALID_HANDLE)
     {
      FileReadArray(file_handlel,ArrayQuickSort,0,16000000);
     }
   else
      Print(" Open file BIN Error N ",GetLastError());
   QuickSort(ArrayQuickSort,0,16000000-1);
   sys[29].value = GetTickCount()-TimeTest;
   sys[29].name  = "Test QuickSort";
   sys[29].size  = "MilSek";
   txt=" 24 Testing QuickSort "+IntegerToString(sys[29].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   if(file_handlel!=INVALID_HANDLE)
     {
      FileReadArray(file_handlel,test_oop.ArrayQuickSort,0,16000000);
     }
   else
      Print(" Open file BIN Error N ",GetLastError());
   test_oop.QuickSort(test_oop.ArrayQuickSort,0,16000000-1);
   sys[30].value = GetTickCount()-TimeTest;
   sys[30].name  = "Test QuickSort OOP";
   sys[30].size  = "MilSek";
   txt=" 23 Testing QuickSort OOP "+IntegerToString(sys[30].value)+"\n"+txt;
   Comment(txt);
   FileClose(file_handlel);
//+------------------------------------------------------------------+
//| Функция Random                                                   |
//+------------------------------------------------------------------+
   int  ii,jj;
   TimeTest=GetTickCount();
   for(ii=0;ii<10000;ii++)
      for(jj=0;jj<10000;jj++)
         TestRandom_(ii+jj);
   sys[31].value = GetTickCount()-TimeTest;
   sys[31].name  = "Test Random";
   sys[31].size  = "MilSek";
   txt=" 22 Testing Random "+IntegerToString(sys[31].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(ii=0;ii<10000;ii++)
      for(jj=0;jj<10000;jj++)
         test_oop.TestRandom_(ii+jj);
   sys[32].value = GetTickCount()-TimeTest;
   sys[32].name  = "Test Random OOP";
   sys[32].size  = "MilSek";
   txt=" 21 Testing Random "+IntegerToString(sys[32].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Sieve                                                    |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<22500;is++)
      TestSieve();
   sys[33].value=GetTickCount()-TimeTest;
   sys[33].name="Test Sieve";
   sys[33].size="MilSek";
   txt=" 20 Testing Sieve "+IntegerToString(sys[33].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int is=0;is<22500;is++)
      test_oop.TestSieve();
   sys[34].value=GetTickCount()-TimeTest;
   sys[34].name="Test Sieve OOP";
   sys[34].size="MilSek";
   txt=" 19 Testing Sieve OOP "+IntegerToString(sys[34].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция StrCat                                                   |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<400000;is++)
      TestStrCat();
   sys[35].value = GetTickCount()-TimeTest;
   sys[35].name  = "Test StrCat";
   sys[35].size  = "MilSek";
   txt=" 18 Testing StrCat "+IntegerToString(sys[35].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int is=0;is<400000;is++)
      test_oop.TestStrCat();
   sys[36].value = GetTickCount()-TimeTest;
   sys[36].name  = "Test StrCat OOP";
   sys[36].size  = "MilSek";
   txt=" 17 Testing StrCat OOP "+IntegerToString(sys[36].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция String                                                   |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   TestString();
   sys[37].value = GetTickCount()-TimeTest;
   sys[37].name  = "Test String";
   sys[37].size  = "MilSek";
   txt=" 16 Testing String "+IntegerToString(sys[37].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   test_oop.TestString();
   sys[38].value = GetTickCount()-TimeTest;
   sys[38].name  = "Test String OOP";
   sys[38].size  = "MilSek";
   txt=" 15 Testing String OOP "+IntegerToString(sys[38].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция StrPrep                                                  |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<14000000;is++)
      TestStrPrep();
   sys[39].value = GetTickCount()-TimeTest;
   sys[39].name  = "Test StrPrep";
   sys[39].size  = "MilSek";
   txt=" 14 Testing StrPrep "+IntegerToString(sys[39].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int is=0;is<14000000;is++)
      test_oop.TestStrPrep();
   sys[40].value = GetTickCount()-TimeTest;
   sys[40].name  = "Test StrPrep OOP";
   sys[40].size  = "MilSek";
   txt=" 13 Testing StrPrep OOP "+IntegerToString(sys[40].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция StrRev                                                   |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<20000000;is++)
      TestStrRev();
   sys[41].value = GetTickCount()-TimeTest;
   sys[41].name  = "Test StrRev";
   sys[41].size  = "MilSek";
   txt=" 12 Testing StrRev "+IntegerToString(sys[41].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int is=0;is<20000000;is++)
      test_oop.TestStrRev();
   sys[42].value = GetTickCount()-TimeTest;
   sys[42].name  = "Test StrRev OOP";
   sys[42].size  = "MilSek";
   txt=" 11 Testing StrRev OOP "+IntegerToString(sys[42].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция StrSum                                                   |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000000;is++)
      TestStrSum();
   sys[43].value = GetTickCount()-TimeTest;
   sys[43].name  = "Test StrSum";
   sys[43].size  = "MilSek";
   txt=" 10 Testing StrSum "+IntegerToString(sys[43].value)+"\n"+txt;
   Comment(txt);

   TimeTest=GetTickCount();
   for(int is=0;is<10000000;is++)
      test_oop.TestStrSum();
   sys[44].value = GetTickCount()-TimeTest;
   sys[44].name  = "Test StrSum OOP";
   sys[44].size  = "MilSek";
   txt=" 9 Testing StrSum OOP "+IntegerToString(sys[44].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция ObjectCreate                                             |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000;is++)
     {
      string name="";
      StringConcatenate(name,"Button",is);
      ButtonCreate(0,name,0,2+is,10+is);
     }
   sys[45].value = GetTickCount()-TimeTest;
   sys[45].name  = "Test ObjectCreate";
   sys[45].size  = "MilSek";
   txt=" 8 Testing ObjectCreate "+IntegerToString(sys[45].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция ObjectMove                                               |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000;is++)
     {
      string name="";
      StringConcatenate(name,"Button",is);
      ButtonMove(0,name,50,100);
     }
   sys[46].value = GetTickCount()-TimeTest;
   sys[46].name  = "Test ObjectMove";
   sys[46].size  = "MilSek";
   txt=" 7 Testing ObjectMove "+IntegerToString(sys[46].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция ObjectDelete                                               |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000;is++)
     {
      string name="";
      StringConcatenate(name,"Button",is);
      ButtonDelete(0,name);
     }
   sys[47].value = GetTickCount()-TimeTest;
   sys[47].name  = "Test ObjectDelete";
   sys[47].size  = "MilSek";
   txt=" 6 Testing ObjectDelete "+IntegerToString(sys[47].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция ObjectCreate OOP                                         |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000;is++)
     {
      string name="";
      StringConcatenate(name,"Button",is);
      test_oop.ButtonCreate(0,name,0,2+is,10+is);
     }
   sys[48].value = GetTickCount()-TimeTest;
   sys[48].name  = "Test ObjectCreate OOP";
   sys[48].size  = "MilSek";
   txt=" 5 Testing ObjectCreate OOP "+IntegerToString(sys[48].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция ObjectMove OOP                                           |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000;is++)
     {
      string name="";
      StringConcatenate(name,"Button",is);
      test_oop.ButtonMove(0,name,50,100);
     }
   sys[49].value = GetTickCount()-TimeTest;
   sys[49].name  = "Test ObjectMove OOP";
   sys[49].size  = "MilSek";
   txt=" 4 Testing ObjectMove OOP "+IntegerToString(sys[49].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция ObjectDelete OOP                                         |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(int is=0;is<10000;is++)
     {
      string name="";
      StringConcatenate(name,"Button",is);
      test_oop.ButtonDelete(0,name);
     }
   sys[50].value = GetTickCount()-TimeTest;
   sys[50].name  = "Test ObjectDelete OOP";
   sys[50].size  = "MilSek";
   txt=" 3 Testing ObjectDelete OOP "+IntegerToString(sys[50].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция CopyRates                                                |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   MqlRates rates[];
   int copied=CopyRates(Symbol(),PERIOD_M1,0,1000000,rates);
   sys[51].value=GetTickCount()-TimeTest;
   sys[51].name  = "Test CopyRates";
   sys[51].size  = "MilSek";
   txt=" 2 Testing CopyRates "+IntegerToString(sys[51].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция canvas                                                   |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   string ObjName="test";
   canvas.CreateBitmapLabel(ObjName,100,20,800,800,COLOR_FORMAT_ARGB_NORMALIZE);
   for(int is=0;is<10000;is++)
     {
      canvas.Rectangle(MathRand()&255,MathRand()&255,256+(MathRand()&255),256+(MathRand()&255),XRGB(MathRand(),MathRand(),MathRand()));
      canvas.Circle(MathRand()&511,MathRand()&511,MathRand()&127,XRGB(MathRand(),MathRand(),MathRand()));
      canvas.Triangle(MathRand()&511,MathRand()&511,MathRand()&511,MathRand()&511,MathRand()&511,MathRand()&511,XRGB(MathRand(),MathRand(),MathRand()));
      //---
      canvas.Update(true);
     }
   ObjectDelete(0,ObjName);
   sys[52].value=GetTickCount()-TimeTest;
   sys[52].name  = "Test Canvas";
   sys[52].size  = "MilSek";
   txt=" 1 Testing Canvas "+IntegerToString(sys[52].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Функция Hello                                                    |
//+------------------------------------------------------------------+
   TimeTest=GetTickCount();
   for(i=0;i<700000;i++)
      Print("Hello, world!!!");
   sys[53].value = GetTickCount()-TimeTest;
   sys[53].name  = "Test Print(Hello, world!!!)";
   sys[53].size  = "MilSek";
   txt=" 33 Testing Hello "+IntegerToString(sys[53].value)+"\n"+txt;
   Comment(txt);
//+------------------------------------------------------------------+
//| Final                                                            |
//+------------------------------------------------------------------+
   sys[54].name  = "Test Final ";
   sys[54].value = GetTickCount()-StartTimeTest;
   sys[54].size  = "MilSek";
   txt="\n"+"Result Time = "+IntegerToString(sys[54].value)+" "+sys[54].size+"\n"+txt;
   Comment(txt);

   Deinit();
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void Deinit()
  {
   string time=TimeToString(TimeLocal());  StringReplace(time,":"," ");
   StringConcatenate(file_nameTES,"System Test"+"\\System Test "+time,".csv");
   Write();
   ShellExecuteW(NULL,"open",TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\"+file_nameTES,NULL,NULL,1);

   string name="";
   StringConcatenate(name,"System Test","\\big_file",".bin");
   FileDelete(name);
  }
//+------------------------------------------------------------------+
//| Запись в файл                                                    |
//+------------------------------------------------------------------+
void Write(void)
  {
   file_handleTES=FileOpen(file_nameTES,FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(file_handleTES!=INVALID_HANDLE)
     {
      for(int i=0; i<ArraySize(sys); i++)
         FileWrite(file_handleTES,sys[i].name,sys[i].value,sys[i].size);
     }
   else
      Print(GetLastError());
   FileClose(file_handleTES);
  }
//+------------------------------------------------------------------+
//| Функция тестирования Ackermann                                   |
//+------------------------------------------------------------------+
int TestAckermann(int m,int n)
  {
   if(m==0) return(n+1);
   if(n==0) return(TestAckermann(m-1,1));
   return(TestAckermann(m-1,TestAckermann(m,(n-1))));
  }
//+------------------------------------------------------------------+
//| Метод тестирования AckermannOOP                                  |
//+------------------------------------------------------------------+
int SystemTest :: TestAckermann(int m,int n)
  {
   if(m==0) return(n+1);
   if(n==0) return(TestAckermann(m-1,1));
   return(TestAckermann(m-1,TestAckermann(m,(n-1))));
  }
//+------------------------------------------------------------------+
//| Функция пузырьковой сортировки                                   |
//+------------------------------------------------------------------+
void BubbleSort(int &arr[],int left,int right)
  {
   for(int i=left+1;i<=right;i++)
      for(int j=right;j>=i;j--)
         if(arr[j-1]>arr[j])
           {
            int xx=arr[j];
            arr[j]=arr[j-1];
            arr[j-1]=xx;
           }
  }
//+------------------------------------------------------------------+
//| Функция пузырьковой сортировки OOP                               |
//+------------------------------------------------------------------+
void SystemTest :: BubbleSort(int &arr[],int left,int right)
  {
   for(int i=left+1;i<=right;i++)
      for(int j=right;j>=i;j--)
         if(arr[j-1]>arr[j])
           {
            int xx=arr[j];
            arr[j]=arr[j-1];
            arr[j-1]=xx;
           }
  }
//+------------------------------------------------------------------+
//| Функция тестирования Call                                        |
//+------------------------------------------------------------------+
void TestCall(int n)
  {
  }
//+------------------------------------------------------------------+
//| Функция тестирования Call OOP                                    |
//+------------------------------------------------------------------+
void SystemTest :: TestCall(int n)
  {
  }
//+------------------------------------------------------------------+
//| Функция тестирования Fibo                                        |
//+------------------------------------------------------------------+
long TestFibo(long n)
  {
   if(n<2) return(1);
   return(TestFibo(n-2)+TestFibo(n-1));
  }
//+------------------------------------------------------------------+
//| Функция тестирования Fibo OOP                                    |
//+------------------------------------------------------------------+
long SystemTest :: TestFibo(long n)
  {
   if(n<2) return(1);
   return(TestFibo(n-2)+TestFibo(n-1));
  }
//+------------------------------------------------------------------+
//| Функция тестирования Float                                       |
//+------------------------------------------------------------------+
void TestFloat()
  {
   double f0=0;
   double f1=123.456789;
   double f2=98765.12345678998765432;
   double f3=12345678943.98;
   for(int i=0;i<35000;i++)
      for(int j=0;j<35000;j++)
        {
         f0=(f1/(i+1))-f2+(f3*i);
        }
  }
//+------------------------------------------------------------------+
//| Функция тестирования Float OOP                                   |
//+------------------------------------------------------------------+
void SystemTest :: TestFloat()
  {
   double f0=0;
   double f1=123.456789;
   double f2=98765.12345678998765432;
   double f3=12345678943.98;
   for(int i=0;i<35000;i++)
      for(int j=0;j<35000;j++)
        {
         f0=(f1/(i+1))-f2+(f3*i);
        }
  }
//+------------------------------------------------------------------+
//| Функция тестирования Matrix                                      |
//+------------------------------------------------------------------+
void TestMatrix()
  {
   int i,j,k,val;
//--- перемножение матриц
   for(i=0;i<168;i++)
     {
      for(j=0;j<168;j++)
        {
         val=0;
         for(k=0;k<168;k++)
           {
            val+=m1[i][k]*m2[k][j];
           }
         mm[i][j]=val;
        }
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования Matrix OOP                                  |
//+------------------------------------------------------------------+
void SystemTest :: TestMatrix()
  {
   int i,j,k,val;
//--- перемножение матриц
   for(i=0;i<168;i++)
     {
      for(j=0;j<168;j++)
        {
         val=0;
         for(k=0;k<168;k++)
           {
            val+=m1[i][k]*m2[k][j];
           }
         mm[i][j]=val;
        }
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования Moments                                     |
//+------------------------------------------------------------------+
double TestRandom(double max)
  {
   static long last=42;
//---
   last=(last*3877+29573)%139968;
   return(max*last/139968);
  }
//+------------------------------------------------------------------+
//| Функция тестирования Moments                                     |
//+------------------------------------------------------------------+
double SystemTest :: TestRandom(double max)
  {
   static long last=42;
//---
   last=(last*3877+29573)%139968;
   return(max*last/139968);
  }
//+------------------------------------------------------------------+  
//| Функция тестирования Moments                                     |
//+------------------------------------------------------------------+
void TestMoments()
  {
   int i,mid=0;
   double sum=0.0;
   double mean=0.0;
   double average_deviation=0.0;
   double standard_deviation=0.0;
   double variance=0.0;
   double skew=0.0;
   double kurtosis=0.0;
   double median=0.0;
   double deviation=0.0;
   int array_size=4096;
//---
   mean = sum/5750;
   for(i=0; i<5750; i++)
     {
      deviation=nums[i]-mean;
      average_deviation+=MathAbs(deviation);
      variance+=MathPow(deviation,2);
      skew+=MathPow(deviation,3);
      kurtosis+=MathPow(deviation,4);
     }
   average_deviation/=5750;
   variance/=(5750-1);
   standard_deviation=MathSqrt(variance);
   if(variance)
     {
      skew/=(5750*variance*standard_deviation);
      kurtosis=(kurtosis/(5750*variance*variance))-3.0;
     }
   mid=(5750/2);
   median=bool(5750%2) ? nums[mid]:(nums[mid]+nums[mid-1])/2;
  }
//+------------------------------------------------------------------+
//| Функция тестирования Moments OOP                                 |
//+------------------------------------------------------------------+
void SystemTest :: TestMoments()
  {
   int i,mid=0;
   double sum=0.0;
   double mean=0.0;
   double average_deviation=0.0;
   double standard_deviation=0.0;
   double variance=0.0;
   double skew=0.0;
   double kurtosis=0.0;
   double median=0.0;
   double deviation=0.0;
   int array_size=4096;
//---
   mean = sum/5750;
   for(i=0; i<5750; i++)
     {
      deviation=nums[i]-mean;
      average_deviation+=MathAbs(deviation);
      variance+=MathPow(deviation,2);
      skew+=MathPow(deviation,3);
      kurtosis+=MathPow(deviation,4);
     }
   average_deviation/=5750;
   variance/=(5750-1);
   standard_deviation=MathSqrt(variance);
   if(variance)
     {
      skew/=(5750*variance*standard_deviation);
      kurtosis=(kurtosis/(5750*variance*variance))-3.0;
     }
   mid=(5750/2);
   median=bool(5750%2) ? nums[mid]:(nums[mid]+nums[mid-1])/2;
  }
//+------------------------------------------------------------------+
//| Функция тестирования NestedLoop                                  |
//+------------------------------------------------------------------+
void TestNestedLoop()
  {
   int a,b,c,d,e,f,xx=0;
//---
   for(a=0; a<38; a++)
      for(b=0; b<38; b++)
         for(c=0; c<38; c++)
            for(d=0; d<38; d++)
               for(e=0; e<38; e++)
                  for(f=0; f<38; f++)
                     xx++;
  }
//+------------------------------------------------------------------+
//| Функция тестирования NestedLoop OOP                              |
//+------------------------------------------------------------------+
void SystemTest :: TestNestedLoop()
  {
   int a,b,c,d,e,f,xx=0;
//---
   for(a=0; a<38; a++)
      for(b=0; b<38; b++)
         for(c=0; c<38; c++)
            for(d=0; d<38; d++)
               for(e=0; e<38; e++)
                  for(f=0; f<38; f++)
                     xx++;
  }
//+------------------------------------------------------------------+
//| Функция тестирования PiCalculated                                |
//+------------------------------------------------------------------+
bool PiCalculate(const int digits)
  {
   static int    api[(22000/4+1)*14]; // PiCalculated
   int d = 0,e,b,g,r;
   int c = (digits/4+1)*14;
   int f = 10000;
   string str;
//---
   for(int i=0;i<c;i++)
      api[i]=20000000;
//---
   while((b=c-=14)>0)
     {
      d=e=d%f;
      while(--b>0)
        {
         d = d * b + api[b];
         g = (b << 1) - 1;
         api[b]=(d%g)*f;
         d/=g;
        }
      r=e+d/f;
      if(r<1000)
        {
         if(r>99) str+="0";
         else
           {
            if(r > 9) str+="00";
            else      str+="000";
           }
        }
      str+=IntegerToString(r);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Функция тестирования PiCalculated OOP                            |
//+------------------------------------------------------------------+
bool SystemTest :: PiCalculate(const int digits)
  {
   static int    api[(22000/4+1)*14]; // PiCalculated
   int d = 0,e,b,g,r;
   int c = (digits/4+1)*14;
   int f = 10000;
   string str;
//---
   for(int i=0;i<c;i++)
      api[i]=20000000;
//---
   while((b=c-=14)>0)
     {
      d=e=d%f;
      while(--b>0)
        {
         d = d * b + api[b];
         g = (b << 1) - 1;
         api[b]=(d%g)*f;
         d/=g;
        }
      r=e+d/f;
      if(r<1000)
        {
         if(r>99) str+="0";
         else
           {
            if(r > 9) str+="00";
            else      str+="000";
           }
        }
      str+=IntegerToString(r);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Функция быстрой сортировки                                       |
//+------------------------------------------------------------------+
void QuickSort(int &arr[],int left,int right)
  {
   int i=left;
   int j=right;
   int center=arr[(i+j)/2];
   int x;
//---
   while(i<=j)
     {
      while(arr[i]<center && i<right) i++;
      while(arr[j]>center && j>left) j--;
      if(i<=j)
        {
         x=arr[i];
         arr[i]=arr[j];
         arr[j]=x;
         i++;
         j--;
        }
     }
   if(left<j) QuickSort(arr,left,j);
   if(right>i) QuickSort(arr,i,right);
  }
//+------------------------------------------------------------------+
//| Функция быстрой сортировки OOP                                   |
//+------------------------------------------------------------------+
void SystemTest :: QuickSort(int &arr[],int left,int right)
  {
   int i=left;
   int j=right;
   int center=arr[(i+j)/2];
   int xx;
//---
   while(i<=j)
     {
      while(arr[i]<center && i<right) i++;
      while(arr[j]>center && j>left) j--;
      if(i<=j)
        {
         xx=arr[i];
         arr[i]=arr[j];
         arr[j]=xx;
         i++;
         j--;
        }
     }
   if(left<j) QuickSort(arr,left,j);
   if(right>i) QuickSort(arr,i,right);
  }
//+------------------------------------------------------------------+
//| Функция тестирования Random                                      |
//+------------------------------------------------------------------+
double TestRandom_(double max)
  {
   static long last=42;
//---
   last=(last*3877+29573)%139968;
   return(max*last/139968);
  }
//+------------------------------------------------------------------+
//| Функция тестирования Random OOP                                  |
//+------------------------------------------------------------------+
double SystemTest :: TestRandom_(double max)
  {
   static long last=42;
//---
   last=(last*3877+29573)%139968;
   return(max*last/139968);
  }
//+------------------------------------------------------------------+
//| Функция тестирования Sieve                                       |
//+------------------------------------------------------------------+
void TestSieve()
  {
   static int flags[22500];
   int      i,k,count=0;
//---
   for(i=1;i<22500;i++)
      flags[i]=1;
//---
   for(i=1;i<22500;i++)
     {
      if(flags[i])
        {
         for(k=i+i;k<22500;k+=i)
            flags[k]=0;
         count++;
        }
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования Sieve OOP                                   |
//+------------------------------------------------------------------+
void SystemTest :: TestSieve()
  {
   static int flags[22500];
   int      i,k,count=0;
//---
   for(i=1;i<22500;i++)
      flags[i]=1;
//---
   for(i=1;i<22500;i++)
     {
      if(flags[i])
        {
         for(k=i+i;k<22500;k+=i)
            flags[k]=0;
         count++;
        }
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrCat                                      |
//+------------------------------------------------------------------+
void TestStrCat()
  {
   static string str="";
   str=str+"Hello\n";
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrCat OOP                                  |
//+------------------------------------------------------------------+
void SystemTest :: TestStrCat()
  {
   static string str="";
   str=str+"Hello\n";
  }
//+------------------------------------------------------------------+
//| Функция тестирования String                                      |
//+------------------------------------------------------------------+
void TestString()
  {
   static string str;
   for(int i=0;i<6000000;i++)
     {
      str=">>>>>>>>>>>>>>>>>...>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
      str+="Мама ";
      str+="мыла ";
      str+="раму";
      str+="\n";
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования String OOP                                  |
//+------------------------------------------------------------------+
void SystemTest :: TestString()
  {
   static string str;
   for(int i=0;i<6000000;i++)
     {
      str=">>>>>>>>>>>>>>>>>...>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
      str+="Мама ";
      str+="мыла ";
      str+="раму";
      str+="\n";
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrPrep                                     |
//+------------------------------------------------------------------+
void TestStrPrep()
  {
   static string str="Print(\"Тестирование разбора строки \",res,\" мс.\");";
   int  i,c,nl,nw,nc;
   bool space;
//---
   space=true;
   nl=nw=nc=0;
//---
   nc+=StringLen(str);
   for(i=0; i<nc; i++)
     {
      c=StringGetCharacter(str,i);
      if(c=='\n')
         ++nl;
      if(c==' ' || c=='\r' || c=='\n' || c=='\t' || c=='\"')
         space=true;
      else
        {
         if(space)
           {
            space=false;
            ++nw;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrPrep OOP                                 |
//+------------------------------------------------------------------+
void SystemTest :: TestStrPrep()
  {
   static string str="Print(\"Тестирование разбора строки \",res,\" мс.\");";
   int  i,c,nl,nw,nc;
   bool space;
//---
   space=true;
   nl=nw=nc=0;
//---
   nc+=StringLen(str);
   for(i=0; i<nc; i++)
     {
      c=StringGetCharacter(str,i);
      if(c=='\n')
         ++nl;
      if(c==' ' || c=='\r' || c=='\n' || c=='\t' || c=='\"')
         space=true;
      else
        {
         if(space)
           {
            space=false;
            ++nw;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrRev                                      |
//+------------------------------------------------------------------+
void TestStrRev()
  {
   static string str="Hello, world!!!\n";
   string rev;
   int len=StringLen(str);
//---
   for(int i=0;i<len;i++)
     {
      StringSetCharacter(rev,i,StringGetCharacter(str,len-i-1));
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrRev OOP                                  |
//+------------------------------------------------------------------+
void SystemTest :: TestStrRev()
  {
   static string str="Hello, world!!!\n";
   string rev;
   int len=StringLen(str);
//---
   for(int i=0;i<len;i++)
     {
      StringSetCharacter(rev,i,StringGetCharacter(str,len-i-1));
     }
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrSum                                      |
//+------------------------------------------------------------------+
void TestStrSum()
  {
   string str1="111";
   string str2="999";
   long sum=StringToInteger(str1)+StringToInteger(str2);
  }
//+------------------------------------------------------------------+
//| Функция тестирования StrSum                                      |
//+------------------------------------------------------------------+
void SystemTest :: TestStrSum()
  {
   string str1="111";
   string str2="999";
   long sum=StringToInteger(str1)+StringToInteger(str2);
  }
//+------------------------------------------------------------------+ 
//| Создает кнопку                                                   | 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               xx=0,                     // координата по оси X 
                  const int               yy=0,                     // координата по оси Y 
                  const int               width=50,                 // ширина кнопки 
                  const int               height=18,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                  const string            text="Button",            // текст 
                  const string            font="Arial",             // шрифт 
                  const int               font_size=10,             // размер шрифта 
                  const color             clr=clrBlack,             // цвет текста 
                  const color             back_clr=C'236,233,216',  // цвет фона 
                  const color             border_clr=clrNONE,       // цвет границы 
                  const bool              state=false,              // нажата/отжата 
                  const bool              back=false,               // на заднем плане 
                  const bool              selection=false,          // выделить для перемещений 
                  const bool              hidden=true,              // скрыт в списке объектов 
                  const long              z_order=0)                // приоритет на нажатие мышью 
  {
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,": не удалось создать кнопку! Код ошибки = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Перемещает кнопку                                                | 
//+------------------------------------------------------------------+ 
bool ButtonMove(const long   chart_ID=0,const string name="Button",const int xx=0,const int yy=0)
  {
   ResetLastError();
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx))
     {
      Print(__FUNCTION__,": не удалось переместить X-координату кнопки! Код ошибки = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy))
     {
      Print(__FUNCTION__,": не удалось переместить Y-координату кнопки! Код ошибки = ",GetLastError());
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Удаляет кнопку                                                   | 
//+------------------------------------------------------------------+ 
bool ButtonDelete(const long   chart_ID=0,const string name="Button")
  {

   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,": не удалось удалить кнопку! Код ошибки = ",GetLastError());
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Создает кнопку                                                   | 
//+------------------------------------------------------------------+ 
bool SystemTest :: ButtonCreate(const long              chart_ID=0,               // ID графика 
                                const string            name="Button",            // имя кнопки 
                                const int               sub_window=0,             // номер подокна 
                                const int               xx=0,                     // координата по оси X 
                                const int               yy=0,                     // координата по оси Y 
                                const int               width=50,                 // ширина кнопки 
                                const int               height=18,                // высота кнопки 
                                const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                                const string            text="Button",            // текст 
                                const string            font="Arial",             // шрифт 
                                const int               font_size=10,             // размер шрифта 
                                const color             clr=clrBlack,             // цвет текста 
                                const color             back_clr=C'236,233,216',  // цвет фона 
                                const color             border_clr=clrNONE,       // цвет границы 
                                const bool              state=false,              // нажата/отжата 
                                const bool              back=false,               // на заднем плане 
                                const bool              selection=false,          // выделить для перемещений 
                                const bool              hidden=true,              // скрыт в списке объектов 
                                const long              z_order=0)                // приоритет на нажатие мышью 
  {
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,": не удалось создать кнопку! Код ошибки = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Перемещает кнопку                                                | 
//+------------------------------------------------------------------+ 
bool SystemTest :: ButtonMove(const long   chart_ID=0,const string name="Button",const int xx=0,const int yy=0)
  {
   ResetLastError();
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx))
     {
      Print(__FUNCTION__,": не удалось переместить X-координату кнопки! Код ошибки = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy))
     {
      Print(__FUNCTION__,": не удалось переместить Y-координату кнопки! Код ошибки = ",GetLastError());
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Удаляет кнопку                                                   | 
//+------------------------------------------------------------------+ 
bool SystemTest :: ButtonDelete(const long   chart_ID=0,const string name="Button")
  {

   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,": не удалось удалить кнопку! Код ошибки = ",GetLastError());
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
