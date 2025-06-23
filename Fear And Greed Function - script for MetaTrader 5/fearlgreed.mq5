//+------------------------------------------------------------------+
//|                                                   Fear&Greed.mq5 |
//|                                  Copyright 2022, Igor Gerasimov. |
//|                                                 tgwls2@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Igor Gerasimov."
#property link      "tgwls2@gmail.com"
#property version   "1.00"
class FearNgreed
{
private:
    uchar            prd_stp,       // the number of trading operations in the expected recovery period
                     prl_stp;       // last value of trading operations in the expected recovery period
    ushort           mtv_stp;       // the number of trading epochs
    double           sns_typ,       // type of sensitivity (0-COWARD/1-BRAVE)
                     lst_bal,       // highest account balance
                     act_bal,       // actual account balance
                     mtv_bal,       // motive account balance
                     mtl_bal,       // last value of motive account balance
                     sts_bal,       // stress account balance
                     act_eqy,       // actual equity
                     add_eqy,       // fear addition
                     lvl_mgn,       // actual margin level percent
                     cff_dec,       // balance reduction factor
                     cff_prf,       // actual profit factor
                     cff_mgn,       // margin level factor
                     cff_mtv,       // motive factor - account balance increase at the end of time
                     val_mtv,       // motive value - epoch account balance increase
                     mul_cwd,       // coward factor
                     mul_nrm,       // normal factor
                     mul_brv;       // brave factor
    bool             amp_dec,       // amplify balance reduction
                     amp_prf,       // amplify actual profit
                     amp_mgn,       // amplify margin level
                     aut_cff,       // auto tune weight factors
                     aut_stp;       // auto setup of the number of trading operations in the expected recovery period
    ENUM_TIMEFRAMES  cue_tim;       // epoch duration
    datetime         act_tim;       // actual day
public:
    FearNgreed()
    {
        sns_typ=0;
        prd_stp=4;
        prl_stp=4;
        mtv_stp=261;
        lst_bal=AccountInfoDouble(ACCOUNT_BALANCE);
        act_bal=lst_bal;
        sts_bal=lst_bal;
        act_eqy=AccountInfoDouble(ACCOUNT_EQUITY);
        add_eqy=0;
        lvl_mgn=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
        cff_dec=2;
        cff_prf=9;
        cff_mgn=1;
        cff_mtv=M_E;
        val_mtv=MathPow(cff_mtv,1/(double)mtv_stp);
        mtv_bal=lst_bal*val_mtv;
        mtl_bal=lst_bal;
        mul_cwd=1;
        mul_nrm=0;
        mul_brv=0;
        amp_dec=true;
        amp_prf=true;
        amp_mgn=true;
        aut_cff=false;
        aut_stp=false;
        cue_tim=PERIOD_D1;
        act_tim=iTime(_Symbol,cue_tim,0);
        return;
    }
    ~FearNgreed()
    {
    }
    void             SetSensitivity(const double a)
    {
        sns_typ=a<1?(a>-1?a:-1):1;
        const double t=0.5-sns_typ;
        mul_cwd=1-MathSqrt(1-MathPow(t>0?t*2:0,2));
        mul_nrm=MathSqrt(1-MathPow(MathAbs(t)*2,2));
        mul_brv=1-MathSqrt(1-MathPow(-t>0?-t*2:0,2));
        if(aut_stp) prd_stp=2+(uchar)(253*sns_typ);
        return;
    }
    double           GetSensitivity()
    {
        return(sns_typ);
    }
    void             SetTuneWeightFactors(const bool a)
    {
        aut_cff=a;
        return;
    }
    bool             GetTuneWeightFactors()
    {
        return(aut_cff);
    }
    void             SetAutoRecoverySteps(const bool a)
    {
        aut_stp=a;
        prd_stp=aut_stp?2+(uchar)(253*sns_typ):prl_stp;
        return;
    }
    bool             GetAutoRecoverySteps()
    {
        return(aut_stp);
    }
    void             SetRecoverySteps(const uchar a)
    {
        prd_stp=a>1?a:2;
        prl_stp=prd_stp;
        return;
    }
    uchar            GetRecoverySteps()
    {
        return(prd_stp);
    }
    void             SetMotiveEpoch(const ENUM_TIMEFRAMES a)
    {
        cue_tim=a;
        return;
    }
    ENUM_TIMEFRAMES  GetMotiveEpoch()
    {
        return(cue_tim);
    }
    void             SetMotiveSteps(const ushort a)
    {
        mtv_stp=a>0?(a<366?a:365):1;
        val_mtv=MathPow(cff_mtv,1/(double)mtv_stp);
        mtv_bal=mtl_bal*val_mtv;
        return;
    }
    ushort           GetMotiveSteps()
    {
        return(mtv_stp);
    }
    void             SetMotiveFactor(const double a)
    {
        cff_mtv=a>1?a:1+DBL_EPSILON;
        val_mtv=MathPow(cff_mtv,1/(double)mtv_stp);
        mtv_bal=mtl_bal*val_mtv;
        return;
    }
    double           GetMotiveFactor()
    {
        return(cff_mtv);
    }
    void             SetInitialBalance(const double a)
    {
        lst_bal=a>0?(a>=AccountInfoDouble(ACCOUNT_BALANCE)?a:AccountInfoDouble(ACCOUNT_BALANCE)):(0>=AccountInfoDouble(ACCOUNT_BALANCE)?0:AccountInfoDouble(ACCOUNT_BALANCE));
        mtv_bal=lst_bal*val_mtv;
        mtl_bal=lst_bal;
        return;
    }
    double           GetInitialBalance()
    {
        return(lst_bal);
    }
    double           GetMotiveBalance()
    {
        return(mtv_bal);
    }
    void             SetActualBalance()
    {
        act_bal=AccountInfoDouble(ACCOUNT_BALANCE);
        return;
    }
    double           GetActualBalance()
    {
        return(act_bal);
    }
    void             SetActualEquity()
    {
        act_eqy=AccountInfoDouble(ACCOUNT_EQUITY);
        return;
    }
    double           GetActualEquity()
    {
        return(act_eqy);
    }
    void             SetMarginLevel()
    {
        lvl_mgn=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
        return;
    }
    double           GetMarginLevel()
    {
        return(lvl_mgn);
    }
    void             TrailInitialBalance()
    {
        lst_bal=AccountInfoDouble(ACCOUNT_BALANCE)>lst_bal?AccountInfoDouble(ACCOUNT_BALANCE):lst_bal;
        return;
    }
    void             TrailMotiveValues()
    {
        if(act_tim!=iTime(_Symbol,cue_tim,0))
            {
                mtl_bal=mtv_bal;
                mtv_bal*=val_mtv;
                sts_bal=AccountInfoDouble(ACCOUNT_BALANCE);
                act_tim=iTime(_Symbol,cue_tim,0);
            }
        return;
    }
    void             TrailActualValues()
    {
        SetActualBalance();
        SetActualEquity();
        SetMarginLevel();
        return;
    }
    void             SetReductionAmplification(const bool a)
    {
        amp_dec=a;
        return;
    }
    bool             GetReductionAmplification()
    {
        return(amp_dec);
    }
    double           GetReductionFactor()
    {
        return(cff_dec);
    }
    double           GetReductionValue()            // Deposite Loss Fear
    {
        const double t=act_bal>0?MathPow(lst_bal/act_bal,1/(double)prd_stp)-1:1,
                     v=t<1?(t>-1?t:-1):1;
        return(amp_dec?MathSin(v*M_PI_2):v);
    }
    void             SetProfitAmplification(const bool a)
    {
        amp_prf=a;
        return;
    }
    bool             GetProfitAmplification()
    {
        return(amp_prf);
    }
    double           GetProfitFactor()
    {
        return(cff_prf);
    }
    double           GetProfitValue()               // Negative Profit Fear
    {
        const double t=MathAbs(lst_bal)>=DBL_EPSILON?(lst_bal-act_eqy)/lst_bal:0,
                     v=t<1?(t>-1?t:-1):1;
        add_eqy=t<0?-t:0;
        return(amp_prf?MathSin(v*M_PI_2):v);
    }
    void             SetMarginAmplification(const bool a)
    {
        amp_mgn=a;
        return;
    }
    bool             GetMarginAmplification()
    {
        return(amp_mgn);
    }
    double           GetMarginFactor()
    {
        return(cff_mgn);
    }
    void             SetWeightFactors(const double a,const double b,const double c) // a - balance reduction/ b - actual profit/ c - margin level
    {
        const double s=a+b+c;
        if(s!=12)
            {
                if(MathAbs(s)<DBL_EPSILON)
                    {
                        cff_dec=2;
                        cff_prf=9;
                        cff_mgn=1;
                        return;
                    }
                const double t=12/s;
                cff_dec=a*t;
                cff_prf=b*t;
                cff_mgn=c*t;
            }
        else
            {
                cff_dec=a;
                cff_prf=b;
                cff_mgn=c;
            }
        return;
    }
    double           GetMarginValue()               // Margin Call Fear
    {
        const double t=(MathIsValidNumber(lvl_mgn) && MathAbs(lvl_mgn)>=DBL_EPSILON)?100/lvl_mgn:0,
                     v=t<1?(t>-1?t:-1):1;
        return(amp_mgn?MathSin(v*M_PI_2):v);
    }
    double           GetFear()                      // General Fear
    {
        TrailActualValues();
        const double t_prf=GetProfitValue();
        double w_dec=cff_dec,w_prf=cff_prf,w_mgn=cff_mgn,t_dec=0,t_mgn=0,t=0;
        if(act_eqy<lst_bal)
            {
                if(aut_cff)
                    {
                        t_dec=GetReductionValue();
                        t_mgn=GetMarginValue();
                        const double d_dec=(12-cff_dec)/cff_dec,d_mgn=(12-cff_mgn)/cff_mgn,
                                     m=MathMax(MathMax(t_dec,MathAbs(t_prf)),t_mgn),
                                     n=MathMin(MathMin(t_dec,MathAbs(t_prf)),t_mgn),
                                     d=m-n;

                        if(MathAbs(d)>=DBL_EPSILON)
                            {
                                w_dec=cff_dec+(t_dec-n)*d_dec/d;
                                w_mgn=cff_mgn+(t_mgn-n)*d_mgn/d;
                                const double s=w_dec+w_prf+w_mgn;
                                if(MathAbs(s)<DBL_EPSILON)
                                    {
                                        w_dec=cff_dec;
                                        w_mgn=cff_mgn;
                                    }
                                else
                                    {
                                        t=12/s;
                                        w_dec*=t;
                                        w_prf*=t;
                                        w_mgn*=t;
                                    }
                            }
                    }
                t=t_dec*w_dec+t_prf*w_prf+t_mgn*w_mgn;
            }
        return(act_eqy<lst_bal?(-MathTanh(t)*mul_cwd-MathSin((t<12?(t>-12?t:-12):12)/12*M_PI_2)*mul_nrm+
                                (t>=0?MathSqrt(144-MathPow(-t>-12?-t:-12,2))/12-1:1-MathSqrt(144-MathPow(-t<12?-t:12,2))/12)*mul_brv):add_eqy);
    }
    double           GetGreed()                     // General Greed
    {
        return(1+GetFear());
    }
    double           GetMotive()                    // General Motive
    {
        TrailActualValues();
        const double t=mtv_bal-(lst_bal<mtv_bal?lst_bal:act_eqy);
        return(MathAbs(t)>=DBL_EPSILON?
               MathTanh((1-(lst_bal<mtv_bal?AccountInfoDouble(ACCOUNT_PROFIT)/t:1))/(double)prl_stp):0);
    }
    double           GetStress()                    // General Stress
    {
        const double t=sts_bal*val_mtv-sts_bal,
                     v=MathAbs(t)>=DBL_EPSILON?AccountInfoDouble(ACCOUNT_PROFIT)/(t*prl_stp):0;
        return(MathSin((v<1?(v>-1?v:-1):1)*M_PI_2));
    }
};
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    FearNgreed FnG;
    FnG.SetWeightFactors(3,7,2);                    // Set Any Positive Three Values Whose Sum Is Not Zero
    FnG.SetTuneWeightFactors(true);                 // Auto Tune Weight Factors
    FnG.SetAutoRecoverySteps(true);                 // Calculate Recovery Steps Value Depending On Sensitivity
    FnG.SetSensitivity(0.5);                        // 0 - SAFE / 0.5 - NORMAL / 1 - RISKY
//  FnG.SetInitialBalance(20000);                   // Set Any Value Equal Or Greater Than Actual Balance
    while(!IsStopped())
        {
            if(AccountInfoDouble(ACCOUNT_BALANCE)!=FnG.GetInitialBalance()) FnG.TrailInitialBalance();
            FnG.TrailMotiveValues();
            const double t=FnG.GetFear(),
                         v=FnG.GetMotive();         // Remaining Epoch Commitments To Be Done
            Comment("   Fear:    "+DoubleToString(t,5),"\n",
                    " Stress:    "+DoubleToString(FnG.GetStress(),5),"\n","\n",
                    " Greed:    "+DoubleToString(1+t,5),"\n",
                    "Motive:    "+DoubleToString(v,5));
            Sleep(999);
        }
    Comment("");
}
//+------------------------------------------------------------------+
