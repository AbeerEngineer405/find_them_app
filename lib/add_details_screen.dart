import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({Key? key}) : super(key: key);

  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String phone = '';
  String birthDate = '';
  String location = '';
  String bloodType = '';
  String ssn = '';
  String dna = '';
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // هنا تقدر ترسل البيانات إلى API أو تطبعها فقط
      print("Name: $name");
      print("Phone: $phone");
      print("Birth Date: $birthDate");
      print("Location: $location");
      print("Blood Type: $bloodType");
      print("SSN: $ssn");
      print("DNA: $dna");
      print("Image: ${selectedImage?.path}");

      // رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ البيانات بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة بيانات")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'الاسم'),
                onSaved: (value) => name = value ?? '',
                validator: (value) => value!.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم الجوال'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => phone = value ?? '',
                validator: (value) => value!.isEmpty ? 'الرجاء إدخال رقم الجوال' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'تاريخ الميلاد'),
                onSaved: (value) => birthDate = value ?? '',
                validator: (value) => value!.isEmpty ? 'الرجاء إدخال تاريخ الميلاد' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'الموقع'),
                onSaved: (value) => location = value ?? '',
                validator: (value) => value!.isEmpty ? 'الرجاء إدخال الموقع' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'فصيلة الدم'),
                onSaved: (value) => bloodType = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'الرقم الوطني (SSN)'),
                onSaved: (value) => ssn = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'DNA'),
                onSaved: (value) => dna = value ?? '',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('اختيار صورة'),
              ),
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(selectedImage!, height: 150),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text('إرسال'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}