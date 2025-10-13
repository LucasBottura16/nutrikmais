import 'package:flutter/material.dart';
import 'package:nutrikmais/utils/colors.dart';

class CustomLoadingData extends StatelessWidget {
  final String nameData;
  final Color? nameDataColor;
  final Color? loadingColor;

  const CustomLoadingData({
    super.key,
    required this.nameData,
    this.nameDataColor = MyColors.myPrimary,
    this.loadingColor = MyColors.myPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(loadingColor!),
            ),
            SizedBox(height: 20),
            Text(
              "Carregando $nameData...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: nameDataColor!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
