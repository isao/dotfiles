#!/bin/zsh -e

# Generate a ctags file for Ember Handlebars components, if run from the root of
# and Ember project repo.


whence ctags >/dev/null || {
	echo 'ctags must be installed.'
	exit
}

[[ -d app/components ]] || exit

hbs_files=(app/components/**/*.hbs)
hbs_ctags=./wta.hbs.tags

cat <<EOF > $hbs_ctags
!_TAG_FILE_FORMAT   2   /extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED   0   /0=unsorted, 1=sorted, 2=foldcase/
!_TAG_OUTPUT_FILESEP    slash   /slash or backslash/
!_TAG_OUTPUT_MODE   u-ctags /u-ctags or e-ctags/
!_TAG_PATTERN_LENGTH_LIMIT  96  /0 for no limit/
!_TAG_PROGRAM_AUTHOR    Isao Yagi //
!_TAG_PROGRAM_NAME  ctags-index-hbs //
!_TAG_PROGRAM_VERSION   0.0.0   //
EOF

for pathname in $hbs_files
do
    # The file name is the template "class name".
    filename=$(basename $pathname .hbs)

    # Split on "-".
    nameparts=(${(s:-:)filename})

    # Uppercase initial letters of each part, and join.
    classname=${(j::)${(C)nameparts}}

    # Create a "class" entry for the file, use line 1.
    printf "%s\t$pathname\t1;\"c\tline:1\n" $classname >> $hbs_ctags
done
