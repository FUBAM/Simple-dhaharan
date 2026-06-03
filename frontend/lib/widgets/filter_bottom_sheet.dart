import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final int? initialMaxTime;
  final int? initialServings;
  final String initialSort;

  const FilterBottomSheet({
    super.key,
    this.initialMaxTime,
    this.initialServings,
    required this.initialSort,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int? _maxTime;
  int? _servings;
  late String _sort;

  @override
  void initState() {
    super.initState();
    _maxTime = widget.initialMaxTime;
    _servings = widget.initialServings;
    _sort = widget.initialSort;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Resep', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filter Waktu
          const Text('Waktu Memasak (Maksimal)', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _maxTime?.toDouble() ?? 120,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  activeColor: Colors.orange,
                  label: _maxTime != null ? '$_maxTime Menit' : 'Semua Waktu',
                  onChanged: (val) => setState(() => _maxTime = val.toInt()),
                ),
              ),
              Text(_maxTime != null ? '$_maxTime Mnt' : 'Bebas', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          // Filter Porsi
          const Text('Jumlah Porsi', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                final porsi = index + 1;
                final isSelected = _servings == porsi;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text('$porsi'),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                    onSelected: (selected) {
                      setState(() => _servings = selected ? porsi : null);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Sorting
          const Text('Urutkan Berdasarkan', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Terbaru', style: TextStyle(fontSize: 14)),
                  value: 'desc',
                  groupValue: _sort,
                  activeColor: Colors.orange,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _sort = val!),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Terlama', style: TextStyle(fontSize: 14)),
                  value: 'asc',
                  groupValue: _sort,
                  activeColor: Colors.orange,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _sort = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Terapkan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'maxTime': _maxTime,
                  'servings': _servings,
                  'sort': _sort,
                });
              },
              child: const Text('TERAPKAN FILTER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}