import 'package:flutter/material.dart';
import 'package:nutrikmais/consultations_screen/add_consultations_screen/add_consultations_view.dart';
import 'package:nutrikmais/consultations_screen/consultations_view.dart';
import 'package:nutrikmais/create_account_screen/create_account_view.dart';
import 'package:nutrikmais/orientations_screen/add_orientations_screen/add_orientations_view.dart';
import 'package:nutrikmais/orientations_screen/models/orientations_model.dart';
import 'package:nutrikmais/orientations_screen/orientation_details_screen/orientation_details_view.dart';
import 'package:nutrikmais/orientations_screen/orientations_view.dart';
import 'package:nutrikmais/home_screen/home_view.dart';
import 'package:nutrikmais/main.dart';
import 'package:nutrikmais/patient_screen/add_pacient_screen/add_patient_view.dart';
import 'package:nutrikmais/patient_screen/patient_view.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_consultations_screen/profile_consultations_view.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_food_screen/profile_food_view.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_infos_screen/profile_infos_view.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_plans_screen/profile_plans_view.dart';
import 'package:nutrikmais/profile_screen/nutritionist_actions/profile_services_screen/profile_services_view.dart';
import 'package:nutrikmais/evolution_screen/evolution_view.dart';
import 'package:nutrikmais/profile_screen/patient_actions/profile_infos_patient_screen/profile_infos_patient_view.dart';
import 'package:nutrikmais/profile_screen/patient_actions/profile_my_nutri_screen/profile_my_nutri_view.dart';
import 'package:nutrikmais/profile_screen/profile_view.dart';

class RouteGenerator {
  static const String routeLogin = "/routes";
  static const String home = "/home";
  static const String createAccount = "/createAccount";

  static const String patientScreen = "/patient_screen";
  static const String addPatientScreen = "/add_patient_screen";

  static const String profileScreen = "/profile_screen";
  static const String profileConsultationsScreen =
      "/profile_consultations_screen";
  static const String profileFoodScreen = "/profile_food_screen";
  static const String profileServicesScreen = "/profile_services_screen";
  static const String profilePlansScreen = "/profile_plans_screen";
  static const String profileInfosScreen = "/profile_infos_screen";
  static const String profileEvolutionScreen = "/profile_evolution_screen";
  static const String profileMyNutriScreen = "/profile_my_nutri_screen";
  static const String profileInfosPatientScreen =
      "/profile_infos_patient_screen";
  static const String consultationsScreen = "/consultations_screen";
  static const String addConsultationsScreen = "/add_consultations_screen";
  static const String orientationsScreen = "/orientations_screen";
  static const String addOrientationsScreen = "/add_orientations_screen";
  static const String orientationDetailsScreen = "/orientation_details_screen";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return MaterialPageRoute(builder: (_) => const Routes());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountView());
      case patientScreen:
        return MaterialPageRoute(builder: (_) => const PatientView());
      case addPatientScreen:
        return MaterialPageRoute(builder: (_) => const AddPatientView());
      case profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case profileConsultationsScreen:
        return MaterialPageRoute(
          builder: (_) => const ProfileConsultationsView(),
        );
      case profileServicesScreen:
        return MaterialPageRoute(builder: (_) => const ProfileServicesView());
      case profileFoodScreen:
        return MaterialPageRoute(builder: (_) => const TabelaAlimentosView());
      case profilePlansScreen:
        return MaterialPageRoute(builder: (_) => const ProfilePlansView());
      case profileInfosScreen:
        return MaterialPageRoute(builder: (_) => const ProfileInfosView());
      case profileEvolutionScreen:
        return MaterialPageRoute(builder: (_) => const EvolutionView());
      case profileMyNutriScreen:
        return MaterialPageRoute(builder: (_) => const ProfileMyNutriView());
      case profileInfosPatientScreen:
        return MaterialPageRoute(
          builder: (_) => const ProfileInfosPatientView(),
        );
      case consultationsScreen:
        return MaterialPageRoute(builder: (_) => const ConsultationsView());
      case addConsultationsScreen:
        return MaterialPageRoute(
          builder: (_) =>
              AddConsultationsView(date: settings.arguments as String?),
        );
      case orientationsScreen:
        return MaterialPageRoute(builder: (_) => const OrientationsView());
      case addOrientationsScreen:
        return MaterialPageRoute(builder: (_) => const AddOrientationsView());
      case orientationDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => OrientationDetailsView(
            orientationData: settings.arguments as DBOrientations,
          ),
        );
      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Tela não encontrada")),
          body: const Center(child: Text("Tela não encontrada")),
        );
      },
    );
  }
}
