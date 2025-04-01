extends Node

const GRID_SIZE := 64
const GAME_OVER_SCENE := preload('res://scenes/game_over.tscn')


var current_tabletop: Tabletop

func hero_died(_hero: Unit):
    var all_died = current_tabletop.get_players().all(func(p: Unit): return p.health_points <= 0)
    if all_died:
        get_tree().change_scene_to_packed(GAME_OVER_SCENE)
    