import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisualizationsScreen extends StatefulWidget {
  @override
  _VisualizationsScreenState createState() => _VisualizationsScreenState();
}

class _VisualizationsScreenState extends State<VisualizationsScreen> {
  String selectedFeature1 = "Age";
  String selectedFeature2 = "Glucose";
  bool showSecondFeature = false;
  String imageUrl = "";

  final List<String> features = [
    "Pregnancies",
    "Glucose",
    "BloodPressure",
    "SkinThickness",
    "Insulin",
    "BMI",
    "DiabetesPedigreeFunction",
    "Age",
    "Outcome"
  ];

  Future<void> fetchVisualization() async {
    final uri = Uri.parse(
      "https://diabetes-prediction-gj1e.onrender.com/visualize?feature1=$selectedFeature1&feature2=${showSecondFeature ? selectedFeature2 : ""}"
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          imageUrl = uri.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching visualization!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visualizations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: selectedFeature1,
              items: features.map((feature) {
                return DropdownMenuItem(value: feature, child: Text(feature));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFeature1 = value!;
                });
              },
              decoration: InputDecoration(labelText: "Feature 1"),
            ),
            if (showSecondFeature)
              DropdownButtonFormField(
                value: selectedFeature2,
                items: features.map((feature) {
                  return DropdownMenuItem(value: feature, child: Text(feature));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFeature2 = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Feature 2"),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Compare Two Features"),
                Switch(
                  value: showSecondFeature,
                  onChanged: (value) {
                    setState(() {
                      showSecondFeature = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchVisualization,
              child: Text("Generate Visualization"),
            ),
            if (imageUrl.isNotEmpty)
              Expanded(
                child: Image.network(imageUrl),
              ),
          ],
        ),
      ),
    );
  }
}
