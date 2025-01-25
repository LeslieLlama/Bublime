extends Node


signal bubble_collected(position : Vector2)

signal new_room_entered(area2d : Area2D, roomname : String)
signal popup_message(textToSay : String, pos : Vector2, textColour : Color)
signal player_damaged(direction_to_push : Vector2)
signal get_player(player : CharacterBody2D)
