defmodule Cards do
  @moduledoc """
    Module for creating and handling a deck of cards
  """

  @doc """
    Creates a deck of cards

  ## Usage

      iex> deck = Cards.create_deck()
      iex> deck
      ["Ace of King", "Ace of Diamond", "Two of King", "Two of Diamond",
      "Three of King", "Three of Diamond"]

  """
  def create_deck do
    values = ["Ace", "Two", "Three"]
    suits = ["King", "Diamond"]

    cards = for value <- values do
      for suit <- suits do
        "#{value} of #{suit}"
      end
    end
    List.flatten(cards)
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Splits the deck into two pieces, the hand comprised of `hand_size` cards and the rest of the deck

  ## Usage

      iex> deck = Cards.create_deck()
      ["Ace of King", "Ace of Diamond", "Two of King", "Two of Diamond",
      "Three of King", "Three of Diamond"]
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of King"]
      iex> deck
      ["Ace of Diamond", "Two of King", "Two of Diamond",
      "Three of King", "Three of Diamond"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def get_card(deck, index) do
    cond do
      index == 0 -> List.first(deck)
      index >= 0 and length(deck) > index -> get_card(Enum.slice(deck, 1, length(deck) - 1), index - 1)
      true -> nil
    end
  end

  def save(deck, filename) do
    bin_content = :erlang.term_to_binary(deck)
    File.write(filename, bin_content)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, :enoent} -> filename <> " does not exist"
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck()
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end

end
