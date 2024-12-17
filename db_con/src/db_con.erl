-module(db_con).
-export([connect/0, run_query/1, get_data/0, insert_data/2]).

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



insert_data(Conn, Name) ->
    Sql = io_lib:format("INSERT INTO users (name) VALUES ('~s');", [Name]),
    case epgsql:squery(Conn, Sql) of
        {ok, _Columns, Rows} when is_list(Rows) ->
            io:format("Insert succeeded: ~s~n", [Name]),
            {ok, Name};  % Успешная вставка, возвращаем имя
        {ok, _Columns, _Rows} ->
            io:format("Insert succeeded but no rows returned~n"),
            {ok, Name};  % Вставка прошла, но нет данных для возврата
        {error, Reason} ->
            io:format("Insert failed: ~p~n", [Reason]),
            {error, Reason}
    end.