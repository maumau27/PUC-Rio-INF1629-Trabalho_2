--[[
	Programa : monolith.lua
	Autores : Mauricio De Castro Lana e Douglas Mandarino
	Data da �ltima modifica��o: 03/05/2017
	Vers�o : 1.0
	Tamanho : =========================== linhas
]]


--[[
	Pre-Condi��es: exista o arquivo no path do programa com palavras a serem lidas
	Valida��o: arquivo existe na pasta
	Pos-Condi��es: escrever na tela, em ordem crescente, a frequencia com que cada uma das palavras mais frequentes no texto aparecem.
	Valida��o: valores s�o escritos na tela
]]
word_freqs = {}
stop_words = {}

local file = io.open("stop_words.txt", "r")

for word in file:read("*a"):gmatch("([^,]+)") do
		table.insert(stop_words, word)
end

for i = 97, 122 do
	table.insert(stop_words, string.char(i))
end
--TODO : perguntar do erro do algoritimo que caso n tenha espaco no final de cada frase da erro
for line in io.lines("input.txt") do
	start_char = nil
	i = 1
	for j = 1,#line do
		local c = line:sub(j, j)
		if start_char == nil then
			if not c:match("%W") then
				start_char = i
			end
		else
			if c:match("%W") then
				found = false
				pass = true
				word = line:sub(start_char,i):lower()
				for _, value in pairs(stop_words) do
					if word == v then
						pass = false
						break
					end
				end
				if pass then
					pair_index = 0
					for _, pair in pairs(word_freqs) do
						if word == pair["word"] then
							pair["freq"] = pair["freq"] + 1
							found = true
							found_at = pair_index
							break
						end
						pair_index = pair_index + 1
					end
					if not found then
						table.insert(word_freqs, {["word"] = word, ["freq"] = 1})
					elseif #word_freqs > 1 then
						table.sort(word_freqs, function(a, b) return a.freq > b.freq end)
						-- TODO : verificar se pode usar a sort nessa padrao de linguagem
					end
				end
				start_char = nil
			end
		end
		i = i + 1
	end
end

for i, v in pairs(word_freqs) do
	print(v['freq'], '-', v['word'])
end
