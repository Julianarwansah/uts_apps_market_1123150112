package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/Julianarwansah/be-catalog-p4-1123150112/handlers"
	"github.com/Julianarwansah/be-catalog-p4-1123150112/middleware"
)

func SetupRouter() *gin.Engine {

	// gin.Default() sudah include Logger & Recovery middleware
	r := gin.Default()

	// ─── CORS Middleware (izinkan request dari Flutter app) ───
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// ─── Init handlers ────────────────────────────────────────
	authHandler := handlers.NewAuthHandler()
	productHandler := handlers.NewProductHandler()

	// ─── API v1 group ─────────────────────────────────────────
	v1 := r.Group("/v1")
	{
		// Health check — tidak perlu auth
		v1.GET("/health", func(c *gin.Context) {
			c.JSON(200, gin.H{
				"status":  "ok",
				"service": "gin-firebase-backend",
			})
		})

		// ── Auth routes (public) ──────────────────────────────
		auth := v1.Group("/auth")
		{
			// Terima Firebase token → return Backend JWT
			auth.POST("/verify-token", authHandler.VerifyToken)
		}

		// ── Protected routes (butuh Backend JWT) ──────────────
		protected := v1.Group("")
		protected.Use(middleware.AuthMiddleware())
		{
			// Products — semua user terautentikasi bisa GET
			products := protected.Group("/products")
			{
				// Public (authenticated users)
				products.GET("", productHandler.GetAll)
				products.GET("/:id", productHandler.GetByID)

				// Admin only
				adminProducts := products.Group("")
				adminProducts.Use(middleware.AdminOnly())
				{
					adminProducts.POST("", productHandler.Create)       // POST /v1/products
					adminProducts.PUT("/:id", productHandler.Update)   // PUT /v1/products/:id
					adminProducts.DELETE("/:id", productHandler.Delete) // DELETE /v1/products/:id
				}
			}
		}
	}

	return r
}