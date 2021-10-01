defmodule DecentApp do
  alias DecentApp.Balance

  @avaible_commands ["DUP", "POP", "NOTHING", "COINS", "+", "-", "*"]

  def call(%Balance{} = balance, commands) do
    {balance, result, error} =
      Enum.reduce(commands, {balance, [], false}, fn command, {bal, res, error} ->
        if error do
          {nil, nil, true}
        else
          is_error =
            cond do
              length(res) < 1 ->
                if command == "DUP" || command == "POP" || command == "+" || command == "-" ||
                     command == "*" do
                  true
                else
                  false
                end

              length(res) < 2 ->
                if command == "+" || command == "-" || command == "*" do
                  true
                else
                  false
                end

              length(res) < 3 ->
                if command == "*" do
                  true
                else
                  false
                end

              is_integer(command) ->
                if command < 0 || command > 10 do
                  true
                else
                  false
                end

              command in @avaible_commands || is_integer(command) ->
                false

              true ->
                false
            end

          if is_error do
            {nil, nil, true}
          else
            res =
              cond do
                command == "NOTHING" ->
                  res

                command == "DUP" ->
                  res ++ [List.last(res)]

                command == "POP" ->
                  {_, res} = List.pop_at(res, length(res) - 1)
                  res

                command == "+" ->
                  [first, second | rest] = Enum.reverse(res)
                  Enum.reverse(rest) ++ [first + second]

                command == "-" ->
                  [first, second | rest] = Enum.reverse(res)
                  Enum.reverse(rest) ++ [first - second]

                command == "*" ->
                  [first, second, third | rest] = Enum.reverse(res)
                  Enum.reverse(rest) ++ [first * second * third]

                is_integer(command) ->
                  res ++ [command]

                command == "COINS" ->
                  res

                true ->
                  res
              end

            new_balance = %{bal | coins: bal.coins - 1}

            new_balance =
              if command == "COINS" do
                %{new_balance | coins: new_balance.coins + 6}
              else
                new_balance
              end

            new_balance =
              if command == "+" do
                %{new_balance | coins: new_balance.coins - 1}
              else
                new_balance
              end

            new_balance =
              if command == "*" do
                %{new_balance | coins: new_balance.coins - 2}
              else
                new_balance
              end

            {new_balance, res, false}
          end
        end
      end)

    if error do
      -1
    else
      if balance.coins < 0 do
        -1
      else
        {balance, result}
      end
    end
  end
end
