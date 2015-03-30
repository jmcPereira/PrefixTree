use strict;
use warnings;
use PrefixTree;


####teste add_dict
my $pt=PrefixTree->new("teste.txt");
#$pt->print();
$pt->add_dict("teste3.gz");
$pt->print();


####teste save /load
#my $pt=PrefixTree->new("teste.txt");
#$pt->save("ptree");
#my $pt2=PrefixTree->load("ptree");
#$pt2->print();

####teste add_word
#my $pt=PrefixTree->new("teste.txt");
#$pt->print();
#$pt->add_word("lesma");
#$pt->print();

####teste word_exists
#my $pt=PrefixTree->new("teste.txt");
#my $res=$pt->word_exists("ola");
#if($res==1){print "A palavra ola  existe\n";}
#elsif($res==0){print "A palavra ola nao existe\n";}
#my $res2=$pt->word_exists("ol");
#if($res2==1){print "A palavra ol existe\n";}
#elsif($res2==0){print "A palavra ol nao existe\n";}

####teste rem_word
#my $pt=PrefixTree->new("teste.txt");
#$pt->print();
#print "\nREMOVI A PALAVRA : lei!\n";
#$pt->rem_word("lei");
#$pt->print();
#print "\nREMOVI A PALAVRA : oi!\n";
#$pt->rem_word("oi");
#$pt->print();
#print "\nREMOVI A PALAVRA : leitura!\n";
#$pt->rem_word("leitura");
#$pt->print();
#print "\nREMOVI A PALAVRA : olga!\n";
#$pt->rem_word("olga");
#$pt->print();
#print "\nREMOVI A PALAVRA : ola!\n";
#$pt->rem_word("ola");
#$pt->print();

####teste prefix_exists
#my $pt=PrefixTree->new("teste.txt");
#my $prefixo="oi";
#my $res=$pt->prefix_exists($prefixo);
#if($res==1){print "O prefixo $prefixo existe\n";}
#elsif($res==0){print "O prefixo $prefixo nao existe\n";}