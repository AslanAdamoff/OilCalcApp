#!/bin/bash

# Скрипт для создания Xcode проекта OilCalcApp

echo "🚀 Создание Xcode проекта для OilCalcApp..."

# Проверяем наличие Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode не найден. Установи Xcode из App Store."
    exit 1
fi

PROJECT_DIR="$(pwd)"
PROJECT_NAME="OilCalcApp"
XCODE_PROJECT="$PROJECT_DIR/$PROJECT_NAME.xcodeproj"

# Проверяем, существует ли уже проект
if [ -d "$XCODE_PROJECT" ]; then
    echo "⚠️  Проект уже существует: $XCODE_PROJECT"
    echo "   Открываю существующий проект..."
    open "$XCODE_PROJECT"
    exit 0
fi

echo "📝 Создание проекта через Xcode..."
echo ""
echo "⚠️  Автоматическое создание .xcodeproj через командную строку сложно."
echo "   Используй ручной способ:"
echo ""
echo "   1. Открой Xcode"
echo "   2. File → New → Project"
echo "   3. iOS → App"
echo "   4. Product Name: OilCalcApp"
echo "   5. Interface: SwiftUI"
echo "   6. Сохрани в: $PROJECT_DIR"
echo "   7. Добавь все файлы в проект (перетащи папки)"
echo ""
echo "   Или используй готовый проект, если он уже создан."
echo ""

# Пытаемся открыть папку в Finder для удобства
if command -v open &> /dev/null; then
    echo "📂 Открываю папку проекта в Finder..."
    open "$PROJECT_DIR"
fi

echo "✅ Готово! Следуй инструкциям выше."

