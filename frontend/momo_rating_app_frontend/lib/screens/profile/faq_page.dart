import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/screens/profile/profile_page.dart';

class Item {
  Item({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });

  String headerText;
  String expandedText;
  bool isExpanded;
}

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<Item> _data = [
    Item(
        headerText: "What is the Momo Rating App?",
        expandedText:
            "The Momo Rating App is a platform where users can rate and review different varieties of Momo based on specific criteria. It helps users discover new Momo varieties, receive personalized recommendations, and connect with other Momo enthusiasts."),
    Item(
        headerText: "How does the Momo Rating App personalize recommendations?",
        expandedText:
            "The app users your preferences to suggest new Momo varieties that match your taste. You can change these preferences anytime by editing your entered preferences."),
    Item(
        headerText: "Is the Momo Rating App free to use?",
        expandedText:
            "Yes, all features of Momo rating and recommendation application is free to use."),
    Item(
        headerText:
            "What area is Momo rating and recommendation application for works?",
        expandedText:
            "Momo rating and recommendation works within the bounder of Nepal."),
    Item(
        headerText: "How can I add my favorite Momo shop to the app?",
        expandedText:
            "Users can suggest new Momo shops and varieties by filling out a form within the app."),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                icon: const Icon(Icons.close))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Frequently \n Asked Question",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff242732),
                            fontWeight: FontWeight.w500,
                            fontSize: 45),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _data[index].isExpanded = isExpanded;
                    });
                  },
                  dividerColor: Colors.transparent,
                  children: _data.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            item.headerText,
                            style: const TextStyle(
                                color: Color(0xff242732),
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        );
                      },
                      body: ListTile(
                        title: Text(
                          item.expandedText,
                          style: const TextStyle(
                            color: Color(0xff4f5056),
                          ),
                        ),
                      ),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
