use warnings;
use strict;
use Test::Deep;
use Test::More tests =>10;
use Test::Exception;
use Data::Dumper;


BEGIN { 
use_ok('PrefixTree');
}

my $pt=PrefixTree->new("teste.txt","teste2.gz","teste3.bz2");
subtest 'testa se objeto criado é uma instância da classe PrefixTree' => sub{
	print Dumper $pt;		
	isa_ok($pt,'PrefixTree');
};

subtest 'testa se subs existem no módulo' => sub {
can_ok('PrefixTree','new');
can_ok('PrefixTree','save');
can_ok('PrefixTree','load');
can_ok('PrefixTree','word_exists');
can_ok('PrefixTree','rem_word');
can_ok('PrefixTree','prefix_exists');
};
subtest 'testa word_exists' => sub{
ok($pt->word_exists("ola") == 1,"WORD EXISTS: ola existe.");
ok($pt->word_exists("ol") == 0,"WORD EXISTS: ol nao existe.");
ok($pt->word_exists("olga") == 1,"WORD EXISTS: olga existe.");
ok($pt->word_exists("adeus") == 1,"WORD EXISTS: adeus existe.");
};
subtest 'testa add_dict' => sub{
my $pt_add_dict=PrefixTree->new();
$pt_add_dict->add_dict("teste.txt","teste2.gz","teste3.bz2");
is_deeply($pt,$pt_add_dict,"ADD_DICT: carrega corretamente arvores");
dies_ok {my $pt_new_err_ext=PrefixTree->new("asdd.asd");} "NEW: die devido a extensao incorreta";
dies_ok {my $pt_new_err_bz2=PrefixTree->new("asdd.bz2");} "NEW: die devido a ficheiro .bz2 inexistente";
dies_ok {my $pt_new_err_gz=PrefixTree->new("asdd.gz");} "NEW: die devido a ficheiro .gz inexistente";
dies_ok {my $pt_new_err_txt=PrefixTree->new("asdd.txt");} "NEW: die devido a ficheiro .txt inexistente";
my $pt_add_dict_err_ext=PrefixTree->new();
my $pt_add_dict_err_bz2=PrefixTree->new();
my $pt_add_dict_err_gz=PrefixTree->new();
my $pt_add_dict_err_txt=PrefixTree->new();
dies_ok {$pt_add_dict_err_ext=PrefixTree->add_dict("asdd.asd");} "ADD_DICT: die devido a extensao incorreta";
dies_ok {$pt_add_dict_err_bz2=PrefixTree->add_dict("asdd.bz2");} "ADD_DICT: die devido ficheiro .bz2 inexistente";
dies_ok {$pt_add_dict_err_bz2=PrefixTree->add_dict("asdd.gz");} "ADD_DICT: die devido ficheiro .gz inexistente";
dies_ok {$pt_add_dict_err_bz2=PrefixTree->add_dict("asdd.txt");} "ADD_DICT: die devido ficheiro .txt inexistente";
};
subtest 'testa add_word' => sub{
$pt->add_word("lesma");
ok($pt->word_exists("lesma") == 1,"ADD WORD: lesma foi inserido. lesma existe!");
$pt->add_word("lagarto");
ok($pt->word_exists("lagarto") == 1,"ADD WORD: lagarto foi inserido. lagarto existe!");
};
subtest 'testa rem_word' => sub{
$pt->rem_word("lesma");
ok($pt->word_exists("lesma") == 0,"REM_WORD: lesma foi removido. lesma nao existe!");
$pt->rem_word("lagarto");
ok($pt->word_exists("lagarto") == 0,"REM_WORD: lagarto foi removido. lagarto nao existe!");
};
my $pt2=PrefixTree->load("teste_save1");
subtest 'testa save/load' => sub {
$pt->save("teste_save1");
is_deeply($pt,$pt2,"SAVE/LOAD: PrefixTree foi guardada. PrefixTree foi carregada. PrefixTree permanece igual!");
};
subtest 'testa prefix_exists' => sub{
ok($pt->prefix_exists("o") == 1,"PREFIX_EXISTS: O prefixo o existe.");
ok($pt->prefix_exists("leitura") == 1,"PREFIX_EXISTS: O prefixo leitura existe.");
ok($pt->prefix_exists("leituras") == 0,"PREFIX_EXISTS: O prefixo leituras nao existe.");
};
subtest 'testa get_words_with_prefix' => sub{
cmp_deeply($pt->get_words_with_prefix("o"),bag('oi','ola','olga'),"GET_WORDS_WITH_PREFIX: Palavras com prefixo o.");
is_deeply($pt->get_words_with_prefix("x"),[],"GET_WORDS_WITH_PREFIX: Palavras com prefixo x. Nao ha!");
};
1;
