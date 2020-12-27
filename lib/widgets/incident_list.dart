import 'package:city_care/view_models/incident_list_view_model.dart';
import 'package:city_care/view_models/incident_view_mode.dart';
import 'package:flutter/material.dart';

class IncidentList extends StatelessWidget {
  final List<IncidentViewModel> incidents;
  const IncidentList({Key key, this.incidents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: incidents.length,
        itemBuilder: (context, index) {
          final incident = incidents[index];
          return ListTile(
            leading: Image.network(
                'https://vast-savannah-75068.herokuapp.com${incident.imageURL}'),
            title: Text(incident.title),
          );
        },
      ),
    );
  }
}
