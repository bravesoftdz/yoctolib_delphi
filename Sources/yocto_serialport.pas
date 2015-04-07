{*********************************************************************
 *
 * $Id: yocto_serialport.pas 19817 2015-03-23 16:49:57Z seb $
 *
 * Implements yFindSerialPort(), the high-level API for SerialPort functions
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


unit yocto_serialport;

interface

uses
  sysutils, classes, windows, yocto_api, yjson;

//--- (YSerialPort definitions)

const Y_SERIALMODE_INVALID            = YAPI_INVALID_STRING;
const Y_PROTOCOL_INVALID              = YAPI_INVALID_STRING;
const Y_VOLTAGELEVEL_OFF = 0;
const Y_VOLTAGELEVEL_TTL3V = 1;
const Y_VOLTAGELEVEL_TTL3VR = 2;
const Y_VOLTAGELEVEL_TTL5V = 3;
const Y_VOLTAGELEVEL_TTL5VR = 4;
const Y_VOLTAGELEVEL_RS232 = 5;
const Y_VOLTAGELEVEL_RS485 = 6;
const Y_VOLTAGELEVEL_INVALID = -1;
const Y_RXCOUNT_INVALID               = YAPI_INVALID_UINT;
const Y_TXCOUNT_INVALID               = YAPI_INVALID_UINT;
const Y_ERRCOUNT_INVALID              = YAPI_INVALID_UINT;
const Y_RXMSGCOUNT_INVALID            = YAPI_INVALID_UINT;
const Y_TXMSGCOUNT_INVALID            = YAPI_INVALID_UINT;
const Y_LASTMSG_INVALID               = YAPI_INVALID_STRING;
const Y_CURRENTJOB_INVALID            = YAPI_INVALID_STRING;
const Y_STARTUPJOB_INVALID            = YAPI_INVALID_STRING;
const Y_COMMAND_INVALID               = YAPI_INVALID_STRING;


//--- (end of YSerialPort definitions)

type
  TYSerialPort = class;
  //--- (YSerialPort class start)
  TYSerialPortValueCallback = procedure(func: TYSerialPort; value:string);
  TYSerialPortTimedReportCallback = procedure(func: TYSerialPort; value:TYMeasure);

  ////
  /// <summary>
  ///   TYSerialPort Class: SerialPort function interface
  /// <para>
  ///   The SerialPort function interface allows you to fully drive a Yoctopuce
  ///   serial port, to send and receive data, and to configure communication
  ///   parameters (baud rate, bit count, parity, flow control and protocol).
  ///   Note that Yoctopuce serial ports are not exposed as virtual COM ports.
  ///   They are meant to be used in the same way as all Yoctopuce devices.
  /// </para>
  /// </summary>
  ///-
  TYSerialPort=class(TYFunction)
  //--- (end of YSerialPort class start)
  protected
  //--- (YSerialPort declaration)
    // Attributes (function value cache)
    _logicalName              : string;
    _advertisedValue          : string;
    _serialMode               : string;
    _protocol                 : string;
    _voltageLevel             : Integer;
    _rxCount                  : LongInt;
    _txCount                  : LongInt;
    _errCount                 : LongInt;
    _rxMsgCount               : LongInt;
    _txMsgCount               : LongInt;
    _lastMsg                  : string;
    _currentJob               : string;
    _startupJob               : string;
    _command                  : string;
    _valueCallbackSerialPort  : TYSerialPortValueCallback;
    _rxptr                    : LongInt;
    // Function-specific method for reading JSON output and caching result
    function _parseAttr(member:PJSONRECORD):integer; override;

    //--- (end of YSerialPort declaration)

  public
    //--- (YSerialPort accessors declaration)
    constructor Create(func:string);

    ////
    /// <summary>
    ///   Returns the serial port communication parameters, as a string such as
    ///   "9600,8N1".
    /// <para>
    ///   The string includes the baud rate, the number of data bits,
    ///   the parity, and the number of stop bits. An optional suffix is included
    ///   if flow control is active: "CtsRts" for hardware handshake, "XOnXOff"
    ///   for logical flow control and "Simplex" for acquiring a shared bus using
    ///   the RTS line (as used by some RS485 adapters for instance).
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the serial port communication parameters, as a string such as
    ///   "9600,8N1"
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_SERIALMODE_INVALID</c>.
    /// </para>
    ///-
    function get_serialMode():string;

    ////
    /// <summary>
    ///   Changes the serial port communication parameters, with a string such as
    ///   "9600,8N1".
    /// <para>
    ///   The string includes the baud rate, the number of data bits,
    ///   the parity, and the number of stop bits. An optional suffix can be added
    ///   to enable flow control: "CtsRts" for hardware handshake, "XOnXOff"
    ///   for logical flow control and "Simplex" for acquiring a shared bus using
    ///   the RTS line (as used by some RS485 adapters for instance).
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the serial port communication parameters, with a string such as
    ///   "9600,8N1"
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
    function set_serialMode(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the type of protocol used over the serial line, as a string.
    /// <para>
    ///   Possible values are "Line" for ASCII messages separated by CR and/or LF,
    ///   "Frame:[timeout]ms" for binary messages separated by a delay time,
    ///   "Modbus-ASCII" for MODBUS messages in ASCII mode,
    ///   "Modbus-RTU" for MODBUS messages in RTU mode,
    ///   "Char" for a continuous ASCII stream or
    ///   "Byte" for a continuous binary stream.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the type of protocol used over the serial line, as a string
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_PROTOCOL_INVALID</c>.
    /// </para>
    ///-
    function get_protocol():string;

    ////
    /// <summary>
    ///   Changes the type of protocol used over the serial line.
    /// <para>
    ///   Possible values are "Line" for ASCII messages separated by CR and/or LF,
    ///   "Frame:[timeout]ms" for binary messages separated by a delay time,
    ///   "Modbus-ASCII" for MODBUS messages in ASCII mode,
    ///   "Modbus-RTU" for MODBUS messages in RTU mode,
    ///   "Char" for a continuous ASCII stream or
    ///   "Byte" for a continuous binary stream.
    ///   The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
    ///   is always at lest the specified number of milliseconds between each bytes sent.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the type of protocol used over the serial line
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
    function set_protocol(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the voltage level used on the serial line.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a value among <c>Y_VOLTAGELEVEL_OFF</c>, <c>Y_VOLTAGELEVEL_TTL3V</c>, <c>Y_VOLTAGELEVEL_TTL3VR</c>,
    ///   <c>Y_VOLTAGELEVEL_TTL5V</c>, <c>Y_VOLTAGELEVEL_TTL5VR</c>, <c>Y_VOLTAGELEVEL_RS232</c> and
    ///   <c>Y_VOLTAGELEVEL_RS485</c> corresponding to the voltage level used on the serial line
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_VOLTAGELEVEL_INVALID</c>.
    /// </para>
    ///-
    function get_voltageLevel():Integer;

    ////
    /// <summary>
    ///   Changes the voltage type used on the serial line.
    /// <para>
    ///   Valid
    ///   values  will depend on the Yoctopuce device model featuring
    ///   the serial port feature.  Check your device documentation
    ///   to find out which values are valid for that specific model.
    ///   Trying to set an invalid value will have no effect.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a value among <c>Y_VOLTAGELEVEL_OFF</c>, <c>Y_VOLTAGELEVEL_TTL3V</c>, <c>Y_VOLTAGELEVEL_TTL3VR</c>,
    ///   <c>Y_VOLTAGELEVEL_TTL5V</c>, <c>Y_VOLTAGELEVEL_TTL5VR</c>, <c>Y_VOLTAGELEVEL_RS232</c> and
    ///   <c>Y_VOLTAGELEVEL_RS485</c> corresponding to the voltage type used on the serial line
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
    function set_voltageLevel(newval:Integer):integer;

    ////
    /// <summary>
    ///   Returns the total number of bytes received since last reset.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the total number of bytes received since last reset
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_RXCOUNT_INVALID</c>.
    /// </para>
    ///-
    function get_rxCount():LongInt;

    ////
    /// <summary>
    ///   Returns the total number of bytes transmitted since last reset.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the total number of bytes transmitted since last reset
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_TXCOUNT_INVALID</c>.
    /// </para>
    ///-
    function get_txCount():LongInt;

    ////
    /// <summary>
    ///   Returns the total number of communication errors detected since last reset.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the total number of communication errors detected since last reset
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_ERRCOUNT_INVALID</c>.
    /// </para>
    ///-
    function get_errCount():LongInt;

    ////
    /// <summary>
    ///   Returns the total number of messages received since last reset.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the total number of messages received since last reset
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_RXMSGCOUNT_INVALID</c>.
    /// </para>
    ///-
    function get_rxMsgCount():LongInt;

    ////
    /// <summary>
    ///   Returns the total number of messages send since last reset.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the total number of messages send since last reset
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_TXMSGCOUNT_INVALID</c>.
    /// </para>
    ///-
    function get_txMsgCount():LongInt;

    ////
    /// <summary>
    ///   Returns the latest message fully received (for Line, Frame and Modbus protocols).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the latest message fully received (for Line, Frame and Modbus protocols)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_LASTMSG_INVALID</c>.
    /// </para>
    ///-
    function get_lastMsg():string;

    ////
    /// <summary>
    ///   Returns the name of the job file currently in use.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the name of the job file currently in use
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_CURRENTJOB_INVALID</c>.
    /// </para>
    ///-
    function get_currentJob():string;

    ////
    /// <summary>
    ///   Changes the job to use when the device is powered on.
    /// <para>
    ///   Remember to call the <c>saveToFlash()</c> method of the module if the
    ///   modification must be kept.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the job to use when the device is powered on
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
    function set_currentJob(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the job file to use when the device is powered on.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the job file to use when the device is powered on
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_STARTUPJOB_INVALID</c>.
    /// </para>
    ///-
    function get_startupJob():string;

    ////
    /// <summary>
    ///   Changes the job to use when the device is powered on.
    /// <para>
    ///   Remember to call the <c>saveToFlash()</c> method of the module if the
    ///   modification must be kept.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the job to use when the device is powered on
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
    function set_startupJob(newval:string):integer;

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
    ///   Use the method <c>YSerialPort.isOnline()</c> to test if $THEFUNCTION$ is
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
    ///   a <c>YSerialPort</c> object allowing you to drive $THEFUNCTION$.
    /// </returns>
    ///-
    class function FindSerialPort(func: string):TYSerialPort;

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
    function registerValueCallback(callback: TYSerialPortValueCallback):LongInt; overload;

    function _invokeValueCallback(value: string):LongInt; override;

    function sendCommand(text: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Clears the serial port buffer and resets counters to zero.
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
    function reset():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Manually sets the state of the RTS line.
    /// <para>
    ///   This function has no effect when
    ///   hardware handshake is enabled, as the RTS line is driven automatically.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="val">
    ///   1 to turn RTS on, 0 to turn RTS off
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_RTS(val: LongInt):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Reads the level of the CTS line.
    /// <para>
    ///   The CTS line is usually driven by
    ///   the RTS signal of the connected serial device.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   1 if the CTS line is high, 0 if the CTS line is low.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function get_CTS():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends a single byte to the serial port.
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="code">
    ///   the byte to send
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeByte(code: LongInt):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends an ASCII string to the serial port, as is.
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="text">
    ///   the text string to send
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeStr(text: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends a binary buffer to the serial port, as is.
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="buff">
    ///   the binary buffer to send
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeBin(buff: TByteArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends a byte sequence (provided as a list of bytes) to the serial port.
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="byteList">
    ///   a list of byte codes
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeArray(byteList: TLongIntArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends a byte sequence (provided as a hexadecimal string) to the serial port.
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="hexString">
    ///   a string of hexadecimal byte codes
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeHex(hexString: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends an ASCII string to the serial port, followed by a line break (CR LF).
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="text">
    ///   the text string to send
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeLine(text: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends a MODBUS message (provided as a hexadecimal string) to the serial port.
    /// <para>
    ///   The message must start with the slave address. The MODBUS CRC/LRC is
    ///   automatically added by the function. This function does not wait for a reply.
    /// </para>
    /// </summary>
    /// <param name="hexString">
    ///   a hexadecimal message string, including device address but no CRC/LRC
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function writeMODBUS(hexString: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Reads one byte from the receive buffer, starting at current stream position.
    /// <para>
    ///   If data at current stream position is not available anymore in the receive buffer,
    ///   or if there is no data available yet, the function returns YAPI_NO_MORE_DATA.
    /// </para>
    /// </summary>
    /// <returns>
    ///   the next byte
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function readByte():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Reads data from the receive buffer as a string, starting at current stream position.
    /// <para>
    ///   If data at current stream position is not available anymore in the receive buffer, the
    ///   function performs a short read.
    /// </para>
    /// </summary>
    /// <param name="nChars">
    ///   the maximum number of characters to read
    /// </param>
    /// <returns>
    ///   a string with receive buffer contents
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function readStr(nChars: LongInt):string; overload; virtual;

    ////
    /// <summary>
    ///   Reads data from the receive buffer as a binary buffer, starting at current stream position.
    /// <para>
    ///   If data at current stream position is not available anymore in the receive buffer, the
    ///   function performs a short read.
    /// </para>
    /// </summary>
    /// <param name="nChars">
    ///   the maximum number of bytes to read
    /// </param>
    /// <returns>
    ///   a binary object with receive buffer contents
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function readBin(nChars: LongInt):TByteArray; overload; virtual;

    ////
    /// <summary>
    ///   Reads data from the receive buffer as a list of bytes, starting at current stream position.
    /// <para>
    ///   If data at current stream position is not available anymore in the receive buffer, the
    ///   function performs a short read.
    /// </para>
    /// </summary>
    /// <param name="nChars">
    ///   the maximum number of bytes to read
    /// </param>
    /// <returns>
    ///   a sequence of bytes with receive buffer contents
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function readArray(nChars: LongInt):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Reads data from the receive buffer as a hexadecimal string, starting at current stream position.
    /// <para>
    ///   If data at current stream position is not available anymore in the receive buffer, the
    ///   function performs a short read.
    /// </para>
    /// </summary>
    /// <param name="nBytes">
    ///   the maximum number of bytes to read
    /// </param>
    /// <returns>
    ///   a string with receive buffer contents, encoded in hexadecimal
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function readHex(nBytes: LongInt):string; overload; virtual;

    ////
    /// <summary>
    ///   Reads a single line (or message) from the receive buffer, starting at current stream position.
    /// <para>
    ///   This function is intended to be used when the serial port is configured for a message protocol,
    ///   such as 'Line' mode or MODBUS protocols.
    /// </para>
    /// <para>
    ///   If data at current stream position is not available anymore in the receive buffer,
    ///   the function returns the oldest available line and moves the stream position just after.
    ///   If no new full line is received, the function returns an empty line.
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string with a single line of text
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function readLine():string; overload; virtual;

    ////
    /// <summary>
    ///   Searches for incoming messages in the serial port receive buffer matching a given pattern,
    ///   starting at current position.
    /// <para>
    ///   This function will only compare and return printable characters
    ///   in the message strings. Binary protocols are handled as hexadecimal strings.
    /// </para>
    /// <para>
    ///   The search returns all messages matching the expression provided as argument in the buffer.
    ///   If no matching message is found, the search waits for one up to the specified maximum timeout
    ///   (in milliseconds).
    /// </para>
    /// </summary>
    /// <param name="pattern">
    ///   a limited regular expression describing the expected message format,
    ///   or an empty string if all messages should be returned (no filtering).
    ///   When using binary protocols, the format applies to the hexadecimal
    ///   representation of the message.
    /// </param>
    /// <param name="maxWait">
    ///   the maximum number of milliseconds to wait for a message if none is found
    ///   in the receive buffer.
    /// </param>
    /// <returns>
    ///   an array of strings containing the messages found, if any.
    ///   Binary messages are converted to hexadecimal representation.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function readMessages(pattern: string; maxWait: LongInt):TStringArray; overload; virtual;

    ////
    /// <summary>
    ///   Changes the current internal stream position to the specified value.
    /// <para>
    ///   This function
    ///   does not affect the device, it only changes the value stored in the YSerialPort object
    ///   for the next read operations.
    /// </para>
    /// </summary>
    /// <param name="absPos">
    ///   the absolute position index for next read operations.
    /// </param>
    /// <returns>
    ///   nothing.
    /// </returns>
    ///-
    function read_seek(absPos: LongInt):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Returns the current absolute stream position pointer of the YSerialPort object.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   the absolute position index for next read operations.
    /// </returns>
    ///-
    function read_tell():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Returns the number of bytes available to read in the input buffer starting from the
    ///   current absolute stream position pointer of the YSerialPort object.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   the number of bytes available to read
    /// </returns>
    ///-
    function read_avail():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sends a text line query to the serial port, and reads the reply, if any.
    /// <para>
    ///   This function is intended to be used when the serial port is configured for 'Line' protocol.
    /// </para>
    /// </summary>
    /// <param name="query">
    ///   the line query to send (without CR/LF)
    /// </param>
    /// <param name="maxWait">
    ///   the maximum number of milliseconds to wait for a reply.
    /// </param>
    /// <returns>
    ///   the next text line received after sending the text query, as a string.
    ///   Additional lines can be obtained by calling readLine or readMessages.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function queryLine(query: string; maxWait: LongInt):string; overload; virtual;

    ////
    /// <summary>
    ///   Sends a message to a specified MODBUS slave connected to the serial port, and reads the
    ///   reply, if any.
    /// <para>
    ///   The message is the PDU, provided as a vector of bytes.
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to query
    /// </param>
    /// <param name="pduBytes">
    ///   the message to send (PDU), as a vector of bytes. The first byte of the
    ///   PDU is the MODBUS function code.
    /// </param>
    /// <returns>
    ///   the received reply, as a vector of bytes.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array (or a MODBUS error reply).
    /// </para>
    ///-
    function queryMODBUS(slaveNo: LongInt; pduBytes: TLongIntArray):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Reads one or more contiguous internal bits (or coil status) from a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x01 (Read Coils).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to query
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the first bit/coil to read (zero-based)
    /// </param>
    /// <param name="nBits">
    ///   the number of bits/coils to read
    /// </param>
    /// <returns>
    ///   a vector of integers, each corresponding to one bit.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function modbusReadBits(slaveNo: LongInt; pduAddr: LongInt; nBits: LongInt):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Reads one or more contiguous input bits (or discrete inputs) from a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x02 (Read Discrete Inputs).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to query
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the first bit/input to read (zero-based)
    /// </param>
    /// <param name="nBits">
    ///   the number of bits/inputs to read
    /// </param>
    /// <returns>
    ///   a vector of integers, each corresponding to one bit.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function modbusReadInputBits(slaveNo: LongInt; pduAddr: LongInt; nBits: LongInt):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Reads one or more contiguous internal registers (holding registers) from a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x03 (Read Holding Registers).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to query
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the first holding register to read (zero-based)
    /// </param>
    /// <param name="nWords">
    ///   the number of holding registers to read
    /// </param>
    /// <returns>
    ///   a vector of integers, each corresponding to one 16-bit register value.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function modbusReadRegisters(slaveNo: LongInt; pduAddr: LongInt; nWords: LongInt):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Reads one or more contiguous input registers (read-only registers) from a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x04 (Read Input Registers).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to query
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the first input register to read (zero-based)
    /// </param>
    /// <param name="nWords">
    ///   the number of input registers to read
    /// </param>
    /// <returns>
    ///   a vector of integers, each corresponding to one 16-bit input value.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function modbusReadInputRegisters(slaveNo: LongInt; pduAddr: LongInt; nWords: LongInt):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Sets a single internal bit (or coil) on a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x05 (Write Single Coil).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to drive
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the bit/coil to set (zero-based)
    /// </param>
    /// <param name="value">
    ///   the value to set (0 for OFF state, non-zero for ON state)
    /// </param>
    /// <returns>
    ///   the number of bits/coils affected on the device (1)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns zero.
    /// </para>
    ///-
    function modbusWriteBit(slaveNo: LongInt; pduAddr: LongInt; value: LongInt):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sets several contiguous internal bits (or coils) on a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x0f (Write Multiple Coils).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to drive
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the first bit/coil to set (zero-based)
    /// </param>
    /// <param name="bits">
    ///   the vector of bits to be set (one integer per bit)
    /// </param>
    /// <returns>
    ///   the number of bits/coils affected on the device
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns zero.
    /// </para>
    ///-
    function modbusWriteBits(slaveNo: LongInt; pduAddr: LongInt; bits: TLongIntArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sets a single internal register (or holding register) on a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x06 (Write Single Register).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to drive
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the register to set (zero-based)
    /// </param>
    /// <param name="value">
    ///   the 16 bit value to set
    /// </param>
    /// <returns>
    ///   the number of registers affected on the device (1)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns zero.
    /// </para>
    ///-
    function modbusWriteRegister(slaveNo: LongInt; pduAddr: LongInt; value: LongInt):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sets several contiguous internal registers (or holding registers) on a MODBUS serial device.
    /// <para>
    ///   This method uses the MODBUS function code 0x10 (Write Multiple Registers).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to drive
    /// </param>
    /// <param name="pduAddr">
    ///   the relative address of the first internal register to set (zero-based)
    /// </param>
    /// <param name="values">
    ///   the vector of 16 bit values to set
    /// </param>
    /// <returns>
    ///   the number of registers affected on the device
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns zero.
    /// </para>
    ///-
    function modbusWriteRegisters(slaveNo: LongInt; pduAddr: LongInt; values: TLongIntArray):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Sets several contiguous internal registers (holding registers) on a MODBUS serial device,
    ///   then performs a contiguous read of a set of (possibly different) internal registers.
    /// <para>
    ///   This method uses the MODBUS function code 0x17 (Read/Write Multiple Registers).
    /// </para>
    /// </summary>
    /// <param name="slaveNo">
    ///   the address of the slave MODBUS device to drive
    /// </param>
    /// <param name="pduWriteAddr">
    ///   the relative address of the first internal register to set (zero-based)
    /// </param>
    /// <param name="values">
    ///   the vector of 16 bit values to set
    /// </param>
    /// <param name="pduReadAddr">
    ///   the relative address of the first internal register to read (zero-based)
    /// </param>
    /// <param name="nReadWords">
    ///   the number of 16 bit values to read
    /// </param>
    /// <returns>
    ///   a vector of integers, each corresponding to one 16-bit register value read.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns an empty array.
    /// </para>
    ///-
    function modbusWriteAndReadRegisters(slaveNo: LongInt; pduWriteAddr: LongInt; values: TLongIntArray; pduReadAddr: LongInt; nReadWords: LongInt):TLongIntArray; overload; virtual;

    ////
    /// <summary>
    ///   Saves the job definition string (JSON data) into a job file.
    /// <para>
    ///   The job file can be later enabled using <c>selectJob()</c>.
    /// </para>
    /// </summary>
    /// <param name="jobfile">
    ///   name of the job file to save on the device filesystem
    /// </param>
    /// <param name="jsonDef">
    ///   a string containing a JSON definition of the job
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function uploadJob(jobfile: string; jsonDef: string):LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Load and start processing the specified job file.
    /// <para>
    ///   The file must have
    ///   been previously created using the user interface or uploaded on the
    ///   device filesystem using the <c>uploadJob()</c> function.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="jobfile">
    ///   name of the job file (on the device filesystem)
    /// </param>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function selectJob(jobfile: string):LongInt; overload; virtual;


    ////
    /// <summary>
    ///   Continues the enumeration of serial ports started using <c>yFirstSerialPort()</c>.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a pointer to a <c>YSerialPort</c> object, corresponding to
    ///   a serial port currently online, or a <c>null</c> pointer
    ///   if there are no more serial ports to enumerate.
    /// </returns>
    ///-
    function nextSerialPort():TYSerialPort;
    ////
    /// <summary>
    ///   c
    /// <para>
    ///   omment from .yc definition
    /// </para>
    /// </summary>
    ///-
    class function FirstSerialPort():TYSerialPort;
  //--- (end of YSerialPort accessors declaration)
  end;

//--- (SerialPort functions declaration)
  ////
  /// <summary>
  ///   Retrieves a serial port for a given identifier.
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
  ///   This function does not require that the serial port is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YSerialPort.isOnline()</c> to test if the serial port is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   a serial port by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes the serial port
  /// </param>
  /// <returns>
  ///   a <c>YSerialPort</c> object allowing you to drive the serial port.
  /// </returns>
  ///-
  function yFindSerialPort(func:string):TYSerialPort;
  ////
  /// <summary>
  ///   Starts the enumeration of serial ports currently accessible.
  /// <para>
  ///   Use the method <c>YSerialPort.nextSerialPort()</c> to iterate on
  ///   next serial ports.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a pointer to a <c>YSerialPort</c> object, corresponding to
  ///   the first serial port currently online, or a <c>null</c> pointer
  ///   if there are none.
  /// </returns>
  ///-
  function yFirstSerialPort():TYSerialPort;

//--- (end of SerialPort functions declaration)

implementation
//--- (YSerialPort dlldef)
//--- (end of YSerialPort dlldef)

  constructor TYSerialPort.Create(func:string);
    begin
      inherited Create(func);
      _className := 'SerialPort';
      //--- (YSerialPort accessors initialization)
      _serialMode := Y_SERIALMODE_INVALID;
      _protocol := Y_PROTOCOL_INVALID;
      _voltageLevel := Y_VOLTAGELEVEL_INVALID;
      _rxCount := Y_RXCOUNT_INVALID;
      _txCount := Y_TXCOUNT_INVALID;
      _errCount := Y_ERRCOUNT_INVALID;
      _rxMsgCount := Y_RXMSGCOUNT_INVALID;
      _txMsgCount := Y_TXMSGCOUNT_INVALID;
      _lastMsg := Y_LASTMSG_INVALID;
      _currentJob := Y_CURRENTJOB_INVALID;
      _startupJob := Y_STARTUPJOB_INVALID;
      _command := Y_COMMAND_INVALID;
      _valueCallbackSerialPort := nil;
      _rxptr := 0;
      //--- (end of YSerialPort accessors initialization)
    end;


//--- (YSerialPort implementation)
{$HINTS OFF}
  function TYSerialPort._parseAttr(member:PJSONRECORD):integer;
    var
      sub : PJSONRECORD;
      i,l        : integer;
    begin
      if (member^.name = 'serialMode') then
        begin
          _serialMode := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'protocol') then
        begin
          _protocol := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'voltageLevel') then
        begin
          _voltageLevel := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'rxCount') then
        begin
          _rxCount := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'txCount') then
        begin
          _txCount := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'errCount') then
        begin
          _errCount := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'rxMsgCount') then
        begin
          _rxMsgCount := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'txMsgCount') then
        begin
          _txMsgCount := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'lastMsg') then
        begin
          _lastMsg := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'currentJob') then
        begin
          _currentJob := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'startupJob') then
        begin
          _startupJob := string(member^.svalue);
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
  ///   Returns the serial port communication parameters, as a string such as
  ///   "9600,8N1".
  /// <para>
  ///   The string includes the baud rate, the number of data bits,
  ///   the parity, and the number of stop bits. An optional suffix is included
  ///   if flow control is active: "CtsRts" for hardware handshake, "XOnXOff"
  ///   for logical flow control and "Simplex" for acquiring a shared bus using
  ///   the RTS line (as used by some RS485 adapters for instance).
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the serial port communication parameters, as a string such as
  ///   "9600,8N1"
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_SERIALMODE_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_serialMode():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_SERIALMODE_INVALID;
              exit
            end;
        end;
      result := self._serialMode;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the serial port communication parameters, with a string such as
  ///   "9600,8N1".
  /// <para>
  ///   The string includes the baud rate, the number of data bits,
  ///   the parity, and the number of stop bits. An optional suffix can be added
  ///   to enable flow control: "CtsRts" for hardware handshake, "XOnXOff"
  ///   for logical flow control and "Simplex" for acquiring a shared bus using
  ///   the RTS line (as used by some RS485 adapters for instance).
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the serial port communication parameters, with a string such as
  ///   "9600,8N1"
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
  function TYSerialPort.set_serialMode(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('serialMode',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the type of protocol used over the serial line, as a string.
  /// <para>
  ///   Possible values are "Line" for ASCII messages separated by CR and/or LF,
  ///   "Frame:[timeout]ms" for binary messages separated by a delay time,
  ///   "Modbus-ASCII" for MODBUS messages in ASCII mode,
  ///   "Modbus-RTU" for MODBUS messages in RTU mode,
  ///   "Char" for a continuous ASCII stream or
  ///   "Byte" for a continuous binary stream.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the type of protocol used over the serial line, as a string
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_PROTOCOL_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_protocol():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_PROTOCOL_INVALID;
              exit
            end;
        end;
      result := self._protocol;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the type of protocol used over the serial line.
  /// <para>
  ///   Possible values are "Line" for ASCII messages separated by CR and/or LF,
  ///   "Frame:[timeout]ms" for binary messages separated by a delay time,
  ///   "Modbus-ASCII" for MODBUS messages in ASCII mode,
  ///   "Modbus-RTU" for MODBUS messages in RTU mode,
  ///   "Char" for a continuous ASCII stream or
  ///   "Byte" for a continuous binary stream.
  ///   The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
  ///   is always at lest the specified number of milliseconds between each bytes sent.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the type of protocol used over the serial line
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
  function TYSerialPort.set_protocol(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('protocol',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the voltage level used on the serial line.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
  ///   Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232 and Y_VOLTAGELEVEL_RS485
  ///   corresponding to the voltage level used on the serial line
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_VOLTAGELEVEL_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_voltageLevel():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_VOLTAGELEVEL_INVALID;
              exit
            end;
        end;
      result := self._voltageLevel;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the voltage type used on the serial line.
  /// <para>
  ///   Valid
  ///   values  will depend on the Yoctopuce device model featuring
  ///   the serial port feature.  Check your device documentation
  ///   to find out which values are valid for that specific model.
  ///   Trying to set an invalid value will have no effect.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
  ///   Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232 and Y_VOLTAGELEVEL_RS485
  ///   corresponding to the voltage type used on the serial line
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
  function TYSerialPort.set_voltageLevel(newval:Integer):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('voltageLevel',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the total number of bytes received since last reset.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the total number of bytes received since last reset
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_RXCOUNT_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_rxCount():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_RXCOUNT_INVALID;
              exit
            end;
        end;
      result := self._rxCount;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the total number of bytes transmitted since last reset.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the total number of bytes transmitted since last reset
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_TXCOUNT_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_txCount():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_TXCOUNT_INVALID;
              exit
            end;
        end;
      result := self._txCount;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the total number of communication errors detected since last reset.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the total number of communication errors detected since last reset
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_ERRCOUNT_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_errCount():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_ERRCOUNT_INVALID;
              exit
            end;
        end;
      result := self._errCount;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the total number of messages received since last reset.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the total number of messages received since last reset
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_RXMSGCOUNT_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_rxMsgCount():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_RXMSGCOUNT_INVALID;
              exit
            end;
        end;
      result := self._rxMsgCount;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the total number of messages send since last reset.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the total number of messages send since last reset
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_TXMSGCOUNT_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_txMsgCount():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_TXMSGCOUNT_INVALID;
              exit
            end;
        end;
      result := self._txMsgCount;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the latest message fully received (for Line, Frame and Modbus protocols).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the latest message fully received (for Line, Frame and Modbus protocols)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_LASTMSG_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_lastMsg():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_LASTMSG_INVALID;
              exit
            end;
        end;
      result := self._lastMsg;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the name of the job file currently in use.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the name of the job file currently in use
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_CURRENTJOB_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_currentJob():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_CURRENTJOB_INVALID;
              exit
            end;
        end;
      result := self._currentJob;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the job to use when the device is powered on.
  /// <para>
  ///   Remember to call the saveToFlash() method of the module if the
  ///   modification must be kept.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the job to use when the device is powered on
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
  function TYSerialPort.set_currentJob(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('currentJob',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the job file to use when the device is powered on.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the job file to use when the device is powered on
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_STARTUPJOB_INVALID.
  /// </para>
  ///-
  function TYSerialPort.get_startupJob():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_STARTUPJOB_INVALID;
              exit
            end;
        end;
      result := self._startupJob;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the job to use when the device is powered on.
  /// <para>
  ///   Remember to call the saveToFlash() method of the module if the
  ///   modification must be kept.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the job to use when the device is powered on
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
  function TYSerialPort.set_startupJob(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('startupJob',rest_val);
    end;

  function TYSerialPort.get_command():string;
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


  function TYSerialPort.set_command(newval:string):integer;
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
  ///   Use the method <c>YSerialPort.isOnline()</c> to test if $THEFUNCTION$ is
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
  ///   a <c>YSerialPort</c> object allowing you to drive $THEFUNCTION$.
  /// </returns>
  ///-
  class function TYSerialPort.FindSerialPort(func: string):TYSerialPort;
    var
      obj : TYSerialPort;
    begin
      obj := TYSerialPort(TYFunction._FindFromCache('SerialPort', func));
      if obj = nil then
        begin
          obj :=  TYSerialPort.create(func);
          TYFunction._AddToCache('SerialPort',  func, obj)
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
  function TYSerialPort.registerValueCallback(callback: TYSerialPortValueCallback):LongInt;
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
      self._valueCallbackSerialPort := callback;
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


  function TYSerialPort._invokeValueCallback(value: string):LongInt;
    begin
      if (addr(self._valueCallbackSerialPort) <> nil) then
        begin
          self._valueCallbackSerialPort(self, value)
        end
      else
        begin
          inherited _invokeValueCallback(value)
        end;
      result := 0;
      exit;
    end;


  function TYSerialPort.sendCommand(text: string):LongInt;
    begin
      result := self.set_command(text);
      exit;
    end;


  ////
  /// <summary>
  ///   Clears the serial port buffer and resets counters to zero.
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
  function TYSerialPort.reset():LongInt;
    begin
      self._rxptr := 0;
      // may throw an exception
      result := self.sendCommand('Z');
      exit;
    end;


  ////
  /// <summary>
  ///   Manually sets the state of the RTS line.
  /// <para>
  ///   This function has no effect when
  ///   hardware handshake is enabled, as the RTS line is driven automatically.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="val">
  ///   1 to turn RTS on, 0 to turn RTS off
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.set_RTS(val: LongInt):LongInt;
    begin
      result := self.sendCommand('R'+inttostr(val));
      exit;
    end;


  ////
  /// <summary>
  ///   Reads the level of the CTS line.
  /// <para>
  ///   The CTS line is usually driven by
  ///   the RTS signal of the connected serial device.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   1 if the CTS line is high, 0 if the CTS line is low.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.get_CTS():LongInt;
    var
      buff : TByteArray;
      res : LongInt;
    begin
      buff := self._download('cts.txt');
      if not(length(buff) = 1) then
        begin
          self._throw( YAPI_IO_ERROR, 'invalid CTS reply');
          result:=YAPI_IO_ERROR;
          exit;
        end;
      res := buff[0] - 48;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a single byte to the serial port.
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="code">
  ///   the byte to send
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeByte(code: LongInt):LongInt;
    begin
      result := self.sendCommand('$'+inttohex(code,02));
      exit;
    end;


  ////
  /// <summary>
  ///   Sends an ASCII string to the serial port, as is.
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="text">
  ///   the text string to send
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeStr(text: string):LongInt;
    var
      buff : TByteArray;
      bufflen : LongInt;
      idx : LongInt;
      ch : LongInt;
    begin
      buff := _StrToByte(text);
      bufflen := length(buff);
      if bufflen < 100 then
        begin
          ch := $020;
          idx := 0;
          while (idx < bufflen) and(ch <> 0) do
            begin
              ch := buff[idx];
              if (ch >= $020) and(ch < $07f) then
                begin
                  idx := idx + 1
                end
              else
                begin
                  ch := 0
                end;
            end;
          if idx >= bufflen then
            begin
              result := self.sendCommand('+'+text);
              exit
            end;
        end;
      // send string using file upload
      result := self._upload('txdata', buff);
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a binary buffer to the serial port, as is.
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="buff">
  ///   the binary buffer to send
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeBin(buff: TByteArray):LongInt;
    begin
      result := self._upload('txdata', buff);
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a byte sequence (provided as a list of bytes) to the serial port.
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="byteList">
  ///   a list of byte codes
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeArray(byteList: TLongIntArray):LongInt;
    var
      buff : TByteArray;
      bufflen : LongInt;
      idx : LongInt;
      hexb : LongInt;
      res : LongInt;
    begin
      bufflen := length(byteList);
      setlength(buff,bufflen);
      idx := 0;
      while idx < bufflen do
        begin
          hexb := byteList[idx];
          buff[idx] := hexb;
          idx := idx + 1
        end;
      // may throw an exception
      res := self._upload('txdata', buff);
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a byte sequence (provided as a hexadecimal string) to the serial port.
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="hexString">
  ///   a string of hexadecimal byte codes
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeHex(hexString: string):LongInt;
    var
      buff : TByteArray;
      bufflen : LongInt;
      idx : LongInt;
      hexb : LongInt;
      res : LongInt;
    begin
      bufflen := Length(hexString);
      if bufflen < 100 then
        begin
          result := self.sendCommand('$'+hexString);
          exit
        end;
      bufflen := ((bufflen) shr 1);
      setlength(buff,bufflen);
      idx := 0;
      while idx < bufflen do
        begin
          hexb := StrToInt('$0' + Copy(hexString,  2 * idx + 1, 2));
          buff[idx] := hexb;
          idx := idx + 1
        end;
      // may throw an exception
      res := self._upload('txdata', buff);
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sends an ASCII string to the serial port, followed by a line break (CR LF).
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="text">
  ///   the text string to send
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeLine(text: string):LongInt;
    var
      buff : TByteArray;
      bufflen : LongInt;
      idx : LongInt;
      ch : LongInt;
    begin
      buff := _StrToByte(''+text+'\r\n');
      bufflen := length(buff)-2;
      if bufflen < 100 then
        begin
          ch := $020;
          idx := 0;
          while (idx < bufflen) and(ch <> 0) do
            begin
              ch := buff[idx];
              if (ch >= $020) and(ch < $07f) then
                begin
                  idx := idx + 1
                end
              else
                begin
                  ch := 0
                end;
            end;
          if idx >= bufflen then
            begin
              result := self.sendCommand('!'+text);
              exit
            end;
        end;
      // send string using file upload
      result := self._upload('txdata', buff);
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a MODBUS message (provided as a hexadecimal string) to the serial port.
  /// <para>
  ///   The message must start with the slave address. The MODBUS CRC/LRC is
  ///   automatically added by the function. This function does not wait for a reply.
  /// </para>
  /// </summary>
  /// <param name="hexString">
  ///   a hexadecimal message string, including device address but no CRC/LRC
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.writeMODBUS(hexString: string):LongInt;
    begin
      result := self.sendCommand(':'+hexString);
      exit;
    end;


  ////
  /// <summary>
  ///   Reads one byte from the receive buffer, starting at current stream position.
  /// <para>
  ///   If data at current stream position is not available anymore in the receive buffer,
  ///   or if there is no data available yet, the function returns YAPI_NO_MORE_DATA.
  /// </para>
  /// </summary>
  /// <returns>
  ///   the next byte
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.readByte():LongInt;
    var
      buff : TByteArray;
      bufflen : LongInt;
      mult : LongInt;
      endpos : LongInt;
      res : LongInt;
    begin
      buff := self._download('rxdata.bin?pos='+inttostr(self._rxptr)+'&len=1');
      bufflen := length(buff) - 1;
      endpos := 0;
      mult := 1;
      while (bufflen > 0) and(buff[bufflen] <> 64) do
        begin
          endpos := endpos + mult * (buff[bufflen] - 48);
          mult := mult * 10;
          bufflen := bufflen - 1
        end;
      self._rxptr := endpos;
      if bufflen = 0 then
        begin
          result := YAPI_NO_MORE_DATA;
          exit
        end;
      res := buff[0];
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads data from the receive buffer as a string, starting at current stream position.
  /// <para>
  ///   If data at current stream position is not available anymore in the receive buffer, the
  ///   function performs a short read.
  /// </para>
  /// </summary>
  /// <param name="nChars">
  ///   the maximum number of characters to read
  /// </param>
  /// <returns>
  ///   a string with receive buffer contents
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.readStr(nChars: LongInt):string;
    var
      buff : TByteArray;
      bufflen : LongInt;
      mult : LongInt;
      endpos : LongInt;
      res : string;
    begin
      if nChars > 65535 then
        begin
          nChars := 65535
        end;
      // may throw an exception
      buff := self._download('rxdata.bin?pos='+inttostr( self._rxptr)+'&len='+inttostr(nChars));
      bufflen := length(buff) - 1;
      endpos := 0;
      mult := 1;
      while (bufflen > 0) and(buff[bufflen] <> 64) do
        begin
          endpos := endpos + mult * (buff[bufflen] - 48);
          mult := mult * 10;
          bufflen := bufflen - 1
        end;
      self._rxptr := endpos;
      res := Copy(_ByteToString(buff),  0 + 1, bufflen);
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads data from the receive buffer as a binary buffer, starting at current stream position.
  /// <para>
  ///   If data at current stream position is not available anymore in the receive buffer, the
  ///   function performs a short read.
  /// </para>
  /// </summary>
  /// <param name="nChars">
  ///   the maximum number of bytes to read
  /// </param>
  /// <returns>
  ///   a binary object with receive buffer contents
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.readBin(nChars: LongInt):TByteArray;
    var
      buff : TByteArray;
      bufflen : LongInt;
      mult : LongInt;
      endpos : LongInt;
      idx : LongInt;
      res : TByteArray;
    begin
      if nChars > 65535 then
        begin
          nChars := 65535
        end;
      // may throw an exception
      buff := self._download('rxdata.bin?pos='+inttostr( self._rxptr)+'&len='+inttostr(nChars));
      bufflen := length(buff) - 1;
      endpos := 0;
      mult := 1;
      while (bufflen > 0) and(buff[bufflen] <> 64) do
        begin
          endpos := endpos + mult * (buff[bufflen] - 48);
          mult := mult * 10;
          bufflen := bufflen - 1
        end;
      self._rxptr := endpos;
      setlength(res,bufflen);
      idx := 0;
      while idx < bufflen do
        begin
          res[idx] := buff[idx];
          idx := idx + 1
        end;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads data from the receive buffer as a list of bytes, starting at current stream position.
  /// <para>
  ///   If data at current stream position is not available anymore in the receive buffer, the
  ///   function performs a short read.
  /// </para>
  /// </summary>
  /// <param name="nChars">
  ///   the maximum number of bytes to read
  /// </param>
  /// <returns>
  ///   a sequence of bytes with receive buffer contents
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.readArray(nChars: LongInt):TLongIntArray;
    var
      buff : TByteArray;
      bufflen : LongInt;
      mult : LongInt;
      endpos : LongInt;
      idx : LongInt;
      b : LongInt;
      res : TLongIntArray;
      res_pos : LongInt;
    begin
      if nChars > 65535 then
        begin
          nChars := 65535
        end;
      // may throw an exception
      buff := self._download('rxdata.bin?pos='+inttostr( self._rxptr)+'&len='+inttostr(nChars));
      bufflen := length(buff) - 1;
      endpos := 0;
      mult := 1;
      while (bufflen > 0) and(buff[bufflen] <> 64) do
        begin
          endpos := endpos + mult * (buff[bufflen] - 48);
          mult := mult * 10;
          bufflen := bufflen - 1
        end;
      self._rxptr := endpos;
      res_pos := 0;
      SetLength(res, bufflen);;
      idx := 0;
      while idx < bufflen do
        begin
          b := buff[idx];
          res[res_pos] := b;
          inc(res_pos);
          idx := idx + 1
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads data from the receive buffer as a hexadecimal string, starting at current stream position.
  /// <para>
  ///   If data at current stream position is not available anymore in the receive buffer, the
  ///   function performs a short read.
  /// </para>
  /// </summary>
  /// <param name="nBytes">
  ///   the maximum number of bytes to read
  /// </param>
  /// <returns>
  ///   a string with receive buffer contents, encoded in hexadecimal
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.readHex(nBytes: LongInt):string;
    var
      buff : TByteArray;
      bufflen : LongInt;
      mult : LongInt;
      endpos : LongInt;
      ofs : LongInt;
      res : string;
    begin
      if nBytes > 65535 then
        begin
          nBytes := 65535
        end;
      // may throw an exception
      buff := self._download('rxdata.bin?pos='+inttostr( self._rxptr)+'&len='+inttostr(nBytes));
      bufflen := length(buff) - 1;
      endpos := 0;
      mult := 1;
      while (bufflen > 0) and(buff[bufflen] <> 64) do
        begin
          endpos := endpos + mult * (buff[bufflen] - 48);
          mult := mult * 10;
          bufflen := bufflen - 1
        end;
      self._rxptr := endpos;
      res := '';
      ofs := 0;
      while ofs + 3 < bufflen do
        begin
          res := ''+ res+''+inttohex( buff[ofs],02)+''+inttohex( buff[ofs + 1],02)+''+inttohex( buff[ofs + 2],02)+''+inttohex(buff[ofs + 3],02);
          ofs := ofs + 4
        end;
      while ofs < bufflen do
        begin
          res := ''+ res+''+inttohex(buff[ofs],02);
          ofs := ofs + 1
        end;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads a single line (or message) from the receive buffer, starting at current stream position.
  /// <para>
  ///   This function is intended to be used when the serial port is configured for a message protocol,
  ///   such as 'Line' mode or MODBUS protocols.
  /// </para>
  /// <para>
  ///   If data at current stream position is not available anymore in the receive buffer,
  ///   the function returns the oldest available line and moves the stream position just after.
  ///   If no new full line is received, the function returns an empty line.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string with a single line of text
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.readLine():string;
    var
      url : string;
      msgbin : TByteArray;
      msgarr : TStringArray;
      msglen : LongInt;
      res : string;
    begin
      url := 'rxmsg.json?pos='+inttostr(self._rxptr)+'&len=1&maxw=1';
      msgbin := self._download(url);
      msgarr := self._json_get_array(msgbin);
      msglen := length(msgarr);
      if msglen = 0 then
        begin
          result := '';
          exit
        end;
      // last element of array is the new position
      msglen := msglen - 1;
      self._rxptr := StrToInt(msgarr[msglen]);
      if msglen = 0 then
        begin
          result := '';
          exit
        end;
      res := self._json_get_string(_StrToByte(msgarr[0]));
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Searches for incoming messages in the serial port receive buffer matching a given pattern,
  ///   starting at current position.
  /// <para>
  ///   This function will only compare and return printable characters
  ///   in the message strings. Binary protocols are handled as hexadecimal strings.
  /// </para>
  /// <para>
  ///   The search returns all messages matching the expression provided as argument in the buffer.
  ///   If no matching message is found, the search waits for one up to the specified maximum timeout
  ///   (in milliseconds).
  /// </para>
  /// </summary>
  /// <param name="pattern">
  ///   a limited regular expression describing the expected message format,
  ///   or an empty string if all messages should be returned (no filtering).
  ///   When using binary protocols, the format applies to the hexadecimal
  ///   representation of the message.
  /// </param>
  /// <param name="maxWait">
  ///   the maximum number of milliseconds to wait for a message if none is found
  ///   in the receive buffer.
  /// </param>
  /// <returns>
  ///   an array of strings containing the messages found, if any.
  ///   Binary messages are converted to hexadecimal representation.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.readMessages(pattern: string; maxWait: LongInt):TStringArray;
    var
      url : string;
      msgbin : TByteArray;
      msgarr : TStringArray;
      msglen : LongInt;
      res : TStringArray;
      idx : LongInt;
      res_pos : LongInt;
    begin
      url := 'rxmsg.json?pos='+inttostr( self._rxptr)+'&maxw='+inttostr( maxWait)+'&pat='+pattern;
      msgbin := self._download(url);
      msgarr := self._json_get_array(msgbin);
      msglen := length(msgarr);
      if msglen = 0 then
        begin
          result := res;
          exit
        end;
      // last element of array is the new position
      msglen := msglen - 1;
      self._rxptr := StrToInt(msgarr[msglen]);
      idx := 0;
      res_pos := length(res);
      SetLength(res, res_pos+msglen);;
      while idx < msglen do
        begin
          res[res_pos] := self._json_get_string(_StrToByte(msgarr[idx]));
          inc(res_pos);
          idx := idx + 1
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the current internal stream position to the specified value.
  /// <para>
  ///   This function
  ///   does not affect the device, it only changes the value stored in the YSerialPort object
  ///   for the next read operations.
  /// </para>
  /// </summary>
  /// <param name="absPos">
  ///   the absolute position index for next read operations.
  /// </param>
  /// <returns>
  ///   nothing.
  /// </returns>
  ///-
  function TYSerialPort.read_seek(absPos: LongInt):LongInt;
    begin
      self._rxptr := absPos;
      result := YAPI_SUCCESS;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the current absolute stream position pointer of the YSerialPort object.
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   the absolute position index for next read operations.
  /// </returns>
  ///-
  function TYSerialPort.read_tell():LongInt;
    begin
      result := self._rxptr;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the number of bytes available to read in the input buffer starting from the
  ///   current absolute stream position pointer of the YSerialPort object.
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   the number of bytes available to read
  /// </returns>
  ///-
  function TYSerialPort.read_avail():LongInt;
    var
      buff : TByteArray;
      bufflen : LongInt;
      res : LongInt;
    begin
      buff := self._download('rxcnt.bin?pos='+inttostr(self._rxptr));
      bufflen := length(buff) - 1;
      while (bufflen > 0) and(buff[bufflen] <> 64) do
        begin
          bufflen := bufflen - 1
        end;
      res := StrToInt(Copy(_ByteToString(buff),  0 + 1, bufflen));
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a text line query to the serial port, and reads the reply, if any.
  /// <para>
  ///   This function is intended to be used when the serial port is configured for 'Line' protocol.
  /// </para>
  /// </summary>
  /// <param name="query">
  ///   the line query to send (without CR/LF)
  /// </param>
  /// <param name="maxWait">
  ///   the maximum number of milliseconds to wait for a reply.
  /// </param>
  /// <returns>
  ///   the next text line received after sending the text query, as a string.
  ///   Additional lines can be obtained by calling readLine or readMessages.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.queryLine(query: string; maxWait: LongInt):string;
    var
      url : string;
      msgbin : TByteArray;
      msgarr : TStringArray;
      msglen : LongInt;
      res : string;
    begin
      url := 'rxmsg.json?len=1&maxw='+inttostr( maxWait)+'&cmd=!'+query;
      msgbin := self._download(url);
      msgarr := self._json_get_array(msgbin);
      msglen := length(msgarr);
      if msglen = 0 then
        begin
          result := '';
          exit
        end;
      // last element of array is the new position
      msglen := msglen - 1;
      self._rxptr := StrToInt(msgarr[msglen]);
      if msglen = 0 then
        begin
          result := '';
          exit
        end;
      res := self._json_get_string(_StrToByte(msgarr[0]));
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sends a message to a specified MODBUS slave connected to the serial port, and reads the
  ///   reply, if any.
  /// <para>
  ///   The message is the PDU, provided as a vector of bytes.
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to query
  /// </param>
  /// <param name="pduBytes">
  ///   the message to send (PDU), as a vector of bytes. The first byte of the
  ///   PDU is the MODBUS function code.
  /// </param>
  /// <returns>
  ///   the received reply, as a vector of bytes.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array (or a MODBUS error reply).
  /// </para>
  ///-
  function TYSerialPort.queryMODBUS(slaveNo: LongInt; pduBytes: TLongIntArray):TLongIntArray;
    var
      funCode : LongInt;
      nib : LongInt;
      i : LongInt;
      cmd : string;
      url : string;
      pat : string;
      msgs : TByteArray;
      reps : TStringArray;
      rep : string;
      res : TLongIntArray;
      replen : LongInt;
      hexb : LongInt;
      res_pos : LongInt;
    begin
      funCode := pduBytes[0];
      nib := ((funCode) shr 4);
      pat := ''+inttohex( slaveNo,02)+'['+inttohex( nib,1)+''+inttohex( (nib+8),1)+']'+inttohex(((funCode) and 15),1)+'.*';
      cmd := ''+inttohex( slaveNo,02)+''+inttohex(funCode,02);
      i := 1;
      while i < length(pduBytes) do
        begin
          cmd := ''+ cmd+''+inttohex(((pduBytes[i]) and ($0ff)),02);
          i := i + 1
        end;
      // may throw an exception
      url := 'rxmsg.json?cmd=:'+ cmd+'&pat=:'+pat;
      msgs := self._download(url);
      reps := self._json_get_array(msgs);
      if not(length(reps) > 1) then
        begin
          self._throw( YAPI_IO_ERROR, 'no reply from slave');
          result:=res;
          exit;
        end;
      if length(reps) > 1 then
        begin
          rep := self._json_get_string(_StrToByte(reps[0]));
          replen := ((Length(rep) - 3) shr 1);
          res_pos := length(res);
          SetLength(res, res_pos+replen);
          i := 0;
          while i < replen do
            begin
              hexb := StrToInt('$0' + Copy(rep, 2 * i + 3 + 1, 2));
              res[res_pos] := hexb;
              inc(res_pos);
              i := i + 1
            end;
          SetLength(res, res_pos);
          if res[0] <> funCode then
            begin
              i := res[1];
              if not(i > 1) then
                begin
                  self._throw( YAPI_NOT_SUPPORTED, 'MODBUS error: unsupported function code');
                  result:=res;
                  exit;
                end;
              if not(i > 2) then
                begin
                  self._throw( YAPI_INVALID_ARGUMENT, 'MODBUS error: illegal data address');
                  result:=res;
                  exit;
                end;
              if not(i > 3) then
                begin
                  self._throw( YAPI_INVALID_ARGUMENT, 'MODBUS error: illegal data value');
                  result:=res;
                  exit;
                end;
              if not(i > 4) then
                begin
                  self._throw( YAPI_INVALID_ARGUMENT, 'MODBUS error: failed to execute function');
                  result:=res;
                  exit;
                end;
            end;
        end;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads one or more contiguous internal bits (or coil status) from a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x01 (Read Coils).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to query
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the first bit/coil to read (zero-based)
  /// </param>
  /// <param name="nBits">
  ///   the number of bits/coils to read
  /// </param>
  /// <returns>
  ///   a vector of integers, each corresponding to one bit.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.modbusReadBits(slaveNo: LongInt; pduAddr: LongInt; nBits: LongInt):TLongIntArray;
    var
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : TLongIntArray;
      bitpos : LongInt;
      idx : LongInt;
      val : LongInt;
      mask : LongInt;
      pdu_pos : LongInt;
      res_pos : LongInt;
    begin
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+5);;
      pdu[pdu_pos] := $001;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nBits) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nBits) and ($0ff));
      inc(pdu_pos);
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res_pos := length(res);
      SetLength(res, res_pos+nBits);;
      bitpos := 0;
      idx := 2;
      val := reply[idx];
      mask := 1;
      while bitpos < nBits do
        begin
          if ((val) and (mask)) = 0 then
            begin
              res[res_pos] := 0;
              inc(res_pos)
            end
          else
            begin
              res[res_pos] := 1;
              inc(res_pos)
            end;
          bitpos := bitpos + 1;
          if mask = $080 then
            begin
              idx := idx + 1;
              val := reply[idx];
              mask := 1
            end
          else
            begin
              mask := ((mask) shl 1)
            end;
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads one or more contiguous input bits (or discrete inputs) from a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x02 (Read Discrete Inputs).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to query
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the first bit/input to read (zero-based)
  /// </param>
  /// <param name="nBits">
  ///   the number of bits/inputs to read
  /// </param>
  /// <returns>
  ///   a vector of integers, each corresponding to one bit.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.modbusReadInputBits(slaveNo: LongInt; pduAddr: LongInt; nBits: LongInt):TLongIntArray;
    var
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : TLongIntArray;
      bitpos : LongInt;
      idx : LongInt;
      val : LongInt;
      mask : LongInt;
      pdu_pos : LongInt;
      res_pos : LongInt;
    begin
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+5);;
      pdu[pdu_pos] := $002;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nBits) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nBits) and ($0ff));
      inc(pdu_pos);
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res_pos := length(res);
      SetLength(res, res_pos+nBits);;
      bitpos := 0;
      idx := 2;
      val := reply[idx];
      mask := 1;
      while bitpos < nBits do
        begin
          if ((val) and (mask)) = 0 then
            begin
              res[res_pos] := 0;
              inc(res_pos)
            end
          else
            begin
              res[res_pos] := 1;
              inc(res_pos)
            end;
          bitpos := bitpos + 1;
          if mask = $080 then
            begin
              idx := idx + 1;
              val := reply[idx];
              mask := 1
            end
          else
            begin
              mask := ((mask) shl 1)
            end;
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads one or more contiguous internal registers (holding registers) from a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x03 (Read Holding Registers).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to query
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the first holding register to read (zero-based)
  /// </param>
  /// <param name="nWords">
  ///   the number of holding registers to read
  /// </param>
  /// <returns>
  ///   a vector of integers, each corresponding to one 16-bit register value.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.modbusReadRegisters(slaveNo: LongInt; pduAddr: LongInt; nWords: LongInt):TLongIntArray;
    var
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : TLongIntArray;
      regpos : LongInt;
      idx : LongInt;
      val : LongInt;
      pdu_pos : LongInt;
      res_pos : LongInt;
    begin
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+5);;
      pdu[pdu_pos] := $003;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWords) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWords) and ($0ff));
      inc(pdu_pos);
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res_pos := length(res);
      SetLength(res, res_pos+nWords);;
      regpos := 0;
      idx := 2;
      while regpos < nWords do
        begin
          val := ((reply[idx]) shl 8);
          idx := idx + 1;
          val := val + reply[idx];
          idx := idx + 1;
          res[res_pos] := val;
          inc(res_pos);
          regpos := regpos + 1
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Reads one or more contiguous input registers (read-only registers) from a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x04 (Read Input Registers).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to query
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the first input register to read (zero-based)
  /// </param>
  /// <param name="nWords">
  ///   the number of input registers to read
  /// </param>
  /// <returns>
  ///   a vector of integers, each corresponding to one 16-bit input value.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.modbusReadInputRegisters(slaveNo: LongInt; pduAddr: LongInt; nWords: LongInt):TLongIntArray;
    var
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : TLongIntArray;
      regpos : LongInt;
      idx : LongInt;
      val : LongInt;
      pdu_pos : LongInt;
      res_pos : LongInt;
    begin
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+5);;
      pdu[pdu_pos] := $004;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWords) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWords) and ($0ff));
      inc(pdu_pos);
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res_pos := length(res);
      SetLength(res, res_pos+nWords);;
      regpos := 0;
      idx := 2;
      while regpos < nWords do
        begin
          val := ((reply[idx]) shl 8);
          idx := idx + 1;
          val := val + reply[idx];
          idx := idx + 1;
          res[res_pos] := val;
          inc(res_pos);
          regpos := regpos + 1
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets a single internal bit (or coil) on a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x05 (Write Single Coil).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to drive
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the bit/coil to set (zero-based)
  /// </param>
  /// <param name="value">
  ///   the value to set (0 for OFF state, non-zero for ON state)
  /// </param>
  /// <returns>
  ///   the number of bits/coils affected on the device (1)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns zero.
  /// </para>
  ///-
  function TYSerialPort.modbusWriteBit(slaveNo: LongInt; pduAddr: LongInt; value: LongInt):LongInt;
    var
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : LongInt;
      pdu_pos : LongInt;
    begin
      res := 0;
      if value <> 0 then
        begin
          value := $0ff
        end;
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+5);;
      pdu[pdu_pos] := $005;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := value;
      inc(pdu_pos);
      pdu[pdu_pos] := $000;
      inc(pdu_pos);
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res := 1;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets several contiguous internal bits (or coils) on a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x0f (Write Multiple Coils).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to drive
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the first bit/coil to set (zero-based)
  /// </param>
  /// <param name="bits">
  ///   the vector of bits to be set (one integer per bit)
  /// </param>
  /// <returns>
  ///   the number of bits/coils affected on the device
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns zero.
  /// </para>
  ///-
  function TYSerialPort.modbusWriteBits(slaveNo: LongInt; pduAddr: LongInt; bits: TLongIntArray):LongInt;
    var
      nBits : LongInt;
      nBytes : LongInt;
      bitpos : LongInt;
      val : LongInt;
      mask : LongInt;
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : LongInt;
      pdu_pos : LongInt;
    begin
      res := 0;
      nBits := length(bits);
      nBytes := (((nBits + 7)) shr 3);
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+6 + nBytes);;
      pdu[pdu_pos] := $00f;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nBits) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nBits) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := nBytes;
      inc(pdu_pos);
      bitpos := 0;
      val := 0;
      mask := 1;
      while bitpos < nBits do
        begin
          if bits[bitpos] <> 0 then
            begin
              val := ((val) or (mask))
            end;
          bitpos := bitpos + 1;
          if mask = $080 then
            begin
              pdu[pdu_pos] := val;
              inc(pdu_pos);
              val := 0;
              mask := 1
            end
          else
            begin
              mask := ((mask) shl 1)
            end;
        end;
      if mask <> 1 then
        begin
          pdu[pdu_pos] := val;
          inc(pdu_pos)
        end;
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res := ((reply[3]) shl 8);
      res := res + reply[4];
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets a single internal register (or holding register) on a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x06 (Write Single Register).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to drive
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the register to set (zero-based)
  /// </param>
  /// <param name="value">
  ///   the 16 bit value to set
  /// </param>
  /// <returns>
  ///   the number of registers affected on the device (1)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns zero.
  /// </para>
  ///-
  function TYSerialPort.modbusWriteRegister(slaveNo: LongInt; pduAddr: LongInt; value: LongInt):LongInt;
    var
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : LongInt;
      pdu_pos : LongInt;
    begin
      res := 0;
      if value <> 0 then
        begin
          value := $0ff
        end;
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+5);;
      pdu[pdu_pos] := $006;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((value) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((value) and ($0ff));
      inc(pdu_pos);
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res := 1;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets several contiguous internal registers (or holding registers) on a MODBUS serial device.
  /// <para>
  ///   This method uses the MODBUS function code 0x10 (Write Multiple Registers).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to drive
  /// </param>
  /// <param name="pduAddr">
  ///   the relative address of the first internal register to set (zero-based)
  /// </param>
  /// <param name="values">
  ///   the vector of 16 bit values to set
  /// </param>
  /// <returns>
  ///   the number of registers affected on the device
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns zero.
  /// </para>
  ///-
  function TYSerialPort.modbusWriteRegisters(slaveNo: LongInt; pduAddr: LongInt; values: TLongIntArray):LongInt;
    var
      nWords : LongInt;
      nBytes : LongInt;
      regpos : LongInt;
      val : LongInt;
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : LongInt;
      pdu_pos : LongInt;
    begin
      res := 0;
      nWords := length(values);
      nBytes := 2 * nWords;
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+6 + nBytes);;
      pdu[pdu_pos] := $010;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWords) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWords) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := nBytes;
      inc(pdu_pos);
      regpos := 0;
      while regpos < nWords do
        begin
          val := values[regpos];
          pdu[pdu_pos] := ((val) shr 8);
          inc(pdu_pos);
          pdu[pdu_pos] := ((val) and ($0ff));
          inc(pdu_pos);
          regpos := regpos + 1
        end;
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res := ((reply[3]) shl 8);
      res := res + reply[4];
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets several contiguous internal registers (holding registers) on a MODBUS serial device,
  ///   then performs a contiguous read of a set of (possibly different) internal registers.
  /// <para>
  ///   This method uses the MODBUS function code 0x17 (Read/Write Multiple Registers).
  /// </para>
  /// </summary>
  /// <param name="slaveNo">
  ///   the address of the slave MODBUS device to drive
  /// </param>
  /// <param name="pduWriteAddr">
  ///   the relative address of the first internal register to set (zero-based)
  /// </param>
  /// <param name="values">
  ///   the vector of 16 bit values to set
  /// </param>
  /// <param name="pduReadAddr">
  ///   the relative address of the first internal register to read (zero-based)
  /// </param>
  /// <param name="nReadWords">
  ///   the number of 16 bit values to read
  /// </param>
  /// <returns>
  ///   a vector of integers, each corresponding to one 16-bit register value read.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns an empty array.
  /// </para>
  ///-
  function TYSerialPort.modbusWriteAndReadRegisters(slaveNo: LongInt; pduWriteAddr: LongInt; values: TLongIntArray; pduReadAddr: LongInt; nReadWords: LongInt):TLongIntArray;
    var
      nWriteWords : LongInt;
      nBytes : LongInt;
      regpos : LongInt;
      val : LongInt;
      idx : LongInt;
      pdu : TLongIntArray;
      reply : TLongIntArray;
      res : TLongIntArray;
      pdu_pos : LongInt;
      res_pos : LongInt;
    begin
      nWriteWords := length(values);
      nBytes := 2 * nWriteWords;
      pdu_pos := length(pdu);
      SetLength(pdu, pdu_pos+10 + nBytes);;
      pdu[pdu_pos] := $017;
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduReadAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduReadAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nReadWords) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nReadWords) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduWriteAddr) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((pduWriteAddr) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWriteWords) shr 8);
      inc(pdu_pos);
      pdu[pdu_pos] := ((nWriteWords) and ($0ff));
      inc(pdu_pos);
      pdu[pdu_pos] := nBytes;
      inc(pdu_pos);
      regpos := 0;
      while regpos < nWriteWords do
        begin
          val := values[regpos];
          pdu[pdu_pos] := ((val) shr 8);
          inc(pdu_pos);
          pdu[pdu_pos] := ((val) and ($0ff));
          inc(pdu_pos);
          regpos := regpos + 1
        end;
      SetLength(pdu, pdu_pos);;
      // may throw an exception
      reply := self.queryMODBUS(slaveNo, pdu);
      if length(reply) = 0 then
        begin
          result := res;
          exit
        end;
      if reply[0] <> pdu[0] then
        begin
          result := res;
          exit
        end;
      res_pos := length(res);
      SetLength(res, res_pos+nReadWords);;
      regpos := 0;
      idx := 2;
      while regpos < nReadWords do
        begin
          val := ((reply[idx]) shl 8);
          idx := idx + 1;
          val := val + reply[idx];
          idx := idx + 1;
          res[res_pos] := val;
          inc(res_pos);
          regpos := regpos + 1
        end;
      SetLength(res, res_pos);;
      result := res;
      exit;
    end;


  ////
  /// <summary>
  ///   Saves the job definition string (JSON data) into a job file.
  /// <para>
  ///   The job file can be later enabled using <c>selectJob()</c>.
  /// </para>
  /// </summary>
  /// <param name="jobfile">
  ///   name of the job file to save on the device filesystem
  /// </param>
  /// <param name="jsonDef">
  ///   a string containing a JSON definition of the job
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.uploadJob(jobfile: string; jsonDef: string):LongInt;
    begin
      self._upload(jobfile, _StrToByte(jsonDef));
      result := YAPI_SUCCESS;
      exit;
    end;


  ////
  /// <summary>
  ///   Load and start processing the specified job file.
  /// <para>
  ///   The file must have
  ///   been previously created using the user interface or uploaded on the
  ///   device filesystem using the <c>uploadJob()</c> function.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="jobfile">
  ///   name of the job file (on the device filesystem)
  /// </param>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYSerialPort.selectJob(jobfile: string):LongInt;
    begin
      result := self.set_currentJob(jobfile);
      exit;
    end;


  function TYSerialPort.nextSerialPort(): TYSerialPort;
    var
      hwid: string;
    begin
      if YISERR(_nextFunction(hwid)) then
        begin
          nextSerialPort := nil;
          exit;
        end;
      if hwid = '' then
        begin
          nextSerialPort := nil;
          exit;
        end;
      nextSerialPort := TYSerialPort.FindSerialPort(hwid);
    end;

  class function TYSerialPort.FirstSerialPort(): TYSerialPort;
    var
      v_fundescr      : YFUN_DESCR;
      dev             : YDEV_DESCR;
      neededsize, err : integer;
      serial, funcId, funcName, funcVal, errmsg : string;
    begin
      err := yapiGetFunctionsByClass('SerialPort', 0, PyHandleArray(@v_fundescr), sizeof(YFUN_DESCR), neededsize, errmsg);
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
     result := TYSerialPort.FindSerialPort(serial+'.'+funcId);
    end;

//--- (end of YSerialPort implementation)

//--- (SerialPort functions)

  function yFindSerialPort(func:string): TYSerialPort;
    begin
      result := TYSerialPort.FindSerialPort(func);
    end;

  function yFirstSerialPort(): TYSerialPort;
    begin
      result := TYSerialPort.FirstSerialPort();
    end;

  procedure _SerialPortCleanup();
    begin
    end;

//--- (end of SerialPort functions)

initialization
  //--- (SerialPort initialization)
  //--- (end of SerialPort initialization)

finalization
  //--- (SerialPort cleanup)
  _SerialPortCleanup();
  //--- (end of SerialPort cleanup)
end.