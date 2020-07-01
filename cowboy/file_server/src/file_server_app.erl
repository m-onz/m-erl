
-module(file_server_app).
-behaviour(application).
-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
        Dispatch = cowboy_router:compile([
                {'_', [ { "/", cowboy_static, { priv_file, file_server, "index.html" } },
                        {"/[...]", cowboy_static, {priv_dir, file_server, ""}}
                ]}
        ]),
        {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
                env => #{dispatch => Dispatch}
        }),
        file_server_sup:start_link().

stop(_State) ->
        ok = cowboy:stop_listener(http).
