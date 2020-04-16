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
  def generate(string, filename) do 
    string 
    |> Identicon.md5_sequence
    |> Identicon.rgb_from
    |> Identicon.build_grid
    |> Identicon.filter_in_even_squares
    |> Identicon.build_pixel_map
    |> Identicon.draw_image
    |> Identicon.save_image filename
  end


  @doc """
  Computes the md5_sequence (binary as a list) of a given string.

  ## Examples

      iex> Identicon.md5_sequence("foo")
      %Identicon.Image{grid: nil, hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216], rgb: nil}

  """
  def md5_sequence(string) do 
    bin_list = :crypto.hash(:md5, string) 
    |> :binary.bin_to_list
    
    %Identicon.Image{hex: bin_list}
  end

  @doc """
  Returns the RGB (first 3 positions) of a md5 sequence.

  ## Examples

      iex> image = %Identicon.Image{hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]}
      iex> Identicon.rgb_from(%Identicon.Image{hex: bin_sequence} = image)
      %Identicon.Image{
        hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216],
        rgb: [172, 189, 24]
      }

  """
  def rgb_from(%Identicon.Image{hex: bin_sequence} = image) do 
    [r, g, b | _tail] = bin_sequence
    
    %Identicon.Image{image | rgb: [r, g, b]}
  end

  @doc """
  Returns the grid given a binary sequence.

  ## Examples

      iex> image = %Identicon.Image{hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216]}
      iex> Identicon.build_grid(%Identicon.Image{hex: bin_sequence} = image)
      %Identicon.Image{
        hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216],
        grid: [
          {172, 0},{189, 1},{24, 2},{189, 3},{172, 4},{219, 5},{76, 6},{194, 7},{76, 8},
          {219, 9},{248, 10},{92, 11},{237, 12},{92, 13},{248, 14},{239, 15},{101, 16},
          {79, 17},{101, 18},{239, 19},{204, 20},{196, 21},{164, 22},{196, 23},{204, 24}
        ]
      }

  """
  def build_grid(%Identicon.Image{hex: bin_sequence} = image) do
    grid = bin_sequence
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(fn [a , b, c] -> [a, b, c, b, a] end)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Returns the even elements in the grid.

  ## Examples

      iex> image = %Identicon.Image{
      iex>              hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216],
      iex>              grid: [
      iex>                    {172, 0},{189, 1},{24, 2},{189, 3},{172, 4},{219, 5},{76, 6},{194, 7},{76, 8},
      iex>                    {219, 9},{248, 10},{92, 11},{237, 12},{92, 13},{248, 14},{239, 15},{101, 16},
      iex>                    {79, 17},{101, 18},{239, 19},{204, 20},{196, 21},{164, 22},{196, 23},{204, 24}
      iex>              ]
      iex>            }
      iex> Identicon.filter_in_even_squares(image)
      %Identicon.Image{
        hex: [172, 189, 24, 219, 76, 194, 248, 92, 237, 239, 101, 79, 204, 196, 164, 216],
        grid: [
          {172, 0},{24, 2},{172, 4},{76, 6},{194, 7},{76, 8},{248, 10},{92, 11},
          {92, 13},{248, 14},{204, 20},{196, 21},{164, 22},{196, 23},{204, 24}
        ]
      }

  """
  def filter_in_even_squares(%Identicon.Image{grid: grid} = image) do
    even_squares = Enum.filter(grid, fn {square, _} = x -> rem(square, 2) == 0 end)

    %Identicon.Image{image | grid: even_squares}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn {_code, index} ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      {{horizontal, vertical}, {horizontal + 50, vertical + 50}}
    end
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{rgb: rgb, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    color = :egd.color(List.to_tuple(rgb))
    Enum.map pixel_map, fn {p1, p2} ->
      :egd.filledRectangle(image, p1, p2, color)
    end
    :egd.render(image)
  end

  def save_image(image, filename) do
    :egd.save(image, filename)
  end
  
end
