package com.thehuxley

import com.thehuxley.EmailToSend
import org.springframework.web.servlet.i18n.SessionLocaleResolver
import org.springframework.context.MessageSource

class EmailService {
    boolean transactional = false

    SessionLocaleResolver localeResolver
    MessageSource messageSource

    /**
     * Cria um email para ser enviado
     * @param text texto a ser enviado no email
     * @param email endereço de email para destino
     */
    def sendEmailWithText(text,email){
        EmailToSend emailToSend = new EmailToSend()
        emailToSend.email = email
        emailToSend.message = text
        emailToSend.status = EmailToSend.TO_SEND
        emailToSend.save()
    }

    /**
     *
     * @param msgKey
     * @param defaultMessage default message to use if none is defined in the message source
     * @param objs objects for use in the message
     * @return
     */
    def msg(String msgKey, String defaultMessage = null, List objs = null) {

        def msg = messageSource.getMessage(
                msgKey,
                objs == null ? null : objs.toArray(),
                defaultMessage,
                localeResolver.defaultLocale)



        if(msg == null || msg == defaultMessage){
            log.warn("No i18n messages specified for msgKey: ${msgKey}")
            msg = defaultMessage
        }

        return msg
    }
    def sendEmail(String msgKey, String defaultMessage = null, List objs = null,email){
        String text = msg(msgKey, defaultMessage,objs)
        EmailToSend emailToSend = new EmailToSend()
        emailToSend.email = email
        emailToSend.message = text
        emailToSend.status = EmailToSend.TO_SEND
        emailToSend.save()
    }

    def sendSimpleEmail( message, subject, email){
        EmailToSend emailToSend = new EmailToSend()
        emailToSend.email = email
        emailToSend.message = message
        emailToSend.status = EmailToSend.TO_SEND
        emailToSend.subject = subject
        emailToSend.save(flush:  true)
    }

    def wrapper  = { message, name ->

        """
        <center>
        <table cellpadding="8" cellspacing="0" style="width:100%!important;background:#ffffff;margin:0;padding:0" border="0">
        <tbody>
        <tr>
            <td valign="top">
                <table cellpadding="0" cellspacing="0" align="center" border="0">
                    <tbody>
                    <tr bgcolor="#272b31">
                        <td width="36"></td>
                        <td style="font-size:0px" height="60">
                            <img src="http://static.cdn.thehuxley.com/rsc/images/logo-white.png" alt="">
                        </td>
                        <td width="36"></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td colspan="3">
                            <table cellpadding="0" cellspacing="0" style="border-left:1px #B8B8B8 solid;border-right:1px #B8B8B8 solid;border-bottom:1px #B8B8B8 solid;border-radius:0px 0px 4px 4px" border="0" align="center">
                                <tbody>
                                <tr>
                                    <td colspan="3" height="36"></td>
                                </tr>
                                <tr>
                                    <td width="36"></td>
                                    <td width="554" style="font-size:14px;color:#444444;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif';border-collapse:collapse" align="left" valign="top">
                                        <h2>Olá ${name},</h2>
                                                ${message}
                                                <br><br>
                                                <br><br>
                                                Obrigado,
                                                <br><br>
                                                - The Huxley Team
                                                <br>
                                            </td>
                                            <td width="36"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" height="36"></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <table cellpadding="0" cellspacing="0" align="center" border="0">
                            <tbody>
                            <tr>
                                <td height="10"></td>
                            </tr>
                            <tr>
                                <td style="padding:0;border-collapse:collapse">
                                    <table cellpadding="0" cellspacing="0" align="center" border="0">
                                        <tbody>
                                        <tr style="color:#B8B8B8;font-size:11px;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif'" valign="top">
                                            <td align="left">2013 <span>The Huxley</span></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                </tbody>
            </table>
        </center>
        """
    }

    def welcomeMessage = { email, name ->
        def subject = "Bem-vindo ao The Huxley!"
        def message = """
            Seja muito bem-vindo ao The Huxley! Nós preparamos um vídeo que mostra uma visão geral do que é possível fazer no The Huxley.

            <a href="http://www.youtube.com/watch?v=Wtc_6W2o9jI&feature=share&list=PL4Z4KvihWKj82YZDWEkmsu8U5XIpCiZ7v">Confira aqui o vídeo introdutório.</a>
        """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def sendAdminMessage = { email, name, subject, message ->
        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def sendGroupAcceptedRequestMessage = { email, name, group ->
        String message = "Sua participação no grupo " + group + " foi aprovada!"
        sendSimpleEmail(wrapper(message, name), "Participação Aprovada", email)
    }

    def teacherAcceptedMessage = { email, name, institution ->
        def subject = "Agora você é um professor no The Huxley!"
        def message = """
            Boas notícias!
            <br><br>
            Seu cadastro como professor da ${institution} foi autorizado.
            <br><br>
            Agora você tem acesso a uma série de novas funcionalidades para poupar o seu tempo com as suas aulas de programação e incentivar os seus alunos a praticarem cada vez mais.
            <br><br>
            Novos recursos:
            <ul>
                <li>Criar e gerenciar grupos de alunos</li>
                <li>Gráficos;</li>
                <li>Detalhes da participação de cada estudante;</li>
                <li>Ver o perfil de cada aluno em detalhes;</li>
                <li>Criar questionários e usá-los como provas práticas ou exercícios extra-classe;</li>
                <li>Acompanhar o desempenho da sua turma em cada questionário;</li>
                <li>Acompanhar as submissões de cada aluno, inclusive saber exatamente onde ele errou;</li>
                <li>Acessar o fórum contextual para tirar dúvidas dos alunos;</li>
                <li>Cadastrar seus próprios problemas;</li>
            </ul>

            <br><br>
            <a href="http://www.youtube.com/watch?v=PlIfwjw4O64&list=PL4Z4KvihWKj82YZDWEkmsu8U5XIpCiZ7v  ">Confira aqui um vídeo com os principais recursos disponíveis pra você.</a>
             """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def institutionAcceptedMessage = { email, name, institution ->
        def subject = "Sua instituição foi aprovada"
        def message = """
            Boas notícias!
            <br><br>
            O cadastro da sua instituição foi aprovado! Com isso você passa a ser o administrador institucional e professor da ${institution}.
            <br><br>
            Como administrador institucional, será sua missão autorizar os cadastros dos professores que fazem parte da sua instituição.
            <br><br>
            Como professor, agora você tem acesso a uma série de novas funcionalidades para poupar o seu tempo com as suas aulas de programação e incentivar os seus alunos a praticarem cada vez mais.
            <br><br>
            Novos recursos:
            <ul>
                <li>Criar e gerenciar grupos de alunos</li>
                <li>Gráficos;</li>
                <li>Detalhes da participação de cada estudante;</li>
                <li>Ver o perfil de cada aluno em detalhes;</li>
                <li>Criar questionários e usá-los como provas práticas ou exercícios extra-classe;</li>
                <li>Acompanhar o desempenho da sua turma em cada questionário;</li>
                <li>Acompanhar as submissões de cada aluno, inclusive saber exatamente onde ele errou;</li>
                <li>Acessar o fórum contextual para tirar dúvidas dos alunos;</li>
                <li>Cadastrar seus próprios problemas;</li>
            </ul>

            <br><br>
            <a href="http://www.youtube.com/watch?v=PlIfwjw4O64&list=PL4Z4KvihWKj82YZDWEkmsu8U5XIpCiZ7v  ">Confira aqui um vídeo com os principais recursos disponíveis pra você.</a>
             """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def documentInstitutionSentMessage = { email, name ->
        def subject = "Os comprovantes da sua instituição foram recebidos"
        def message = """
            Recebemos os arquivos que você enviou para comprovar a existência da sua instituição e do seu vínculo com ela.
            <br><br>
            Por favor, aguarde enquanto a nossa equipe verifica estas informações. Logo após a análise, o cadastro será liberado.
        """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def documentTeacherSentMessage = { email, name, institution, admin ->
        def subject = "Os comprovantes de docência foram recebidos"
        def message = """
            Recebemos os arquivos que você enviou para comprovar que você é um professor da ${institution}.
            <br><br>
            O administrador da sua instituição (${admin}) irá avaliar os seus comprovantes para aprovar a sua associação como docente. Em caso de dúvidas, procure o seu administrador institucional.
            """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def teacherPendencyMessage = { email, name, teacher ->
        def subject = "Solicitação para cadastro de professor"
        def message = """
          O ${teacher} solicitou o cadastro como professor na sua instituição. Por favor, acesse o endereço <a href="http://www.thehuxley.com/huxley/manager/pendencies">http://www.thehuxley.com/huxley/manager/pendencies</a> para aprovar ou rejeitar essa solicitação.
         """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def teacherRejectedMessage = { email, name, rejectMessage ->
        def subject = "A sua associação como professor não foi aceita"
        def message = """
            O administrador institucional rejeitou a sua solicitação de se tornar um professor no The Huxley.
        """
        if (rejectMessage) {
            message += """
                <br><br>
                Ele deixou a mensagem abaixo:
                <br><br>
                ${rejectMessage}
            """
        }

        message += """
            <br><br>
            Em caso de dúvidas, procure o seu administrador institucional.
        """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

    def institutionRejectMessage = { email, name, institution ->
        def subject = "A sua instituição não foi aceita"
        def message = """
            Desculpe-nos, mas a sua solicitação de cadastro da instituição ${institution} não foi aceita.
         """

        sendSimpleEmail(wrapper(message, name), subject, email)
    }

}
