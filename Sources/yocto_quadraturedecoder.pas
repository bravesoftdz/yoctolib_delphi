{*********************************************************************
 *
 * $Id: yocto_quadraturedecoder.pas 21782 2015-10-16 07:53:41Z seb $
 *
 * Implements yFindQuadratureDecoder(), the high-level API for QuadratureDecoder functions
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


unit yocto_quadraturedecoder;

interface

uses
  sysutils, classes, windows, yocto_api, yjson;

//--- (YQuadratureDecoder definitions)

const Y_SPEED_INVALID                 = YAPI_INVALID_DOUBLE;
const Y_DECODING_OFF = 0;
const Y_DECODING_ON = 1;
const Y_DECODING_INVALID = -1;


//--- (end of YQuadratureDecoder definitions)

type
  TYQuadratureDecoder = class;
  //--- (YQuadratureDecoder class start)
  TYQuadratureDecoderValueCallback = procedure(func: TYQuadratureDecoder; value:string);
  TYQuadratureDecoderTimedReportCallback = procedure(func: TYQuadratureDecoder; value:TYMeasure);

  ////
  /// <summary>
  ///   TYQuadratureDecoder Class: QuadratureDecoder function interface
  /// <para>
  ///   The class YQuadratureDecoder allows you to decode a two-wire signal produced by a
  ///   quadrature encoder. It inherits from YSensor class the core functions to read measurements,
  ///   register callback functions, access to the autonomous datalogger.
  /// </para>
  /// </summary>
  ///-
  TYQuadratureDecoder=class(TYSensor)
  //--- (end of YQuadratureDecoder class start)
  protected
  //--- (YQuadratureDecoder declaration)
    // Attributes (function value cache)
    _logicalName              : string;
    _advertisedValue          : string;
    _unit                     : string;
    _currentValue             : double;
    _lowestValue              : double;
    _highestValue             : double;
    _currentRawValue          : double;
    _logFrequency             : string;
    _reportFrequency          : string;
    _calibrationParam         : string;
    _resolution               : double;
    _sensorState              : LongInt;
    _speed                    : double;
    _decoding                 : Integer;
    _valueCallbackQuadratureDecoder : TYQuadratureDecoderValueCallback;
    _timedReportCallbackQuadratureDecoder : TYQuadratureDecoderTimedReportCallback;
    // Function-specific method for reading JSON output and caching result
    function _parseAttr(member:PJSONRECORD):integer; override;

    //--- (end of YQuadratureDecoder declaration)

  public
    //--- (YQuadratureDecoder accessors declaration)
    constructor Create(func:string);

    ////
    /// <summary>
    ///   Changes the current expected position of the quadrature decoder.
    /// <para>
    ///   Invoking this function implicitely activates the quadrature decoder.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a floating point number corresponding to the current expected position of the quadrature decoder
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
    function set_currentValue(newval:double):integer;

    ////
    /// <summary>
    ///   Returns the PWM frequency in Hz.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a floating point number corresponding to the PWM frequency in Hz
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_SPEED_INVALID</c>.
    /// </para>
    ///-
    function get_speed():double;

    ////
    /// <summary>
    ///   Returns the current activation state of the quadrature decoder.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   either <c>Y_DECODING_OFF</c> or <c>Y_DECODING_ON</c>, according to the current activation state of
    ///   the quadrature decoder
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_DECODING_INVALID</c>.
    /// </para>
    ///-
    function get_decoding():Integer;

    ////
    /// <summary>
    ///   Changes the activation state of the quadrature decoder.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   either <c>Y_DECODING_OFF</c> or <c>Y_DECODING_ON</c>, according to the activation state of the
    ///   quadrature decoder
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
    function set_decoding(newval:Integer):integer;

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
    ///   Use the method <c>YQuadratureDecoder.isOnline()</c> to test if $THEFUNCTION$ is
    ///   indeed online at a given time. In case of ambiguity when looking for
    ///   $AFUNCTION$ by logical name, no error is notified: the first instance
    ///   found is returned. The search is performed first by hardware name,
    ///   then by logical name.
    /// </para>
    /// </summary>
    /// <param name="func">
    ///   a string that uniquely characterizes $THEFUNCTION$
    /// </param>
    /// <returns>
    ///   a <c>YQuadratureDecoder</c> object allowing you to drive $THEFUNCTION$.
    /// </returns>
    ///-
    class function FindQuadratureDecoder(func: string):TYQuadratureDecoder;

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
    function registerValueCallback(callback: TYQuadratureDecoderValueCallback):LongInt; overload;

    function _invokeValueCallback(value: string):LongInt; override;

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
    function registerTimedReportCallback(callback: TYQuadratureDecoderTimedReportCallback):LongInt; overload;

    function _invokeTimedReportCallback(value: TYMeasure):LongInt; override;


    ////
    /// <summary>
    ///   Continues the enumeration of quadrature decoders started using <c>yFirstQuadratureDecoder()</c>.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a pointer to a <c>YQuadratureDecoder</c> object, corresponding to
    ///   a quadrature decoder currently online, or a <c>null</c> pointer
    ///   if there are no more quadrature decoders to enumerate.
    /// </returns>
    ///-
    function nextQuadratureDecoder():TYQuadratureDecoder;
    ////
    /// <summary>
    ///   c
    /// <para>
    ///   omment from .yc definition
    /// </para>
    /// </summary>
    ///-
    class function FirstQuadratureDecoder():TYQuadratureDecoder;
  //--- (end of YQuadratureDecoder accessors declaration)
  end;

//--- (QuadratureDecoder functions declaration)
  ////
  /// <summary>
  ///   Retrieves a quadrature decoder for a given identifier.
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
  ///   This function does not require that the quadrature decoder is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YQuadratureDecoder.isOnline()</c> to test if the quadrature decoder is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   a quadrature decoder by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes the quadrature decoder
  /// </param>
  /// <returns>
  ///   a <c>YQuadratureDecoder</c> object allowing you to drive the quadrature decoder.
  /// </returns>
  ///-
  function yFindQuadratureDecoder(func:string):TYQuadratureDecoder;
  ////
  /// <summary>
  ///   Starts the enumeration of quadrature decoders currently accessible.
  /// <para>
  ///   Use the method <c>YQuadratureDecoder.nextQuadratureDecoder()</c> to iterate on
  ///   next quadrature decoders.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a pointer to a <c>YQuadratureDecoder</c> object, corresponding to
  ///   the first quadrature decoder currently online, or a <c>null</c> pointer
  ///   if there are none.
  /// </returns>
  ///-
  function yFirstQuadratureDecoder():TYQuadratureDecoder;

//--- (end of QuadratureDecoder functions declaration)

implementation
//--- (YQuadratureDecoder dlldef)
//--- (end of YQuadratureDecoder dlldef)

  constructor TYQuadratureDecoder.Create(func:string);
    begin
      inherited Create(func);
      _className := 'QuadratureDecoder';
      //--- (YQuadratureDecoder accessors initialization)
      _speed := Y_SPEED_INVALID;
      _decoding := Y_DECODING_INVALID;
      _valueCallbackQuadratureDecoder := nil;
      _timedReportCallbackQuadratureDecoder := nil;
      //--- (end of YQuadratureDecoder accessors initialization)
    end;


//--- (YQuadratureDecoder implementation)
{$HINTS OFF}
  function TYQuadratureDecoder._parseAttr(member:PJSONRECORD):integer;
    var
      sub : PJSONRECORD;
      i,l        : integer;
    begin
      if (member^.name = 'speed') then
        begin
          _speed := round(member^.ivalue * 1000.0 / 65536.0) / 1000.0;
         result := 1;
         exit;
         end;
      if (member^.name = 'decoding') then
        begin
          _decoding := member^.ivalue;
         result := 1;
         exit;
         end;
      result := inherited _parseAttr(member);
    end;
{$HINTS ON}

  ////
  /// <summary>
  ///   Changes the current expected position of the quadrature decoder.
  /// <para>
  ///   Invoking this function implicitely activates the quadrature decoder.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a floating point number corresponding to the current expected position of the quadrature decoder
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
  function TYQuadratureDecoder.set_currentValue(newval:double):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(round(newval * 65536.0));
      result := _setAttr('currentValue',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the PWM frequency in Hz.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a floating point number corresponding to the PWM frequency in Hz
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_SPEED_INVALID.
  /// </para>
  ///-
  function TYQuadratureDecoder.get_speed():double;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_SPEED_INVALID;
              exit;
            end;
        end;
      result := self._speed;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the current activation state of the quadrature decoder.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   either Y_DECODING_OFF or Y_DECODING_ON, according to the current activation state of the quadrature decoder
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_DECODING_INVALID.
  /// </para>
  ///-
  function TYQuadratureDecoder.get_decoding():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_DECODING_INVALID;
              exit;
            end;
        end;
      result := self._decoding;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the activation state of the quadrature decoder.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   either Y_DECODING_OFF or Y_DECODING_ON, according to the activation state of the quadrature decoder
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
  function TYQuadratureDecoder.set_decoding(newval:Integer):integer;
    var
      rest_val: string;
    begin
      if(newval>0) then rest_val := '1' else rest_val := '0';
      result := _setAttr('decoding',rest_val);
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
  ///   Use the method <c>YQuadratureDecoder.isOnline()</c> to test if $THEFUNCTION$ is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   $AFUNCTION$ by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes $THEFUNCTION$
  /// </param>
  /// <returns>
  ///   a <c>YQuadratureDecoder</c> object allowing you to drive $THEFUNCTION$.
  /// </returns>
  ///-
  class function TYQuadratureDecoder.FindQuadratureDecoder(func: string):TYQuadratureDecoder;
    var
      obj : TYQuadratureDecoder;
    begin
      obj := TYQuadratureDecoder(TYFunction._FindFromCache('QuadratureDecoder', func));
      if obj = nil then
        begin
          obj :=  TYQuadratureDecoder.create(func);
          TYFunction._AddToCache('QuadratureDecoder',  func, obj);
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
  function TYQuadratureDecoder.registerValueCallback(callback: TYQuadratureDecoderValueCallback):LongInt;
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
      self._valueCallbackQuadratureDecoder := callback;
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


  function TYQuadratureDecoder._invokeValueCallback(value: string):LongInt;
    begin
      if (addr(self._valueCallbackQuadratureDecoder) <> nil) then
        begin
          self._valueCallbackQuadratureDecoder(self, value);
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
  function TYQuadratureDecoder.registerTimedReportCallback(callback: TYQuadratureDecoderTimedReportCallback):LongInt;
    begin
      if (addr(callback) <> nil) then
        begin
          TYFunction._UpdateTimedReportCallbackList(self, true);
        end
      else
        begin
          TYFunction._UpdateTimedReportCallbackList(self, false);
        end;
      self._timedReportCallbackQuadratureDecoder := callback;
      result := 0;
      exit;
    end;


  function TYQuadratureDecoder._invokeTimedReportCallback(value: TYMeasure):LongInt;
    begin
      if (addr(self._timedReportCallbackQuadratureDecoder) <> nil) then
        begin
          self._timedReportCallbackQuadratureDecoder(self, value);
        end
      else
        begin
          inherited _invokeTimedReportCallback(value);
        end;
      result := 0;
      exit;
    end;


  function TYQuadratureDecoder.nextQuadratureDecoder(): TYQuadratureDecoder;
    var
      hwid: string;
    begin
      if YISERR(_nextFunction(hwid)) then
        begin
          nextQuadratureDecoder := nil;
          exit;
        end;
      if hwid = '' then
        begin
          nextQuadratureDecoder := nil;
          exit;
        end;
      nextQuadratureDecoder := TYQuadratureDecoder.FindQuadratureDecoder(hwid);
    end;

  class function TYQuadratureDecoder.FirstQuadratureDecoder(): TYQuadratureDecoder;
    var
      v_fundescr      : YFUN_DESCR;
      dev             : YDEV_DESCR;
      neededsize, err : integer;
      serial, funcId, funcName, funcVal, errmsg : string;
    begin
      err := yapiGetFunctionsByClass('QuadratureDecoder', 0, PyHandleArray(@v_fundescr), sizeof(YFUN_DESCR), neededsize, errmsg);
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
     result := TYQuadratureDecoder.FindQuadratureDecoder(serial+'.'+funcId);
    end;

//--- (end of YQuadratureDecoder implementation)

//--- (QuadratureDecoder functions)

  function yFindQuadratureDecoder(func:string): TYQuadratureDecoder;
    begin
      result := TYQuadratureDecoder.FindQuadratureDecoder(func);
    end;

  function yFirstQuadratureDecoder(): TYQuadratureDecoder;
    begin
      result := TYQuadratureDecoder.FirstQuadratureDecoder();
    end;

  procedure _QuadratureDecoderCleanup();
    begin
    end;

//--- (end of QuadratureDecoder functions)

initialization
  //--- (QuadratureDecoder initialization)
  //--- (end of QuadratureDecoder initialization)

finalization
  //--- (QuadratureDecoder cleanup)
  _QuadratureDecoderCleanup();
  //--- (end of QuadratureDecoder cleanup)
end.