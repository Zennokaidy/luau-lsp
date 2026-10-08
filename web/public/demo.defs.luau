-- PixelForge Studio — Luau API definitions for luau-lsp

-- ============================================================
-- STDLIB OVERRIDES
-- Sobrescreve math/buffer/vector pra incluir funções novas
-- que o LSP (de julho 2024) não conhece.
-- ============================================================

type Math = {
    abs: (n: number) -> number,
    acos: (n: number) -> number,
    asin: (n: number) -> number,
    atan: (n: number) -> number,
    atan2: (y: number, x: number) -> number,
    ceil: (n: number) -> number,
    clamp: (n: number, min: number, max: number) -> number,
    cos: (r: number) -> number,
    cosh: (r: number) -> number,
    deg: (r: number) -> number,
    exp: (n: number) -> number,
    floor: (n: number) -> number,
    fmod: (a: number, b: number) -> number,
    frexp: (n: number) -> (number, number),
    huge: number,
    ldexp: (m: number, e: number) -> number,
    lerp: (a: number, b: number, t: number) -> number,
    log: (n: number, base: number?) -> number,
    log10: (n: number) -> number,
    map: (x: number, inMin: number, inMax: number, outMin: number, outMax: number) -> number,
    max: (...number) -> number,
    min: (...number) -> number,
    modf: (n: number) -> (number, number),
    noise: (x: number, y: number?, z: number?) -> number,
    pi: number,
    pow: (a: number, b: number) -> number,
    rad: (d: number) -> number,
    random: (m: number?, n: number?) -> number,
    randomseed: (seed: number) -> (),
    round: (n: number) -> number,
    sign: (n: number) -> number,
    sin: (r: number) -> number,
    sinh: (r: number) -> number,
    sqrt: (n: number) -> number,
    tan: (r: number) -> number,
    tanh: (r: number) -> number,
    isnan: (n: number) -> boolean,
    isinf: (n: number) -> boolean,
    isfinite: (n: number) -> boolean,
}

type Buffer = {
    create: (size: number) -> any,
    fromstring: (s: string) -> any,
    tostring: (b: any) -> string,
    len: (b: any) -> number,
    copy: (target: any, targetOffset: number, source: any, sourceOffset: number?, count: number?) -> (),
    fill: (b: any, offset: number, value: number, count: number?) -> (),
    readi8: (b: any, offset: number) -> number,
    readu8: (b: any, offset: number) -> number,
    readi16: (b: any, offset: number) -> number,
    readu16: (b: any, offset: number) -> number,
    readi32: (b: any, offset: number) -> number,
    readu32: (b: any, offset: number) -> number,
    readf32: (b: any, offset: number) -> number,
    readf64: (b: any, offset: number) -> number,
    writei8: (b: any, offset: number, value: number) -> (),
    writeu8: (b: any, offset: number, value: number) -> (),
    writei16: (b: any, offset: number, value: number) -> (),
    writeu16: (b: any, offset: number, value: number) -> (),
    writei32: (b: any, offset: number, value: number) -> (),
    writeu32: (b: any, offset: number, value: number) -> (),
    writef32: (b: any, offset: number, value: number) -> (),
    writef64: (b: any, offset: number, value: number) -> (),
    readstring: (b: any, offset: number, count: number) -> string,
    writestring: (b: any, offset: number, value: string, count: number?) -> (),
    readbits: (b: any, bitOffset: number, bitCount: number) -> number,
    writebits: (b: any, bitOffset: number, bitCount: number, value: number) -> (),
}

type Vector3 = {
    x: number,
    y: number,
    z: number,
    magnitude: number,
    unit: Vector3,
    cross: (self: Vector3, other: Vector3) -> Vector3,
    dot: (self: Vector3, other: Vector3) -> number,
    angle: (self: Vector3, other: Vector3, axis: Vector3?) -> number,
    floor: (self: Vector3) -> Vector3,
    ceil: (self: Vector3) -> Vector3,
    abs: (self: Vector3) -> Vector3,
    sign: (self: Vector3) -> Vector3,
    clamp: (self: Vector3, min: Vector3, max: Vector3) -> Vector3,
    max: (self: Vector3, ...Vector3) -> Vector3,
    min: (self: Vector3, ...Vector3) -> Vector3,
    lerp: (self: Vector3, goal: Vector3, alpha: number) -> Vector3,
}

type VectorLib = {
    create: (x: number, y: number, z: number?) -> Vector3,
    zero: Vector3,
    one: Vector3,
    magnitude: (v: Vector3) -> number,
    normalize: (v: Vector3) -> Vector3,
    cross: (a: Vector3, b: Vector3) -> Vector3,
    dot: (a: Vector3, b: Vector3) -> number,
    angle: (a: Vector3, b: Vector3, axis: Vector3?) -> number,
    floor: (v: Vector3) -> Vector3,
    ceil: (v: Vector3) -> Vector3,
    abs: (v: Vector3) -> Vector3,
    sign: (v: Vector3) -> Vector3,
    clamp: (v: Vector3, min: Vector3, max: Vector3) -> Vector3,
    max: (...Vector3) -> Vector3,
    min: (...Vector3) -> Vector3,
    lerp: (a: Vector3, b: Vector3, t: number) -> Vector3,
}

declare math: Math
declare buffer: Buffer
declare vector: VectorLib

-- ============================================================
-- TIPOS BASE (PixelForge)
-- ============================================================
type Screen = {
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
    drawLine: (x1: number, y1: number, x2: number, y2: number) -> (),
    drawArc: (x: number, y: number, r: number, a1: number, a2: number, ccw: boolean, color: string?) -> (),
    fillArc: (x: number, y: number, r: number, a1: number, a2: number, ccw: boolean, color: string?) -> (),
    drawPolygon: (...number) -> (),
    drawPolyline: (...number) -> (),
    fillPolygon: (...number) -> (),
    drawText: (text: string, x: number, y: number, size: number, color: string?) -> (),
    drawTextOutline: (text: string, x: number, y: number, size: number, color: string?) -> (),
    textWidth: (text: string, size: number) -> number,
    setLinearGradient: (x1: number, y1: number, x2: number, y2: number, c1: string, c2: string) -> (),
    setRadialGradient: (x: number, y: number, radius: number, c1: string, c2: string) -> (),
    drawSprite: (name: string, x: number, y: number, w: number, h: number?) -> (),
    drawSpritePart: (name: string, px: number, py: number, pw: number, ph: number, x: number, y: number, w: number, h: number?) -> (),
    drawImage: (image: PForgeImage, x: number, y: number, w: number, h: number?) -> (),
    drawImagePart: (image: PForgeImage, px: number, py: number, pw: number, ph: number, x: number, y: number, w: number, h: number?) -> (),
    drawMap: (name: string, x: number, y: number, w: number, h: number?) -> (),
}

type Keyboard = {
    A: number, W: number, S: number, D: number,
    SPACE: number, ENTER: number, SHIFT: number, CTRL: number,
    ALT: number, ESCAPE: number, TAB: number, BACKSPACE: number,
    LEFT: number, RIGHT: number, UP: number, DOWN: number,
    press: { [string]: number },
    release: { [string]: number },
}

type Mouse = {
    x: number, y: number,
    left: number, middle: number, right: number,
    pressed: number, press: number, release: number, wheel: number,
}

type Touch = {
    touching: number, press: number, release: number,
    x: number, y: number, touches: { any },
}

type Gamepad = {
    A: number, B: number, X: number, Y: number,
    LB: number, RB: number, LT: number, RT: number,
}

type SystemInputs = {
    keyboard: number, mouse: number, touch: number, gamepad: number,
}

type SystemFile = {
    save: (obj: any, name: string, format: string?, quality: number?) -> (),
    load: (types: any, callback: (any) -> ()) -> (),
    loaded: any,
    dropped: any,
}

type System = {
    time: () -> number,
    language: string,
    update_rate: number,
    inputs: SystemInputs,
    prompt: (text: string, callback: ((boolean, string) -> ())?) -> (),
    say: (text: string) -> (),
    pause: () -> (),
    exit: () -> (),
    file: SystemFile,
}

type Storage = {
    get: (name: string, defaultValue: any?) -> any,
    set: (name: string, value: any) -> (),
}

type SoundHandle = {
    setVolume: (v: number) -> (),
    setPitch: (p: number) -> (),
    setPan: (p: number) -> (),
    getDuration: () -> number,
    stop: () -> (),
}

type MusicHandle = {
    setVolume: (v: number) -> (),
    stop: () -> (),
    play: () -> (),
    getDuration: () -> number,
    getPosition: () -> number,
    setPosition: (p: number) -> (),
}

type Audio = {
    beep: (sequence: string) -> (),
    cancelBeeps: () -> (),
    playSound: (name: string, loop: boolean?) -> SoundHandle,
    playMusic: (name: string) -> MusicHandle,
}

type AssetManager = {
    loadFont: (path: string) -> (),
    loadImage: (path: string, callback: ((PForgeImage?) -> ())?) -> any,
    loadJSON: (path: string, callback: ((any) -> ())?) -> any,
    loadText: (path: string, callback: ((string?) -> ())?) -> any,
    loadCSV: (path: string, callback: ((string?) -> ())?) -> any,
    loadMarkdown: (path: string, callback: ((string?) -> ())?) -> any,
    loadModel: (path: string, scene: any, callback: ((any) -> ())?) -> any,
    wasmInstance: (path: string, callback: ((any) -> ())?) -> any,
}

type LightOpts = {
    color: number?,
    intensity: number?,
    position: {number}?,
    groundColor: number?,
}

type BoxOpts = { size: {number}?, color: number?, position: {number}?, wireframe: boolean? }
type SphereOpts = { radius: number?, color: number?, position: {number}? }
type PlaneOpts = { width: number?, height: number?, color: number?, position: {number}?, rotationX: number? }
type CylinderOpts = { radiusTop: number?, radiusBottom: number?, height: number?, color: number?, position: {number}? }
type ConeOpts = { radius: number?, height: number?, color: number?, position: {number}? }
type TorusOpts = { radius: number?, tube: number?, color: number?, position: {number}? }
type CameraOpts = { position: {number}?, lookAt: {number}?, fov: number? }
type Gfx3dInitOpts = { background: number?, fov: number?, near: number?, far: number? }

type Gfx3d = {
    init: (opts: Gfx3dInitOpts?) -> (),
    addLight: (type: string, opts: LightOpts?) -> any,
    addBox: (name: string, opts: BoxOpts?) -> any,
    addSphere: (name: string, opts: SphereOpts?) -> any,
    addPlane: (name: string, opts: PlaneOpts?) -> any,
    addCylinder: (name: string, opts: CylinderOpts?) -> any,
    addCone: (name: string, opts: ConeOpts?) -> any,
    addTorus: (name: string, opts: TorusOpts?) -> any,
    get: (name: string) -> any,
    remove: (name: string) -> (),
    setPosition: (name: string, x: number, y: number, z: number) -> (),
    translate: (name: string, dx: number, dy: number, dz: number) -> (),
    rotate: (name: string, rx: number, ry: number, rz: number) -> (),
    setColor: (name: string, color: number) -> (),
    setCamera: (opts: CameraOpts) -> (),
    moveCamera: (dx: number, dy: number, dz: number) -> (),
    render: () -> (),
    getDelta: () -> number,
}

-- ============================================================
-- CLASSES
-- ============================================================
type PForgeImage = {
    width: number,
    height: number,
    clear: (self: PForgeImage, color: string?) -> (),
    setRGB: (self: PForgeImage, x: number, y: number, r: number, g: number, b: number) -> (),
    setRGBA: (self: PForgeImage, x: number, y: number, r: number, g: number, b: number, a: number) -> (),
    getRGB: (self: PForgeImage, x: number, y: number, result: any?) -> { r: number, g: number, b: number },
    getRGBA: (self: PForgeImage, x: number, y: number, result: any?) -> { r: number, g: number, b: number, a: number },
    setColor: (self: PForgeImage, c: string) -> (),
    setAlpha: (self: PForgeImage, a: number) -> (),
    setBlending: (self: PForgeImage, b: string) -> (),
    setFont: (self: PForgeImage, f: string) -> (),
    setPixelated: (self: PForgeImage, p: boolean) -> (),
    setLineWidth: (self: PForgeImage, w: number) -> (),
    setLineDash: (self: PForgeImage, d: {number}) -> (),
    fillRect: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> (),
    drawRect: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> (),
    fillRound: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> (),
    drawRound: (self: PForgeImage, x: number, y: number, w: number, h: number, color: string?) -> (),
    fillRoundRect: (self: PForgeImage, x: number, y: number, w: number, h: number, r: number, color: string?) -> (),
    drawRoundRect: (self: PForgeImage, x: number, y: number, w: number, h: number, r: number, color: string?) -> (),
    drawLine: (self: PForgeImage, x1: number, y1: number, x2: number, y2: number) -> (),
    drawSprite: (self: PForgeImage, name: string, x: number, y: number, w: number, h: number?) -> (),
    drawImage: (self: PForgeImage, image: PForgeImage, x: number, y: number, w: number, h: number?) -> (),
    drawText: (self: PForgeImage, text: string, x: number, y: number, size: number, color: string?) -> (),
    drawTextOutline: (self: PForgeImage, text: string, x: number, y: number, size: number, color: string?) -> (),
    textWidth: (self: PForgeImage, text: string, size: number) -> number,
}

type PForgeSprite = {
    frames: { PForgeImage },
    fps: number,
    setFPS: (self: PForgeSprite, fps: number) -> (),
    setFrame: (self: PForgeSprite, n: number) -> (),
}

type PForgeMap = {
    width: number,
    height: number,
    tileWidth: number,
    tileHeight: number,
    data: { any },
    get: (self: PForgeMap, x: number, y: number) -> any,
    set: (self: PForgeMap, x: number, y: number, val: any) -> (),
}

type PForgeSound = {
    write: (self: PForgeSound, ch: number, idx: number, val: number) -> (),
    read: (self: PForgeSound, ch: number, idx: number) -> number,
    play: (self: PForgeSound, volume: number?, pitch: number?, pan: number?, loop: boolean?) -> (),
}

-- ============================================================
-- GLOBAIS PixelForge
-- ============================================================
declare screen: Screen
declare keyboard: Keyboard
declare mouse: Mouse
declare touch: Touch
declare gamepad: Gamepad
declare system: System
declare storage: Storage
declare audio: Audio
declare asset_manager: AssetManager
declare gfx3d: Gfx3d

declare sprites: { [string]: PForgeSprite }
declare maps: { [string]: PForgeMap }
declare sounds: { [string]: PForgeSound }
declare music: { [string]: PForgeSound }

declare PForgeImage: { new: (width: number, height: number, centered: boolean?) -> PForgeImage }
declare PForgeSprite: { new: (frames: { PForgeImage }?) -> PForgeSprite }
declare PForgeMap: { new: (width: number, height: number, tileWidth: number, tileHeight: number) -> PForgeMap }
declare PForgeSound: { new: (channels: number, length: number, sampleRate: number) -> PForgeSound }

-- ============================================================
-- HOOKS
-- ============================================================
declare onInit: (fn: () -> ()) -> ()
declare onUpdate: (fn: (dt: number, frame: number) -> ()) -> ()
declare onDraw: (fn: () -> ()) -> ()

declare init: (fn: () -> ()) -> ()
declare update: (fn: (dt: number, frame: number) -> ()) -> ()
declare draw: (fn: () -> ()) -> ()

-- ============================================================
-- THREADING
-- ============================================================
declare after: (seconds: number, action: () -> ()) -> any
declare every: (seconds: number, action: () -> ()) -> any
declare do_: (action: () -> ()) -> any
declare sleep: (seconds: number) -> ()

-- ============================================================
-- MATH / TIME HELPERS (do runtime PixelForge, expostos como globais)
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

declare round: (n: number) -> number
declare floor: (n: number) -> number
declare ceil: (n: number) -> number
declare abs: (n: number) -> number
declare sign: (n: number) -> number
declare sqrt: (n: number) -> number
declare pow: (a: number, b: number) -> number
declare min: (...number) -> number
declare max: (...number) -> number
declare sin: (n: number) -> number
declare cos: (n: number) -> number
declare tan: (n: number) -> number
declare PI: number

-- ============================================================
-- UTILITÁRIOS
-- ============================================================
type Random = {
    next: () -> number,
    nextInt: (max: number) -> number,
    seed: (v: number) -> (),
    clone: (s: number?) -> Random,
}

declare random: Random
declare List: () -> { any }

-- ============================================================
-- THREE.JS BRIDGE
-- ============================================================
declare three: {
    create: (name: string, ...any) -> string,
    call: (handle: string, method: string, ...any) -> any,
    get: (handle: string, prop: string) -> any,
    set: (handle: string, prop: string, value: any) -> (),
    const: (name: string) -> number,
}

-- ============================================================
-- MULTIPLAYER
-- ============================================================
type ServerConnection = {
    status: string,
    messages: { any },
    send: (self: ServerConnection, data: any) -> (),
    disconnect: (self: ServerConnection) -> (),
}

type Server = {
    room: string,
    new_connections: { any },
    active_connections: { any },
    messages: { any },
    closed_connections: { any },
    stop: (self: Server) -> (),
}

declare Server: { new: (room: string?) -> Server }
declare ServerConnection: { new: (room: string?) -> ServerConnection }
