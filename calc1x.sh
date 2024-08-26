#!/bin/bash

#入力された数値が整数かチェックする。
function check_num () {
	local num=$1
	if [[ ! "$num" =~ ^[+-]?[0-9]+$ ]]; then
		echo "整数ではありません。スクリプトを終了します。"
		exit 1
	fi
}

#入力された演算子をチェックする。
#正規表現では「-」は特殊文字として扱われてしまうため、末尾に記載する。
#^[+-*/]$→誤
#^[+*/-]$→正
function check_operator () {
	local operator=$1
	if [[ ! "$operator" =~ ^[+*/-]$ ]]; then
		echo "無効な演算子です。スクリプトを終了します。"
		exit 1
	fi
}

#1つ目の整数を入力する。
echo -n "1つ目の整数を入力してください:"
read num1

#入力されたnum1が整数かチェックする。
check_num "$num1"

#演算子を入力する
echo -n "演算子(+,-,*,/)の中から１つ選んで入力してください:"
read operator

#入力されたoperatorが正しいかチェックする
check_operator "$operator"

echo -n "２つ目の整数を入力してください:"
read num2

#入力されたnum2が整数かチェックする。
check_num "$num2"

#計算を行う
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
		if [[ "$num2" -eq 0 ]]; then
			echo "0では割れません。スクリプトを終了します。"
			exit 2
		fi
		result=$((num1 / num2))
		remainder=$((num1 % num2))
		echo "$num1 $operator $num2 = $result 余り $remainder"
		;;

esac
