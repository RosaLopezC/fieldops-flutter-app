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
        
        // Dividir opciones en filas de 3, pero si son solo 2, que ocupen toda la fila
        ..._buildButtonRows(),
      ],
    );
  }

  List<Widget> _buildButtonRows() {
    List<Widget> rows = [];
    
    // Si solo hay 2 opciones, hacer una fila especial
    if (options.length == 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _buildOptionButton(options[0])),
            SizedBox(width: 10),
            Expanded(child: _buildOptionButton(options[1])),
          ],
        ),
      );
      return rows;
    }
    
    // Para más de 2 opciones, usar el patrón de 3 por fila
    for (int i = 0; i < options.length; i += 3) {
      List<String> rowOptions = options.skip(i).take(3).toList();
      
      rows.add(
        Row(
          children: [
            for (int j = 0; j < rowOptions.length; j++) ...[
              if (j > 0) SizedBox(width: 10),
              Expanded(child: _buildOptionButton(rowOptions[j])),
            ],
            // Llenar espacios vacíos si hay menos de 3 botones
            for (int k = rowOptions.length; k < 3; k++) ...[
              SizedBox(width: 10),
              Expanded(child: SizedBox()),
            ],
          ],
        ),
      );
      
      if (i + 3 < options.length) {
        rows.add(SizedBox(height: 10));
      }
    }
    
    return rows;
  }

  Widget _buildOptionButton(String option) {
    final isSelected = selectedValue == option;
    
    return Container(
      height: 50, // Altura aumentada para textos más largos
      child: ElevatedButton(
        onPressed: () => onSelect(option),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          option,
          textAlign: TextAlign.center,
          maxLines: 2, // Permitir 2 líneas para textos largos
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF1565C0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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