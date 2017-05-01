function read_file(path_to_file)

	local file = io.open(path_to_file, "r")
	data = file:read("*a")
	file:close()
	return data

end

function filter_char_and_normalize(str_data)

	local pattern  = str_data:gsub('%W',' '):lower()

	return pattern

end

function scan(str_data)

	local words = {}

	for word in str_data:gmatch("%S+") do
		table.insert(words, word)
	end

	return words

end

function remove_stop_words(word_list)

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

	return words
end

function frequencies(word_list)

	local word_freq = {}

	for _, value in pairs(word_list) do
		if word_freq[value] == nil then
			word_freq[value] = 1
		else
			word_freq[value] = word_freq[value] + 1
		end
	end

	return word_freq
end

function sorts(word_freq)

	local temp_word_freqs = {}


	for word, freq in pairs(word_freq) do
		table.insert(temp_word_freqs, { ["word"] = word, ["freq"] = freq })
	end

	table.sort(temp_word_freqs, function(a, b) return a.freq > b.freq end)

	return temp_word_freqs

end

function print_freq(word_freq)

	for i, v in pairs(word_freq) do
		print(v['freq'], '-', v['word'])
	end

end

print_freq(sorts(frequencies(remove_stop_words(scan(filter_char_and_normalize(read_file("t.txt")))))))
