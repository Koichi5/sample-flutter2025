import 'package:flutter/material.dart';
import 'package:sample_flutter2025/weather/pages/weather_page.dart';
import 'package:sample_flutter2025/components/custom_button.dart';
import 'package:sample_flutter2025/components/custom_text.dart';
import 'package:sample_flutter2025/components/custom_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Choose a demo to explore:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Weather Demo
              Card(
                child: ListTile(
                  leading: const Icon(Icons.cloud, color: Colors.blue),
                  title: const Text('Weather App'),
                  subtitle: const Text(
                    'View current weather with different widgets',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeatherPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Custom Button Demo
              Card(
                child: ListTile(
                  leading: const Icon(Icons.smart_button, color: Colors.purple),
                  title: const Text('Custom Button Demo'),
                  subtitle: const Text(
                    'Explore different button styles and states',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomButtonDemo(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Custom Text Demo
              Card(
                child: ListTile(
                  leading: const Icon(Icons.text_fields, color: Colors.orange),
                  title: const Text('Custom Text Demo'),
                  subtitle: const Text(
                    'Explore different text styles and variants',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomTextDemo(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Custom Dialog Demo
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.teal),
                  title: const Text('Custom Dialog Demo'),
                  subtitle: const Text(
                    'Explore different dialog types and interactions',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomDialogDemo(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 48),

              // Quick demo buttons
              const Text(
                'Quick Preview:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Primary',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Primary button pressed!'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Save',
                      icon: Icons.save,
                      backgroundColor: Colors.green,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Save button pressed!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
