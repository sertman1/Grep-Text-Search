#include <stdio.h>
#include "textsearch_fns.h"

int read_line(FILE *in, char *buf) {
    char c = fgetc(in);
    if (c == EOF) {
        return 0; // indicates failure to read line
    }
    else {
        int i = 0;
        for (; i < MAXLINE; i++) {
            if (c == EOF || c == '\n') {
                break; // 'in' no longer points to current line of text => immediatley stop
            }
            buf[i] = c;
            c = fgetc(in);
        }
        buf[i] = '\0';
        if (i == 511)  { // check if line had more than 511 chars
            while (c != '\n') { // if so, make 'in' point to next line for future read_line calls
                c = fgetc(in);
                if (c == EOF) {
                    break;
                }
            }
        }
        return 1;
    }
}

void print_line(const char *buf) {
    int i = 0;
    for (; i < MAXLINE; i++) {
        if (buf[i] == '\0') {
            break;
        }
        printf("%c", buf[i]);
    }
    printf("\n");
}

unsigned count_occurrences(const char *line, const char *str) {
    unsigned occurrences = 0;
    for (unsigned i = 0; i < find_string_length(line); i++) {
        if (starts_with((line + i), str)) {
            occurrences++;
        }
    }
    return occurrences;
}

unsigned find_string_length(const char *s) {
    unsigned length = 0;
    int index = 0;
    while (s[index] != '\0') {
        length++;
        index++;
    }   
    return length;
}

int starts_with(const char *s, const char *pfx) {
    if (pfx[0] == '\0') {
        if (s[0] == '\0') {
            return 1; // both are null terminators
        }
        return 0;
    }
    else if (s[0] == '\0') {
        return 0;
    }
    unsigned pfx_length = find_string_length(pfx);
    unsigned string_length = find_string_length(s);
    if (string_length < pfx_length) {
        return 0;
    }
    for (unsigned i = 0; i < pfx_length; i++) {
        if (s[i] != pfx[i]) {
            return 0;
        }

    }
    return 1;
}
