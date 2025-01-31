import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onPlusTapped; // Função para o comportamento do botão "+"

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onPlusTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 2) {
          // Índice 2 será o botão "+"
          onPlusTapped();
        } else {
          onItemTapped(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.fileLines),
          label: 'Relatórios',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.plus), // Ícone de "+"
          label: 'Cadastrar',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.calendarAlt),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          label: 'Perfil',
        ),
      ],
    );
  }
}
