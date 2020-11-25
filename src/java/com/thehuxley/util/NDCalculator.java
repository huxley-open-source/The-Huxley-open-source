package com.thehuxley.util;

import java.util.Arrays;

public class NDCalculator {

	private final double DISTRIBUICAO_DESEJADA[] = new double[] { 0.05, 0.075,
			0.1, 0.125, 0.2, 0.125, 0.1, 0.1, 0.075, 0.05 };
	private int totalProblemasValidos;
	/**
	 * Representa o n�mero de usu�rios que acertaram cada problema. Cada posi��o
	 * do array corresponde ao n�mero de acertos de um problema.
	 */
	private int usuariosQueAcertaram[];
	private double faixaProblemas[] = new double[DISTRIBUICAO_DESEJADA.length];
	private int faixaAcertos[] = new int[DISTRIBUICAO_DESEJADA.length];

	public NDCalculator(int usuariosQueAcertaram[]) {
		this.totalProblemasValidos = usuariosQueAcertaram.length;
		this.usuariosQueAcertaram = usuariosQueAcertaram;
		/* Ordena crescente */
		Arrays.sort(this.usuariosQueAcertaram);
	}

	/**
	 * Calcula o ND com base nos problemas
	 */
	public void calcular() {
		if (DISTRIBUICAO_DESEJADA.length > 0) {
			faixaProblemas[0] = totalProblemasValidos
					* DISTRIBUICAO_DESEJADA[0];
		}
		for (int i = 1; i < DISTRIBUICAO_DESEJADA.length; i++) {
			faixaProblemas[i] = faixaProblemas[i - 1] + totalProblemasValidos
					* DISTRIBUICAO_DESEJADA[i];
		}

		int indiceFaixaAcertos = 0;

		for (int i = 0; i < faixaAcertos.length; i++) {
			faixaAcertos[i] = usuariosQueAcertaram[(int) Math
					.floor(faixaProblemas[i]) - 1];
		}

	}

	public double[] getFaixaProblemas() {
		return faixaProblemas;
	}

	/**
	 * Esse array � o mais importante.
	 * � ele quem define o n�mero de acertos que faram parte de cada ND.<br/>
	 * ND 1 = problemas cujo o n�mero de usu�rios que acertarem forem <= faixaAcertos[0] <br/>
	 * ND 2 = problemas cujo o n�mero de usu�rios que acertarem forem >faixaAcertos[0] && <= faixaAcertos[1] <br/>
	 * ...
	 * ND 10 = problemas cujo o n�mero de usu�rios que acertarem forem >faixaAcertos[8] && <= faixaAcertos[9] <br/>
	 * 
	 * @return
	 */
	public int[] getFaixaAcertos() {
		return faixaAcertos;
	}

}
