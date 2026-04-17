package main

import (
	"log"

	"github.com/Julianarwansah/be-catalog-p4-1123150112/config"
	"github.com/Julianarwansah/be-catalog-p4-1123150112/models"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Warning: Error loading .env file, pastikan posisi direktori atau variabel environment sudah diset.")
	}

	config.InitDatabase()

	// 1. Bersihkan tabel produk agar tidak ada data makanan yang tersisa
	config.DB.Exec("DELETE FROM products")
	log.Println("Tabel produk dikosongkan.")

	// 2. Daftar produk rokok (E-commerce Standard)
	products := []models.Product{
		// --- CATEGORY: SKM (Sigaret Kretek Mesin) ---
		{
			Name:        "Sampoerna A Mild",
			Price:       32000,
			Category:    "SKM (Sigaret Kretek Mesin)",
			Stock:       500,
			Description: "Rokok filter low tar low nicotine (LTLN) nomor 1 di Indonesia. Memiliki rasa yang sangat halus dan bersih. Kemasan 16 batang.",
			ImageURL:    "https://picsum.photos/seed/amild/400",
		},
		{
			Name:        "Gudang Garam Filter",
			Price:       25000,
			Category:    "SKM (Sigaret Kretek Mesin)",
			Stock:       400,
			Description: "Rokok kretek filter legendaris dengan perpaduan tembakau dan cengkeh berkualitas tinggi. Sensasi rasa yang mantap dan kuat. Kemasan 12 batang.",
			ImageURL:    "https://picsum.photos/seed/ggfilter/400",
		},
		{
			Name:        "Djarum Super",
			Price:       28000,
			Category:    "SKM (Sigaret Kretek Mesin)",
			Stock:       450,
			Description: "Dibuat dari paduan tembakau dan cengkeh pilihan dengan kualitas dunia. Memberikan kepuasan maksimal bagi penikmat kretek sejati. Kemasan 16 batang.",
			ImageURL:    "https://picsum.photos/seed/djarumsuper/400",
		},

		// --- CATEGORY: SKT (Sigaret Kretek Tangan) ---
		{
			Name:        "Dji Sam Soe 234",
			Price:       22000,
			Category:    "SKT (Sigaret Kretek Tangan)",
			Stock:       300,
			Description: "Legenda kretek tangan tanpa filter dengan racikan tembakau legendaris sejak 1913. Aroma dan rasa yang tak tertandingi. Kemasan 12 batang.",
			ImageURL:    "https://picsum.photos/seed/234/400",
		},

		// --- CATEGORY: SPM (Sigaret Putih Mesin) ---
		{
			Name:        "Marlboro Red",
			Price:       42000,
			Category:    "SPM (Sigaret Putih Mesin)",
			Stock:       200,
			Description: "Rokok putih premium tanpa cengkeh. Memberikan sensasi rasa tembakau yang murni dan berkarakter kuat. Kemasan 20 batang.",
			ImageURL:    "https://picsum.photos/seed/marlboro/400",
		},

		// --- CATEGORY: INVESTIGASI ---
		{
			Name:        "Dalil",
			Price:       18000,
			Category:    "Investigasi Lapangan",
			Stock:       100,
			Description: "Rokok temuan hasil investigasi lapangan. Memiliki karakteristik rasa yang unik dengan harga ekonomis. Isi 20 batang.",
			ImageURL:    "https://picsum.photos/seed/dalil/400",
		},
		{
			Name:        "Hmin",
			Price:       15000,
			Category:    "Investigasi Lapangan",
			Stock:       150,
			Description: "Varian rokok investigasi dengan profil rasa yang berani dan perpaduan tembakau lokal. Harga sangat kompetitif. Isi 20 batang.",
			ImageURL:    "https://picsum.photos/seed/hmin/400",
		},
		{
			Name:        "Classy",
			Price:       25000,
			Category:    "Investigasi Lapangan",
			Stock:       120,
			Description: "Rokok kategori investigasi kelas premium. Memberikan sensasi tar yang seimbang dan desain kemasan elegan. Isi 20 batang.",
			ImageURL:    "https://picsum.photos/seed/classy/400",
		},
		{
			Name:        "Anoah",
			Price:       22000,
			Category:    "Investigasi Lapangan",
			Stock:       90,
			Description: "Rokok temuan dengan aromatik cengkeh pilihan yang menonjol. Produk eksklusif untuk data investigasi. Isi 16 batang.",
			ImageURL:    "https://picsum.photos/seed/anoah/400",
		},
	}

	for _, p := range products {
		config.DB.Create(&p)
	}
	log.Printf("Seed berhasil: %d produk rokok standar e-commerce telah ditambahkan", len(products))
}
