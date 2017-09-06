defmodule ElchemyTest do
  use ExUnit.Case
  use Elchemy

  doctest Blockchain
  typetest Blockchain

  test "Can hash" do
    assert Blockchain.hash().(:sha256).("A") |> Blockchain.encode().() ==
      :crypto.hash(:sha256, "A") |> Base.encode16()

  end

  test "Can chain blocks" do
    now = fn -> DateTime.utc_now |> DateTime.to_unix end
    genesis = Blockchain.genesis().(now.())
    1..10
    |> Enum.reduce([genesis], fn index, list ->
      Blockchain.new.(now.()).("Block ##{index}").(list)
    end)
    |> IO.inspect
  end

end
