defmodule Identicon do
  @moduledoc """
  A `Identicon` is a generated image based on an input. For example, github profiles that have no image uploaded
  by a user, use an identicon as an image. The important thing to note is that this image is not randomly created
  every time, but for a given input a identicon generator returns always the same image. Another property to take identicon
  account is that identicons are always vertically-simmetric with respect the center.
  """

  @doc """
  Creates an identicon (image) of a given string.

  """
  def generate(string) do 
    string 
    |> Identicon.md5_sequence
    |> Identicon.build_grid
    |> Identicon.filter_odd_squares
  end


  @doc """
  Computes the md5_sequence (binary as a list) of a given string.

  ## Examples

      iex> Identicon.md5_sequence("foo")
      [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]

  """
  def md5_sequence(string) do 
    :crypto.hash(:md5, string) 
    |> :binary.bin_to_list
  end

  @doc """
  Returns the RGB (first 3 positions) of a md5 sequence.

  ## Examples

      iex> Identicon.rgb_from([172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216])
      [172, 189, 24]

  """
  def rgb_from(bin_sequence) do 
    [r, g, b | _tail] = bin_sequence
    [r, g, b]
  end

  @doc """
  Returns the grid given a binary sequence.

  ## Examples

      iex> Identicon.build_grid([172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216])
      [
        {172, 0},
        {189, 1},
        {24, 2},
        {189, 3},
        {172, 4},
        {219, 5},
        {76, 6},
        {194, 7},
        {76, 8},
        {219, 9},
        {248, 10},
        {92, 11},
        {237, 12},
        {92, 13},
        {248, 14},
        {239, 15},
        {101, 16},
        {79, 17},
        {101, 18},
        {239, 19},
        {204, 20},
        {196, 21},
        {164, 22},
        {196, 23},
        {204, 24}
      ]

  """
  def build_grid(bin_sequence) do
    bin_sequence
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(fn [a , b, c] -> [a, b, c, b, a] end)
    |> List.flatten
    |> Enum.with_index
  end

  def filter_odd_squares(grid) do
    Enum.filter grid, fn({code, _}) -> 
      rem(code, 2) == 0
    end
  end
  
end
