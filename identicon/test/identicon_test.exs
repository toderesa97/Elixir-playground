defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "get the md5 sequence (binary list) correctly" do
    expected = %Identicon.Image{hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]}
    assert Identicon.md5_sequence("foo") == expected
  end

  test "get the rbg from binary list" do
    input = %Identicon.Image{hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]}
    expected = %Identicon.Image{
      hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216],
      rgb: [172, 189, 24]
    }
    assert Identicon.rgb_from(input) == expected
  end

  test "builds grid from binary list" do
    input = %Identicon.Image{hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]} 
    expected = %Identicon.Image{
      hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216],
      grid: [
        {172, 0},{189, 1},{24, 2},{189, 3},{172, 4},{219, 5},{76, 6},{194, 7},{76, 8},
        {219, 9},{248, 10},{92, 11},{237, 12},{92, 13},{248, 14},{239, 15},{101, 16},
        {79, 17},{101, 18},{239, 19},{204, 20},{196, 21},{164, 22},{196, 23},{204, 24}
      ]
    }
    assert Identicon.build_grid(input) == expected
  end

  test "filter in evens" do
    input = %Identicon.Image{
      grid: [
        {172, 0},{189, 1},{24, 2},{189, 3},{172, 4},{219, 5},{76, 6},{194, 7},{76, 8},
        {219, 9},{248, 10},{92, 11},{237, 12},{92, 13},{248, 14},{239, 15},{101, 16},
        {79, 17},{101, 18},{239, 19},{204, 20},{196, 21},{164, 22},{196, 23},{204, 24}
      ]
    }
    expected = %Identicon.Image{
      grid: [
        {172, 0},{24, 2},{172, 4},{76, 6},{194, 7},{76, 8},{248, 10},{92, 11},
        {92, 13},{248, 14},{204, 20},{196, 21},{164, 22},{196, 23},{204, 24}
      ]
    }
    assert Identicon.filter_in_even_squares(input) == expected
  end

end
