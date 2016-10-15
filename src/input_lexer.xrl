Definitions.

INT        = [0-9]+
DIRECTION  = [NSEW]
COMMAND    = [RLM]
WHITESPACE = [\s\t\n\r]

Rules.

{INT}         : {token, {int,       TokenLine, list_to_integer(TokenChars)}}.
{DIRECTION}   : {token, {direction, TokenLine, TokenChars}}.
{COMMAND}     : {token, {command,   TokenLine, TokenChars}}.
{WHITESPACE}+ : skip_token.

Erlang code.
