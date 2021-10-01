defmodule DecentAppTest do
  use ExUnit.Case
  doctest DecentApp

  alias DecentApp.Balance

  describe "Awesome tests" do
    test "success" do
      balance = %Balance{coins: 10}

      {new_balance, result} =
        DecentApp.call(balance, [3, "DUP", "COINS", 5, "+", "NOTHING", "POP", 7, "-", 9])

      assert new_balance.coins == 5
      assert length(result) > 1

      {new_balance, result} = DecentApp.call(balance, [1, 2, 3, 5, "*"])

      assert new_balance.coins == 3
      assert length(result) == 2

      {new_balance, result} = DecentApp.call(balance, [1, 1, 2, 2, "*"])

      assert new_balance.coins == 3
      assert length(result) == 2
    end

    test "failed" do
      # There is a bug in the `is_error` variable.
      # Running the following test without making any changes to the code will fail.
      # assert DecentApp.call(%Balance{coins: 10}, [
      #          3,
      #          3,
      #          "FALSE"
      #        ]) == -1

      # assert DecentApp.call(%Balance{coins: 10}, [
      #          3,
      #          "DUP",
      #          "FALSE",
      #          5,
      #          "+",
      #          "NOTHING",
      #          "POP",
      #          7,
      #          "-",
      #          9
      #        ]) == -1

      assert DecentApp.call(%Balance{coins: 1}, [3, 5, 6]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["+"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["-"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["DUP"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["POP"]) == -1

      assert DecentApp.call(%Balance{coins: 1}, [1, 1, 1, "*"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["*"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, [1, "*"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, [1, 2, "*"]) == -1
    end
  end
end
