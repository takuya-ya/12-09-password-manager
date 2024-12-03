#!/bin/bash

echo 'パスワードマネージャーへようこそ！'
echo -n 'サービス名を入力してください：'
read service_name
echo -n 'ユーザー名を入力してください：'
read user_name
echo -n 'パスワードを入力してください：'
read -s password
echo
printf 'Thank you\033[31m!\033[0m\n'
