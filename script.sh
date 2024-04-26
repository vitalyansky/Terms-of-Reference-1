#!/bin/bash

# Проверка количества аргументов
if [ "$#" -ne 2 ]; then
    echo "Использование: $0 входная директория выходная директория"
    exit 1
fi

src_dir="$1"
dest_dir="$2"

# Проверка существования директорий
if [ ! -d "$src_dir" ]; then
    echo "Входная директория $src_dir не существует."
    exit 1
fi

if [ ! -d "$dest_dir" ]; then
    echo "Выходная директория $dest_dir не существует."
    exit 1
fi

# Функция для копирования файлов с проверкой дубликатов
safe_copy() {
    local src_path="$1"
    local dest_path="$2"
    local base_name=$(basename -- "$src_path")
    local file_ext="${base_name##*.}"
    local file_name="${base_name%.*}"

    # Обработка совпадения имен файлов в целевой директории
    local index=0
    local new_file_name="$base_name"
    while [ -f "$dest_dir/$new_file_name" ]; do
        index=$((index + 1))
        new_file_name="${file_name} ($index).$file_ext"
    done

    # Копирование файла
    cp -- "$src_path" "$dest_dir/$new_file_name"
}

# Использование find с -print0 и read -d '' для обработки всех имен файлов
find "$src_dir" -type f -print0 | while IFS= read -r -d '' file; do
    safe_copy "$file" "$dest_dir/$(basename -- "$file")"
done

echo "Файлы скопированы в $dest_dir"
