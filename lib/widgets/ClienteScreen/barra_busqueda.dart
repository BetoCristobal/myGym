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
              decoration: InputDecoration(
                labelText: "Buscar...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: _clearSearchText, icon: const Icon(Icons.clear)
                    )
                  : null ,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onChanged: widget.onSearchChanged
            );
  }
}