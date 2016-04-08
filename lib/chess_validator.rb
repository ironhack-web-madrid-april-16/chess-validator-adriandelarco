class Board
	attr_reader :array_board

	def initialize
		@array_board = []
	end

	def create_board(array)
		@array_board = array
	end
	
	def create_basic_board
		@array_board = [
			[:bR,:bN,:bB,:bQ,:bK,:bB,:bN,:bR],
			[:bP,:bP,:bP,:bP,:bP,:bP,:bP,:bP],
			[nil,nil,nil,nil,nil,nil,nil,nil],
			[nil,nil,nil,nil,nil,nil,nil,nil],
			[nil,nil,nil,nil,nil,nil,nil,nil],
			[nil,nil,nil,nil,nil,nil,nil,nil],
			[:wP,:wP,:wP,:wP,:wP,:wP,:wP,:wP],
			[:wR,:wN,:wB,:wQ,:wK,:wB,:wN,:wR]
		]
	end

end

class Validator

	def initialize(board)
		@board = board
	end

	def check_movements_txt(file)
		array_movements = IO.read(file).split("\n")     
		array_movements.each do |coord|
			coord = coord.split(" ")
			move_letters(coord[0],coord[1])
		end
	end

	def move_letters(origin_coord, target_cord)

		origin_coord = converter(origin_coord)
		target_cord = converter(target_cord)
		move(origin_coord, target_cord)
		#puts origin_coord 
		#puts target_cord
	end
	
	def move(origin_coord, target_cord)

		piece_to_move = check_status(origin_coord)
		if piece_to_move != nil && check_target(target_cord) == true

			case piece_to_move
			when :bR || :wR
				puts Rook.new.move_valid(origin_coord, target_cord)
			when :bB || :wB
				puts Bishop.new.move_valid(origin_coord, target_cord)
			when :bQ || :wQ
				puts Queen.new.move_valid(origin_coord, target_cord)
			when :bK || :wK
				puts King.new.move_valid(origin_coord, target_cord)
			when :bP
				puts Pawn.new.move_valid(origin_coord, target_cord, "black")
			when :wP
				puts Pawn.new.move_valid(origin_coord, target_cord, "white")
			when :bN || :wN
				puts Horse.new.move_valid(origin_coord, target_cord)
			end

		else

			puts "false"
			
		end
		
	end

	def check_status(origin_coord)
		@board.array_board[origin_coord[0]][origin_coord[1]]
	end

	def check_target(target_cord)

		if @board.array_board[target_cord[0]][target_cord[1]] == nil
			true
		end

	end

	def converter(coord)
		coord_converted = []
		coord_converted[0] = 8 - coord[1].to_i
		array_n = ("a".."h").to_a
		array_n.each_with_index do |letter, index|
			if coord[0] == letter
				coord_converted[1] = index
			end
			
		end
		coord = [coord_converted[0],coord_converted[1]]
		coord
	end


end

class Rook

	def move_valid(origin_coord, target_cord)
		if origin_coord[0] == target_cord[0] || origin_coord[1] == target_cord[1]
			true
		else
			false
		end
	end

end

class Bishop
	
	def move_valid(origin_coord, target_cord)
		a = origin_coord[0] - target_cord[0]
		b = origin_coord[1] - target_cord[1]

		if a.abs == b.abs
			true
		else
			false
		end
	end

end

class Queen

	def move_valid(origin_coord, target_cord)
		valid_for_rook = Rook.new.move_valid(origin_coord,target_cord)
		valid_for_bishop = Bishop.new.move_valid(origin_coord,target_cord)
		if valid_for_bishop == true || valid_for_rook == true
			true
		else
			false
		end
	end

end

class King

	def move_valid(origin_coord, target_cord)
		valid_for_queen = Queen.new.move_valid(origin_coord,target_cord)
		a = origin_coord[0] - target_cord[0]
		b = origin_coord[1] - target_cord[1]

		if valid_for_queen == true && a.abs <= 1 && b.abs <= 1
			true
		else
			false
		end
	end

end

class Pawn

	def move_valid(origin_coord, target_cord, color)
		
		case color
		when "white"
			if origin_coord[0] == 6
				direction = 2
			else
				direction = 1
			end
			if origin_coord[0] - target_cord[0] <= direction && origin_coord[1] == target_cord[1]
				true
			else
				false
			end
		when "black"
			if origin_coord[0] == 1
				direction = -2
			else
				direction = -1
			end
			if origin_coord[0] - target_cord[0] >= direction && origin_coord[1] == target_cord[1]
				true
			else
				false
			end
		end
		
	end

end

class Horse

	def move_valid(origin_coord, target_cord)
		
		a = origin_coord[0] - target_cord[0]
		b = origin_coord[1] - target_cord[1]

		if a.abs == 2
			if b.abs == 1
				true
			else
				false
			end
		elsif b.abs == 2
			if a.abs == 1
				true
			else
				false
			end
		end
	end

end




board1 = Board.new
complex_board = [
			[:bK,:nil,:nil,:nil,:nil,:bB,:nil,:nil],
			[:nil,:nil,:nil,:nil,:nil,:bP,:nil,:nil],
			[nil,:bP,:wR,nil,:wB,nil,:bN,nil],
			[:wN,nil,:bP,:bR,nil,nil,nil,:wP],
			[nil,nil,nil,nil,:wK,:wQ,nil,:wP],
			[:wR,nil,:bB,:wN,:wP,nil,nil,nil],
			[nil,:wP,:bQ,nil,nil,:wP,nil,nil],
			[nil,nil,nil,nil,nil,:wB,nil,nil]
		]
board1.create_board(complex_board)

#board1.move([1,0],[2,1])
validator_for_board1 = Validator.new(board1)
validator_for_board1.check_movements_txt("complex_moves.txt")
#board1.move_letters("a7","b6")
#board1.converter("c7")