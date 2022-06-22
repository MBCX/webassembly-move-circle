const circle = document.querySelector("#circle");
let last_time;

document.addEventListener("DOMContentLoaded", async function() {
   const file = await WebAssembly.instantiateStreaming(
        await window.fetch(
            "WASM/main.wasm", {
                headers: {
                    "Content-Type": "application/wasm"
                }
            },
        ),
        {console}
    );
    const wasm = file.instance.exports;

    const box = circle.getBoundingClientRect();
    const pos = {
        left: Math.floor(box.left),
        right: Math.floor(box.right),
        top: Math.floor(box.top),
        bottom: Math.floor(box.bottom),
    };

    wasm.init_circle_pos(pos.left);

    function updateCirclePos()
    {
        circle.style.left = wasm.get_pos_x() + "px";
    }

    function update(time)
    {
        if (last_time != null)
        {
            const delta = time - last_time;

            // First WASM functions.
            wasm.game_loop(delta);
            wasm.set_window_wh(window.innerWidth, window.innerHeight);
    
            // Regular JS functions.
            updateCirclePos();
        }
        last_time = time;
        window.requestAnimationFrame(update);
    }
    window.requestAnimationFrame(update);
});