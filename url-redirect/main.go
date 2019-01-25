/*
Program url-redirect is a simple http request redirection tool.
*/
package main

import (
	"log"
	"net/http"
	"os"
)

/*
main is the entry point for the url-redirect tool.
To use this tool, set an environment variable: REDIRECT_TO_URL
with the value of the url you would like to redirect to.
You should format the url as: URI = scheme:[//authority]
For example: http://www.example.com
*/
func main() {
	// Reads in the address to listen for incoming requests for
	addr := DefaultEnv("LISTEN_ADDR", ":http")
	// Reads in the url to redirect all requests to.
	redirect := RequireEnv("REDIRECT_TO_URL")
	// Initializes a new basic HTTP server object
	mux := http.NewServeMux()

	// Handler function to route http requests to the provided url.
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, redirect, 307)
	})

	log.Printf("Server is listening at on port 80 for http requests...")
	log.Printf("Server is redirecting all requests to: %s", redirect)
	// Starts the server, logs error if server cannot be started.
	log.Fatal(http.ListenAndServe(addr, mux))
}

/*
RequireEnv reads in a value from the environment.
If the value is not in the environment this function logs an error and exits.
*/
func RequireEnv(name string) string {
	envVar := os.Getenv(name)
	if len(envVar) == 0 {
		log.Fatalf("Please set %s", name)
	}
	return envVar
}

/*
DefaultEnv reads in a value from the environment.
If the value is not in the environment this function returns the default value provided.
*/
func DefaultEnv(name, defaultValue string) string {
	envVar := os.Getenv(name)

	// Default to defaultValue if value not provided
	if len(envVar) == 0 {
		log.Printf("No %s env var set. Defaulting to %s", name, defaultValue)
		envVar = defaultValue
	}
	return envVar
}
