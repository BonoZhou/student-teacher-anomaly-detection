#!/bin/bash

# 定义需要遍历的根目录
root_dir=$(dirname "$(readlink -f "\$0")")
function gettest()
{
    # 遍历所有除了img文件夹外的文件夹
find "$root_dir" -mindepth 1 -type d ! -name "img" -print0 | while IFS= read -r -d $'\0' dir; do
    folder_name=$(basename "$dir")
    img_dir="$dir/img"
    if [ ! -d "$img_dir" ]; then
        mkdir "$img_dir"
    fi
    i=1
    # 复制文件夹中的图片文件到img文件夹中并重命名
    find "$dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.png \) -print0 | while IFS= read -r -d $'\0' file; do
        new_name="test_${folder_name}_$i.${file##*.}"
        cp "$file" "$img_dir/$new_name"
        ((i++))
    done
done
}

