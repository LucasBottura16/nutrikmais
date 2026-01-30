import 'package:flutter/material.dart';
import 'package:nutrikmais/bioimpedance_screen/bioimpedance_details_screen/bioimpedance_details_service.dart';
import 'package:nutrikmais/bioimpedance_screen/models/bioimpedance_model.dart';
import 'package:nutrikmais/globals/configs/app_bar.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/hooks/use_user_type.dart';

class BioimpedanceDetailsView extends StatefulWidget {
  const BioimpedanceDetailsView({super.key, required this.bioimpedanceData});

  final DBBioimpedance bioimpedanceData;

  @override
  State<BioimpedanceDetailsView> createState() =>
      _BioimpedanceDetailsViewState();
}

class _BioimpedanceDetailsViewState extends State<BioimpedanceDetailsView> {
  late List<String> _images;
  String _userType = "";

  @override
  void initState() {
    super.initState();
    _images = List<String>.from(widget.bioimpedanceData.bioimpedanceImages);
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final userPrefs = await useUserPreferences();
    setState(() {
      _userType = userPrefs.typeUser;
    });
  }

  Future<void> _confirmAndDelete(String imageUrl) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover imagem'),
        content: const Text('Deseja remover esta imagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await BioimpedanceDetailsService.deleteImageAndUpdate(
        uidBioimpedance: widget.bioimpedanceData.uidBioimpedance,
        imageUrl: imageUrl,
      );
      if (!mounted) return;
      setState(() {
        _images.remove(imageUrl);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem removida com sucesso.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover imagem: $e')));
    }
  }

  void _openPreview(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bioimpedância do paciente',
        backgroundColor: MyColors.myPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paciente: ${widget.bioimpedanceData.patientName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Data: ${widget.bioimpedanceData.bioimpedanceUpdatedAt}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Divider(height: 24, color: Colors.grey[400]),
            const Text(
              'Imagens:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _images.isEmpty
                  ? const Center(child: Text('Nenhuma imagem disponível.'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        final url = _images[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            GestureDetector(
                              onTap: () => _openPreview(url),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: _userType == "patient"
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                      onPressed: () => _confirmAndDelete(url),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      tooltip: 'Remover',
                                    ),
                            ),
                          ],
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
