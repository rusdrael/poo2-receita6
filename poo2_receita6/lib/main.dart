import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);

class DataService {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);
  final ValueNotifier<List<dynamic>> columnNamesNotifier = ValueNotifier([]);
  final ValueNotifier<List<dynamic>> propertyNamesNotifier = ValueNotifier([]);

  late final Map<int, void Function()> loadFunctions;

  DataService() {
    loadFunctions = {
      0: carregarCafes,
      1: carregarCervejas,
      2: carregarNacoes,
    };
    carregarCafes();
  }

  void carregar(int index) {
    loadFunctions[index]?.call();
  }

  void carregarCafes() {
    tableStateNotifier.value = [
      {
        "name": "Evening Blend",
        "origin": "Embu, Kenya",
        "intensifier": "dense"
      },
      {
        "name": "Kreb-Full-o Solstice",
        "origin": "Harrar, Ethiopia",
        "intensifier": "tart"
      },
      {
        "name": "Summer Coffee",
        "origin": "Nueva Segovia, Nicaragua",
        "intensifier": "structured"
      }
    ];

    columnNamesNotifier.value = ["Nome", "Origem", "Intensificador"];
    propertyNamesNotifier.value = ["name", "origin", "intensifier"];
  }

  void carregarCervejas() {
    tableStateNotifier.value = [
      {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
      {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
      {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
    ];

    columnNamesNotifier.value = ["Nome", "Estilo", "IBU"];
    propertyNamesNotifier.value = ["name", "style", "ibu"];
  }

  void carregarNacoes() {
    tableStateNotifier.value = [
      {
        "nacionality": "Greek Macedonians",
        "language": "Arabic",
        "capital": "Tashkent"
      },
      {
        "nacionality": "Mongolians",
        "language": "Nepali",
        "capital": "Kathmandu"
      },
      {"nacionality": "Kurds", "language": "Italian", "capital": "Ottawa"}
    ];

    columnNamesNotifier.value = ["Nacionalidade", "Linguagem", "Capital"];
    propertyNamesNotifier.value = ["nacionality", "language", "capital"];
  }
}

final dataService = DataService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            return DataTableWidget(
              jsonObjects: value,
              columnNamesNotifier: dataService.columnNamesNotifier,
              propertyNamesNotifier: dataService.propertyNamesNotifier,
            );
          },
        ),
        bottomNavigationBar:
            NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  final Function(int) itemSelectedCallback;

  const NewNavBar({super.key, required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(0);

    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        itemSelectedCallback(index);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas",
          icon: Icon(Icons.local_drink_outlined),
        ),
        BottomNavigationBarItem(
          label: "Nações",
          icon: Icon(Icons.flag_outlined),
        ),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final ValueNotifier<List<dynamic>> columnNamesNotifier;
  final ValueNotifier<List<dynamic>> propertyNamesNotifier;

  const DataTableWidget({
    super.key,
    this.jsonObjects = const [],
    required this.columnNamesNotifier,
    required this.propertyNamesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: columnNamesNotifier,
      builder: (_, columnNames, __) {
        return DataTable(
          columns: columnNames.map((name) {
            return DataColumn(
              label: Text(
                name.toString(),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }).toList(),
          rows: jsonObjects.map((obj) {
            return DataRow(
              cells: propertyNamesNotifier.value.map((propName) {
                return DataCell(
                  Text(obj[propName].toString()),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}
