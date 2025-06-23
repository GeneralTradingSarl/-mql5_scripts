//+------------------------------------------------------------------+
//|                                                          MQLUnit |
//|                                   Copyright 2021, Niklas Schlimm |
//|                             https://github.com/nschlimm/MQL5Unit |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Niklas Schlimm"
#property version   "1.00"

#include "MQLUnitTestLibrary.mqh"

int m_movingAverageHandle;

void OnInit() {
   m_testSuite = ComposeTestsuite();
};

//+------------------------------------------------------------------+
//| Simple test example on moving average indicator
//+------------------------------------------------------------------+
CUnitTestSuite* ComposeTestsuite()
  {
   CUnitTestSuite* testSuite = new CUnitTestSuite();
   testSuite.AddSetupFunction(1, Test_Indicators_copyBuffer_setup);
   testSuite.AddUnitTestFunction(2,Test_Indicators_copyBuffer);
   testSuite.AddTearDownFunction(3, Test_Indicators_copyBuffer_tearDown);
   return testSuite;
  }

//+------------------------------------------------------------------+
//| Setup method to initialize indicator
//+------------------------------------------------------------------+
void Test_Indicators_copyBuffer_setup()
  {
   // initialize indicator
   m_movingAverageHandle=iMA(_Symbol, PERIOD_CURRENT,10,0,MODE_SMA,PRICE_CLOSE);
  }

//+------------------------------------------------------------------+
//| Tear down and remove indicator
//+------------------------------------------------------------------+
void Test_Indicators_copyBuffer_tearDown()
  {
   // remove indicator
   m_movingAverageHandle=NULL;
  }

//+------------------------------------------------------------------+
//| Test on indicator
//+------------------------------------------------------------------+
CUnitTestAsserts* Test_Indicators_copyBuffer()
  {
   CUnitTestAsserts* ut = new CUnitTestAsserts("Test_Indicators_copyBuffer");
   double movingAverageData[];
   CopyBuffer(m_movingAverageHandle,0,1,10,movingAverageData);
   // check if data is copied to local array
   ut.IsTrue(__FILE__, __LINE__, movingAverageData[0] > 0);
   return ut;
  }

//+------------------------------------------------------------------+
