defmodule MapsTest do
  use ExUnit.Case
  doctest Cards

  test "does create map" do
    actual = Maps.create_map()
    expected = %{s3: "cheap", athena: "expensive", emr: "expensive"}
    assert Map.equal?(expected, actual)
  end

  test "does put new value into map" do
    map = Maps.create_map()
    expected = %{s3: "cheap", athena: "expensive", emr: "expensive", dynamo: "cheap"}
    actual = Maps.put(map, :dynamo, "cheap")
    assert Map.equal?(expected, actual)
  end

  test "does update key on map" do
    map = Maps.create_map()
    expected = %{s3: "cheap", athena: "expensive", emr: "cheap"}
    actual = Maps.update(map, :emr, "cheap")
    assert Map.equal?(expected, actual)
  end

end