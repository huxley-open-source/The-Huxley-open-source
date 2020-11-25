a = int(input())
b = int(input())
c = int(input())
if(a >= b)and(a >= c):
    if(b >= c):
        print(c)
        print(b)
        print(a)
    else:
        print(b)
        print(c)
        print(a)
elif(b >= a)and(b >= c):
    if(a >= c):
        print(c)
        print(a)
        print(b)
    else:
        print(a)
        print(c)
        print(b)
elif(c >= a)and(c >= b):
    if(a >= b):
        print(b)
        print(a)
        print(c)
    else:
        print(a)
        print(b)
        print(c)
elif(a==b==c):
    print(a)
    print(b)
    print(c)
