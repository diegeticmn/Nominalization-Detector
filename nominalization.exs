defmodule Nominals do

  def findnoms(file) do
    File.stream!(file)
    |> Enum.to_list
    |> Enum.map(&String.trim_trailing(&1))
    |> Enum.map(fn(x) -> if(Regex.match?(~r/ment$|ness$|ism$|tion$/, x), do: x) end)
    |> List.flatten
    |> Enum.reject(fn(x) -> x == nil end)
  end

  def morphemecount(list) do
    list
    |> findnoms
    |> morpheme
    |> count
  end

   defp morpheme(list) do
     new_list = Enum.map(list, &String.split_at(&1, -4))
     morpheme_list = for {_a, b} <- new_list, do: [] ++ b
     Enum.map(morpheme_list, fn(x) -> if(Regex.match?(~r/ism$/, x), do: String.slice(x, -3..-1), else: x) end)
   end

   defp count(words) when is_list(words) do
     Enum.reduce(words, %{}, &update_count/2)
   end

   defp update_count(word, acc) do
     Map.update(acc, word, 1, &(&1 + 1))
   end

end

IO.inspect Nominals.morphemecount("nominals.txt")
