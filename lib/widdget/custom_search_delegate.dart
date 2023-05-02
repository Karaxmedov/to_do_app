import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';

import '../model/task_model.dart';
import 'tasks_item.dart';

class CustomSearchDElegate extends SearchDelegate {
  final List<Task> tasks;

  CustomSearchDElegate({required this.tasks});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = "";
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.red,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredList = tasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(filteredList[index].id),
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
                    Text("${filteredList[index].name} Silindi"),
                  ],
                ),
                onDismissed: (direction) async {
                  await locator<LocalStorage>()
                      .deleteTask(task: filteredList[index]);

                  filteredList.remove(filteredList[index]);
                },
                child: TasksItem(
                  index: index,
                  task: filteredList[index],
                ),
              );
            },
          )
        : Center(
            child: const Text(
              "search_not_found",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
