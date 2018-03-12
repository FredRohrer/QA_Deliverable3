require 'minitest/autorun'
require_relative 'verifier.rb'

class verifierTest {

	def test_get_ok_File {
		test_block = getFile("verifier.rb")
		assert_kind_of(File, test_block)
	}
	
	def test_get_bad_File {
		exc = assert_raises RuntimeError {
			getFile("")
		}
		assert_equal('Invalid file', exc.message) 
	}
	
	
	def test_iter_next {
		s, i = iter_next("012345|789", 0, '|')
		assert_equal (s, "012345")
		assert_equal (i, 7)
	}
	
	
	def test_verify_pipes {
		assert (verify_pipes("||||")
		assert_output("Expected 4 pipes, but there are 3") { 
			assert (!verify_pipes("|||")
		}
	}
	
	
	def test_hash_char {
		mem = Hash.new
		
		assert_equal (hash_char('|'), 0) 
	}
	
	
	def test_verify_block_num_true {
		bool, i = verify_block_num('1234567|garbage!', 1234567)
		assert (bool)
		assert_equal (i, 8) 
		bool, i = verify_block_num('0|||||', 0)
		assert (bool)
		assert_equal (i, 2)
	}
	
	def test_verify_block_num_false {
		assert_output("Expected 4322, but got 1234") {
			assert (!verify_block_num('1234||', 4321))
		}
		assert_output("Expected 2, but got invalid block number: garbage") {
			assert (!verify_block_num('garbage|||', 1))
		}
	}
	
	
	def test_verify_prev_hash_true {
		
	}
	

}
