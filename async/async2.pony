use collections = "collections"

actor MathematicianOld
  let _reg: SharedRegistersOld
  let _out: OutStream
  new create(reg: SharedRegistersOld, out: OutStream) =>
    _reg = reg
    _out = out

  be increment(name: String) =>
    """
    Read the value of the named register, then write the incremented value.
    """
    let reg = _reg
    let out = _out

    reg.read(name, {(value: I64)(reg, out, name) =>
      let new_value = value + 1
      reg.write(name, new_value)
      out.print("Incremented " + name + " to " + new_value.string())
    } val)

actor Main3
  new create(env: Env) =>
    let reg = SharedRegistersOld
    let out = env.out

    reg.write("x", 99)

    for i in collections.Range(0, 10) do
      MathematicianOld(reg, out).increment("x")
    end
