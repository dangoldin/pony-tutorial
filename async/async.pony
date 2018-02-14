use collections = "collections"

actor SharedRegistersOld
  let _data: collections.Map[String, I64] = _data.create()

  be write(name: String, value: I64) =>
    """
    Write to the named register, setting its value to the given value.
    """
    _data(name) = value

  be read(name: String, fn: {(I64)} val) =>
    """
    Read the value of the named register and pass it to the given function.
    A register which has never been written to will have a value of zero.
    """
    fn(try _data(name)? else 0 end)

actor Main2
  new create(env: Env) =>
    let reg = SharedRegistersOld
    let out = env.out

    reg.write("x", 99)
    reg.write("y", 100)

    reg.read("x", {(value: I64)(out) =>
      out.print("The value of x is " + value.string())
    } val)

    reg.read("y", {(value: I64)(out) =>
      out.print("The value of y is " + value.string())
    } val)
