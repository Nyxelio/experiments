extern struct Artiste *CreerMaillonArtiste(char*);
extern void MettreEnFileArtiste(struct Artiste *);
extern struct Album *CreerMaillonAlbum(char*,char*);
extern void MettreEnFileAlbum(struct Album *);
extern void Afficher();
extern void triTab();
extern void SauvChaine(char*,FILE*);
extern void findfile(char[]);
extern void ExtraireNomEtDate(char[], int,char*,char*);
