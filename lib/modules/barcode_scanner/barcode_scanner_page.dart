import 'package:flutter/material.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:payflow/shared/widgets/label_button/label_button.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final controller = BarcodeScannerController();

  @override
  void initState() {
    super.initState();
    controller.getAvailableCameras();
    controller.statusNotifier.addListener(() {
      if (controller.status.hasBarcode) {
        Navigator.of(context).pushReplacementNamed('/insert_boleto');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, value, __) {
              if (value.showCamera) {
                return Container(
                  child: value.cameraController!.buildPreview(),
                );
              } else {
                return Container();
              }
            },
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: BackButton(
                  color: AppColors.background,
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
                title: Text(
                  'Escaneie o código de barras do boleto',
                  style: TextStyles.buttonBackground,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SetLabelButtons(
                primaryLabel: "Inserir código do boleto",
                primaryOnPressed: () {},
                secondaryLabel: "Adicionar da galeria",
                secondaryOnPressed: () {},
              ),
            ),
          ),
          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, value, __) {
              if (value.hasError) {
                return BottomSheetWidget(
                  primaryLabel: "Escanear novamente",
                  primaryOnPressed: () {
                    controller.getAvailableCameras();
                  },
                  secondaryLabel: "Digitar código",
                  secondaryOnPressed: () {},
                  title: "Não foi possível identificar um código de barras.",
                  subtitle:
                      "Tente escanear novamente ou digite o código do seu boleto.",
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}