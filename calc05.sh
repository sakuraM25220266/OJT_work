#!/bin/bash -ex
#-----------------------------------------------------------------------------------------------
# 課題4のスクリプトに対して、複数のファイルを引数で指定し、すべてのファイルを検索する。
# 検索対象のテキストが含まれているファイルのみ、検索結果を表示する。
# すべてのファイルを検索して見つからなかった場合は「条件に一致する行がありませんでした。」と表示する。
# 結果表示後、スクリプトを終了する。
#-----------------------------------------------------------------------------------------------

readonly TRUE=0
readonly FALSE=1

# 検索したい文字列の入力を受け付ける
function input_search_text() {
    local search_text
    read -p "検索対象のテキスト: " search_text
    echo "$search_text"
}

# メイン処理
# 引数で受け取った検索対象のファイル名を配列に代入する
file_name_array=("$@")

# 検索したい文字列の入力を受け付ける
search_text=$(input_search_text)

# 検索結果を格納するためのフラグ
is_found=$FALSE

# ファイルを1行ずつ読み込んで検索を行う
for file_name in "${file_name_array[@]}"; do
    line_number=0
    #ファイル内に検索対象の文字列が見つかったかどうかを示すためのフラグ
    has_matches=$FALSE
    while read line; do
        line_number=$((line_number + 1))
        if [[ "$line" == *"$search_text"* ]]; then
            #検索対象の文字列が見つかった場合にファイル名を表示する
            if [ $has_matches = $FALSE ]; then
                echo "ファイル名：""$file_name"
                has_matches=$TRUE
            fi
            echo -e "$line_number行目\t$line"
            is_found=$TRUE
        fi
    done < "$file_name"
done

# 結果が見つからなかった場合はexit1でスクリプトを終了し、見つかった場合はexit0で終了する。
if [ $is_found = $FALSE ]; then
    echo "条件に一致する行がありませんでした。"
    exit 1
else
    exit 0
fi