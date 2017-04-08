#!/bin/sh
FROM_ENCODING="UTF-16LE"
TO_ENCODING="UTF-8"
FROM_ENCODING_CLUE="Little-endian UTF-16"
TEMP_OUTPUT='/tmp/convall.out'

print_usage() {
	echo "Usage: $0 <project home> [<output postfix>]"
	echo "ex   : $0 /path/for/project"
	echo "ex   : $0 /path/for/project .out"
}

sh_main() {
	project_home="$1"
	output_postfix="$2"

	if [ -z "$project_home" ]; then
		print_usage
		return 1
	fi

	if [ -z "$output_postfix" ]; then
		echo "WARNING: output postfix is empty! Do you want to overwrite original files? [y/n]: "
		read overwrite

		if [ "$overwrite" != "Y" ] && [ "$overwrite" != "y" ]; then
			echo ''
			print_usage
			return 1
		fi
	fi

	files=(`find "$project_home" -type f -print`)
	count=${#files[@]}

	for (( index=0; ${index} < ${count}; index=${index}+1 ))
	do
		do_conv ${files[${index}]} $output_postfix
	done

	return 0
}

do_conv() {
	file_path="$1"
	output_postfix="$2"

	contain_text=`file "$file_path" | grep "$FROM_ENCODING_CLUE"`

	if [ -n "$contain_text" ]; then
		echo "$file_path: convert"
		`iconv -f "$FROM_ENCODING" -t "$TO_ENCODING" "$file_path" | awk 'NR==1{sub(/^\xef\xbb\xbf/,"")}1' | tr -d '\r' > "$TEMP_OUTPUT"`
		`mv "$TEMP_OUTPUT" "$file_path""$output_postfix"`
	else
		echo "$file_path: skip"
	fi
}

sh_main "$@"
