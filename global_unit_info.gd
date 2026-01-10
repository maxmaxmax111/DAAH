extends Node3D

@export var demon_admiral_portrait: CompressedTexture2D
@export var angel_admiral_portrait: CompressedTexture2D
@export var alien_admiral_portrait: CompressedTexture2D
@export var human_admiral_portrait: CompressedTexture2D

#universal vars (same across all races)
@export var pawn_supply: int = 1
@export var knight_supply: int = 2
@export var bishop_supply: int = 3
@export var rook_supply: int = 5
@export var queen_supply: int = 9

@export var pawn_size: int = 1
@export var knight_size: int = 1
@export var bishop_size: int = 1
@export var rook_size: int = 2
@export var queen_size: int = 3

#race specific vars
@export var demon_pawn_portrait: CompressedTexture2D
@export var demon_pawn_supply: int
@export var demon_pawn_size: int
@export var demon_pawn_name: String
@export var demon_pawn_instance: Node3D

@export var demon_knight_portrait: CompressedTexture2D
@export var demon_knight_supply: int
@export var demon_knight_size: int
@export var demon_knight_name: String
@export var demon_knight_instance: Node3D

@export var demon_bishop_portrait: CompressedTexture2D
@export var demon_bishop_supply: int
@export var demon_bishop_size: int
@export var demon_bishop_name: String
@export var demon_bishop_instance: Node3D

@export var demon_rook_portrait: CompressedTexture2D
@export var demon_rook_supply: int
@export var demon_rook_size: int
@export var demon_rook_name: String
@export var demon_rook_instance: Node3D

@export var demon_queen_portrait: CompressedTexture2D
@export var demon_queen_supply: int
@export var demon_queen_size: int
@export var demon_queen_name: String
@export var demon_queen_instance: Node3D

@export var angel_pawn_portrait: CompressedTexture2D
@export var angel_pawn_supply: int
@export var angel_pawn_size: int
@export var angel_pawn_name: String
@export var angel_pawn_instance: Node3D

@export var angel_knight_portrait: CompressedTexture2D
@export var angel_knight_supply: int
@export var angel_knight_size: int
@export var angel_knight_name: String
@export var angel_knight_instance: Node3D

@export var angel_bishop_portrait: CompressedTexture2D
@export var angel_bishop_supply: int
@export var angel_bishop_size: int
@export var angel_bishop_name: String
@export var angel_bishop_instance: Node3D

@export var angel_rook_portrait: CompressedTexture2D
@export var angel_rook_supply: int
@export var angel_rook_size: int
@export var angel_rook_name: String
@export var angel_rook_instance: Node3D

@export var angel_queen_portrait: CompressedTexture2D
@export var angel_queen_supply: int
@export var angel_queen_size: int
@export var angel_queen_name: String
@export var angel_queen_instance: Node3D

@export var alien_pawn_portrait: CompressedTexture2D
@export var alien_pawn_supply: int
@export var alien_pawn_size: int
@export var alien_pawn_name: String
@export var alien_pawn_instance: Node3D

@export var alien_knight_portrait: CompressedTexture2D
@export var alien_knight_supply: int
@export var alien_knight_size: int
@export var alien_knight_name: String
@export var alien_knight_instance: Node3D

@export var alien_bishop_portrait: CompressedTexture2D
@export var alien_bishop_supply: int
@export var alien_bishop_size: int
@export var alien_bishop_name: String
@export var alien_bishop_instance: Node3D

@export var alien_rook_portrait: CompressedTexture2D
@export var alien_rook_supply: int
@export var alien_rook_size: int
@export var alien_rook_name: String
@export var alien_rook_instance: Node3D

@export var alien_queen_portrait: CompressedTexture2D
@export var alien_queen_supply: int
@export var alien_queen_size: int
@export var alien_queen_name: String
@export var alien_queen_instance: Node3D

@export var human_pawn_portrait: CompressedTexture2D
@export var human_pawn_supply: int
@export var human_pawn_size: int
@export var human_pawn_name: String
@export var human_pawn_instance: Node3D

@export var human_knight_portrait: CompressedTexture2D
@export var humandemon_knight_supply: int
@export var human_knight_size: int
@export var human_knight_name: String
@export var human_knight_instance: Node3D

@export var human_bishop_portrait: CompressedTexture2D
@export var human_bishop_supply: int
@export var human_bishop_size: int
@export var human_bishop_name: String
@export var human_bishop_instance: Node3D

@export var human_rook_portrait: CompressedTexture2D
@export var human_rook_supply: int
@export var human_rook_size: int
@export var human_rook_name: String
@export var human_rook_instance: Node3D

@export var human_queen_portrait: CompressedTexture2D
@export var humandemon_queen_supply: int
@export var human_queen_size: int
@export var human_queen_name: String
@export var human_queen_instance: Node3D