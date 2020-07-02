
# Distributed erlang

## Form an erlang cluster with multiple machines on the same subnet.

On each machine run...

```sh

erl -sname dilbert -setcookie <cluster_namespace>

```

There are different ways to connect the mesh, this uses an RPC call establish connections between machines.

```erlang

rpc:call(dilbert@machine1, erlang, node, []).

```

Erlang clusters form a fully connected mesh by default (each machine can contact any other machine).

## check your nodes name

```erlang

node()

```

## see the list of nodes that a node is connected too

```erlang

nodes()

```
