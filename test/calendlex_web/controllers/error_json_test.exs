defmodule CalendlexWeb.ErrorJSONTest do
  use CalendlexWeb.ConnCase, async: true

  test "renders 404" do
    assert CalendlexWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert CalendlexWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
