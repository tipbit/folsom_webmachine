%%%-------------------------------------------------------------------
%%% File:      folsom_webmachine_nodes_memory_resource.erl
%%% @author    varnit khanna <varnitk@gmail.com>
%%% @doc
%%% Get memory info for all nodes in the cluster
%%% @end
%%%------------------------------------------------------------------

-module(folsom_webmachine_nodes_memory_resource).

-export([init/1, content_types_provided/2, to_json/2, allowed_methods/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(_) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
    {[{"application/json", to_json}], ReqData, Context}.

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.

to_json(ReqData, Context) ->
    Memory = [{N, folsom_vm_metrics:get_memory(N)} || N <- erlang:nodes([visible, this])],
    {mochijson2:encode(Memory), ReqData, Context}.
