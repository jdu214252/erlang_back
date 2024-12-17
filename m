-module(db_con).
-export([connect/0, run_query/1, get_data/0]).

-include_lib("../lib/epgsql/_build/default/lib/epgsql/include/epgsql.hrl").
  
% -include_lib("../lib/epgsql/include/epgsql.hrl").




-define(DB_HOST, "localhost").
-define(DB_PORT, 5432).
-define(DB_USER, "postgres").
-define(DB_PASS, "root").
-define(DB_NAME, "erlang").

connect() ->
    {ok, C} = epgsqla:start_link(),
    Ref = epgsqla:connect(C, "localhost", "postgres", "root", #{database => "erlang"}),
    receive
        {C, Ref, connected} ->
            {ok, C};
        {C, Ref, Error = {error, _}} ->
            Error;
        {'EXIT', C, _Reason} ->
            {error, closed}
    end.
    % case epgsql:connect(?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, []) of
    %     {ok, Conn} ->
    %         io:format("Connected to PostgreSQL~n"),
    %         Conn;
    %     {error, Reason} ->
    %         io:format("Failed to connect: ~p~n", [Reason]),
    %         {error, Reason}
    % end.


run_query(Conn) ->
    Sql = "SELECT id, name FROM users LIMIT 5;",
    
    case epgsql:parse(Conn, "select_users", Sql, []) of
        {ok, Statement} ->
            case epgsql:execute(Conn, Statement, [], 0) of
                {ok, _Count, Rows} ->
                    io:format("Query succeeded: ~p~n", [Rows]),
                    Rows;
                {error, Reason} ->
                    io:format("Query failed: ~p~n", [Reason]),
                    {error, Reason}
            end;
        {error, Reason} ->
            io:format("Failed to parse query: ~p~n", [Reason]),
            {error, Reason}
    end.


get_data() ->
    %% Connect to the database
    Conn = connect(),
    case Conn of
        {error, _} -> 
            io:format("Connection failed~n");
        Conn ->
            %% Run the query
            run_query(Conn),
            %% Always close the connection after usage
            epgsql:close(Conn)
    end.












































































    -module(db_con).
-export([connect/0, run_query/1, get_data/0]).

-include_lib("../lib/epgsql/_build/default/lib/epgsql/include/epgsql.hrl").

-define(DB_HOST, "localhost").
-define(DB_PORT, 5432).
-define(DB_USER, "postgres").
-define(DB_PASS, "root").
-define(DB_NAME, "erlang").

connect() ->
    {ok, C} = epgsqla:start_link(),
    Ref = epgsqla:connect(C, "localhost", "postgres", "root", #{database => "erlang"}),
    receive
        {C, Ref, connected} -> 
            {ok, C};
        {C, Ref, {error, _}} -> 
            {error, "Failed to connect"};
        {'EXIT', C, _Reason} -> 
            {error, "Connection closed"}
    end.

run_query(Conn) ->
    Sql = "SELECT id, name FROM users;",
    case epgsql:parse(Conn, "select_users", Sql, []) of
        {ok, Statement} ->
            case epgsql:execute(Conn, Statement, [], 0) of
                {ok, _Count, Rows} ->
                    io:format("Query succeeded: ~p~n", [Rows]),
                    Rows;
                {error, Reason} ->
                    io:format("Query failed: ~p~n", [Reason]),
                    {error, Reason}
            end;
        {error, Reason} ->
            io:format("Failed to parse query: ~p~n", [Reason]),
            {error, Reason}
    end.

get_data() ->
    %% Connect to the database
    Conn = connect(),
    io:format("Conn: ~p~n", [Conn]),  % Add debug print here
    case Conn of
        {error, _} -> 
            io:format("Connection failed~n");
        {ok, Conn} ->
            %% Run the query
            run_query(Conn),
            %% Always close the connection after usage
            epgsql:close(Conn)
    end.





























































































% shu oxshaDI


-module(db_con).
-export([connect/0, run_query/1, get_data/0]).

-include_lib("../lib/epgsql/_build/default/lib/epgsql/include/epgsql.hrl").

-define(DB_HOST, "localhost").
-define(DB_PORT, 5432).
-define(DB_USER, "postgres").
-define(DB_PASS, "root").
-define(DB_NAME, "erlang").

connect() ->
    {ok, C} = epgsqla:start_link(),
    Ref = epgsqla:connect(C, "localhost", "postgres", "root", #{database => "erlang"}),
    receive
        {C, Ref, connected} -> 
            {ok, C};
        {C, Ref, {error, _}} -> 
            {error, "Failed to connect"};
        {'EXIT', C, _Reason} -> 
            {error, "Connection closed"}
    end.

run_query(Conn) ->
    Sql = "SELECT id, name FROM users;",
    %% Use epgsql:squery for simple SQL execution
    case epgsql:squery(Conn, Sql) of
        {ok, Columns, Rows} ->
            io:format("Query succeeded: Columns: ~p, Rows: ~p~n", [Columns, Rows]),
            Rows;
        {error, Reason} ->
            io:format("Query failed: ~p~n", [Reason]),
            {error, Reason}
    end.

get_data() ->
    %% Connect to the database
    case connect() of
        {ok, Conn} ->
            io:format("Conn: ~p~n", [Conn]),
            %% Run the query
            run_query(Conn),
            %% Always close the connection after usage
            epgsql:close(Conn);
        {error, _} -> 
            io:format("Connection failed~n")
    end.
