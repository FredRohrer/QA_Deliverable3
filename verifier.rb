

def getFile (input) {
	block = File.new(input, 'r')
	unless block {
		raise "Invalid file"
	}
	block
}

def hash_char(c) {
	c.unpack('U*')
	x = (c ** 2000) * ((c + 2) ** 21) - ((c + 5) ** 3) 
	x % 65536
}

def verify_block_num(line) {

}

def verify_prev_has(line, i, prev_hasg) {

}

def 

def verify_line (balances, prevHash, iter, prev_time, line) {
	
}



block = getFile(ARGV[3]).readlines



