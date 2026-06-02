# 💊 MedStock

Aplicación móvil de gestión de inventario de medicamentos desarrollada en Flutter. Permite registrar, editar y controlar el stock de productos farmacéuticos de forma simple y eficiente.

---

## 📱 Capturas

> _Agregá capturas de pantalla aquí_

---

## 🚀 Funcionalidades

- **Autenticación** — Login y registro de usuarios con validación de matrícula
- **Gestión de productos** — Alta, baja y modificación de medicamentos
- **Control de stock** — Incremento/decremento de stock directamente desde la lista
- **Alertas de stock** — Indicadores visuales de stock bajo y sobrestock
- **Exportación** — Exportar inventario a CSV y PDF
- **Perfil de usuario** — Edición de datos personales y cambio de contraseña
- **Temas y fuentes** — Personalización visual persistente entre sesiones
- **Sesión persistente** — Login recordado con SharedPreferences

---

## 🛠️ Tecnologías

| Tecnología | Uso |
|---|---|
| [Flutter](https://flutter.dev) | Framework UI multiplataforma |
| [Riverpod](https://riverpod.dev) | Manejo de estado |
| [SQLite (sqflite)](https://pub.dev/packages/sqflite) | Base de datos local |
| [SharedPreferences](https://pub.dev/packages/shared_preferences) | Persistencia de sesión y configuración |
| [GoRouter](https://pub.dev/packages/go_router) | Navegación declarativa |
| [intl](https://pub.dev/packages/intl) | Formateo de fechas y moneda |
| [url_launcher](https://pub.dev/packages/url_launcher) | Apertura de links externos |

---

## 🏗️ Arquitectura

El proyecto sigue una arquitectura por capas inspirada en **Clean Architecture**:

```
lib/
├── config/
│   └── database/          # DBHelpers (SQLite)
├── core/
│   ├── services/          # Servicios (exportación, etc.)
│   └── theme/             # Colores, fuentes y temas
├── domain/
│   └── entities/          # Modelos de datos (Product, User)
└── presentations/
    ├── providers/          # Estado con Riverpod (StateNotifier)
    ├── screens/            # Pantallas organizadas por módulo
    │   ├── auth/
    │   ├── products/
    │   ├── settings/
    │   └── users/
    └── widgets/            # Widgets reutilizables
```

### Manejo de estado

Se utiliza **Riverpod** con `StateNotifier` para gestionar el estado de la aplicación. Cada entidad principal tiene su propio provider:

- `productListProvider` — Lista y operaciones CRUD de productos
- `sessionProvider` — Estado de autenticación
- `currentUserProvider` — Usuario logueado actualmente
- `themeProvider` — Tema y fuente seleccionados
- `inventoryProvider` — Configuración de inventario (moneda, stock mínimo/máximo)

---

## ⚙️ Instalación y ejecución

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.0.0
- Android Studio o VS Code con extensión Flutter
- Dispositivo físico o emulador Android/iOS

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/aletbm/medstock.git
cd medstock

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la app
flutter run
```

---

## 📦 Dependencias principales

```yaml
dependencies:
  flutter_riverpod: ^2.x.x
  go_router: ^x.x.x
  sqflite: ^x.x.x
  shared_preferences: ^x.x.x
  intl: ^x.x.x
  url_launcher: ^6.3.0
```

> Verificá las versiones exactas en `pubspec.yaml`

---

## 👤 Desarrollador

**Alexander Daniel Rios**
- GitHub: [@aletbm](https://github.com/aletbm)
- Email: alexanderdaniel_rios@hotmail.com

---

## 📄 Licencia

Este proyecto es de uso personal/educativo.
