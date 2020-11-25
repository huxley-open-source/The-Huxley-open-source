package com.thehuxley.stimulusPredictor;

import com.thehuxley.stimulusPredictor.libsvm.*;

import java.io.*;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class SvmPredict {
	private static svm_print_interface svm_print_null = new svm_print_interface()
	{
		public void print(String s) {}
	};

	private static svm_print_interface svm_print_stdout = new svm_print_interface()
	{
		public void print(String s)
		{
			System.out.print(s);
		}
	};

	private static svm_print_interface svm_print_string = svm_print_stdout;

	static void info(String s) 
	{
		svm_print_string.print(s);
	}

	private static double atof(String s)
	{
		return Double.valueOf(s).doubleValue();
	}

	private static int atoi(String s)
	{
		return Integer.parseInt(s);
	}

	private static ArrayList<Double> predict(ArrayList<String> input, svm_model model, int predict_probability) throws IOException
	{
		int correct = 0;
		int total = 0;
		double error = 0;
		double sumv = 0, sumy = 0, sumvv = 0, sumyy = 0, sumvy = 0;
        ArrayList<Double> result = new ArrayList<Double>();

		int svm_type=svm.svm_get_svm_type(model);
		int nr_class=svm.svm_get_nr_class(model);
		double[] prob_estimates=null;

		if(predict_probability == 1)
		{
			if(svm_type == svm_parameter.EPSILON_SVR ||
			   svm_type == svm_parameter.NU_SVR)
			{
                SvmPredict.info("Prob. model for test data: target value = predicted value + z,\nz: Laplace distribution e^(-|z|/sigma)/(2sigma),sigma="+svm.svm_get_svr_probability(model)+"\n");
			}
			else
			{
				int[] labels=new int[nr_class];
				svm.svm_get_labels(model,labels);
				prob_estimates = new double[nr_class];
				//output.writeBytes("labels");
              //  result += "labels";
				for(int j=0;j<nr_class;j++){
					//output.writeBytes(" "+labels[j]);
                //    result += " " + labels[j];;
                }
				//output.writeBytes("\n");
                //result += "\n";
			}
		}
		for(String instance: input)
		{
			String line = instance;
			if(line == null) break;

			StringTokenizer st = new StringTokenizer(line," \t\n\r\f:");

			double target = atof(st.nextToken());
			int m = st.countTokens()/2;
			svm_node[] x = new svm_node[m];
			for(int j=0;j<m;j++)
			{
				x[j] = new svm_node();
				x[j].index = atoi(st.nextToken());
				x[j].value = atof(st.nextToken());
			}

			double v;
			if (predict_probability==1 && (svm_type==svm_parameter.C_SVC || svm_type==svm_parameter.NU_SVC))
			{
				v = svm.svm_predict_probability(model,x,prob_estimates);
				//output.writeBytes(v+" ");
                //result += v + " ";
                result.add(v);
				for(int j=0;j<nr_class;j++){
					//output.writeBytes(prob_estimates[j]+" ");
                    //result += prob_estimates[j]+" ";
                    result.add(prob_estimates[j]);
                }
				//output.writeBytes("\n");
                //result += "\n";
            }
			else
			{
				v = svm.svm_predict(model,x);
				//output.writeBytes(v+"\n");
                //result += "," + v;
                result.add(v);
			}


			if(v == target)
				++correct;
			error += (v-target)*(v-target);
			sumv += v;
			sumy += target;
			sumvv += v*v;
			sumyy += target*target;
			sumvy += v*target;
			++total;
		}
		if(svm_type == svm_parameter.EPSILON_SVR ||
		   svm_type == svm_parameter.NU_SVR)
		{
            SvmPredict.info("Mean squared error = "+error/total+" (regression)\n");
            SvmPredict.info("Squared correlation coefficient = "+
				 ((total*sumvy-sumv*sumy)*(total*sumvy-sumv*sumy))/
				 ((total*sumvv-sumv*sumv)*(total*sumyy-sumy*sumy))+
				 " (regression)\n");
		}
		else{
            SvmPredict.info("Accuracy = "+(double)correct/total*100+
				 "% ("+correct+"/"+total+") (classification)\n");
        }
        return result;
	}

	private static void exit_with_help()
	{
		System.out.print("usage: svm_predict [options] test_file model_file output_file\n"
		+"options:\n"
		+"-b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0); one-class SVM not supported yet\n"
		+"-q : quiet mode (no outputs)\n");
	}

    public static ArrayList<Double> runPredict(ArrayList<String> input, String pathModel) throws IOException {
        ArrayList<Double> result = new ArrayList<Double>();
        int i, predict_probability=0;
        svm_print_string = svm_print_stdout;

        try
        {
            svm_model model = svm.svm_load_model(pathModel);
            if(predict_probability == 1)
            {
                if(svm.svm_check_probability_model(model)==0)
                {
                    System.out.print("Model does not support probabiliy estimates\n");
                }
            }
            else
            {
                if(svm.svm_check_probability_model(model)!=0)
                {
                    SvmPredict.info("Model supports probability estimates, but disabled in prediction.\n");
                }
            }
            result = predict(input,model,predict_probability);

        }
        catch(FileNotFoundException e)
        {
            exit_with_help();
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            exit_with_help();
        }
        return result;
    }
}
