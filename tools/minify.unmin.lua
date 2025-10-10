
function G_1(L_37_arg1)
	for L_38_forvar1, L_39_forvar2 in pairs(L_37_arg1) do
		L_37_arg1[L_39_forvar2] = true
	end
	return L_37_arg1
end
function G_2(L_40_arg1)
	local L_41_ = 0
	for L_42_forvar1 in pairs(L_40_arg1) do
		L_41_ = L_41_ + 1
	end
	return L_41_
end
function G_3(L_43_arg1, L_44_arg2, L_45_arg3)
	if L_43_arg1.Print then
		return L_43_arg1.Print()
	end
	L_44_arg2 = L_44_arg2 or 0
	local L_46_ = (G_2(L_43_arg1) > 1)
	local L_47_ = string.rep('    ', L_44_arg2 + 1)
	local L_48_ = "{"..(L_46_ and '\n' or '')
	for L_49_forvar1, L_50_forvar2 in pairs(L_43_arg1) do
		if type(L_50_forvar2) ~= 'function' and not L_45_arg3(L_49_forvar1) then
			L_48_ = L_48_..(L_46_ and L_47_ or '')
			if type(L_49_forvar1) == 'number' then
			elseif type(L_49_forvar1) == 'string' and L_49_forvar1:match("^[A-Za-z_][A-Za-z0-9_]*$") then
				L_48_ = L_48_..L_49_forvar1.." = "
			elseif type(L_49_forvar1) == 'string' then
				L_48_ = L_48_.."[\""..L_49_forvar1.."\"] = "
			else
				L_48_ = L_48_.."["..tostring(L_49_forvar1).."] = "
			end
			if type(L_50_forvar2) == 'string' then
				L_48_ = L_48_.."\""..L_50_forvar2.."\""
			elseif type(L_50_forvar2) == 'number' then
				L_48_ = L_48_..L_50_forvar2
			elseif type(L_50_forvar2) == 'table' then
				L_48_ = L_48_..G_3(L_50_forvar2, L_44_arg2 + (L_46_ and 1 or 0), L_45_arg3)
			else
				L_48_ = L_48_..tostring(L_50_forvar2)
			end
			if next(L_43_arg1, L_49_forvar1) then
				L_48_ = L_48_..","
			end
			if L_46_ then
				L_48_ = L_48_..'\n'
			end
		end
	end
	L_48_ = L_48_..(L_46_ and string.rep('    ', L_44_arg2) or '').."}"
	return L_48_
end
function G_4(L_51_arg1, L_52_arg2)
	L_52_arg2 = L_52_arg2 or function()
		return false
	end
	return G_3(L_51_arg1, 0, L_52_arg2)
end
local L_1_ = G_1{
	' ',
	'\n',
	'\t',
	'\r'
}
local L_2_ = {
	['\r'] = '\\r',
	['\n'] = '\\n',
	['\t'] = '\\t',
	['"'] = '\\"',
	["'"] = "\\'",
	['\\'] = '\\'
}
local L_3_ = {
	['r'] = '\r',
	['n'] = '\n',
	['t'] = '\t',
	['"'] = '"',
	["'"] = "'",
	['\\'] = '\\'
}
local L_4_ = G_1{
	'a',
	'b',
	'c',
	'd',
	'e',
	'f',
	'g',
	'h',
	'i',
	'j',
	'k',
	'l',
	'm',
	'n',
	'o',
	'p',
	'q',
	'r',
	's',
	't',
	'u',
	'v',
	'w',
	'x',
	'y',
	'z',
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H',
	'I',
	'J',
	'K',
	'L',
	'M',
	'N',
	'O',
	'P',
	'Q',
	'R',
	'S',
	'T',
	'U',
	'V',
	'W',
	'X',
	'Y',
	'Z',
	'_'
}
local L_5_ = G_1{
	'a',
	'b',
	'c',
	'd',
	'e',
	'f',
	'g',
	'h',
	'i',
	'j',
	'k',
	'l',
	'm',
	'n',
	'o',
	'p',
	'q',
	'r',
	's',
	't',
	'u',
	'v',
	'w',
	'x',
	'y',
	'z',
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H',
	'I',
	'J',
	'K',
	'L',
	'M',
	'N',
	'O',
	'P',
	'Q',
	'R',
	'S',
	'T',
	'U',
	'V',
	'W',
	'X',
	'Y',
	'Z',
	'_',
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9'
}
local L_6_ = G_1{
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9'
}
local L_7_ = G_1{
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9',
	'A',
	'a',
	'B',
	'b',
	'C',
	'c',
	'D',
	'd',
	'E',
	'e',
	'F',
	'f'
}
local L_8_ = G_1{
	'+',
	'-',
	'*',
	'/',
	'^',
	'%',
	',',
	'{',
	'}',
	'[',
	']',
	'(',
	')',
	';',
	'#',
	'.',
	':'
}
local L_9_ = G_1{
	'~',
	'=',
	'>',
	'<'
}
local L_10_ = G_1{
	'and',
	'break',
	'do',
	'else',
	'elseif',
	'end',
	'false',
	'for',
	'function',
	'goto',
	'if',
	'in',
	'local',
	'nil',
	'not',
	'or',
	'repeat',
	'return',
	'then',
	'true',
	'until',
	'while',
}
local L_11_ = G_1{
	'else',
	'elseif',
	'until',
	'end'
}
local L_12_ = G_1{
	'-',
	'not',
	'#'
}
local L_13_ = G_1{
	'+',
	'-',
	'*',
	'/',
	'%',
	'^',
	'#',
	'..',
	'.',
	':',
	'>',
	'<',
	'<=',
	'>=',
	'~=',
	'==',
	'and',
	'or'
}
local L_14_ = G_1{}
local L_15_ = {
	['+'] = {
		6,
		6
	};
	['-'] = {
		6,
		6
	};
	['*'] = {
		7,
		7
	};
	['/'] = {
		7,
		7
	};
	['%'] = {
		7,
		7
	};
	['^'] = {
		10,
		9
	};
	['..'] = {
		5,
		4
	};
	['=='] = {
		3,
		3
	};
	['~='] = {
		3,
		3
	};
	['>'] = {
		3,
		3
	};
	['<'] = {
		3,
		3
	};
	['>='] = {
		3,
		3
	};
	['<='] = {
		3,
		3
	};
	['and'] = {
		2,
		2
	};
	['or'] = {
		1,
		1
	};
}
local L_16_ = 8
function G_5(L_53_arg1)
	local L_54_ = 1
	local L_55_ = #L_53_arg1
	local L_56_ = {}
	local function L_57_func(L_66_arg1)
		L_66_arg1 = L_54_ + (L_66_arg1 or 0)
		if L_66_arg1 <= L_55_ then
			return L_53_arg1:sub(L_66_arg1, L_66_arg1)
		else
			return ''
		end
	end
	local function L_58_func()
		if L_54_ <= L_55_ then
			local L_67_ = L_53_arg1:sub(L_54_, L_54_)
			L_54_ = L_54_ + 1
			return L_67_
		else
			return ''
		end
	end
	local L_59_ = error
	local function L_60_func(L_68_arg1)
		local L_69_ = 1
		local L_70_ = 1
		local L_71_ = 1
		while L_69_ <= L_54_ do
			if L_53_arg1:sub(L_69_, L_69_) == '\n' then
				L_70_ = L_70_ + 1
				L_71_ = 1
			else
				L_71_ = L_71_ + 1
			end
			L_69_ = L_69_ + 1
		end
		for L_72_forvar1, L_73_forvar2 in pairs(L_56_) do
			print(L_73_forvar2.Type.."<"..L_73_forvar2.Source..">")
		end
		L_59_("file<"..L_70_..":"..L_71_..">: "..L_68_arg1)
	end
	local function L_61_func(L_74_arg1)
		while true do
			local L_75_ = L_58_func()
			if L_75_ == '' then
				L_60_func("Unfinished long string.")
			elseif L_75_ == ']' then
				local L_76_ = true
				for L_77_forvar1 = 1, L_74_arg1 do
					if L_57_func() == '=' then
						L_54_ = L_54_ + 1
					else
						L_76_ = false
						break
					end
				end
				if L_76_ and L_58_func() == ']' then
					return
				end
			end
		end
	end
	local function L_62_func()
		local L_78_ = L_54_
		while L_57_func() == '=' do
			L_54_ = L_54_ + 1
		end
		if L_57_func() == '[' then
			L_54_ = L_54_ + 1
			return L_54_ - L_78_ - 1
		else
			L_54_ = L_78_
			return nil
		end
	end
	local L_63_ = 1
	local L_64_ = 1
	local function L_65_func(L_79_arg1)
		local L_80_ = {
			Type = L_79_arg1;
			LeadingWhite = L_53_arg1:sub(L_63_, L_64_ - 1);
			Source = L_53_arg1:sub(L_64_, L_54_ - 1);
		}
		table.insert(L_56_, L_80_)
		L_63_ = L_54_
		L_64_ = L_54_
		return L_80_
	end
	while true do
		L_63_ = L_54_
		while true do
			local L_83_ = L_57_func()
			if L_83_ == '' then
				break
			elseif L_83_ == '-' then
				if L_57_func(1) == '-' then
					L_54_ = L_54_ + 2
					if L_57_func() == '[' then
						L_54_ = L_54_ + 1
						local L_84_ = L_62_func()
						if L_84_ then
							L_61_func(L_84_)
						else
							while true do
								local L_85_ = L_58_func()
								if L_85_ == '' or L_85_ == '\n' then
									break
								end
							end
						end
					else
						while true do
							local L_86_ = L_58_func()
							if L_86_ == '' or L_86_ == '\n' then
								break
							end
						end
					end
				else
					break
				end
			elseif L_1_[L_83_] then
				L_54_ = L_54_ + 1
			else
				break
			end
		end
		local L_81_ = L_53_arg1:sub(L_63_, L_54_ - 1)
		L_64_ = L_54_
		local L_82_ = L_58_func()
		if L_82_ == '' then
			L_65_func('Eof')
			break
		elseif L_82_ == '\'' or L_82_ == '\"' then
			while true do
				local L_87_ = L_58_func()
				if L_87_ == '\\' then
					local L_88_ = L_58_func()
					local L_89_ = L_3_[L_88_]
					if not L_89_ then
						L_60_func("Invalid Escape Sequence `"..L_88_.."`.")
					end
				elseif L_87_ == L_82_ then
					break
				end
			end
			L_65_func('String')
		elseif L_4_[L_82_] then
			while L_5_[L_57_func()] do
				L_54_ = L_54_ + 1
			end
			if L_10_[L_53_arg1:sub(L_64_, L_54_ - 1)] then
				L_65_func('Keyword')
			else
				L_65_func('Ident')
			end
		elseif L_6_[L_82_] or (L_82_ == '.' and L_6_[L_57_func()]) then
			if L_82_ == '0' and L_57_func() == 'x' then
				L_54_ = L_54_ + 1
				while L_7_[L_57_func()] do
					L_54_ = L_54_ + 1
				end
			else
				while L_6_[L_57_func()] do
					L_54_ = L_54_ + 1
				end
				if L_57_func() == '.' then
					L_54_ = L_54_ + 1
					while L_6_[L_57_func()] do
						L_54_ = L_54_ + 1
					end
				end
				if L_57_func() == 'e' or L_57_func() == 'E' then
					L_54_ = L_54_ + 1
					if L_57_func() == '-' then
						L_54_ = L_54_ + 1
					end
					while L_6_[L_57_func()] do
						L_54_ = L_54_ + 1
					end
				end
			end
			L_65_func('Number')
		elseif L_82_ == '[' then
			local L_90_ = L_62_func()
			if L_90_ then
				L_61_func(L_90_)
				L_65_func('String')
			else
				L_65_func('Symbol')
			end
		elseif L_82_ == '.' then
			if L_57_func() == '.' then
				L_58_func()
				if L_57_func() == '.' then
					L_58_func()
				end
			end
			L_65_func('Symbol')
		elseif L_9_[L_82_] then
			if L_57_func() == '=' then
				L_54_ = L_54_ + 1
			end
			L_65_func('Symbol')
		elseif L_8_[L_82_] then
			L_65_func('Symbol')
		else
			L_60_func("Bad symbol `"..L_82_.."` in source.")
		end
	end
	return L_56_
end
function G_6(L_91_arg1)
	local L_92_ = G_5(L_91_arg1)
	local L_93_ = 1
	local function L_94_func()
		local L_124_ = L_92_[L_93_]
		if L_93_ < #L_92_ then
			L_93_ = L_93_ + 1
		end
		return L_124_
	end
	local function L_95_func(L_125_arg1)
		L_125_arg1 = L_93_ + (L_125_arg1 or 0)
		return L_92_[L_125_arg1] or L_92_[#L_92_]
	end
	local function L_96_func(L_126_arg1)
		local L_127_ = 1
		local L_128_ = 0
		local L_129_ = 1
		while true do
			local L_130_ = L_92_[L_129_]
			local L_131_
			if L_130_ == L_126_arg1 then
				L_131_ = L_130_.LeadingWhite
			else
				L_131_ = L_130_.LeadingWhite..L_130_.Source
			end
			for L_132_forvar1 = 1, #L_131_ do
				local L_133_ = L_131_:sub(L_132_forvar1, L_132_forvar1)
				if L_133_ == '\n' then
					L_127_ = L_127_ + 1
					L_128_ = 0
				else
					L_128_ = L_128_ + 1
				end
			end
			if L_130_ == L_126_arg1 then
				break
			end
			L_129_ = L_129_ + 1
		end
		return L_127_..":"..(L_128_ + 1)
	end
	local function L_97_func()
		local L_134_ = L_95_func()
		return "<"..L_134_.Type.." `"..L_134_.Source.."`> at: "..L_96_func(L_134_)
	end
	local function L_98_func()
		local L_135_ = L_95_func()
		return L_135_.Type == 'Eof' or (L_135_.Type == 'Keyword' and L_11_[L_135_.Source])
	end
	local function L_99_func()
		return L_12_[L_95_func().Source] or false
	end
	local function L_100_func()
		return L_13_[L_95_func().Source] or false
	end
	local function L_101_func(L_136_arg1, L_137_arg2)
		local L_138_ = L_95_func()
		if L_138_.Type == L_136_arg1 and (L_137_arg2 == nil or L_138_.Source == L_137_arg2) then
			return L_94_func()
		else
			for L_139_forvar1 = -3, 3 do
				print("Tokens["..L_139_forvar1.."] = `"..L_95_func(L_139_forvar1).Source.."`")
			end
			if L_137_arg2 then
				error(L_96_func(L_138_)..": `"..L_137_arg2.."` expected.")
			else
				error(L_96_func(L_138_)..": "..L_136_arg1.." expected.")
			end
		end
	end
	local function L_102_func(L_140_arg1)
		local L_141_ = L_140_arg1.GetFirstToken
		local L_142_ = L_140_arg1.GetLastToken
		function L_140_arg1:GetFirstToken()
			local L_143_ = L_141_(self)
			assert(L_143_)
			return L_143_
		end
		function L_140_arg1:GetLastToken()
			local L_144_ = L_142_(self)
			assert(L_144_)
			return L_144_
		end
		return L_140_arg1
	end
	local L_103_
	local L_104_
	local function L_105_func()
		local L_145_ = {}
		local L_146_ = {}
		table.insert(L_145_, L_104_())
		while L_95_func().Source == ',' do
			table.insert(L_146_, L_94_func())
			table.insert(L_145_, L_104_())
		end
		return L_145_, L_146_
	end
	local function L_106_func()
		local L_147_ = L_95_func()
		if L_147_.Source == '(' then
			local L_148_ = L_94_func()
			local L_149_ = L_104_()
			local L_150_ = L_101_func('Symbol', ')')
			return L_102_func{
				Type = 'ParenExpr';
				Expression = L_149_;
				Token_OpenParen = L_148_;
				Token_CloseParen = L_150_;
				GetFirstToken = function(L_151_arg1)
					return L_151_arg1.Token_OpenParen
				end;
				GetLastToken = function(L_152_arg1)
					return L_152_arg1.Token_CloseParen
				end;
			}
		elseif L_147_.Type == 'Ident' then
			return L_102_func{
				Type = 'VariableExpr';
				Token = L_94_func();
				GetFirstToken = function(L_153_arg1)
					return L_153_arg1.Token
				end;
				GetLastToken = function(L_154_arg1)
					return L_154_arg1.Token
				end;
			}
		else
			print(L_97_func())
			error(L_96_func(L_147_)..": Unexpected symbol")
		end
	end
	function G_7()
		local L_155_ = L_101_func('Symbol', '{')
		local L_156_ = {}
		local L_157_ = {}
		while L_95_func().Source ~= '}' do
			if L_95_func().Source == '[' then
				local L_159_ = L_94_func()
				local L_160_ = L_104_()
				local L_161_ = L_101_func('Symbol', ']')
				local L_162_ = L_101_func('Symbol', '=')
				local L_163_ = L_104_()
				table.insert(L_156_, {
					EntryType = 'Index';
					Index = L_160_;
					Value = L_163_;
					Token_OpenBracket = L_159_;
					Token_CloseBracket = L_161_;
					Token_Equals = L_162_;
				})
			elseif L_95_func().Type == 'Ident' and L_95_func(1).Source == '=' then
				local L_164_ = L_94_func()
				local L_165_ = L_94_func()
				local L_166_ = L_104_()
				table.insert(L_156_, {
					EntryType = 'Field';
					Field = L_164_;
					Value = L_166_;
					Token_Equals = L_165_;
				})
			else
				local L_167_ = L_104_()
				table.insert(L_156_, {
					EntryType = 'Value';
					Value = L_167_;
				})
			end
			if L_95_func().Source == ',' or L_95_func().Source == ';' then
				table.insert(L_157_, L_94_func())
			else
				break
			end
		end
		local L_158_ = L_101_func('Symbol', '}')
		return L_102_func{
			Type = 'TableLiteral';
			EntryList = L_156_;
			Token_SeparatorList = L_157_;
			Token_OpenBrace = L_155_;
			Token_CloseBrace = L_158_;
			GetFirstToken = function(L_168_arg1)
				return L_168_arg1.Token_OpenBrace
			end;
			GetLastToken = function(L_169_arg1)
				return L_169_arg1.Token_CloseBrace
			end;
		}
	end
	local function L_107_func()
		local L_170_ = {}
		local L_171_ = {}
		if L_95_func().Type == 'Ident' then
			table.insert(L_170_, L_94_func())
		end
		while L_95_func().Source == ',' do
			table.insert(L_171_, L_94_func())
			local L_172_ = L_101_func('Ident')
			table.insert(L_170_, L_172_)
		end
		return L_170_, L_171_
	end
	local function L_108_func(L_173_arg1)
		local L_174_ = L_103_()
		local L_175_ = L_95_func()
		if L_175_.Type == 'Keyword' and L_175_.Source == L_173_arg1 then
			L_94_func()
			return L_174_, L_175_
		else
			print(L_175_.Type, L_175_.Source)
			error(L_96_func(L_175_)..": "..L_173_arg1.." expected.")
		end
	end
	local function L_109_func(L_176_arg1)
		local L_177_ = L_94_func()
		local L_178_
		local L_179_
		if not L_176_arg1 then
			L_178_ = {}
			L_179_ = {}
			table.insert(L_178_, L_101_func('Ident'))
			while L_95_func().Source == '.' do
				table.insert(L_179_, L_94_func())
				table.insert(L_178_, L_101_func('Ident'))
			end
			if L_95_func().Source == ':' then
				table.insert(L_179_, L_94_func())
				table.insert(L_178_, L_101_func('Ident'))
			end
		end
		local L_180_ = L_101_func('Symbol', '(')
		local L_181_, L_182_ = L_107_func()
		local L_183_ = L_101_func('Symbol', ')')
		local L_184_, L_185_ = L_108_func('end')
		return L_102_func{
			Type = (L_176_arg1 and 'FunctionLiteral' or 'FunctionStat');
			NameChain = L_178_;
			ArgList = L_181_;
			Body = L_184_;
			Token_Function = L_177_;
			Token_NameChainSeparator = L_179_;
			Token_OpenParen = L_180_;
			Token_ArgCommaList = L_182_;
			Token_CloseParen = L_183_;
			Token_End = L_185_;
			GetFirstToken = function(L_186_arg1)
				return L_186_arg1.Token_Function
			end;
			GetLastToken = function(L_187_arg1)
				return L_187_arg1.Token_End
			end;
		}
	end
	local function L_110_func()
		local L_188_ = L_95_func()
		if L_188_.Source == '(' then
			local L_189_ = L_94_func()
			local L_190_ = {}
			local L_191_ = {}
			while L_95_func().Source ~= ')' do
				table.insert(L_190_, L_104_())
				if L_95_func().Source == ',' then
					table.insert(L_191_, L_94_func())
				else
					break
				end
			end
			local L_192_ = L_101_func('Symbol', ')')
			return L_102_func{
				CallType = 'ArgCall';
				ArgList = L_190_;
				Token_CommaList = L_191_;
				Token_OpenParen = L_189_;
				Token_CloseParen = L_192_;
				GetFirstToken = function(L_193_arg1)
					return L_193_arg1.Token_OpenParen
				end;
				GetLastToken = function(L_194_arg1)
					return L_194_arg1.Token_CloseParen
				end;
			}
		elseif L_188_.Source == '{' then
			return L_102_func{
				CallType = 'TableCall';
				TableExpr = L_104_();
				GetFirstToken = function(L_195_arg1)
					return L_195_arg1.TableExpr:GetFirstToken()
				end;
				GetLastToken = function(L_196_arg1)
					return L_196_arg1.TableExpr:GetLastToken()
				end;
			}
		elseif L_188_.Type == 'String' then
			return L_102_func{
				CallType = 'StringCall';
				Token = L_94_func();
				GetFirstToken = function(L_197_arg1)
					return L_197_arg1.Token
				end;
				GetLastToken = function(L_198_arg1)
					return L_198_arg1.Token
				end;
			}
		else
			error("Function arguments expected.")
		end
	end
	local function L_111_func()
		local L_199_ = L_106_func()
		assert(L_199_, "nil prefixexpr")
		while true do
			local L_200_ = L_95_func()
			if L_200_.Source == '.' then
				local L_201_ = L_94_func()
				local L_202_ = L_101_func('Ident')
				L_199_ = L_102_func{
					Type = 'FieldExpr';
					Base = L_199_;
					Field = L_202_;
					Token_Dot = L_201_;
					GetFirstToken = function(L_203_arg1)
						return L_203_arg1.Base:GetFirstToken()
					end;
					GetLastToken = function(L_204_arg1)
						return L_204_arg1.Field
					end;
				}
			elseif L_200_.Source == ':' then
				local L_205_ = L_94_func()
				local L_206_ = L_101_func('Ident')
				local L_207_ = L_110_func()
				L_199_ = L_102_func{
					Type = 'MethodExpr';
					Base = L_199_;
					Method = L_206_;
					FunctionArguments = L_207_;
					Token_Colon = L_205_;
					GetFirstToken = function(L_208_arg1)
						return L_208_arg1.Base:GetFirstToken()
					end;
					GetLastToken = function(L_209_arg1)
						return L_209_arg1.FunctionArguments:GetLastToken()
					end;
				}
			elseif L_200_.Source == '[' then
				local L_210_ = L_94_func()
				local L_211_ = L_104_()
				local L_212_ = L_101_func('Symbol', ']')
				L_199_ = L_102_func{
					Type = 'IndexExpr';
					Base = L_199_;
					Index = L_211_;
					Token_OpenBracket = L_210_;
					Token_CloseBracket = L_212_;
					GetFirstToken = function(L_213_arg1)
						return L_213_arg1.Base:GetFirstToken()
					end;
					GetLastToken = function(L_214_arg1)
						return L_214_arg1.Token_CloseBracket
					end;
				}
			elseif L_200_.Source == '{' then
				L_199_ = L_102_func{
					Type = 'CallExpr';
					Base = L_199_;
					FunctionArguments = L_110_func();
					GetFirstToken = function(L_215_arg1)
						return L_215_arg1.Base:GetFirstToken()
					end;
					GetLastToken = function(L_216_arg1)
						return L_216_arg1.FunctionArguments:GetLastToken()
					end;
				}
			elseif L_200_.Source == '(' then
				L_199_ = L_102_func{
					Type = 'CallExpr';
					Base = L_199_;
					FunctionArguments = L_110_func();
					GetFirstToken = function(L_217_arg1)
						return L_217_arg1.Base:GetFirstToken()
					end;
					GetLastToken = function(L_218_arg1)
						return L_218_arg1.FunctionArguments:GetLastToken()
					end;
				}
			else
				return L_199_
			end
		end
	end
	local function L_112_func()
		local L_219_ = L_95_func()
		if L_219_.Type == 'Number' then
			return L_102_func{
				Type = 'NumberLiteral';
				Token = L_94_func();
				GetFirstToken = function(L_220_arg1)
					return L_220_arg1.Token
				end;
				GetLastToken = function(L_221_arg1)
					return L_221_arg1.Token
				end;
			}
		elseif L_219_.Type == 'String' then
			return L_102_func{
				Type = 'StringLiteral';
				Token = L_94_func();
				GetFirstToken = function(L_222_arg1)
					return L_222_arg1.Token
				end;
				GetLastToken = function(L_223_arg1)
					return L_223_arg1.Token
				end;
			}
		elseif L_219_.Source == 'nil' then
			return L_102_func{
				Type = 'NilLiteral';
				Token = L_94_func();
				GetFirstToken = function(L_224_arg1)
					return L_224_arg1.Token
				end;
				GetLastToken = function(L_225_arg1)
					return L_225_arg1.Token
				end;
			}
		elseif L_219_.Source == 'true' or L_219_.Source == 'false' then
			return L_102_func{
				Type = 'BooleanLiteral';
				Token = L_94_func();
				GetFirstToken = function(L_226_arg1)
					return L_226_arg1.Token
				end;
				GetLastToken = function(L_227_arg1)
					return L_227_arg1.Token
				end;
			}
		elseif L_219_.Source == '...' then
			return L_102_func{
				Type = 'VargLiteral';
				Token = L_94_func();
				GetFirstToken = function(L_228_arg1)
					return L_228_arg1.Token
				end;
				GetLastToken = function(L_229_arg1)
					return L_229_arg1.Token
				end;
			}
		elseif L_219_.Source == '{' then
			return G_7()
		elseif L_219_.Source == 'function' then
			return L_109_func(true)
		else
			return L_111_func()
		end
	end
	local function L_113_func(L_230_arg1)
		local L_231_
		if L_99_func() then
			local L_232_ = L_94_func()
			local L_233_ = L_113_func(L_16_)
			L_231_ = L_102_func{
				Type = 'UnopExpr';
				Token_Op = L_232_;
				Rhs = L_233_;
				GetFirstToken = function(L_234_arg1)
					return L_234_arg1.Token_Op
				end;
				GetLastToken = function(L_235_arg1)
					return L_235_arg1.Rhs:GetLastToken()
				end;
			}
		else
			L_231_ = L_112_func()
			assert(L_231_, "nil simpleexpr")
		end
		while L_100_func() and L_15_[L_95_func().Source][1] > L_230_arg1 do
			local L_236_ = L_94_func()
			local L_237_ = L_113_func(L_15_[L_236_.Source][2])
			assert(L_237_, "RhsNeeded")
			L_231_ = L_102_func{
				Type = 'BinopExpr';
				Lhs = L_231_;
				Rhs = L_237_;
				Token_Op = L_236_;
				GetFirstToken = function(L_238_arg1)
					return L_238_arg1.Lhs:GetFirstToken()
				end;
				GetLastToken = function(L_239_arg1)
					return L_239_arg1.Rhs:GetLastToken()
				end;
			}
		end
		return L_231_
	end
	L_104_ = function()
		return L_113_func(0)
	end
	local function L_114_func()
		local L_240_ = L_111_func()
		if L_240_.Type == 'MethodExpr' or L_240_.Type == 'CallExpr' then
			return L_102_func{
				Type = 'CallExprStat';
				Expression = L_240_;
				GetFirstToken = function(L_241_arg1)
					return L_241_arg1.Expression:GetFirstToken()
				end;
				GetLastToken = function(L_242_arg1)
					return L_242_arg1.Expression:GetLastToken()
				end;
			}
		else
			local L_243_ = {
				L_240_
			}
			local L_244_ = {}
			while L_95_func().Source == ',' do
				table.insert(L_244_, L_94_func())
				local L_248_ = L_111_func()
				if L_248_.Type == 'MethodExpr' or L_248_.Type == 'CallExpr' then
					error("Bad left hand side of assignment")
				end
				table.insert(L_243_, L_248_)
			end
			local L_245_ = L_101_func('Symbol', '=')
			local L_246_ = {
				L_104_()
			}
			local L_247_ = {}
			while L_95_func().Source == ',' do
				table.insert(L_247_, L_94_func())
				table.insert(L_246_, L_104_())
			end
			return L_102_func{
				Type = 'AssignmentStat';
				Rhs = L_246_;
				Lhs = L_243_;
				Token_Equals = L_245_;
				Token_LhsSeparatorList = L_244_;
				Token_RhsSeparatorList = L_247_;
				GetFirstToken = function(L_249_arg1)
					return L_249_arg1.Lhs[1]:GetFirstToken()
				end;
				GetLastToken = function(L_250_arg1)
					return L_250_arg1.Rhs[#L_250_arg1.Rhs]:GetLastToken()
				end;
			}
		end
	end
	local function L_115_func()
		local L_251_ = L_94_func()
		local L_252_ = L_104_()
		local L_253_ = L_101_func('Keyword', 'then')
		local L_254_ = L_103_()
		local L_255_ = {}
		while L_95_func().Source == 'elseif' or L_95_func().Source == 'else' do
			local L_257_ = L_94_func()
			local L_258_, L_259_
			if L_257_.Source == 'elseif' then
				L_258_ = L_104_()
				L_259_ = L_101_func('Keyword', 'then')
			end
			local L_260_ = L_103_()
			table.insert(L_255_, {
				Condition = L_258_;
				Body = L_260_;
				ClauseType = L_257_.Source;
				Token = L_257_;
				Token_Then = L_259_;
			})
			if L_257_.Source == 'else' then
				break
			end
		end
		local L_256_ = L_101_func('Keyword', 'end')
		return L_102_func{
			Type = 'IfStat';
			Condition = L_252_;
			Body = L_254_;
			ElseClauseList = L_255_;
			Token_If = L_251_;
			Token_Then = L_253_;
			Token_End = L_256_;
			GetFirstToken = function(L_261_arg1)
				return L_261_arg1.Token_If
			end;
			GetLastToken = function(L_262_arg1)
				return L_262_arg1.Token_End
			end;
		}
	end
	local function L_116_func()
		local L_263_ = L_94_func()
		local L_264_, L_265_ = L_108_func('end')
		return L_102_func{
			Type = 'DoStat';
			Body = L_264_;
			Token_Do = L_263_;
			Token_End = L_265_;
			GetFirstToken = function(L_266_arg1)
				return L_266_arg1.Token_Do
			end;
			GetLastToken = function(L_267_arg1)
				return L_267_arg1.Token_End
			end;
		}
	end
	local function L_117_func()
		local L_268_ = L_94_func()
		local L_269_ = L_104_()
		local L_270_ = L_101_func('Keyword', 'do')
		local L_271_, L_272_ = L_108_func('end')
		return L_102_func{
			Type = 'WhileStat';
			Condition = L_269_;
			Body = L_271_;
			Token_While = L_268_;
			Token_Do = L_270_;
			Token_End = L_272_;
			GetFirstToken = function(L_273_arg1)
				return L_273_arg1.Token_While
			end;
			GetLastToken = function(L_274_arg1)
				return L_274_arg1.Token_End
			end;
		}
	end
	local function L_118_func()
		local L_275_ = L_94_func()
		local L_276_, L_277_ = L_107_func()
		local L_278_ = {}
		if L_95_func().Source == '=' then
			local L_279_ = L_94_func()
			local L_280_, L_281_ = L_105_func()
			if #L_280_ < 2 or #L_280_ > 3 then
				error("expected 2 or 3 values for range bounds")
			end
			local L_282_ = L_101_func('Keyword', 'do')
			local L_283_, L_284_ = L_108_func('end')
			return L_102_func{
				Type = 'NumericForStat';
				VarList = L_276_;
				RangeList = L_280_;
				Body = L_283_;
				Token_For = L_275_;
				Token_VarCommaList = L_277_;
				Token_Equals = L_279_;
				Token_RangeCommaList = L_281_;
				Token_Do = L_282_;
				Token_End = L_284_;
				GetFirstToken = function(L_285_arg1)
					return L_285_arg1.Token_For
				end;
				GetLastToken = function(L_286_arg1)
					return L_286_arg1.Token_End
				end;
			}
		elseif L_95_func().Source == 'in' then
			local L_287_ = L_94_func()
			local L_288_, L_289_ = L_105_func()
			local L_290_ = L_101_func('Keyword', 'do')
			local L_291_, L_292_ = L_108_func('end')
			return L_102_func{
				Type = 'GenericForStat';
				VarList = L_276_;
				GeneratorList = L_288_;
				Body = L_291_;
				Token_For = L_275_;
				Token_VarCommaList = L_277_;
				Token_In = L_287_;
				Token_GeneratorCommaList = L_289_;
				Token_Do = L_290_;
				Token_End = L_292_;
				GetFirstToken = function(L_293_arg1)
					return L_293_arg1.Token_For
				end;
				GetLastToken = function(L_294_arg1)
					return L_294_arg1.Token_End
				end;
			}
		else
			error("`=` or in expected")
		end
	end
	local function L_119_func()
		local L_295_ = L_94_func()
		local L_296_, L_297_ = L_108_func('until')
		local L_298_ = L_104_()
		return L_102_func{
			Type = 'RepeatStat';
			Body = L_296_;
			Condition = L_298_;
			Token_Repeat = L_295_;
			Token_Until = L_297_;
			GetFirstToken = function(L_299_arg1)
				return L_299_arg1.Token_Repeat
			end;
			GetLastToken = function(L_300_arg1)
				return L_300_arg1.Condition:GetLastToken()
			end;
		}
	end
	local function L_120_func()
		local L_301_ = L_94_func()
		if L_95_func().Source == 'function' then
			local L_302_ = L_109_func(false)
			if #L_302_.NameChain > 1 then
				error(L_96_func(L_302_.Token_NameChainSeparator[1])..": `(` expected.")
			end
			return L_102_func{
				Type = 'LocalFunctionStat';
				FunctionStat = L_302_;
				Token_Local = L_301_;
				GetFirstToken = function(L_303_arg1)
					return L_303_arg1.Token_Local
				end;
				GetLastToken = function(L_304_arg1)
					return L_304_arg1.FunctionStat:GetLastToken()
				end;
			}
		elseif L_95_func().Type == 'Ident' then
			local L_305_, L_306_ = L_107_func()
			local L_307_, L_308_ = {}, {}
			local L_309_
			if L_95_func().Source == '=' then
				L_309_ = L_94_func()
				L_307_, L_308_ = L_105_func()
			end
			return L_102_func{
				Type = 'LocalVarStat';
				VarList = L_305_;
				ExprList = L_307_;
				Token_Local = L_301_;
				Token_Equals = L_309_;
				Token_VarCommaList = L_306_;
				Token_ExprCommaList = L_308_;
				GetFirstToken = function(L_310_arg1)
					return L_310_arg1.Token_Local
				end;
				GetLastToken = function(L_311_arg1)
					if #L_311_arg1.ExprList > 0 then
						return L_311_arg1.ExprList[#L_311_arg1.ExprList]:GetLastToken()
					else
						return L_311_arg1.VarList[#L_311_arg1.VarList]
					end
				end;
			}
		else
			error("`function` or ident expected")
		end
	end
	local function L_121_func()
		local L_312_ = L_94_func()
		local L_313_
		local L_314_
		if L_98_func() or L_95_func().Source == ';' then
			L_313_ = {}
			L_314_ = {}
		else
			L_313_, L_314_ = L_105_func()
		end
		return {
			Type = 'ReturnStat';
			ExprList = L_313_;
			Token_Return = L_312_;
			Token_CommaList = L_314_;
			GetFirstToken = function(L_315_arg1)
				return L_315_arg1.Token_Return
			end;
			GetLastToken = function(L_316_arg1)
				if #L_316_arg1.ExprList > 0 then
					return L_316_arg1.ExprList[#L_316_arg1.ExprList]:GetLastToken()
				else
					return L_316_arg1.Token_Return
				end
			end;
		}
	end
	local function L_122_func()
		local L_317_ = L_94_func()
		return {
			Type = 'BreakStat';
			Token_Break = L_317_;
			GetFirstToken = function(L_318_arg1)
				return L_318_arg1.Token_Break
			end;
			GetLastToken = function(L_319_arg1)
				return L_319_arg1.Token_Break
			end;
		}
	end
	local function L_123_func()
		local L_320_ = L_95_func()
		if L_320_.Source == 'if' then
			return false, L_115_func()
		elseif L_320_.Source == 'while' then
			return false, L_117_func()
		elseif L_320_.Source == 'do' then
			return false, L_116_func()
		elseif L_320_.Source == 'for' then
			return false, L_118_func()
		elseif L_320_.Source == 'repeat' then
			return false, L_119_func()
		elseif L_320_.Source == 'function' then
			return false, L_109_func(false)
		elseif L_320_.Source == 'local' then
			return false, L_120_func()
		elseif L_320_.Source == 'return' then
			return true, L_121_func()
		elseif L_320_.Source == 'break' then
			return true, L_122_func()
		else
			return false, L_114_func()
		end
	end
	L_103_ = function()
		local L_321_ = {}
		local L_322_ = {}
		local L_323_ = false
		while not L_323_ and not L_98_func() do
			local L_324_
			L_323_, L_324_ = L_123_func()
			table.insert(L_321_, L_324_)
			local L_325_ = L_95_func()
			if L_325_.Type == 'Symbol' and L_325_.Source == ';' then
				L_322_[#L_321_] = L_94_func()
			end
		end
		return {
			Type = 'StatList';
			StatementList = L_321_;
			SemicolonList = L_322_;
			GetFirstToken = function(L_326_arg1)
				if #L_326_arg1.StatementList == 0 then
					return nil
				else
					return L_326_arg1.StatementList[1]:GetFirstToken()
				end
			end;
			GetLastToken = function(L_327_arg1)
				if #L_327_arg1.StatementList == 0 then
					return nil
				elseif L_327_arg1.SemicolonList[#L_327_arg1.StatementList] then
					return L_327_arg1.SemicolonList[#L_327_arg1.StatementList]
				else
					return L_327_arg1.StatementList[#L_327_arg1.StatementList]:GetLastToken()
				end
			end;
		}
	end
	return L_103_()
end
function G_8(L_328_arg1, L_329_arg2)
	local L_330_ = G_1{
		'BinopExpr';
		'UnopExpr';
		'NumberLiteral';
		'StringLiteral';
		'NilLiteral';
		'BooleanLiteral';
		'VargLiteral';
		'FieldExpr';
		'IndexExpr';
		'MethodExpr';
		'CallExpr';
		'FunctionLiteral';
		'VariableExpr';
		'ParenExpr';
		'TableLiteral';
	}
	local L_331_ = G_1{
		'StatList';
		'BreakStat';
		'ReturnStat';
		'LocalVarStat';
		'LocalFunctionStat';
		'FunctionStat';
		'RepeatStat';
		'GenericForStat';
		'NumericForStat';
		'WhileStat';
		'DoStat';
		'IfStat';
		'CallExprStat';
		'AssignmentStat';
	}
	for L_336_forvar1, L_337_forvar2 in pairs(L_329_arg2) do
		if not L_331_[L_336_forvar1] and not L_330_[L_336_forvar1] then
			error("Invalid visitor target: `"..L_336_forvar1.."`")
		end
	end
	local function L_332_func(L_338_arg1)
		local L_339_ = L_329_arg2[L_338_arg1.Type]
		if type(L_339_) == 'function' then
			return L_339_(L_338_arg1)
		elseif L_339_ and L_339_.Pre then
			return L_339_.Pre(L_338_arg1)
		end
	end
	local function L_333_func(L_340_arg1)
		local L_341_ = L_329_arg2[L_340_arg1.Type]
		if L_341_ and type(L_341_) == 'table' and L_341_.Post then
			return L_341_.Post(L_340_arg1)
		end
	end
	local L_334_, L_335_
	L_334_ = function(L_342_arg1)
		if L_332_func(L_342_arg1) then
			return
		end
		if L_342_arg1.Type == 'BinopExpr' then
			L_334_(L_342_arg1.Lhs)
			L_334_(L_342_arg1.Rhs)
		elseif L_342_arg1.Type == 'UnopExpr' then
			L_334_(L_342_arg1.Rhs)
		elseif L_342_arg1.Type == 'NumberLiteral' or L_342_arg1.Type == 'StringLiteral' or L_342_arg1.Type == 'NilLiteral' or L_342_arg1.Type == 'BooleanLiteral' or L_342_arg1.Type == 'VargLiteral' then
		elseif L_342_arg1.Type == 'FieldExpr' then
			L_334_(L_342_arg1.Base)
		elseif L_342_arg1.Type == 'IndexExpr' then
			L_334_(L_342_arg1.Base)
			L_334_(L_342_arg1.Index)
		elseif L_342_arg1.Type == 'MethodExpr' or L_342_arg1.Type == 'CallExpr' then
			L_334_(L_342_arg1.Base)
			if L_342_arg1.FunctionArguments.CallType == 'ArgCall' then
				for L_343_forvar1, L_344_forvar2 in pairs(L_342_arg1.FunctionArguments.ArgList) do
					L_334_(L_344_forvar2)
				end
			elseif L_342_arg1.FunctionArguments.CallType == 'TableCall' then
				L_334_(L_342_arg1.FunctionArguments.TableExpr)
			end
		elseif L_342_arg1.Type == 'FunctionLiteral' then
			L_335_(L_342_arg1.Body)
		elseif L_342_arg1.Type == 'VariableExpr' then
		elseif L_342_arg1.Type == 'ParenExpr' then
			L_334_(L_342_arg1.Expression)
		elseif L_342_arg1.Type == 'TableLiteral' then
			for L_345_forvar1, L_346_forvar2 in pairs(L_342_arg1.EntryList) do
				if L_346_forvar2.EntryType == 'Field' then
					L_334_(L_346_forvar2.Value)
				elseif L_346_forvar2.EntryType == 'Index' then
					L_334_(L_346_forvar2.Index)
					L_334_(L_346_forvar2.Value)
				elseif L_346_forvar2.EntryType == 'Value' then
					L_334_(L_346_forvar2.Value)
				else
					assert(false, "unreachable")
				end
			end
		else
			assert(false, "unreachable, type: "..L_342_arg1.Type..":"..G_4(L_342_arg1))
		end
		L_333_func(L_342_arg1)
	end
	L_335_ = function(L_347_arg1)
		if L_332_func(L_347_arg1) then
			return
		end
		if L_347_arg1.Type == 'StatList' then
			for L_348_forvar1, L_349_forvar2 in pairs(L_347_arg1.StatementList) do
				L_335_(L_349_forvar2)
			end
		elseif L_347_arg1.Type == 'BreakStat' then
		elseif L_347_arg1.Type == 'ReturnStat' then
			for L_350_forvar1, L_351_forvar2 in pairs(L_347_arg1.ExprList) do
				L_334_(L_351_forvar2)
			end
		elseif L_347_arg1.Type == 'LocalVarStat' then
			if L_347_arg1.Token_Equals then
				for L_352_forvar1, L_353_forvar2 in pairs(L_347_arg1.ExprList) do
					L_334_(L_353_forvar2)
				end
			end
		elseif L_347_arg1.Type == 'LocalFunctionStat' then
			L_335_(L_347_arg1.FunctionStat.Body)
		elseif L_347_arg1.Type == 'FunctionStat' then
			L_335_(L_347_arg1.Body)
		elseif L_347_arg1.Type == 'RepeatStat' then
			L_335_(L_347_arg1.Body)
			L_334_(L_347_arg1.Condition)
		elseif L_347_arg1.Type == 'GenericForStat' then
			for L_354_forvar1, L_355_forvar2 in pairs(L_347_arg1.GeneratorList) do
				L_334_(L_355_forvar2)
			end
			L_335_(L_347_arg1.Body)
		elseif L_347_arg1.Type == 'NumericForStat' then
			for L_356_forvar1, L_357_forvar2 in pairs(L_347_arg1.RangeList) do
				L_334_(L_357_forvar2)
			end
			L_335_(L_347_arg1.Body)
		elseif L_347_arg1.Type == 'WhileStat' then
			L_334_(L_347_arg1.Condition)
			L_335_(L_347_arg1.Body)
		elseif L_347_arg1.Type == 'DoStat' then
			L_335_(L_347_arg1.Body)
		elseif L_347_arg1.Type == 'IfStat' then
			L_334_(L_347_arg1.Condition)
			L_335_(L_347_arg1.Body)
			for L_358_forvar1, L_359_forvar2 in pairs(L_347_arg1.ElseClauseList) do
				if L_359_forvar2.Condition then
					L_334_(L_359_forvar2.Condition)
				end
				L_335_(L_359_forvar2.Body)
			end
		elseif L_347_arg1.Type == 'CallExprStat' then
			L_334_(L_347_arg1.Expression)
		elseif L_347_arg1.Type == 'AssignmentStat' then
			for L_360_forvar1, L_361_forvar2 in pairs(L_347_arg1.Lhs) do
				L_334_(L_361_forvar2)
			end
			for L_362_forvar1, L_363_forvar2 in pairs(L_347_arg1.Rhs) do
				L_334_(L_363_forvar2)
			end
		else
			assert(false, "unreachable")
		end
		L_333_func(L_347_arg1)
	end
	if L_331_[L_328_arg1.Type] then
		L_335_(L_328_arg1)
	else
		L_334_(L_328_arg1)
	end
end
function G_9(L_364_arg1)
	local L_365_ = {}
	local L_366_ = nil
	local L_367_ = 0
	local function L_368_func()
		L_367_ = L_367_ + 1
		return L_367_
	end
	local function L_369_func()
		L_366_ = {
			ParentScope = L_366_;
			ChildScopeList = {};
			VariableList = {};
			BeginLocation = L_368_func();
		}
		if L_366_.ParentScope then
			L_366_.Depth = L_366_.ParentScope.Depth + 1
			table.insert(L_366_.ParentScope.ChildScopeList, L_366_)
		else
			L_366_.Depth = 1
		end
		function L_366_:GetVar(L_377_arg1)
			for L_378_forvar1, L_379_forvar2 in pairs(self.VariableList) do
				if L_379_forvar2.Name == L_377_arg1 then
					return L_379_forvar2
				end
			end
			if self.ParentScope then
				return self.ParentScope:GetVar(L_377_arg1)
			else
				for L_380_forvar1, L_381_forvar2 in pairs(L_365_) do
					if L_381_forvar2.Name == L_377_arg1 then
						return L_381_forvar2
					end
				end
			end
		end
	end
	local function L_370_func()
		local L_382_ = L_366_
		L_382_.EndLocation = L_368_func()
		for L_383_forvar1, L_384_forvar2 in pairs(L_382_.VariableList) do
			L_384_forvar2.ScopeEndLocation = L_382_.EndLocation
		end
		L_366_ = L_382_.ParentScope
		return L_382_
	end
	L_369_func()
	local function L_371_func(L_385_arg1, L_386_arg2, L_387_arg3)
		assert(L_387_arg3, "Misisng localInfo")
		assert(L_385_arg1, "Missing local var name")
		local L_388_ = {
			Type = 'Local';
			Name = L_385_arg1;
			RenameList = {
				L_386_arg2
			};
			AssignedTo = false;
			Info = L_387_arg3;
			UseCount = 0;
			Scope = L_366_;
			BeginLocation = L_368_func();
			EndLocation = L_368_func();
			ReferenceLocationList = {
				L_368_func()
			};
		}
		function L_388_:Rename(L_389_arg1)
			self.Name = L_389_arg1
			for L_390_forvar1, L_391_forvar2 in pairs(self.RenameList) do
				L_391_forvar2(L_389_arg1)
			end
		end
		function L_388_:Reference()
			self.UseCount = self.UseCount + 1
		end
		table.insert(L_366_.VariableList, L_388_)
		return L_388_
	end
	local function L_372_func(L_392_arg1)
		for L_394_forvar1, L_395_forvar2 in pairs(L_365_) do
			if L_395_forvar2.Name == L_392_arg1 then
				return L_395_forvar2
			end
		end
		local L_393_ = {
			Type = 'Global';
			Name = L_392_arg1;
			RenameList = {};
			AssignedTo = false;
			UseCount = 0;
			Scope = nil;
			BeginLocation = L_368_func();
			EndLocation = L_368_func();
			ReferenceLocationList = {};
		}
		function L_393_:Rename(L_396_arg1)
			self.Name = L_396_arg1
			for L_397_forvar1, L_398_forvar2 in pairs(self.RenameList) do
				L_398_forvar2(L_396_arg1)
			end
		end
		function L_393_:Reference()
			self.UseCount = self.UseCount + 1
		end
		table.insert(L_365_, L_393_)
		return L_393_
	end
	local function L_373_func(L_399_arg1, L_400_arg2)
		assert(L_399_arg1, "Missing var name")
		local L_401_ = L_372_func(L_399_arg1)
		table.insert(L_401_.RenameList, L_400_arg2)
		return L_401_
	end
	local function L_374_func(L_402_arg1, L_403_arg2)
		for L_404_forvar1 = #L_402_arg1.VariableList, 1, -1 do
			if L_402_arg1.VariableList[L_404_forvar1].Name == L_403_arg2 then
				return L_402_arg1.VariableList[L_404_forvar1]
			end
		end
		if L_402_arg1.ParentScope then
			local L_405_ = L_374_func(L_402_arg1.ParentScope, L_403_arg2)
			if L_405_ then
				return L_405_
			end
		end
		return nil
	end
	local function L_375_func(L_406_arg1, L_407_arg2)
		assert(L_406_arg1, "Missing var name")
		local L_408_ = L_374_func(L_366_, L_406_arg1)
		if L_408_ then
			table.insert(L_408_.RenameList, L_407_arg2)
		else
			L_408_ = L_373_func(L_406_arg1, L_407_arg2)
		end
		local L_409_ = L_368_func()
		L_408_.EndLocation = L_409_
		table.insert(L_408_.ReferenceLocationList, L_408_.EndLocation)
		return L_408_
	end
	local L_376_ = {}
	L_376_.FunctionLiteral = {
		Pre = function(L_410_arg1)
			L_369_func()
			for L_411_forvar1, L_412_forvar2 in pairs(L_410_arg1.ArgList) do
				local L_413_ = L_371_func(L_412_forvar2.Source, function(L_414_arg1)
					L_412_forvar2.Source = L_414_arg1
				end, {
					Type = 'Argument';
					Index = L_411_forvar1;
				})
			end
		end;
		Post = function(L_415_arg1)
			L_370_func()
		end;
	}
	L_376_.VariableExpr = function(L_416_arg1)
		L_416_arg1.Variable = L_375_func(L_416_arg1.Token.Source, function(L_417_arg1)
			L_416_arg1.Token.Source = L_417_arg1
		end)
	end
	L_376_.StatList = {
		Pre = function(L_418_arg1)
			L_369_func()
		end;
		Post = function(L_419_arg1)
			L_370_func()
		end;
	}
	L_376_.LocalVarStat = {
		Post = function(L_420_arg1)
			for L_421_forvar1, L_422_forvar2 in pairs(L_420_arg1.VarList) do
				L_371_func(L_422_forvar2.Source, function(L_423_arg1)
					L_420_arg1.VarList[L_421_forvar1].Source = L_423_arg1
				end, {
					Type = 'Local';
				})
			end
		end;
	}
	L_376_.LocalFunctionStat = {
		Pre = function(L_424_arg1)
			L_371_func(L_424_arg1.FunctionStat.NameChain[1].Source, function(L_425_arg1)
				L_424_arg1.FunctionStat.NameChain[1].Source = L_425_arg1
			end, {
				Type = 'LocalFunction';
			})
			L_369_func()
			for L_426_forvar1, L_427_forvar2 in pairs(L_424_arg1.FunctionStat.ArgList) do
				L_371_func(L_427_forvar2.Source, function(L_428_arg1)
					L_427_forvar2.Source = L_428_arg1
				end, {
					Type = 'Argument';
					Index = L_426_forvar1;
				})
			end
		end;
		Post = function()
			L_370_func()
		end;
	}
	L_376_.FunctionStat = {
		Pre = function(L_429_arg1)
			local L_430_ = L_429_arg1.NameChain
			local L_431_
			if #L_430_ == 1 then
				L_431_ = L_373_func(L_430_[1].Source, function(L_432_arg1)
					L_430_[1].Source = L_432_arg1
				end)
			else
				L_431_ = L_375_func(L_430_[1].Source, function(L_433_arg1)
					L_430_[1].Source = L_433_arg1
				end)
			end
			L_431_.AssignedTo = true
			L_369_func()
			for L_434_forvar1, L_435_forvar2 in pairs(L_429_arg1.ArgList) do
				L_371_func(L_435_forvar2.Source, function(L_436_arg1)
					L_435_forvar2.Source = L_436_arg1
				end, {
					Type = 'Argument';
					Index = L_434_forvar1;
				})
			end
		end;
		Post = function()
			L_370_func()
		end;
	}
	L_376_.GenericForStat = {
		Pre = function(L_437_arg1)
			for L_438_forvar1, L_439_forvar2 in pairs(L_437_arg1.GeneratorList) do
				G_8(L_439_forvar2, L_376_)
			end
			L_369_func()
			for L_440_forvar1, L_441_forvar2 in pairs(L_437_arg1.VarList) do
				L_371_func(L_441_forvar2.Source, function(L_442_arg1)
					L_441_forvar2.Source = L_442_arg1
				end, {
					Type = 'ForRange';
					Index = L_440_forvar1;
				})
			end
			G_8(L_437_arg1.Body, L_376_)
			L_370_func()
			return true
		end;
	}
	L_376_.NumericForStat = {
		Pre = function(L_443_arg1)
			for L_444_forvar1, L_445_forvar2 in pairs(L_443_arg1.RangeList) do
				G_8(L_445_forvar2, L_376_)
			end
			L_369_func()
			for L_446_forvar1, L_447_forvar2 in pairs(L_443_arg1.VarList) do
				L_371_func(L_447_forvar2.Source, function(L_448_arg1)
					L_447_forvar2.Source = L_448_arg1
				end, {
					Type = 'ForRange';
					Index = L_446_forvar1;
				})
			end
			G_8(L_443_arg1.Body, L_376_)
			L_370_func()
			return true
		end;
	}
	L_376_.AssignmentStat = {
		Post = function(L_449_arg1)
			for L_450_forvar1, L_451_forvar2 in pairs(L_449_arg1.Lhs) do
				if L_451_forvar2.Variable then
					L_451_forvar2.Variable.AssignedTo = true
				end
			end
		end;
	}
	G_8(L_364_arg1, L_376_)
	return L_365_, L_370_func()
end
function G_10(L_452_arg1)
	local L_453_, L_454_
	local function L_455_func(L_456_arg1)
		if not L_456_arg1.LeadingWhite or not L_456_arg1.Source then
			error("Bad token: "..G_4(L_456_arg1))
		end
		io.write(L_456_arg1.LeadingWhite)
		io.write(L_456_arg1.Source)
	end
	L_454_ = function(L_457_arg1)
		if L_457_arg1.Type == 'BinopExpr' then
			L_454_(L_457_arg1.Lhs)
			L_455_func(L_457_arg1.Token_Op)
			L_454_(L_457_arg1.Rhs)
		elseif L_457_arg1.Type == 'UnopExpr' then
			L_455_func(L_457_arg1.Token_Op)
			L_454_(L_457_arg1.Rhs)
		elseif L_457_arg1.Type == 'NumberLiteral' or L_457_arg1.Type == 'StringLiteral' or L_457_arg1.Type == 'NilLiteral' or L_457_arg1.Type == 'BooleanLiteral' or L_457_arg1.Type == 'VargLiteral' then
			L_455_func(L_457_arg1.Token)
		elseif L_457_arg1.Type == 'FieldExpr' then
			L_454_(L_457_arg1.Base)
			L_455_func(L_457_arg1.Token_Dot)
			L_455_func(L_457_arg1.Field)
		elseif L_457_arg1.Type == 'IndexExpr' then
			L_454_(L_457_arg1.Base)
			L_455_func(L_457_arg1.Token_OpenBracket)
			L_454_(L_457_arg1.Index)
			L_455_func(L_457_arg1.Token_CloseBracket)
		elseif L_457_arg1.Type == 'MethodExpr' or L_457_arg1.Type == 'CallExpr' then
			L_454_(L_457_arg1.Base)
			if L_457_arg1.Type == 'MethodExpr' then
				L_455_func(L_457_arg1.Token_Colon)
				L_455_func(L_457_arg1.Method)
			end
			if L_457_arg1.FunctionArguments.CallType == 'StringCall' then
				L_455_func(L_457_arg1.FunctionArguments.Token)
			elseif L_457_arg1.FunctionArguments.CallType == 'ArgCall' then
				L_455_func(L_457_arg1.FunctionArguments.Token_OpenParen)
				for L_458_forvar1, L_459_forvar2 in pairs(L_457_arg1.FunctionArguments.ArgList) do
					L_454_(L_459_forvar2)
					local L_460_ = L_457_arg1.FunctionArguments.Token_CommaList[L_458_forvar1]
					if L_460_ then
						L_455_func(L_460_)
					end
				end
				L_455_func(L_457_arg1.FunctionArguments.Token_CloseParen)
			elseif L_457_arg1.FunctionArguments.CallType == 'TableCall' then
				L_454_(L_457_arg1.FunctionArguments.TableExpr)
			end
		elseif L_457_arg1.Type == 'FunctionLiteral' then
			L_455_func(L_457_arg1.Token_Function)
			L_455_func(L_457_arg1.Token_OpenParen)
			for L_461_forvar1, L_462_forvar2 in pairs(L_457_arg1.ArgList) do
				L_455_func(L_462_forvar2)
				local L_463_ = L_457_arg1.Token_ArgCommaList[L_461_forvar1]
				if L_463_ then
					L_455_func(L_463_)
				end
			end
			L_455_func(L_457_arg1.Token_CloseParen)
			L_453_(L_457_arg1.Body)
			L_455_func(L_457_arg1.Token_End)
		elseif L_457_arg1.Type == 'VariableExpr' then
			L_455_func(L_457_arg1.Token)
		elseif L_457_arg1.Type == 'ParenExpr' then
			L_455_func(L_457_arg1.Token_OpenParen)
			L_454_(L_457_arg1.Expression)
			L_455_func(L_457_arg1.Token_CloseParen)
		elseif L_457_arg1.Type == 'TableLiteral' then
			L_455_func(L_457_arg1.Token_OpenBrace)
			for L_464_forvar1, L_465_forvar2 in pairs(L_457_arg1.EntryList) do
				if L_465_forvar2.EntryType == 'Field' then
					L_455_func(L_465_forvar2.Field)
					L_455_func(L_465_forvar2.Token_Equals)
					L_454_(L_465_forvar2.Value)
				elseif L_465_forvar2.EntryType == 'Index' then
					L_455_func(L_465_forvar2.Token_OpenBracket)
					L_454_(L_465_forvar2.Index)
					L_455_func(L_465_forvar2.Token_CloseBracket)
					L_455_func(L_465_forvar2.Token_Equals)
					L_454_(L_465_forvar2.Value)
				elseif L_465_forvar2.EntryType == 'Value' then
					L_454_(L_465_forvar2.Value)
				else
					assert(false, "unreachable")
				end
				local L_466_ = L_457_arg1.Token_SeparatorList[L_464_forvar1]
				if L_466_ then
					L_455_func(L_466_)
				end
			end
			L_455_func(L_457_arg1.Token_CloseBrace)
		else
			assert(false, "unreachable, type: "..L_457_arg1.Type..":"..G_4(L_457_arg1))
		end
	end
	L_453_ = function(L_467_arg1)
		if L_467_arg1.Type == 'StatList' then
			for L_468_forvar1, L_469_forvar2 in pairs(L_467_arg1.StatementList) do
				L_453_(L_469_forvar2)
				if L_467_arg1.SemicolonList[L_468_forvar1] then
					L_455_func(L_467_arg1.SemicolonList[L_468_forvar1])
				end
			end
		elseif L_467_arg1.Type == 'BreakStat' then
			L_455_func(L_467_arg1.Token_Break)
		elseif L_467_arg1.Type == 'ReturnStat' then
			L_455_func(L_467_arg1.Token_Return)
			for L_470_forvar1, L_471_forvar2 in pairs(L_467_arg1.ExprList) do
				L_454_(L_471_forvar2)
				if L_467_arg1.Token_CommaList[L_470_forvar1] then
					L_455_func(L_467_arg1.Token_CommaList[L_470_forvar1])
				end
			end
		elseif L_467_arg1.Type == 'LocalVarStat' then
			L_455_func(L_467_arg1.Token_Local)
			for L_472_forvar1, L_473_forvar2 in pairs(L_467_arg1.VarList) do
				L_455_func(L_473_forvar2)
				local L_474_ = L_467_arg1.Token_VarCommaList[L_472_forvar1]
				if L_474_ then
					L_455_func(L_474_)
				end
			end
			if L_467_arg1.Token_Equals then
				L_455_func(L_467_arg1.Token_Equals)
				for L_475_forvar1, L_476_forvar2 in pairs(L_467_arg1.ExprList) do
					L_454_(L_476_forvar2)
					local L_477_ = L_467_arg1.Token_ExprCommaList[L_475_forvar1]
					if L_477_ then
						L_455_func(L_477_)
					end
				end
			end
		elseif L_467_arg1.Type == 'LocalFunctionStat' then
			L_455_func(L_467_arg1.Token_Local)
			L_455_func(L_467_arg1.FunctionStat.Token_Function)
			L_455_func(L_467_arg1.FunctionStat.NameChain[1])
			L_455_func(L_467_arg1.FunctionStat.Token_OpenParen)
			for L_478_forvar1, L_479_forvar2 in pairs(L_467_arg1.FunctionStat.ArgList) do
				L_455_func(L_479_forvar2)
				local L_480_ = L_467_arg1.FunctionStat.Token_ArgCommaList[L_478_forvar1]
				if L_480_ then
					L_455_func(L_480_)
				end
			end
			L_455_func(L_467_arg1.FunctionStat.Token_CloseParen)
			L_453_(L_467_arg1.FunctionStat.Body)
			L_455_func(L_467_arg1.FunctionStat.Token_End)
		elseif L_467_arg1.Type == 'FunctionStat' then
			L_455_func(L_467_arg1.Token_Function)
			for L_481_forvar1, L_482_forvar2 in pairs(L_467_arg1.NameChain) do
				L_455_func(L_482_forvar2)
				local L_483_ = L_467_arg1.Token_NameChainSeparator[L_481_forvar1]
				if L_483_ then
					L_455_func(L_483_)
				end
			end
			L_455_func(L_467_arg1.Token_OpenParen)
			for L_484_forvar1, L_485_forvar2 in pairs(L_467_arg1.ArgList) do
				L_455_func(L_485_forvar2)
				local L_486_ = L_467_arg1.Token_ArgCommaList[L_484_forvar1]
				if L_486_ then
					L_455_func(L_486_)
				end
			end
			L_455_func(L_467_arg1.Token_CloseParen)
			L_453_(L_467_arg1.Body)
			L_455_func(L_467_arg1.Token_End)
		elseif L_467_arg1.Type == 'RepeatStat' then
			L_455_func(L_467_arg1.Token_Repeat)
			L_453_(L_467_arg1.Body)
			L_455_func(L_467_arg1.Token_Until)
			L_454_(L_467_arg1.Condition)
		elseif L_467_arg1.Type == 'GenericForStat' then
			L_455_func(L_467_arg1.Token_For)
			for L_487_forvar1, L_488_forvar2 in pairs(L_467_arg1.VarList) do
				L_455_func(L_488_forvar2)
				local L_489_ = L_467_arg1.Token_VarCommaList[L_487_forvar1]
				if L_489_ then
					L_455_func(L_489_)
				end
			end
			L_455_func(L_467_arg1.Token_In)
			for L_490_forvar1, L_491_forvar2 in pairs(L_467_arg1.GeneratorList) do
				L_454_(L_491_forvar2)
				local L_492_ = L_467_arg1.Token_GeneratorCommaList[L_490_forvar1]
				if L_492_ then
					L_455_func(L_492_)
				end
			end
			L_455_func(L_467_arg1.Token_Do)
			L_453_(L_467_arg1.Body)
			L_455_func(L_467_arg1.Token_End)
		elseif L_467_arg1.Type == 'NumericForStat' then
			L_455_func(L_467_arg1.Token_For)
			for L_493_forvar1, L_494_forvar2 in pairs(L_467_arg1.VarList) do
				L_455_func(L_494_forvar2)
				local L_495_ = L_467_arg1.Token_VarCommaList[L_493_forvar1]
				if L_495_ then
					L_455_func(L_495_)
				end
			end
			L_455_func(L_467_arg1.Token_Equals)
			for L_496_forvar1, L_497_forvar2 in pairs(L_467_arg1.RangeList) do
				L_454_(L_497_forvar2)
				local L_498_ = L_467_arg1.Token_RangeCommaList[L_496_forvar1]
				if L_498_ then
					L_455_func(L_498_)
				end
			end
			L_455_func(L_467_arg1.Token_Do)
			L_453_(L_467_arg1.Body)
			L_455_func(L_467_arg1.Token_End)
		elseif L_467_arg1.Type == 'WhileStat' then
			L_455_func(L_467_arg1.Token_While)
			L_454_(L_467_arg1.Condition)
			L_455_func(L_467_arg1.Token_Do)
			L_453_(L_467_arg1.Body)
			L_455_func(L_467_arg1.Token_End)
		elseif L_467_arg1.Type == 'DoStat' then
			L_455_func(L_467_arg1.Token_Do)
			L_453_(L_467_arg1.Body)
			L_455_func(L_467_arg1.Token_End)
		elseif L_467_arg1.Type == 'IfStat' then
			L_455_func(L_467_arg1.Token_If)
			L_454_(L_467_arg1.Condition)
			L_455_func(L_467_arg1.Token_Then)
			L_453_(L_467_arg1.Body)
			for L_499_forvar1, L_500_forvar2 in pairs(L_467_arg1.ElseClauseList) do
				L_455_func(L_500_forvar2.Token)
				if L_500_forvar2.Condition then
					L_454_(L_500_forvar2.Condition)
					L_455_func(L_500_forvar2.Token_Then)
				end
				L_453_(L_500_forvar2.Body)
			end
			L_455_func(L_467_arg1.Token_End)
		elseif L_467_arg1.Type == 'CallExprStat' then
			L_454_(L_467_arg1.Expression)
		elseif L_467_arg1.Type == 'AssignmentStat' then
			for L_501_forvar1, L_502_forvar2 in pairs(L_467_arg1.Lhs) do
				L_454_(L_502_forvar2)
				local L_503_ = L_467_arg1.Token_LhsSeparatorList[L_501_forvar1]
				if L_503_ then
					L_455_func(L_503_)
				end
			end
			L_455_func(L_467_arg1.Token_Equals)
			for L_504_forvar1, L_505_forvar2 in pairs(L_467_arg1.Rhs) do
				L_454_(L_505_forvar2)
				local L_506_ = L_467_arg1.Token_RhsSeparatorList[L_504_forvar1]
				if L_506_ then
					L_455_func(L_506_)
				end
			end
		else
			assert(false, "unreachable")
		end
	end
	L_453_(L_452_arg1)
end
local function L_17_func(L_507_arg1)
	local L_508_, L_509_
	local L_510_ = 0
	local function L_511_func(L_518_arg1)
		local L_519_ = '\n'..('\t'):rep(L_510_)
		if L_518_arg1.LeadingWhite == '' or (L_518_arg1.LeadingWhite:sub(-#L_519_, -1) ~= L_519_) then
			L_518_arg1.LeadingWhite = L_518_arg1.LeadingWhite:gsub("\n?[\t ]*$", "")
			L_518_arg1.LeadingWhite = L_518_arg1.LeadingWhite..L_519_
		end
	end
	local function L_512_func()
		L_510_ = L_510_ + 1
	end
	local function L_513_func()
		L_510_ = L_510_ - 1
		assert(L_510_ >= 0, "Undented too far")
	end
	local function L_514_func(L_520_arg1)
		if #L_520_arg1.LeadingWhite > 0 then
			return L_520_arg1.LeadingWhite:sub(1, 1)
		else
			return L_520_arg1.Source:sub(1, 1)
		end
	end
	local function L_515_func(L_521_arg1)
		if not L_1_[L_514_func(L_521_arg1)] then
			L_521_arg1.LeadingWhite = ' '..L_521_arg1.LeadingWhite
		end
	end
	local function L_516_func(L_522_arg1)
		L_515_func(L_522_arg1:GetFirstToken())
	end
	local function L_517_func(L_523_arg1, L_524_arg2, L_525_arg3)
		L_512_func()
		L_508_(L_524_arg2)
		L_513_func()
		L_511_func(L_525_arg3)
	end
	L_509_ = function(L_526_arg1)
		if L_526_arg1.Type == 'BinopExpr' then
			L_509_(L_526_arg1.Lhs)
			L_509_(L_526_arg1.Rhs)
			if L_526_arg1.Token_Op.Source == '..' then
			else
				L_516_func(L_526_arg1.Rhs)
				L_515_func(L_526_arg1.Token_Op)
			end
		elseif L_526_arg1.Type == 'UnopExpr' then
			L_509_(L_526_arg1.Rhs)
		elseif L_526_arg1.Type == 'NumberLiteral' or L_526_arg1.Type == 'StringLiteral' or L_526_arg1.Type == 'NilLiteral' or L_526_arg1.Type == 'BooleanLiteral' or L_526_arg1.Type == 'VargLiteral' then
		elseif L_526_arg1.Type == 'FieldExpr' then
			L_509_(L_526_arg1.Base)
		elseif L_526_arg1.Type == 'IndexExpr' then
			L_509_(L_526_arg1.Base)
			L_509_(L_526_arg1.Index)
		elseif L_526_arg1.Type == 'MethodExpr' or L_526_arg1.Type == 'CallExpr' then
			L_509_(L_526_arg1.Base)
			if L_526_arg1.Type == 'MethodExpr' then
			end
			if L_526_arg1.FunctionArguments.CallType == 'StringCall' then
			elseif L_526_arg1.FunctionArguments.CallType == 'ArgCall' then
				for L_527_forvar1, L_528_forvar2 in pairs(L_526_arg1.FunctionArguments.ArgList) do
					L_509_(L_528_forvar2)
					if L_527_forvar1 > 1 then
						L_516_func(L_528_forvar2)
					end
					local L_529_ = L_526_arg1.FunctionArguments.Token_CommaList[L_527_forvar1]
					if L_529_ then
					end
				end
			elseif L_526_arg1.FunctionArguments.CallType == 'TableCall' then
				L_509_(L_526_arg1.FunctionArguments.TableExpr)
			end
		elseif L_526_arg1.Type == 'FunctionLiteral' then
			for L_530_forvar1, L_531_forvar2 in pairs(L_526_arg1.ArgList) do
				if L_530_forvar1 > 1 then
					L_515_func(L_531_forvar2)
				end
				local L_532_ = L_526_arg1.Token_ArgCommaList[L_530_forvar1]
				if L_532_ then
				end
			end
			L_517_func(L_526_arg1.Token_CloseParen, L_526_arg1.Body, L_526_arg1.Token_End)
		elseif L_526_arg1.Type == 'VariableExpr' then
		elseif L_526_arg1.Type == 'ParenExpr' then
			L_509_(L_526_arg1.Expression)
		elseif L_526_arg1.Type == 'TableLiteral' then
			if #L_526_arg1.EntryList == 0 then
			else
				L_512_func()
				for L_533_forvar1, L_534_forvar2 in pairs(L_526_arg1.EntryList) do
					if L_534_forvar2.EntryType == 'Field' then
						L_511_func(L_534_forvar2.Field)
						L_515_func(L_534_forvar2.Token_Equals)
						L_509_(L_534_forvar2.Value)
						L_516_func(L_534_forvar2.Value)
					elseif L_534_forvar2.EntryType == 'Index' then
						L_511_func(L_534_forvar2.Token_OpenBracket)
						L_509_(L_534_forvar2.Index)
						L_515_func(L_534_forvar2.Token_Equals)
						L_509_(L_534_forvar2.Value)
						L_516_func(L_534_forvar2.Value)
					elseif L_534_forvar2.EntryType == 'Value' then
						L_509_(L_534_forvar2.Value)
						L_511_func(L_534_forvar2.Value:GetFirstToken())
					else
						assert(false, "unreachable")
					end
					local L_535_ = L_526_arg1.Token_SeparatorList[L_533_forvar1]
					if L_535_ then
					end
				end
				L_513_func()
				L_511_func(L_526_arg1.Token_CloseBrace)
			end
		else
			assert(false, "unreachable, type: "..L_526_arg1.Type..":"..G_4(L_526_arg1))
		end
	end
	L_508_ = function(L_536_arg1)
		if L_536_arg1.Type == 'StatList' then
			for L_537_forvar1, L_538_forvar2 in pairs(L_536_arg1.StatementList) do
				L_508_(L_538_forvar2)
				L_511_func(L_538_forvar2:GetFirstToken())
			end
		elseif L_536_arg1.Type == 'BreakStat' then
		elseif L_536_arg1.Type == 'ReturnStat' then
			for L_539_forvar1, L_540_forvar2 in pairs(L_536_arg1.ExprList) do
				L_509_(L_540_forvar2)
				L_516_func(L_540_forvar2)
				if L_536_arg1.Token_CommaList[L_539_forvar1] then
				end
			end
		elseif L_536_arg1.Type == 'LocalVarStat' then
			for L_541_forvar1, L_542_forvar2 in pairs(L_536_arg1.VarList) do
				L_515_func(L_542_forvar2)
				local L_543_ = L_536_arg1.Token_VarCommaList[L_541_forvar1]
				if L_543_ then
				end
			end
			if L_536_arg1.Token_Equals then
				L_515_func(L_536_arg1.Token_Equals)
				for L_544_forvar1, L_545_forvar2 in pairs(L_536_arg1.ExprList) do
					L_509_(L_545_forvar2)
					L_516_func(L_545_forvar2)
					local L_546_ = L_536_arg1.Token_ExprCommaList[L_544_forvar1]
					if L_546_ then
					end
				end
			end
		elseif L_536_arg1.Type == 'LocalFunctionStat' then
			L_515_func(L_536_arg1.FunctionStat.Token_Function)
			L_515_func(L_536_arg1.FunctionStat.NameChain[1])
			for L_547_forvar1, L_548_forvar2 in pairs(L_536_arg1.FunctionStat.ArgList) do
				if L_547_forvar1 > 1 then
					L_515_func(L_548_forvar2)
				end
				local L_549_ = L_536_arg1.FunctionStat.Token_ArgCommaList[L_547_forvar1]
				if L_549_ then
				end
			end
			L_517_func(L_536_arg1.FunctionStat.Token_CloseParen, L_536_arg1.FunctionStat.Body, L_536_arg1.FunctionStat.Token_End)
		elseif L_536_arg1.Type == 'FunctionStat' then
			for L_550_forvar1, L_551_forvar2 in pairs(L_536_arg1.NameChain) do
				if L_550_forvar1 == 1 then
					L_515_func(L_551_forvar2)
				end
				local L_552_ = L_536_arg1.Token_NameChainSeparator[L_550_forvar1]
				if L_552_ then
				end
			end
			for L_553_forvar1, L_554_forvar2 in pairs(L_536_arg1.ArgList) do
				if L_553_forvar1 > 1 then
					L_515_func(L_554_forvar2)
				end
				local L_555_ = L_536_arg1.Token_ArgCommaList[L_553_forvar1]
				if L_555_ then
				end
			end
			L_517_func(L_536_arg1.Token_CloseParen, L_536_arg1.Body, L_536_arg1.Token_End)
		elseif L_536_arg1.Type == 'RepeatStat' then
			L_517_func(L_536_arg1.Token_Repeat, L_536_arg1.Body, L_536_arg1.Token_Until)
			L_509_(L_536_arg1.Condition)
			L_516_func(L_536_arg1.Condition)
		elseif L_536_arg1.Type == 'GenericForStat' then
			for L_556_forvar1, L_557_forvar2 in pairs(L_536_arg1.VarList) do
				L_515_func(L_557_forvar2)
				local L_558_ = L_536_arg1.Token_VarCommaList[L_556_forvar1]
				if L_558_ then
				end
			end
			L_515_func(L_536_arg1.Token_In)
			for L_559_forvar1, L_560_forvar2 in pairs(L_536_arg1.GeneratorList) do
				L_509_(L_560_forvar2)
				L_516_func(L_560_forvar2)
				local L_561_ = L_536_arg1.Token_GeneratorCommaList[L_559_forvar1]
				if L_561_ then
				end
			end
			L_515_func(L_536_arg1.Token_Do)
			L_517_func(L_536_arg1.Token_Do, L_536_arg1.Body, L_536_arg1.Token_End)
		elseif L_536_arg1.Type == 'NumericForStat' then
			for L_562_forvar1, L_563_forvar2 in pairs(L_536_arg1.VarList) do
				L_515_func(L_563_forvar2)
				local L_564_ = L_536_arg1.Token_VarCommaList[L_562_forvar1]
				if L_564_ then
				end
			end
			L_515_func(L_536_arg1.Token_Equals)
			for L_565_forvar1, L_566_forvar2 in pairs(L_536_arg1.RangeList) do
				L_509_(L_566_forvar2)
				L_516_func(L_566_forvar2)
				local L_567_ = L_536_arg1.Token_RangeCommaList[L_565_forvar1]
				if L_567_ then
				end
			end
			L_515_func(L_536_arg1.Token_Do)
			L_517_func(L_536_arg1.Token_Do, L_536_arg1.Body, L_536_arg1.Token_End)
		elseif L_536_arg1.Type == 'WhileStat' then
			L_509_(L_536_arg1.Condition)
			L_516_func(L_536_arg1.Condition)
			L_515_func(L_536_arg1.Token_Do)
			L_517_func(L_536_arg1.Token_Do, L_536_arg1.Body, L_536_arg1.Token_End)
		elseif L_536_arg1.Type == 'DoStat' then
			L_517_func(L_536_arg1.Token_Do, L_536_arg1.Body, L_536_arg1.Token_End)
		elseif L_536_arg1.Type == 'IfStat' then
			L_509_(L_536_arg1.Condition)
			L_516_func(L_536_arg1.Condition)
			L_515_func(L_536_arg1.Token_Then)
			local L_568_ = L_536_arg1.Token_Then
			local L_569_ = L_536_arg1.Body
			for L_570_forvar1, L_571_forvar2 in pairs(L_536_arg1.ElseClauseList) do
				L_517_func(L_568_, L_569_, L_571_forvar2.Token)
				L_568_ = L_571_forvar2.Token
				if L_571_forvar2.Condition then
					L_509_(L_571_forvar2.Condition)
					L_516_func(L_571_forvar2.Condition)
					L_515_func(L_571_forvar2.Token_Then)
					L_568_ = L_571_forvar2.Token_Then
				end
				L_569_ = L_571_forvar2.Body
			end
			L_517_func(L_568_, L_569_, L_536_arg1.Token_End)
		elseif L_536_arg1.Type == 'CallExprStat' then
			L_509_(L_536_arg1.Expression)
		elseif L_536_arg1.Type == 'AssignmentStat' then
			for L_572_forvar1, L_573_forvar2 in pairs(L_536_arg1.Lhs) do
				L_509_(L_573_forvar2)
				if L_572_forvar1 > 1 then
					L_516_func(L_573_forvar2)
				end
				local L_574_ = L_536_arg1.Token_LhsSeparatorList[L_572_forvar1]
				if L_574_ then
				end
			end
			L_515_func(L_536_arg1.Token_Equals)
			for L_575_forvar1, L_576_forvar2 in pairs(L_536_arg1.Rhs) do
				L_509_(L_576_forvar2)
				L_516_func(L_576_forvar2)
				local L_577_ = L_536_arg1.Token_RhsSeparatorList[L_575_forvar1]
				if L_577_ then
				end
			end
		else
			assert(false, "unreachable")
		end
	end
	L_508_(L_507_arg1)
end
local function L_18_func(L_578_arg1)
	local L_579_, L_580_
	local function L_581_func(L_584_arg1)
		L_584_arg1.LeadingWhite = ''
	end
	local function L_582_func(L_585_arg1, L_586_arg2)
		L_581_func(L_586_arg2)
		local L_587_ = L_585_arg1.Source:sub(-1, -1)
		local L_588_ = L_586_arg2.Source:sub(1, 1)
		if (L_587_ == '-' and L_588_ == '-') or (L_5_[L_587_] and L_5_[L_588_]) then
			L_586_arg2.LeadingWhite = ' '
		else
			L_586_arg2.LeadingWhite = ''
		end
	end
	local function L_583_func(L_589_arg1, L_590_arg2, L_591_arg3)
		L_579_(L_590_arg2)
		L_581_func(L_591_arg3)
		local L_592_ = L_590_arg2:GetFirstToken()
		local L_593_ = L_590_arg2:GetLastToken()
		if L_592_ then
			L_582_func(L_589_arg1, L_592_)
			L_582_func(L_593_, L_591_arg3)
		else
			L_582_func(L_589_arg1, L_591_arg3)
		end
	end
	L_580_ = function(L_594_arg1)
		if L_594_arg1.Type == 'BinopExpr' then
			L_580_(L_594_arg1.Lhs)
			L_581_func(L_594_arg1.Token_Op)
			L_580_(L_594_arg1.Rhs)
			L_582_func(L_594_arg1.Token_Op, L_594_arg1.Rhs:GetFirstToken())
			L_582_func(L_594_arg1.Lhs:GetLastToken(), L_594_arg1.Token_Op)
		elseif L_594_arg1.Type == 'UnopExpr' then
			L_581_func(L_594_arg1.Token_Op)
			L_580_(L_594_arg1.Rhs)
			L_582_func(L_594_arg1.Token_Op, L_594_arg1.Rhs:GetFirstToken())
		elseif L_594_arg1.Type == 'NumberLiteral' or L_594_arg1.Type == 'StringLiteral' or L_594_arg1.Type == 'NilLiteral' or L_594_arg1.Type == 'BooleanLiteral' or L_594_arg1.Type == 'VargLiteral' then
			L_581_func(L_594_arg1.Token)
		elseif L_594_arg1.Type == 'FieldExpr' then
			L_580_(L_594_arg1.Base)
			L_581_func(L_594_arg1.Token_Dot)
			L_581_func(L_594_arg1.Field)
		elseif L_594_arg1.Type == 'IndexExpr' then
			L_580_(L_594_arg1.Base)
			L_581_func(L_594_arg1.Token_OpenBracket)
			L_580_(L_594_arg1.Index)
			L_581_func(L_594_arg1.Token_CloseBracket)
		elseif L_594_arg1.Type == 'MethodExpr' or L_594_arg1.Type == 'CallExpr' then
			L_580_(L_594_arg1.Base)
			if L_594_arg1.Type == 'MethodExpr' then
				L_581_func(L_594_arg1.Token_Colon)
				L_581_func(L_594_arg1.Method)
			end
			if L_594_arg1.FunctionArguments.CallType == 'StringCall' then
				L_581_func(L_594_arg1.FunctionArguments.Token)
			elseif L_594_arg1.FunctionArguments.CallType == 'ArgCall' then
				L_581_func(L_594_arg1.FunctionArguments.Token_OpenParen)
				for L_595_forvar1, L_596_forvar2 in pairs(L_594_arg1.FunctionArguments.ArgList) do
					L_580_(L_596_forvar2)
					local L_597_ = L_594_arg1.FunctionArguments.Token_CommaList[L_595_forvar1]
					if L_597_ then
						L_581_func(L_597_)
					end
				end
				L_581_func(L_594_arg1.FunctionArguments.Token_CloseParen)
			elseif L_594_arg1.FunctionArguments.CallType == 'TableCall' then
				L_580_(L_594_arg1.FunctionArguments.TableExpr)
			end
		elseif L_594_arg1.Type == 'FunctionLiteral' then
			L_581_func(L_594_arg1.Token_Function)
			L_581_func(L_594_arg1.Token_OpenParen)
			for L_598_forvar1, L_599_forvar2 in pairs(L_594_arg1.ArgList) do
				L_581_func(L_599_forvar2)
				local L_600_ = L_594_arg1.Token_ArgCommaList[L_598_forvar1]
				if L_600_ then
					L_581_func(L_600_)
				end
			end
			L_581_func(L_594_arg1.Token_CloseParen)
			L_583_func(L_594_arg1.Token_CloseParen, L_594_arg1.Body, L_594_arg1.Token_End)
		elseif L_594_arg1.Type == 'VariableExpr' then
			L_581_func(L_594_arg1.Token)
		elseif L_594_arg1.Type == 'ParenExpr' then
			L_581_func(L_594_arg1.Token_OpenParen)
			L_580_(L_594_arg1.Expression)
			L_581_func(L_594_arg1.Token_CloseParen)
		elseif L_594_arg1.Type == 'TableLiteral' then
			L_581_func(L_594_arg1.Token_OpenBrace)
			for L_601_forvar1, L_602_forvar2 in pairs(L_594_arg1.EntryList) do
				if L_602_forvar2.EntryType == 'Field' then
					L_581_func(L_602_forvar2.Field)
					L_581_func(L_602_forvar2.Token_Equals)
					L_580_(L_602_forvar2.Value)
				elseif L_602_forvar2.EntryType == 'Index' then
					L_581_func(L_602_forvar2.Token_OpenBracket)
					L_580_(L_602_forvar2.Index)
					L_581_func(L_602_forvar2.Token_CloseBracket)
					L_581_func(L_602_forvar2.Token_Equals)
					L_580_(L_602_forvar2.Value)
				elseif L_602_forvar2.EntryType == 'Value' then
					L_580_(L_602_forvar2.Value)
				else
					assert(false, "unreachable")
				end
				local L_603_ = L_594_arg1.Token_SeparatorList[L_601_forvar1]
				if L_603_ then
					L_581_func(L_603_)
				end
			end
			L_581_func(L_594_arg1.Token_CloseBrace)
		else
			assert(false, "unreachable, type: "..L_594_arg1.Type..":"..G_4(L_594_arg1))
		end
	end
	L_579_ = function(L_604_arg1)
		if L_604_arg1.Type == 'StatList' then
			for L_605_forvar1 = 1, #L_604_arg1.StatementList do
				local L_606_ = L_604_arg1.StatementList[L_605_forvar1]
				L_579_(L_606_)
				L_581_func(L_606_:GetFirstToken())
				local L_607_ = L_604_arg1.StatementList[L_605_forvar1 - 1]
				if L_607_ then
					if L_604_arg1.SemicolonList[L_605_forvar1 - 1] and (L_607_:GetLastToken().Source ~= ')' or L_606_:GetFirstToken().Source ~= ')') then
						L_604_arg1.SemicolonList[L_605_forvar1 - 1] = nil
					end
					if not L_604_arg1.SemicolonList[L_605_forvar1 - 1] then
						L_582_func(L_607_:GetLastToken(), L_606_:GetFirstToken())
					end
				end
			end
			L_604_arg1.SemicolonList[#L_604_arg1.StatementList] = nil
			if #L_604_arg1.StatementList > 0 then
				L_581_func(L_604_arg1.StatementList[1]:GetFirstToken())
			end
		elseif L_604_arg1.Type == 'BreakStat' then
			L_581_func(L_604_arg1.Token_Break)
		elseif L_604_arg1.Type == 'ReturnStat' then
			L_581_func(L_604_arg1.Token_Return)
			for L_608_forvar1, L_609_forvar2 in pairs(L_604_arg1.ExprList) do
				L_580_(L_609_forvar2)
				if L_604_arg1.Token_CommaList[L_608_forvar1] then
					L_581_func(L_604_arg1.Token_CommaList[L_608_forvar1])
				end
			end
			if #L_604_arg1.ExprList > 0 then
				L_582_func(L_604_arg1.Token_Return, L_604_arg1.ExprList[1]:GetFirstToken())
			end
		elseif L_604_arg1.Type == 'LocalVarStat' then
			L_581_func(L_604_arg1.Token_Local)
			for L_610_forvar1, L_611_forvar2 in pairs(L_604_arg1.VarList) do
				if L_610_forvar1 == 1 then
					L_582_func(L_604_arg1.Token_Local, L_611_forvar2)
				else
					L_581_func(L_611_forvar2)
				end
				local L_612_ = L_604_arg1.Token_VarCommaList[L_610_forvar1]
				if L_612_ then
					L_581_func(L_612_)
				end
			end
			if L_604_arg1.Token_Equals then
				L_581_func(L_604_arg1.Token_Equals)
				for L_613_forvar1, L_614_forvar2 in pairs(L_604_arg1.ExprList) do
					L_580_(L_614_forvar2)
					local L_615_ = L_604_arg1.Token_ExprCommaList[L_613_forvar1]
					if L_615_ then
						L_581_func(L_615_)
					end
				end
			end
		elseif L_604_arg1.Type == 'LocalFunctionStat' then
			L_581_func(L_604_arg1.Token_Local)
			L_582_func(L_604_arg1.Token_Local, L_604_arg1.FunctionStat.Token_Function)
			L_582_func(L_604_arg1.FunctionStat.Token_Function, L_604_arg1.FunctionStat.NameChain[1])
			L_582_func(L_604_arg1.FunctionStat.NameChain[1], L_604_arg1.FunctionStat.Token_OpenParen)
			for L_616_forvar1, L_617_forvar2 in pairs(L_604_arg1.FunctionStat.ArgList) do
				L_581_func(L_617_forvar2)
				local L_618_ = L_604_arg1.FunctionStat.Token_ArgCommaList[L_616_forvar1]
				if L_618_ then
					L_581_func(L_618_)
				end
			end
			L_581_func(L_604_arg1.FunctionStat.Token_CloseParen)
			L_583_func(L_604_arg1.FunctionStat.Token_CloseParen, L_604_arg1.FunctionStat.Body, L_604_arg1.FunctionStat.Token_End)
		elseif L_604_arg1.Type == 'FunctionStat' then
			L_581_func(L_604_arg1.Token_Function)
			for L_619_forvar1, L_620_forvar2 in pairs(L_604_arg1.NameChain) do
				if L_619_forvar1 == 1 then
					L_582_func(L_604_arg1.Token_Function, L_620_forvar2)
				else
					L_581_func(L_620_forvar2)
				end
				local L_621_ = L_604_arg1.Token_NameChainSeparator[L_619_forvar1]
				if L_621_ then
					L_581_func(L_621_)
				end
			end
			L_581_func(L_604_arg1.Token_OpenParen)
			for L_622_forvar1, L_623_forvar2 in pairs(L_604_arg1.ArgList) do
				L_581_func(L_623_forvar2)
				local L_624_ = L_604_arg1.Token_ArgCommaList[L_622_forvar1]
				if L_624_ then
					L_581_func(L_624_)
				end
			end
			L_581_func(L_604_arg1.Token_CloseParen)
			L_583_func(L_604_arg1.Token_CloseParen, L_604_arg1.Body, L_604_arg1.Token_End)
		elseif L_604_arg1.Type == 'RepeatStat' then
			L_581_func(L_604_arg1.Token_Repeat)
			L_583_func(L_604_arg1.Token_Repeat, L_604_arg1.Body, L_604_arg1.Token_Until)
			L_580_(L_604_arg1.Condition)
			L_582_func(L_604_arg1.Token_Until, L_604_arg1.Condition:GetFirstToken())
		elseif L_604_arg1.Type == 'GenericForStat' then
			L_581_func(L_604_arg1.Token_For)
			for L_625_forvar1, L_626_forvar2 in pairs(L_604_arg1.VarList) do
				if L_625_forvar1 == 1 then
					L_582_func(L_604_arg1.Token_For, L_626_forvar2)
				else
					L_581_func(L_626_forvar2)
				end
				local L_627_ = L_604_arg1.Token_VarCommaList[L_625_forvar1]
				if L_627_ then
					L_581_func(L_627_)
				end
			end
			L_582_func(L_604_arg1.VarList[#L_604_arg1.VarList], L_604_arg1.Token_In)
			for L_628_forvar1, L_629_forvar2 in pairs(L_604_arg1.GeneratorList) do
				L_580_(L_629_forvar2)
				if L_628_forvar1 == 1 then
					L_582_func(L_604_arg1.Token_In, L_629_forvar2:GetFirstToken())
				end
				local L_630_ = L_604_arg1.Token_GeneratorCommaList[L_628_forvar1]
				if L_630_ then
					L_581_func(L_630_)
				end
			end
			L_582_func(L_604_arg1.GeneratorList[#L_604_arg1.GeneratorList]:GetLastToken(), L_604_arg1.Token_Do)
			L_583_func(L_604_arg1.Token_Do, L_604_arg1.Body, L_604_arg1.Token_End)
		elseif L_604_arg1.Type == 'NumericForStat' then
			L_581_func(L_604_arg1.Token_For)
			for L_631_forvar1, L_632_forvar2 in pairs(L_604_arg1.VarList) do
				if L_631_forvar1 == 1 then
					L_582_func(L_604_arg1.Token_For, L_632_forvar2)
				else
					L_581_func(L_632_forvar2)
				end
				local L_633_ = L_604_arg1.Token_VarCommaList[L_631_forvar1]
				if L_633_ then
					L_581_func(L_633_)
				end
			end
			L_582_func(L_604_arg1.VarList[#L_604_arg1.VarList], L_604_arg1.Token_Equals)
			for L_634_forvar1, L_635_forvar2 in pairs(L_604_arg1.RangeList) do
				L_580_(L_635_forvar2)
				if L_634_forvar1 == 1 then
					L_582_func(L_604_arg1.Token_Equals, L_635_forvar2:GetFirstToken())
				end
				local L_636_ = L_604_arg1.Token_RangeCommaList[L_634_forvar1]
				if L_636_ then
					L_581_func(L_636_)
				end
			end
			L_582_func(L_604_arg1.RangeList[#L_604_arg1.RangeList]:GetLastToken(), L_604_arg1.Token_Do)
			L_583_func(L_604_arg1.Token_Do, L_604_arg1.Body, L_604_arg1.Token_End)
		elseif L_604_arg1.Type == 'WhileStat' then
			L_581_func(L_604_arg1.Token_While)
			L_580_(L_604_arg1.Condition)
			L_581_func(L_604_arg1.Token_Do)
			L_582_func(L_604_arg1.Token_While, L_604_arg1.Condition:GetFirstToken())
			L_582_func(L_604_arg1.Condition:GetLastToken(), L_604_arg1.Token_Do)
			L_583_func(L_604_arg1.Token_Do, L_604_arg1.Body, L_604_arg1.Token_End)
		elseif L_604_arg1.Type == 'DoStat' then
			L_581_func(L_604_arg1.Token_Do)
			L_581_func(L_604_arg1.Token_End)
			L_583_func(L_604_arg1.Token_Do, L_604_arg1.Body, L_604_arg1.Token_End)
		elseif L_604_arg1.Type == 'IfStat' then
			L_581_func(L_604_arg1.Token_If)
			L_580_(L_604_arg1.Condition)
			L_582_func(L_604_arg1.Token_If, L_604_arg1.Condition:GetFirstToken())
			L_582_func(L_604_arg1.Condition:GetLastToken(), L_604_arg1.Token_Then)
			local L_637_ = L_604_arg1.Token_Then
			local L_638_ = L_604_arg1.Body
			for L_639_forvar1, L_640_forvar2 in pairs(L_604_arg1.ElseClauseList) do
				L_583_func(L_637_, L_638_, L_640_forvar2.Token)
				L_637_ = L_640_forvar2.Token
				if L_640_forvar2.Condition then
					L_580_(L_640_forvar2.Condition)
					L_582_func(L_640_forvar2.Token, L_640_forvar2.Condition:GetFirstToken())
					L_582_func(L_640_forvar2.Condition:GetLastToken(), L_640_forvar2.Token_Then)
					L_637_ = L_640_forvar2.Token_Then
				end
				L_579_(L_640_forvar2.Body)
				L_638_ = L_640_forvar2.Body
			end
			L_583_func(L_637_, L_638_, L_604_arg1.Token_End)
		elseif L_604_arg1.Type == 'CallExprStat' then
			L_580_(L_604_arg1.Expression)
		elseif L_604_arg1.Type == 'AssignmentStat' then
			for L_641_forvar1, L_642_forvar2 in pairs(L_604_arg1.Lhs) do
				L_580_(L_642_forvar2)
				local L_643_ = L_604_arg1.Token_LhsSeparatorList[L_641_forvar1]
				if L_643_ then
					L_581_func(L_643_)
				end
			end
			L_581_func(L_604_arg1.Token_Equals)
			for L_644_forvar1, L_645_forvar2 in pairs(L_604_arg1.Rhs) do
				L_580_(L_645_forvar2)
				local L_646_ = L_604_arg1.Token_RhsSeparatorList[L_644_forvar1]
				if L_646_ then
					L_581_func(L_646_)
				end
			end
		else
			assert(false, "unreachable")
		end
	end
	L_579_(L_578_arg1)
end
local L_19_ = 0
local L_20_ = {}
for L_647_forvar1 = ('a'):byte(), ('z'):byte() do
	table.insert(L_20_, string.char(L_647_forvar1))
end
for L_648_forvar1 = ('A'):byte(), ('Z'):byte() do
	table.insert(L_20_, string.char(L_648_forvar1))
end
for L_649_forvar1 = ('0'):byte(), ('9'):byte() do
	table.insert(L_20_, string.char(L_649_forvar1))
end
table.insert(L_20_, '_')
local L_21_ = {}
for L_650_forvar1 = ('a'):byte(), ('z'):byte() do
	table.insert(L_21_, string.char(L_650_forvar1))
end
for L_651_forvar1 = ('A'):byte(), ('Z'):byte() do
	table.insert(L_21_, string.char(L_651_forvar1))
end
local function L_22_func(L_652_arg1)
	local L_653_ = ''
	local L_654_ = L_652_arg1 % #L_21_
	L_652_arg1 = (L_652_arg1 - L_654_) / #L_21_
	L_653_ = L_653_..L_21_[L_654_ + 1]
	while L_652_arg1 > 0 do
		local L_655_ = L_652_arg1 % #L_20_
		L_652_arg1 = (L_652_arg1 - L_655_) / #L_20_
		L_653_ = L_653_..L_20_[L_655_ + 1]
	end
	return L_653_
end
local function L_23_func()
	local L_656_ = L_19_
	L_19_ = L_19_ + 1
	return L_22_func(L_656_)
end
local function L_24_func()
	local L_657_ = ''
	repeat
		L_657_ = L_23_func()
	until not L_10_[L_657_]
	return L_657_
end
local function L_25_func(L_658_arg1, L_659_arg2)
	local L_660_ = {}
	local L_661_ = 0
	for L_665_forvar1, L_666_forvar2 in pairs(L_658_arg1) do
		if L_666_forvar2.AssignedTo then
			L_666_forvar2:Rename('_TMP_'..L_661_..'_')
			L_661_ = L_661_ + 1
		else
			L_660_[L_666_forvar2.Name] = true
		end
	end
	local function L_662_func(L_667_arg1)
		for L_668_forvar1, L_669_forvar2 in pairs(L_667_arg1.VariableList) do
			L_669_forvar2:Rename('_TMP_'..L_661_..'_')
			L_661_ = L_661_ + 1
		end
		for L_670_forvar1, L_671_forvar2 in pairs(L_667_arg1.ChildScopeList) do
			L_662_func(L_671_forvar2)
		end
	end
	local L_663_ = 0
	for L_672_forvar1, L_673_forvar2 in pairs(L_658_arg1) do
		if L_673_forvar2.AssignedTo then
			local L_674_ = ''
			repeat
				L_674_ = L_22_func(L_663_)
				L_663_ = L_663_ + 1
			until not L_10_[L_674_] and not L_660_[L_674_]
			L_673_forvar2:Rename(L_674_)
		end
	end
	L_659_arg2.FirstFreeName = L_663_
	local function L_664_func(L_675_arg1)
		for L_676_forvar1, L_677_forvar2 in pairs(L_675_arg1.VariableList) do
			local L_678_ = ''
			repeat
				L_678_ = L_22_func(L_675_arg1.FirstFreeName)
				L_675_arg1.FirstFreeName = L_675_arg1.FirstFreeName + 1
			until not L_10_[L_678_] and not L_660_[L_678_]
			L_677_forvar2:Rename(L_678_)
		end
		for L_679_forvar1, L_680_forvar2 in pairs(L_675_arg1.ChildScopeList) do
			L_680_forvar2.FirstFreeName = L_675_arg1.FirstFreeName
			L_664_func(L_680_forvar2)
		end
	end
	L_664_func(L_659_arg2)
end
local function L_26_func(L_681_arg1, L_682_arg2)
	local L_683_ = {}
	for L_689_forvar1, L_690_forvar2 in pairs(L_10_) do
		L_683_[L_689_forvar1] = true
	end
	local L_684_ = {}
	local L_685_ = {}
	do
		for L_692_forvar1, L_693_forvar2 in pairs(L_681_arg1) do
			if L_693_forvar2.AssignedTo then
				table.insert(L_684_, L_693_forvar2)
			else
				L_683_[L_693_forvar2.Name] = true
			end
		end
		local function L_691_func(L_694_arg1)
			for L_695_forvar1, L_696_forvar2 in pairs(L_694_arg1.VariableList) do
				table.insert(L_684_, L_696_forvar2)
				table.insert(L_685_, L_696_forvar2)
			end
			for L_697_forvar1, L_698_forvar2 in pairs(L_694_arg1.ChildScopeList) do
				L_691_func(L_698_forvar2)
			end
		end
		L_691_func(L_682_arg2)
	end
	for L_699_forvar1, L_700_forvar2 in pairs(L_684_) do
		L_700_forvar2.UsedNameArray = {}
	end
	table.sort(L_684_, function(L_701_arg1, L_702_arg2)
		return #L_701_arg1.RenameList < #L_702_arg2.RenameList
	end)
	local L_686_ = 0
	local L_687_ = {}
	local function L_688_func(L_703_arg1)
		local L_704_ = L_687_[L_703_arg1]
		if not L_704_ then
			repeat
				L_704_ = L_22_func(L_686_)
				L_686_ = L_686_ + 1
			until not L_683_[L_704_]
			L_687_[L_703_arg1] = L_704_
		end
		return L_704_
	end
	for L_705_forvar1, L_706_forvar2 in pairs(L_684_) do
		L_706_forvar2.Renamed = true
		local L_707_ = 1
		while L_706_forvar2.UsedNameArray[L_707_] do
			L_707_ = L_707_ + 1
		end
		L_706_forvar2:Rename(L_688_func(L_707_))
		if L_706_forvar2.Scope then
			for L_708_forvar1, L_709_forvar2 in pairs(L_684_) do
				if not L_709_forvar2.Renamed then
					if not L_709_forvar2.Scope or L_709_forvar2.Scope.Depth < L_706_forvar2.Scope.Depth then
						for L_710_forvar1, L_711_forvar2 in pairs(L_709_forvar2.ReferenceLocationList) do
							if L_711_forvar2 >= L_706_forvar2.BeginLocation and L_711_forvar2 <= L_706_forvar2.ScopeEndLocation then
								L_709_forvar2.UsedNameArray[L_707_] = true
								break
							end
						end
					elseif L_709_forvar2.Scope.Depth > L_706_forvar2.Scope.Depth then
						for L_712_forvar1, L_713_forvar2 in pairs(L_706_forvar2.ReferenceLocationList) do
							if L_713_forvar2 >= L_709_forvar2.BeginLocation and L_713_forvar2 <= L_709_forvar2.ScopeEndLocation then
								L_709_forvar2.UsedNameArray[L_707_] = true
								break
							end
						end
					else
						if L_706_forvar2.BeginLocation < L_709_forvar2.EndLocation and L_706_forvar2.EndLocation > L_709_forvar2.BeginLocation then
							L_709_forvar2.UsedNameArray[L_707_] = true
						end
					end
				end
			end
		else
			for L_714_forvar1, L_715_forvar2 in pairs(L_684_) do
				if not L_715_forvar2.Renamed then
					if L_715_forvar2.Type == 'Global' then
						L_715_forvar2.UsedNameArray[L_707_] = true
					elseif L_715_forvar2.Type == 'Local' then
						for L_716_forvar1, L_717_forvar2 in pairs(L_706_forvar2.ReferenceLocationList) do
							if L_717_forvar2 >= L_715_forvar2.BeginLocation and L_717_forvar2 <= L_715_forvar2.ScopeEndLocation then
								L_715_forvar2.UsedNameArray[L_707_] = true
								break
							end
						end
					else
						assert(false, "unreachable")
					end
				end
			end
		end
	end
end
local function L_27_func(L_718_arg1, L_719_arg2)
	local L_720_ = {}
	for L_725_forvar1, L_726_forvar2 in pairs(L_718_arg1) do
		if not L_726_forvar2.AssignedTo then
			L_720_[L_726_forvar2.Name] = true
		end
	end
	local L_721_ = 1
	local L_722_ = 1
	local function L_723_func(L_727_arg1, L_728_arg2)
		L_727_arg1.Name = L_728_arg2
		for L_729_forvar1, L_730_forvar2 in pairs(L_727_arg1.RenameList) do
			L_730_forvar2(L_728_arg2)
		end
	end
	for L_731_forvar1, L_732_forvar2 in pairs(L_718_arg1) do
		if L_732_forvar2.AssignedTo then
			L_723_func(L_732_forvar2, 'G_'..L_722_)
			L_722_ = L_722_ + 1
		end
	end
	local function L_724_func(L_733_arg1)
		for L_734_forvar1, L_735_forvar2 in pairs(L_733_arg1.VariableList) do
			local L_736_ = 'L_'..L_721_..'_'
			if L_735_forvar2.Info.Type == 'Argument' then
				L_736_ = L_736_..'arg'..L_735_forvar2.Info.Index
			elseif L_735_forvar2.Info.Type == 'LocalFunction' then
				L_736_ = L_736_..'func'
			elseif L_735_forvar2.Info.Type == 'ForRange' then
				L_736_ = L_736_..'forvar'..L_735_forvar2.Info.Index
			end
			L_723_func(L_735_forvar2, L_736_)
			L_721_ = L_721_ + 1
		end
		for L_737_forvar1, L_738_forvar2 in pairs(L_733_arg1.ChildScopeList) do
			L_724_func(L_738_forvar2)
		end
	end
	L_724_func(L_719_arg2)
end
local function L_28_func()
	error("\nusage: minify <file> or unminify <file>\n".."  The modified code will be printed to the stdout, pipe it to a file, the\n".."  lua interpreter, or something else as desired EG:\n\n".."        lua minify.lua minify input.lua > output.lua\n\n".."  * minify will minify the code in the file.\n".."  * unminify will beautify the code and replace the variable names with easily\n".."    find-replacable ones to aide in reverse engineering minified code.\n", 0)
end
local L_29_ = {
	...
}
if #L_29_ ~= 2 then
	L_28_func()
end
local L_30_ = io.open(L_29_[2], 'r')
if not L_30_ then
	error("Could not open the input file `"..L_29_[2].."`", 0)
end
local L_31_ = L_30_:read('*all')
local L_32_ = G_6(L_31_)
local L_33_, L_34_ = G_9(L_32_)
local function L_35_func(L_739_arg1, L_740_arg2, L_741_arg3)
	L_25_func(L_740_arg2, L_741_arg3)
	L_18_func(L_739_arg1)
	G_10(L_739_arg1)
end
local function L_36_func(L_742_arg1, L_743_arg2, L_744_arg3)
	L_27_func(L_743_arg2, L_744_arg3)
	L_17_func(L_742_arg1)
	G_10(L_742_arg1)
end
if L_29_[1] == 'minify' then
	L_35_func(L_32_, L_33_, L_34_)
elseif L_29_[1] == 'unminify' then
	L_36_func(L_32_, L_33_, L_34_)
else
	L_28_func()
end