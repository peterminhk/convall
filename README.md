# convall
Convert all files in a specific directory from one encoding to another encoding.

## Purpose
Some people are struggling to figure out why some files cannot be shown in diff view, but only show "Binary file not shown." (in github) or "No preview for this file type" (in gitlab) message.

I found out git cannot show diff for UTF-16LE encoded text files, and if you convert encoding of those files then you can see diffs.

You can do this with iconv, but this script helps you convert all files at once.
This script will convert UTF-16LE to UTF-8 and also strip [BOM](https://en.wikipedia.org/wiki/Byte_order_mark).

## Getting Started

Usage:
```
convall.sh <project home> [<output postfix>]
```

You can overwrite original files:
```
convall.sh /path/for/project
```

You can create new files as output:
```
convall.sh /path/for/project .out
```

## How to Customize

Maybe this diff problem also happened to some other encodings not only UTF-16LE.
If you want to run convall for other encodings then edit these variables in the script.

```
FROM_ENCODING="UTF-16LE"
TO_ENCODING="UTF-8"
FROM_ENCODING_CLUE="Little-endian UTF-16"
```

You can pick 'clue texts' from the result of 'file /path/for/source/file' command.
