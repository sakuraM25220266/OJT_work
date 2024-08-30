#!/bin/bash -ex

#キーボードから数値1、演算子、数値2を入力して四則演算を行い、結果を表示する。
#入力チェックを行い、入力エラーの場合は入力を繰り返す。
#計算結果の表示後に計算ループを続けるかどうかを確認し、"Y"が入力されたときはループを続け、"N"が入力されたときはスクリプトを終了する。

#入力された数値が整数かチェックする。
#入力が正しければ0を、正しくなければ1を戻り値として返す。
function check_num() {
	local num=$1
	if [[ ! "$num" =~ ^[+-]?[0-9]+$ ]]; then
		return 1
	fi
	return 0
}

#入力された演算子をチェックする。
#正規表現では「-」は特殊文字として扱われてしまうため、末尾に記載する。
#入力が正しければ0を、正しくなければ1を戻り値として返す。
#^[+-*/]$→誤
#^[+*/-]$→正
function check_operator() {
	local operator=$1
	if [[ ! "$operator" =~ ^[+*/-]$ ]]; then
		return 1
	fi
	return 0
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

#整数と演算子の入力を受け付ける。
function input() {
	#1つ目の整数を入力する。
	#入力チェックを行い、整数以外が入力された場合は入力を繰り返す。
	while :; do
		echo -n "1つ目の整数を入力してください:"
		read num1
		check_num "$num1"
		#関数check_numの戻り値を取得し、戻り値が0の時breakする。
		local return_value=$?
		if [[ $return_value -eq 0 ]]; then
			break
		else
			echo "整数ではありません。もう一度入力してください。"
		fi
	done

	#演算子を入力する。
	#入力チェックを行い、正しい演算子が入力されない場合は入力を繰り返す。
	while :; do
		echo -n "演算子(+,-,*,/)の中から１つ選んで入力してください:"
		read operator
		check_operator "$operator"
		#関数check_operatorの戻り値を取得し、戻り値が0の時breakする。
		local return_value=$?
		if [[ $return_value -eq 0 ]]; then
			break
		else
			echo "無効な演算子です。もう一度入力してください。"
		fi
	done

	#2つ目の整数を入力する。
	#入力チェックを行い、整数以外が入力された場合は入力を繰り返す。
	while :; do
		echo -n "2つ目の整数を入力してください:"
		read num2
		check_num "$num2"
		#関数check_numの戻り値を取得し、戻り値が0の時breakする。
		local return_value=$?
		if [[ $return_value -eq 0 ]]; then
			if [[ "$operator" = "/" && "$num2" -eq 0 ]]; then
				echo "0では割れません。もう一度入力してください。"
			else
				break
			fi
		else
			echo "整数ではありません。もう一度入力してください。"
		fi
	done
}

#num1、operator、num2を引数として受け取り、計算を行う。
function calculate() {
	local num1=$1
	local operator=$2
	local num2=$3
	local result
	local remainder
	case $operator in
	+)
		result=$((num1 + num2))
		echo "$num1 $operator $num2 = $result"
		;;
	-)
		result=$((num1 - num2))
		echo "$num1 $operator $num2 = $result"
		;;
	\*)
		result=$((num1 * num2))
		echo "$num1 $operator $num2 = $result"
		;;
	/)
		result=$((num1 / num2))
		remainder=$((num1 % num2))
		echo "$num1 $operator $num2 = $result 余り $remainder"
		;;
	esac
}

#計算を続けるかどうかを確認する。
#continue_responseにYが入力されたとき0を、Nが入力されたとき1を戻り値として返す。
function ask_continue() {
	while :; do
		echo -n '計算を続けますか？続ける場合は"Y"、終了する場合は"N"を入力してください:'
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
continue_program=0
while [ "$continue_program" -eq 0 ]; do
	input
	calculate "$num1" "$operator" "$num2"
	ask_continue
	continue_program=$?
done
echo "スクリプトを終了します。"
exit 0