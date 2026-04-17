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
		{Name: "Nasi Goreng Spesial", Price: 25000, Category: "Makanan", Stock: 50, Description: "Nasi goreng dengan telur dan ayam", ImageURL: "https://picsum.photos/400"},
		{Name: "Sate Ayam 10 Tusuk", Price: 20000, Category: "Makanan", Stock: 100, Description: "Sate ayam dengan bumbu kacang", ImageURL: "https://picsum.photos/401"},
		{Name: "Es Teh Manis", Price: 8000, Category: "Minuman", Stock: 200, Description: "Es teh manis segar", ImageURL: "https://picsum.photos/402"},
		{Name: "Kopi Susu", Price: 15000, Category: "Minuman", Stock: 150, Description: "Kopi susu kekinian", ImageURL: "https://picsum.photos/403"},
		{Name: "Ayam Bakar", Price: 30000, Category: "Makanan", Stock: 30, Description: "Ayam bakar dengan sambal", ImageURL: "https://picsum.photos/404"},
	}

	for _, p := range products {
		config.DB.Create(&p)
	}
	log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}
