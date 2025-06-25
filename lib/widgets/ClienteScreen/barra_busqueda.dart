import 'package:flutter/material.dart';

class BarraBusqueda extends StatefulWidget {
  final bool desactivarBarraBusqueda;
  final Function(String) onSearchChanged;
  final FocusNode? focusNode;

  const BarraBusqueda({
    super.key, 
    required this.desactivarBarraBusqueda, 
    required this.onSearchChanged,
    this.focusNode
  });

  @override
  State<BarraBusqueda> createState() => _BarraBusquedaState();
}

class _BarraBusquedaState extends State<BarraBusqueda> {

  final TextEditingController _searchController = TextEditingController();

  void _clearSearchText() {
    _searchController.clear();
    widget.onSearchChanged('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
              focusNode: widget.focusNode,
              enabled: widget.desactivarBarraBusqueda,
              controller: _searchController,
              style: TextStyle(color: Colors.white54),
              decoration: InputDecoration(
                labelText: "Buscar...",
                labelStyle: TextStyle(
                  color: widget.desactivarBarraBusqueda ? Colors.white54 : Color.fromARGB(255, 61, 61, 61)
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: widget.desactivarBarraBusqueda ? Colors.white54 : Color.fromARGB(255, 61, 61, 61),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: _clearSearchText, icon: const Icon(Icons.clear)
                    )
                  : null ,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.desactivarBarraBusqueda 
                      ? Colors.white54 
                      : const Color.fromARGB(255, 61, 61, 61)
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white54)
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 61, 61, 61))
                ),
              ),
              onChanged: widget.onSearchChanged
            );
  }
}