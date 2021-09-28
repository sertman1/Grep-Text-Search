#include <stdio.h>
#include <stdlib.h>
#include <string.h> // these functions may be used in the test program
#include "textsearch_fns.h"
#include "tctest.h"

typedef struct {
  const char *pandp;
  const char *mgf;
  const char *too_much;
} TestObjs;


TestObjs *setup(void);
void cleanup(TestObjs *objs);

// TODO: declare test functions

// Example:
//void test_read_line(TestObjs *objs);
//void test_print_line(TestObjs *objs);
void test_find_string_length();
void test_starts_with();
//void test_count_occurences(TestObjs *objs);


int main(int argc, char **argv) {
  // Allow the name of the test function to execute to be specified
  // on the command line
  if (argc > 1) {
    tctest_testname_to_execute = argv[1];
  }

  TEST_INIT();

  //TEST(test_read_line);
  //TEST(test_print_line);
  TEST(test_find_string_length);
  TEST(test_starts_with);
  //TEST(test_count_occurences);

  TEST_FINI();

  return 0;
}


TestObjs *setup(void) {
  TestObjs *objs = malloc(sizeof(TestObjs));

  objs->pandp =
    "It is a truth universally acknowledged, that a single man in\n"
    "possession of a good fortune, must be in want of a wife.\n"
    "\n"
    "However little known the feelings or views of such a man may be\n"
    "on his first entering a neighbourhood, this truth is so well\n"
    "fixed in the minds of the surrounding families, that he is\n"
    "considered as the rightful property of some one or other of their\n"
    "daughters.\n";

  objs->too_much =  
    "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000CDHSY*FI$IW$*@(UDNJNPZJIJOHRUHUSUOXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n"
    "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111DIUHFHUIWHUUWDXNHXANFJNWOHIFWUIDDdwhqpuuhidwXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n";

  objs->mgf = 
    "So you wanna be hardcore\n"
    "With your hat to the back, talkin' 'bout the gats in your raps\n"
    "But I can't feel that hardcore appeal\n" 
    "That you're screamin', maybe I'm dreamin'\n";

  return objs;
}


void cleanup(TestObjs *objs) {
  free(objs);
}
/*
void test_count_occurences(TestObjs *objs) {
  FILE *in = fmemopen((char *) objs->pandp, strlen(objs->pandp), "r");
  char buf[MAXLINE + 1];
  read_line(in, buf);
  ASSERT(count_occurrences(buf, "truth") == 1);
  ASSERT(count_occurrences(buf, "uni") == 1);
  ASSERT(count_occurrences(buf, "i") == 4);
  ASSERT(count_occurrences(buf, "X") == 0);
  ASSERT(count_occurrences(buf, "universally acknowledged,") == 1);
  ASSERT(count_occurrences(buf, "that a single man in") == 1);
  ASSERT(count_occurrences(buf, "It is a truth universally acknowledged, that a single man in\n") == 0);
  ASSERT(count_occurrences(buf, "IT IS a truth universally acknowledged, that a single man in") == 0);
  ASSERT(count_occurrences(buf, "It is a truth universally acknowledged, that a single man in") == 1);

  FILE *in2 = fmemopen((char *) objs->mgf, strlen(objs->mgf), "r");
  char buf2[MAXLINE + 1];
  read_line(in2, buf2);
  ASSERT(count_occurrences(buf2, "So") == 1);
  ASSERT(count_occurrences(buf2, "nn") == 1);
  ASSERT(count_occurrences(buf2, "2pac") == 0);

  FILE *in3 = fmemopen((char *) objs->too_much, strlen(objs->too_much), "r");
  char buf3[MAXLINE+1];
  read_line(in3, buf3);
  ASSERT(count_occurrences(buf3, "0") == 511);
  read_line(in3, buf3);
  ASSERT(count_occurrences(buf3, "1") == 511);

  ASSERT(count_occurrences("ThisIsATest", "i") == 1);
  ASSERT(count_occurrences("ThIsIsATest", "I") == 2);
  ASSERT(count_occurrences("aaaa 123", "aaa") == 2);

}
*/

void test_starts_with () {
  const char* s = "AndThusIWalked";
  const char* pfx_wrong = "andthus";
  ASSERT(starts_with(s, pfx_wrong) == 0);
  const char* pfx_right = "AndThus";
  ASSERT(starts_with(s, pfx_right) == 1);
  const char* whitespace = " \n so yeah...";
  const char* pfx_whitespace = " \n ";
  ASSERT(starts_with(whitespace, pfx_whitespace) == 1);
  const char* so_yeah = "so yeah...";
  ASSERT(starts_with(whitespace, so_yeah) == 0);
  ASSERT(starts_with(whitespace+10, so_yeah+7) == 1);
  char null[5] = {'\0'};
  char null2[10] = {'\0'};
  ASSERT(starts_with(null,null2) == 1);
  ASSERT(starts_with(null, so_yeah) == 0);
  ASSERT(starts_with(pfx_right, null2) == 0);
}

void test_find_string_length() {
  const char* five = "five";
  ASSERT(find_string_length(five) == 4);
  const char* none = "";
  ASSERT(find_string_length(none) == 0);
  const char* nl = "\n";
  ASSERT(find_string_length(nl) == 1);  
  const char nothing[100] = {"\0"};
  ASSERT(find_string_length(nothing) == 0);
  const char everything[10] = {1,2,3,4,5,6,7,8,9,10};
  ASSERT(find_string_length(everything) == 10);
  char some[5];
  some[0] = 'h';
  some[1] = 'i';
  some[2] = '!';
  some[3] = '\0';
  ASSERT(find_string_length(some) == 3);
  some[3] = '!';
  some[4] = '\0';
  ASSERT(find_string_length(some) == 4);
  const char* opening_line = "It is a truth universally acknowledged, that a single man in\n";
  ASSERT(find_string_length(opening_line) == 61);
 }
/*
void test_read_line(TestObjs *objs) {
  // the fmemopen function allows us to treat a character string
  // as an input file
  FILE *in = fmemopen((char *) objs->pandp, strlen(objs->pandp), "r");
  char buf[MAXLINE + 1];

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "It is a truth universally acknowledged, that a single man in"));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "possession of a good fortune, must be in want of a wife."));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, ""));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "However little known the feelings or views of such a man may be"));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "on his first entering a neighbourhood, this truth is so well"));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "fixed in the minds of the surrounding families, that he is"));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "considered as the rightful property of some one or other of their"));

  ASSERT(read_line(in, buf));
  ASSERT(0 == strcmp(buf, "daughters."));

  // at this point we have read the last line
  ASSERT(!read_line(in, buf));

  FILE *in2 = fmemopen((char *) objs->too_much, strlen(objs->too_much), "r");
  char buf2[MAXLINE + 1];
  read_line(in2, buf2);
  int only_zeros= 1;
  for (int i = 0; i < (int)strlen(buf2); i++) {
    if (buf2[i] != '0') {
      only_zeros = 0;
    }
  }
  ASSERT(only_zeros);
  ASSERT(strlen(buf2) == 511);
  read_line(in2, buf2);
  int only_ones = 1;
  for (int i = 0; i < (int)strlen(buf2); i++) {
    if (buf2[i] != '1') {
      only_ones = 0;
    }
  }
  ASSERT(only_ones);
  ASSERT(strlen(buf2) == 511);

  fclose(in);
  fclose(in2);
}

void test_print_line(TestObjs * objs) {

  FILE *in = fmemopen((char *) objs->mgf, strlen(objs->mgf), "r");
  char buf[MAXLINE + 1];
  read_line(in, buf);

  FILE* out = fopen("output.txt", "w+");
  ASSERT(out != NULL);

  print_line(out, buf);

  read_line(in, buf);
  print_line(out, buf);

  read_line(in, buf);
  print_line(out, buf);

  read_line(in, buf);
  print_line(out, buf);

  FILE *in2 = fmemopen((char *) objs->mgf, strlen(objs->mgf), "r");
  char c = fgetc(out);
  while (c != EOF) {
    ASSERT(c == fgetc(in2));
  }
  fclose(out);
  fclose(in);
  fclose(in2);

  FILE *in3 = fmemopen((char *) objs->too_much, strlen(objs->too_much), "r");    
  char buf2[MAXLINE + 1];
  read_line(in3, buf2);

  FILE* out2 = fopen("output.txt", "w+");
  ASSERT(out != NULL);

  print_line(out, buf2);

  read_line(in3, buf2);
  print_line(out, buf2);

  FILE *in4 = fmemopen((char *) objs->mgf, strlen(objs->mgf), "r");
  char c2 = fgetc(out);
  while (c2 != EOF) {
    ASSERT(c2 == fgetc(in4));
  }

  fclose(in3);
  fclose(in4);
  fclose(out2);
}
*/

