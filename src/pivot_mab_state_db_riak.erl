-module(pivot_mab_state_db_riak).

-export([add_reward/5]).

-define(BUCKET(Env), <<"pivot-event-", Env/binary>>).
-define(KEY(App, Bandit, Arm, Type), <<App/binary, ":", Bandit/binary, ":", Arm/binary, ":", Type/binary>>).

add_reward(Env, App, Bandit, Arm, Reward) ->
  riakou:do(fun(Pid) ->
    ok = riakc_pb_socket:counter_incr(Pid, ?BUCKET(Env), ?KEY(App, Bandit, Arm, <<"reward">>), Reward),
    ok = riakc_pb_socket:counter_incr(Pid, ?BUCKET(Env), ?KEY(App, Bandit, Arm, <<"count">>), 1)
    %% TODO should we increment a bandit counter just in case we want to get a total # of runs for a bandit?
  end).
