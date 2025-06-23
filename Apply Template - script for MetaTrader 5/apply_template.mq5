//+------------------------------------------------------------------+
//|                                               apply_template.mq5 |
//|                                   Copyright 2014, byJJ           |
//|                                    http://ideiasparainvestir.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, by JJ"
#property link      "http://ideiasparainvestir.com"
#property version   "1.00"
#property script_show_inputs
#property description "Simple Script for Apply Template and/or timeframe in all charts opened"
#include  <Charts\Chart.mqh>;

input ENUM_TIMEFRAMES tempo_grafico; // Change TimeFrame - Current = dont changed
input string template_name="D"; // Name of Template (without '.tpl')
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   long currChart,prevChart=ChartFirst();
   int i=0,limit=100;
   bool errTemplate;
   while(i<limit)
     {
      currChart=ChartNext(prevChart); // Obter o ID do novo gráfico usando o ID gráfico anterior

                                      // Se o tempo grafico e diferente aplica a todos
      if(tempo_grafico!=PERIOD_CURRENT)
        {
         ChartSetSymbolPeriod(prevChart,ChartSymbol(prevChart),tempo_grafico);
        }

      // Aplica a template
      errTemplate=ChartApplyTemplate(prevChart,template_name+".tpl");
      if(!errTemplate)
        {
         Print("Erro ao adicionar a template a ",ChartSymbol(prevChart),"-> ",GetLastError());
        }
      if(currChart<0) break;          // Ter atingido o fim da lista de gráfico
      Print(i,ChartSymbol(currChart)," ID =",currChart);
      prevChart=currChart;// vamos salvar o ID do gráfico atual para o ChartNext()
      i++;// Não esqueça de aumentar o contador

     }

  }
//+------------------------------------------------------------------+
