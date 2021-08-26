import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Function saveFilters;
  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _lactoseFree = false;
  bool _vegan = false;
  bool _vegetarian = false;

  @override
  void initState() {
    super.initState();
    _glutenFree = widget.currentFilters['gluten']!;
    _lactoseFree = widget.currentFilters['lactose']!;
    _vegan = widget.currentFilters['vegan']!;
    _vegetarian = widget.currentFilters['vegeterian']!;
  }

  void _generateSaveFilters() {
    widget.saveFilters({
      'gluten': _glutenFree,
      'lactose': _lactoseFree,
      'vegan': _vegan,
      'vegeterian': _vegetarian,
    });
  }

  Widget _buildSwitchListtile(
    String title,
    String subtitle,
    bool currentValue,
    Function funciton,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: (newValue) {
        funciton(newValue);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Filters"),
          actions: [
            IconButton(
                onPressed: () {
                  widget.saveFilters({
                    'gluten': _glutenFree,
                    'lactose': _lactoseFree,
                    'vegan': _vegan,
                    'vegeterian': _vegetarian,
                  });
                },
                icon: Icon(Icons.save))
          ],
        ),
        drawer: MainDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Adjust you meal selection.',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildSwitchListtile(
                      'Gluten-free',
                      'Only include gluten-free meals',
                      _glutenFree, (newValue) {
                    setState(() {
                      _glutenFree = newValue;
                      _generateSaveFilters();
                    });
                  }),
                  _buildSwitchListtile(
                      'Lactose-free',
                      'Only include lactose-free meals',
                      _lactoseFree, (newValue) {
                    setState(() {
                      _lactoseFree = newValue;
                      _generateSaveFilters();
                    });
                  }),
                  _buildSwitchListtile('Vegeterian',
                      'Only include vegeterian meals', _vegetarian, (newValue) {
                    setState(() {
                      _vegetarian = newValue;
                      _generateSaveFilters();
                    });
                  }),
                  _buildSwitchListtile(
                      'Vegan', 'Only include vegan meals', _vegan, (newValue) {
                    setState(() {
                      _vegan = newValue;
                      _generateSaveFilters();
                    });
                  })
                ],
              ),
            )
          ],
        ));
  }
}
