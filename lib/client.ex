defmodule Client do
    use WebSockex
    require Logger

    # Testing Server
    @echo_server "ws://echo.websocket.org/?encoding=text"

    def start_link(opts \\ []) do
        WebSockex.start_link(@echo_server, __MODULE__, %{}, opts)
    end  
    
    def handle_frame({:text, "please reply" = msg}, state) do
        Logger.info("Echo server says, #{msg}")
        reply = "back atcha!"
        
        Logger.info("Sent to Echo server, #{reply}")
        {:reply, {:text, reply}, state}
    end

    def handle_frame({:text, "shut down"}, state) do
        Logger.info("shutting down...")
        {:close, state}
    end

    def handle_frame({:text, msg}, state) do
        Logger.info("Echo server says, #{msg}")
        {:ok, state}
    end

    def handle_disconnect(%{reason: reason}, state) do
        Logger.info("Disconnect with reason: #{inspect reason}")
        {:ok, state}
    end
end