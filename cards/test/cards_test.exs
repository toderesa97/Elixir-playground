defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "save function persists correctly" do
    deck = Cards.create_deck()
    Cards.save(deck, "persisted_deck")
    {:ok, binary} = File.read("persisted_deck")
    assert deck == :erlang.binary_to_term(binary)
  end

  test "shuffle does randomize a deck" do
    deck = Cards.create_deck()
    refute deck == Cards.shuffle(deck)
  end
end
