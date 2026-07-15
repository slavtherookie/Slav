local ThemeKeys = {}

local textColor = Color3.fromRGB(230, 230, 235)
local backgroundColor = Color3.fromRGB(0, 0, 0)
local selectionColor = Color3.fromRGB(255, 255, 255)
local selectionBackgroundColor = Color3.fromRGB(0, 90, 156)
local operatorColor = Color3.fromRGB(230, 230, 235)
local numberColor = Color3.fromRGB(255, 191, 71)
local stringColor = Color3.fromRGB(120, 245, 175)
local commentColor = Color3.fromRGB(120, 126, 145)
local keywordColor = Color3.fromRGB(255, 110, 110)
local errorColor = Color3.fromRGB(255, 69, 58)
local warningColor = Color3.fromRGB(255, 149, 0)
local informationColor = Color3.fromRGB(100, 108, 130)
local hintColor = Color3.fromRGB(90, 150, 255)
local findSelectionBackgroundColor = Color3.fromRGB(178, 128, 0)
local matchingWordBackgroundColor = Color3.fromRGB(35, 35, 35)
local builtinFunctionColor = Color3.fromRGB(120, 195, 255)
local whitespaceColor = Color3.fromRGB(70, 74, 90)
local currentLineHighlightColor = Color3.fromRGB(18, 18, 18)
local debuggerCurrentLineColor = Color3.fromRGB(20, 20, 20)
local debuggerErrorLineColor = Color3.fromRGB(45, 15, 15)
local localMethodColor = Color3.fromRGB(255, 224, 150)
local localPropertyColor = Color3.fromRGB(130, 175, 255)
local nilColor = Color3.fromRGB(255, 191, 71)
local boolColor = Color3.fromRGB(255, 191, 71)
local functionWordColor = Color3.fromRGB(255, 110, 110)
local localWordColor = Color3.fromRGB(255, 110, 110)
local selfColor = Color3.fromRGB(255, 140, 140)
local luauKeywordColor = Color3.fromRGB(255, 110, 110)
local functionNameColor = Color3.fromRGB(255, 224, 150)
local todoColor = Color3.fromRGB(120, 126, 145)
local scriptRulerColor = Color3.fromRGB(60, 60, 60)
local scriptBracketColor = Color3.fromRGB(230, 230, 235)
local typeColor = Color3.fromRGB(110, 165, 255)
local documentationCodeBlockBackgroundColor = Color3.fromRGB(15, 15, 15)
local menuPrimaryTextColor = Color3.fromRGB(240, 240, 240)
local menuSecondaryTextColor = Color3.fromRGB(130, 130, 130)
local menuSelectedTextColor = Color3.fromRGB(255, 255, 255)
local menuItemBackgroundColor = Color3.fromRGB(12, 12, 12)
local selectedMenuItemBackgroundColor = Color3.fromRGB(0, 90, 156)
local scriptEditorScrollbarBackgroundColor = Color3.fromRGB(0, 0, 0)
local scriptEditorScrollbarHandleColor = Color3.fromRGB(55, 55, 55)
local indentationRulerColor = Color3.fromRGB(28, 28, 28)

ThemeKeys["TextColor"] = { type = "editor", color = textColor }
ThemeKeys["BackgroundColor"] = { type = "editor", color = backgroundColor }
ThemeKeys["SelectionColor"] = { type = "editor", color = selectionColor }
ThemeKeys["SelectionBackgroundColor"] = { type = "editor", color = selectionBackgroundColor }
ThemeKeys["ErrorColor"] = { type = "editor", color = errorColor }
ThemeKeys["WarningColor"] = { type = "editor", color = warningColor }
ThemeKeys["InformationColor"] = { type = "editor", color = informationColor }
ThemeKeys["HintColor"] = { type = "editor", color = hintColor }
ThemeKeys["FindSelectionBackgroundColor"] = { type = "editor", color = findSelectionBackgroundColor }
ThemeKeys["MatchingWordBackgroundColor"] = { type = "editor", color = matchingWordBackgroundColor }
ThemeKeys["WhitespaceColor"] = { type = "editor", color = whitespaceColor }
ThemeKeys["CurrentLineHighlightColor"] = { type = "editor", color = currentLineHighlightColor }
ThemeKeys["DebuggerCurrentLineColor"] = { type = "editor", color = debuggerCurrentLineColor }
ThemeKeys["DebuggerErrorLineColor"] = { type = "editor", color = debuggerErrorLineColor }
ThemeKeys["TODOColor"] = { type = "comment", color = todoColor }
ThemeKeys["ScriptRulerColor"] = { type = "editor", color = scriptRulerColor }
ThemeKeys["ScriptBracketColor"] = { type = "operator", color = scriptBracketColor }
ThemeKeys["DocumentationCodeBlockBackgroundColor"] = { type = "editor", color = documentationCodeBlockBackgroundColor }
ThemeKeys["MenuPrimaryTextColor"] = { type = "editor", color = menuPrimaryTextColor }
ThemeKeys["MenuSecondaryTextColor"] = { type = "editor", color = menuSecondaryTextColor }
ThemeKeys["MenuSelectedTextColor"] = { type = "editor", color = menuSelectedTextColor }
ThemeKeys["MenuItemBackground"] = { type = "editor", color = menuItemBackgroundColor }
ThemeKeys["SelectedMenuItemBackground"] = { type = "editor", color = selectedMenuItemBackgroundColor }
ThemeKeys["ScriptEditorScrollbarBackground"] = { type = "editor", color = scriptEditorScrollbarBackgroundColor }
ThemeKeys["ScriptEditorScrollbarHandle"] = { type = "editor", color = scriptEditorScrollbarHandleColor }
ThemeKeys["IndentationRulerColor"] = { type = "editor", color = indentationRulerColor }

ThemeKeys["and"] = { type = "keyword", color = keywordColor }
ThemeKeys["do"] = { type = "keyword", color = keywordColor }
ThemeKeys["end"] = { type = "keyword", color = keywordColor }
ThemeKeys["export"] = { type = "keyword", color = luauKeywordColor }
ThemeKeys["function"] = { type = "keyword", color = functionWordColor }
ThemeKeys["in"] = { type = "keyword", color = keywordColor }
ThemeKeys["inf"] = { type = "keyword", color = keywordColor }
ThemeKeys["local"] = { type = "keyword", color = localWordColor }
ThemeKeys["not"] = { type = "keyword", color = keywordColor }
ThemeKeys["or"] = { type = "keyword", color = keywordColor }
ThemeKeys["then"] = { type = "keyword", color = keywordColor }
ThemeKeys["type"] = { type = "keyword", color = luauKeywordColor }
ThemeKeys["self"] = { type = "keyword", color = selfColor }

ThemeKeys["break"] = { type = "flow", color = keywordColor }
ThemeKeys["continue"] = { type = "flow", color = luauKeywordColor }
ThemeKeys["else"] = { type = "flow", color = keywordColor }
ThemeKeys["elseif"] = { type = "flow", color = keywordColor }
ThemeKeys["for"] = { type = "flow", color = keywordColor }
ThemeKeys["if"] = { type = "flow", color = keywordColor }
ThemeKeys["repeat"] = { type = "flow", color = keywordColor }
ThemeKeys["return"] = { type = "flow", color = keywordColor }
ThemeKeys["until"] = { type = "flow", color = keywordColor }
ThemeKeys["while"] = { type = "flow", color = keywordColor }

ThemeKeys["false"] = { type = "literal", color = boolColor }
ThemeKeys["nil"] = { type = "literal", color = nilColor }
ThemeKeys["true"] = { type = "literal", color = boolColor }

ThemeKeys["string_literal"] = { type = "string", color = stringColor }
ThemeKeys["function_name"] = { type = "identifier", color = functionNameColor }
ThemeKeys["local_method"] = { type = "identifier", color = localMethodColor }
ThemeKeys["local_property"] = { type = "identifier", color = localPropertyColor }

ThemeKeys["op_add"] = { type = "operator", color = operatorColor }
ThemeKeys["op_assign"] = { type = "operator", color = operatorColor }
ThemeKeys["op_concat"] = { type = "operator", color = operatorColor }
ThemeKeys["op_div"] = { type = "operator", color = operatorColor }
ThemeKeys["op_eq"] = { type = "operator", color = operatorColor }
ThemeKeys["op_floordiv"] = { type = "operator", color = operatorColor }
ThemeKeys["op_ge"] = { type = "operator", color = operatorColor }
ThemeKeys["op_gt"] = { type = "operator", color = operatorColor }
ThemeKeys["op_le"] = { type = "operator", color = operatorColor }
ThemeKeys["op_len"] = { type = "operator", color = operatorColor }
ThemeKeys["op_lt"] = { type = "operator", color = operatorColor }
ThemeKeys["op_mod"] = { type = "operator", color = operatorColor }
ThemeKeys["op_mul"] = { type = "operator", color = operatorColor }
ThemeKeys["op_neq"] = { type = "operator", color = operatorColor }
ThemeKeys["op_pow"] = { type = "operator", color = operatorColor }
ThemeKeys["op_sub"] = { type = "operator", color = operatorColor }
ThemeKeys["op_unm"] = { type = "operator", color = operatorColor }

ThemeKeys["op_ampersand"] = { type = "type_annotation", color = operatorColor }
ThemeKeys["op_arrow"] = { type = "type_annotation", color = operatorColor }
ThemeKeys["op_colon"] = { type = "type_annotation", color = operatorColor }
ThemeKeys["op_pipe"] = { type = "type_annotation", color = operatorColor }
ThemeKeys["op_question"] = { type = "type_annotation", color = operatorColor }
ThemeKeys["op_typecast"] = { type = "type_annotation", color = operatorColor }

ThemeKeys["typeof"] = { type = "type_annotation", color = builtinFunctionColor }
ThemeKeys["assert"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["collectgarbage"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["error"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["gcinfo"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["getfenv"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["getmetatable"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["ipairs"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["loadstring"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["newproxy"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["next"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["pairs"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["pcall"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["print"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["rawequal"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["rawget"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["rawlen"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["rawset"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["require"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["select"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["setfenv"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["setmetatable"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["tonumber"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["tostring"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["unpack"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["warn"] = { type = "builtin", color = builtinFunctionColor }
ThemeKeys["xpcall"] = { type = "builtin", color = builtinFunctionColor }

ThemeKeys["_G"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["_VERSION"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["bit32"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["buffer"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["coroutine"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["debug"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["game"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["math"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["os"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["plugin"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["script"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["shared"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["string"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["table"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["task"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["utf8"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["vector"] = { type = "global", color = builtinFunctionColor }
ThemeKeys["workspace"] = { type = "global", color = builtinFunctionColor }

ThemeKeys["Axes"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["BrickColor"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["CFrame"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["CatalogSearchParams"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Color3"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["ColorSequence"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["ColorSequenceKeypoint"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["DateTime"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["DockWidgetPluginGuiInfo"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Enum"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["EnumItem"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Faces"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["FloatCurveKey"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Font"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Instance"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["NumberRange"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["NumberSequence"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["NumberSequenceKeypoint"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["OverlapParams"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["PathWaypoint"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["PhysicalProperties"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Ray"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["RaycastParams"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["RaycastResult"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Rect"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Region3"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Region3int16"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["RotationCurveKey"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["SharedTable"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["TweenInfo"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["UDim"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["UDim2"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Vector2"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Vector2int16"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Vector3"] = { type = "type", color = builtinFunctionColor }
ThemeKeys["Vector3int16"] = { type = "type", color = builtinFunctionColor }

ThemeKeys["any"] = { type = "type", color = typeColor }
ThemeKeys["boolean"] = { type = "type", color = typeColor }
ThemeKeys["never"] = { type = "type", color = typeColor }
ThemeKeys["number"] = { type = "type", color = typeColor }
ThemeKeys["thread"] = { type = "type", color = typeColor }
ThemeKeys["unknown"] = { type = "type", color = typeColor }
ThemeKeys["userdata"] = { type = "type", color = typeColor }
ThemeKeys["void"] = { type = "type", color = typeColor }

ThemeKeys["__add"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__band"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__bnot"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__bor"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__bxor"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__call"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__concat"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__div"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__eq"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__idiv"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__index"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__iter"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__le"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__len"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__lt"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__mod"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__mul"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__newindex"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__pow"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__shl"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__shr"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__sub"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__tostring"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__type"] = { type = "metamethod", color = builtinFunctionColor }
ThemeKeys["__unm"] = { type = "metamethod", color = builtinFunctionColor }

ThemeKeys["comment_multi_close"] = { type = "comment", color = commentColor }
ThemeKeys["comment_multi_open"] = { type = "comment", color = commentColor }
ThemeKeys["comment_single"] = { type = "comment", color = commentColor }

ThemeKeys["num_binary"] = { type = "number", color = numberColor }
ThemeKeys["num_exp"] = { type = "number", color = numberColor }
ThemeKeys["num_float"] = { type = "number", color = numberColor }
ThemeKeys["num_hex"] = { type = "number", color = numberColor }
ThemeKeys["num_inf"] = { type = "number", color = numberColor }
ThemeKeys["num_integer"] = { type = "number", color = numberColor }
ThemeKeys["num_nan"] = { type = "number", color = numberColor }
ThemeKeys["num_separator"] = { type = "number", color = numberColor }

return function() return ThemeKeys end
