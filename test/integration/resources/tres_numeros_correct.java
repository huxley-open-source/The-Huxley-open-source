import java.util.Scanner;

public class tres_numeros_correct{
	public static void main(String[] args){
		Scanner input = new Scanner(System.in);
		int num1, num2, num3, aux;
		num1 = input.nextInt();
		num2 = input.nextInt();
		num3 = input.nextInt();
		while(num1 > num2 || num2 > num3)
		{
			if(num1 > num2)
			{
				aux = num1;
				num1= num2;
				num2 = aux;
			}
			if(num2 > num3)
			{
				aux = num2;
				num2= num3;
				num3 = aux;
			}
		}
		
		System.out.println(num1);
		System.out.println(num2);
		System.out.println(num3);
	}
}