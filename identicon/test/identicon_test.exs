defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "get the md5 sequence (binary list) correctly" do
    expected = [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]
    assert Identicon.md5_sequence("foo") == expected
  end

  test "get the rbg from binary list" do
    bin_list = [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]
    assert Identicon.rgb_from(bin_list) == [172, 189, 24]
  end

  test "builds grid from binary list" do
    bin_list = [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]
    assert Identicon.build_grid(bin_list) == [
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
  end

end
