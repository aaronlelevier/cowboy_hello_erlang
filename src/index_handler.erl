-module(index_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
  %% io:format("init:~n"),
  Resource = path(Req),
  %% io:format("Resource:~p~n",[Resource]),
  case Resource of
    ["/", "websocket", ModStr] ->
      Self = self(),
      Mod = list_to_atom(ModStr),
      %% Spawn an erlang handler
      %% The return value will cause cowboy
      %% to call this module at the entry point
      %% websocket_handle
      Pid = spawn_link(Mod, start, [Self]),
      {cowboy_websocket, Req, Pid};
    _ ->
      handle(Req, State)
  end.

handle(Req, State) ->
  Resource = filename:join(path(Req)),
  io:format("ezwebframe:handle ~p~n", [Resource]),
  case Resource of
    "/" ->
      Path = "/Users/aaron/Documents/erlang/hello_erlang/static/index.html",
      serve_file(Path, Req, State);
    _ ->
      error
  end.

path(Req) ->
  Path = cowboy_req:path(Req),
  filename:split(binary_to_list(Path)).

serve_file(File, Req, State) ->
  {ok, Bin} = file:read_file(File),
  reply_html(Bin, Req, State).

reply_html(Data, Req, State) ->
  Req1 = send_page(html, Data, Req),
  {ok, Req1, State}.

send_page(_Type, Data, Req) ->
  cowboy_req:reply(
    200, #{<<"Content-Type">> => <<"text/html">>},
    Data, Req).

