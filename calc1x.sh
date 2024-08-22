#!/bin/bash

#1つ目の整数を入力する。
echo -n "1つ目の整数を入力してください:"
read num1

#入力されたnum1が整数かチェックする。
if [[ ! "$num1" =~ ^[+-]?[0-9]+$ ]]; then
	echo "整数ではありません。スクリプトを終了します。"
	exit 1
fi

echo -n "２つ目の整数を入力してください:"
read num2

#入力されたnum2が整数かチェックする。
if [[ ! "$num2" =~ ^[+-]?[0-9]+$ ]]; then
        echo "整数ではありません。スクリプトを終了します。"
        exit 1
fi

echo -n "演算子(+,-,*,/)の中から１つ選んで入力してください:"
read operator

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
		if [[ "$num" -eq 0 ]]; then
			echo "0では割れません。スクリプトを終了します。"
			exit 1
		fi
		result=$((num1 / num2))
		remainder=$((num1 % num2))
		echo "$num1 $operator $num2 = $result 余り $remainder"
		;;
	*)
		echo "無効な演算子です。スクリプトを終了します。"
		exit 1
		;;
esac
