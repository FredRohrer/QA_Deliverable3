

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
	i = 0
	string_num = ""
	line.each_char { |c|
		if (c == '|') {
			break 
		}
		string_num = string_num + c
		i = i + 1
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



