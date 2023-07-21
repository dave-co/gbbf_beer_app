import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  // final String yearParam;
  final String festivalName;
  final List<String> festivalNames;
  const Settings(this.festivalName, this.festivalNames, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateSettingsState();
}

class _CreateSettingsState extends State<Settings> {
  // static const years = ['2023', '2022'];
  // late String year;
  late String festivalName;
  late List<String> festivalNames;

  @override
  void initState(){
    super.initState();
    // year = widget.yearParam;
    festivalName = widget.festivalName;
    festivalNames = widget.festivalNames;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, festivalName);
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
                    value: festivalName,
                    items: festivalNames.map((String festivalName) {
                      return DropdownMenuItem(value: festivalName, child: Text(festivalName));
                    }).toList(),
                    onChanged: (String? newFestivalName) {
                      setState(() {
                        festivalName = newFestivalName!;
                      });
                    })
              ])
            ])
        )
    );
  }
}
