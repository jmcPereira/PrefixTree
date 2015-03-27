package PrefixTree;
use strict;
use Exporter;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError) ;
use IO::Uncompress::Bunzip2 qw(bunzip2 $Bunzip2Error);
use Data::Dumper;
use Storable;
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
			my $fh = IO::Uncompress::Gunzip->new($ficheiro) 
				or die "Erro ao descompactar ",$ficheiro," !!!\n\t-> ",$GunzipError;
			while(<$fh>) {
				chomp;
				$_ =~ s/^\s*(.*?)\s*$/$1/;
				if($_ ne ""){lepalavra($_,$dicionario);}
			}
		}
		elsif ($ext eq "bz2"){
			print "A descompactar ",$ficheiro,"...\n";
			my $fh=new IO::Uncompress::Bunzip2 $ficheiro 
				or die "Erro ao descompactar ",$ficheiro," !!!\n\t-> ",$Bunzip2Error;
			while(<$fh>){
				chomp;
				$_ =~ s/^\s*(.*?)\s*$/$1/;
				if($_ ne ""){lepalavra($_,$dicionario);}
			};
		}
		elsif ($ext eq "txt"){
			my $stream;
			open($stream, "<", $ficheiro);
			print "A ler ",$ficheiro," ...\n";
			while(<$stream>){
				chomp;
				if($_ ne ""){lepalavra($_,$dicionario);}
			};
		}
		else {die "Erro: Formato desconhecido em ",$ficheiro,"\n";}
		
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
	$dic2->{"."}={};
}

sub print{
	my ($self)=@_;
	my $href=$self->{dicionario};
	print Dumper($href);
}

sub save{
	my ($self,$ficheiro)=@_;
	store $self,$ficheiro;	
	}
	
sub load{
	my ($self,$ficheiro)=@_;
	$self=retrieve($ficheiro);
	}

sub add_dict{
	my($self, @ficheiros) = @_;
	my $dicionario=$self->{dicionario};
	
	foreach my $ficheiro (@ficheiros){
		my ($ext) = $ficheiro =~ /\.([^.]+)$/;
		if ($ext eq "gz"){
			print "A descompactar ",$ficheiro,"...\n";
			my $fh = IO::Uncompress::Gunzip->new($ficheiro) 
				or die "Erro ao descompactar ",$ficheiro," !!!\n\t-> ",$GunzipError;
			while(<$fh>) {
				chomp;
				$_ =~ s/^\s*(.*?)\s*$/$1/;
				if($_ ne ""){lepalavra($_,$dicionario);}
			}
		}
		elsif ($ext eq "bz2"){
			print "A descompactar ",$ficheiro,"...\n";
			my $fh=new IO::Uncompress::Bunzip2 $ficheiro 
				or die "Erro ao descompactar ",$ficheiro," !!!\n\t-> ",$Bunzip2Error;
			while(<$fh>){
				chomp;
				$_ =~ s/^\s*(.*?)\s*$/$1/;
				if($_ ne ""){lepalavra($_,$dicionario);}
			};
		}
		elsif ($ext eq "txt"){
			my $stream;
			open($stream, "<", $ficheiro);
			print "A ler ",$ficheiro," ...\n";
			while(<$stream>){
				chomp;
				if($_ ne ""){lepalavra($_,$dicionario);}
			};
		}
		else {die "Erro: Formato desconhecido em ",$ficheiro,"\n";}
		
		}
	}

sub add_word{
	my ($self,$palavra)=@_;
	chomp $palavra;
	lepalavra($palavra,$self->{dicionario});
	}
	
sub rem_word{
	my ($self,$palavra)=@_;
	if($self->word_exists($palavra)==0){die "Palavra nao existe!";}
	else{
		my $dic2=$self->{dicionario};
		my $dic_temp=0;
		my $count=0;
		my $letra;
		my $letra_temp="";
		my @letras=split //, $palavra;
		foreach $letra (@letras){
			$count=values $dic2->{$letra};
			if ($count>1){$dic_temp=0;$letra_temp="";}
			print "COUNT: ",$count,"\n";
			if($count==1 and $letra_temp eq ""){
				$dic_temp=$dic2;
				$letra_temp=$letra;
				print "Temporaria",$letra_temp,"\n";
				}
			$dic2=$dic2->{$letra};
		}
		if($dic_temp!=0){delete $dic_temp->{$letra_temp};}
		else {delete $dic2->{"."};}
	}
	}

sub word_exists{
	my ($self,$palavra)=@_;
	my $dic2=$self->{dicionario};
	my @letras=split //, $palavra;
	foreach my $letra (@letras){
		if(not exists $dic2->{$letra}){
			return 0;
			}
		$dic2=$dic2->{$letra};
	}
	if(exists $dic2->{"."}) {return 1;}
	else {return 0;}
	}
	
sub prefix_exists{
	my ($self,$prefixo)=@_;
	my $dic2=$self->{dicionario};
	my @letras=split //, $prefixo;
	foreach my $letra (@letras){
		if(not exists $dic2->{$letra}){
			return 0;
			}
		$dic2=$dic2->{$letra};
	}
	return 1;
	}
	
1;