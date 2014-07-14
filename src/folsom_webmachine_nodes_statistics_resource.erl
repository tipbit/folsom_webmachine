%%%-------------------------------------------------------------------
%%% File:      folsom_webmachine_nodes_statistics_resource.erl
%%% @author    varnit khanna <varnitk@gmail.com>
%%% @doc
%%% Get statistics for all nodes in the cluster
%%% @end
%%%------------------------------------------------------------------

-module(folsom_webmachine_nodes_statistics_resource).

-export([init/1, content_types_provided/2, to_json/2, allowed_methods/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(_) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
    {[{"application/json", to_json}], ReqData, Context}.

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.

to_json(ReqData, Context) ->
    Statistics = [{N, folsom_vm_metrics:get_statistics(N)} || N <- erlang:nodes([visible, this])],
    {mochijson2:encode(Statistics), ReqData, Context}.
