Nonterminals mission plateau position rovers rover commands.
Terminals int direction command.
Rootsymbol mission.

mission -> plateau rovers : {'$1', '$2'}.

plateau -> int int : {extract_token('$1'), extract_token('$2')}.

rovers -> rover        : ['$1'].
rovers -> rover rovers : ['$1' | '$2'].

rover -> position commands: {'$1', '$2'}.

position -> int int direction : {extract_token('$1'), extract_token('$2'), extract_token('$3')}.

commands -> command          : [extract_token('$1')].
commands -> command commands : [extract_token('$1') | '$2'].

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
