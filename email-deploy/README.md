# GitHub Actions para Crear Releases y Notificaciones por Correo

Este documento explica cómo configurar y utilizar una acción de GitHub para automatizar la creación de releases y enviar notificaciones por correo cuando se crea un nuevo tag en el repositorio.

## Descripción

Este flujo de trabajo se activa cuando se hace push de un nuevo tag que sigue el patrón `v*`. Realiza dos tareas principales:

1. **Crear un Release**: Utiliza la herramienta `gh` para generar automáticamente un release basado en el tag recién creado.
2. **Generar Notas de Cambio (Changelog)**: Usa el archivo `.github/release.yml` para categorizar los cambios basados en las etiquetas (labels) de los issues y pull requests.
3. **Enviar Notificación por Correo**: Utiliza una imagen Docker pre-construida para enviar una notificación de correo con detalles del nuevo release.

## Requisitos

- Tener configurado GitHub Actions en tu repositorio.
- Tener instalado o disponible `gh` (GitHub CLI) en el contexto de ejecución de GitHub Actions.
- Configurar los siguientes secretos en tu repositorio:
  - `GITHUB_TOKEN`: Token proporcionado automáticamente por GitHub para acciones.
  - `POSTMARK_SERVER_TOKEN`: Tu token de servidor de Postmark para enviar correos.

## Configuración

### 1. Añadir el Flujo de Trabajo

Crea un archivo `.github/workflows/release.yml` en tu repositorio con el siguiente contenido:

```yaml
name: Create release

on:
  push:
    tags:
      - 'v*'

permissions:
  contents: write

jobs:
  release:
    name: Release pushed tag
    runs-on: ubuntu-22.04
    steps:
      - name: Create release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          tag: ${{ github.ref_name }}
        run: |
          gh release create "$tag" \
              --repo="$GITHUB_REPOSITORY" \
              --title="${tag#v}" \
              --generate-notes
      - name: New release notification
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          POSTMARK_SERVER_TOKEN: ${{ secrets.POSTMARK_SERVER_TOKEN }}
          APP_NAME: Fullstack Template
          VERSION: ${{ github.ref_name }}
          RECEIVE_EMAIL: lsanchez@avilatek.dev
          REPOSITORY: https://github.com/${{ github.repository }}
          LINK: https://github.com/${{ github.repository }}/releases/tag/${{ github.ref_name }}
        uses: docker://lesanpi/email-deploy:v1.1.1
```

## 2. Configurar el Template de Notas de Cambio

Asegúrate de que el archivo .github/release.yml exista en tu repositorio con la siguiente configuración para organizar las notas de cambio:

```yml
changelog:
  exclude:
    labels:
      - ignore-for-release
  categories:
    - title: Breaking Changes 🛠
      labels:
        - breaking-change
    - title: New Features 🎉
      labels:
        - enhancement
        - feat
        - kind:feat
        - feature
    - title: Bug fixes 🐛
      labels:
        - fix
        - kind:fix
    - title: Documentation 📄
      labels:
        - documentation
    - title: Other Changes
      labels:
        - '*'
```
