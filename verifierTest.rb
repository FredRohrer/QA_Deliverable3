require 'minitest/autorun'
begin 
	require_relative 'verifier.rb'
rescue RuntimeError => e # the thing throws stuff based on command line args
end
class VerifierTest < Minitest::Test
	#File getter tests
	def test_get_ok_File 
		test_block = getFile("verifier.rb")
		assert_kind_of File, test_block
	end
	
	def test_get_bad_File 
		exc = assert_raises RuntimeError do
			getFile("")
		end
		assert_equal'Invalid file', exc.message
	end
	
	#test of iterererer
	#def test_iter_next 
	#	s, i = iter_next("012345|789", 0, '|')
	#	assert_equal "012345", s
	#	assert_equal 7, i
	#end
	
	#test of verify pipes
	def test_verify_pipes 
		assert verify_pipes("||||")
		assert_output "Expected 4 pipes, but there are 3\n" do
			assert !verify_pipes("|||")
		end
	end
	
	#test of hashing a char
	def test_hash_char 
		mem = Hash.new
		hashed = hash_char('A', mem)
		
		x = 65
		test = ((x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)) % 65536
		assert_equal test, hashed  
	end
	
	#test of block_num
	def test_verify_block_num_true 
		ver = verify_block_num('1234567', 1234567)
		assert (ver)
		ver = verify_block_num('0', 0)
		assert (ver)
		# assert_equal 2, i
	end
	
	def test_verify_block_num_false 
		assert_output("Expected block number to be 4321, but is 1234\n") do
			assert (!verify_block_num('1234', 4321))
		end
		assert_output("Expected block number to be 1, but is invalid block number: garbage\n") do
			assert (!verify_block_num('garbage', 1))
		end
	end
	
	#test of previous hash rightness
	def test_prev_hash_true 
		assert verify_prev_hash("beef", "beef")
	end
	
	def test_prev_hash_false
		assert_output ("Expected the previous hash to be beef, but is dead\n") do
			verify_prev_hash("dead", "beef")
		end
	end
	
	#testing hash line
	def test_hash_line
		s = '0|0|SYSTEM>Henry(100)|1518892051.737141000'
		mem = {}
		assert_equal '1c12', hash_line(s, mem).to_s(16)
		s = '1|1c12|SYSTEM>George(100)|1518892051.740967000'
		assert_equal 'abb2', hash_line(s, mem).to_s(16)
	end
	
	#testing parsing a transaction
	def test_parse_tr_valid
		stuff = parse_tr('Bob>Chuck(1)')
		assert_equal ['Bob', 'Chuck', 1], stuff
		stuff = parse_tr('foo>bar(123456)')
		assert_equal ['foo', 'bar', 123456], stuff
	end
	
	def test_parse_tr_invalid
		assert_output ("Transaction error: Expected name1>name2(x), but have foobar\n") do
			refute parse_tr('foobar')
		end
	end
	
	def test_pars_tr_par
		assert_output ("Transaction error: Expected a ( somewhere, but have foo>bar1414)\n") do 
			refute parse_tr('foo>bar1414)')
		end
		assert_output ("Transaction error: Expected a ) somewhere, but have foo>bar(123\n") do 
			refute parse_tr('foo>bar(123')
		end 
	end
	
	def test_pars_tr_invalid_value
		assert_output ("Transaction error: Expected an int in () but have foo\n") do
			refute parse_tr('foo>bar(foo)')
		end
	end
	
	#tesing verify transaction
	def test_ver_tr 
		hist = Hash.new(0)
		assert ver_tr('foo>bar(100)', hist, false)
		test = {'bar'=>100, 'foo'=>-100}
		assert_equal test, hist
		
		hist = Hash.new(0)
		assert ver_tr('SYSTEM>foo(100)', hist, true)
		test = {'foo'=> 100}
		assert_equal test, hist
	end
	
	def test_ver_tr_no_sys
		hist = Hash.new(0)
		assert_output ("There is no SYSTEM giving\n") do
			refute ver_tr('foo>bar(10)', hist, true)
		end
	end
end

