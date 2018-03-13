

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
	return value
end

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
		num = Integer (line)
		if (num == cur_num ) 
			return true
		else
			puts "Expected block number to be #{cur_num}, but is #{num}"
			return false
		end
	rescue ArgumentError 
		puts "Expected block number to be #{cur_num}, but is invalid block number: #{line}"
		return false
	end
end

def verify_prev_hash(line, prev_hash) 
	#str_hash, j = iter_next(line, i, '|')
	if (line == prev_hash) 
		return true
	end
	puts "Expected the previous hash to be #{prev_hash}, but is #{line}"
	return false 
end

def hash_line (line, mem)
	value = 0
	line.each_char { |c|
		temp = hash_char(c, mem)
		value = (value + temp) % 65536
	}
	return value
end


def parse_tr (tr) 
	parties = tr.split('>')
	if parties.length != 2
		puts "Transaction error: Expected name1>name2(x), but have #{tr}"
		return false 
	end
	
	recs = parties[1].split('(')
	
	unless recs.length == 2 
		puts "Transaction error: Expected a ( somewhere, but have #{tr}"
		return false
	end
	
	if recs[1][-1] == ')'
		recs[1].chop!
	else
		puts "Transaction error: Expected a ) somewhere, but have #{tr}"
		return false
	end
	
	
	begin 
		value = Integer(recs[1])
	rescue ArgumentError
		puts "Transaction error: Expected an int in () but have #{recs[1]}"
		return false
	end
	
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
	
	
	
	return true
	
end

def verify_all_trans (line, tr_hist) 
	trans = line.split(':')
	if trans.length < 1 
		puts "Expected at least a system transaction but no transactions"
	end
	last = false
	trans.each_with_index { |tr, i|
		if trans.length == i + 1 
			last = true
		end 
		return false unless ver_tr(tr, tr_hist, last)
	}
	
	tr_hist.each { |key, value|
		if value < 0 
			puts "#{key} ended the block with negative Billcoins"
			return false
		end
	}
	
	return true, tr_hist
end

def verify_time (line, prev_time) 
	s_nums = line.split('.')
	prev_sec = prev_time[0]
	prev_nano = prev_time[1]
	if s_nums.length != 2 
		puts "Expected time in format #.#, but is #{line}"
		return false
	end	
	begin
		sec = Integer(s_nums[0])
		nano = Integer(s_nums[1])
	rescue ArgumentError
		puts "Expected time in format #.#, but is #{line}"
		return false
	end
	
	
	if sec > prev_sec or (sec == prev_sec and nano > prev_nano) 
		prev_time[0] = sec
		prev_time[1] = nano 
		return true
	end
	puts "Expected time to increase but #{line} is not greater than #{prev_sec}.#{prev_nano}"
	return false
end

def ver_hash (str_hash, calc_code)
	str_code = calc_code.to_s(16)
	unless str_code == str_hash 
		puts "The hash code: #{str_hash} does not match the calculated code of #{str_code}"
		return false
	end
	return true
end

def verify_line (tr_hist, mem, block_num, prev_hash, prev_time, line)
	if verify_pipes(line) 
		sep = line.split('|')
		if (verify_block_num(sep[0], block_num) and
			verify_prev_hash(sep[1], prev_hash) and
			verify_all_trans(sep[2], tr_hist) and
			verify_time(sep[3], prev_time))
			
			to_be_hashed = sep[0] + '|' + sep[1] + '|' + sep[2] + '|' + sep[3]
			code = hash_line(to_be_hashed, mem) 
			if ver_hash(sep[4], code)
				return true, sep[4] # return the previous hash
			end
		end
	end
	return false 
end

def ver_all(tr_hist, block)
	prev_hash = '0'
	mem = Hash.new(0)
	prev_time = [0, 0]
	
	block.each_line.with_index { |line, i|
		line.chomp!
		ver, prev_hash = verify_line(tr_hist, mem, i, prev_hash, prev_time, line)
		unless ver
			puts "Error ^ in line #{i}"
			return false
		end
	}
	return true
end


