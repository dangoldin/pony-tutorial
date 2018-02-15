use "time"

class NumberGenerator is TimerNotify
  let _env: Env
  var _counter: U64

  new iso create(env: Env) =>
    _counter = 0
    _env = env

  fun ref _next(): String =>
    _counter = _counter + 1
    _counter.string()

  fun ref apply(timer: Timer, count: U64): Bool =>
    _env.out.print(_next())
    true

actor Main
  new create(env: Env) =>
    let timers = Timers
    let timer = Timer(NumberGenerator(env), 0, 5_000_000_000)
    timers(consume timer)
