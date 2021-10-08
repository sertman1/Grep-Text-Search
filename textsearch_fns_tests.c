#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include "textsearch_fns.h"
#include "tctest.h"

typedef struct { 
  const char *simple;
  const char *pandp;
  const char *mgf;
  const char *too_much;
} TestObjs;


TestObjs *setup(void);
void cleanup(TestObjs *objs);


// Example:
void test_read_line(TestObjs *objs);
void test_print_line(TestObjs *objs);
void test_find_string_length();
void test_starts_with();
void test_count_occurences();


int main(int argc, char **argv) {
  // Allow the name of the test function to execute to be specified
  // on the command line
  if (argc > 1) {
    tctest_testname_to_execute = argv[1];
  }

  TEST_INIT();

  TEST(test_read_line);
  TEST(test_print_line);
  TEST(test_find_string_length);
  TEST(test_starts_with);
  TEST(test_count_occurences);

  TEST_FINI();

  return 0;
}


TestObjs *setup(void) {
  TestObjs *objs = malloc(sizeof(TestObjs));
	
 objs->simple = 
    "simple";
  	
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

void test_count_occurences() {
char *b = "one";
ASSERT(count_occurrences(b, "one") == 1);
char * buff = "One truth";
ASSERT(count_occurrences(buff, "truth") == 1);
ASSERT(count_occurrences(buff, "ne") == 1);
ASSERT(count_occurrences(buff, "ruth") == 1);
ASSERT(count_occurrences(buff, " ") == 1);

  const char * buf = "It is a truth universally acknowledged, that a single man in";
  ASSERT(count_occurrences(buf, "It") == 1);
  ASSERT(count_occurrences(buf, "truth") == 1);
  ASSERT(count_occurrences(buf, "uni") == 1);
  ASSERT(count_occurrences(buf, "i") == 4);
  ASSERT(count_occurrences(buf, "X") == 0);
  ASSERT(count_occurrences(buf, "universally acknowledged,") == 1);
  ASSERT(count_occurrences(buf, "that a single man in") == 1);
  ASSERT(count_occurrences(buf, "It is a truth universally acknowledged, that a single man in\n") == 0);
  ASSERT(count_occurrences(buf, "IT IS a truth universally acknowledged, that a single man in") == 0);
  ASSERT(count_occurrences(buf, "It is a truth universally acknowledged, that a single man in") == 1);

  const char* buf2 = "So you wanna be hardcore";
  ASSERT(count_occurrences(buf2, "So") == 1);
  ASSERT(count_occurrences(buf2, "nn") == 1);
  ASSERT(count_occurrences(buf2, "2pac") == 0);
  ASSERT(count_occurrences(buf2, "a") == 3);

  const char* buf3 = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  ASSERT(count_occurrences(buf3, "0") == 511);
  buf3 = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
  ASSERT(count_occurrences(buf3, "1") == 511);
  ASSERT(count_occurrences("ThisIsATest", "i") == 1);
  ASSERT(count_occurrences("ThIsIsATest", "I") == 2);
  ASSERT(count_occurrences("aaaa 123", "aaa") == 2);

  const char* buf4 = "There are multiple there there there theres in this sentence. Seven  there there theres are desired.";
  ASSERT(count_occurrences(buf4, "there") == 7);
  ASSERT(count_occurrences(buf4, "There") == 1);
  ASSERT(count_occurrences(buf4, "theres") == 2);

  const char* buf5 = "Truthfully, truth is truthful..";
  ASSERT(count_occurrences(buf5, "truth") == 2);
  ASSERT(count_occurrences(buf5, "Truth") == 1);
  ASSERT(count_occurrences(buf5, ".") == 2);
}


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
  ASSERT(starts_with("WELPzz","WELp") == 0);
  ASSERT(starts_with("   i guess...,","   i ") == 1);
  ASSERT(starts_with("   i guess...,","   i  gX") == 0);
  ASSERT(starts_with("   i guess...,","   i guess..., .") == 0);
  ASSERT(starts_with("nochance","chance") == 0);
  ASSERT(starts_with("noNONONONONONO","NO") == 0);
  ASSERT(starts_with("","") == 1);
  ASSERT(starts_with(" ", "") == 0);
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
  ASSERT(find_string_length("notSUPERLONG   ") == 15);
  ASSERT(find_string_length("\nshort ") == 7);
  ASSERT(find_string_length("%^&crazy! *#@)$**kaO-2~'?QB+={]") == 31);
}

void test_read_line(TestObjs *objs) { 
    FILE *i = fmemopen((char *) objs->simple, strlen(objs->simple), "r");
  char b[MAXLINE + 1];
  ASSERT(read_line(i, b));
  print_line(b);
  ASSERT(0 == strcmp(b, "simple"));
  fclose(i);
  FILE *in = fmemopen((char *) objs->pandp, strlen(objs->pandp), "r");
  char buf[MAXLINE + 1];

  ASSERT(read_line(in, buf));
  print_line(buf);
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
  char buf[MAXLINE + 1];
  char buf2[MAXLINE + 1];
  char * b = "It is a truth universally acknowledged, that a single man in";
  char * b2 = "possession of a good fortune, must be in want of a wife.";
  print_line(b);
  print_line(b2);

  FILE *in = fmemopen((char *) objs->mgf, strlen(objs->mgf), "r");
  read_line(in, buf);

  print_line(buf);

  read_line(in, buf);
  print_line(buf);

  read_line(in, buf);
  print_line(buf);

  read_line(in, buf);
  print_line(buf);

  fclose(in);

  FILE *in3 = fmemopen((char *) objs->too_much, strlen(objs->too_much), "r");    
  read_line(in3, buf2);

  print_line(buf2);

  read_line(in3, buf2);
  print_line(buf2);
  fclose(in3);
 
}


