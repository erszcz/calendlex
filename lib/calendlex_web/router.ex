defmodule CalendlexWeb.Router do
  use CalendlexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CalendlexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalendlexWeb do
  #   pipe_through :api
  # end

  live_session :public, on_mount: CalendlexWeb.Live.InitAssigns do
    scope "/", CalendlexWeb do
      pipe_through :browser

      live "/", PageLive
      live "/:event_type_slug", EventTypeLive

      #live "/:event_type_slug/:time_slot", ScheduleEventLive

      #live "/:event_type_slug/scheduled_events", ScheduleEventLive.Index, :index
      live "/:event_type_slug/:time_slot", ScheduleEventLive.Index, :new
      #live "/:event_type_slug/scheduled_events/:id/edit", ScheduleEventLive.Index, :edit

      live "/events/:event_type_slug/:event_id", ScheduleEventLive.Show, :show
      #live "/:event_type_slug/scheduled_events/:id/show/edit", ScheduleEventLive.Show, :edit
    end
  end
end
