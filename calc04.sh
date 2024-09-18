#!/bin/bash -ex
#---------------------------------------------------------------------
# 課題3のスクリプトで作成したTSVファイルに対してテキスト検索を行う。
# 検索したいテキストを入力し、その文字列が含まれている行番号、含まれる行の全文を表示する。
# 1行も見つからなかった場合は「条件に一致する行がありませんでした。」と表示する。
# 結果表示後、スクリプトを終了する。
#---------------------------------------------------------------------

readonly TRUE=0
readonly FALSE=1

# 検索したい文字列の入力を受け付ける
function input_serch_text() {
    local serch_text
    read -p "検索対象のテキスト: " serch_text
    echo "$serch_text"
}

# メイン処理
# 引数で受け取った検索対象のファイル名を変数に代入する
file_name="$1"

# 検索したい文字列の入力を受け付ける
serch_text=$(input_serch_text)

# 検索結果を格納するためのフラグ
is_found=$FALSE

line_number=0

# ファイルを1行ずつ読み込んで検索を行う
while read line; do
    line_number=$((line_number + 1))
    if [[ "$line" == *"$serch_text"* ]]; then
        echo -e "$line_number" "行目\t" "$line"
        is_found=$TRUE
    fi
done < "$file_name"

# 結果が見つからなかった場合はexit1でスクリプトを終了し、見つかった場合はexit0で終了する。
if [ $is_found = $FALSE ]; then
    echo "条件に一致する行がありませんでした。"
    exit 1
else
    exit 0
fi