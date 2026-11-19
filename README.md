# Pokédex

[![CI](https://github.com/DanielCazorro/Pokedex/actions/workflows/ci.yml/badge.svg)](https://github.com/DanielCazorro/Pokedex/actions/workflows/ci.yml)
![iOS 26+](https://img.shields.io/badge/iOS-26%2B-black?logo=apple)
![Swift 6](https://img.shields.io/badge/Swift-6-F05138?logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-0A84FF)

App de iOS para consultar todos los Pokémon, hecha en SwiftUI sobre la API pública [PokeAPI](https://pokeapi.co/).

> 🚧 **En desarrollo.**

---

## 📱 Capturas

*Las capturas se irán añadiendo a medida que estén las pantallas.*

---

## ✨ Funcionalidades

- **Pokédex completa**: todos los Pokémon con scroll infinito, búsqueda por nombre o número y filtros por tipo y
  generación.
- **Detalle**: descripción, estadísticas, evoluciones, debilidades, movimientos, versión shiny y grito.
- **Favoritos y modo sin conexión**: lo que ya has visto se abre sin internet.
- **Comparador**: dos Pokémon cara a cara, con sus estadísticas y la efectividad de sus tipos.
- **Español e inglés**, según el idioma del móvil.

---

## 🛠 Tecnologías

| | |
|---|---|
| Plataforma | iOS 26+, iPhone |
| Lenguaje | Swift 6 con concurrencia estricta |
| UI | SwiftUI con Liquid Glass |
| Arquitectura | Por capas: Interfaces (View + ViewModel), Use Cases y Models |
| Datos | `async/await`, `@Observable` y SwiftData |
| Tests | Swift Testing y [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) |
| Calidad | [SwiftLint](https://github.com/realm/SwiftLint), [Periphery](https://github.com/peripheryapp/periphery) y GitHub Actions |

---

## 🚀 Cómo ejecutarla

1. Necesitas **Xcode 27** o posterior.
2. Abre `Pokedex.xcodeproj`. La primera vez, acepta el plugin de SwiftLint (**Trust & Enable**).
3. Elige un simulador con iOS 26 o posterior y pulsa **Run**.

No hace falta ninguna API key.

> **¿Falla el build con `Plug-in ended with uncaught signal: 5`?** Es el plugin de SwiftLint, que no encuentra
> SourceKit porque el Mac tiene seleccionadas las Command Line Tools en lugar de Xcode. Se arregla con:
>
> ```bash
> sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
> ```

---

## 📄 Créditos

- Datos e imágenes: [PokeAPI](https://pokeapi.co/).
- Pokémon y los nombres de sus personajes son marcas de Nintendo, Creatures Inc. y GAME FREAK inc. Este es un
  proyecto personal, sin ánimo de lucro y sin relación con ellos.
