require "pry"
require "colorize"
require './print.rb'

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

	def save_to_txt(array,file)
		name = "#{file}_results.txt"
		IO.write(name,array.join("\n"))    
	end

	def check_movements_txt(file)
		array_results = []
		array_movements = IO.read(file).split("\n")     
		array_movements.each do |coord|
			coord = coord.split(" ")
			Print.coord(coord[0],coord[1])
			result = move_letters(coord[0],coord[1])
			if result == true
				Print.legal
				array_results.push("LEGAL")
			elsif result == false
				Print.ilegal
				array_results.push("ILEGAL")
			elsif result == "empty"
				Print.empty
				array_results.push("EMPTY")
			elsif result == "occupied"
				Print.occupied
				array_results.push("OCCUPIED")
			end
		end
		save_to_txt(array_results,file)
	end

	def move_letters(origin_coord, target_cord)

		origin_coord = converter(origin_coord)
		target_cord = converter(target_cord)
		move(origin_coord, target_cord)

	end
	
	def move(origin_coord, target_cord)

		piece_to_move = check_status(origin_coord)
		if piece_to_move != nil && check_target(target_cord) == true

			case piece_to_move
			when :bR, :wR
				Rook.new.move_valid(origin_coord, target_cord)
			when :bB, :wB
				Bishop.new.move_valid(origin_coord, target_cord) 
			when :bQ, :wQ
				Queen.new.move_valid(origin_coord, target_cord)
			when :bK, :wK
				King.new.move_valid(origin_coord, target_cord)
			when :bP
				Pawn.new.move_valid(origin_coord, target_cord, "black") 
			when :wP
				Pawn.new.move_valid(origin_coord, target_cord, "white") 
			when :bN, :wN
				Horse.new.move_valid(origin_coord, target_cord) 
			end

		elsif piece_to_move == nil
			result = "empty"
		else
			result = "occupied"
		end
		
	end

	def check_status(origin_coord)
		@board.array_board[origin_coord[0]][origin_coord[1]]
	end

	def check_target(target_cord)
		@board.array_board[target_cord[0]][target_cord[1]] == nil ? true : false;
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
		a.abs == b.abs ? true : false;
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
			origin_coord[0] == 6 ? direction = 2 : direction = 1;
			if origin_coord[0] - target_cord[0] <= direction && origin_coord[1] == target_cord[1]
				true
			else
				false
			end
		when "black"
			origin_coord[0] == 1 ? direction = -2 : direction = -1;
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
			b.abs == 1 ? true : false;
		elsif b.abs == 2
			a.abs == 1 ? true : false;
		else
			false
		end
	end

end


board1 = Board.new
complex_board = [
			[:bK,nil,nil,nil,nil,:bB,nil,nil],
			[nil,nil,nil,nil,nil,:bP,nil,nil],
			[nil,:bP,:wR,nil,:wB,nil,:bN,nil],
			[:wN,nil,:bP,:bR,nil,nil,nil,:wP],
			[nil,nil,nil,nil,:wK,:wQ,nil,:wP],
			[:wR,nil,:bB,:wN,:wP,nil,nil,nil],
			[nil,:wP,:bQ,nil,nil,:wP,nil,nil],
			[nil,nil,nil,nil,nil,:wB,nil,nil]
		]
board1.create_board(complex_board)


validator_for_board1 = Validator.new(board1)
#validator_for_board1.move([1,0],[2,1])
validator_for_board1.check_movements_txt("complex_moves.txt")
#validator_for_board1.move_letters("e4","d8")
#validator_for_board1.converter("c7")