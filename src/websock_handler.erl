-module(websock_handler).
-behavior(cowboy_handler).

-export([init/2, websocket_handle/2]).

%% only used to initialize the websocket connection
init(Req, State) ->
	{cowboy_websocket, Req, State}.

%% can optionally use:
%%websocket_init(State) ->
%%	erlang:start_timer(1000, self(), <<"Hello!">>),
%%	{ok, State}.

%% or:
%%websocket_init(State) ->
%%	{reply, {text, <<"Hello!">>}, State}.

%% ping-pong handlers
websocket_handle(Frame = {text, _}, State) ->
	{reply, Frame, State};
websocket_handle(_Frame, State) ->
	{ok, State}.