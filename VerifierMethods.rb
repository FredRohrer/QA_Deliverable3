

def getFile (input) 
	begin 
	f = File.new(input, 'r')
	rescue  
		raise "Invalid file"
	end
	f
end



def hash_char(char, mem)

	value = mem.fetch(char) { |ch| 
		c = ch.unpack("U*")[0]
		x = (c ** 2000) * ((c + 2) ** 21) - ((c + 5) ** 3) 
		x = x % 65536
		mem[ch] = x
		x
	}
	return value, mem
end

#def iter_next (line, start, end_char) 
#	i = 0
#	str = ""
#	line = line[start..-1]
#	line.each_char { |c|
#		if (c == end_char) 
#			break 
#		end 
#		str = str + c
#		i = i + 1
#	}
#	return str, i + 1
#end

def verify_pipes (line) 
	pipe_count = 0
	line.each_char { |c|
		if (c == '|') 
			pipe_count = pipe_count + 1
		end
	}
	unless pipe_count == 4 
		puts "Expected 4 pipes, but there are #{pipe_count}"
		return false
	end
	
	return true
end

def verify_block_num(line, cur_num) 
	#string_num, i = iter_next(line, 0, '|')
	
	begin 
		num = Integer (string_num)
		if (num == cur_num ) 
			return true
		else
			puts "Expected block number to be #{cur_num}, but is #{num}"
			return false
		end
	rescue ArgumentError 
		puts "Expected block number to be #{cur_num}, but is invalid block number: #{string_num}"
		return false
	end
end

def verify_prev_hash(line, prev_hash) 
	#str_hash, j = iter_next(line, i, '|')
	if (str_hash == prev_hash) 
		return true
	end
	puts "Expected the previous hash to be #{prev_hash}, but got #{str_hash}"
	return false 
end

def hash_line (line, mem)
	value = 0
	line.each_char { |c|
		temp, mem = hash_char(c)
		value = (value + temp) % c 
	}
	return value, mem 
end


def parse_tr (tr) 
	parties = tr.split('>')
	if parties.length != 2
		puts "Expected name1>name2(x), but have #{tr}"
		return false 
	end
	
	recs = parties[1].split('(')
	
	unless recs.length == 2 
		
	end
	
	if recs[1][-1] == ')'
		recs[1].chop!
	end
	
	value = Integer(recs[1])
	return parties[0], recs[0], value
end 

def ver_tr (trans, hist, last) 
	
	sender, rec, value = parse_tr(trans)
	return false unless sender
	
	hist[rec] = hist[rec] + value
	
	if last
		unless sender == "SYSTEM" and value == 100
			puts "There is no SYSTEM giving"
			return false
		end
	else	
		hist[sender] = hist[sender] - value
	end
	
	
	
	return true, hist
	
end

def ver_all_trans (line, tr_hist) 
	trans = line.split(':')
	if trans.length < 1 
		puts "Expected at least a system transaction but no transactions"
	end
	last = false
	trans.each_with_index { |tr, i|
		if trans.length == i + 1 last = true
		ver, tr_hist = ver_tr(tr, tr_hist, last)
		return false unless ver
		
		
		
	}
	
	tr_hist.each { |key, value|
		if value > 0 
			puts "#{key} ended the block with negative Billcoins"
			return false
		end
	}
	
	return true, tr_hist
end

def verify_time (line, prev_sec, prev_nano) 
	s_nums = line.split('.')
	if s_num.length != 2 
		puts "Expected time in format #.#, but is #{line}"
		return false
	end	
	begin
		sec = Integer(s_num[0])
		nano = Integer(s_num[1])
	rescue ArgumentError
		puts "Expected time in format #.#, but is #{line}"
		return false
	end
	
	if sec < prev_sec or (sec == prev_sec and nano > prev_nano) 
		return true, sec, nano	
	end
	puts "Expected time to increase but #{line} is not greater than #{prev_sec}.#{prev_nano}"
	return false
end


def verify_line (balances, prevHash, iter, prev_time, line)

end



