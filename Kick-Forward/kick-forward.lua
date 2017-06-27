--[[
	Programa : Kick_Forward.lua
	Autores : Mauricio De Castro Lana e Douglas Mandarino
	Data da última modificação: 30/04/2017
	Versão : 1.0
	Tamanho : 166 linhas
]]

--[[
	Pre-Condições: exista um arquivo em path_to_file, exista func
	Validação: arquivo passado pela main existe na pasta
	Pos-Condições: variavel data instanciada com o conteudo do arquivo
	Validação: variavel data é instanciada com o conteudo do arquivo durante a função
]]
function read_file(path_to_file, func)

	local file = io.open(path_to_file, "r")
	data = file:read("*a")
	file:close()
	return func(data, normalize)

end

--[[
	Pre-Condições: Variavel str_data estar instanciada a uma String
	Validação: Variavel str_data é passada por read_file contendo uma string
	Pos-Condições: String contida por str_data contendo apenas caracteres alphnumericos instanciada em pattern
	Validação: Função torna todos os caracteres minusculas e remove os não alphnumericos em str_datav para pattern
]]
function filter_char(str_data, func)

	local pattern  = str_data:gsub('%W',' ')

	return func(pattern, scan)

end

--[[
	Pre-Condições: variavel str_data estar instanciada a uma string
	Validação: Variavel str_data é passada por filter_char contendo uma string
	Pos-Condições: str_data estar com apenas caracteres minusculos
	Validação: função torna todas os caracteres minusculos
]]
function normalize(str_data, func)
	func(str_data:lower(), remove_stop_words)
end

--[[
	Pre-Condições: variavel str_data estar instanciada a uma string
	Validação: Variavel str_data é passada por normalize contendo uma string
	Pos-Condições: variavel word estar instanciada a uma tabela de palavras
	Validação: função preenche a varivel word com todas as palavras de data
]]
function scan(str_data, func)

	local words = {}

	for word in str_data:gmatch("%S+") do
		table.insert(words, word)
	end

	return func(words, frequencies)

end

--[[
	Pre-Condições: variavel word_list estar instanciada a uma tabela de palavras
	Validação: Variavel word_list é passada por scan contendo uma tabela de palavras
	Pos-Condições: variavel word não conter paravras de parada definidas por stop_words
	Validação: palavras de parada são removidas de word ao longo da função
]]
function remove_stop_words(word_list, func)

	local file = io.open("stop_words.txt")
	local stop_words = {}
	local words = {}

	for word in file:read("*a"):gmatch("([^,]+)") do
		table.insert(stop_words, word)
	end

	for i = 97, 122 do
		table.insert(stop_words, string.char(i))
	end

	for i, v in pairs(word_list) do
		words[i] = v
	end

	for i = #words, 1, -1 do
		for stpwrd_key, stpwrd_value in pairs(stop_words) do
			if words[i] == stpwrd_value then
				table.remove(words, i)
			end
		end
	end

	return func(words, sorts)
end

--[[
	Pre-Condições: variavel word_list estar instanciada a uma tabela de palavras
	Validação: Variavel word_list é passada por remove_stop_words contendo uma tabela de palavras
	Pos-Condições: variavel word_freqs estar instanciada a uma tabela contendo frequencia das palavras
	Validação: variavel word_freqs instanciada durante a função
]]
function frequencies(word_list, func)

	local word_freq = {}

	for _, value in pairs(word_list) do
		if word_freq[value] == nil then
			word_freq[value] = 1
		else
			word_freq[value] = word_freq[value] + 1
		end
	end

	return func(word_freq, print_freq)
end

--[[
	Pre-Condições: variavel word_freqs estar instanciada a uma tabela contendo frequencia das palavras
	Validação: Variavel word_freqs é passada por frequencies contendo uma tabela contendo frequencia das palavras
	Pos-Condições: variavel word_freqs ordenada por frequencia
	Validação: variavel word_freqs é ordenada pela função
]]
function sorts(word_freq, func)

	local temp_word_freqs = {}


	for word, freq in pairs(word_freq) do
		table.insert(temp_word_freqs, { ["word"] = word, ["freq"] = freq })
	end

	table.sort(temp_word_freqs, function(a, b) return a.freq > b.freq end)

	return func(temp_word_freqs, no_op)

end

--[[
	Pre-Condições: variavel word_freqs estar instanciada a uma tabela contendo frequencia das palavras
	Validação: Variavel word_freqs é passada por sorts contendo uma tabela contendo frequencia das palavras
	Pos-Condições: escrever na tela os valores de word_freqs
	Validação: valores são escritos na tela
]]
function print_freq(word_freq, func)

	for i, v in pairs(word_freq) do
		print(v['freq'], '-', v['word'])
	end

	func(nil)

end

function no_op(func)

	return

end

read_file("t.txt", filter_char)
--ver comentarios no pull-request (roxana)
