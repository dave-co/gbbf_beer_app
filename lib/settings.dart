import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String yearParam;
  const Settings(this.yearParam, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateSettingsState();
}

class _CreateSettingsState extends State<Settings> {
  static const years = ['2023', '2022'];
  String year = "2023";

  @override
  void initState(){
    super.initState();
    year = widget.yearParam;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, year);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: Column(children: [
              Row(children: [
                const Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Text('Year:')),
                DropdownButton(
                    value: year,
                    items: years.map((String year) {
                      return DropdownMenuItem(value: year, child: Text(year));
                    }).toList(),
                    onChanged: (String? newYear) {
                      setState(() {
                        year = newYear!;
                      });
                    })
              ])
            ])
        )
    );
  }
}
