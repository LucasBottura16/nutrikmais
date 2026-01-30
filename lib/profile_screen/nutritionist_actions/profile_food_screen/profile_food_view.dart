import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_food_screen/models/profile_food_model.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_food_screen/profile_food_service.dart';
import 'package:nutrikmais/globals/customs/Widgets/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_dropdown.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';

class TabelaAlimentosView extends StatefulWidget {
  const TabelaAlimentosView({super.key});

  @override
  State<TabelaAlimentosView> createState() => _TabelaAlimentosViewState();
}

class _TabelaAlimentosViewState extends State<TabelaAlimentosView> {
  List<Alimento> _todosAlimentos = [];
  List<Alimento> _alimentosFiltrados = [];

  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  List<String> _categorias = [];
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _buscarDados();
    _searchController.addListener(_filtrarAlimentos);
  }

  Future<void> _buscarDados() async {
    try {
      final alimentos = await AlimentoService.carregarAlimentos();

      final Set<String> categoriasSet = alimentos
          .map((a) => a.categoria)
          .toSet();
      final List<String> categoriasList = categoriasSet.toList();
      categoriasList.sort();

      setState(() {
        _todosAlimentos = alimentos;
        _alimentosFiltrados = alimentos;
        _categorias = ['Todas as categorias', ...categoriasList];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filtrarAlimentos() {
    List<Alimento> resultados = _todosAlimentos;
    final query = _searchController.text.toLowerCase();

    if (_categoriaSelecionada != null) {
      resultados = resultados.where((alimento) {
        return alimento.categoria == _categoriaSelecionada;
      }).toList();
    }

    if (query.isNotEmpty) {
      resultados = resultados.where((alimento) {
        final descricaoLower = alimento.descricao.toLowerCase();
        return descricaoLower.contains(query);
      }).toList();
    }

    setState(() {
      _alimentosFiltrados = resultados;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Alimentos TACO",
        backgroundColor: MyColors.myPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInputField(
              controller: _searchController,
              labelText: 'Buscar alimento...',
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 16),

            CustomDropdown(
              value: _categoriaSelecionada,
              hintText: 'Filtrar por categoria',
              items: _categorias,
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue == 'Todas as categorias') {
                    _categoriaSelecionada = null;
                    _filtrarAlimentos();
                  } else {
                    _categoriaSelecionada = newValue;
                    _filtrarAlimentos();
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text("Ocorreu um erro: $_errorMessage"));
    }
    if (_alimentosFiltrados.isEmpty) {
      return const Center(child: Text("Nenhum alimento encontrado."));
    }

    return ListView.builder(
      itemCount: _alimentosFiltrados.length,
      itemBuilder: (context, index) {
        final alimento = _alimentosFiltrados[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Text(
                    alimento.numero.toString(),
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: Text(
                        alimento.descricao,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Categoria: ${alimento.categoria}\n'
                      'Energia: ${alimento.energiaKcal} kcal | Proteína: ${alimento.proteinaG} g\n'
                      'Medida: ${alimento.medidaCaseira}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
