require 'minitest/autorun'
require_relative 'VerifierMethods.rb'

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
		hashed, mem = hash_char('A', mem)
		
		x = 65
		test = ((x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)) % 65536
		assert_equal test, hashed  
	end
	
	#test of block_num
	def test_verify_block_num_true 
		ver, i = verify_block_num('1234567|garbage!', 1234567)
		assert (ver)
		assert_equal 8, i
		ver, i = verify_block_num('0|||||', 0)
		assert (ver)
		assert_equal 2, i
	end
	
	def test_verify_block_num_false 
		assert_output("Expected block number to be 4321, but is 1234\n") do
			assert (!verify_block_num('1234||', 4321))
		end
		assert_output("Expected block number to be 1, but is invalid block number: garbage\n") do
			assert (!verify_block_num('garbage|||', 1))
		end
	end
	
	#test of previous hash rightness
	def test_prev_hash_true 
		assert verify_prev_hash("beef", "beef")
	end
	
	def test_prev_hash_false
		assert_output "Expected the previous hash to be beef, but is dead") do
			verify_prev_hash("dead", "beef")
		end
	end
	
	

end

