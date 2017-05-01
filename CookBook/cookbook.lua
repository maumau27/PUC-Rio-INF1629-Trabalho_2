data = {}
words = {}
word_freqs = {}

function read_file(path_to_file)

	local file = io.open(path_to_file, "r")
	data = file:read("*a")
	file:close()

end

function filter_char_and_normalize()

	data = data:gsub('%W',' '):lower()

end

function scan()

	for word in data:gmatch("%S+") do
		table.insert(words, word)
	end

end

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

function frequencies()

	for _, value in pairs(words) do
		if word_freqs[value] == nil then
			word_freqs[value] = 1
		else
			word_freqs[value] = word_freqs[value] + 1
		end
	end

end

function sorts()

	local temp_word_freqs = {}


	for word, freq in pairs(word_freqs) do
		table.insert(temp_word_freqs, { ["word"] = word, ["freq"] = freq })
	end

	table.sort(temp_word_freqs, function(a, b) return a.freq > b.freq end)

	word_freqs = temp_word_freqs

end

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

