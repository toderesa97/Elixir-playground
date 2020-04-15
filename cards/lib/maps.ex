defmodule Maps do
  @moduledoc """
    Module for playing with maps
  """

  def create_map() do
    %{s3: "cheap", athena: "expensive", emr: "expensive"}
  end

  def update(map, key, value) do
    Map.put(map, key, value)
  end 

  def put(map, key, value) do 
    Map.put_new(map, key, value)
  end

end