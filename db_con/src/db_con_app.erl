%%%-------------------------------------------------------------------
%% @doc db_con public API
%% @end
%%%-------------------------------------------------------------------

-module(db_con_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    db_con_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
