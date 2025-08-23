import 'package:flutter/material.dart';
import '../colors.dart';

class CustomCatalog extends StatelessWidget {
  final String title;
  final String? textButton;
  final String imageUrl;
  final VoidCallback? onPressed;
  final bool isCompactMode;

  const CustomCatalog({
    super.key,
    required this.title,
    this.textButton = "Acessar",
    this.imageUrl = "Sem Imagem",
    this.onPressed,
    this.isCompactMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final imageHeight = isCompactMode
        ? 120.0
        : isSmallScreen
            ? 150.0
            : 180.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: imageHeight,
              color: MyColors.myTertiary,
              child: imageUrl == "Sem Imagem" || imageUrl.isEmpty
                  ? _buildPlaceholderImage(imageHeight)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _buildPlaceholderImage(imageHeight),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Text(title,
                          maxLines: isCompactMode ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isCompactMode ? 14 : 16,
                          ))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.myPrimary,
                      padding: EdgeInsets.symmetric(
                          horizontal: isCompactMode ? 12 : 16,
                          vertical: isCompactMode ? 4 : 8),
                      minimumSize: Size(0, isCompactMode ? 32 : 40),
                    ),
                    child: Text(
                      textButton ?? "Acessar",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(double height) {
    return Center(
      child: Image.asset(
        "images/Logo.png",
        width: height * 0.7,
        height: height * 0.7,
        fit: BoxFit.contain,
      ),
    );
  }
}
