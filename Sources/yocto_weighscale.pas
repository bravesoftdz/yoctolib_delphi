{*********************************************************************
 *
 * $Id: yocto_weighscale.pas 28561 2017-09-15 15:09:45Z seb $
 *
 * Implements yFindWeighScale(), the high-level API for WeighScale functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 *  Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 *  Yoctopuce Sarl (hereafter Licensor) grants to you a perpetual
 *  non-exclusive license to use, modify, copy and integrate this
 *  file into your software for the sole purpose of interfacing
 *  with Yoctopuce products.
 *
 *  You may reproduce and distribute copies of this file in
 *  source or object form, as long as the sole purpose of this
 *  code is to interface with Yoctopuce products. You must retain
 *  this notice in the distributed source file.
 *
 *  You should refer to Yoctopuce General Terms and Conditions
 *  for additional information regarding your rights and
 *  obligations.
 *
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *  WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *  WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS
 *  FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *  EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *  INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA,
 *  COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR
 *  SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT
 *  LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *  CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *  BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *  WARRANTY, OR OTHERWISE.
 *
 *********************************************************************}


unit yocto_weighscale;

interface

uses
  sysutils, classes, windows, yocto_api, yjson;

//--- (YWeighScale definitions)

const Y_EXCITATION_OFF = 0;
const Y_EXCITATION_DC = 1;
const Y_EXCITATION_AC = 2;
const Y_EXCITATION_INVALID = -1;
const Y_ADAPTRATIO_INVALID            = YAPI_INVALID_DOUBLE;
const Y_COMPTEMPERATURE_INVALID       = YAPI_INVALID_DOUBLE;
const Y_COMPENSATION_INVALID          = YAPI_INVALID_DOUBLE;
const Y_ZEROTRACKING_INVALID          = YAPI_INVALID_DOUBLE;
const Y_COMMAND_INVALID               = YAPI_INVALID_STRING;


//--- (end of YWeighScale definitions)

type
  TYWeighScale = class;
  //--- (YWeighScale class start)
  TYWeighScaleValueCallback = procedure(func: TYWeighScale; value:string);
  TYWeighScaleTimedReportCallback = procedure(func: TYWeighScale; value:TYMeasure);

  ////
  /// <summary>
  ///   TYWeighScale Class: WeighScale function interface
  /// <para>
  ///   The YWeighScale class provides a weight measurement from a ratiometric load cell
  ///   sensor. It can be used to control the bridge excitation parameters, in order to avoid
  ///   measure shifts caused by temperature variation in the electronics, and can also
  ///   automatically apply an additional correction factor based on temperature to
  ///   compensate for offsets in the load cell itself.
  /// </para>
  /// </summary>
  ///-
  TYWeighScale=class(TYSensor)
  //--- (end of YWeighScale class start)
  protected
  //--- (YWeighScale declaration)
    // Attributes (function value cache)
    _excitation               : Integer;
    _adaptRatio               : double;
    _compTemperature          : double;
    _compensation             : double;
    _zeroTracking             : double;
    _command                  : string;
    _valueCallbackWeighScale  : TYWeighScaleValueCallback;
    _timedReportCallbackWeighScale : TYWeighScaleTimedReportCallback;
    // Function-specific method for reading JSON output and caching result
    function _parseAttr(member:PJSONRECORD):integer; override;

    //--- (end of YWeighScale declaration)

  public
    //--- (YWeighScale accessors declaration)
    constructor Create(func:string);

    ////
    /// <summary>
    ///   Returns the current load cell bridge excitation method.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a value among <c>Y_EXCITATION_OFF</c>, <c>Y_EXCITATION_DC</c> and <c>Y_EXCITATION_AC</c>
    ///   corresponding to the current load cell bridge excitation method
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_EXCITATION_INVALID</c>.
    /// </para>
    ///-
    function get_excitation():Integer;

    ////
    /// <summary>
    ///   Changes the current load cell bridge excitation method.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a value among <c>Y_EXCITATION_OFF</c>, <c>Y_EXCITATION_DC</c> and <c>Y_EXCITATION_AC</c>
    ///   corresponding to the current load cell bridge excitation method
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_excitation(newval:Integer):integer;

    ////
    /// <summary>
    ///   Changes the compensation temperature update rate, in percents.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a floating point number corresponding to the compensation temperature update rate, in percents
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_adaptRatio(newval:double):integer;

    ////
    /// <summary>
    ///   Returns the compensation temperature update rate, in percents.
    /// <para>
    ///   the maximal value is 65 percents.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a floating point number corresponding to the compensation temperature update rate, in percents
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_ADAPTRATIO_INVALID</c>.
    /// </para>
    ///-
    function get_adaptRatio():double;

    ////
    /// <summary>
    ///   Returns the current compensation temperature.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a floating point number corresponding to the current compensation temperature
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_COMPTEMPERATURE_INVALID</c>.
    /// </para>
    ///-
    function get_compTemperature():double;

    ////
    /// <summary>
    ///   Returns the current current thermal compensation value.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a floating point number corresponding to the current current thermal compensation value
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_COMPENSATION_INVALID</c>.
    /// </para>
    ///-
    function get_compensation():double;

    ////
    /// <summary>
    ///   Changes the compensation temperature update rate, in percents.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a floating point number corresponding to the compensation temperature update rate, in percents
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_zeroTracking(newval:double):integer;

    ////
    /// <summary>
    ///   Returns the zero tracking threshold value.
    /// <para>
    ///   When this threshold is larger than
    ///   zero, any measure under the threshold will automatically be ignored and the
    ///   zero compensation will be updated.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a floating point number corresponding to the zero tracking threshold value
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_ZEROTRACKING_INVALID</c>.
    /// </para>
    ///-
    function get_zeroTracking():double;

    function get_command():string;

    function set_command(newval:string):integer;

    ////
    /// <summary>
    ///   Retrieves $AFUNCTION$ for a given identifier.
    /// <para>
    ///   The identifier can be specified using several formats:
    /// </para>
    /// <para>
    /// </para>
    /// <para>
    ///   - FunctionLogicalName
    /// </para>
    /// <para>
    ///   - ModuleSerialNumber.FunctionIdentifier
    /// </para>
    /// <para>
    ///   - ModuleSerialNumber.FunctionLogicalName
    /// </para>
    /// <para>
    ///   - ModuleLogicalName.FunctionIdentifier
    /// </para>
    /// <para>
    ///   - ModuleLogicalName.FunctionLogicalName
    /// </para>
    /// <para>
    /// </para>
    /// <para>
    ///   This function does not require that $THEFUNCTION$ is online at the time
    ///   it is invoked. The returned object is nevertheless valid.
    ///   Use the method <c>YWeighScale.isOnline()</c> to test if $THEFUNCTION$ is
    ///   indeed online at a given time. In case of ambiguity when looking for
    ///   $AFUNCTION$ by logical name, no error is notified: the first instance
    ///   found is returned. The search is performed first by hardware name,
    ///   then by logical name.
    /// </para>
    /// <para>
    ///   If a call to this object's is_online() method returns FALSE although
    ///   you are certain that the matching device is plugged, make sure that you did
    ///   call registerHub() at application initialization time.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="func">
    ///   a string that uniquely characterizes $THEFUNCTION$
    /// </param>
    /// <returns>
    ///   a <c>YWeighScale</c> object allowing you to drive $THEFUNCTION$.
    /// </returns>
    ///-
    class function FindWeighScale(func: string):TYWeighScale;

    ////
    /// <summary>
    ///   Registers the callback function that is invoked on every change of advertised value.
    /// <para>
    ///   The callback is invoked only during the execution of <c>ySleep</c> or <c>yHandleEvents</c>.
    ///   This provides control over the time when the callback is triggered. For good responsiveness, remember to call
    ///   one of these two functions periodically. To unregister a callback, pass a NIL pointer as argument.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="callback">
    ///   the callback function to call, or a NIL pointer. The callback function should take two
    ///   arguments: the function object of which the value has changed, and the character string describing
    ///   the new advertised value.
    /// @noreturn
    /// </param>
    ///-
    function registerValueCallback(callback: TYWeighScaleValueCallback):LongInt; overload;

    function _invokeValueCallback(value: string):LongInt; override;

    ////
    /// <summary>
    ///   Registers the callback function that is invoked on every periodic timed notification.
    /// <para>
    ///   The callback is invoked only during the execution of <c>ySleep</c> or <c>yHandleEvents</c>.
    ///   This provides control over the time when the callback is triggered. For good responsiveness, remember to call
    ///   one of these two functions periodically. To unregister a callback, pass a NIL pointer as argument.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="callback">
    ///   the callback function to call, or a NIL pointer. The callback function should take two
    ///   arguments: the function object of which the value has changed, and an YMeasure object describing
    ///   the new advertised value.
    /// @noreturn
    /// </param>
    ///-
    function registerTimedReportCallback(callback: TYWeighScaleTimedReportCallback):LongInt; overload;

    function _invokeTimedReportCallback(value: TYMeasure):LongInt; override;

    ////
    /// <summary>
    ///   Adapts the load cell signal bias (stored in the corresponding genericSensor)
    ///   so that the current signal corresponds to a zero weight.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function tare():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Configures the load cell span parameters (stored in the corresponding genericSensor)
    ///   so that the current signal corresponds to the specified reference weight.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="currWeight">
    ///   reference weight presently on the load cell.
    /// </param>
    /// <param name="maxWeight">
    ///   maximum weight to be expectect on the load cell.
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function setupSpan(currWeight: double; maxWeight: double):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Records a weight offset thermal compensation table, in order to automatically correct the
    ///   measured weight based on the compensation temperature.
    /// <para>
    ///   The weight correction will be applied by linear interpolation between specified points.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="tempValues">
    ///   array of floating point numbers, corresponding to all
    ///   temperatures for which an offset correction is specified.
    /// </param>
    /// <param name="compValues">
    ///   array of floating point numbers, corresponding to the offset correction
    ///   to apply for each of the temperature included in the first
    ///   argument, index by index.
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_offsetCompensationTable(tempValues: TDoubleArray; compValues: TDoubleArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Retrieves the weight offset thermal compensation table previously configured using the
    ///   <c>set_offsetCompensationTable</c> function.
    /// <para>
    ///   The weight correction is applied by linear interpolation between specified points.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="tempValues">
    ///   array of floating point numbers, that is filled by the function
    ///   with all temperatures for which an offset correction is specified.
    /// </param>
    /// <param name="compValues">
    ///   array of floating point numbers, that is filled by the function
    ///   with the offset correction applied for each of the temperature
    ///   included in the first argument, index by index.
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function loadOffsetCompensationTable(var tempValues: TDoubleArray; var compValues: TDoubleArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Records a weight span thermal compensation table, in order to automatically correct the
    ///   measured weight based on the compensation temperature.
    /// <para>
    ///   The weight correction will be applied by linear interpolation between specified points.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="tempValues">
    ///   array of floating point numbers, corresponding to all
    ///   temperatures for which a span correction is specified.
    /// </param>
    /// <param name="compValues">
    ///   array of floating point numbers, corresponding to the span correction
    ///   (in percents) to apply for each of the temperature included in the first
    ///   argument, index by index.
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_spanCompensationTable(tempValues: TDoubleArray; compValues: TDoubleArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Retrieves the weight span thermal compensation table previously configured using the
    ///   <c>set_spanCompensationTable</c> function.
    /// <para>
    ///   The weight correction is applied by linear interpolation between specified points.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="tempValues">
    ///   array of floating point numbers, that is filled by the function
    ///   with all temperatures for which an span correction is specified.
    /// </param>
    /// <param name="compValues">
    ///   array of floating point numbers, that is filled by the function
    ///   with the span correction applied for each of the temperature
    ///   included in the first argument, index by index.
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function loadSpanCompensationTable(var tempValues: TDoubleArray; var compValues: TDoubleArray):LongInt; overload; virtual;


    ////
    /// <summary>
    ///   Continues the enumeration of weighing scale sensors started using <c>yFirstWeighScale()</c>.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a pointer to a <c>YWeighScale</c> object, corresponding to
    ///   a weighing scale sensor currently online, or a <c>NIL</c> pointer
    ///   if there are no more weighing scale sensors to enumerate.
    /// </returns>
    ///-
    function nextWeighScale():TYWeighScale;
    ////
    /// <summary>
    ///   c
    /// <para>
    ///   omment from .yc definition
    /// </para>
    /// </summary>
    ///-
    class function FirstWeighScale():TYWeighScale;
  //--- (end of YWeighScale accessors declaration)
  end;

//--- (WeighScale functions declaration)
  ////
  /// <summary>
  ///   Retrieves a weighing scale sensor for a given identifier.
  /// <para>
  ///   The identifier can be specified using several formats:
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   - FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionLogicalName
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   This function does not require that the weighing scale sensor is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YWeighScale.isOnline()</c> to test if the weighing scale sensor is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   a weighing scale sensor by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// <para>
  ///   If a call to this object's is_online() method returns FALSE although
  ///   you are certain that the matching device is plugged, make sure that you did
  ///   call registerHub() at application initialization time.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes the weighing scale sensor
  /// </param>
  /// <returns>
  ///   a <c>YWeighScale</c> object allowing you to drive the weighing scale sensor.
  /// </returns>
  ///-
  function yFindWeighScale(func:string):TYWeighScale;
  ////
  /// <summary>
  ///   Starts the enumeration of weighing scale sensors currently accessible.
  /// <para>
  ///   Use the method <c>YWeighScale.nextWeighScale()</c> to iterate on
  ///   next weighing scale sensors.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a pointer to a <c>YWeighScale</c> object, corresponding to
  ///   the first weighing scale sensor currently online, or a <c>NIL</c> pointer
  ///   if there are none.
  /// </returns>
  ///-
  function yFirstWeighScale():TYWeighScale;

//--- (end of WeighScale functions declaration)

implementation
//--- (YWeighScale dlldef)
//--- (end of YWeighScale dlldef)

  constructor TYWeighScale.Create(func:string);
    begin
      inherited Create(func);
      _className := 'WeighScale';
      //--- (YWeighScale accessors initialization)
      _excitation := Y_EXCITATION_INVALID;
      _adaptRatio := Y_ADAPTRATIO_INVALID;
      _compTemperature := Y_COMPTEMPERATURE_INVALID;
      _compensation := Y_COMPENSATION_INVALID;
      _zeroTracking := Y_ZEROTRACKING_INVALID;
      _command := Y_COMMAND_INVALID;
      _valueCallbackWeighScale := nil;
      _timedReportCallbackWeighScale := nil;
      //--- (end of YWeighScale accessors initialization)
    end;


//--- (YWeighScale implementation)
{$HINTS OFF}
  function TYWeighScale._parseAttr(member:PJSONRECORD):integer;
    var
      sub : PJSONRECORD;
      i,l        : integer;
    begin
      if (member^.name = 'excitation') then
        begin
          _excitation := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'adaptRatio') then
        begin
          _adaptRatio := round(member^.ivalue * 1000.0 / 65536.0) / 1000.0;
         result := 1;
         exit;
         end;
      if (member^.name = 'compTemperature') then
        begin
          _compTemperature := round(member^.ivalue * 1000.0 / 65536.0) / 1000.0;
         result := 1;
         exit;
         end;
      if (member^.name = 'compensation') then
        begin
          _compensation := round(member^.ivalue * 1000.0 / 65536.0) / 1000.0;
         result := 1;
         exit;
         end;
      if (member^.name = 'zeroTracking') then
        begin
          _zeroTracking := round(member^.ivalue * 1000.0 / 65536.0) / 1000.0;
         result := 1;
         exit;
         end;
      if (member^.name = 'command') then
        begin
          _command := string(member^.svalue);
         result := 1;
         exit;
         end;
      result := inherited _parseAttr(member);
    end;
{$HINTS ON}

  ////
  /// <summary>
  ///   Returns the current load cell bridge excitation method.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a value among Y_EXCITATION_OFF, Y_EXCITATION_DC and Y_EXCITATION_AC corresponding to the current
  ///   load cell bridge excitation method
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_EXCITATION_INVALID.
  /// </para>
  ///-
  function TYWeighScale.get_excitation():Integer;
    var
      res : Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_EXCITATION_INVALID;
              exit;
            end;
        end;
      res := self._excitation;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the current load cell bridge excitation method.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a value among Y_EXCITATION_OFF, Y_EXCITATION_DC and Y_EXCITATION_AC corresponding to the current
  ///   load cell bridge excitation method
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.set_excitation(newval:Integer):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('excitation',rest_val);
    end;

  ////
  /// <summary>
  ///   Changes the compensation temperature update rate, in percents.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a floating point number corresponding to the compensation temperature update rate, in percents
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.set_adaptRatio(newval:double):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(round(newval * 65536.0));
      result := _setAttr('adaptRatio',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the compensation temperature update rate, in percents.
  /// <para>
  ///   the maximal value is 65 percents.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a floating point number corresponding to the compensation temperature update rate, in percents
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_ADAPTRATIO_INVALID.
  /// </para>
  ///-
  function TYWeighScale.get_adaptRatio():double;
    var
      res : double;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_ADAPTRATIO_INVALID;
              exit;
            end;
        end;
      res := self._adaptRatio;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the current compensation temperature.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a floating point number corresponding to the current compensation temperature
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_COMPTEMPERATURE_INVALID.
  /// </para>
  ///-
  function TYWeighScale.get_compTemperature():double;
    var
      res : double;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_COMPTEMPERATURE_INVALID;
              exit;
            end;
        end;
      res := self._compTemperature;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the current current thermal compensation value.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a floating point number corresponding to the current current thermal compensation value
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_COMPENSATION_INVALID.
  /// </para>
  ///-
  function TYWeighScale.get_compensation():double;
    var
      res : double;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_COMPENSATION_INVALID;
              exit;
            end;
        end;
      res := self._compensation;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the compensation temperature update rate, in percents.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a floating point number corresponding to the compensation temperature update rate, in percents
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.set_zeroTracking(newval:double):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(round(newval * 65536.0));
      result := _setAttr('zeroTracking',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the zero tracking threshold value.
  /// <para>
  ///   When this threshold is larger than
  ///   zero, any measure under the threshold will automatically be ignored and the
  ///   zero compensation will be updated.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a floating point number corresponding to the zero tracking threshold value
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_ZEROTRACKING_INVALID.
  /// </para>
  ///-
  function TYWeighScale.get_zeroTracking():double;
    var
      res : double;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_ZEROTRACKING_INVALID;
              exit;
            end;
        end;
      res := self._zeroTracking;
      result := res;
      exit;
    end;


  function TYWeighScale.get_command():string;
    var
      res : string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_COMMAND_INVALID;
              exit;
            end;
        end;
      res := self._command;
      result := res;
      exit;
    end;


  function TYWeighScale.set_command(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('command',rest_val);
    end;

  ////
  /// <summary>
  ///   Retrieves $AFUNCTION$ for a given identifier.
  /// <para>
  ///   The identifier can be specified using several formats:
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   - FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionLogicalName
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   This function does not require that $THEFUNCTION$ is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YWeighScale.isOnline()</c> to test if $THEFUNCTION$ is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   $AFUNCTION$ by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// <para>
  ///   If a call to this object's is_online() method returns FALSE although
  ///   you are certain that the matching device is plugged, make sure that you did
  ///   call registerHub() at application initialization time.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes $THEFUNCTION$
  /// </param>
  /// <returns>
  ///   a <c>YWeighScale</c> object allowing you to drive $THEFUNCTION$.
  /// </returns>
  ///-
  class function TYWeighScale.FindWeighScale(func: string):TYWeighScale;
    var
      obj : TYWeighScale;
    begin
      obj := TYWeighScale(TYFunction._FindFromCache('WeighScale', func));
      if obj = nil then
        begin
          obj :=  TYWeighScale.create(func);
          TYFunction._AddToCache('WeighScale',  func, obj);
        end;
      result := obj;
      exit;
    end;


  ////
  /// <summary>
  ///   Registers the callback function that is invoked on every change of advertised value.
  /// <para>
  ///   The callback is invoked only during the execution of <c>ySleep</c> or <c>yHandleEvents</c>.
  ///   This provides control over the time when the callback is triggered. For good responsiveness, remember to call
  ///   one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="callback">
  ///   the callback function to call, or a null pointer. The callback function should take two
  ///   arguments: the function object of which the value has changed, and the character string describing
  ///   the new advertised value.
  /// @noreturn
  /// </param>
  ///-
  function TYWeighScale.registerValueCallback(callback: TYWeighScaleValueCallback):LongInt;
    var
      val : string;
    begin
      if (addr(callback) <> nil) then
        begin
          TYFunction._UpdateValueCallbackList(self, true);
        end
      else
        begin
          TYFunction._UpdateValueCallbackList(self, false);
        end;
      self._valueCallbackWeighScale := callback;
      // Immediately invoke value callback with current value
      if (addr(callback) <> nil) and self.isOnline then
        begin
          val := self._advertisedValue;
          if not((val = '')) then
            begin
              self._invokeValueCallback(val);
            end;
        end;
      result := 0;
      exit;
    end;


  function TYWeighScale._invokeValueCallback(value: string):LongInt;
    begin
      if (addr(self._valueCallbackWeighScale) <> nil) then
        begin
          self._valueCallbackWeighScale(self, value);
        end
      else
        begin
          inherited _invokeValueCallback(value);
        end;
      result := 0;
      exit;
    end;


  ////
  /// <summary>
  ///   Registers the callback function that is invoked on every periodic timed notification.
  /// <para>
  ///   The callback is invoked only during the execution of <c>ySleep</c> or <c>yHandleEvents</c>.
  ///   This provides control over the time when the callback is triggered. For good responsiveness, remember to call
  ///   one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="callback">
  ///   the callback function to call, or a null pointer. The callback function should take two
  ///   arguments: the function object of which the value has changed, and an YMeasure object describing
  ///   the new advertised value.
  /// @noreturn
  /// </param>
  ///-
  function TYWeighScale.registerTimedReportCallback(callback: TYWeighScaleTimedReportCallback):LongInt;
    var
      sensor : TYSensor;
    begin
      sensor := self;
      if (addr(callback) <> nil) then
        begin
          TYFunction._UpdateTimedReportCallbackList(sensor, true);
        end
      else
        begin
          TYFunction._UpdateTimedReportCallbackList(sensor, false);
        end;
      self._timedReportCallbackWeighScale := callback;
      result := 0;
      exit;
    end;


  function TYWeighScale._invokeTimedReportCallback(value: TYMeasure):LongInt;
    begin
      if (addr(self._timedReportCallbackWeighScale) <> nil) then
        begin
          self._timedReportCallbackWeighScale(self, value);
        end
      else
        begin
          inherited _invokeTimedReportCallback(value);
        end;
      result := 0;
      exit;
    end;


  ////
  /// <summary>
  ///   Adapts the load cell signal bias (stored in the corresponding genericSensor)
  ///   so that the current signal corresponds to a zero weight.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.tare():LongInt;
    begin
      result := self.set_command('T');
      exit;
    end;


  ////
  /// <summary>
  ///   Configures the load cell span parameters (stored in the corresponding genericSensor)
  ///   so that the current signal corresponds to the specified reference weight.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="currWeight">
  ///   reference weight presently on the load cell.
  /// </param>
  /// <param name="maxWeight">
  ///   maximum weight to be expectect on the load cell.
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.setupSpan(currWeight: double; maxWeight: double):LongInt;
    begin
      result := self.set_command('S'+inttostr( round(1000*currWeight))+':'+inttostr(round(1000*maxWeight)));
      exit;
    end;


  ////
  /// <summary>
  ///   Records a weight offset thermal compensation table, in order to automatically correct the
  ///   measured weight based on the compensation temperature.
  /// <para>
  ///   The weight correction will be applied by linear interpolation between specified points.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="tempValues">
  ///   array of floating point numbers, corresponding to all
  ///   temperatures for which an offset correction is specified.
  /// </param>
  /// <param name="compValues">
  ///   array of floating point numbers, corresponding to the offset correction
  ///   to apply for each of the temperature included in the first
  ///   argument, index by index.
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.set_offsetCompensationTable(tempValues: TDoubleArray; compValues: TDoubleArray):LongInt;
    var
      siz : LongInt;
      res : LongInt;
      idx : LongInt;
      found : LongInt;
      prev : double;
      curr : double;
      currComp : double;
      idxTemp : double;
    begin
      siz := length(tempValues);
      if not(siz <> 1) then
        begin
          self._throw( YAPI_INVALID_ARGUMENT, 'thermal compensation table must have at least two points');
          result:=YAPI_INVALID_ARGUMENT;
          exit;
        end;
      if not(siz = length(compValues)) then
        begin
          self._throw( YAPI_INVALID_ARGUMENT, 'table sizes mismatch');
          result:=YAPI_INVALID_ARGUMENT;
          exit;
        end;

      res := self.set_command('2Z');
      if not(res=YAPI_SUCCESS) then
        begin
          self._throw( YAPI_IO_ERROR, 'unable to reset thermal compensation table');
          result:=YAPI_IO_ERROR;
          exit;
        end;
      // add records in growing temperature value
      found := 1;
      prev := -999999.0;
      while found > 0 do
        begin
          found := 0;
          curr := 99999999.0;
          currComp := -999999.0;
          idx := 0;
          while idx < siz do
            begin
              idxTemp := tempValues[idx];
              if (idxTemp > prev) and(idxTemp < curr) then
                begin
                  curr := idxTemp;
                  currComp := compValues[idx];
                  found := 1;
                end;
              idx := idx + 1;
            end;
          if found > 0 then
            begin
              res := self.set_command('2m'+inttostr( round(1000*curr))+':'+inttostr(round(1000*currComp)));
              if not(res=YAPI_SUCCESS) then
                begin
                  self._throw( YAPI_IO_ERROR, 'unable to set thermal compensation table');
                  result:=YAPI_IO_ERROR;
                  exit;
                end;
              prev := curr;
            end;
        end;
      result := YAPI_SUCCESS;
      exit;
    end;


  ////
  /// <summary>
  ///   Retrieves the weight offset thermal compensation table previously configured using the
  ///   <c>set_offsetCompensationTable</c> function.
  /// <para>
  ///   The weight correction is applied by linear interpolation between specified points.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="tempValues">
  ///   array of floating point numbers, that is filled by the function
  ///   with all temperatures for which an offset correction is specified.
  /// </param>
  /// <param name="compValues">
  ///   array of floating point numbers, that is filled by the function
  ///   with the offset correction applied for each of the temperature
  ///   included in the first argument, index by index.
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.loadOffsetCompensationTable(var tempValues: TDoubleArray; var compValues: TDoubleArray):LongInt;
    var
      id : string;
      bin_json : TByteArray;
      paramlist : TStringArray;
      siz : LongInt;
      idx : LongInt;
      temp : double;
      comp : double;
      tempValues_pos : LongInt;
      compValues_pos : LongInt;
    begin
      SetLength(paramlist, 0);

      id := self.get_functionId;
      id := Copy(id,  11 + 1, Length(id) - 11);
      bin_json := self._download('extra.json?page=2');
      paramlist := self._json_get_array(bin_json);
      // convert all values to float and append records
      siz := ((length(paramlist)) shr 1);
      tempValues_pos := 0;
      SetLength(tempValues, siz);;
      compValues_pos := 0;
      SetLength(compValues, siz);;
      idx := 0;
      while idx < siz do
        begin
          temp := StrToFloat(paramlist[2*idx])/1000.0;
          comp := StrToFloat(paramlist[2*idx+1])/1000.0;
          tempValues[tempValues_pos] := temp;
          inc(tempValues_pos);
          compValues[compValues_pos] := comp;
          inc(compValues_pos);
          idx := idx + 1;
        end;
      SetLength(tempValues, tempValues_pos);;
      SetLength(compValues, compValues_pos);;
      result := YAPI_SUCCESS;
      exit;
    end;


  ////
  /// <summary>
  ///   Records a weight span thermal compensation table, in order to automatically correct the
  ///   measured weight based on the compensation temperature.
  /// <para>
  ///   The weight correction will be applied by linear interpolation between specified points.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="tempValues">
  ///   array of floating point numbers, corresponding to all
  ///   temperatures for which a span correction is specified.
  /// </param>
  /// <param name="compValues">
  ///   array of floating point numbers, corresponding to the span correction
  ///   (in percents) to apply for each of the temperature included in the first
  ///   argument, index by index.
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.set_spanCompensationTable(tempValues: TDoubleArray; compValues: TDoubleArray):LongInt;
    var
      siz : LongInt;
      res : LongInt;
      idx : LongInt;
      found : LongInt;
      prev : double;
      curr : double;
      currComp : double;
      idxTemp : double;
    begin
      siz := length(tempValues);
      if not(siz <> 1) then
        begin
          self._throw( YAPI_INVALID_ARGUMENT, 'thermal compensation table must have at least two points');
          result:=YAPI_INVALID_ARGUMENT;
          exit;
        end;
      if not(siz = length(compValues)) then
        begin
          self._throw( YAPI_INVALID_ARGUMENT, 'table sizes mismatch');
          result:=YAPI_INVALID_ARGUMENT;
          exit;
        end;

      res := self.set_command('3Z');
      if not(res=YAPI_SUCCESS) then
        begin
          self._throw( YAPI_IO_ERROR, 'unable to reset thermal compensation table');
          result:=YAPI_IO_ERROR;
          exit;
        end;
      // add records in growing temperature value
      found := 1;
      prev := -999999.0;
      while found > 0 do
        begin
          found := 0;
          curr := 99999999.0;
          currComp := -999999.0;
          idx := 0;
          while idx < siz do
            begin
              idxTemp := tempValues[idx];
              if (idxTemp > prev) and(idxTemp < curr) then
                begin
                  curr := idxTemp;
                  currComp := compValues[idx];
                  found := 1;
                end;
              idx := idx + 1;
            end;
          if found > 0 then
            begin
              res := self.set_command('3m'+inttostr( round(1000*curr))+':'+inttostr(round(1000*currComp)));
              if not(res=YAPI_SUCCESS) then
                begin
                  self._throw( YAPI_IO_ERROR, 'unable to set thermal compensation table');
                  result:=YAPI_IO_ERROR;
                  exit;
                end;
              prev := curr;
            end;
        end;
      result := YAPI_SUCCESS;
      exit;
    end;


  ////
  /// <summary>
  ///   Retrieves the weight span thermal compensation table previously configured using the
  ///   <c>set_spanCompensationTable</c> function.
  /// <para>
  ///   The weight correction is applied by linear interpolation between specified points.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="tempValues">
  ///   array of floating point numbers, that is filled by the function
  ///   with all temperatures for which an span correction is specified.
  /// </param>
  /// <param name="compValues">
  ///   array of floating point numbers, that is filled by the function
  ///   with the span correction applied for each of the temperature
  ///   included in the first argument, index by index.
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWeighScale.loadSpanCompensationTable(var tempValues: TDoubleArray; var compValues: TDoubleArray):LongInt;
    var
      id : string;
      bin_json : TByteArray;
      paramlist : TStringArray;
      siz : LongInt;
      idx : LongInt;
      temp : double;
      comp : double;
      tempValues_pos : LongInt;
      compValues_pos : LongInt;
    begin
      SetLength(paramlist, 0);

      id := self.get_functionId;
      id := Copy(id,  11 + 1, Length(id) - 11);
      bin_json := self._download('extra.json?page=3');
      paramlist := self._json_get_array(bin_json);
      // convert all values to float and append records
      siz := ((length(paramlist)) shr 1);
      tempValues_pos := 0;
      SetLength(tempValues, siz);;
      compValues_pos := 0;
      SetLength(compValues, siz);;
      idx := 0;
      while idx < siz do
        begin
          temp := StrToFloat(paramlist[2*idx])/1000.0;
          comp := StrToFloat(paramlist[2*idx+1])/1000.0;
          tempValues[tempValues_pos] := temp;
          inc(tempValues_pos);
          compValues[compValues_pos] := comp;
          inc(compValues_pos);
          idx := idx + 1;
        end;
      SetLength(tempValues, tempValues_pos);;
      SetLength(compValues, compValues_pos);;
      result := YAPI_SUCCESS;
      exit;
    end;


  function TYWeighScale.nextWeighScale(): TYWeighScale;
    var
      hwid: string;
    begin
      if YISERR(_nextFunction(hwid)) then
        begin
          nextWeighScale := nil;
          exit;
        end;
      if hwid = '' then
        begin
          nextWeighScale := nil;
          exit;
        end;
      nextWeighScale := TYWeighScale.FindWeighScale(hwid);
    end;

  class function TYWeighScale.FirstWeighScale(): TYWeighScale;
    var
      v_fundescr      : YFUN_DESCR;
      dev             : YDEV_DESCR;
      neededsize, err : integer;
      serial, funcId, funcName, funcVal, errmsg : string;
    begin
      err := yapiGetFunctionsByClass('WeighScale', 0, PyHandleArray(@v_fundescr), sizeof(YFUN_DESCR), neededsize, errmsg);
      if (YISERR(err) or (neededsize = 0)) then
        begin
          result := nil;
          exit;
        end;
      if (YISERR(yapiGetFunctionInfo(v_fundescr, dev, serial, funcId, funcName, funcVal, errmsg))) then
        begin
          result := nil;
          exit;
        end;
     result := TYWeighScale.FindWeighScale(serial+'.'+funcId);
    end;

//--- (end of YWeighScale implementation)

//--- (WeighScale functions)

  function yFindWeighScale(func:string): TYWeighScale;
    begin
      result := TYWeighScale.FindWeighScale(func);
    end;

  function yFirstWeighScale(): TYWeighScale;
    begin
      result := TYWeighScale.FirstWeighScale();
    end;

  procedure _WeighScaleCleanup();
    begin
    end;

//--- (end of WeighScale functions)

initialization
  //--- (WeighScale initialization)
  //--- (end of WeighScale initialization)

finalization
  //--- (WeighScale cleanup)
  _WeighScaleCleanup();
  //--- (end of WeighScale cleanup)
end.