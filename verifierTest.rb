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
	
	
}