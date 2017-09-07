defmodule ElchemyTest do
  use ExUnit.Case
  use Elchemy

  @moduletag timeout: 300_000

  doctest Blockchain
  typetest Blockchain

  test "Can hash" do
    assert Blockchain.hash().(:sha256).("A") |> Blockchain.encode().() ==
      :crypto.hash(:sha256, "A") |> Base.encode32()

  end

  test "Can mine blocks" do
    now = fn -> DateTime.utc_now |> DateTime.to_unix end

    genesis = Blockchain.genesis().(now.())
    difficulty = 4
    no_of_blocks = 10

    start = now.()
    1..no_of_blocks
    |> Enum.reduce([genesis], fn index, list ->
      start = now.()
      block = Blockchain.new.(now.()).("Block ##{index}").(difficulty).(list)
      IO.puts "Spent #{ now.() - start } seconds finding"
      block
    end)
    |> IO.inspect
    IO.puts "Spent #{ now.() - start } seconds on 10 blocks"
  end

end
