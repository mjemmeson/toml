#!/usr/bin/perl

use strict;
use Test::More;

use_ok("TOML");

# Syntactically invalid example, originally from https://rt.cpan.org/Ticket/Display.html?id=83836
my $toml = q{foo = "bar'};
my $new;
my $err;
my $serr = $TOML::SYNTAX_ERROR = $TOML::SYNTAX_ERROR ;

$new = from_toml($toml);
is($new, undef, "Invalid syntax returns <undef> in scalar context");

($new, $err) = from_toml($toml);
like($err, qr/^$serr/, 'Invalid syntax returns <undef>, $err in list context');

note "repeated table";

$toml = << 'REPEATED_TABLE';
[[fruit]]
  name = "apple"

  [[fruit.variety]]
    name = "red delicious"

  # This table conflicts with the previous table
  [fruit.variety]
    name = "granny smith"
REPEATED_TABLE

($new, $err) = from_toml($toml);
like($err, qr/^Key 'fruit.variety' already exists/, 'repeated key returns <undef>, "Key already exists" in list context');

done_testing();


