This was a project I started back in late 2024, to centralize a lot of functions that I used in my projects into one repository. But I was new to Dart, so I had no idea about a lot of things, like enums and named parameters. So I abandoned this version to move on to version 2.

Version 2 uses two packages:
- `localpkg`: [Calebh101/localpkg-dart](https://github.com/Calebh101/localpkg-dart)
  - This package is compatible with both Dart and Flutter.
- `localpkg_flutter`: [Calebh101/localpkg-flutter-2](https://github.com/Calebh101/localpkg-flutter-2)
  - This package uses and exports `localpkg`, but also contains some Flutter-only implementations of things like new widgets and snack bars.

Trust me, you do *not* want to look in or use version 1's code.
