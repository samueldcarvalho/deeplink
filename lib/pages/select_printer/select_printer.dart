import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get_it/get_it.dart';

import '../../shared/services/shared_preference/shared_preference_service.dart';

class SelectPrinter extends StatefulWidget {
  const SelectPrinter({super.key});

  @override
  State<SelectPrinter> createState() => _SelectPrinterState();
}

class _SelectPrinterState extends State<SelectPrinter> {
  var printerManager = PrinterManager.instance;
  List<PrinterDevice> devices = <PrinterDevice>[];
  PrinterDevice? printerDevice;

  SharedPreferenceService cSharedPreference =
      GetIt.instance<SharedPreferenceService>();

  bool isConnected = false;
  bool isLoading = false;

  void _scan({bool isBle = false}) async {
    setState(() {
      isLoading = true;
    });
    //_disconnectDevice();
    PrinterManager.instance
        .discovery(type: PrinterType.usb, isBle: isBle)
        .listen((device) {
      devices.add(device);
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  void _connectDevice(PrinterDevice selectedPrinter) async {
    if (printerDevice == selectedPrinter) {
      _disconnectDevice();
    } else {
      await PrinterManager.instance.connect(
          type: PrinterType.usb,
          model: UsbPrinterInput(
              name: selectedPrinter.name,
              productId: selectedPrinter.productId,
              vendorId: selectedPrinter.vendorId));

      setState(() {
        isConnected = true;
        printerDevice = selectedPrinter;
        cSharedPreference.setRememberPrinter(selectedPrinter);
      });
    }
  }

  void _disconnectDevice() async {
    await PrinterManager.instance.disconnect(type: PrinterType.usb);
    setState(() {
      isConnected = false;
      printerDevice = null;
    });
  }

  void selectDevice(PrinterDevice device) async {
    if (printerDevice != null) {
      if ((device.address != printerDevice!.address) ||
          (printerDevice!.vendorId != device.vendorId)) {
        await PrinterManager.instance.disconnect(type: PrinterType.usb);
      }
    }
    printerDevice = device;
    setState(() {});
  }

  void _sendBytesToPrint(List<int> bytes) async {
    PrinterManager.instance.send(type: PrinterType.usb, bytes: bytes);
  }

  Future<List<int>> _testPrint() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text('Seja bem-vindo(a)!',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.text('');
    bytes += generator.text('SENHA:',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
        ));
    bytes += generator.text('NL0013',
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          align: PosAlign.center,
        ));
    bytes += generator.text('');
    bytes += generator.text('07/12/2022 16:00',
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  @override
  void initState() {
    super.initState();
    _scan();
    printerDevice = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de impressoras'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text('Buscando impressoras...')
                ],
              ),
            )
          : devices.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          _scan();
                        },
                        child: const Text('Buscar impressoras')),
                    const SizedBox(height: 20),
                    const Center(
                        child: Text('Não há impressoras USB conectadas'))
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          _scan();
                        },
                        child: const Text('Buscar impressoras')),
                    OutlinedButton(
                        onPressed: () async {
                          _disconnectDevice();
                        },
                        child: const Text('Disconectar impressora')),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              _connectDevice(devices[index]);
                            },
                            title: Text(devices[index].name),
                            leading:
                                // &&

                                Icon(Icons.check_box,
                                    color: isConnected &&
                                            printerDevice?.name ==
                                                devices[index].name
                                        ? Colors.green
                                        : Colors.grey),
//                                    : Container(),
                            trailing: OutlinedButton(
                              child: const Text('Imprimir Teste'),
                              onPressed: () async {
                                _sendBytesToPrint(await _testPrint());
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
