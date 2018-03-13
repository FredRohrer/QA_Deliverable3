require_relative 'VerifierMethods.rb'

unless ARGV.length == 1
	abort "Invalid command line argument"

end

f = getFile(ARGV[0]) 

block = f.read
tr_hist = Hash.new(0) 
if ver_all(tr_hist, block)
	tr_hist.each {|key, value| 
		puts "#{key} has #{value} Billcoins!"
	}
end