-module(hello_erlang_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  % Routing docs: https://ninenines.eu/docs/en/cowboy/2.6/guide/routing/
  % {HostMatch, list({PathMatch, Handler, InitialState})}
  Dispatch = cowboy_router:compile([
    {'_', [
			% path to resource example
			{"/blog", blog_handler, #{}},
			% home page
      {"/", index_handler, #{}}
    ]}
  ]),
  {ok, _} = cowboy:start_clear(my_http_listener,
    [{port, 8080}],
    #{env => #{dispatch => Dispatch}}
  ),
  hello_erlang_sup:start_link().

stop(_State) ->
  ok.


