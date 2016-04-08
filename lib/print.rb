module Print

	def Print.legal
		puts "LEGAL".green
	end

	def Print.ilegal
		puts "ILEGAL".red
	end

	def Print.empty
		puts "No piece here.".yellow
	end

	def Print.occupied
		puts "Ocupied".yellow
	end

	def Print.coord(orig_coord, target_coord)
		print "#{orig_coord} => #{target_coord}: ".blue
	end

	def Print.a
		puts ""
	end

end