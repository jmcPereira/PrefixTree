package PrefixTree;
use strict;
use Exporter;
use IO::Uncompress::Gunzip qw(gunzip);
use IO::Uncompress::Bunzip2 qw(bunzip2);
use Data::Dumper;
our @ISA=qw(Exporter);
our @EXPORT=qw();
our @EXPORTER_OK=qw(print save load add_dict add_word rem_word get_words_with_prefix prefix_exists word_exists);


sub new {
	my($class, @ficheiros) = @_;
	my $dicionario={};
	
	foreach my $ficheiro (@ficheiros){
		my ($ext) = $ficheiro =~ /\.([^.]+)$/;
		if ($ext eq "gz"){
			print "A descompactar ",$ficheiro,"...\n";
			my $descompactado_gz = new IO::Uncompress::Gunzip $ficheiro;
		}
		elsif ($ext eq "bz2"){
			print "A descompactar ",$ficheiro,"...\n";
			my $descompactado_bz2=new IO::Uncompress::Bunzip2 $ficheiro;
		}
		elsif ($ext eq "txt"){
			my $stream;
			open($stream, "<", $ficheiro);
			while(<$stream>){
				chomp;
				lepalavra($_,$dicionario);
			};
		}
		else {print "Erro: Formato desconhecido em ",$ficheiro,"\n";}
		
	}
	return bless {dicionario =>$dicionario},$class;
}

sub lepalavra{
	my ($palavra,$dic2)=@_;
	my @letras=split //, $palavra;
	foreach my $letra (@letras){
		if(not exists $dic2->{$letra}){
			$dic2->{$letra}={};
			}
		$dic2=$dic2->{$letra};
	}
}

sub print{
	my ($self)=@_;
	my $href=$self->{dicionario};
	print Dumper($href);
	delete $href->{$_};
}
1;