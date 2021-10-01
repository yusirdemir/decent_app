defmodule DecentApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    DecentApp.Supervisor.start_link(name: DecentApp.Supervisor)
  end
end
