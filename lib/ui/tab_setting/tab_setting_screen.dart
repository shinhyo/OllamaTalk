import 'package:flutter/material.dart';

class TabSettingScreen extends StatelessWidget {
  const TabSettingScreen({super.key});

  static const label = 'Setting';

  @override
  Widget build(BuildContext context) {
    final List<String> sampleData =
        List.generate(20, (index) => 'Item ${index + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text(label),
      ),
      body: ListView.builder(
        itemCount: sampleData.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(sampleData[index]),
            subtitle: Text('Subtitle ${index + 1}'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item ${index + 1} tapped')),
              );
            },
          );
        },
      ),
    );
  }
}
