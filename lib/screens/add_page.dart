import 'package:flutter/material.dart';
import 'package:todo_app_with_api/services/todo_service.dart';
import 'package:todo_app_with_api/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Update Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isEdit ? 'Update' : 'Add',
                ),
              ))
        ],
      ),
    );
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call edited without todo data');
      return;
    }
    final id = todo['_id'];
    final success = await TodoService.updateTodo(id, body);
    if (success) {
      showSuccessMessage(context, msg: 'Success Update Todo');
    } else {
      showErrorMessage(context, msg: 'Failed Update Todo');
    }
  }

  Future<void> submitData() async {
    final success = await TodoService.addTodo(body);
    if (success) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, msg: 'Success Add Todo');
    } else {
      showErrorMessage(context, msg: 'Failed Add Todo');
    }
  }
}
