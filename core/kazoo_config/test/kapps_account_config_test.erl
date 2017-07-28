%%%-------------------------------------------------------------------
%%% @copyright (C) 2017, 2600Hz
%%% @doc
%%% @end
%%% @contributors
%%%-------------------------------------------------------------------
-module(kapps_account_config_test).

-include_lib("eunit/include/eunit.hrl").
-include("kazoo_config.hrl").

% get_ne_binary_test_() ->
%     % SysDefaultValue = get_fixture_value(<<"default">>, "test_cat_system"),
%     [{"Testing get_ne_binary account config"
%      ,[{"get a key with binary value"
%        ,?_assertEqual(true, is_ne_binary(kapps_account_config:get_ne_binary(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, [<<"root_obj_key">>, <<"b_key">>])))
%        }
%       %% ,{"get a non castable to binary value should crash"
%       %%  ,?_assertEqual(undefined, is_ne_binary(kapps_account_config:get_ne_binary(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, [<<"root_obj_key">>, <<"obj_key">>])))
%       %%  }
%       ,{"get a castable to binary value should it as binary"
%        ,?_assertEqual(true, is_ne_binary(kapps_account_config:get_ne_binary(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, [<<"root_obj_key">>, <<"i_key">>])))
%        }
%       ,{"get an empty value should reutrn default"
%        ,?_assertEqual(undefined, kapps_account_config:get_ne_binary(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, <<"not_exists">>))
%        }
%       ,{"get a list of binary value should reutrn list of binary"
%        ,?_assertEqual(true, is_ne_binaries(kapps_account_config:get_ne_binaries(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, [<<"root_obj_key">>, <<"b_keys">>])))
%        }
%       ,{"get not a list of binary value should reutrn Default"
%        ,?_assertEqual(undefined, kapps_account_config:get_ne_binaries(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, [<<"root_obj_key">>, <<"b_key">>]))
%        }
%       ,{"get an empty list of binary value should reutrn Default"
%        ,?_assertEqual(undefined, kapps_account_config:get_ne_binaries(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, [<<"root_obj_key">>, <<"b_key">>]))
%        }
%       ]
%      }
%     ].

% is_ne_binary(Value) -> kz_term:is_ne_binary(Value).
% is_ne_binaries(Value) -> kz_term:is_ne_binaries(Value).

% get_global_test_() ->
%     FunToTest = fun(AccountId, Category, Key) ->
%                         kapps_account_config:get_global(AccountId, Category, Key)
%                 end,
%     SysDefaultValue = get_fixture_value(<<"default">>, "test_cat_system"),
%     ResellerFixture = kapps_config_util:fixture("test_cat_reseller"),
%     SubAccountFixture = kapps_config_util:fixture("test_cat_subaccount_1"),

%     [{"Testing get global account config"
%      ,[{"customized sub-account on get_global/2 should result in account"
%        ,?_assertEqual(SubAccountFixture, kapps_account_config:get_global(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT))
%        }
%       ,{"undefined sub-account on get_global/2 should result in system_config"
%        ,?_assertEqual(SysDefaultValue, kapps_account_config:get_global(undefined, ?TEST_CAT))
%        }
%       ,{"not customized sub-account and customized reseller on get_global/2 should result in reseller"
%        ,?_assertEqual(ResellerFixture, kapps_account_config:get_global(?CUSTOMIZED_RESELLER, ?TEST_CAT))
%        }
%       ,{"not customized sub-account and reseller on get_global/2 should result in system_config"
%        ,?_assertEqual(SysDefaultValue, kapps_account_config:get_global(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT))
%        }
%       ,{"not customized sub-account and reseller and empty system_config on get_global/2 should result in empty"
%        ,?_assertEqual(kz_json:new(), kapps_account_config:get_global(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT_EMPTY))
%        }
%       ,{"non exisiting category on get_global/2 should result in empty"
%        ,?_assertEqual(kz_json:new(), kapps_account_config:get_global(?NOT_CUSTOMIZED_ALL_ACCOUNTS, <<"no_cat">>))
%        }
%       ,common_get_global_tests(FunToTest)
%       ]
%      }
%     ].

% common_get_global_tests(Fun) ->
%     SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),
%     ResellerValue = get_fixture_value(<<"root_obj_key">>, "test_cat_reseller"),
%     SubAccountValue = get_fixture_value(<<"root_obj_key">>, "test_cat_subaccount_1"),

%     [{"Common get global account config"
%      ,[{"undefined account id should result in system_config"
%        ,?_assertEqual(SysValue, Fun(undefined, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"not customized sub-account and reseller should result in system_config"
%        ,?_assertEqual(SysValue, Fun(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"not customized sub-account and customized reseller should result in reseller"
%        ,?_assertEqual(ResellerValue, Fun(?CUSTOMIZED_RESELLER, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"not customized sub-account and empty customized reseller should result in system_config"
%        ,?_assertEqual(SysValue, Fun(?CUSTOMIZED_RESELLER_UNDEFINED, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"empty customized sub-account should result in system_config"
%        ,?_assertEqual(SysValue, Fun(?CUSTOMIZED_SUBACCOUNT_1_UNDEFINED, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"customized sub-account should result in account"
%        ,?_assertEqual(SubAccountValue, Fun(?CUSTOMIZED_SUBACCOUNT_1, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ]
%      }
%     ].

% get_from_reseller_test_() ->
%     FunToTest = fun(Args) when length(Args) =:= 3 ->
%                         apply(fun kapps_account_config:get_global/3, Args);
%                    (Args) when length(Args) =:= 4 ->
%                         apply(fun kapps_account_config:get_global/4, Args)
%                 end,
%     [{"Testing get config from reseller"
%      ,common_get_from_reseller_tests(FunToTest)
%      }
%     ].

% common_get_from_reseller_tests(FunToTest) ->
%     SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),
%     Default = kz_json:from_list([{<<"new_key">>, <<"new_val">>}]),
%     ResellerValue = get_fixture_value(<<"root_obj_key">>, "test_cat_reseller"),

%     [{"Common get config from reseller tests"
%      ,[{"undefined account id should result in system_config"
%        ,?_assertEqual(SysValue, FunToTest([undefined, ?TEST_CAT, <<"root_obj_key">>]))
%        }
%       ,{"not customized reseller should result in system_config"
%        ,?_assertEqual(SysValue, FunToTest([?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT, <<"root_obj_key">>]))
%        }
%       ,{"not customized reseller and empty system_config should result in set Default on system_config"
%        ,?_assertEqual(Default, FunToTest([?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT_EMPTY, <<"new_key">>, Default]))
%        }
%       ,{"empty customized reseller should result in system_config"
%        ,?_assertEqual(SysValue, FunToTest([?CUSTOMIZED_RESELLER_UNDEFINED, ?TEST_CAT, <<"root_obj_key">>, Default]))
%        }
%       ,{"customized reseller should result in reseller"
%        ,?_assertEqual(ResellerValue, FunToTest([?CUSTOMIZED_RESELLER, ?TEST_CAT, <<"root_obj_key">>, Default]))
%        }
%       ]
%      }
%     ].

get_with_strategy_test_() ->
    [{"Testing getting account config with strategy"
     ,[get_startegy_hierarchy_merge()
      % ,get_startegy_global()
      % ,get_startegy_reseller()
      % ,get_with_strategy_general()
      ]
     }
    ].

get_startegy_hierarchy_merge() ->
    DummyAccountId = kz_binary:rand_hex(16),
    SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),
    % SubAccountValue = get_fixture_value(<<"root_obj_key">>, "test_cat_subaccount_1"),

    [{"Testing get config hierarchy_merge strategy"
     ,[{"customized account"
       ,?_assertEqual(ok
        ,io:format(user, "\n" ++ "~p~n", [kapps_account_config:get_with_strategy(<<"hierarchy_merge">>, ?CUST_A_CUST_P_CUST_R, ?TEST_CAT, <<"root_obj_key">>)]))
       }
      % ,{"not customized account with undefined parent account id and no reseller should result in system_config"
      %  ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"hierarchy_merge">>, DummyAccountId, ?TEST_CAT, <<"root_obj_key">>))
      %  }
      ]
     }
    ].

%%
%% Test Customized Account scenario
%%
%%  A
%%  |
%%  `-> P -> R ==> APR
%%  |   `--> E(R) ==> AP
%%  |   `--> N(R) ==> AP
%%  |
%%  `-> E(P) -> R ==> AR
%%  |   `-----> E(R) ==> A
%%  |   `-----> N(R) ==> A
%%  |
%%  `-> N(P) -> R ==> AR
%%      `-----> E(R) ==> A
%%      `-----> N(R) ==> A


% get_with_strategy_general() ->
%     SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),

%     Default = kz_json:from_list([{<<"new_key">>, <<"new_val">>}]),
%     Db = kz_util:format_account_db(?NOT_CUSTOMIZED_ALL_ACCOUNTS),

%     [{"Testing strategy with no account id"
%      ,[{"undefined account id should result in system_config"
%        ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, undefined, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"empty call object account id should result in system_config"
%        ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, kapps_call:new(), ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"empty jobj object account id should result in system_config"
%        ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, kz_json:new(), ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"unkown object account id should result in system_config"
%        ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, maps:new(), ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"passing non raw account id where account is not customized should result in system_config"
%        ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, Db, ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ,{"passing non raw account id in jobj where account is not customized should result in system_config"
%        ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, kz_json:from_list([{<<"account_id">>, Db}]), ?TEST_CAT, <<"root_obj_key">>))
%        }
%       ]
%      }
%     ,{"Testing some general situation"
%      ,[{"not customized account and reseller and empty system_config should result in set Default on system_config"
%        ,?_assertEqual(Default, kapps_account_config:get_with_strategy(<<"global">>, ?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT_EMPTY, <<"new_key">>, Default))
%        }
%       ,{"not customized account and reseller and not exisits system_config should result in set Default on system_config"
%        ,?_assertEqual(Default, kapps_account_config:get_with_strategy(<<"global">>, ?NO_CONFIG, <<"no_cat">>, <<"new_key">>, Default))
%        }
%       ]
%      }
%     ].

% get_startegy_global() ->
%     FunToTest = fun(AccountId, Category, Key) ->
%                         kapps_account_config:get_with_strategy(<<"global">>, AccountId, Category, Key)
%                 end,
%     [{"Testing get config global strategy"
%      ,common_get_global_tests(FunToTest)
%      }
%     ].

% get_startegy_reseller() ->
%     FunToTest = fun(Args) when length(Args) =:= 3 ->
%                         apply(fun kapps_account_config:get_with_strategy/4, [<<"reseller">>|Args]);
%                    (Args) when length(Args) =:= 4 ->
%                         apply(fun kapps_account_config:get_with_strategy/5, [<<"reseller">>|Args])
%                 end,
%     [{"Testing get config reseller strategy"
%      ,common_get_from_reseller_tests(FunToTest)
%      }
%     ].

get_fixture_value(Key, Fixture) ->
    kz_json:get_value(Key, kapps_config_util:fixture(Fixture)).