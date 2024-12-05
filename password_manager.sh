#!/bin/bash

echo 'パスワードマネージャーへようこそ！'
echo -n 'サービス名を入力してください：'
read service_name
echo -n 'ユーザー名を入力してください：'
read user_name
echo -n 'パスワードを入力してください：'
read -s password
echo

declare -a user_inputs=("$service_name" "$user_name" "$password")
declare -a original_message=(
  '\033[31mサービス名が入力されていません\033[0m\n'
  '\033[31mユーザー名が入力されていません\033[0m\n'
  '\033[31mパスワードが入力されていません\033[0m\n'
)
declare -a error_messages=()

# 未入力項目を確認し、未入力の場合はエラーメッセージを追加
for index in ${!user_inputs[@]}; do
    if [ -z "${user_inputs[$index]}" ]; then
        error_messages+=("${original_message[$index]}")
    fi
done

# ユーザー入力の文字数上限を設定

# エラーが無い場合は感謝メッセージ出力、ある場合はエラーメッセージ出力、
if [ -z "$error_messages" ]; then
    (
        echo "$service_name":"$user_name":"$password" >> user_input.txt
    ) 2>error.txt

    if [ $? -ne 0 ]; then
        printf '\033[31m入力内容の保存に失敗しました\033[0m\n'
        return
    fi
    printf 'Thank you\033[31m!\033[0m\n'
else
    for i in "${error_messages[@]}"; do
        printf $i
    done
fi
