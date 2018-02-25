#!/bin/bash
#

usage_exit() {
    if (($1)); then echo "$0: No dictionary found."; fi
    echo "Usage: $0 [-m minimum_word_length] [-r maximum_number_of_failures] [-d dictionary]" 1>&2
    exit 1
}

game_exit() {
    # tempdictにファイルが存在する場合は削除
    [ -f $tempdict ] && rm $tempdict
    reset
    print_score
    exit 0
}

print_status() {
    echo; echo -n "     Word : "
    for c in ${ans[@]}; do echo -n $c; done; echo
    echo -n " Gusessed : "
    for c in ${guessed[@]}
    # 印字可能文字以外は削除
    do
        echo $c
    done | sort | tr -cd [:print:]

    local skull="\xf0\x9f\x92\x80" fire="\xf0\x9f\x94\xa5" spark="\xf0\x9f\x92\xa5" bomb="\xf0\x9f\x92\xa3"
    echo -n -e "\n    ${skull} "; printf "(%2d/%2d):" ${failure} ${mfailures}
    for ((i=0; i<failure-1; i++)); do echo -n " "; done
    if ((failure>0)); then echo -n -e "${fire}"; fi
    for ((i=0;i<mfailures-failure-1; i++)); do echo -n "_"; done
    if ((failure==mfailures)); then echo -e "${spark}${fire}"; else echo -e "${bomb}"; fi
}

print_score() {
    echo "You got ${got} word(s) with ${challenge} challenge(s)."
    echo
}

not_in_list() {
    # リスト中に文字がないことを確認
    local c=$1
    shift
    local list=($@)
    for cc in ${list[@]}
    do
        if [ $cc = $c ]
        then
            return 1
        fi
    done
    return 0
}

not_in_word() {
    # 単語中に文字がないことを確認。ある場合はansに記入
    local c=$1
    local r=0
    for ((i=0; i < ${#w[@]}; i++))
    do
        if [ ${w[$i]} = $c ]
        then
            r=1
            ans[$i]=$c
        fi
    done
    return $r
}

dictionary="/usr/share/dict/words"
length=6 mfailures=7 challenge=0 got=0

while getopts m:d:r OPT
do
    case $OPT in
        m) length=$OPTARG ;;
        r) mfailures=$OPTARG ;;
        d) dictionary=$OPTARG ;;
        \?) usage_exit ;;
    esac
done

[ -f $dictionary ] || usage_exit 1
if (($length > 11 )); then length=11; fi
if (($mfailures < 1 )); then mfailures=7; fi

echo "minimum word length: ${length}"
echo "maximum number of failures: ${mfailures}"
echo "dictionary: ${dictionary}"

trap 'game_exit' 1 2 15

tempdict=$(mktemp /tmp/sdbangban.XXXXXX)
grep -v \' ${dictionary} | tr A-Z a-z | sort | uniq > $tempdict
dl=$(wc -l ${tempdict}); dl=${dl% *}; dl=${dl#* }

tic=('|' '/' '-' '\') # くるくる演出用
playing=1
while  ((playing))
do
    word=""
    echo
    while $(test "$word" = "")
    do
        echo -n "."
        word=$(sed -n "$((RANDOM * RANDOM % dl + 1))p" ${tempdict})
        if (( ${#word} < length )); then word=""; fi
    done

    w=()
    ans=()
    while read -n 1 c
    do
        if [ "$c" != "" ]; then w+=("$c") ans+=("-"); fi
    done <<< $word

    echo
    guessed=()
    failure=0
    challenge=$((challenge+1))

    print_status
    while :
    do
        # -s: silent(読み込み時にechoしない)
        # -p: prompt
        while read -s -n 1 -p "Guess:" c
        do
            case $c in
                [A-Z]) c=$(tr A-Z a-z <<< ${c}); break ;;
                [a-z]) break ;;
                *) printf "\nNot a valid guess: '%c'\n" ${c}; continue ;;
            esac
        done
        echo $c
        if not_in_list "$c" ${guessed[@]} # not in guessed
        then
            guessed+=("$c")
            if not_in_word "$c" # not in word
            then
                failure=$((failure+1))
            fi
        else
            echo "Already guessed '$c'"
        fi

        print_status
        if not_in_list "-" ${ans[@]}
        then
            echo
            echo "You got it! Yes, theh word was \"${word}\""
            got=$((got+1))
            break
        elif (( failure >= mfailures ))
        then
            echo
            echo "Sorry, the word was \"${word}\""
            break
        fi
    done
    print_score

    # リトライ前のくるくる演出
    echo -n -e "\033[?25l"
    for ((i=0; i < ${#tic[@]} * 5 + 1; i++)); do m=$((i % ${#tic[@]})); sleep 0.1; printf "%c\r" ${tic[$m]}; done;
    echo -n -e "\033[?25h"

    while read -s -n 1 -p "Another word? " retry
    do
        echo $retry
        case $retry in
            [Yy]) break ;;
            [Nn]) playing=0; break;;
            *) echo "Please type 'y' or 'n'" ;;
        esac
    done
done

game_exit
