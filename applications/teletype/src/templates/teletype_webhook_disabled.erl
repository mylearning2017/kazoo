%%%-------------------------------------------------------------------
%%% @copyright (C) 2015-2017, 2600Hz Inc
%%% @doc
%%%
%%% @end
%%% @contributors
%%%   James Aimonetti
%%%-------------------------------------------------------------------
-module(teletype_webhook_disabled).

-export([init/0
        ,handle_webhook_disabled/1
        ]).

-include("teletype.hrl").

-define(TEMPLATE_ID, <<"webhook_disabled">>).
-define(MOD_CONFIG_CAT, <<(?NOTIFY_CONFIG_CAT)/binary, ".", (?TEMPLATE_ID)/binary>>).

-define(TEMPLATE_MACROS
       ,kz_json:from_list(
          [?MACRO_VALUE(<<"hook.id">>, <<"hook_id">>, <<"Hook ID">>, <<"Hook ID">>)
          ,?MACRO_VALUE(<<"hook.name">>, <<"hook_name">>, <<"Hook Name">>, <<"Hook Name">>)
          ,?MACRO_VALUE(<<"hook.uri">>, <<"hook_uri">>, <<"Hook URI">>, <<"Hook URI">>)
          ,?MACRO_VALUE(<<"hook.event">>, <<"hook_event">>, <<"Hook Event">>, <<"Hook Event">>)
          ,?MACRO_VALUE(<<"hook.disable_reason">>, <<"hook_disable_reason">>, <<"Disable Reason">>, <<"Why the hook was disabled">>)
           | ?COMMON_TEMPLATE_MACROS
          ]
         )
       ).

-define(TEMPLATE_SUBJECT, <<"Webhook '{{hook.name}}' auto-disabled">>).
-define(TEMPLATE_CATEGORY, <<"webhook">>).
-define(TEMPLATE_NAME, <<"Webhook Auto-Disabled">>).

-define(TEMPLATE_TO, ?CONFIGURED_EMAILS(?EMAIL_ADMINS)).
-define(TEMPLATE_FROM, teletype_util:default_from_address(?MOD_CONFIG_CAT)).
-define(TEMPLATE_CC, ?CONFIGURED_EMAILS(?EMAIL_SPECIFIED, [])).
-define(TEMPLATE_BCC, ?CONFIGURED_EMAILS(?EMAIL_SPECIFIED, [])).
-define(TEMPLATE_REPLY_TO, teletype_util:default_reply_to(?MOD_CONFIG_CAT)).

-spec init() -> 'ok'.
init() ->
    kz_util:put_callid(?MODULE),
    teletype_templates:init(?TEMPLATE_ID, [{'macros', ?TEMPLATE_MACROS}
                                          ,{'subject', ?TEMPLATE_SUBJECT}
                                          ,{'category', ?TEMPLATE_CATEGORY}
                                          ,{'friendly_name', ?TEMPLATE_NAME}
                                          ,{'to', ?TEMPLATE_TO}
                                          ,{'from', ?TEMPLATE_FROM}
                                          ,{'cc', ?TEMPLATE_CC}
                                          ,{'bcc', ?TEMPLATE_BCC}
                                          ,{'reply_to', ?TEMPLATE_REPLY_TO}
                                          ]),
    teletype_bindings:bind(<<"webhook_disabled">>, ?MODULE, 'handle_webhook_disabled').

-spec handle_webhook_disabled(kz_json:object()) -> 'ok'.
handle_webhook_disabled(JObj) ->
    'true' = kapi_notifications:webhook_disabled_v(JObj),
    kz_util:put_callid(JObj),

    %% Gather data for template
    DataJObj = kz_json:normalize(JObj),
    AccountId = kz_json:get_value(<<"account_id">>, DataJObj),

    case teletype_util:is_notice_enabled(AccountId, JObj, ?TEMPLATE_ID) of
        'false' -> teletype_util:notification_disabled(DataJObj, ?TEMPLATE_ID);
        'true' -> handle_req(DataJObj, AccountId)
    end.

-spec handle_req(kz_json:object(), ne_binary()) -> 'ok'.
handle_req(DataJObj, AccountId) ->
    HookId = kz_json:get_value(<<"hook_id">>, DataJObj),

    lager:debug("looking for hook ~s in account ~s", [HookId, AccountId]),

    {'ok', HookJObj} = teletype_util:open_doc(<<"webhook">>, HookId, DataJObj),

    ReqData = kz_json:set_value(<<"hook">>, HookJObj, DataJObj),
    process_req(kz_json:merge_jobjs(DataJObj, ReqData)).

-spec process_req(kz_json:object()) -> 'ok'.
process_req(DataJObj) ->
    teletype_util:send_update(DataJObj, <<"pending">>),
    Macros = [{<<"account">>, teletype_util:account_params(DataJObj)}
             ,{<<"hook">>, hook_data(kz_json:get_value(<<"hook">>, DataJObj))}
             ,{<<"system">>, teletype_util:system_params()}
             ],

    %% Populate templates
    RenderedTemplates = teletype_templates:render(?TEMPLATE_ID, Macros, DataJObj),

    {'ok', TemplateMetaJObj} =
        teletype_templates:fetch_notification(?TEMPLATE_ID
                                             ,teletype_util:find_account_id(DataJObj)
                                             ),

    Subject = teletype_util:render_subject(
                kz_json:find(<<"subject">>, [DataJObj, TemplateMetaJObj], ?TEMPLATE_SUBJECT)
                                          ,Macros
               ),

    Emails = teletype_util:find_addresses(DataJObj, TemplateMetaJObj, ?MOD_CONFIG_CAT),

    case teletype_util:send_email(Emails, Subject, RenderedTemplates) of
        'ok' -> teletype_util:send_update(DataJObj, <<"completed">>);
        {'error', Reason} -> teletype_util:send_update(DataJObj, <<"failed">>, Reason)
    end.

-spec hook_data(kzd_webhook:doc()) -> kz_proplist().
hook_data(HookJObj) ->
    props:filter_undefined(
      [{<<"id">>, kz_doc:id(HookJObj)}
      ,{<<"name">>, kzd_webhook:name(HookJObj)}
      ,{<<"uri">>, kzd_webhook:uri(HookJObj)}
      ,{<<"event">>, kzd_webhook:event(HookJObj)}
      ,{<<"disable_reason">>, kzd_webhook:disabled_message(HookJObj)}
      ]).
