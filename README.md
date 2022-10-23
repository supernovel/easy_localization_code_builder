Generates translation key code for the easy localization package. Support for json and yaml formats.You can see examples in the assets/ folder.

## Getting started

first, Setting build.yaml
```yaml
$default:
  builders:
    easy_localization_keys_generator:easyLocalizationKeysGenerator:
      # The subset of files within the target's sources which should have this Builder applied.
      generate_for: 
        - assets/*.json
        - assets/*.yaml
      # Set output folder
      options:
        output_path: './lib/localizations'
```


## Usage
- Run build runner

```dart
fvm flutter pub run build_runner build
```