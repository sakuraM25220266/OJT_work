#!/bin/bash -ex
#---------------------------------------------------------------------
#キーボードで入力した文字列をテキストファイルに出力する。
#1行目を入力したら、テキストファイルの最終行に下記のように出力する。
#日時{タブ文字}キーボードで入力した文字列
#出力ファイル名は下記のようにする。
#output_20240701_001122.tsv
#1行ファイル出力後に処理を続けるかどうかの確認を行い、終了するまでループする。
#---------------------------------------------------------------------

readonly TRUE=0
readonly FALSE=1

#ファイル名を作成する。
function generate_file_name() {
	local datetime=$(date "+%Y%m%d_%H%M%S")
	local file_name="output_${datetime}.tsv"
	echo "$file_name"
}

#ユーザーから文字列の入力を受け付ける。
#リダイレクトを行わないと、「文字列を入力してください:」がファイルに出力されるため、標準出力エラーを利用している。
#「1>&2」:標準出力(1)の出力先を標準エラー出力(2)と同じところに設定する。
function accept_user_input(){
	echo -n "文字列を入力してください:" 1>&2
	read user_input
	echo "$user_input"
}

#ファイルへ出力する1行を成形する。
function shape_output_line(){
	local user_input=$1
	local current_datetime=$(date "+%Y-%m-%d %H:%M:%S.%3N")
	echo -en "${current_datetime}\t${user_input}\n"
}

#成形した1行をtsvファイルへ出力する。
function write_file() {
	local file_name=$1
	local output_line=$2
	echo "$output_line" >> "$file_name"
	echo "ファイルへ書き込みました。"
}

#ユーザーの回答が"Y"または"N"であるかをチェックする。
#入力が正しければTRUEを、正しくなければFALSEを戻り値として返す。
function check_user_response() {
	local user_response=$1
	if [[ ! "$user_response" =~ ^[YN]$ ]]; then
		return $FALSE
	fi
	return $TRUE
}

#入力を続けるかどうか確認する。
#user_responseにYが入力されたときTRUEを、Nが入力されたときFALSEを戻り値として返す。
function confirm_if_continue() {
	while :; do
		echo -n '入力を続けますか？続ける場合は"Y"、終了する場合は"N"を入力してください:'
		read user_response
		check_user_response "$user_response"
		local return_value=$?
		if [[ $return_value = $TRUE ]]; then
			if [[ "$user_response" = "Y" ]]; then
				return $TRUE
			elif [[ "$user_response" = "N" ]]; then
				return $FALSE
			fi
		else
			echo "入力が正しくありません。もう一度入力してください。"
		fi
	done
}

#メイン処理
#ask_continueの戻り値がTRUEの場合は計算を繰り返し、FALSEの場合はスクリプトを終了する。
file_name=$(generate_file_name)
isContinue=$TRUE
while [ "$isContinue" = $TRUE ]; do
	#入力を受け付ける
	user_input=$(accept_user_input)

	#ファイルへ出力する1行を成形する
	output_line=$(shape_output_line "$user_input")

	#ファイルへ出力する
	write_file "$file_name" "$output_line"

	#入力を続けるかどうか確認する。
	confirm_if_continue
	isContinue=$?
done
echo "スクリプトを終了します。"
exit 0
