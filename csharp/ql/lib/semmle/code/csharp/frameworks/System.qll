/** Provides definitions related to the namespace `System`. */

import csharp
private import system.Reflection
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System` namespace. */
class SystemNamespace extends Namespace {
  SystemNamespace() {
    this.getParentNamespace() instanceof GlobalNamespace and
    this.hasUndecoratedName("System")
  }
}

/** A class in the `System` namespace. */
class SystemClass extends Class {
  SystemClass() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic class in the `System` namespace. */
class SystemUnboundGenericClass extends UnboundGenericClass {
  SystemUnboundGenericClass() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic struct in the `System` namespace. */
class SystemUnboundGenericStruct extends UnboundGenericStruct {
  SystemUnboundGenericStruct() { this.getNamespace() instanceof SystemNamespace }
}

/** An interface in the `System` namespace. */
class SystemInterface extends Interface {
  SystemInterface() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic interface in the `System` namespace. */
class SystemUnboundGenericInterface extends UnboundGenericInterface {
  SystemUnboundGenericInterface() { this.getNamespace() instanceof SystemNamespace }
}

/** A delegate type in the `System` namespace. */
class SystemDelegateType extends DelegateType {
  SystemDelegateType() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic delegate type in the `System` namespace. */
class SystemUnboundGenericDelegateType extends UnboundGenericDelegateType {
  SystemUnboundGenericDelegateType() { this.getNamespace() instanceof SystemNamespace }
}

/** The `System.Action` delegate type. */
class SystemActionDelegateType extends SystemDelegateType {
  SystemActionDelegateType() { this.getName() = "Action" }
}

/** The `System.Action<T1, ..., Tn>` delegate type. */
class SystemActionTDelegateType extends SystemUnboundGenericDelegateType {
  SystemActionTDelegateType() { this.getName().regexpMatch("Action<,*>") }
}

/** `System.Array` class. */
class SystemArrayClass extends SystemClass {
  SystemArrayClass() { this.hasName("Array") }

  /** Gets the `Length` property. */
  Property getLengthProperty() { result = this.getProperty("Length") }
}

/** `System.Attribute` class. */
class SystemAttributeClass extends SystemClass {
  SystemAttributeClass() { this.hasName("Attribute") }
}

/** The `System.Boolean` structure. */
class SystemBooleanStruct extends BoolType {
  /** Gets the `Parse(string)` method. */
  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `TryParse(string, out bool)` method. */
  Method getTryParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("TryParse") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(1).getType() instanceof BoolType and
    result.getReturnType() instanceof BoolType
  }
}

/** Data flow for `System.Boolean`. */
private class SystemBooleanFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Boolean;false;Parse;(System.String);;Argument[0];ReturnValue;taint",
        "System;Boolean;false;TryParse;(System.String,System.Boolean);;Argument[0];Argument[1];taint",
        "System;Boolean;false;TryParse;(System.String,System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Boolean;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Boolean);;Element of Argument[0];Argument[1];taint",
        "System;Boolean;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Boolean);;Element of Argument[0];ReturnValue;taint",
      ]
  }
}

/** The `System.Convert` class. */
class SystemConvertClass extends SystemClass {
  SystemConvertClass() { this.hasName("Convert") }
}

/** Data flow for `System.Convert`. */
private class SystemConvertFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Convert;false;ChangeType;(System.Object,System.Type);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ChangeType;(System.Object,System.Type,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ChangeType;(System.Object,System.TypeCode);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ChangeType;(System.Object,System.TypeCode,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;FromBase64CharArray;(System.Char[],System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;taint",
        "System;Convert;false;FromBase64String;(System.String);;Argument[0];Element of ReturnValue;taint",
        "System;Convert;false;FromHexString;(System.ReadOnlySpan<System.Char>);;Element of Argument[0];Element of ReturnValue;taint",
        "System;Convert;false;FromHexString;(System.String);;Argument[0];Element of ReturnValue;taint",
        "System;Convert;false;GetTypeCode;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;IsDBNull;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32,System.Base64FormattingOptions);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32,System.Base64FormattingOptions);;Element of Argument[0];Element of Argument[3];taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32);;Element of Argument[0];Element of Argument[3];taint",
        "System;Convert;false;ToBase64String;(System.Byte[]);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.Byte[],System.Base64FormattingOptions);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.Byte[],System.Int32,System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.Byte[],System.Int32,System.Int32,System.Base64FormattingOptions);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.ReadOnlySpan<System.Byte>,System.Base64FormattingOptions);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToHexString;(System.Byte[]);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToHexString;(System.Byte[],System.Int32,System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToHexString;(System.ReadOnlySpan<System.Byte>);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Boolean,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Byte,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Byte,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Char,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.DateTime,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Decimal,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Double,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int16,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int16,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int32,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int32,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int64,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int64,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.SByte,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Single,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt16,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt32,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt64,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;TryFromBase64Chars;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>,System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;TryFromBase64Chars;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>,System.Int32);;Element of Argument[0];Element of Argument[1];taint",
        "System;Convert;false;TryFromBase64Chars;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>,System.Int32);;Element of Argument[0];Argument[2];taint",
        "System;Convert;false;TryFromBase64String;(System.String,System.Span<System.Byte>,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;TryFromBase64String;(System.String,System.Span<System.Byte>,System.Int32);;Argument[0];Element of Argument[1];taint",
        "System;Convert;false;TryFromBase64String;(System.String,System.Span<System.Byte>,System.Int32);;Argument[0];Argument[2];taint",
        "System;Convert;false;TryToBase64Chars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>,System.Int32,System.Base64FormattingOptions);;Element of Argument[0];ReturnValue;taint",
        "System;Convert;false;TryToBase64Chars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>,System.Int32,System.Base64FormattingOptions);;Element of Argument[0];Element of Argument[1];taint",
        "System;Convert;false;TryToBase64Chars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>,System.Int32,System.Base64FormattingOptions);;Element of Argument[0];Argument[2];taint",
      ]
  }
}

/** `System.Delegate` class. */
class SystemDelegateClass extends SystemClass {
  SystemDelegateClass() { this.hasName("Delegate") }
}

/** The `System.DivideByZeroException` class. */
class SystemDivideByZeroExceptionClass extends SystemClass {
  SystemDivideByZeroExceptionClass() { this.hasName("DivideByZeroException") }
}

/** The `System.Enum` class. */
class SystemEnumClass extends SystemClass {
  SystemEnumClass() { this.hasName("Enum") }
}

/** The `System.Exception` class. */
class SystemExceptionClass extends SystemClass {
  SystemExceptionClass() { this.hasName("Exception") }
}

/** The `System.Func<T1, ..., Tn, TResult>` delegate type. */
class SystemFuncDelegateType extends SystemUnboundGenericDelegateType {
  SystemFuncDelegateType() { this.getName().regexpMatch("Func<,*>") }

  /** Gets one of the `Ti` input type parameters. */
  TypeParameter getAnInputTypeParameter() {
    exists(int i | i in [0 .. this.getNumberOfTypeParameters() - 2] |
      result = this.getTypeParameter(i)
    )
  }

  /** Gets the `TResult` output type parameter. */
  TypeParameter getReturnTypeParameter() {
    result = this.getTypeParameter(this.getNumberOfTypeParameters() - 1)
  }
}

/** The `System.IComparable` interface. */
class SystemIComparableInterface extends SystemInterface {
  SystemIComparableInterface() { this.hasName("IComparable") }

  /** Gets the `CompareTo(object)` method. */
  Method getCompareToMethod() {
    result.getDeclaringType() = this and
    result.hasName("CompareTo") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.IComparable<T>` interface. */
class SystemIComparableTInterface extends SystemUnboundGenericInterface {
  SystemIComparableTInterface() { this.hasName("IComparable<>") }

  /** Gets the `CompareTo(T)` method. */
  Method getCompareToMethod() {
    result.getDeclaringType() = this and
    result.hasName("CompareTo") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = this.getTypeParameter(0) and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.IEquatable<T>` interface. */
class SystemIEquatableTInterface extends SystemUnboundGenericInterface {
  SystemIEquatableTInterface() { this.hasName("IEquatable<>") }

  /** Gets the `Equals(T)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = this.getTypeParameter(0) and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.IFormatProvider` interface. */
class SystemIFormatProviderInterface extends SystemInterface {
  SystemIFormatProviderInterface() { this.hasName("IFormatProvider") }
}

/** The `System.Int32` structure. */
class SystemInt32Struct extends IntType {
  /** Gets the `Parse(string, ...)` method. */
  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse") and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `TryParse(string, ..., out int)` method. */
  Method getTryParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("TryParse") and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(result.getNumberOfParameters() - 1).getType() instanceof IntType and
    result.getReturnType() instanceof BoolType
  }
}

/** Data flow for `System.Int32`. */
private class SystemInt32FlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Int32;false;Parse;(System.String);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.String,System.Globalization.NumberStyles);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.String,System.Globalization.NumberStyles,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.ReadOnlySpan<System.Char>,System.Globalization.NumberStyles,System.IFormatProvider);;Element of Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.String,System.Int32);;Argument[0];Argument[1];taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Int32);;Element of Argument[0];Argument[1];taint",
        "System;Int32;false;TryParse;(System.String,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.String,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Argument[0];Argument[3];taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Element of Argument[0];Argument[3];taint"
      ]
  }
}

/** The `System.InvalidCastException` class. */
class SystemInvalidCastExceptionClass extends SystemClass {
  SystemInvalidCastExceptionClass() { this.hasName("InvalidCastException") }
}

/** The `System.Lazy<T>` class. */
class SystemLazyClass extends SystemUnboundGenericClass {
  SystemLazyClass() {
    this.hasName("Lazy<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = this.getTypeParameter(0)
  }
}

/** Data flow for `System.Lazy<>`. */
private class SystemLazyFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Lazy<>;false;Lazy;(System.Func<T>);;ReturnValue of Argument[0];Property[System.Lazy<>.Value] of ReturnValue;value",
        "System;Lazy<>;false;Lazy;(System.Func<T>,System.Boolean);;ReturnValue of Argument[0];Property[System.Lazy<>.Value] of ReturnValue;value",
        "System;Lazy<>;false;Lazy;(System.Func<T>,System.Threading.LazyThreadSafetyMode);;ReturnValue of Argument[0];Property[System.Lazy<>.Value] of ReturnValue;value",
        "System;Lazy<>;false;get_Value;();;Argument[-1];ReturnValue;taint",
      ]
  }
}

/** The `System.Nullable<T>` struct. */
class SystemNullableStruct extends SystemUnboundGenericStruct {
  SystemNullableStruct() {
    this.hasName("Nullable<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = this.getTypeParameter(0)
  }

  /** Gets the `HasValue` property. */
  Property getHasValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("HasValue") and
    result.getType() instanceof BoolType
  }

  /** Gets a `GetValueOrDefault()` method. */
  Method getAGetValueOrDefaultMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetValueOrDefault") and
    result.getReturnType() = this.getTypeParameter(0)
  }
}

/** Data flow for `System.Nullable<>`. */
private class SystemNullableFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Nullable<>;false;GetValueOrDefault;();;Property[System.Nullable<>.Value] of Argument[-1];ReturnValue;value",
        "System;Nullable<>;false;GetValueOrDefault;(T);;Argument[0];ReturnValue;value",
        "System;Nullable<>;false;GetValueOrDefault;(T);;Property[System.Nullable<>.Value] of Argument[-1];ReturnValue;value",
        "System;Nullable<>;false;Nullable;(T);;Argument[0];Property[System.Nullable<>.Value] of ReturnValue;value",
        "System;Nullable<>;false;get_HasValue;();;Property[System.Nullable<>.Value] of Argument[-1];ReturnValue;taint",
        "System;Nullable<>;false;get_Value;();;Argument[-1];ReturnValue;taint",
      ]
  }
}

/** The `System.NullReferenceException` class. */
class SystemNullReferenceExceptionClass extends SystemClass {
  SystemNullReferenceExceptionClass() { this.hasName("NullReferenceException") }
}

/** The `System.Object` class. */
class SystemObjectClass extends SystemClass {
  SystemObjectClass() { this instanceof ObjectType }

  /** Gets the `Equals(object)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `Equals(object, object)` method. */
  Method getStaticEqualsMethod() {
    result.isStatic() and
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `ReferenceEquals(object, object)` method. */
  Method getReferenceEqualsMethod() {
    result.isStatic() and
    result.getDeclaringType() = this and
    result.hasName("ReferenceEquals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `GetHashCode()` method. */
  Method getGetHashCodeMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetHashCode") and
    result.hasNoParameters() and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `GetType()` method. */
  Method getGetTypeMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetType") and
    result.hasNoParameters() and
    result.getReturnType() instanceof SystemTypeClass
  }

  /** Gets the `ToString()` method. */
  Method getToStringMethod() {
    result.getDeclaringType() = this and
    result.hasName("ToString") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof StringType
  }
}

/** The `System.OutOfMemoryException` class. */
class SystemOutOfMemoryExceptionClass extends SystemClass {
  SystemOutOfMemoryExceptionClass() { this.hasName("OutOfMemoryException") }
}

/** The `System.OverflowException` class. */
class SystemOverflowExceptionClass extends SystemClass {
  SystemOverflowExceptionClass() { this.hasName("OverflowException") }
}

/** The `System.Predicate<T>` delegate type. */
class SystemPredicateDelegateType extends SystemUnboundGenericDelegateType {
  SystemPredicateDelegateType() {
    this.hasName("Predicate<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** The `System.String` class. */
class SystemStringClass extends StringType {
  /** Gets the `Equals(object)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals")
  }

  /** Gets the `==` operator. */
  Operator getEqualsOperator() {
    result.getDeclaringType() = this and
    result.hasName("==")
  }

  /** Gets the `Replace(string/char, string/char)` method. */
  Method getReplaceMethod() {
    result.getDeclaringType() = this and
    result.hasName("Replace") and
    result.getNumberOfParameters() = 2 and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Format(...)` method. */
  Method getFormatMethod() {
    result.getDeclaringType() = this and
    result.hasName("Format") and
    result.getNumberOfParameters() in [2 .. 5] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Split(...)` method. */
  Method getSplitMethod() {
    result.getDeclaringType() = this and
    result.hasName("Split") and
    result.getNumberOfParameters() in [1 .. 3] and
    result.getReturnType().(ArrayType).getElementType() instanceof StringType
  }

  /** Gets a `Substring(...)` method. */
  Method getSubstringMethod() {
    result.getDeclaringType() = this and
    result.hasName("Substring") and
    result.getNumberOfParameters() in [1 .. 2] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Concat(...)` method. */
  Method getConcatMethod() {
    result.getDeclaringType() = this and
    result.hasUndecoratedName("Concat") and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Copy()` method. */
  Method getCopyMethod() {
    result.getDeclaringType() = this and
    result.hasName("Copy") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Join(...)` method. */
  Method getJoinMethod() {
    result.getDeclaringType() = this and
    result.hasUndecoratedName("Join") and
    result.getNumberOfParameters() > 1 and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Clone()` method. */
  Method getCloneMethod() {
    result.getDeclaringType() = this and
    result.hasName("Clone") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `Insert(int, string)` method. */
  Method getInsertMethod() {
    result.getDeclaringType() = this and
    result.hasName("Insert") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof IntType and
    result.getParameter(1).getType() instanceof StringType and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Normalize(...)` method. */
  Method getNormalizeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Normalize") and
    result.getNumberOfParameters() in [0 .. 1] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Remove(...)` method. */
  Method getRemoveMethod() {
    result.getDeclaringType() = this and
    result.hasName("Remove") and
    result.getNumberOfParameters() in [1 .. 2] and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `IsNullOrEmpty(string)` method. */
  Method getIsNullOrEmptyMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNullOrEmpty") and
    result.isStatic() and
    result.getNumberOfParameters() = 1 and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `IsNullOrWhiteSpace(string)` method. */
  Method getIsNullOrWhiteSpaceMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNullOrWhiteSpace") and
    result.isStatic() and
    result.getNumberOfParameters() = 1 and
    result.getReturnType() instanceof BoolType
  }
}

/** Data flow for `System.String`. */
private class SystemStringFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;String;false;Clone;();;Argument[-1];ReturnValue;value",
        "System;String;false;Concat;(System.Collections.Generic.IEnumerable<System.String>);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.Object[]);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Element of Argument[3];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String);;Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[3];ReturnValue;taint",
        "System;String;false;Concat;(System.String[]);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Concat<>;(System.Collections.Generic.IEnumerable<T>);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Copy;(System.String);;Argument[0];ReturnValue;value",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[3];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[3];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[4];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object[]);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object[]);;Element of Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[3];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object[]);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;GetEnumerator;();;Element of Argument[-1];Property[System.CharEnumerator.Current] of ReturnValue;value",
        "System;String;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.IEnumerator<>.Current] of ReturnValue;value",
        "System;String;false;Insert;(System.Int32,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Insert;(System.Int32,System.String);;Argument[-1];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.Object[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.Object[]);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[]);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[],System.Int32,System.Int32);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[],System.Int32,System.Int32);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Collections.Generic.IEnumerable<System.String>);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Collections.Generic.IEnumerable<System.String>);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Object[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Object[]);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[]);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[],System.Int32,System.Int32);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[],System.Int32,System.Int32);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join<>;(System.Char,System.Collections.Generic.IEnumerable<T>);;Argument[0];ReturnValue;taint",
        "System;String;false;Join<>;(System.Char,System.Collections.Generic.IEnumerable<T>);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Join<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Argument[0];ReturnValue;taint",
        "System;String;false;Join<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Element of Argument[1];ReturnValue;taint",
        "System;String;false;Normalize;();;Argument[-1];ReturnValue;taint",
        "System;String;false;Normalize;(System.Text.NormalizationForm);;Argument[-1];ReturnValue;taint",
        "System;String;false;PadLeft;(System.Int32);;Argument[-1];ReturnValue;taint",
        "System;String;false;PadLeft;(System.Int32,System.Char);;Argument[-1];ReturnValue;taint",
        "System;String;false;PadRight;(System.Int32);;Argument[-1];ReturnValue;taint",
        "System;String;false;PadRight;(System.Int32,System.Char);;Argument[-1];ReturnValue;taint",
        "System;String;false;Remove;(System.Int32);;Argument[-1];ReturnValue;taint",
        "System;String;false;Remove;(System.Int32,System.Int32);;Argument[-1];ReturnValue;taint",
        "System;String;false;Replace;(System.Char,System.Char);;Argument[1];ReturnValue;taint",
        "System;String;false;Replace;(System.Char,System.Char);;Argument[-1];ReturnValue;taint",
        "System;String;false;Replace;(System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Replace;(System.String,System.String);;Argument[-1];ReturnValue;taint",
        "System;String;false;Split;(System.Char,System.Int32,System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.Char,System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.Char[]);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.Char[],System.Int32);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.Char[],System.Int32,System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.Char[],System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.String,System.Int32,System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.String,System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.String[],System.Int32,System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;Split;(System.String[],System.StringSplitOptions);;Argument[-1];Element of ReturnValue;taint",
        "System;String;false;String;(System.Char[]);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;String;(System.Char[],System.Int32,System.Int32);;Element of Argument[0];ReturnValue;taint",
        "System;String;false;Substring;(System.Int32);;Argument[-1];ReturnValue;taint",
        "System;String;false;Substring;(System.Int32,System.Int32);;Argument[-1];ReturnValue;taint",
        "System;String;false;ToLower;();;Argument[-1];ReturnValue;taint",
        "System;String;false;ToLower;(System.Globalization.CultureInfo);;Argument[-1];ReturnValue;taint",
        "System;String;false;ToLowerInvariant;();;Argument[-1];ReturnValue;taint",
        "System;String;false;ToString;();;Argument[-1];ReturnValue;value",
        "System;String;false;ToString;(System.IFormatProvider);;Argument[-1];ReturnValue;value",
        "System;String;false;ToUpper;();;Argument[-1];ReturnValue;taint",
        "System;String;false;ToUpper;(System.Globalization.CultureInfo);;Argument[-1];ReturnValue;taint",
        "System;String;false;ToUpperInvariant;();;Argument[-1];ReturnValue;taint",
        "System;String;false;Trim;();;Argument[-1];ReturnValue;taint",
        "System;String;false;Trim;(System.Char);;Argument[-1];ReturnValue;taint",
        "System;String;false;Trim;(System.Char[]);;Argument[-1];ReturnValue;taint",
        "System;String;false;TrimEnd;();;Argument[-1];ReturnValue;taint",
        "System;String;false;TrimEnd;(System.Char);;Argument[-1];ReturnValue;taint",
        "System;String;false;TrimEnd;(System.Char[]);;Argument[-1];ReturnValue;taint",
        "System;String;false;TrimStart;();;Argument[-1];ReturnValue;taint",
        "System;String;false;TrimStart;(System.Char);;Argument[-1];ReturnValue;taint",
        "System;String;false;TrimStart;(System.Char[]);;Argument[-1];ReturnValue;taint",
      ]
  }
}

/** A `ToString()` method. */
class ToStringMethod extends Method {
  ToStringMethod() { this = any(SystemObjectClass c).getToStringMethod().getAnOverrider*() }
}

/** The `System.Type` class */
class SystemTypeClass extends SystemClass {
  SystemTypeClass() { this.hasName("Type") }

  /** Gets the `FullName` property. */
  Property getFullNameProperty() {
    result.getDeclaringType() = this and
    result.hasName("FullName") and
    result.getType() instanceof StringType
  }

  /** Gets the `InvokeMember(string, ...)` method. */
  Method getInvokeMemberMethod() {
    result.getDeclaringType() = this and
    result.hasName("InvokeMember") and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(3).getType() instanceof ObjectType and
    result.getParameter(4).getType().(ArrayType).getElementType() instanceof ObjectType and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `GetMethod(string, ...)` method. */
  Method getGetMethodMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetMethod") and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof SystemReflectionMethodInfoClass
  }
}

/** The `System.Uri` class. */
class SystemUriClass extends SystemClass {
  SystemUriClass() { this.hasName("Uri") }

  /** Gets the `PathAndQuery` property. */
  Property getPathAndQueryProperty() {
    result.getDeclaringType() = this and
    result.hasName("PathAndQuery") and
    result.getType() instanceof StringType
  }

  /** Gets the `Query` property. */
  Property getQueryProperty() {
    result.getDeclaringType() = this and
    result.hasName("Query") and
    result.getType() instanceof StringType
  }

  /** Gets the `OriginalString` property. */
  Property getOriginalStringProperty() {
    result.getDeclaringType() = this and
    result.hasName("OriginalString") and
    result.getType() instanceof StringType
  }
}

/** Data flow for `System.Uri`. */
private class SystemUriFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Uri;false;ToString;();;Argument[-1];ReturnValue;taint",
        "System;Uri;false;Uri;(System.String);;Argument[0];ReturnValue;taint",
        "System;Uri;false;Uri;(System.String,System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Uri;false;Uri;(System.String,System.UriKind);;Argument[0];ReturnValue;taint",
        "System;Uri;false;get_OriginalString;();;Argument[-1];ReturnValue;taint",
        "System;Uri;false;get_PathAndQuery;();;Argument[-1];ReturnValue;taint",
        "System;Uri;false;get_Query;();;Argument[-1];ReturnValue;taint",
      ]
  }
}

/** The `System.ValueType` class. */
class SystemValueTypeClass extends SystemClass {
  SystemValueTypeClass() { this.hasName("ValueType") }
}

/** The `System.IntPtr` type. */
class SystemIntPtrType extends ValueType {
  SystemIntPtrType() {
    this = any(SystemNamespace n).getATypeDeclaration() and
    this.hasName("IntPtr")
  }
}

/** The `System.IDisposable` interface. */
class SystemIDisposableInterface extends SystemInterface {
  SystemIDisposableInterface() { this.hasName("IDisposable") }

  /** Gets the `Dispose()` method. */
  Method getDisposeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Dispose") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof VoidType
  }
}

/** A method that overrides `int object.GetHashCode()`. */
class GetHashCodeMethod extends Method {
  GetHashCodeMethod() {
    exists(Method m | m = any(SystemObjectClass c).getGetHashCodeMethod() |
      this = m.getAnOverrider*()
    )
  }
}

/** A method that overrides `bool object.Equals(object)`. */
class EqualsMethod extends Method {
  EqualsMethod() {
    exists(Method m | m = any(SystemObjectClass c).getEqualsMethod() | this = m.getAnOverrider*())
  }
}

/** A method that implements `bool IEquatable<T>.Equals(T)`. */
class IEquatableEqualsMethod extends Method {
  IEquatableEqualsMethod() {
    exists(Method m |
      m = any(SystemIEquatableTInterface i).getAConstructedGeneric().getAMethod() and
      m.getUnboundDeclaration() = any(SystemIEquatableTInterface i).getEqualsMethod()
    |
      this = m or this.getAnUltimateImplementee() = m
    )
  }
}

/**
 * Whether the type `t` defines an equals method.
 *
 * Either the equals method is (an override of) `object.Equals(object)`,
 * or an implementation of `IEquatable<T>.Equals(T)` which is called
 * from the `object.Equals(object)` method inherited by `t`.
 */
predicate implementsEquals(ValueOrRefType t) { getInvokedEqualsMethod(t).getDeclaringType() = t }

/**
 * Gets the equals method that will be invoked on a value `x`
 * of type `t` when `x.Equals(object)` is called.
 *
 * Either the equals method is (an override of) `object.Equals(object)`,
 * or an implementation of `IEquatable<T>.Equals(T)` which is called
 * from the `object.Equals(object)` method inherited by `t`.
 */
Method getInvokedEqualsMethod(ValueOrRefType t) {
  result = getInheritedEqualsMethod(t, _) and
  not exists(getInvokedIEquatableEqualsMethod(t, result))
  or
  exists(EqualsMethod eq |
    result = getInvokedIEquatableEqualsMethod(t, eq) and
    getInheritedEqualsMethod(t, _) = eq
  )
}

pragma[noinline]
private EqualsMethod getInheritedEqualsMethod(ValueOrRefType t, ValueOrRefType decl) {
  t.hasMethod(result) and decl = result.getDeclaringType()
}

/**
 * Equals method `eq` is inherited by `t`, `t` overrides `IEquatable<T>.Equals(T)`
 * from the declaring type of `eq`, and `eq` calls the overridden method (provided
 * that `eq` is from source code).
 *
 * Example:
 *
 * ```csharp
 * abstract class A<T> : IEquatable<T> {
 *   public abstract bool Equals(T other);
 *   public override bool Equals(object other) { return other != null && GetType() == other.GetType() && Equals((T)other); }
 * }
 *
 * class B : A<B> {
 *   public override bool Equals(B other) { ... }
 * }
 * ```
 *
 * In the example, `t = B`, `eq = A<B>.Equals(object)`, and `result = B.Equals(B)`.
 */
private IEquatableEqualsMethod getInvokedIEquatableEqualsMethod(ValueOrRefType t, EqualsMethod eq) {
  t.hasMethod(result) and
  exists(IEquatableEqualsMethod ieem |
    result = ieem.getAnOverrider*() and
    eq = getInheritedEqualsMethod(t.getBaseClass(), ieem.getDeclaringType())
  |
    not ieem.fromSource()
    or
    callsEqualsMethod(eq, ieem)
  )
}

/** Whether `eq` calls `ieem` */
private predicate callsEqualsMethod(EqualsMethod eq, IEquatableEqualsMethod ieem) {
  exists(MethodCall callToDerivedEquals |
    callToDerivedEquals.getEnclosingCallable() = eq.getUnboundDeclaration() and
    callToDerivedEquals.getTarget() = ieem.getUnboundDeclaration()
  )
}

/** A method that implements `void IDisposable.Dispose()`. */
class DisposeMethod extends Method {
  DisposeMethod() {
    exists(Method m | m = any(SystemIDisposableInterface i).getDisposeMethod() |
      this = m or this.getAnUltimateImplementee() = m
    )
  }
}

/** A method with the signature `void Dispose(bool)`. */
library class DisposeBoolMethod extends Method {
  DisposeBoolMethod() {
    this.hasName("Dispose") and
    this.getReturnType() instanceof VoidType and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof BoolType
  }
}

/**
 * Whether the type `t` defines a dispose method.
 *
 * Either the dispose method is (an override of) `IDisposable.Dispose()`,
 * or an implementation of a method `Dispose(bool)` which is called
 * from the `IDisposable.Dispose()` method inherited by `t`.
 */
predicate implementsDispose(ValueOrRefType t) { getInvokedDisposeMethod(t).getDeclaringType() = t }

/**
 * Gets the dispose method that will be invoked on a value `x`
 * of type `t` when `x.Dipsose()` is called.
 *
 * Either the dispose method is (an override of) `IDisposable.Dispose()`,
 * or an implementation of a method `Dispose(bool)` which is called
 * from the `IDisposable.Dispose()` method inherited by `t`.
 */
Method getInvokedDisposeMethod(ValueOrRefType t) {
  result = getInheritedDisposeMethod(t) and
  not exists(getInvokedDiposeBoolMethod(t, result))
  or
  exists(DisposeMethod eq |
    result = getInvokedDiposeBoolMethod(t, eq) and
    getInheritedDisposeMethod(t) = eq
  )
}

private DisposeMethod getInheritedDisposeMethod(ValueOrRefType t) { t.hasMethod(result) }

/**
 * Dispose method `disp` is inherited by `t`, `t` overrides a `void Dispose(bool)`
 * method from the declaring type of `disp`, and `disp` calls the overridden method
 * (provided that `disp` is from source code).
 *
 * Example:
 *
 * ```csharp
 * class A : IDisposable {
 *   public void Dispose() { Dispose(true); }
 *   public virtual void Dispose(bool disposing) { ... }
 * }
 *
 * class B : A {
 *   public override bool Dispose(bool disposing) { base.Dispose(disposing); ... }
 * }
 * ```
 *
 * In the example, `t = B`, `disp = A.Dispose()`, and `result = B.Dispose(bool)`.
 */
private DisposeBoolMethod getInvokedDiposeBoolMethod(ValueOrRefType t, DisposeMethod disp) {
  t.hasMethod(result) and
  disp = getInheritedDisposeMethod(t.getBaseClass()) and
  exists(DisposeBoolMethod dbm |
    result = dbm.getAnOverrider*() and
    disp.getDeclaringType() = dbm.getDeclaringType()
  |
    not disp.fromSource()
    or
    exists(MethodCall callToDerivedDispose |
      callToDerivedDispose.getEnclosingCallable() = disp.getUnboundDeclaration() and
      callToDerivedDispose.getTarget() = dbm.getUnboundDeclaration()
    )
  )
}

/** A struct in the `System` namespace. */
class SystemStruct extends Struct {
  SystemStruct() { this.getNamespace() instanceof SystemNamespace }
}

/** `System.Guid` struct. */
class SystemGuid extends SystemStruct {
  SystemGuid() { this.hasName("Guid") }
}

/** The `System.NotImplementedException` class. */
class SystemNotImplementedExceptionClass extends SystemClass {
  SystemNotImplementedExceptionClass() { this.hasName("NotImplementedException") }
}

/** The `System.DateTime` struct. */
class SystemDateTimeStruct extends SystemStruct {
  SystemDateTimeStruct() { this.hasName("DateTime") }
}
