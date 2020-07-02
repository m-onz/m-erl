
# Distributed erlang

These are notes on forming an erlang cluster with multiple machines on the same subnet.
This is practically identical to formaing an erlang cluster on the same machine.
Forming a cluster in more advanced network configurations or over the internet is slightly more complicated.

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

node().

```

## see the list of nodes that a node is connected too

```erlang

nodes().

```
