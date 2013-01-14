#!/bin/sh

abort() {
        echo "$*" >&2
        exit 1
}


p3split() {
        while read a; do
                set -- $a
                for i; do
                        echo $i
                done
        done
}


p3encode() {
        read a && echo $a # "P3"
        read a && echo $a # width
        read a && echo $a # height
        read a && echo $a # max
        while read r && read g && read b; do
                read c <&9 || c=0
                r=$(( (r&0xf8)+((c>>5)&7) ))
                g=$(( (g&0xfc)+((c>>3)&3) ))
                b=$(( (b&0xf8)+((c>>0)&7) ))
                echo $r $g $b
        done
}


p3decode() {
        read a # "P3"
        read a # width
        read a # height
        read a # max
        while read r && read g && read b; do
                c=$(( ((r&7)<<5) + ((g&3)<<3) + ((b&7)<<0) ))
                test $c -eq 0 && break
                printf %b $(printf '\\0%o' $c)
        done
}


encode() {
        test $# -lt 2 && abort "Usage: $0 plain.txt source.png >embedded.png"
        exec 8<&0
        od -v -An -tu1 "$1" | p3split | (
                exec 9<&0 <&8 8<&-
                pngtopnm "$2" | pnmtoplainpnm | p3split | p3encode | pnmtopng
        )
}


decode() {
        test $# -lt 1 && abort "Usage: $0 embedded.png >plain.txt"
        pngtopnm "$1" | pnmtoplainpnm | p3split | p3decode
}


cmd=${0##*/}
case $cmd in
encode.sh) encode "$@" ;;
decode.sh) decode "$@" ;;
*) abort "Unknown command: $cmd" ;;
esac
