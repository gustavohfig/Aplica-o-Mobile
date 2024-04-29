// Aqui contém a lista de filmes *no formato JSON* (é um padrão para transportar textos de WEB), que ele vai trazer da API e cria uma LIST com objetos do tipo *Movie*, criado no arquivo api.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'api.dart';
import 'detail.dart';

// Vamos precisar de uma aplicação com estado
class MoviesListView extends StatefulWidget {
  const MoviesListView({super.key});

  @override
  State<MoviesListView> createState() => _MoviesListViewState();
}

class _MoviesListViewState extends State<MoviesListView> {
  List<Movie> movies = List<Movie>.empty();
  TextEditingController _searchController = TextEditingController();

  void _searchMovies() {
    String search = _searchController.text; // Get the user input
    API.getMovie(search).then((response) {
      setState(() {
        Iterable lista = json.decode(response.body);
        movies = lista.map((model) => Movie.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Filmes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _searchMovies,
                  child: Text("Procurar"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      movies[index].image,
                    ),
                  ),
                  title: Text(
                    movies[index].name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(movies[index].link),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(movies[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}