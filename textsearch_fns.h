#ifndef TEXTSEARCH_FNS_H
#define TEXTSEARCH_FNS_H

#define MAXLINE 511

int read_line(FILE *in, char *buf);
void print_line(const char *buf);
unsigned count_occurrences(const char *line, const char *str);
unsigned find_string_length(const char *s);
int starts_with(const char *s, const char *pfx);

#endif // TEXTSEARCH_FNS_H
