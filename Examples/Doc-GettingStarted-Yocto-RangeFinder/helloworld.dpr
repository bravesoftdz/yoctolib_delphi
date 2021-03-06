{*********************************************************************
 *
 *  $Id: helloworld.dpr 32621 2018-10-10 13:10:25Z seb $
 *
 *  An example that show how to use a  Yocto-RangeFinder
 *
 *  You can find more information on our web site:
 *   Yocto-RangeFinder documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-rangefinder/doc.html
 *   Delphi API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-delphi-EN.html
 *
 *********************************************************************}

program helloworld;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  yocto_api,
  yocto_rangeFinder,
  yocto_lightSensor,
  yocto_temperature;

Procedure  Usage();
  var
   exe : string;
  begin
    exe:= ExtractFileName(paramstr(0));
    WriteLn(exe+' <serial_number>');
    WriteLn(exe+' <logical_name>');
    WriteLn(exe+' any');
    sleep(2500);
    halt;
  End;

var
  rf : TYRangeFinder;
  ir : TYLightSensor;
  tmp : TYTemperature;
  m : TYModule;
  errmsg,target : string;
  done   : boolean;

begin

  if (paramcount<1) then usage();

  // Setup the API to use local USB devices
  if yRegisterHub('usb', errmsg)<>YAPI_SUCCESS then
  begin
    Write('RegisterHub error: '+errmsg);
    exit;
  end;

  target := paramstr(1);

  if target='any' then
    begin
      // search for the first available light sensor
      rf := yFirstRangeFinder();
      if rf = nil then
         begin
           writeln('No module connected (check USB cable)');
           halt;
         end;
      m := rf.get_module();
      target := m.get_serialNumber();
    end
   else // or use the one specified on command line
   rf := YFindRangeFinder(target+'.rangeFinder1');
   ir := YFindLightSensor(target+'.lightSensor1');
   tmp := YFindTemperature(target+'.temperature1');

  // lets poll the sensor
  done := false;
  repeat
    if (rf.isOnline()) then
     begin
       Writeln('Distance    : '+FloatToStr(rf.get_currentValue()));
       Writeln('Ambiant IR  : '+FloatToStr(ir.get_currentValue()));
       Writeln('Temperature : '+FloatToStr(tmp.get_currentValue()));
       Writeln('   (press Ctrl-C to exit)');
       YSleep(1000,errmsg);
     end
    else
     begin
       Writeln('Module not connected (check identification and USB cable)');
       done := true;
     end;
  until done;
  yFreeAPI();

end.
