import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AlertType { sucess, warning, fail, help, question }

alertDialog(BuildContext context, String message,
    {Function()? onAfterExecute,
    Function()? onPressedYes,
    Function()? onPressedNo,
    AlertType type = AlertType.warning}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomAlertDialogContent(
        message: message,
        type: type,
        onYes: onPressedYes,
        onNo: onPressedNo,
        onAfterExecute: onAfterExecute,
      );
    },
  );
}

class CustomAlertDialogContent extends StatelessWidget {
  final AlertType type;
  final String message;
  final Function()? onAfterExecute;
  final Function()? onYes;
  final Function()? onNo;

  const CustomAlertDialogContent(
      {Key? key,
      required this.type,
      required this.message,
      this.onAfterExecute,
      this.onYes,
      this.onNo})
      : super(key: key);

  String getTitleType() {
    String title;
    switch (type) {
      case AlertType.sucess:
        title = 'Sucesso';
        break;
      case AlertType.warning:
        title = 'Alerta';
        break;
      case AlertType.fail:
        title = 'Erro';
        break;
      case AlertType.help:
        title = 'Ajuda';
        break;
      case AlertType.question:
        title = 'Pergunta';
        break;
      default:
        title = 'Alerta';
    }

    return title;
  }

  Color getColorType() {
    Color color;
    switch (type) {
      case AlertType.sucess:
        color = Colors.green;
        break;
      case AlertType.warning:
        color = Colors.amber;
        break;
      case AlertType.fail:
        color = Colors.red;
        break;
      case AlertType.help:
        color = Colors.lightBlue;
        break;
      case AlertType.question:
        color = Colors.redAccent;
        break;
      default:
        color = Colors.amber;
    }

    return color;
  }

  IconData getIconType() {
    IconData icon;
    switch (type) {
      case AlertType.sucess:
        icon = Icons.check_rounded;
        break;
      case AlertType.warning:
        icon = Icons.warning_amber_rounded;
        break;
      case AlertType.fail:
        icon = Icons.close_rounded;
        break;
      case AlertType.help:
        icon = Icons.info_outline_rounded;
        break;
      case AlertType.question:
        icon = Icons.help_rounded;
        break;
      default:
        icon = Icons.warning_amber_rounded;
    }

    return icon;
  }

  Widget getIcon() {
    if (type == AlertType.question) {
      return SizedBox(
          width: 32,
          height: 32,
          child: Icon(getIconType(), color: Colors.redAccent, size: 32));
    } else {
      return Container(
          width: 32,
          height: 32,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: getColorType()),
          child: Icon(getIconType(), color: Colors.white, size: 24));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    getIcon(),
                    const SizedBox(width: 10),
                    Text(
                      getTitleType(),
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: const Color(0xFF676767),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Text(
                  message,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: const Color(0xFF676767),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: type == AlertType.question
                      ? [
                          SizedBox(
                            width: width * 0.25,
                            height: 48,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                              child: Text(
                                'Sim',
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                if (onYes != null) {
                                  Navigator.pop(context);
                                  await onYes!();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: width * 0.25,
                            height: 48,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                              child: Text(
                                'Não',
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                if (onNo != null) {
                                  Navigator.pop(context);
                                  await onNo!();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ]
                      : [
                          SizedBox(
                            width: width * 0.25,
                            height: 48,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                              child: Text(
                                'OK',
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                if (onAfterExecute != null) {
                                  Navigator.pop(context);
                                  await onAfterExecute!();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

alertDialogPergunta(BuildContext context, String msg,
    {Function()? onPressYes, Function()? onPressNo, String title = ''}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title != '' ? title : "Alerta"),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Sim',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () {
                  if (onPressYes != null) {
                    onPressYes();
                  }
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                  child: const Text(
                    'Não',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onPressed: () {
                    if (onPressNo != null) {
                      onPressNo();
                    }
                    Navigator.pop(context, false);
                  })
            ],
          ),
        );
      });
}

alertDialogSair(BuildContext context,
    {Function()? onPressYes, Function()? onPressNo}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      double width = MediaQuery.of(context).size.width;

      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Gostaria de sair do aplicativo?",
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: const Color(0xFF676767),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Text(
                  'Se sair, será necessário fazer login novamente para iniciar sessão.',
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: const Color(0xFF676767),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.30,
                      height: 48,
                      child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          child: Text(
                            'Não sair',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            if (onPressNo != null) {
                              onPressNo();
                            }
                            Navigator.pop(context, false);
                          }),
                    ),
                    SizedBox(
                      width: width * 0.25,
                      height: 48,
                      child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(const BorderSide(
                              color: Color(0xFF676767),
                            )),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          child: Text(
                            'Sair',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: const Color(0xFF676767),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            if (onPressYes != null) {
                              onPressYes();
                            }
                            Navigator.pop(context, false);
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
