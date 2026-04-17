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

	config.DB.Exec("DELETE FROM products")
	log.Println("Tabel produk dikosongkan.")

	products := []models.Product{
		{
			Name:        "Sampoerna A Mild",
			Price:       32000,
			Category:    "SKM (Sigaret Kretek Mesin)",
			Stock:       500,
			Description: "Rokok filter low tar low nicotine (LTLN) nomor 1 di Indonesia. Memiliki rasa yang sangat halus dan bersih. Kemasan 16 batang.",
			ImageURL:    "https://i.imgur.com/ZS7JABe.png",
		},
		{
			Name:        "Gudang Garam Filter",
			Price:       25000,
			Category:    "SKM (Sigaret Kretek Mesin)",
			Stock:       400,
			Description: "Rokok kretek filter legendaris dengan perpaduan tembakau dan cengkeh berkualitas tinggi. Sensasi rasa yang mantap dan kuat. Kemasan 12 batang.",
			ImageURL:    "https://i.imgur.com/i5lDv1K.png",
		},
		{
			Name:        "Djarum Super",
			Price:       28000,
			Category:    "SKM (Sigaret Kretek Mesin)",
			Stock:       450,
			Description: "Dibuat dari paduan tembakau dan cengkeh pilihan dengan kualitas dunia. Memberikan kepuasan maksimal bagi penikmat kretek sejati. Kemasan 16 batang.",
			ImageURL:    "https://i.imgur.com/E0nSwa8.png",
		},
		{
			Name:        "Dji Sam Soe 234",
			Price:       22000,
			Category:    "SKT (Sigaret Kretek Tangan)",
			Stock:       300,
			Description: "Legenda kretek tangan tanpa filter dengan racikan tembakau legendaris sejak 1913. Aroma dan rasa yang tak tertandingi. Kemasan 12 batang.",
			ImageURL:    "https://i.imgur.com/KzHjv6c.png",
		},
		{
			Name:        "Hmin",
			Price:       15000,
			Category:    "Investigasi Lapangan",
			Stock:       150,
			Description: "Varian rokok investigasi dengan profil rasa yang berani dan perpaduan tembakau lokal. Harga sangat kompetitif. Isi 20 batang.",
			ImageURL:    "https://i.imgur.com/TYgyVvH.png",
		},
		{
			Name:        "Classy",
			Price:       25000,
			Category:    "Investigasi Lapangan",
			Stock:       120,
			Description: "Rokok kategori investigasi kelas premium. Memberikan sensasi tar yang seimbang dan desain kemasan elegan. Isi 20 batang.",
			ImageURL:    "https://i.imgur.com/PrnH3S8.png",
		},
	}

	for _, p := range products {
		config.DB.Create(&p)
	}
	log.Printf("Seed berhasil: %d produk rokok standar e-commerce telah ditambahkan", len(products))
}
