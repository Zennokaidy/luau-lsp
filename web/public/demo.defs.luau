-- PixelForge Studio — Luau API definitions for luau-lsp
-- Covers: screen, keyboard, mouse, touch, gamepad, system, storage, audio,
-- asset_manager, gfx3d, PForgeImage/Sprite/Map/Sound, registries,
-- lifecycle hooks, threading helpers, math helpers and the multiplayer API.

-- ============================================================
-- screen — 2D drawing (origin at center, 1 unit = 100px)
-- ============================================================
declare screen: {
    width: number,
    height: number,
    clear: (color: string?) -> (),
    setColor: (color: string) -> (),
    setAlpha: (a: number) -> (),
    setBlending: (mode: string) -> (),
    setFont: (font: string) -> (),
    setTranslation: (x: number, y: number) -> (),
    setScale: (x: number, y: number) -> (),
    setRotation: (r: number) -> (),
    setDrawAnchor: (x: number, y: number) -> (),
    setDrawRotation: (r: number) -> (),
    setDrawScale: (x: number, y: number) -> (),
    setPixelated: (p: boolean) -> (),
    setLineWidth: (w: number) -> (),
    setLineDash: (d: {number}) -> (),
    setCursorVisible: (v: boolean) -> (),
    fillRect: (x: number, y: number, w: number, h: number, color: string?) -> (),
    drawRect: (x: number, y: number, w: number, h: number, color: string?) -> (),
    fillRoundRect: (x: number, y: number, w: number, h: number, r: number, color: string?) -> (),
    drawRoundRect: (x: number, y: number, w: number, h: number, r: number, color: string?) -> (),
    fillRound: (x: number, y: number, w: number, h: number, color: string?) -> (),
    drawRound: (x: number, y: number, w: number, h: number, color: string?) -> (),
    drawSprite: (name: string, x: number, y: number, w: number, h: number?) -> (),
    drawText: (text: string, x: number, y: number, size: number, color: string?) -> (),
    textWidth: (text: string, size: number) -> number,
    drawLine: (x1: number, y1: number, x2: number, y2: number) -> (),
}

-- ============================================================
-- keyboard
-- ============================================================
declare keyboard: {
    A: number, W: number, S: number, D: number,
    UP: number, DOWN: number, LEFT: number, RIGHT: number,
    SPACE: number, ENTER: number, SHIFT: number, CTRL: number,
    ALT: number, ESCAPE: number, TAB: number, BACKSPACE: number,
    press: {[string]: number},
    release: {[string]: number},
}

-- ============================================================
-- mouse
-- ============================================================
declare mouse: {
    x: number,
    y: number,
    pressed: number,
    left: number,
    middle: number,
    right: number,
    press: number,
    release: number,
    wheel: number,
}

-- ============================================================
-- touch
-- ============================================================
declare touch: {
    touching: number,
    press: number,
    release: number,
    x: number,
    y: number,
    touches: {any},
}

-- ============================================================
-- gamepad
-- ============================================================
declare gamepad: {
    A: number, B: number, X: number, Y: number,
    LB: number, RB: number, LT: number, RT: number,
}

-- ============================================================
-- system
-- ============================================================
declare system: {
    time: () -> number,
    language: string,
    say: (text: string) -> (),
    pause: () -> (),
    exit: () -> (),
    prompt: (text: string, cb: ((boolean, string) -> ())?) -> (),
    file: {
        save: (obj: any, name: string, format: string?, quality: number?) -> (),
        load: (path: string) -> (),
    },
}

-- ============================================================
-- storage
-- ============================================================
declare storage: {
    get: (name: string, default: any?) -> any,
    set: (name: string, value: any) -> (),
}

-- ============================================================
-- audio
-- ============================================================
declare audio: {
    beep: (sequence: string) -> (),
    cancelBeeps: () -> (),
    playSound: (name: string, loop: boolean?) -> {
        setVolume: (v: number) -> (),
        setPitch: (p: number) -> (),
        setPan: (p: number) -> (),
        getDuration: () -> number,
        stop: () -> (),
    },
    playMusic: (name: string) -> {
        setVolume: (v: number) -> (),
        stop: () -> (),
        play: () -> (),
        getDuration: () -> number,
        getPosition: () -> number,
        setPosition: (p: number) -> (),
    },
}

-- ============================================================
-- asset_manager
-- ============================================================
declare asset_manager: {
    loadFont: (path: string) -> (),
    loadImage: (path: string, cb: ((PForgeImage?) -> ())?) -> any,
    loadJSON: (path: string, cb: ((any) -> ())?) -> any,
    loadText: (path: string, cb: ((string?) -> ())?) -> any,
    loadCSV: (path: string, cb: ((string?) -> ())?) -> any,
    loadMarkdown: (path: string, cb: ((string?) -> ())?) -> any,
    loadModel: (path: string) -> (),
    wasmInstance: (name: string) -> any,
}

-- ============================================================
-- gfx3d
-- ============================================================
declare gfx3d: {
    init: (opts: {background: number?, fov: number?, near: number?, far: number?}?) -> (),
    addLight: (type: string, opts: {color: number?, intensity: number?, position: {number}?, groundColor: number?}?) -> any,
    addBox: (name: string, opts: {size: {number}?, color: number?, position: {number}?, wireframe: boolean?}?) -> any,
    addSphere: (name: string, opts: {radius: number?, color: number?, position: {number}?}?) -> any,
    addPlane: (name: string, opts: {width: number?, height: number?, color: number?, position: {number}?, rotationX: number?}?) -> any,
    addCylinder: (name: string, opts: {radiusTop: number?, radiusBottom: number?, height: number?, color: number?, position: {number}?}?) -> any,
    addCone: (name: string, opts: {radius: number?, height: number?, color: number?, position: {number}?}?) -> any,
    addTorus: (name: string, opts: {radius: number?, tube: number?, color: number?, position: {number}?}?) -> any,
    get: (name: string) -> any,
    remove: (name: string) -> (),
    setCamera: (opts: {position: {number}?, lookAt: {number}?, fov: number?}) -> (),
    moveCamera: (dx: number, dy: number, dz: number) -> (),
    render: () -> (),
    rotate: (name: string, rx: number, ry: number, rz: number) -> (),
    translate: (name: string, dx: number, dy: number, dz: number) -> (),
    setPosition: (name: string, x: number, y: number, z: number) -> (),
    setColor: (name: string, color: number) -> (),
    getDelta: () -> number,
}

-- ============================================================
-- PForgeImage
-- ============================================================
declare class PForgeImage
    new: (width: number, height: number, centered: boolean?) -> PForgeImage
    width: number
    height: number
    clear: (self: PForgeImage, color: string?) -> ()
    setRGB: (self: PForgeImage, x: number, y: number, r: number, g: number, b: number) -> ()
    setRGBA: (self: PForgeImage, x: number, y: number, r: number, g: number, b: number, a: number) -> ()
    getRGB: (self: PForgeImage, x: number, y: number) -> {r: number, g: number, b: number}
    getRGBA: (self: PForgeImage, x: number, y: number) -> {r: number, g: number, b: number, a: number}
    setColor: (self: PForgeImage, c: string) -> ()
    setAlpha: (self: PForgeImage, a: number) -> ()
    setBlending: (self: PForgeImage, b: string) -> ()
    setFont: (self: PForgeImage, f: string) -> ()
    setPixelated: (self: PForgeImage, p: boolean) -> ()
    setLineWidth: (self: PForgeImage, w: number) -> ()
    setLineDash: (self: PForgeImage, d: {number}) -> ()
    fillRect: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> ()
    drawRect: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> ()
    fillRound: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> ()
    drawRound: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> ()
    fillRoundRect: (self: PForgeImage, x: number, y: number, w: number, h: number, r: number, color: string?) -> ()
    drawRoundRect: (self: PForgeImage, x: number, y: number, w: number, h: number, r: number, color: string?) -> ()
    drawLine: (self: PForgeImage, x1: number, y1: number, x2: number, y2: number) -> ()
    drawSprite: (self: PForgeImage, name: string, x: number, y: number, w: number, h: number?) -> ()
    drawImage: (self: PForgeImage, image: PForgeImage, x: number, y: number, w: number, h: number?) -> ()
    drawText: (self: PForgeImage, text: string, x: number, y: number, size: number, color: string?) -> ()
    textWidth: (self: PForgeImage, text: string, size: number) -> number
end

-- ============================================================
-- PForgeSprite
-- ============================================================
declare class PForgeSprite
    new: (frames: {PForgeImage}?) -> PForgeSprite
    frames: {PForgeImage}
    fps: number
    setFPS: (self: PForgeSprite, fps: number) -> ()
    setFrame: (self: PForgeSprite, n: number) -> ()
end

-- ============================================================
-- PForgeMap
-- ============================================================
declare class PForgeMap
    new: (width: number, height: number, tileWidth: number, tileHeight: number) -> PForgeMap
    width: number
    height: number
    tileWidth: number
    tileHeight: number
    data: {any}
    get: (self: PForgeMap, x: number, y: number) -> any
    set: (self: PForgeMap, x: number, y: number, val: any) -> ()
end

-- ============================================================
-- PForgeSound
-- ============================================================
declare class PForgeSound
    new: (channels: number, length: number, sampleRate: number) -> PForgeSound
    write: (self: PForgeSound, ch: number, idx: number, val: number) -> ()
    read: (self: PForgeSound, ch: number, idx: number) -> number
    play: (self: PForgeSound) -> ()
end

-- ============================================================
-- Registries
-- ============================================================
declare sprites: {[string]: PForgeSprite}
declare maps: {[string]: PForgeMap}
declare sounds: {[string]: PForgeSound}
declare music: {[string]: PForgeSound}

-- ============================================================
-- Lifecycle hooks
-- ============================================================
declare onInit: (fn: () -> ()) -> ()
declare onUpdate: (fn: (dt: number, frame: number) -> ()) -> ()
declare onDraw: (fn: () -> ()) -> ()

-- ============================================================
-- Threading helpers
-- ============================================================
declare after: (seconds: number, action: () -> ()) -> any
declare every: (seconds: number, action: () -> ()) -> any
declare do_: (action: () -> ()) -> any
declare sleep: (seconds: number) -> ()

-- ============================================================
-- Math / time helpers
-- ============================================================
declare seconds: (n: number) -> number
declare milliseconds: (n: number) -> number
declare sind: (x: number) -> number
declare cosd: (x: number) -> number
declare tand: (x: number) -> number
declare asind: (x: number) -> number
declare acosd: (x: number) -> number
declare atand: (x: number) -> number
declare atan2d: (y: number, x: number) -> number

-- ============================================================
-- Multiplayer
-- ============================================================
declare class Server
    new: (room: string?) -> Server
    room: string
    new_connections: {any}
    active_connections: {any}
    messages: {any}
    closed_connections: {any}
    stop: (self: Server) -> ()
end

declare class ServerConnection
    new: (room: string?) -> ServerConnection
    status: string
    messages: {any}
    send: (self: ServerConnection, data: any) -> ()
    disconnect: (self: ServerConnection) -> ()
end
