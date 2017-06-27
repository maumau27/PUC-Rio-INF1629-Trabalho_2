--[[
	Programa : JogoDaSenha.lua
	Autores : Mauricio De Castro Lana e Douglas Mandarino
	Data da última modificação: 30/04/2017
	Versão : 1.0
	Tamanho : 142 linhas
]]

data = {}
words = {}
word_freqs = {}

--[[
	Pre-Condições: exista um arquivo em path_to_file
	Validação: arquivo passado pela main existe na pasta
	Pos-Condições: variavel data instanciada com o conteudo do arquivo
	Validação: variavel data é instanciada com o conteudo do arquivo durante a função
]]
function read_file(path_to_file)

	local file = io.open(path_to_file, "r")
	data = file:read("*a")
	file:close()

end

--[[
	Pre-Condições: Variavel data estar instanciada a uma String
	Validação: Variavel data é instanciada a uma Sting pela função read_file
	Pos-Condições: String contida por data contendo apenas minusculas e caracteres alphnumericos
	Validação: Função torna todos os caracteres minusculas e remove os não alphnumericos em data
]]
function filter_char_and_normalize()

	data = data:gsub('%W',' '):lower()

end

--[[
	Pre-Condições: variavel data estar instanciada a uma string
	Validação: data está instanciada a uma string pela função read_file
	Pos-Condições: variavel word estar instanciada a uma tabela de palavras
	Validação: função preenche a varivel word com todas as palavras de data
]]
function scan()

	for word in data:gmatch("%S+") do
		table.insert(words, word)
	end

end

--[[
	Pre-Condições: variavel word estar instanciada a uma tabela de palavras
	Validação: word está instanciada a uma string pela função scan
	Pos-Condições: variavel word não conter paravras de parada definidas por stop_words
	Validação: palavras de parada são removidas de word ao longo da função
]]
function remove_stop_words()

	local file = io.open("stop_words.txt")
	local stop_words = {}

	for word in file:read("*a"):gmatch("([^,]+)") do
		table.insert(stop_words, word)
	end

	for i = 97, 122 do
		table.insert(stop_words, string.char(i))
	end

	for i = #words, 1, -1 do
		for stpwrd_key, stpwrd_value in pairs(stop_words) do
			if words[i] == stpwrd_value then
				table.remove(words, i)
			end
		end
	end

end

--[[
	Pre-Condições: variavel word estar instanciada a uma tabela de palavras
	Validação: word está instanciada a uma string pela função scan
	Pos-Condições: variavel word_freqs estar instanciada a uma tabela contendo frequencia das palavras
	Validação: variavel word_freqs instanciada durante a função
]]
function frequencies()

	for _, value in pairs(words) do
		if word_freqs[value] == nil then
			word_freqs[value] = 1
		else
			word_freqs[value] = word_freqs[value] + 1
		end
	end

end

--[[
	Pre-Condições: variavel word_freqs estar instanciada a uma tabela contendo frequencia das palavras
	Validação: word_freqs está instanciada a uma string pela função frequencies
	Pos-Condições: variavel word_freqs ordenada por frequencia
	Validação: variavel word_freqs é ordenada pela função
]]
function sorts()

	local temp_word_freqs = {}


	for word, freq in pairs(word_freqs) do
		table.insert(temp_word_freqs, { ["word"] = word, ["freq"] = freq })
	end

	table.sort(temp_word_freqs, function(a, b) return a.freq > b.freq end)

	word_freqs = temp_word_freqs

end

--[[
	Pre-Condições: variavel word_freqs estar instanciada a uma tabela contendo frequencia das palavras
	Validação: word_freqs está instanciada a uma string pela função frequencies
	Pos-Condições: escrever na tela os valores de word_freqs
	Validação: valores são escritos na tela
]]
function print_freq()

	for i, v in pairs(word_freqs) do
		print(v['freq'], '-', v['word'])
	end

end

read_file("t.txt")
filter_char_and_normalize()
scan()
remove_stop_words()
frequencies()
sorts()
print_freq()
--ver comentarios no pull-request (Roxana)
