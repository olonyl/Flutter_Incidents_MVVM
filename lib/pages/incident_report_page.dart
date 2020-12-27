import 'dart:io';

import 'package:camera/camera.dart';
import 'package:city_care/pages/take_picture_page.dart';
import 'package:city_care/view_models/report_incident_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({Key key}) : super(key: key);

  @override
  _IncidentReportPageState createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  ReportIncidentViewModel _reportIncidentViewModel;

  @override
  void initState() {
    super.initState();
    _reportIncidentViewModel =
        Provider.of<ReportIncidentViewModel>(context, listen: false);
  }

  void _showPhotAlbum() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _reportIncidentViewModel.imagePath = image.path;
    });
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePicturePage(camera: camera),
      ),
    );
    setState(() {
      _reportIncidentViewModel.imagePath = result;
    });
  }

  _showPhotoSelectionOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCamera();
                  },
                  leading: Icon(Icons.photo_camera),
                  title: Text("Take a Picture"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showPhotAlbum();
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from photo library"),
                )
              ],
            ),
          );
        });
  }

  void _saveIncident(BuildContext context) async {
    _reportIncidentViewModel.saveIncident();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReportIncidentViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Report an Incident"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            vm.imagePath == null
                ? Image.asset("images/Nicaragua.jpg")
                : Image.file(File(vm.imagePath)),
            FlatButton(
              onPressed: () {
                _showPhotoSelectionOptions(context);
              },
              color: Colors.grey,
              child: Text(
                "Take picture",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextField(
              onChanged: (value) => vm.title = value,
              decoration: InputDecoration(
                labelText: "Enter a title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextField(
              onChanged: (value) => vm.description = value,
              textInputAction: TextInputAction.done,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Enter description",
              ),
            ),
            FlatButton(
              onPressed: () {
                _saveIncident(context);
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
