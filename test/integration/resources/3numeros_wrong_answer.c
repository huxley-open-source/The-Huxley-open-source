#include <stdio.h>

int main() {
	int a, b, c, pos1, pos2, pos3;
	scanf("%d\n", &a);
	scanf("%d\n", &b);
	scanf("%d\n", &c);
	if(a >= b && a >= c) {
		pos1 = a;
		if(b >= c) {
			pos2 = b;
			pos3 = c;
		} else {
			pos2 = c;
			pos3 = b;
		}
	} else if(b >= a && b >= c){
		pos1 = b;
		if(a >= c){
			pos2 = a;
			pos3 = c;
		} else {
			pos2 = c;
			pos3 = a;
		}
	} else if(c >= a && c >= b){
		pos1 = c;
		if(a >= b){
			pos2 = a;
			pos3 = b;
		} else {
			pos2 = b;
			pos3 = a;
		}
	}
	printf("%d\n%d\n%d\n", pos1, pos2, pos3);
	return 0;
}