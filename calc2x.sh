#!/bin/bash -ex

#入力された数値が整数かチェックする。
function check_num (){
        local num=$1
        if [[ ! "$num" =~ ^[+-]?[0-9]+$ ]]; then
                echo "整数ではありません。もう一度入力してください。"
                return 1
        fi
        return 0
}

#入力された演算子をチェックする。
#正規表現では「-」は特殊文字として扱われてしまうため、末尾に記載する。
#^[+-*/]$→誤
#^[+*/-]$→正
function check_operator () {
        local operator=$1
        if [[ ! "$operator" =~ ^[+*/-]$ ]]; then
                echo "無効な演算子です。もう一度入力してください。"
                return 1
        fi
        return 0
}

#ユーザーの回答が"Y"または"N"であるかをチェックする。
function check_answer () {
	local answer=$1
	if [[ ! "$answer" =~ ^[YN]$ ]]; then
		echo "入力が正しくありません。もう一度入力してください。"
		return 1
	fi
	return 0
}

#整数と演算子の入力を受け付け、計算を行う。
function calculation (){
	#1つ目の整数を入力する。
	#入力チェックを行い、整数以外が入力された場合は入力を繰り返す。
	while :
	do
		echo -n "1つ目の整数を入力してください:"
	        read num1
		if check_num "$num1"; then
	                break
	        fi
	done

	#演算子を入力する。
	#入力チェックを行い、正しい演算子が入力されない場合は入力を繰り返す。
	while :
	do
	        echo -n "演算子(+,-,*,/)の中から１つ選んで入力してください:"
	        read operator
	        if check_operator "$operator"; then
	                break
	        fi
	done

	#2つ目の整数を入力する。
	#入力チェックを行い、整数以外が入力された場合は入力を繰り返す。
	while :
	do
	        echo -n "2つ目の整数を入力してください:"
	        read num2
	        if check_num "$num2"; then
	                if [[ "$operator" = "/" && "$num2" -eq 0 ]]; then
	                        echo "0では割れません。もう一度入力してください。"
	                else
	                        break
	                fi
	        fi
	done

	#計算を行う。
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

#計算を行い、再度計算を続けるか続けないかを尋ねる。
#続ける場合は"Y"、続けない場合は"N"を入力する。
while :
do
	#計算を実行する。
	calculation
	#続けるかどうかの確認をする。
	while :
	do
		echo -n '計算を続けますか？続ける場合は"Y"、終了する場合は"N"を入力してください:'
		read answer
		if check_answer "$answer"; then
			case $answer in
				Y)
					break
					;;
				N)
					echo "スクリプトを終了します。"
					exit 0
					;;
			esac	
		fi
	done
done
