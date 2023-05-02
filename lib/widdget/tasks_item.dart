import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';

import '../main.dart';
import '../model/task_model.dart';

class TasksItem extends StatefulWidget {
  final int index;
  final Task task;
  const TasksItem({super.key, required this.task, required this.index});

  @override
  State<TasksItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TasksItem> {
  bool isSubmitted = true;
  final TextEditingController _textEditingController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    _localStorage = locator<LocalStorage>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.name;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(
                  0.2,
                ),
                blurRadius: 10),
          ]),
      child: ListTile(
        title: setTitle(),
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleated = !widget.task.isCompleated;
            _localStorage.updateTask(task: widget.task);

            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.task.isCompleated ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              onConfirm: (time) {
                widget.task.time = time;
                _localStorage.updateTask(task: widget.task);

                setState(() {});
              },
            );
          },
          child: Text(
            DateFormat("hh:mm a").format(
              widget.task.time,
            ),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  setTitle() {
    if (widget.task.isCompleated) {
      return Text(
        widget.task.name,
        style: const TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
        ),
      );
    } else if (isSubmitted) {
      return GestureDetector(
        onTap: () {
          isSubmitted = false;
          setState(() {});
        },
        child: Text(
          widget.task.name,
          style: const TextStyle(color: Colors.black),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              minLines: 1,
              maxLines: null,
              controller: _textEditingController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _textEditingController.text = widget.task.name;
              isSubmitted = true;
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.task.name = _textEditingController.text;
              _localStorage.updateTask(task: widget.task);

              isSubmitted = true;
              setState(() {});
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ],
      );
    }
  }
}
