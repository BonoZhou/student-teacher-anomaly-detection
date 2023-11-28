#!/bin/bash

# 获取脚本所在目录的路径
script_dir=$(dirname "$(readlink -f "\$0")")

# 遍历所有一级文件夹（除了img文件夹）
find "$script_dir" -mindepth 1 -maxdepth 1 -type d ! -name "img" -print0 | while IFS= read -r -d $'\0' first_level_dir; do
    first_level_name=$(basename "$first_level_dir")
    
    # 遍历一级文件夹中的二级文件夹
    find "$first_level_dir" -mindepth 1 -maxdepth 1 -type d -print0 | while IFS= read -r -d $'\0' second_level_dir; do
        second_level_name=$(basename "$second_level_dir")
        
        img_dir="$script_dir/img"
        if [ ! -d "$img_dir" ]; then
            mkdir "$img_dir"
        fi

        i=1
        # 复制二级文件夹中的图片文件到img文件夹中并重命名
        find "$second_level_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.png \) -print0 | while IFS= read -r -d $'\0' file; do
            new_name="${first_level_name}_${second_level_name}_$i.${file##*.}"
            cp "$file" "$img_dir/$new_name"
            ((i++))
        done
    done
done