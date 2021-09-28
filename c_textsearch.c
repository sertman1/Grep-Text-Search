#include <stdio.h>
#include <stdlib.h>
#include "textsearch_fns.h"

int main(int argc, char **argv) {
  
  if (argc != 3 && argc != 4) {  // check for only two valid number of args
    fprintf(stderr, "Error: invalid number of command line arguments\n");
    return 1;
  }
  FILE* input_file = fopen(argv[argc - 1], "r");
  if (input_file == NULL) { 
    fprintf(stderr, "Error: unable to open file");
    return 1;
  }

  char* desired_string = argv[argc - 2];
  char buffer[MAXLINE + 1] = {'\0'}; // to store individual lines of text from file

  if (argc == 3) {  // print lines
    
    FILE* output = fopen("output.txt", "w+");

    while (read_line(input_file, buffer) != 0) { // while you can still get lines of text from the input file
      if (count_occurrences(buffer, desired_string)) { // if any occurences were found, print line
        print_line(output, buffer);
      }
    }
    fclose(output);
  }
  else { // count occurences
    int num_occurences = 0;
    while (read_line(input_file, buffer) != 0) { 
      num_occurences += count_occurrences(buffer, desired_string);
    }
    printf("%d occurrence(s)\n", num_occurences);
  }

  fclose(input_file);

  return 0;
}
