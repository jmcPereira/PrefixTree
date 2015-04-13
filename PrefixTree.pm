 package PrefixTree;
use strict;
use Data::Dumper;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError) ;
use IO::Uncompress::Bunzip2 qw(bunzip2 $Bunzip2Error);
use Storable;
use Switch;

BEGIN {

    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '2.0';
    @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw();
    @EXPORT_OK   = qw(save load add_dict add_word rem_word get_words_with_prefix prefix_exists word_exists);
    %EXPORT_TAGS = ();
}


#################### subroutine header begin ####################

=head2 new

 Usage     : A subrotina new é usada para criar uma PrefixTree
 Purpose   : New cria uma PrefixTree com as palavras contidas nos ficheiros inseridos
 Returns   : Retorna uma PrefixTree
 Argument  : Uma lista de ficheiros do tipo txt ou gz ou bz2
 Throws    : 
 Comment   : 
See Also   :

=cut

#################### subroutine header end ####################

sub new {
	my($class, @ficheiros) = @_;
<<<<<<< HEAD
        my $dicionario = {};
	my $res = bless {dicionario => $dicionario};
	$res->add_dict(@ficheiros);
        return bless {dicionario =>$res->{dicionario}},$class;
}



#################### subroutine header begin ####################

=head2 save

 Usage     : A subrotina save é usada para armazenar o objecto em disco
 Purpose   : Save, serve para não perdermos os dados já existentes
 Returns   : 
 Argument  : Nome do ficheiro onde gravar o objecto
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################

sub save{
        my ($self,$ficheiro)=@_;
        store $self,$ficheiro;
}

#################### subroutine header begin ####################

=head2 load

 Usage     : A subrotina load é usada para carregar uma PrefixTree já existente
 Purpose   : Load permite carregar dados anteriormente gravados
 Returns   : Retorna uma PrefixTree
 Argument  : O nome do ficheiro a ler
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################
sub load{
	my ($self,$ficheiro)=@_;
	$self=retrieve($ficheiro);
}

#################### subroutine header begin ####################

=head2 add_dict

 Usage     : A subrotina add_dict é usada para adicionar mais ficheiros à PrefixTree
 Purpose   : Add_dict permite adicionar ficheiros a uma PrefixTree já existente
 Returns   : 
 Argument  : Uma lista com  os nomes dos ficheiros no formato txt ou bz2 ou gz
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################

sub add_dict{
        my($self, @ficheiros) = @_;
        my $dicionario=$self->{dicionario};
=======
	my $dicionario={};
>>>>>>> e79995e612ea2e8b5576c221108835fa362c7f6c
	foreach my $ficheiro (@ficheiros){
                my ($ext) = $ficheiro =~ /\.([^.]+)$/;
                my $fh;

                switch($ext){
                        case "gz" {
                                $fh = IO::Uncompress::Gunzip->new($ficheiro)
                                    or die "Erro ao descompactar ",$ficheiro," !!!\n\t-> ",$GunzipError;
                        }
                        case "bz2" {
                                $fh=new IO::Uncompress::Bunzip2 $ficheiro
                                    or die "Erro ao descompactar ",$ficheiro," !!!\n\t-> ",$Bunzip2Error;
                        }
                        case "txt" {
                                open($fh, "<", $ficheiro) or die "Erro ao abrir ",$ficheiro," !!!";
                        }
                        else {
                                die "Erro: Formato desconhecido em ",$ficheiro,"\n"
                        }
                }
                while(<$fh>){
                        chomp;
                        s/^\s*(.*?)\s*$/$1/;
                        if($_ ne ""){ 
				$self->add_word($_);
			}
                }
        }
}

#################### subroutine header begin ####################

=head2 add_word

 Usage     : A subrotina add_word é usada para adicionar mais uma palavra
 Purpose   : Add_word é usada quando queremos adicionar uma nova palavra à PrefixTree
 Returns   : 
 Argument  : Uma palavra
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################
sub add_word{
        my ($self,$palavra)=@_;
        chomp $palavra;
	my $dic= $self->{dicionario};
	
        my @letras=split //, $palavra;
        foreach my $letra (@letras){
                if(not exists $dic->{$letra}){
                        $dic->{$letra}={};
         	}
                $dic=$dic->{$letra};
        }
        $dic->{"##"}={};

}

#################### subroutine header begin ####################

=head2 rem_word

 Usage     : A subrotina rem_word é usada para remover uma palavra
 Purpose   : Rem_word é usada quando queremos remover uma palavra da PrefixTree
 Returns   : 
 Argument  : Uma palavra
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################

sub rem_word{
        my ($self,$palavra)=@_;
        if($self->word_exists($palavra)==0){
		 die "Palavra nao existe!";
	}
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
                        if($count==1 and $letra_temp eq ""){
                                $dic_temp=$dic2;
                                $letra_temp=$letra;
                        }
                        $dic2=$dic2->{$letra};
                }
                if($dic_temp!=0){
			 delete $dic_temp->{$letra_temp};
		}
                else{ 
		    delete $dic2->{"##"};
		}
        }
}

#################### subroutine header begin ####################

=head2 get_words_with_prefix

 Usage     : A subrotina get-words_with_prefix é usada para procurar palavras com um certo prefixo
 Purpose   : Get-words_with_prefix tem o intuito de fornecer uma lista de palavras que comecem por uma certa palavra
 Returns   : Retorna uma lista de palavras
 Argument  : O prefixo pelo qual se quer que as palavras comecem
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################

sub get_words_with_prefix{
        my ($self,$prefixo)=@_;
        my $dic=$self->{dicionario};
        my @words;
        if($self->prefix_exists($prefixo)==0){return [];}
        else {
                my @letras=split //,$prefixo;
                foreach my $letra (@letras){$dic=$dic->{$letra};}
                get_words_with_prefix_aux($prefixo,$dic,\@words);
        }
        Dumper(@words);
        \@words;
}

sub get_words_with_prefix_aux{

        my ($prefixo,$dic,$words)=@_;
        my $word="";

        foreach my $ram (keys $dic){
                if($ram eq "##"){
                        push $words , $prefixo;
		}
                else{
                        get_words_with_prefix_aux($prefixo.$ram,$dic->{$ram},$words);
		}
        }

}
#################### subroutine header begin ####################

=head2 prefix_exists

 Usage     : A subrotina prefix_exists é usada para testar se um certo prefixo existe na PrefixTree
 Purpose   : Prefix_exists serve para testar se um dado prefixo existe na PrefixTree
 Returns   : Retorna true se existir, false caso contrário
 Argument  : O prefixo que se quer testar se existe
 Throws    : 
 Comment   : 
See Also   : 

=cut

#################### subroutine header end ####################
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

#################### subroutine header begin ####################

=head2 word_exists

 Usage     : A subrotina word_exists é usada para testar se uma certa palavra existe na PrefixTree
 Purpose   : Word_exists serve para testar se uma dada palavra existe na PrefixTree
 Returns   : Retorna true se existir, false caso contrário
 Argument  : A palavra que se quer testar se existe
 Throws    : 
 Comment   : 

=cut

#################### subroutine header end ####################

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
        if(exists $dic2->{"##"}){ 
		return 1;
	}
        else{
		return 0;
	}
}
<<<<<<< HEAD


#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!


=head1 NAME

PrefixTree - Uma árvore de prefixos armazena todos os prefixos das palavras introduzidas

=head1 SYNOPSIS

  use PrefixTree;


=head1 DESCRIPTION

Uma PrefixTree armazena todos os prefixos das palavras introduzidas.
Uma das grandes vantagens desta estrutura é que serve para armazenar uma lista de palavras
de uma forma compacta.
Quando uma lista de palavras é muito grande é comum que as palavras partilhem prefixos.
Neste caso, uma PrefixTree permite armazenar informação de uma forma compacta

=head1 USAGE
PrefixTree é usada para armazenar um conjunto de palavras

=head1 BUGS
Nã foram detectados bugs
=head1 SUPPORT
Contactar Hugo Freitas e José Pereira

=head1 AUTHOR

    Hugo Freitas & José Pereira
    pg27750@alunos.uminho.pt
    pg27748@alunos.uminho.pt

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################


=======
>>>>>>> e79995e612ea2e8b5576c221108835fa362c7f6c
1;
