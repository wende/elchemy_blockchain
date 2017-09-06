
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
  verify as: Base.encode16/1
  def encode(a1), do: Base.encode16(a1)
  @spec block(integer, integer, String.t, String.t) :: %{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    hash: String.t
  }
  curry block/4
  def block(index, timestamp, data, previous_hash) do
    [to_string().(index), to_string().(timestamp), data, previous_hash]
    |> (XList.foldl.((&++/0).()).("")).()
    |> (hash().(:sha256)).()
    |> (encode()).()
    |> ((fn(arg1) -> fn(arg2) -> fn(arg3) -> fn(arg4) -> fn(arg5) -> %{index: arg1, timestamp: arg2, data: arg3, previousHash: arg4, hash: arg5} end end end end end).(index).(timestamp).(data).(previous_hash)).()
  end

  @spec genesis(integer) :: %{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    hash: String.t
  }
  curry genesis/1
  def genesis(now) do
    block().(0).(now).("Genesis Block").("0")
  end

  @spec new(integer, String.t, list(%{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    hash: String.t
  })) :: list(%{
    index: integer,
    timestamp: integer,
    data: String.t,
    previousHash: String.t,
    hash: String.t
  })
  curry new/3
  def new(now, data, list) do
    case list do
      [] ->
        g = genesis().(now)
        [block().((g.index + 1)).(now).(data).(g.hash) | [g]]
      [x | xs] ->
        [block().((x.index + 1)).(now).(data).(x.hash) | [x | xs]]
    end
  end

end

