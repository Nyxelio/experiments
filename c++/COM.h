class COM
{
	public:
		COM();
		~COM();
		void initialiser(unsigned int vit,unsigned char par,unsigned char nb);
		void afficher();
	private:
		unsigned int vitesse;
		unsigned char nbBitsDonnees;
		unsigned char parite;
};
