
# Compiled using Elchemy v0.4.37
defmodule Blockchain do
  use Elchemy

  @type encoding :: :sha256

  #  Elchemy doesn't have verify for IOData yet 
  @spec hash(encoding, String.t) :: String.t
  curry hash/2
  def hash(a1, a2), do: :crypto.hash(a1, a2)
  @spec encode(String.t) :: String.t
  curry encode/1
  verify as: Base.encode32/1
  def encode(a1), do: Base.encode32(a1)
  @spec find_valid(String.t, String.t, integer) :: {integer, String.t}
  curry find_valid/3
  def find_valid(start, subblock, nonce) do
    (subblock ++ to_string().(nonce))
    |> (hash().(:sha256)).()
    |> (encode()).()
    |> (fn(a) -> if XString.starts_with.(start).(a) do XDebug.log.("Found").({nonce, a}) else (nonce + 1)
    |> (find_valid().(start).(subblock)).() end end).()
  end

  @spec get_hash(integer, integer, String.t, String.t, integer) :: {integer, String.t}
  curry get_hash/5
  def get_hash(index, timestamp, data, previous_hash, difficulty) do
    start = XString.repeat.(difficulty).("WENDE")
    |> (XString.left.(difficulty)).()
    subblock = (to_string().(index) ++ (to_string().(timestamp) ++ (data ++ previous_hash)))
    find_valid().(start).(subblock).(0)
  end

  @spec block(integer, integer, String.t, String.t, integer) :: %{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    difficulty: integer,
    nonce: integer,
    hash: String.t
  }
  curry block/5
  def block(index, timestamp, data, previous_hash, difficulty) do
    {nonce, valid_hash} = get_hash().(index).(timestamp).(data).(previous_hash).(difficulty)
    (fn(arg1) -> fn(arg2) -> fn(arg3) -> fn(arg4) -> fn(arg5) -> fn(arg6) -> fn(arg7) -> %{index: arg1, timestamp: arg2, data: arg3, previousHash: arg4, difficulty: arg5, nonce: arg6, hash: arg7} end end end end end end end).(index).(timestamp).(data).(previous_hash).(difficulty).(nonce).(valid_hash)
  end

  @spec genesis(integer) :: %{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    difficulty: integer,
    nonce: integer,
    hash: String.t
  }
  curry genesis/1
  def genesis(now) do
    block().(0).(now).("Genesis Block").("0").(1)
  end

  @spec new(integer, String.t, integer, list(%{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    difficulty: integer,
    nonce: integer,
    hash: String.t
  })) :: list(%{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    difficulty: integer,
    nonce: integer,
    hash: String.t
  })
  curry new/4
  def new(now, data, difficulty, list) do
    case list do
      [] ->
        g = genesis().(now)
        [block().((g.index + 1)).(now).(data).(g.hash).(difficulty) | [g]]
      [x | xs] ->
        [block().((x.index + 1)).(now).(data).(x.hash).(difficulty) | [x | xs]]
    end
  end

end

