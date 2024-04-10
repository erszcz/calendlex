defmodule CalendlexWeb.ScheduleEventLiveTest do
  use CalendlexWeb.ConnCase

  import Phoenix.LiveViewTest
  import Calendlex.MyContextFixtures

  @create_attrs %{end_at: "2024-04-09T10:29:00", name: "some name", start_at: "2024-04-09T10:29:00"}
  @update_attrs %{end_at: "2024-04-10T10:29:00", name: "some updated name", start_at: "2024-04-10T10:29:00"}
  @invalid_attrs %{end_at: nil, name: nil, start_at: nil}

  defp create_schedule_event(_) do
    schedule_event = schedule_event_fixture()
    %{schedule_event: schedule_event}
  end

  describe "Index" do
    setup [:create_schedule_event]

    test "lists all scheduled_events", %{conn: conn, schedule_event: schedule_event} do
      {:ok, _index_live, html} = live(conn, ~p"/scheduled_events")

      assert html =~ "Listing Scheduled events"
      assert html =~ schedule_event.name
    end

    test "saves new schedule_event", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/scheduled_events")

      assert index_live |> element("a", "New Schedule event") |> render_click() =~
               "New Schedule event"

      assert_patch(index_live, ~p"/scheduled_events/new")

      assert index_live
             |> form("#schedule_event-form", schedule_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#schedule_event-form", schedule_event: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/scheduled_events")

      html = render(index_live)
      assert html =~ "Schedule event created successfully"
      assert html =~ "some name"
    end

    test "updates schedule_event in listing", %{conn: conn, schedule_event: schedule_event} do
      {:ok, index_live, _html} = live(conn, ~p"/scheduled_events")

      assert index_live |> element("#scheduled_events-#{schedule_event.id} a", "Edit") |> render_click() =~
               "Edit Schedule event"

      assert_patch(index_live, ~p"/scheduled_events/#{schedule_event}/edit")

      assert index_live
             |> form("#schedule_event-form", schedule_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#schedule_event-form", schedule_event: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/scheduled_events")

      html = render(index_live)
      assert html =~ "Schedule event updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes schedule_event in listing", %{conn: conn, schedule_event: schedule_event} do
      {:ok, index_live, _html} = live(conn, ~p"/scheduled_events")

      assert index_live |> element("#scheduled_events-#{schedule_event.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#scheduled_events-#{schedule_event.id}")
    end
  end

  describe "Show" do
    setup [:create_schedule_event]

    test "displays schedule_event", %{conn: conn, schedule_event: schedule_event} do
      {:ok, _show_live, html} = live(conn, ~p"/scheduled_events/#{schedule_event}")

      assert html =~ "Show Schedule event"
      assert html =~ schedule_event.name
    end

    test "updates schedule_event within modal", %{conn: conn, schedule_event: schedule_event} do
      {:ok, show_live, _html} = live(conn, ~p"/scheduled_events/#{schedule_event}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Schedule event"

      assert_patch(show_live, ~p"/scheduled_events/#{schedule_event}/show/edit")

      assert show_live
             |> form("#schedule_event-form", schedule_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#schedule_event-form", schedule_event: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/scheduled_events/#{schedule_event}")

      html = render(show_live)
      assert html =~ "Schedule event updated successfully"
      assert html =~ "some updated name"
    end
  end
end
