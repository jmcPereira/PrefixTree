use warnings;
use strict;
use Test::More tests =>20;

BEGIN { use_ok('PrefixTree');
	}

#testa se objeto criado é uma instância da classe PrefixTree.
my $pt=PrefixTree->new("teste.txt");
isa_ok($pt,'PrefixTree');

#testa se subs existem no módulo.
can_ok('PrefixTree','new');
can_ok('PrefixTree','save');
can_ok('PrefixTree','load');
can_ok('PrefixTree','word_exists');
can_ok('PrefixTree','rem_word');
can_ok('PrefixTree','prefix_exists');

#testa word_exists
ok($pt->word_exists("ola") == 1,"WORD EXISTS: ola existe.");
ok($pt->word_exists("ol") == 0,"WORD EXISTS: ol nao existe.");
ok($pt->word_exists("olga") == 1,"WORD EXISTS: olga existe.");
ok($pt->word_exists("adeus") == 1,"WORD EXISTS: adeus existe.");

#testa add_word
$pt->add_word("lesma");
ok($pt->word_exists("lesma") == 1,"ADD WORD: lesma foi inserido. lesma existe!");
$pt->add_word("lagarto");
ok($pt->word_exists("lagarto") == 1,"ADD WORD: lagarto foi inserido. lagarto existe!");

#testa rem_word
$pt->rem_word("lesma");
ok($pt->word_exists("lesma") == 0,"REM_WORD: lesma foi removido. lesma nao existe!");
$pt->rem_word("lagarto");
ok($pt->word_exists("lagarto") == 0,"REM_WORD: lagarto foi removido. lagarto nao existe!");

#testa save/load
$pt->save("teste_save");
my $pt2=PrefixTree->load("teste_save");
is_deeply($pt,$pt2,"SAVE/LOAD: PrefixTree foi guardada. PrefixTree foi carregada. PrefixTree permanece igual!");

#testa prefix_exists
ok($pt->prefix_exists("o") == 1,"PREFIX_EXISTS: O prefixo o existe.");
ok($pt->prefix_exists("leitura") == 1,"PREFIX_EXISTS: O prefixo leitura existe.");
ok($pt->prefix_exists("leituras") == 0,"PREFIX_EXISTS: O prefixo leituras nao existe.");