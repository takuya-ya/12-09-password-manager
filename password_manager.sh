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
declare -a input_length_errors=(
  '\033[31mサービス名は50文字以内で入力してください\033[0m\n'
  '\033[31mユーザー名は50文字以内で入力してください\033[0m\n'
  '\033[31mパスワードは50文字以内で入力してください\033[0m\n'
)
declare -a error_messages=()

max_length=50
# 未入力項目を確認し、未入力の場合はエラーメッセージを追加
for index in ${!user_inputs[@]}; do
    if [ -z "${user_inputs[$index]}" ]; then
        error_messages+=("${original_message[$index]}")
    fi

    if [ "${#user_inputs[index]}" -ge $this_max_length ]; then
        error_messages+=("${input_length_errors[$index]}")
    fi
done

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
