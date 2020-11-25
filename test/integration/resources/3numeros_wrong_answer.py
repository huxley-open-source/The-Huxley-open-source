quantdivisores = 0
num = int(input())
for divisores in range(1,num + 1):
    if(num % divisores == 0):
        if(divisores % 3 == 0):
               quantdivisores+=1

if(quantdivisores > 0):
    print(quantdivisores)

else:
    print("O numero na`o possui divisores multiplos de 3!")