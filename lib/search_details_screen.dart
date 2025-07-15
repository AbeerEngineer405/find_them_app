import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SearchDetailsScreen extends StatefulWidget {
  const SearchDetailsScreen({super.key});

  @override
  State<SearchDetailsScreen> createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends State<SearchDetailsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController dnaResultController = TextEditingController();

  String result = '';

  Future<void> searchDetails() async {
    const apiUrl = 'https://e08f5fdc728a.ngrok-free.app/search';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'blood_type': bloodTypeController.text,
        'dna_result': dnaResultController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        result = response.body;
      });
    } else {
      setState(() {
        result = 'Error: ${response.reasonPhrase}';
      });
    }
  }

  Future<void> searchByImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://e08f5fdc728a.ngrok-free.app/search-by-image'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', pickedFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Result'),
            content: Text(responseBody),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to search by image'),
          ),
        );
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: bloodTypeController,
              decoration: const InputDecoration(labelText: 'Blood Type'),
            ),
            TextField(
              controller: dnaResultController,
              decoration: const InputDecoration(labelText: 'DNA Result'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: searchDetails,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: searchByImage,
              child: const Text('Search by Image'),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}