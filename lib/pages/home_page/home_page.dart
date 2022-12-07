import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    print('--iniciando dynamiclinks HOMEPAGE --');
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print('REDIRECIONANDO HOMEPAGE');
      Navigator.of(context).pushNamed('/print_page');
    }).onError((error) {
      print(error.toString());
    });
    print('FINALIZANDO dynamiclinks HOMEPAGE');
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/select_printer');
              },
              icon: const Icon(Icons.miscellaneous_services_sharp))
        ],
      ),
    );
  }
}
