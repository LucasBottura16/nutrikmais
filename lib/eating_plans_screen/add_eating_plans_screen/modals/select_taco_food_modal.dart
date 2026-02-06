import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_food_screen/models/profile_food_model.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_food_screen/profile_food_service.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';
import 'package:nutrikmais/globals/customs/components/custom_dropdown.dart';
import 'package:nutrikmais/globals/configs/colors.dart';

/// Modal para selecionar um alimento da tabela TACO
Future<Alimento?> showSelectTacoFoodDialog(BuildContext context) async {
  return showDialog<Alimento?>(
    context: context,
    builder: (context) {
      return const _SelectTacoFoodDialog();
    },
  );
}

class _SelectTacoFoodDialog extends StatefulWidget {
  const _SelectTacoFoodDialog();

  @override
  State<_SelectTacoFoodDialog> createState() => _SelectTacoFoodDialogState();
}

class _SelectTacoFoodDialogState extends State<_SelectTacoFoodDialog> {
  List<Alimento> _todosAlimentos = [];
  List<Alimento> _alimentosFiltrados = [];

  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  List<String> _categorias = [];
  String? _categoriaSelecionada;

  /// Normaliza uma string removendo acentos e caracteres especiais
  String _normalizarTexto(String texto) {
    texto = texto.toLowerCase();

    // Mapa de caracteres com acentos para sem acentos
    const Map<String, String> acentos = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
    };

    String resultado = '';
    for (int i = 0; i < texto.length; i++) {
      String char = texto[i];
      resultado += acentos[char] ?? char;
    }
    return resultado;
  }

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
    final queryNormalizado = _normalizarTexto(_searchController.text);

    if (_categoriaSelecionada != null) {
      resultados = resultados.where((alimento) {
        return alimento.categoria == _categoriaSelecionada;
      }).toList();
    }

    if (queryNormalizado.isNotEmpty) {
      resultados = resultados.where((alimento) {
        final descricaoNormalizada = _normalizarTexto(alimento.descricao);
        return descricaoNormalizada.contains(queryNormalizado);
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selecionar Alimento TACO',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            CustomInputField(
              controller: _searchController,
              labelText: 'Buscar alimento...',
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, alimento);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: MyColors.myPrimary.withOpacity(0.2),
                    radius: 20,
                    child: Text(
                      alimento.numero.toString(),
                      style: TextStyle(
                        color: MyColors.myPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alimento.descricao,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Categoria: ${alimento.categoria}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'Energia: ${alimento.energiaKcal} kcal | Proteína: ${alimento.proteinaG} g',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'Lipídios: ${alimento.lipideosG} g | Carboidratos: ${alimento.carboidratoG} g',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'Medida: ${alimento.medidaCaseira}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
