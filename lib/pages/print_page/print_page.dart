import 'package:deeplink/shared/services/printer_service/printer_service.dart';
import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';

import '../../shared/services/dio_service/dio_response.dart';
import '../../shared/widgets/dialogs_widget.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  late PrinterService? printerService;
  String senha = '';
  bool isEnd = false;

  String password = '';

  List<String> messages = [];

  Future _getPassword(BuildContext buildContext) async {
    ApiResponse response = await printerService!.getLastPassword();

    if (response.cStatus == StatusReponse.success) {
      setState(() {
        senha = response.cResult['dados'];
      });

      setState(() async {
        isEnd = await printerService!.execute(response.cResult['dados']);
      });

      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(buildContext);
        //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        MoveToBackground.moveTaskToBack();
      });
    } else {
      await alertDialog(buildContext, response.cMessage,
          onAfterExecute: () async {}, type: AlertType.warning);
    }
  }

  bool isPrinterConfigured = true;

  @override
  void initState() async {
    super.initState();
    printerService = PrinterService();
    printerService!.initialize();

    setState(() {
      isPrinterConfigured = printerService!.printerDevice != null;
    });

    if (printerService!.printerDevice != null) {
      _getPassword(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressão'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: isPrinterConfigured
                ? [
                    const Text('Pronto!'),
                    const Text('Aguarde a impressão da sua senha'),
                    const Text('Senha:'),
                    Text(senha),
                    const SizedBox(height: 10),
                    isEnd ? Container() : const CircularProgressIndicator(),
                  ]
                : [
                    const Text(
                        'É necessário realizar a configuração da impressora.'),
                  ],
          ),
        ),
      ),
    );
  }
}
