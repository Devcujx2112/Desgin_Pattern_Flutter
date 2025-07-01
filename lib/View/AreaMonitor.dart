import 'package:design_pattern_login/ViewModel/AreaMonitorViewModel.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AreaMontitor extends StatefulWidget {
  const AreaMontitor({super.key});

  @override
  State<AreaMontitor> createState() => _AreaMontitorState();
}

class _AreaMontitorState extends State<AreaMontitor> {

  Map<String, dynamic> dataCountry = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    final VM_Monitor = Provider.of<AreaMontitorViewModel>(
      context,
      listen: false,
    );

    return ModalProgressHUD(inAsyncCall: _isLoading,
        progressIndicator: LoadingAnimationWidget.inkDrop(
            color: Colors.green, size: 50), child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Terrorism"),
            automaticallyImplyLeading: false,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildForm(controller: VM_Monitor.nameCountries, dataType: 0),
                SizedBox(height: 20),
                _buildForm(controller: VM_Monitor.latitude, dataType: 1),
                SizedBox(height: 20),
                _buildForm(controller: VM_Monitor.longitude, dataType: 2),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  bool isSuccess = await VM_Monitor.InsertAreaMonitor();
                  if(isSuccess){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thêm dữ liệu thành công'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Đóng',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                    return;
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi thêm dữ liệu ${VM_Monitor.errorMessage}'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Đóng',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                }, child: Text("Insert")),
              ],
            ),
          ),
        ));
  }

  Widget _buildForm(
      {required TextEditingController controller, required int dataType}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: 13),
            // onChanged: (value) => ShowAllData(),
            decoration: InputDecoration(
              hintText:
              dataType == 0
                  ? "Tên đất nước bị tấn công"
                  : dataType == 1
                  ? "Latitude"
                  : "Longitude",
              hintStyle: TextStyle(fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
