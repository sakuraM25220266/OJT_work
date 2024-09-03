#!/bin/bash -ex
#---------------------------------------------------------------------
#キーボードで入力した文字列をテキストファイルに出力する。
#1行目を入力したら、テキストファイルの最終行に下記のように出力する。
#日時{タブ文字}キーボードで入力した文字列
#出力ファイル名は下記のようにする。
#output_20240701_001122.tsv
#1行ファイル出力後に処理を続けるかどうかの確認を行い、終了するまでループする。
#---------------------------------------------------------------------

#ファイルを作成する。
function make_file() {
	local datetime=$(date "+%Y%m%d_%H%M%S")
	local file_name="output_${datetime}.tsv"
	echo "$file_name"
}

#ユーザーから文字列の入力を受け付ける。
function get_text(){
	echo -n "文字列を入力してください:"
	read user_input
}

#文字列と一緒にファイルに出力される現在日時を取得する。
function get_current_datetime(){
	current_datetime=$(date "+%Y-%m-%d %H:%M:%S.%3N")
}

#日時と文字列をtsvファイルへ出力する。
function write() {
	local file_name=$1
	local datetime=$2
	local user_input=$3
	echo -en "${current_datetime}\t${user_input}\\n" >> "$file_name"
}

#ユーザーの回答が"Y"または"N"であるかをチェックする。
#入力が正しければ0を、正しくなければ1を戻り値として返す。
function check_continue_response() {
	local continue_response=$1
	if [[ ! "$continue_response" =~ ^[YN]$ ]]; then
		return 1
	fi
	return 0
}

#入力を続けるかどうか確認する。
#continue_responseにYが入力されたとき0を、Nが入力されたとき1を戻り値として返す。
function ask_continue() {
	while :; do
		echo -n '入力を続けますか？続ける場合は"Y"、終了する場合は"N"を入力してください:'
		read continue_response
		check_continue_response "$continue_response"
		local return_value=$?
		if [[ $return_value -eq 0 ]]; then
			if [[ "$continue_response" = "Y" ]]; then
				return 0
			elif [[ "$continue_response" = "N" ]]; then
				return 1
			fi
		else
			echo "入力が正しくありません。もう一度入力してください。"
		fi
	done
}

#メイン処理
#ask_continueの戻り値が0の場合は計算を繰り返し、1の場合はスクリプトを終了する。
file_name=$(make_file)
continue_program=0
while [ "$continue_program" -eq 0 ]; do
	get_text
	get_current_datetime
	write "$file_name" "$current_datetime" "$user_input"
	echo "ファイルへ書き込みました。"
	ask_continue
	continue_program=$?
done
echo "スクリプトを終了します。"
exit 0