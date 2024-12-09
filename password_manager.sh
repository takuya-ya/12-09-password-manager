#!/bin/bash

add_password()
{
    declare -A original_message=(
    [service_name]='\033[31mサービス名が入力されていません\033[0m\n'
    [user_name]='\033[31mユーザー名が入力されていません\033[0m\n'
    [password]='\033[31mパスワードが入力されていません\033[0m\n'
    )
    declare -A input_length_errors=(
    [service_name]='\033[31mサービス名は50文字以内で入力してください\033[0m\n'
    [user_name]='\033[31mユーザー名は50文字以内で入力してください\033[0m\n'
    [password]='\033[31mパスワードは50文字以内で入力してください\033[0m\n'
    )
    local -A user_inputs=([service_name]="" [user_name]="" [password]="")
    local -a error_messages=()

    # TODO:echoをreadに変更し行数削減
    echo -n 'サービス名を入力してください：'
    read user_inputs[service_name]
    echo -n 'ユーザー名を入力してください：'
    read user_inputs[user_name]
    echo -n 'パスワードを入力してください：'
    read -s user_inputs[password]
    echo

    # 未入力項目と文字数超過を確認し、該当するエラーメッセージを配列に追加
    validation_user_inputs

    # エラーが無い場合、入力をファイルに保存
    if [ -z "$error_messages" ]; then
        save_to_file
    # エラーがある場合、エラーメッセージ出力
    else
        for error_message in "${error_messages[@]}"; do
            printf $error_message
        done
    fi
}

# 未入力項目と文字数超過を確認し、該当するエラーメッセージを配列に追加
validation_user_inputs()
{
    max_length=50
    for index in ${!user_inputs[@]}; do
        if [ -z "${user_inputs[$index]}" ]; then
            error_messages+=("${original_message[$index]}")
        fi

        if [ "${#user_inputs[$index]}" -ge $max_length ]; then
            error_messages+=("${input_length_errors[$index]}")
        fi
    done
}

save_to_file()
{
    (
        echo "${user_inputs[service_name]}":"${user_inputs[user_name]}":"${user_inputs[password]}" >> user_input.txt
    ) 2>error.txt

    #保存失敗時、エラーメッセージを出力
    if [ $? -ne 0 ]; then
        printf '\033[31m入力内容の保存に失敗しました\033[0m\n'
        return
    fi
    printf 'Thank you\033[31m!\033[0m\n'
}

get_password()
{
    read -p 'サービス名を入力してください:' service_name
    grep "$service_name" user_input.txt
    # サービス名が登録されていなった場合
    # ユーザー情報の出力
}

while true; do
    echo 'パスワードマネージャーへようこそ！'
    read -p '次の選択肢から入力してください(Add Password/Get Password/Exit):' menu
    case $menu in
    # fix: テスト終了後条件文fを修正
        'a')
            add_password
            ;;
        'g')
            get_password
            ;;
        'Exit')
            exit
            ;;
        *)
            printf '\033[31m選択肢から入力してください\033[0m'
            echo ''
            ;;
    esac
    echo ''
done
