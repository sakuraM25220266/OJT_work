#!/bin/bash -ex
#-----------------------------------------------------------------------------------------------
# 課題4で作成したスクリプトについて、検索対象ファイルを複数指定できるようにする。
# 検索対象のテキストが含まれているファイルのみ、検索結果を表示する。
# すべてのファイルを検索して見つからなかった場合は「条件に一致する行がありませんでした。」と表示する。
# 結果表示後、スクリプトを終了する。
#-----------------------------------------------------------------------------------------------

#引数にファイル名が指定されたかどうか確認する
#ファイル名が指定されなければ戻り値として1を返す
function is_empty() {
    if [ $# -eq 0 ]; then
        return 1
    fi
}

# 検索したい文字列の入力を受け付ける
function input_search_text() {
    local search_text
    read -p "検索対象のテキスト: " search_text
    echo "$search_text"
}

# メイン処理
#引数にファイル名が指定されたかどうか確認する
#ファイル名が指定されなければexit2でスクリプトを終了する
is_empty "$@"
if [ $? -ne 0 ]; then
    echo "ファイル名が指定されませんでした。スクリプトを終了します。"
    exit 2
fi

# 引数で受け取った検索対象のファイル名を配列に代入する
file_name_array=("$@")

# 検索したい文字列の入力を受け付ける
search_text=$(input_search_text)

# 引数に指定したファイル全体の中で、検索対象を含む行が何行見つかったか数えるカウンター
total_count=0

# ファイルを1行ずつ読み込んで検索を行う
for file_name in "${file_name_array[@]}"; do
    line_number=0
    #1つのファイルの中で検索対象を含む行が何行見つかったか数えるカウンター
    match_count_in_file=0
    while read line; do
        line_number=$((line_number + 1))
        if [[ "$line" == *"$search_text"* ]]; then
            match_count_in_file=$((match_count_in_file + 1))
            #検索対象を含む行が初めて見つかった場合のみファイル名を表示する
            if [ $match_count_in_file -eq 1 ]; then
                echo "ファイル名：""$file_name"
            fi
            echo -e "$line_number行目\t$line"
            total_count=$((total_count + 1))
        fi
    done <"$file_name"
done

# 検索対象が見つからなかった場合はexit1でスクリプトを終了し、見つかった場合はexit0で終了する。
if [ $total_count -eq 0 ]; then
    echo "条件に一致する行がありませんでした。"
    exit 1
else
    exit 0
fi
