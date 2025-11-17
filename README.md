# heic_to_jpeg

Plugin Flutter do konwersji obrazów HEIC na JPEG dla platform Android, iOS i **Web**.

## ⚙️ Konfiguracja Web (WYMAGANE!)

Aby plugin działał na web, **musisz** dodać bibliotekę heic2any do pliku `web/index.html`:

```html
<head>
  ...
  <!-- HEIC decoder library - WYMAGANE dla heic_to_jpeg -->
  <script src="https://cdn.jsdelivr.net/npm/heic2any@0.0.4/dist/heic2any.min.js"></script>
</head>
```

Dodaj tę linię **przed** tagiem `</head>` w swoim pliku `web/index.html`.

## Użycie na Web

### Podstawowe użycie:

```dart
import 'package:heic_to_jpeg/heic_to_jpeg.dart';
import 'dart:typed_data';

// Konwertuj HEIC bytes na JPEG bytes
Uint8List heicBytes = ...; // twoje bajty HEIC
Uint8List jpegBytes = await HeicToJpeg.convert(heicBytes);
```

### Pełny przykład z file pickerem:

```dart
import 'package:file_picker/file_picker.dart';
import 'package:heic_to_jpeg/heic_to_jpeg.dart';

Future<void> convertHeicToJpeg() async {
  // 1. Wybierz plik HEIC
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['heic', 'HEIC'],
    withData: true, // WAŻNE dla web!
  );

  if (result != null && result.files.first.bytes != null) {
    final heicBytes = result.files.first.bytes!;

    // 2. Konwertuj na JPEG
    final jpegBytes = await HeicToJpeg.convert(heicBytes);

    // 3. Użyj jpegBytes (np. wyświetl)
    // Image.memory(jpegBytes)
  }
}
```

## Uruchomienie przykładu

```bash
cd example
flutter pub get
flutter run -d chrome
```

Wybierz plik HEIC, a aplikacja automatycznie przekonwertuje go na JPEG i wyświetli podgląd.

## Platformy

- ✅ **Web** - Canvas API (package:web)
- ✅ **Android** - BitmapFactory
- ✅ **iOS** - UIImage