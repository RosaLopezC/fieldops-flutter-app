import 'package:flutter/material.dart';

// Resumen del proyecto unificado
class ProjectSummaryCard extends StatelessWidget {
  final String tipoPoste;
  final String? tension; // Para eléctrico
  final String distrito;
  final String zona;
  final String sector;

  const ProjectSummaryCard({
    Key? key,
    required this.tipoPoste,
    this.tension,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$tipoPoste${tension != null ? ' $tension' : ''}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          SizedBox(height: 10),
          Text('Distrito: $distrito', style: _infoTextStyle()),
          Text('Zona: $zona', style: _infoTextStyle()),
          Text('Sector: $sector', style: _infoTextStyle()),
        ],
      ),
    );
  }

  TextStyle _infoTextStyle() {
    return TextStyle(fontSize: 12, color: Colors.grey[600]);
  }
}

// Campo de texto unificado
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final String? hintText;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: enabled ? Color(0xFFF5F5F5) : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText ?? 'Ingrese $label',
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 16,
              color: enabled ? Colors.black : Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }
}

// Selector de opciones horizontal
class OptionsSelector extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final Function(String) onSelect;
  final String title;

  const OptionsSelector({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1565C0),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedValue == option;
              
              return InkWell(
                onTap: () => onSelect(option),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF1565C0) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(0xFF1565C0) : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Switch personalizado
class CustomSwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const CustomSwitchRow({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1565C0),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF6B00),
        ),
      ],
    );
  }
}

// Botón personalizado
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color(0xFF1565C0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

// Dropdown personalizado
class CustomDropdown extends StatelessWidget {
  final String title;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Seleccione $title'),
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}