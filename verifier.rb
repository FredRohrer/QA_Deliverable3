

def getFile (input) {
	block = File.new(input, 'r')
	unless block {
		raise "Invalid file"
	}
	block
}



def hash_char(char, mem) {

	value = mem.fetch(char) { |ch| 
		c = ch.unpack("U*")[0]
		x = (c ** 2000) * ((c + 2) ** 21) - ((c + 5) ** 3) 
		x = x % 65536
		mem[ch] = x
		x
	}
	return value, mem
}

def iter_next (line, start, end_char) {
	i = 0
	str = ""
	line = line[start]
	line.each_char { |c|
		if (c == end_char) {
			break 
		}
		str = str + c
		i = i + 1
	}
	return str, i + 1
}

def verify_pipes (line) {
	pipe_count = 0
	line.each_char { |c|
		if (c == '|') {
			pipe_count = pipe_count + 1
		}
	}
	unless pipe_count == 4 {
		puts "Expected 4 pipes, but there are #{pipe_count}"
		return false
	}
	return true
}

def verify_block_num(line, cur_num) {
	string_num, i = iter_next(line, 0, '|')
	num 
	begin 
		num = Integer(string_num)
		if (num == cur_num + 1) {
			return true, i 
		}
		else {
			puts "Expected #{cur_num + 1}, got #{num}"
			return false
		}
	rescue ArgumentError{
		puts "Expected #{cur_num + 1}, got invalid block number: #{string_num}"
		return false
	}
}

def verify_prev_hash(line, i, prev_hasg) {
	
}

def verify_tran (line, i, trans) {
	
	return true, i, trans 
}

def verify_time (line, i, prev) {
	
}
def hash_line (line, i,  ) 

def verify_line (balances, prevHash, iter, prev_time, line) {
	
}



block = getFile(ARGV[3]).readlines



