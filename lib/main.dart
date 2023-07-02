import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// final pro = ChangeNotifierProvider((ref) => Database());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('test code'),
        ),
        body: Column(
          children: [
            Consumer(builder: (context, ref, child) {
              final items = ref.watch(dataProdiver);
              return Center(
                child: Row(
                    children: List.generate(
                        items.length,
                        (index) => Item(
                              items[index],
                              key: UniqueKey(),
                            ))),
              );
            }),
            Consumer(builder: (context, ref, child) {
              ref.watch(dataProdiver);
              return Center(
                child: Column(
                  children: [
                    Center(
                      child: Card(
                          child: Text(ref.watch(selectedItem) == null
                              ? 'No item'
                              : 'item selected : ITEM${ref.watch(selectedItem)!.name}')),
                    ),
                    Center(
                      child: Card(
                          child: Text(ref.watch(selectedItem) == null
                              ? 'null'
                              : 'count: ${ref.watch(selectedItem)!.count}')),
                    ),
                  ],
                ),
              );
            })
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              label: 'add',
              icon: IconButton(
                  onPressed: () {
                    ref.read(dataProdiver.notifier).addNew();
                  },
                  icon: const Icon(Icons.add))),
          BottomNavigationBarItem(
              label: 'increase',
              icon: Consumer(builder: (context, ref, child) {
                print('check rebuild');
                return IconButton(
                    onPressed: () {
                      ref
                          .watch(dataProdiver.notifier)
                          .increase(ref.read(selectedItem)!.name);
                    },
                    icon: const Icon(Icons.add));
              }))
        ]),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final Coffee coffee;
  const Item(this.coffee, {super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Consumer(builder: (context, ref, child) {
          print('${coffee.name} :   ${coffee.isOnline}');
          return InkWell(
            onTap: () {
              final newItem = coffee.copyWith(isOnline: !coffee.isOnline);
              ref.read(selectedItem.notifier).state = coffee;
              ref.read(dataProdiver.notifier).updateCoffee(newItem);
            },
            child: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                color: coffee.isOnline ? Colors.red : Colors.blue,
                child: Text(coffee.name),
              ),
            ),
          );
        }),
      ],
    );
  }
}

/////
///// model
class Coffee {
  final int count;
  final String name;
  final bool isOnline;
  const Coffee(this.name, this.isOnline, this.count);

  Coffee copyWith({bool? isOnline, int? count}) => Coffee(
      name, isOnline = isOnline ?? this.isOnline, count = count ?? this.count);
}

class Database extends StateNotifier<List<Coffee>> {
  Database() : super([]);
  int i = 0;
  addNew() {
    i++;
    // state = [...state, Coffee('$i', false)];
    state = [...state, Coffee('$i', false, 0)];
  }

  updateCoffee(Coffee coffee) {
    state = [
      for (final e in state)
        if (e.name == coffee.name) e.copyWith(isOnline: coffee.isOnline) else e
    ];
  }

  void increase(String selectedName) {
    final item = state.firstWhere((element) => element.name == selectedName);

    state = [
      for (final e in state)
        (e.name == selectedName) ? item.copyWith(count: item.count + 1) : e
    ];
  }
}

final selectedItem = StateProvider<Coffee?>((ref) => null);
final dataProdiver =
    StateNotifierProvider<Database, List<Coffee>>((ref) => Database());
