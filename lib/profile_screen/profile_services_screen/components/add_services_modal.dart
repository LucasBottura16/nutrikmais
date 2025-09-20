import 'package:flutter/material.dart';
import 'package:nutrikmais/profile_screen/profile_service.dart';
import 'package:nutrikmais/profile_screen/profile_services_screen/profile_services_service.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/customs_components/custom_button.dart';
import 'package:nutrikmais/utils/customs_components/custom_input_field.dart';
import 'package:nutrikmais/utils/masks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicoData {
  final String nome;
  final String descricao;
  final String preco;

  ServicoData({
    required this.nome,
    required this.descricao,
    required this.preco,
  });
}

class AddServiceSheet extends StatefulWidget {
  const AddServiceSheet({super.key});

  static Future<ServicoData?> show(BuildContext context) {
    return showModalBottomSheet<ServicoData>(
      context: context,
      isScrollControlled:
          true, // Permite que o modal ocupe mais da metade da tela
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const AddServiceSheet();
      },
    );
  }

  @override
  State<AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<AddServiceSheet> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Padding para ajustar o conteúdo quando o teclado aparecer
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Adicionar Novo Serviço",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            CustomInputField(
              controller: _nomeController,
              labelText: "Nome do Serviço",
              hintText: "insira um serviço",
              validator: (value) => (value?.isEmpty ?? true)
                  ? "Por favor, insira um nome."
                  : null,
            ),

            const SizedBox(height: 16),
            CustomInputField(
              controller: _descricaoController,
              labelText: "Descrição do Serviço",
              hintText: "insira uma desrcrição",
              validator: (value) => (value?.isEmpty ?? true)
                  ? "Por favor, insira uma descrição."
                  : null,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _precoController,
              labelText: "Preço do Serviço",
              hintText: "R\$ 00.00",
              inputFormatters: [MasksInput.currencyRealFormatter],
              validator: (value) => (value?.isEmpty ?? true)
                  ? "Por favor, insira um preço."
                  : null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    _isLoading = true;
                  });

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  String uid = prefs.getString('uidLogged') ?? "";

                  await ProfileServicesService().addServicesNutritionist(
                    uid,
                    _nomeController.text,
                    _descricaoController.text,
                    _precoController.text,
                  );

                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.of(context).pop();
                }
              },
              title: "SALVAR SERVIÇO",
              titleColor: Colors.white,
              buttonColor: MyColors.myPrimary,
              buttonBorderRadius: 10,
              buttonEdgeInsets: const EdgeInsets.fromLTRB(50, 15, 50, 15),
              isLoading: _isLoading,
              loadingColor: MyColors.myPrimary,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
