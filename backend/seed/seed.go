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

	products := []models.Product{
		{Name: "Dalil", Price: 18000, Category: "Investigasi & Penjualan Lapangan", Stock: 100, Description: "Rokok Dalil - Temuan Investigasi", ImageURL: "https://picsum.photos/seed/dalil/400"},
		{Name: "Hmin", Price: 15000, Category: "Investigasi & Penjualan Lapangan", Stock: 150, Description: "Rokok Hmin - Temuan Investigasi", ImageURL: "https://picsum.photos/seed/hmin/401"},
		{Name: "Towin", Price: 17000, Category: "Investigasi & Penjualan Lapangan", Stock: 80, Description: "Rokok Towin - Temuan Investigasi", ImageURL: "https://picsum.photos/seed/towin/402"},
		{Name: "Classy", Price: 25000, Category: "Investigasi & Penjualan Lapangan", Stock: 200, Description: "Rokok Classy - Temuan Investigasi", ImageURL: "https://picsum.photos/seed/classy/403"},
		{Name: "Anoah", Price: 22000, Category: "Investigasi & Penjualan Lapangan", Stock: 60, Description: "Rokok Anoah - Temuan Investigasi", ImageURL: "https://picsum.photos/seed/anoah/404"},
		{Name: "Bonte", Price: 12000, Category: "Investigasi & Penjualan Lapangan", Stock: 300, Description: "Rokok Bonte - Temuan Investigasi", ImageURL: "https://picsum.photos/seed/bonte/405"},
	}

	for _, p := range products {
		config.DB.Create(&p)
	}
	log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}
