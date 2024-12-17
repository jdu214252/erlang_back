-module(my_postgres_app_app).
-export([start/0, get_users/0]).



start() ->
    case get_users() of
        {ok, Users} -> 
            io:format("Users: ~p~n", [Users]);
        {error, Reason} -> 
            io:format("Failed to connect to the database: ~p~n", [Reason])
    end.

get_users() ->
    Host = "localhost",
    Port = 5432,
    DbName = "mydb",
    Username = "myuser",
    Password = "mypassword",

    case epgsql:connect(Host, Port, DbName, Username, Password) of
        {ok, C} ->
            Sql = "SELECT usename FROM pg_user;",
            case epgsql:equery(C, Sql) of
                {ok, Result} ->

                    Users = lists:map(fun({[User], _}) -> User end, Result),
                    {ok, Users};
                {error, Reason} ->
                    {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason}
    end.
