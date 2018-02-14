use collections = "collections"

actor SharedRegisters
  let _data: collections.Map[String, I64] = _data.create()

  be access(fn: {(SharedRegisters ref)} val) =>
    fn(this)

  be write(name: String, value: I64) =>
    write_now(name, value)

  be read(name: String, fn: {(I64)} val) =>
    fn(read_now(name))

  fun ref write_now(name: String, value: I64) =>
    _data(name) = value

  fun ref read_now(name: String): I64 =>
    try _data(name)? else 0 end

actor Mathematician
  let _reg: SharedRegisters
  let _out: OutStream
  new create(reg: SharedRegisters, out: OutStream) =>
    _reg = reg
    _out = out

  be increment(name: String) =>
    """
    Read the value of the named register, then write the incremented value.
    """
    let reg = _reg
    let out = _out

    reg.access({(reg: SharedRegisters ref)(out, name) =>
      let new_value = reg.read_now(name) + 1
      reg.write_now(name, new_value)
      out.print("Incremented " + name + " to " + new_value.string())
    } val)

actor Main
  new create(env: Env) =>
    let reg = SharedRegisters
    let out = env.out

    reg.write("x", 99)

    for i in collections.Range(0, 10) do
      Mathematician(reg, out).increment("x")
    end
