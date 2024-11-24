extends Node
class_name GameOptionsUtils


static func register_setting(property_name: String, type: int, default_value: Variant, hint: int = 0, hint_string: String = "") -> void:
	if not ProjectSettings.has_setting(property_name):
		ProjectSettings.set(property_name, default_value)
		ProjectSettings.add_property_info({
			"name": property_name,
			"type": type,
			"hint": hint,
			"hint_string": hint_string,
		})
	ProjectSettings.set_initial_value(property_name, default_value)
	ProjectSettings.set_as_basic(property_name, true)


static func error_message(error: Error) -> String:
	match error:
		FAILED:
			return "Failed."
		ERR_UNAVAILABLE:
			return "Unavailable."
		ERR_UNCONFIGURED:
			return "Unconfigured."
		ERR_UNAUTHORIZED:
			return "Unauthorized."
		ERR_PARAMETER_RANGE_ERROR:
			return "Parameter range error."
		ERR_OUT_OF_MEMORY:
			return "Out of memory (OOM)."
		ERR_FILE_NOT_FOUND:
			return "File not found."
		ERR_FILE_BAD_DRIVE:
			return "Bad drive."
		ERR_FILE_BAD_PATH:
			return "Bad file path."
		ERR_FILE_NO_PERMISSION:
			return "No file permission."
		ERR_FILE_ALREADY_IN_USE:
			return "File already in use."
		ERR_FILE_CANT_OPEN:
			return "Can't open file."
		ERR_FILE_CANT_WRITE:
			return "Can't write to file."
		ERR_FILE_CANT_READ:
			return "Can't read file."
		ERR_FILE_UNRECOGNIZED:
			return "Unrecognized file."
		ERR_FILE_CORRUPT:
			return "File is corrupt."
		ERR_FILE_MISSING_DEPENDENCIES:
			return "Missing file dependencies."
		ERR_FILE_EOF:
			return "End of file (EOF)."
		ERR_CANT_OPEN:
			return "Can't open."
		ERR_CANT_CREATE:
			return "Can't create."
		ERR_QUERY_FAILED:
			return "Query failed."
		ERR_ALREADY_IN_USE:
			return "Already in use."
		ERR_LOCKED:
			return "Locked."
		ERR_TIMEOUT:
			return "Timeout."
		ERR_CANT_CONNECT:
			return "Can't connect."
		ERR_CANT_RESOLVE:
			return "Can't resolve."
		ERR_CONNECTION_ERROR:
			return "Connection error."
		ERR_CANT_ACQUIRE_RESOURCE:
			return "Can't acquire resource."
		ERR_CANT_FORK:
			return "Can't fork process."
		ERR_INVALID_DATA:
			return "Invalid data."
		ERR_INVALID_PARAMETER:
			return "Invalid parameter."
		ERR_ALREADY_EXISTS:
			return "Already exists."
		ERR_DOES_NOT_EXIST:
			return "Does not exist."
		ERR_DATABASE_CANT_READ:
			return "Database: Read error."
		ERR_DATABASE_CANT_WRITE:
			return "Database: Write error."
		ERR_COMPILATION_FAILED:
			return "Compilation failed."
		ERR_METHOD_NOT_FOUND:
			return "Method not found."
		ERR_LINK_FAILED:
			return "Linking failed."
		ERR_SCRIPT_FAILED:
			return "Script failed."
		ERR_CYCLIC_LINK:
			return "Cycling link (import cycle)."
		ERR_INVALID_DECLARATION:
			return "Invalid declaration."
		ERR_DUPLICATE_SYMBOL:
			return "Duplicate symbol."
		ERR_PARSE_ERROR:
			return "Parse error."
		ERR_BUSY:
			return "Busy."
		ERR_SKIP:
			return "Skip error."
		ERR_HELP:
			return "Help error. Used internally when passing --version or --help as executable options."
		ERR_BUG:
			return "Godot bug encountered."
		ERR_PRINTER_ON_FIRE:
			return "Printer is on fire."
		_:
			return "Unknown error."
