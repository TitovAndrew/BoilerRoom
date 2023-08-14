const string DistrIsRandom = "System1:DISTR.isRandom";
const string DistrLowerBound = "System1:DISTR.LowerBound";
const string DistrUpperBound = "System1:DISTR.UpperBound";

const string ValveGas1IsOpen = "System1:valve_gas1.isOpened";
const string ValveGas2IsOpen = "System1:valve_gas2.isOpened";
const string ValveOil1IsOpen = "System1:valve_oil1.isOpened";
const string ValveOil2IsOpen = "System1:valve_oil2.isOpened";
const string ValveWater1IsOpen = "System1:valve_water1.isOpened";
const string ValveWater2IsOpen = "System1:valve_water2.isOpened";
const string ValveSteam1IsOpen = "System1:valve_steam1.isOpened";
const string ValveSteam2IsOpen = "System1:valve_steam2.isOpened";

const string Burner1IsOn = "System1:burner1.States.isOn";
const string Burner2IsOn = "System1:burner2.States.isOn";
const string OilPumpIsOn = "System1:oil_pump.States.isOn";
const string WaterPumpIsOn = "System1:water_pump.States.isOn";
const string GasFanIsOn = "System1:gas_fan.States.isOn";
const string SteamFanIsOn = "System1:steam_fan.States.isOn";

const string Burner1CanWork = "System1:burner1.States.CanWork";
const string Burner2CanWork = "System1:burner2.States.CanWork";
const string OilPumpCanWork = "System1:oil_pump.States.CanWork";
const string WaterPumpCanWork = "System1:water_pump.States.CanWork";
const string GasFanCanWork = "System1:gas_fan.States.CanWork";
const string SteamFanCanWork = "System1:steam_fan.States.CanWork";

const string Burner1InRepair = "System1:burner1.States.Repair";
const string Burner2InRepair = "System1:burner2.States.Repair";
const string OilPumpInRepair = "System1:oil_pump.States.Repair";
const string WaterPumpInRepair = "System1:water_pump.States.Repair";
const string GasFanInRepair = "System1:gas_fan.States.Repair";
const string SteamFanInRepair = "System1:steam_fan.States.Repair";

const string Burner1FailProb = "System1:burner1.Inputs.FailureProb";
const string Burner2FailProb = "System1:burner2.Inputs.FailureProb";
const string OilPumpFailProb = "System1:oil_pump.Inputs.FailureProb";
const string WaterPumpFailProb = "System1:water_pump.Inputs.FailureProb";
const string GasFanFailProb = "System1:gas_fan.Inputs.FailureProb";
const string SteamFanFailProb = "System1:steam_fan.Inputs.FailureProb";

const string OilPumpPerc = "System1:oil_pump.Inputs.PercentageWork";
const string WaterPumpPerc = "System1:water_pump.Inputs.PercentageWork";
const string GasFanPerc = "System1:gas_fan.Inputs.PercentageWork";

const string Burner1NoFuel = "System1:burner1.alarm.no_fuel";
const string Burner2NoFuel = "System1:burner2.alarm.no_fuel";

const string Pres1 = "System1:pres_meter1.Pressure";
const string Pres2 = "System1:pres_meter2.Pressure";
const string Pres1IsOn = "System1:pres_meter1.States.isOn";
const string Pres2IsOn = "System1:pres_meter2.States.isOn";

const string Temp1 = "System1:temp_sensor1.Temperature";
const string Temp2 = "System1:temp_sensor2.Temperature";
const string Temp1IsOn = "System1:temp_sensor1.States.isOn";
const string Temp2IsOn = "System1:temp_sensor2.States.isOn";

const string IsAuto = "System1:AUTO.isOn";

int Burner1Counter = 0;
int Burner2Counter = 0;
int OilPumpCounter = 0;
int WaterPumpCounter = 0;
int GasFanCounter = 0;
int SteamFanCounter = 0;

//const string OilPumpValue = "System1:oil_pump.Inputs.PercentageWork";

main()
{
  float floatValue = 0;
  double border_random = 32767;

  int res;
  bool isRandom, isAuto;
  int lowerBound;
  int upperBound;
  
  float test;
  
  while (true)
  {
    dpGet(IsAuto, isAuto);
    if (isAuto)
    {
      openAllValves();
      
      turnonAll();
      delay(0,050);
      
      repairAll();
    }
    
    dpGet(DistrIsRandom, isRandom);
    DebugN(isRandom);

    if (isRandom)
    {
      dpGet(DistrLowerBound, lowerBound);
      dpGet(DistrUpperBound, upperBound);

      floatValue = (int) (NormValue(lowerBound, upperBound));//(uniform_law(rand()/32767.0, lowerBound, upperBound));
      DebugN(floatValue);
      dpSet(OilPumpPerc, floatValue);
    }
    delay(0,050);
    countTemp1();
    countTemp2();
    
    countPres1();
    countPres2();
    delay(0,050);
    checkBreakNoFuel(Burner1IsOn, Burner1CanWork, Burner1NoFuel, ValveGas1IsOpen, ValveOil1IsOpen);
    checkBreakNoFuel(Burner2IsOn, Burner2CanWork, Burner2NoFuel, ValveGas2IsOpen, ValveOil2IsOpen);
    delay(0,050);
    tryBreakBurner1();
    tryBreakBurner2();
    tryBreakOilPump();
    tryBreakWaterPump();
    tryBreakGasFan();
    tryBreakSteamFan();
    
    delay(0,800);
    
    test = NormValue(50, 10);
    DebugN("норм распределение", test);
  }  
}

void openAllValves()
{
  dpSet(ValveGas1IsOpen, true);
  dpSet(ValveGas2IsOpen, true);
  dpSet(ValveOil1IsOpen, true);
  dpSet(ValveOil2IsOpen, true);
  dpSet(ValveWater1IsOpen, true);
  dpSet(ValveWater2IsOpen, true);
  dpSet(ValveSteam1IsOpen, true);
  dpSet(ValveSteam2IsOpen, true);
}

void turnonAll()
{
  bool bcw1, bcw2, opc, wpc, gfc, sfc, bio1, bio2, opio, wpio, gfio, sfio, temp1, temp2, pres1, pres2;
  dpGet(Burner1CanWork, bcw1);
  dpGet(Burner2CanWork, bcw2);
  dpGet(OilPumpCanWork, opc);
  dpGet(WaterPumpCanWork, wpc);
  dpGet(GasFanCanWork, gfc);
  dpGet(SteamFanCanWork, sfc);
  
  dpGet(Burner1IsOn, bio1);
  dpGet(Burner2IsOn, bio2);
  dpGet(OilPumpIsOn, opio);
  dpGet(WaterPumpIsOn, wpio);
  dpGet(GasFanIsOn, gfio);
  dpGet(SteamFanIsOn, sfio);
  
  dpGet(Temp1IsOn, temp1);
  dpGet(Temp2IsOn, temp2);
  dpGet(Pres1IsOn, pres1);
  dpGet(Pres2IsOn, pres2);
  
  if(bcw1 && !bio1) dpSetWait(Burner1IsOn, true);
  if(bcw2 && !bio2) dpSetWait(Burner2IsOn, true);
  if(opc && !opio) dpSetWait(OilPumpIsOn, true);
  if(wpc && !wpio) dpSetWait(WaterPumpIsOn, true);
  if(gfc && !gfio) dpSetWait(GasFanIsOn, true);
  if(sfc && !sfio) dpSetWait(SteamFanIsOn, true);
  
  if(!temp1) dpSetWait(Temp1IsOn, true);
  if(!temp2) dpSetWait(Temp2IsOn, true);
  if(!pres1) dpSetWait(Pres1IsOn, true);
  if(!pres2) dpSetWait(Pres2IsOn, true);
}

void repairAll()
{
  bool bcw1, bcw2, opc, wpc, gfc, sfc;
  dpGet(Burner1CanWork, bcw1);
  dpGet(Burner2CanWork, bcw2);
  dpGet(OilPumpCanWork, opc);
  dpGet(WaterPumpCanWork, wpc);
  dpGet(GasFanCanWork, gfc);
  dpGet(SteamFanCanWork, sfc);
  //if (!bcw1) dpSetWait(Burner1CanWork, true);
  //if (!bcw2) dpSetWait(Burner2CanWork, true);
  //if (!opc) dpSetWait(OilPumpCanWork, true);
  //if (!wpc) dpSetWait(WaterPumpCanWork, true);
  //if (!gfc) dpSetWait(GasFanCanWork, true);
  //if (!sfc) dpSetWait(SteamFanCanWork, true);
  repairBurner1();
  repairBurner2();
  repairOilPump();
  repairWaterPump();
  repairGasFan();
  repairSteamFan();
}

void repairBurner1()
{
  bool canWork, inRepair;
  dpGet(Burner1CanWork, canWork);
  dpGet(Burner1InRepair, inRepair);
  if (!canWork)
  {
    if (Burner1Counter == 0) Burner1Counter = 3;
    if (!inRepair) dpSetWait(Burner1InRepair, true);
    else 
    {
      Burner1Counter = Burner1Counter - 1;
      if (Burner1Counter == 0)
      {
        dpSetWait(Burner1CanWork, true);
        dpSetWait(Burner1InRepair, false);
      }
    }
  }
}

void repairBurner2()
{
  bool canWork, inRepair;
  dpGet(Burner2CanWork, canWork);
  dpGet(Burner2InRepair, inRepair);
  if (!canWork)
  {
    if (Burner2Counter == 0) Burner2Counter = 3;
    if (!inRepair) dpSetWait(Burner2InRepair, true);
    else 
    {
      Burner2Counter = Burner2Counter - 1;
      if (Burner2Counter == 0)
      {
        dpSetWait(Burner2CanWork, true);
        dpSetWait(Burner2InRepair, false);
      }
    }
  }
}

void repairOilPump()
{
  bool canWork, inRepair;
  dpGet(OilPumpCanWork, canWork);
  dpGet(OilPumpInRepair, inRepair);
  if (!canWork)
  {
    if (OilPumpCounter == 0) OilPumpCounter = 3;
    if (!inRepair) dpSetWait(OilPumpInRepair, true);
    else 
    {
      OilPumpCounter = OilPumpCounter - 1;
      if (OilPumpCounter == 0)
      {
        dpSetWait(OilPumpCanWork, true);
        dpSetWait(OilPumpInRepair, false);
      }
    }
  }
}

void repairWaterPump()
{
  bool canWork, inRepair;
  dpGet(WaterPumpCanWork, canWork);
  dpGet(WaterPumpInRepair, inRepair);
  if (!canWork)
  {
    if (WaterPumpCounter == 0) WaterPumpCounter = 3;
    if (!inRepair) dpSetWait(WaterPumpInRepair, true);
    else 
    {
      WaterPumpCounter = WaterPumpCounter - 1;
      if (WaterPumpCounter == 0)
      {
        dpSetWait(WaterPumpCanWork, true);
        dpSetWait(WaterPumpInRepair, false);
      }
    }
  }
}

void repairGasFan()
{
  bool canWork, inRepair;
  dpGet(GasFanCanWork, canWork);
  dpGet(GasFanInRepair, inRepair);
  if (!canWork)
  {
    if (GasFanCounter == 0) GasFanCounter = 3;
    if (!inRepair) dpSetWait(GasFanInRepair, true);
    else 
    {
      GasFanCounter = GasFanCounter - 1;
      if (GasFanCounter == 0)
      {
        dpSetWait(GasFanCanWork, true);
        dpSetWait(GasFanInRepair, false);
      }
    }
  }
}

void repairSteamFan()
{
  bool canWork, inRepair;
  dpGet(SteamFanCanWork, canWork);
  dpGet(SteamFanInRepair, inRepair);
  if (!canWork)
  {
    if (SteamFanCounter == 0) SteamFanCounter = 3;
    if (!inRepair) dpSetWait(SteamFanInRepair, true);
    else 
    {
      SteamFanCounter = SteamFanCounter - 1;
      if (SteamFanCounter == 0)
      {
        dpSetWait(SteamFanCanWork, true);
        dpSetWait(SteamFanInRepair, false);
      }
    }
  }
}

void countTemp1()
{
  float wpp, p1;
  bool vso1, sfo, vwo1, wpio, bio1;
  dpGet(ValveSteam1IsOpen, vso1);
  dpGet(SteamFanIsOn, sfo);
  if ((vso1 == true)&&(sfo == true))
  {
    dpGet(ValveWater1IsOpen, vwo1);
    dpGet(WaterPumpIsOn, wpio);
    dpGet(Burner1IsOn, bio1);
    if ((vwo1 == true)&&(wpio == true)&&(bio1 == true))
    {
      dpGet(WaterPumpPerc, wpp);
      dpGet(Pres1, p1);
      dpSet(Temp1, p1*1.4 + wpp/2 + 67);
    } else dpSet(Temp1, 0);
  } else dpSet(Temp1, 0);
}

void countTemp2()
{
  float wpp, p2;
  bool vso2, sfo, vwo2, wpio, bio2;
  dpGet(ValveSteam2IsOpen, vso2);
  dpGet(SteamFanIsOn, sfo);
  if ((vso2 == true)&&(sfo == true))
  {
    dpGet(ValveWater2IsOpen, vwo2);
    dpGet(WaterPumpIsOn, wpio);
    dpGet(Burner2IsOn, bio2);
    if ((vwo2 == true)&&(wpio == true)&&(bio2 == true))
    {
      dpGet(WaterPumpPerc, wpp);
      dpGet(Pres2, p2);
      dpSet(Temp2, p2*1.4 + wpp/2 + 67);
    } else dpSet(Temp2, 0);
  } else dpSet(Temp2, 0);
}

void checkBreakNoFuel(string thisBurnerIsOn, string thisBurnerCanWork, string thisBurnerNoFuel, 
                      string thisValveGas, string thisValveOil)
{
  bool BurnerIsOn, vgo, voo, opio, gfio;
  dpGet(thisBurnerIsOn, BurnerIsOn);
  if (BurnerIsOn)
  {
    dpGet(thisValveGas, vgo);
    dpGet(thisValveOil, voo);
    dpGet(OilPumpIsOn, opio);
    dpGet(GasFanIsOn, gfio);
    if (((vgo == false)||(gfio == false))&&((voo == false)||(opio == false)))
    {
      dpSet(thisBurnerNoFuel, 1, thisBurnerCanWork, 0);
    }
  }
}

void countPres1()
{
  float counter = 0;
  bool vgo1, voo1, opio, gfio, bio1, bio2, vgo2, voo2;
  float opp, gfp;
  dpGet(ValveGas1IsOpen, vgo1);
  dpGet(ValveOil1IsOpen, voo1);
  dpGet(OilPumpIsOn, opio);
  dpGet(GasFanIsOn, gfio);
  dpGet(Burner1IsOn, bio1);
  dpGet(Burner2IsOn, bio2);
  dpGet(ValveGas2IsOpen, vgo2);
  dpGet(ValveOil2IsOpen, voo2);
  if (((vgo1 == true)&&(gfio == true))||((voo1 == true)&&(opio == true)))
  {
    if (bio1)
    {
      if ((voo1 == true)&&(opio == true)) 
      {
        dpGet(OilPumpPerc, opp);
        if ((!voo2)||(!bio2)) opp = opp*1.8;
        counter += opp;
      }
      if ((vgo1 == true)&&(gfio == true))
      {
        dpGet(GasFanPerc, gfp);
        if ((!vgo2)||(!bio2)) gfp = gfp*1.8;
        counter += gfp;
      }
      dpSet(Pres1, counter*0.6 + 15);
      DebugN("pres1 ", counter);
    }
    else dpSet(Pres1, 0);    
  }
  else dpSet(Pres1, 0);
}

void countPres2()
{
  float counter = 0;
  bool vgo1, voo1, opio, gfio, bio1, bio2, vgo2, voo2;
  float opp, gfp;
  dpGet(ValveGas1IsOpen, vgo1);
  dpGet(ValveOil1IsOpen, voo1);
  dpGet(OilPumpIsOn, opio);
  dpGet(GasFanIsOn, gfio);
  dpGet(Burner1IsOn, bio1);
  dpGet(Burner2IsOn, bio2);
  dpGet(ValveGas2IsOpen, vgo2);
  dpGet(ValveOil2IsOpen, voo2);
  if (((vgo2 == true)&&(gfio == true))||((voo2 == true)&&(opio == true)))
  {
    if (bio2)
    {
      if ((voo2 == true)&&(opio == true)) 
      {
        dpGet(OilPumpPerc, opp);
        if ((!voo1)||(!bio1)) opp = opp*1.8;
        counter += opp;
      }
      if ((vgo2 == true)&&(gfio == true))
      {
        dpGet(GasFanPerc, gfp);
        if ((!vgo1)||(!bio1)) gfp = gfp*1.8;
        counter += gfp;
      }
      dpSet(Pres2, counter*0.6 + 15);
      DebugN("pres2 ", counter);
    }
    else dpSet(Pres2, 0);    
  }
  else dpSet(Pres2, 0);
}

void tryBreakBurner1()
{
  bool isOn;
  float prob;
  dpGet(Burner1IsOn, isOn);
  if (isOn)
  {
    dpGet(Burner1FailProb, prob);
    if (isProbBroken(prob))
    {
      dpSet(Burner1CanWork, false);
    }
  }
}

void tryBreakBurner2()
{
  bool isOn;
  float prob;
  dpGet(Burner2IsOn, isOn);
  if (isOn)
  {
    dpGet(Burner2FailProb, prob);
    if (isProbBroken(prob))
    {
      dpSet(Burner2CanWork, false);
    }
  }
}

void tryBreakOilPump()
{
  bool isOn;
  float prob;
  dpGet(OilPumpIsOn, isOn);
  if (isOn)
  {
    dpGet(OilPumpFailProb, prob);
    if (isProbBroken(prob))
    {
      dpSet(OilPumpCanWork, false);
    }
  }
}

void tryBreakWaterPump()
{
  bool isOn;
  float prob;
  dpGet(WaterPumpIsOn, isOn);
  if (isOn)
  {
    dpGet(WaterPumpFailProb, prob);
    if (isProbBroken(prob))
    {
      dpSet(WaterPumpCanWork, false);
    }
  }
}

void tryBreakGasFan()
{
  bool isOn;
  float prob;
  dpGet(GasFanIsOn, isOn);
  if (isOn)
  {
    dpGet(GasFanFailProb, prob);
    if (isProbBroken(prob))
    {
      dpSet(GasFanCanWork, false);
    }
  }
}

void tryBreakSteamFan()
{
  bool isOn;
  float prob;
  dpGet(SteamFanIsOn, isOn);
  if (isOn)
  {
    dpGet(SteamFanFailProb, prob);
    if (isProbBroken(prob))
    {
      dpSet(SteamFanCanWork, false);
    }
  }
}

double uniform_law(double x, int low, int upper)
{
  return x * (upper - low + 1) + low;
}

bool isProbBroken(float prob)
{
  float currProb = rand()/32767.0;
  if (currProb > prob)
    return false;
  else
    return true;
}

float NormValue(float mo, float sko)
{
  float sum = 0, x;
  for (int i = 0 ; i < 25; i++) sum += 1.0 * rand() / 32767.0;
  x = (sqrt(2.0) * sko * (sum-12.5))/1.99661 + mo;
  if (x < 0) x = x * (-1);
  return floor(x * 10) / 10;
}
