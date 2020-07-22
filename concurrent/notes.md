
## concurrent

concurrent primitives

```
spawn()
!
recieve
self()
```

```erlang

i().
processes().

self() ! { send, a, tuple, to , myself }.
flush(). % flush the mailbox to get the message

```

You can send anyerlang term using the send (bang !) primitive.

```
% sending a message to many processes at the same time
%
Pid1 ! Msg1, Pid2 ! Msg, Pid3, Msg.

% output of each process is sent to the next
%
Pid3 ! Pid2 ! Pid1 ! Msg. % is equivalent too Pid3 ! ( Pid2 ! ( Pid1 ! Msg ) )

self(). % <0, 77, 0>
pid(0, 77, 0) ! test. % use pid method to send a message to a process
flush(). % got test.

% send a message to a non-existant process, is ignored (effectivly sent into the ether)
pid(0, 55, 0) ! this_process_does_not_exist.
flush(). % no response
```
