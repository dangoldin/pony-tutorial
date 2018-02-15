use "itertools"
use "promises"

class val TransactionEvent
  let _amount : U64

  new create(amount: U64) =>
    _amount = amount

  fun transaction_amount() : U64 =>
    _amount

class val AccountSummary
  let _balance : U64
  let _account : String

  new create(balance: U64, account: String) =>
    _balance = balance
    _account = account

  fun currentbalance() : U64 =>
    _balance

  fun accountnumber() : String =>
    _account

actor AccountAggregate
  let _account: String
  var _balance: U64

  new create(account: String, starting_balance: U64) =>
    _account = account
    _balance = starting_balance

  be handle_tx_event(tx: TransactionEvent val) =>
    // imagine lots of complex processing here
    _balance = _balance + tx.transaction_amount()

  be summarize(p: Promise[AccountSummary]) =>
    p(recover AccountSummary(_balance, _account) end)

actor Main
  let _env: Env

  new create(env: Env) =>
    _env = env

    let accounts = ["0001"; "0002"; "0003"; "0004"]

    let create_summary_promise =
      {(account: String): Promise[AccountSummary] =>
        let aggregate = AccountAggregate(account, 6000)
        // just to illustrate mutable balance
        aggregate.handle_tx_event(recover TransactionEvent(351) end)
        aggregate.handle_tx_event(recover TransactionEvent(224) end)

        let p = Promise[AccountSummary]
        aggregate.summarize(p)
        p
      } iso

    Promises[AccountSummary].join(
      Iter[String](accounts.values())
        .map[Promise[AccountSummary]](consume create_summary_promise))
      .next[None](recover this~receive_collection() end)

  be receive_collection(coll: Array[AccountSummary] val) =>
    _env.out.print("received account summaries:")
    for summary in coll.values() do
      _env.out.print("Account " + summary.accountnumber() + ": $" +
        summary.currentbalance().string())
    end
