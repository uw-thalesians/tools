package main

import (
	"log"
	"net/http"
)

func redirect(w http.ResponseWriter, r *http.Request) {

	http.Redirect(w, r, "http://www.ph.perceptia.info", 307)
}

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("/", redirect)



	log.Printf("server is listening at on port 80")
	log.Fatal(http.ListenAndServe(":http", mux))
}

