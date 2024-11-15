import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewHomeworkPage extends StatefulWidget {
  @override
  State<NewHomeworkPage> createState() => _NewHomeworkPageState();
}

class _NewHomeworkPageState extends State<NewHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _selectedDeadline;

  final DatabaseReference _database = FirebaseDatabase.instance.ref('Homework');

  @override
  void dispose() {
    _classNameController.dispose();
    _subjectNameController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _selectDeadline(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDeadline = selectedDate;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final className = _classNameController.text;
      final subjectName = _subjectNameController.text;
      final title = _titleController.text;
      final content = _contentController.text;
      final deadline = _selectedDeadline;

      if (deadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a deadline!')),
        );
        return;
      }

      try {
        // Firebase에 데이터 저장
        await _database.push().set({
          'className': className,
          'subjectName': subjectName,
          'title': title,
          'content': content,
          'deadline': deadline.toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Homework added successfully!')),
        );

        // 폼 초기화
        _classNameController.clear();
        _subjectNameController.clear();
        _titleController.clear();
        _contentController.clear();
        setState(() {
          _selectedDeadline = null;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add homework: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _classNameController,
                decoration: InputDecoration(
                  labelText: 'Class Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter class name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _subjectNameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _selectDeadline(context),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    _selectedDeadline == null
                        ? 'Select Deadline'
                        : 'Deadline: ${_selectedDeadline}',
                    style: TextStyle(
                      color: _selectedDeadline == null
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
