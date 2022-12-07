import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: GoogleFonts.roboto().fontFamily,
          toggleableActiveColor: Colors.white,
        ),
        title: "Fila de atendimento",
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.cInitialRoute);
  }
}
