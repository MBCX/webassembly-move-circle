;; main.wat
;;
;; Author: MBCX
;; Date: 16/06/2022

(module
    ;; Import JS functions.
    (import "console" "log" (func $log (param i32)))

    ;; Global circle variables.
    (global $circle_left (mut i32) (i32.const 0))

    ;; 0 -> Disable debug mode.
    ;; 1 -> Enable debug mode.
    (global $debug_mode (mut i32) (i32.const 1))

    ;; Internal game clock
    ;; and delta time.
    (global $game_tick (mut i32) (i32.const 0))
    (global $game_delta (mut f32) (f32.const 0.0))

    ;; window screen wh
    (global $screen_w (mut i32) (i32.const 0))
    (global $screen_h (mut i32) (i32.const 0))


    ;; ----- Util functions -----

    ;; Set cirlce positions (values set by JavaScript).
    (func $init_circle_pos (param $left i32)
        local.get $left
        global.get $circle_left
        i32.add
        global.set $circle_left

        call $is_debug ;; Check if debug mode is enabled.
        if
            global.get $circle_left
            call $log
        end
    )

    ;; Detect if debug mode is enabled
    ;; or not.
    (func $is_debug (result i32)
        i32.const 1
        global.get $debug_mode
        i32.eq
        if
            i32.const 1
            return
        end
        i32.const 0
        return
    )

    ;; Update internal game tick.
    (func $update_tick
        global.get $game_tick
        i32.const 1
        i32.add
        global.set $game_tick
    )

    ;; Getters
    (func $get_pos_x (result i32)
        global.get $circle_left
    )

    (func $get_dt (result f32)
        global.get $game_delta
    )

    ;; Setters
    (func $set_window_wh (param $w i32) (param $h i32)
        ;; Reset values.
        global.get $screen_w
        global.get $screen_w
        i32.sub
        global.set $screen_w

        global.get $screen_h
        global.get $screen_h
        i32.sub
        global.set $screen_h

        ;; Set new values.
        local.get $w
        global.get $screen_w
        i32.add
        global.set $screen_w

        local.get $h
        global.get $screen_h
        i32.add
        global.set $screen_h
    )

    (func $set_dt (param $dt_time f32)
        global.get $game_delta
        global.get $game_delta
        f32.sub
        global.set $game_delta
        
        global.get $game_delta
        local.get $dt_time
        f32.add
        global.set $game_delta
    )
    ;; ----- / Util functions -----


    ;; ----- Update functions -----

    (func $update_circle_pos
        (local $dt f32)

        call $get_dt
        local.set $dt

        global.get $circle_left
        i32.const 1
        i32.add
        global.set $circle_left

        ;; Check if circle is offscreen.
        global.get $circle_left
        global.get $screen_w
        i32.gt_u
        if
            global.get $circle_left
            global.get $circle_left
            i32.sub
            global.set $circle_left
        end
    )

    ;; ----- /Update functions -----

    ;; Main game-loop
    (func $game_loop (param $dt f32)
        local.get $dt
        call $set_dt
        call $update_tick
        call $update_circle_pos
    )

    ;; Export functions to be used by JS.
    (export "init_circle_pos" (func $init_circle_pos))
    (export "game_loop" (func $game_loop))

    ;; Getter exports.
    (export "get_pos_x" (func $get_pos_x))

    ;; Setter exports.
    (export "set_window_wh" (func $set_window_wh))
)