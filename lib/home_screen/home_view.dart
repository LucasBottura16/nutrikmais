import 'package:flutter/material.dart';
import 'package:nutrikmais/home_screen/home_service.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';
import 'package:nutrikmais/utils/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _nome = "";

  _verifyAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nome = prefs.getString('nameLogged') ?? '';

    if (_nome.isEmpty) {
      await HomeService.getMyDetails();
    }
    setState(() {
      _nome = prefs.getString('nameLogged') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _verifyAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Home", backgroundColor: MyColors.myPrimary),
      drawer: const MyDrawer(screen: "home_screen"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $_nome!',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 140,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: MyColors.myPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Próxima consulta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Data: 25/10/2025 às 14:00',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Local: Clínica Nutrikmais',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Consulta: Bioimpedância',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Ver detalhes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 140,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: MyColors.myPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Seu progresso esta semana',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Você completou 5 de 7 metas',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Ver detalhes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Dieta - Terça-feira",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: SizedBox(
                  height: 350,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Café da manhã:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            title: const Text('Iogurte com frutas e granola'),
                            subtitle: const Text('200 kcal'),
                          ),
                          ListTile(
                            title: const Text('Café preto sem açúcar'),
                            subtitle: const Text('5 kcal'),
                          ),
                          const Divider(),
                          const Text(
                            'Almoço:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Peito de frango grelhado com salada',
                            ),
                            subtitle: const Text('450 kcal'),
                          ),
                          ListTile(
                            title: const Text('Arroz integral e legumes'),
                            subtitle: const Text('300 kcal'),
                          ),
                          const Divider(),
                          const Text(
                            'Jantar:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            title: const Text('Sopa de legumes'),
                            subtitle: const Text('250 kcal'),
                          ),
                          ListTile(
                            title: const Text('Chá de camomila'),
                            subtitle: const Text('0 kcal'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Orientações - Terça-feira",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: SizedBox(
                  height: 300, // Altura fixa para permitir scroll
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text('Hidratação'),
                            subtitle: const Text(
                              'Beba pelo menos 2 litros de água ao longo do dia.',
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Atividade física'),
                            subtitle: const Text(
                              'Caminhe por 30 minutos após o almoço.',
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Sono'),
                            subtitle: const Text(
                              'Durma entre 7 a 8 horas por noite para melhor recuperação.',
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Meditação'),
                            subtitle: const Text(
                              'Pratique 10 minutos de meditação para reduzir o estresse.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Suas últimas atividades',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: const Text('Consulta com a nutricionista'),
                        subtitle: const Text('20 de setembro de 2023'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.orange,
                        ),
                        title: const Text('Nova receita adicionada'),
                        subtitle: const Text('18 de setembro de 2023'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.fitness_center,
                          color: Colors.blue,
                        ),
                        title: const Text('Exercício concluído'),
                        subtitle: const Text('15 de setembro de 2023'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
