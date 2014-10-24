%%%-------------------------------------------------------------------
%%% File:      folsom_webmachine_dump_metrics_resource.erl
%%% @author    varnit khanna <varnitk@gmail.com>
%%% @doc
%%% http end point that dumps all metrics
%%% @end
%%%------------------------------------------------------------------

-module(folsom_webmachine_dump_metrics_resource).

-export([init/1,
         content_types_provided/2,
         to_json/2,
         allowed_methods/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(_) -> {ok, []}.

content_types_provided(ReqData, Context) ->
    {[{"application/json", to_json}], ReqData, Context}.

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.

to_json(ReqData, Context) ->
    Result = dump(),
    {mochijson2:encode(Result), ReqData, Context}.

%%====================================================================
%% Private
%%====================================================================
dump() ->
    generate(folsom_metrics:get_metrics(), []).

generate([], A) ->
    A;
generate([Metric | Rest], A) ->
    Type =  proplists:delete(tags, proplists:get_value(Metric,
                             folsom_metrics:get_metric_info(Metric), [])),
    Value = case proplists:get_value(type, Type) of
        counter ->
            [{count, folsom_metrics:get_metric_value(Metric)}];
        meter ->
            folsom_metrics:get_metric_value(Metric);
        spiral ->
            folsom_metrics:get_metric_value(Metric);
        gauge ->
            [{value, folsom_metrics:get_metric_value(Metric)}];
        %%TODO: implement histogram
        _ ->
            []
    end,

    MetricValue = [{Metric, lists:append(Value, Type)}],
    generate(Rest, [MetricValue | A]).
