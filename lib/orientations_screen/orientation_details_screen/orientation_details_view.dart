import 'package:flutter/material.dart';
import 'package:nutrikmais/orientations_screen/models/orientations_model.dart';
import 'package:nutrikmais/utils/app_bar.dart';
import 'package:nutrikmais/utils/colors.dart';

class OrientationDetailsView extends StatefulWidget {
  const OrientationDetailsView({super.key, required this.orientationData});

  final DBOrientations orientationData;

  @override
  State<OrientationDetailsView> createState() => _OrientationDetailsViewState();
}

class _OrientationDetailsViewState extends State<OrientationDetailsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Orientações do paciente",
        backgroundColor: MyColors.myPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paciente: ${widget.orientationData.patientName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Data: ${widget.orientationData.orientationsUpdatedAt}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Divider(height: 24, color: Colors.grey[400]),
            const Text(
              'Orientações:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.orientationData.orientations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(widget.orientationData.orientations[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
