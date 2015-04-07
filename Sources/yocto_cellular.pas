{*********************************************************************
 *
 * $Id: yocto_cellular.pas 19727 2015-03-13 16:22:10Z mvuilleu $
 *
 * Implements yFindCellular(), the high-level API for Cellular functions
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


unit yocto_cellular;

interface

uses
  sysutils, classes, windows, yocto_api, yjson;

//--- (generated code: YCellular definitions)

const Y_LINKQUALITY_INVALID           = YAPI_INVALID_UINT;
const Y_CELLOPERATOR_INVALID          = YAPI_INVALID_STRING;
const Y_MESSAGE_INVALID               = YAPI_INVALID_STRING;
const Y_PIN_INVALID                   = YAPI_INVALID_STRING;
const Y_LOCKEDOPERATOR_INVALID        = YAPI_INVALID_STRING;
const Y_ENABLEDATA_HOMENETWORK = 0;
const Y_ENABLEDATA_ROAMING = 1;
const Y_ENABLEDATA_NEVER = 2;
const Y_ENABLEDATA_INVALID = -1;
const Y_APN_INVALID                   = YAPI_INVALID_STRING;
const Y_APNSECRET_INVALID             = YAPI_INVALID_STRING;
const Y_COMMAND_INVALID               = YAPI_INVALID_STRING;


//--- (end of generated code: YCellular definitions)

//--- (generated code: YCellRecord definitions)


//--- (end of generated code: YCellRecord definitions)


type
  TYCellular = class;
  TYCellRecord = class;
  //--- (generated code: YCellular class start)
  TYCellularValueCallback = procedure(func: TYCellular; value:string);
  TYCellularTimedReportCallback = procedure(func: TYCellular; value:TYMeasure);

  ////
  /// <summary>
  ///   TYCellular Class: Cellular function interface
  /// <para>
  ///   YCellular functions provides control over cellular network parameters
  ///   and status for devices that are GSM-enabled.
  /// </para>
  /// </summary>
  ///-
  TYCellular=class(TYFunction)
  //--- (end of generated code: YCellular class start)
  protected
  //--- (generated code: YCellular declaration)
    // Attributes (function value cache)
    _logicalName              : string;
    _advertisedValue          : string;
    _linkQuality              : LongInt;
    _cellOperator             : string;
    _message                  : string;
    _pin                      : string;
    _lockedOperator           : string;
    _enableData               : Integer;
    _apn                      : string;
    _apnSecret                : string;
    _command                  : string;
    _valueCallbackCellular    : TYCellularValueCallback;
    // Function-specific method for reading JSON output and caching result
    function _parseAttr(member:PJSONRECORD):integer; override;

    //--- (end of generated code: YCellular declaration)

  public
    //--- (generated code: YCellular accessors declaration)
    constructor Create(func:string);

    ////
    /// <summary>
    ///   Returns the link quality, expressed in percent.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the link quality, expressed in percent
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_LINKQUALITY_INVALID</c>.
    /// </para>
    ///-
    function get_linkQuality():LongInt;

    ////
    /// <summary>
    ///   Returns the name of the cell operator currently in use.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the name of the cell operator currently in use
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_CELLOPERATOR_INVALID</c>.
    /// </para>
    ///-
    function get_cellOperator():string;

    ////
    /// <summary>
    ///   Returns the latest status message from the wireless interface.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the latest status message from the wireless interface
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_MESSAGE_INVALID</c>.
    /// </para>
    ///-
    function get_message():string;

    ////
    /// <summary>
    ///   Returns an opaque string if a PIN code has been configured in the device to access
    ///   the SIM card, or an empty string if none has been configured or if the code provided
    ///   was rejected by the SIM card.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to an opaque string if a PIN code has been configured in the device to access
    ///   the SIM card, or an empty string if none has been configured or if the code provided
    ///   was rejected by the SIM card
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_PIN_INVALID</c>.
    /// </para>
    ///-
    function get_pin():string;

    ////
    /// <summary>
    ///   Changes the PIN code used by the module to access the SIM card.
    /// <para>
    ///   This function does not change the code on the SIM card itself, but only changes
    ///   the parameter used by the device to try to get access to it. If the SIM code
    ///   does not work immediately on first try, it will be automatically forgotten
    ///   and the message will be set to "Enter SIM PIN". The method should then be
    ///   invoked again with right correct PIN code. After three failed attempts in a row,
    ///   the message is changed to "Enter SIM PUK" and the SIM card PUK code must be
    ///   provided using method <c>sendPUK</c>.
    /// </para>
    /// <para>
    ///   Remember to call the <c>saveToFlash()</c> method of the module to save the
    ///   new value in the device flash.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the PIN code used by the module to access the SIM card
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
    function set_pin(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the name of the only cell operator to use if automatic choice is disabled,
    ///   or an empty string if the SIM card will automatically choose among available
    ///   cell operators.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the name of the only cell operator to use if automatic choice is disabled,
    ///   or an empty string if the SIM card will automatically choose among available
    ///   cell operators
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_LOCKEDOPERATOR_INVALID</c>.
    /// </para>
    ///-
    function get_lockedOperator():string;

    ////
    /// <summary>
    ///   Changes the name of the cell operator to be used.
    /// <para>
    ///   If the name is an empty
    ///   string, the choice will be made automatically based on the SIM card. Otherwise,
    ///   the selected operator is the only one that will be used.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the name of the cell operator to be used
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
    function set_lockedOperator(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the condition for enabling IP data services (GPRS).
    /// <para>
    ///   When data services are disabled, SMS are the only mean of communication.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a value among <c>Y_ENABLEDATA_HOMENETWORK</c>, <c>Y_ENABLEDATA_ROAMING</c> and
    ///   <c>Y_ENABLEDATA_NEVER</c> corresponding to the condition for enabling IP data services (GPRS)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_ENABLEDATA_INVALID</c>.
    /// </para>
    ///-
    function get_enableData():Integer;

    ////
    /// <summary>
    ///   Changes the condition for enabling IP data services (GPRS).
    /// <para>
    ///   The service can be either fully deactivated, or limited to the SIM home network,
    ///   or enabled for all partner networks (roaming). Caution: enabling data services
    ///   on roaming networks may cause prohibitive communication costs !
    /// </para>
    /// <para>
    ///   When data services are disabled, SMS are the only mean of communication.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a value among <c>Y_ENABLEDATA_HOMENETWORK</c>, <c>Y_ENABLEDATA_ROAMING</c> and
    ///   <c>Y_ENABLEDATA_NEVER</c> corresponding to the condition for enabling IP data services (GPRS)
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
    function set_enableData(newval:Integer):integer;

    ////
    /// <summary>
    ///   Returns the Access Point Name (APN) to be used, if needed.
    /// <para>
    ///   When left blank, the APN suggested by the cell operator will be used.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the Access Point Name (APN) to be used, if needed
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_APN_INVALID</c>.
    /// </para>
    ///-
    function get_apn():string;

    ////
    /// <summary>
    ///   Returns the Access Point Name (APN) to be used, if needed.
    /// <para>
    ///   When left blank, the APN suggested by the cell operator will be used.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string
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
    function set_apn(newval:string):integer;

    ////
    /// <summary>
    ///   Returns an opaque string if APN authentication parameters have been configured
    ///   in the device, or an empty string otherwise.
    /// <para>
    ///   To configure these parameters, use <c>set_apnAuth()</c>.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to an opaque string if APN authentication parameters have been configured
    ///   in the device, or an empty string otherwise
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_APNSECRET_INVALID</c>.
    /// </para>
    ///-
    function get_apnSecret():string;

    function set_apnSecret(newval:string):integer;

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
    ///   Use the method <c>YCellular.isOnline()</c> to test if $THEFUNCTION$ is
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
    ///   a <c>YCellular</c> object allowing you to drive $THEFUNCTION$.
    /// </returns>
    ///-
    class function FindCellular(func: string):TYCellular;

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
    function registerValueCallback(callback: TYCellularValueCallback):LongInt; overload;

    function _invokeValueCallback(value: string):LongInt; override;

    ////
    /// <summary>
    ///   Sends a PUK code to unlock the SIM card after three failed PIN code attempts, and
    ///   setup a new PIN into the SIM card.
    /// <para>
    ///   Only ten consecutives tentatives are permitted:
    ///   after that, the SIM card will be blocked permanently without any mean of recovery
    ///   to use it again. Note that after calling this method, you have usually to invoke
    ///   method <c>set_pin()</c> to tell the YoctoHub which PIN to use in the future.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="puk">
    ///   the SIM PUK code
    /// </param>
    /// <param name="newPin">
    ///   new PIN code to configure into the SIM card
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> when the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function sendPUK(puk: string; newPin: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Configure authentication parameters to connect to the APN.
    /// <para>
    ///   Both
    ///   PAP and CHAP authentication are supported.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="username">
    ///   APN username
    /// </param>
    /// <param name="password">
    ///   APN password
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> when the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_apnAuth(username: string; password: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends an AT command to the GSM module and returns the command output.
    /// <para>
    ///   The command will only execute when the GSM module is in standard
    ///   command state, and should leave it in the exact same state.
    ///   Use this function with great care !
    /// </para>
    /// </summary>
    /// <param name="cmd">
    ///   the AT command to execute, like for instance: "+CCLK?".
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   a string with the result of the commands. Empty lines are
    ///   automatically removed from the output.
    /// </returns>
    ///-
    function _AT(cmd: string):string; overload; virtual;

    ////
    /// <summary>
    ///   Returns a list of nearby cellular antennas, as required for quick
    ///   geolocation of the device.
    /// <para>
    ///   The first cell listed is the serving
    ///   cell, and the next ones are the neighboor cells reported by the
    ///   serving cell.
    /// </para>
    /// </summary>
    /// <returns>
    ///   a list of YCellRecords.
    /// </returns>
    ///-
    function quickCellSurvey():TYCellRecordArray; overload; virtual;


    ////
    /// <summary>
    ///   Continues the enumeration of cellular interfaces started using <c>yFirstCellular()</c>.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a pointer to a <c>YCellular</c> object, corresponding to
    ///   a cellular interface currently online, or a <c>null</c> pointer
    ///   if there are no more cellular interfaces to enumerate.
    /// </returns>
    ///-
    function nextCellular():TYCellular;
    ////
    /// <summary>
    ///   c
    /// <para>
    ///   omment from .yc definition
    /// </para>
    /// </summary>
    ///-
    class function FirstCellular():TYCellular;
  //--- (end of generated code: YCellular accessors declaration)
  end;



  //--- (generated code: YCellRecord class start)
  ////
  /// <summary>
  ///   TYCellRecord Class: Description of a cellular antenna
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  ///-
  TYCellRecord=class(TObject)
  //--- (end of generated code: YCellRecord class start)
  protected
  //--- (generated code: YCellRecord declaration)
    // Attributes (function value cache)
    _oper                     : string;
    _mcc                      : LongInt;
    _mnc                      : LongInt;
    _lac                      : LongInt;
    _cid                      : LongInt;
    _dbm                      : LongInt;
    _tad                      : LongInt;

    //--- (end of generated code: YCellRecord declaration)

  public
    //--- (generated code: YCellRecord accessors declaration)
    function get_cellOperator():string; overload; virtual;

    function get_mobileCountryCode():LongInt; overload; virtual;

    function get_mobileNetworkCode():LongInt; overload; virtual;

    function get_locationAreaCode():LongInt; overload; virtual;

    function get_cellId():LongInt; overload; virtual;

    function get_signalStrength():LongInt; overload; virtual;

    function get_timingAdvance():LongInt; overload; virtual;


  //--- (end of generated code: YCellRecord accessors declaration)
  end;


//--- (generated code: Cellular functions declaration)
  ////
  /// <summary>
  ///   Retrieves a cellular interface for a given identifier.
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
  ///   This function does not require that the cellular interface is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YCellular.isOnline()</c> to test if the cellular interface is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   a cellular interface by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes the cellular interface
  /// </param>
  /// <returns>
  ///   a <c>YCellular</c> object allowing you to drive the cellular interface.
  /// </returns>
  ///-
  function yFindCellular(func:string):TYCellular;
  ////
  /// <summary>
  ///   Starts the enumeration of cellular interfaces currently accessible.
  /// <para>
  ///   Use the method <c>YCellular.nextCellular()</c> to iterate on
  ///   next cellular interfaces.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a pointer to a <c>YCellular</c> object, corresponding to
  ///   the first cellular interface currently online, or a <c>null</c> pointer
  ///   if there are none.
  /// </returns>
  ///-
  function yFirstCellular():TYCellular;

//--- (end of generated code: Cellular functions declaration)
//--- (generated code: CellRecord functions declaration)
//--- (end of generated code: CellRecord functions declaration)

implementation
//--- (generated code: YCellular dlldef)
//--- (end of generated code: YCellular dlldef)
//--- (generated code: YCellRecord dlldef)
//--- (end of generated code: YCellRecord dlldef)

  constructor TYCellular.Create(func:string);
    begin
      inherited Create(func);
      _className := 'Cellular';
      //--- (generated code: YCellular accessors initialization)
      _linkQuality := Y_LINKQUALITY_INVALID;
      _cellOperator := Y_CELLOPERATOR_INVALID;
      _message := Y_MESSAGE_INVALID;
      _pin := Y_PIN_INVALID;
      _lockedOperator := Y_LOCKEDOPERATOR_INVALID;
      _enableData := Y_ENABLEDATA_INVALID;
      _apn := Y_APN_INVALID;
      _apnSecret := Y_APNSECRET_INVALID;
      _command := Y_COMMAND_INVALID;
      _valueCallbackCellular := nil;
      //--- (end of generated code: YCellular accessors initialization)
    end;


//--- (generated code: YCellular implementation)
{$HINTS OFF}
  function TYCellular._parseAttr(member:PJSONRECORD):integer;
    var
      sub : PJSONRECORD;
      i,l        : integer;
    begin
      if (member^.name = 'linkQuality') then
        begin
          _linkQuality := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'cellOperator') then
        begin
          _cellOperator := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'message') then
        begin
          _message := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'pin') then
        begin
          _pin := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'lockedOperator') then
        begin
          _lockedOperator := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'enableData') then
        begin
          _enableData := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'apn') then
        begin
          _apn := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'apnSecret') then
        begin
          _apnSecret := string(member^.svalue);
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
  ///   Returns the link quality, expressed in percent.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the link quality, expressed in percent
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_LINKQUALITY_INVALID.
  /// </para>
  ///-
  function TYCellular.get_linkQuality():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_LINKQUALITY_INVALID;
              exit
            end;
        end;
      result := self._linkQuality;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the name of the cell operator currently in use.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the name of the cell operator currently in use
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_CELLOPERATOR_INVALID.
  /// </para>
  ///-
  function TYCellular.get_cellOperator():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_CELLOPERATOR_INVALID;
              exit
            end;
        end;
      result := self._cellOperator;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the latest status message from the wireless interface.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the latest status message from the wireless interface
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_MESSAGE_INVALID.
  /// </para>
  ///-
  function TYCellular.get_message():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_MESSAGE_INVALID;
              exit
            end;
        end;
      result := self._message;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns an opaque string if a PIN code has been configured in the device to access
  ///   the SIM card, or an empty string if none has been configured or if the code provided
  ///   was rejected by the SIM card.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to an opaque string if a PIN code has been configured in the device to access
  ///   the SIM card, or an empty string if none has been configured or if the code provided
  ///   was rejected by the SIM card
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_PIN_INVALID.
  /// </para>
  ///-
  function TYCellular.get_pin():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_PIN_INVALID;
              exit
            end;
        end;
      result := self._pin;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the PIN code used by the module to access the SIM card.
  /// <para>
  ///   This function does not change the code on the SIM card itself, but only changes
  ///   the parameter used by the device to try to get access to it. If the SIM code
  ///   does not work immediately on first try, it will be automatically forgotten
  ///   and the message will be set to "Enter SIM PIN". The method should then be
  ///   invoked again with right correct PIN code. After three failed attempts in a row,
  ///   the message is changed to "Enter SIM PUK" and the SIM card PUK code must be
  ///   provided using method sendPUK.
  /// </para>
  /// <para>
  ///   Remember to call the saveToFlash() method of the module to save the
  ///   new value in the device flash.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the PIN code used by the module to access the SIM card
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
  function TYCellular.set_pin(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('pin',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the name of the only cell operator to use if automatic choice is disabled,
  ///   or an empty string if the SIM card will automatically choose among available
  ///   cell operators.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the name of the only cell operator to use if automatic choice is disabled,
  ///   or an empty string if the SIM card will automatically choose among available
  ///   cell operators
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_LOCKEDOPERATOR_INVALID.
  /// </para>
  ///-
  function TYCellular.get_lockedOperator():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_LOCKEDOPERATOR_INVALID;
              exit
            end;
        end;
      result := self._lockedOperator;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the name of the cell operator to be used.
  /// <para>
  ///   If the name is an empty
  ///   string, the choice will be made automatically based on the SIM card. Otherwise,
  ///   the selected operator is the only one that will be used.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the name of the cell operator to be used
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
  function TYCellular.set_lockedOperator(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('lockedOperator',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the condition for enabling IP data services (GPRS).
  /// <para>
  ///   When data services are disabled, SMS are the only mean of communication.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a value among Y_ENABLEDATA_HOMENETWORK, Y_ENABLEDATA_ROAMING and Y_ENABLEDATA_NEVER corresponding
  ///   to the condition for enabling IP data services (GPRS)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_ENABLEDATA_INVALID.
  /// </para>
  ///-
  function TYCellular.get_enableData():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_ENABLEDATA_INVALID;
              exit
            end;
        end;
      result := self._enableData;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the condition for enabling IP data services (GPRS).
  /// <para>
  ///   The service can be either fully deactivated, or limited to the SIM home network,
  ///   or enabled for all partner networks (roaming). Caution: enabling data services
  ///   on roaming networks may cause prohibitive communication costs !
  /// </para>
  /// <para>
  ///   When data services are disabled, SMS are the only mean of communication.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a value among Y_ENABLEDATA_HOMENETWORK, Y_ENABLEDATA_ROAMING and Y_ENABLEDATA_NEVER corresponding
  ///   to the condition for enabling IP data services (GPRS)
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
  function TYCellular.set_enableData(newval:Integer):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('enableData',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the Access Point Name (APN) to be used, if needed.
  /// <para>
  ///   When left blank, the APN suggested by the cell operator will be used.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the Access Point Name (APN) to be used, if needed
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_APN_INVALID.
  /// </para>
  ///-
  function TYCellular.get_apn():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_APN_INVALID;
              exit
            end;
        end;
      result := self._apn;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the Access Point Name (APN) to be used, if needed.
  /// <para>
  ///   When left blank, the APN suggested by the cell operator will be used.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string
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
  function TYCellular.set_apn(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('apn',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns an opaque string if APN authentication parameters have been configured
  ///   in the device, or an empty string otherwise.
  /// <para>
  ///   To configure these parameters, use set_apnAuth().
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to an opaque string if APN authentication parameters have been configured
  ///   in the device, or an empty string otherwise
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_APNSECRET_INVALID.
  /// </para>
  ///-
  function TYCellular.get_apnSecret():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_APNSECRET_INVALID;
              exit
            end;
        end;
      result := self._apnSecret;
      exit;
    end;


  function TYCellular.set_apnSecret(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('apnSecret',rest_val);
    end;

  function TYCellular.get_command():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_COMMAND_INVALID;
              exit
            end;
        end;
      result := self._command;
      exit;
    end;


  function TYCellular.set_command(newval:string):integer;
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
  ///   Use the method <c>YCellular.isOnline()</c> to test if $THEFUNCTION$ is
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
  ///   a <c>YCellular</c> object allowing you to drive $THEFUNCTION$.
  /// </returns>
  ///-
  class function TYCellular.FindCellular(func: string):TYCellular;
    var
      obj : TYCellular;
    begin
      obj := TYCellular(TYFunction._FindFromCache('Cellular', func));
      if obj = nil then
        begin
          obj :=  TYCellular.create(func);
          TYFunction._AddToCache('Cellular',  func, obj)
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
  function TYCellular.registerValueCallback(callback: TYCellularValueCallback):LongInt;
    var
      val : string;
    begin
      if (addr(callback) <> nil) then
        begin
          TYFunction._UpdateValueCallbackList(self, true)
        end
      else
        begin
          TYFunction._UpdateValueCallbackList(self, false)
        end;
      self._valueCallbackCellular := callback;
      // Immediately invoke value callback with current value
      if (addr(callback) <> nil) and self.isOnline then
        begin
          val := self._advertisedValue;
          if not((val = '')) then
            begin
              self._invokeValueCallback(val)
            end;
        end;
      result := 0;
      exit;
    end;


  function TYCellular._invokeValueCallback(value: string):LongInt;
    begin
      if (addr(self._valueCallbackCellular) <> nil) then
        begin
          self._valueCallbackCellular(self, value)
        end
      else
        begin
          inherited _invokeValueCallback(value)
        end;
      result := 0;
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a PUK code to unlock the SIM card after three failed PIN code attempts, and
  ///   setup a new PIN into the SIM card.
  /// <para>
  ///   Only ten consecutives tentatives are permitted:
  ///   after that, the SIM card will be blocked permanently without any mean of recovery
  ///   to use it again. Note that after calling this method, you have usually to invoke
  ///   method <c>set_pin()</c> to tell the YoctoHub which PIN to use in the future.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="puk">
  ///   the SIM PUK code
  /// </param>
  /// <param name="newPin">
  ///   new PIN code to configure into the SIM card
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> when the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYCellular.sendPUK(puk: string; newPin: string):LongInt;
    var
      gsmMsg : string;
    begin
      gsmMsg := self.get_message;
      if not((gsmMsg = 'Enter SIM PUK')) then
        begin
          self._throw(YAPI_INVALID_ARGUMENT, 'PUK not expected at this time');
          result:=YAPI_INVALID_ARGUMENT;
          exit;
        end;
      if (newPin = '') then
        begin
          result := self.set_command('AT+CPIN='+puk+',0000;
          +CLCK=SC,0,0000');
          exit
        end;
      result := self.set_command('AT+CPIN='+puk+','+newPin);
      exit;
    end;


  ////
  /// <summary>
  ///   Configure authentication parameters to connect to the APN.
  /// <para>
  ///   Both
  ///   PAP and CHAP authentication are supported.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="username">
  ///   APN username
  /// </param>
  /// <param name="password">
  ///   APN password
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> when the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYCellular.set_apnAuth(username: string; password: string):LongInt;
    begin
      result := self.set_apnSecret(''+username+','+password);
      exit;
    end;


  ////
  /// <summary>
  ///   Sends an AT command to the GSM module and returns the command output.
  /// <para>
  ///   The command will only execute when the GSM module is in standard
  ///   command state, and should leave it in the exact same state.
  ///   Use this function with great care !
  /// </para>
  /// </summary>
  /// <param name="cmd">
  ///   the AT command to execute, like for instance: "+CCLK?".
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   a string with the result of the commands. Empty lines are
  ///   automatically removed from the output.
  /// </returns>
  ///-
  function TYCellular._AT(cmd: string):string;
    var
      chrPos : LongInt;
      cmdLen : LongInt;
      content : TByteArray;
    begin
      cmdLen := Length(cmd);
      chrPos := (pos('#', cmd) - 1);
      while chrPos >= 0 do
        begin
          cmd := ''+ Copy(cmd,  0 + 1, chrPos)+''+chr( 37)+'23'+Copy(cmd,  chrPos+1 + 1, cmdLen-chrPos-1);
          cmdLen := cmdLen + 2;
          chrPos := (pos('#', cmd) - 1)
        end;
      chrPos := (pos('+', cmd) - 1);
      while chrPos >= 0 do
        begin
          cmd := ''+ Copy(cmd,  0 + 1, chrPos)+''+chr( 37)+'2B'+Copy(cmd,  chrPos+1 + 1, cmdLen-chrPos-1);
          cmdLen := cmdLen + 2;
          chrPos := (pos('+', cmd) - 1)
        end;
      chrPos := (pos('=', cmd) - 1);
      while chrPos >= 0 do
        begin
          cmd := ''+ Copy(cmd,  0 + 1, chrPos)+''+chr( 37)+'3D'+Copy(cmd,  chrPos+1 + 1, cmdLen-chrPos-1);
          cmdLen := cmdLen + 2;
          chrPos := (pos('=', cmd) - 1)
        end;
      
      // may throw an exception
      content := self._download('at.txt?cmd='+cmd);
      result := _ByteToString(content);
      exit;
    end;


  ////
  /// <summary>
  ///   Returns a list of nearby cellular antennas, as required for quick
  ///   geolocation of the device.
  /// <para>
  ///   The first cell listed is the serving
  ///   cell, and the next ones are the neighboor cells reported by the
  ///   serving cell.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a list of YCellRecords.
  /// </returns>
  ///-
  function TYCellular.quickCellSurvey():TYCellRecordArray;
    var
      moni : string;
      recs : TStringArray;
      llen : LongInt;
      mccs : string;
      mcc : LongInt;
      mncs : string;
      mnc : LongInt;
      lac : LongInt;
      cellId : LongInt;
      dbms : string;
      dbm : LongInt;
      tads : string;
      tad : LongInt;
      oper : string;
      res : TYCellRecordArray;
      res_pos : LongInt;
      i_i : LongInt;
    begin
      moni := self._AT('+CCED=0;#MONI=7;#MONI');
      mccs := Copy(moni, 7 + 1, 3);
      if (Copy(mccs, 0 + 1, 1) = '0') then
        begin
          mccs := Copy(mccs, 1 + 1, 2)
        end;
      if (Copy(mccs, 0 + 1, 1) = '0') then
        begin
          mccs := Copy(mccs, 1 + 1, 1)
        end;
      mcc := StrToInt(mccs);
      mncs := Copy(moni, 11 + 1, 3);
      if (Copy(mncs, 2 + 1, 1) = ',') then
        begin
          mncs := Copy(mncs, 0 + 1, 2)
        end;
      if (Copy(mncs, 0 + 1, 1) = '0') then
        begin
          mncs := Copy(mncs, 1 + 1, Length(mncs)-1)
        end;
      mnc := StrToInt(mncs);
      recs := _stringSplit(moni, '#');
      // process each line in turn
      res_pos := 0;
      SetLength(res, length(celllist));;
      for i_i:=0 to length(recs)-1 do
        begin
          llen := Length(recs[i_i]) - 2;
          if llen >= 44 then
            begin
              if (Copy(recs[i_i], 41 + 1, 3) = 'dbm') then
                begin
                  lac := StrToInt('$0' + Copy(recs[i_i], 16 + 1, 4));
                  cellId := StrToInt('$0' + Copy(recs[i_i], 23 + 1, 4));
                  dbms := Copy(recs[i_i], 37 + 1, 4);
                  if (Copy(dbms, 0 + 1, 1) = ' ') then
                    begin
                      dbms := Copy(dbms, 1 + 1, 3)
                    end;
                  dbm := StrToInt(dbms);
                  if llen > 66 then
                    begin
                      tads := Copy(recs[i_i], 54 + 1, 2);
                      if (Copy(tads, 0 + 1, 1) = ' ') then
                        begin
                          tads := Copy(tads, 1 + 1, 3)
                        end;
                      tad := StrToInt(tads);
                      oper := Copy(recs[i_i], 66 + 1, llen-66)
                    end
                  else
                    begin
                      tad := -1;
                      oper := ''
                    end;
                  if lac < 65535 then
                    begin
                      res[res_pos] := TYCellRecord.create(mcc, mnc, lac, cellId, dbm, tad, oper);
                      inc(res_pos)
                    end;
                end;
            end;
        end;
      result := res;
      exit;
    end;


  function TYCellular.nextCellular(): TYCellular;
    var
      hwid: string;
    begin
      if YISERR(_nextFunction(hwid)) then
        begin
          nextCellular := nil;
          exit;
        end;
      if hwid = '' then
        begin
          nextCellular := nil;
          exit;
        end;
      nextCellular := TYCellular.FindCellular(hwid);
    end;

  class function TYCellular.FirstCellular(): TYCellular;
    var
      v_fundescr      : YFUN_DESCR;
      dev             : YDEV_DESCR;
      neededsize, err : integer;
      serial, funcId, funcName, funcVal, errmsg : string;
    begin
      err := yapiGetFunctionsByClass('Cellular', 0, PyHandleArray(@v_fundescr), sizeof(YFUN_DESCR), neededsize, errmsg);
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
     result := TYCellular.FindCellular(serial+'.'+funcId);
    end;

//--- (end of generated code: YCellular implementation)

//--- (generated code: Cellular functions)

  function yFindCellular(func:string): TYCellular;
    begin
      result := TYCellular.FindCellular(func);
    end;

  function yFirstCellular(): TYCellular;
    begin
      result := TYCellular.FirstCellular();
    end;

  procedure _CellularCleanup();
    begin
    end;

//--- (end of generated code: Cellular functions)

  constructor TYCellRecord.Create(mcc, mnc, lac, cellId, dbm, tad, cnsot: integer; oper :string);
    begin
      //--- (generated code: YCellRecord accessors initialization)
      _mcc := 0;
      _mnc := 0;
      _lac := 0;
      _cid := 0;
      _dbm := 0;
      _tad := 0;
      //--- (end of generated code: YCellRecord accessors initialization)
      _oper := oper;
      _mcc := mcc;
      _mnc := mnc;
      _lac := lac;
      _cid := cellId;
      _dbm := dbm;
      _tad := tad;
    end;


//--- (generated code: YCellRecord implementation)

  function TYCellRecord.get_cellOperator():string;
    begin
      result := self._oper;
      exit;
    end;


  function TYCellRecord.get_mobileCountryCode():LongInt;
    begin
      result := self._mcc;
      exit;
    end;


  function TYCellRecord.get_mobileNetworkCode():LongInt;
    begin
      result := self._mnc;
      exit;
    end;


  function TYCellRecord.get_locationAreaCode():LongInt;
    begin
      result := self._lac;
      exit;
    end;


  function TYCellRecord.get_cellId():LongInt;
    begin
      result := self._cid;
      exit;
    end;


  function TYCellRecord.get_signalStrength():LongInt;
    begin
      result := self._dbm;
      exit;
    end;


  function TYCellRecord.get_timingAdvance():LongInt;
    begin
      result := self._tad;
      exit;
    end;


//--- (end of generated code: YCellRecord implementation)

//--- (generated code: CellRecord functions)

  procedure _CellRecordCleanup();
    begin
    end;

//--- (end of generated code: CellRecord functions)


initialization
  //--- (generated code: Cellular initialization)
  //--- (end of generated code: Cellular initialization)
  //--- (generated code: CellRecord initialization)
  //--- (end of generated code: CellRecord initialization)

finalization
  //--- (generated code: Cellular cleanup)
  _CellularCleanup();
  //--- (end of generated code: Cellular cleanup)
  //--- (generated code: CellRecord cleanup)
  //--- (end of generated code: CellRecord cleanup)
end.