%%
%% hash.erl
%% @author m-onz
%%
%% example.
%% > erl
%% > c("hash.erl").
%%
%% [source](https://github.com/joearms/crypto_tutorial)
%% [source](http://necrobious.blogspot.com/2008/03/binary-to-hex-string-back-to-binary-in.html)
%%

-module(hash).
-export([ file/2, sha256/1, sha1/1, digest_hex/2, sha256_hex/1, sha1_hex/1 ]).

bin_to_hexstr(Bin) ->
  lists:flatten([io_lib:format("~2.16.0B", [X]) ||
    X <- binary_to_list(Bin)]).

%% hash a file, provide the algorithm
%% see erlang documentation for a list of available algorithms
%% http://erlang.org/doc/man/crypto.html#type-sha1
%%
%% example usage:
%% hash:file("beam.text", sha)
%%
%%
%% sha1 :: sha
%% sha2 :: sha224 | sha256 | sha384 | sha512
%% sha3 :: sha3_224 | sha3_256 | sha3_384 | sha3_512*
%% blake2 :: blake2b | blake2s*
%%
%% certain algorithms may not be available
%% it depends on your erlang OTP version
%% and which version of openSSL it was compiled with
%%
file(File, Algorithm) ->
  hash_file(File, Algorithm).

%% hash:sha256("./hash.beam").
%%
sha256(File) ->
    hash_file(File, sha256).

sha1(File) ->
    hash_file(File, sha).

hash_file(File, Method) ->
    % the file can be huge so read it in chunks
    case file:open(File, [binary,raw,read]) of
	{ok, P} -> hash_loop(P, crypto:hash_init(Method));
	Error   -> Error
    end.

hash_loop(P, C) ->
    case file:read(P, 4096) of
	{ok, Bin} ->
	    hash_loop(P, crypto:hash_update(C, Bin));
	eof ->
	    file:close(P),
	    {ok, crypto:hash_final(C)}
    end.

%% hash:sha256_hex(<<"turnips">>)
%% in node...
%% console.log('sha1 ',crypto.createHash('sha1').update('turnips').digest('hex'))
%%
sha1_hex (T) ->
  bin_to_hexstr(crypto:hash(sha, T)).

%% console.log('sha256 ', crypto.createHash('sha256').update('turnips').digest('hex'))
%%
sha256_hex (T) ->
  bin_to_hexstr(crypto:hash(sha256, T)).

%% hash:digest_hex(<<turnips>>, sha512).
%%
digest_hex(T, Algorithm) ->
  bin_to_hexstr(crypto:hash(Algorithm, T)).

%% // verify erlang code with equivellent js (node) code...
%% var crypto = require('crypto')
%% console.log('sha1 ',crypto.createHash('sha1').update('turnips').digest('hex'))
%% console.log('sha256 ', crypto.createHash('sha256').update('turnips').digest('hex'))
