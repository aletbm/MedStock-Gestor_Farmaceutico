import 'package:flutter/material.dart';
import 'package:medstock/domain/entities/menu_item.dart';

final List<MenuItem> menuItems = [
  MenuItem(
    title: 'Apariencia', 
    description: 'Tema, colores y fuente de la aplicación', 
    icon: Icons.brightness_6,
    path: '/apparence'
  ),
  MenuItem(
    title: 'Inventario',
    description: 'Configurar el inventario de medicamentos',
    icon: Icons.inventory,
    path: '/inventory'
  ),
  MenuItem(
    title: 'Exportar datos',
    description: 'Exportar los datos de la aplicación',
    icon: Icons.file_download,
    path: '/export-data'
  ),
  MenuItem(
    title: 'Acerca de',
    description: 'Información sobre la aplicación',
    icon: Icons.info,
    path: '/about'
  ),
];