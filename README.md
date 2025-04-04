# 🪄 Portkey

**Portkey** is a Swift command-line tool that helps you move localized string entries between modules or bundles in your iOS project.

## 💬 A Note on the Name

While the name _Portkey_ is a lighthearted nod to magical teleportation, this project is in no way affiliated with or endorsing the views of any TERF, including _that one_. **Trans rights are human rights** 🏳️‍⚧️

## ✨ Why Portkey?

In modular iOS projects, each module often maintains its own localization files. But as code moves between modules, or into or out of the main bundle, localized strings can get left behind leading to broken UIs or missing translations.

Portkey solves this by:

- Finding a localization key in the source module
- Removing it from the source localization file(s)
- Moving it (with any associated comments) to the respective destination file(s)

It's like `mv`, but for localized string key/values. 💫

## 🚀 Usage

To use this tool, download the binary from Github [here](https://github.com/rubencodes/Portkey/blob/main/portkey). Then, run the binary from the command line to move strings between localization bundles:

```bash
portkey <key> <sourcePath> <destinationPath> [newKey]
```

### Basic Example

```
portkey "HomePage.title" ./Modules/Login ./Modules/Onboarding
```

This moves the `HomePage.title` key from each locale’s `.strings` file in the Login module to the corresponding file in the Onboarding module.

### Rename Example

You can also use the tool to rename a key within a module (or rename it upon moving):

```
portkey "HomePage.title" ./Modules/Login ./Modules/Login "HomePage.Title.new"
```

In this case, the source and destination paths are the same, but we provide the optional new key argument, so it removes the original key, and adds it to the same file with a new key name.

## 🧠 What It Supports

- ✅ .strings files
- ✅ Per-locale \*.lproj directories (e.g., en.lproj/Localizable.strings)
- ✅ Moving comments (/_ comment _/, // comment) associated with the key
- ✅ Optional renaming of keys when moving
- ✅ Graceful skipping if key not found or destination file doesn’t exist
- ✅ Graceful skipping if key collision at destination

## 🛠 How It Works

For each locale found in the source module:

1. Portkey looks for supported file types (currently just `.strings`)
2. If the source file exists and contains the key:

- Portkey removes the entry and any comment above it
- If a matching destination file exists, Portkey appends the entry to it

3. The key is moved once per locale, and logs are printed to confirm what happened.

## 🔮 Future Plans

- ⏳ Support for .stringsdict files
- 🧪 --dry-run mode
- 📣 --verbose or --quiet flags

## 📦 Building

To build the script locally, clone the project and execute the following in the command line at the source root:

```
swift build
```

To run the script locally:

```
swift run portkey <key> <sourcePath> <destinationPath>
```

To package a new release executable, run:

```
swift build -c release
```

This will output a new executable binary at `.build/release/portkey`.
