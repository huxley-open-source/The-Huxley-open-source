package com.thehuxley;

import java.util.HashMap;
import java.util.Map;

class EvaluationStatus {
    static byte CORRECT = 0;
    static byte WRONG_ANSWER = 1;
    static byte RUNTIME_ERROR = 2;
    static byte COMPILATION_ERROR = 3;
    static byte EMPTY_ANSWER = 4;
    static byte TIME_LIMIT_EXCEEDED = 5;
    static byte WAITING = 6;
    static byte EMPTY_TEST_CASE = 7;
    static byte WRONG_FILE_NAME = 8;
    static byte PRESENTATION_ERROR = 9;
    static byte HUXLEY_ERROR = -1;

    private EvaluationStatus() {}

    /**
     =Erro de compilação
     =Resposta vazia
     =Tempo limite excedido
     =Avaliando
     =Este problema não possui casos de teste cadastrados
     =Erro no servidor do huxley
     =Erro de formatação
     =Erro no servidor do huxley
     * @param eveluationStatusCode
     * @return
     */
    static getMsg(byte eveluationStatusCode){
        switch (eveluationStatusCode){
            case CORRECT:
                return "evaluation.correct"
                break
            case WRONG_ANSWER:
                return "evaluation.wrong_answer"
                break
            case RUNTIME_ERROR:
                return "evaluation.runtime_error"
                break
            case COMPILATION_ERROR:
                return "evaluation.compilation_error"
                break
            case EMPTY_ANSWER:
                return "evaluation.empty_answer"
                break
            case TIME_LIMIT_EXCEEDED:
                return "evaluation.time_limit_exceeded"
                break
            case WAITING:
                return "evaluation.waiting"
                break
            case EMPTY_TEST_CASE:
                return "evaluation.empty_test_case"
                break
            case WRONG_FILE_NAME:
                return "evaluation.wrong_file_name"
                break
            case PRESENTATION_ERROR:
                return "evaluation.presentation_error"
                break
            case HUXLEY_ERROR:
                return "evaluation.huxley_error"
                break

        }
    }
}
