import 'package:flutter/material.dart';

import '../../domain/entity/history_entity.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.history,
  });
  final List<History> history;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: history.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: const Text("Euro to EGP"),
          subtitle: Text(history[index].date),
          trailing: Text(history[index].rate.toString()),
        );
      },
    );
  }
}
