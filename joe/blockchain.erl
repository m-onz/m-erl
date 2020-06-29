
-module(blockchain).
-export([ add_block/3, make_key/1, read_message/1, test/0 ]).
%% -compile(export_all).

bin_to_hexstr(Bin) ->
  lists:flatten([io_lib:format("~2.16.0B", [X]) ||
    X <- binary_to_list(Bin)]).

hexhash (T) ->
  bin_to_hexstr(crypto:hash(sha, T)).

add_block (Prev, Who, Msg) ->
  { ok, Pri } = file:read_file(Who ++ ".pri"),
  { ok, Pub } = file:read_file(Who ++ ".pub"),
  Data = term_to_binary({ Prev, Msg }),
  Proof = crypto:sign(ecdsa, sha256, Data, [ Pri, secp256k1 ]),
  Block = #{ data => Data, pub_key => Pub, proof => Proof },
  Bin = term_to_binary(Block),
  Name = hexhash(Bin),
  file:write_file(Name, Bin),
  Name.

make_key (Who) ->
  { Pub, Pri } = crypto:generate_key(ecdh, secp256k1 ),
  file:write_file(Who ++ ".pub", Pub),
  file:write_file(Who ++ ".pri", Pri).

read_and_validate_file(SHA) ->
  { ok, B } = file:read_file(SHA),
  SHA = hexhash(B),
  B.

validate_message (Pub, Bin, Proof) ->
  true = crypto:verify(
    ecdsa,
    sha256,
    Bin,
    Proof,
    [ Pub, secp256k1 ]
  ).

read_message (Block) ->
  B = read_and_validate_file(Block),
  #{ data := Data, pub_key := Pub, proof := Proof } = binary_to_term(B),
  validate_message(Pub, Data, Proof),
  { Prev, Msg } = binary_to_term(Data),
  io:format("Block:~p~nMsg=~p~n", [ Block, Msg ]),
  io:format("~p~n", [ Prev ]),
  case Prev of
    nil   -> true;
    <<>>  -> true;
    _     -> read_message(Prev)
  end.

test () ->
   blockchain:make_key("monz"),
   BLOCK1 = blockchain:add_block(nil, "monz", "turnips 1"),
   BLOCK2 = blockchain:add_block(BLOCK1, "monz", "turnips 2"),
   BLOCK3 = blockchain:add_block(BLOCK2, "monz", "turnips 3"),
   read_message(BLOCK3).

%%%
%%% end of file
