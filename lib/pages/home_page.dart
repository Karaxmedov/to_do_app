import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/widdget/custom_search_delegate.dart';
import 'package:to_do_app/widdget/tasks_item.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;
  @override
  void initState() {
    _allTask = <Task>[];
    _localStorage = locator<LocalStorage>();

    _getAllTaskFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: const Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage(context);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_allTask[index].id),
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // ignore: prefer_interpolation_to_compose_strings, unnecessary_string_interpolations
                      Text("${_allTask[index].name}" + "remove_task".tr()),
                    ],
                  ),
                  onDismissed: (direction) async {
                    _localStorage.deleteTask(task: _allTask[index]);

                    _allTask.remove(_allTask[index]);
                    setState(() {});
                  },
                  child: TasksItem(
                    index: index,
                    task: _allTask[index],
                  ),
                );
              },
            )
          : Center(
              child: const Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: addTask(context),
          ),
        );
      },
    );
  }

  TextField addTask(BuildContext context) {
    return TextField(
      autofocus: true,
      style: const TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: "add_task".tr(),
        border: InputBorder.none,
      ),
      onSubmitted: (value) {
        Navigator.of(context).pop();
        DatePicker.showTimePicker(
          context,
          showSecondsColumn: false,
          onConfirm: (time) async {
            var task = Task.create(name: value, time: time);
            _allTask.add(task);
            await _localStorage.addTask(task: task);

            setState(() {});
          },
        );
      },
    );
  }

  Future<void> _getAllTaskFromDB() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage(BuildContext context) async {
    await showSearch(
        context: context, delegate: CustomSearchDElegate(tasks: _allTask));
    _getAllTaskFromDB();
    setState(() {});
  }
}
