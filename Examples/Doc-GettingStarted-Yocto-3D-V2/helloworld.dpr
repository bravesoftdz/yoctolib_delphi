program helloworld;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  yocto_api,
  yocto_tilt,
  yocto_compass,
  yocto_accelerometer,
  yocto_gyro;

Procedure  Usage();
  var
   exe : string;

  begin
    exe:= ExtractFileName(paramstr(0));
    WriteLn(exe+' <serial_number>');
    WriteLn(exe+' <logical_name>');
    WriteLn(exe+' any');
    halt;
  End;

var
  m             : TYmodule;
  anytilt,tilt1,tilt2   : TYTilt;
  Compass       : TYcompass;
  accelerometer : TYAccelerometer;
  gyro          : TYGyro;
  errmsg,serial : string;
  done          : boolean;
  count         : integer;

begin
   if (paramcount<1) then usage();

  // Setup the API to use local USB devices
  if yRegisterHub('usb', errmsg)<>YAPI_SUCCESS then
  begin
    Write('RegisterHub error: '+errmsg);
    exit;
  end;

  if paramstr(1)='any' then
    begin
      // lets try to find the first available tilt sensor
      anytilt := yFirstTilt();
      if anytilt=nil then
         begin
           writeln('No module connected (check USB cable)');
           halt;
         end
       end
   else
  // or the one specified on command line
  anytilt:= YFindTilt(paramstr(1)+'.tilt1');

  // make sure it is online
  if  not anytilt.isOnline() then
    begin
      writeln('No module connected (check USB cable)');
      halt;
    end;

  // lets find the parent module so we can get the other sensors
  m      :=  anytilt.get_module();
  serial :=  m.get_serialNumber();

  // retreive some sensors present on the yocto-3D
  tilt1         := yFindTilt(serial+'.tilt1');
  tilt2         := yFindTilt(serial+'.tilt2');
  compass       := yFindCompass(serial+'.compass');
  accelerometer :=  yFindaccelerometer(serial+'.accelerometer');
  gyro          :=yFindGyro(serial+'.gyro');

  // let's poll
  done := false;
  count :=0;

  repeat
    if (tilt1.isOnline()) then
     begin
       if (count mod 10=0) then   Writeln('tilt1'#9'tilt2'#9'compass'#9'acc'#9'gyro');
       Write(FloatToStr(tilt1.get_currentValue())+#9);
       Write(FloatToStr(tilt2.get_currentValue())+#9);
       Write(FloatToStr(compass.get_currentValue())+#9);
       Write(FloatToStr(accelerometer.get_currentValue())+#9);
       Writeln(FloatToStr(gyro.get_currentValue()));
       inc(count);
       Sleep(100);
     end
    else
     begin
       Writeln('Module not connected (check identification and USB cable)');
       done := true;
     end;
  until done;
end.