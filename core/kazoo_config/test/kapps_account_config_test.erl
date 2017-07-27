%%%-------------------------------------------------------------------
%%% @copyright (C) 2017, 2600Hz
%%% @doc
%%% @end
%%% @contributors
%%%-------------------------------------------------------------------
-module(kapps_account_config_test).

-include_lib("eunit/include/eunit.hrl").
-include("kazoo_config.hrl").

get_global_test_() ->
    FunToTest = fun(AccountId, Category, Key) ->
                        kapps_account_config:get_global(AccountId, Category, Key)
                end,
    SysDefaultValue = get_fixture_value(<<"default">>, "test_cat_system"),
    ResellerFixture = kapps_config_util:fixture("test_cat_reseller"),
    SubAccountFixture = kapps_config_util:fixture("test_cat_subaccount2"),

    [{"Testing get global account config"
     ,[{"customized sub-account on get_global/2 should result in account"
       ,?_assertEqual(SubAccountFixture, kapps_account_config:get_global(?CUSTOMIZED_SUBACCOUNT, ?TEST_CAT))
       }
      ,{"undefined sub-account on get_global/2 should result in system_config"
       ,?_assertEqual(SysDefaultValue, kapps_account_config:get_global(undefined, ?TEST_CAT))
       }
      ,{"not customized sub-account and customized reseller on get_global/2 should result in reseller"
       ,?_assertEqual(ResellerFixture, kapps_account_config:get_global(?CUSTOMIZED_RESELLER, ?TEST_CAT))
       }
      ,{"not customized sub-account and reseller on get_global/2 should result in system_config"
       ,?_assertEqual(SysDefaultValue, kapps_account_config:get_global(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT))
       }
      ,{"not customized sub-account and reseller and empty system_config on get_global/2 should result in empty"
       ,?_assertEqual(kz_json:new(), kapps_account_config:get_global(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT_EMPTY))
       }
      ,{"non exisiting category on get_global/2 should result in empty"
       ,?_assertEqual(kz_json:new(), kapps_account_config:get_global(?NOT_CUSTOMIZED_ALL_ACCOUNTS, <<"no_cat">>))
       }
      ,common_global_tests(FunToTest)
      ]
     }
    ].

common_global_tests(Fun) ->
    SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),
    ResellerValue = get_fixture_value(<<"root_obj_key">>, "test_cat_reseller"),
    SubAccountValue = get_fixture_value(<<"root_obj_key">>, "test_cat_subaccount2"),

    [{"undefined account id should result in system_config"
      ,?_assertEqual(SysValue, Fun(undefined, ?TEST_CAT, <<"root_obj_key">>))
     }
    ,{"not customized sub-account and reseller should result in system_config"
     ,?_assertEqual(SysValue, Fun(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT, <<"root_obj_key">>))
     }
    ,{"not customized sub-account and customized reseller should result in reseller"
     ,?_assertEqual(ResellerValue, Fun(?CUSTOMIZED_RESELLER, ?TEST_CAT, <<"root_obj_key">>))
     }
    ,{"not customized sub-account and customized reseller with undefined key should result in system_config"
     ,?_assertEqual(SysValue, Fun(?CUSTOMIZED_RESELLER_UNDEFINED, ?TEST_CAT, <<"root_obj_key">>))
     }
    ,{"customized sub-account with undefined key should result in system_config"
     ,?_assertEqual(SysValue, Fun(?CUSTOMIZED_SUBACCOUNT_UNDEFINED, ?TEST_CAT, <<"root_obj_key">>))
     }
    ,{"customized sub-account should result in account"
     ,?_assertEqual(SubAccountValue, Fun(?CUSTOMIZED_SUBACCOUNT, ?TEST_CAT, <<"root_obj_key">>))
     }
    ].

get_from_reseller_test_() ->
    SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),
    Default = kz_json:from_list([{<<"new_key">>, <<"new_val">>}]),

    [{"Testing get config from reseller"
     ,[{"not customized reseller should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_from_reseller(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT, <<"root_obj_key">>))
       }
      ,{"not customized reseller and empty system_config should result in default"
       ,?_assertEqual(Default, kapps_account_config:get_from_reseller(?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT_EMPTY, <<"new_key">>, Default))
       }
      ]
     }
    ].

get_with_strategy_test_() ->
    [{"Testing getting account config with strategy"
     ,[get_with_strategy_general()
      ,get_startegy_global_from_sub_account()
      ]
     }
    ].

get_with_strategy_general() ->
    SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),

    Default = kz_json:from_list([{<<"new_key">>, <<"new_val">>}]),
    Db = kz_util:format_account_db(?NOT_CUSTOMIZED_ALL_ACCOUNTS),

    [{"Testing strategy with no account id"
     ,[{"undefined account id should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, 'undefined', ?TEST_CAT, <<"root_obj_key">>))
       }
      ,{"empty call object account id should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, kapps_call:new(), ?TEST_CAT, <<"root_obj_key">>))
       }
      ,{"empty jobj object account id should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, kz_json:new(), ?TEST_CAT, <<"root_obj_key">>))
       }
      ,{"unkown object account id should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, maps:new(), ?TEST_CAT, <<"root_obj_key">>))
       }
      ,{"passing non raw account id where account is not customized should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, Db, ?TEST_CAT, <<"root_obj_key">>))
       }
      ,{"passing non raw account id in jobj where account is not customized should result in system_config"
       ,?_assertEqual(SysValue, kapps_account_config:get_with_strategy(<<"global">>, kz_json:from_list([{<<"account_id">>, Db}]), ?TEST_CAT, <<"root_obj_key">>))
       }
      ]
     }
    ,{"Testing some general situation"
     ,[{"not customized account and reseller and empty system_config should result in set on system_config"
       ,?_assertEqual(Default, kapps_account_config:get_with_strategy(<<"global">>, ?NOT_CUSTOMIZED_ALL_ACCOUNTS, ?TEST_CAT_EMPTY, <<"new_key">>, Default))
       }
      ,{"not customized account and reseller and not exisits system_config should result in set on system_config"
       ,?_assertEqual(Default, kapps_account_config:get_with_strategy(<<"global">>, ?EMPTY_ALL, ?TEST_CAT_EMPTY, <<"new_key">>, Default))
       }
      ]
     }
    ].

get_startegy_global_from_sub_account() ->
    FunToTest = fun(AccountId, Category, Key) ->
                        kapps_account_config:get_with_strategy(<<"global">>, AccountId, Category, Key)
                end,
    %% SysValue = get_fixture_value([<<"default">>, <<"root_obj_key">>], "test_cat_system"),
    %% ResellerValue = get_fixture_value(<<"root_obj_key">>, "test_cat_reseller"),

    [{"Testing global strategy for sub-account"
     ,common_global_tests(FunToTest)
     }
    ].

get_fixture_value(Key, Fixture) ->
    kz_json:get_value(Key, kapps_config_util:fixture(Fixture)).
