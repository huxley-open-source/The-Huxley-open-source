<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br, en">
    <head>
        <meta name="layout" content="info"/>

        <style>
            body {
                font-family: verdana, arial, sans-serif;
            }
            .plan-title {
                background-color: #f5f5f5;
                background-image: -webkit-linear-gradient(top,#f5f5f5,#f1f1f1);
                background-image: -moz-linear-gradient(top,#f5f5f5,#f1f1f1);
                background-image: -ms-linear-gradient(top,#f5f5f5,#f1f1f1);
                background-image: -o-linear-gradient(top,#f5f5f5,#f1f1f1);
                background-image: linear-gradient(top,#f5f5f5,#f1f1f1);
                color: #444;
                font-size: 26px;
                padding: 10px 20px;
                border: 1px solid #dcdcdc;
            }

            .plan {
                display: inline-table;
                margin-right: 10px;
                width: 260px;
                max-width: 260px;
            }

            .price {
                font-weight: bold;
                font-size: 56px;
            }

            .price .currency {
                font-size: 16px
            }

            .price .cents {
                font-size: 16px
            }

            .byuser {
                font-size: 12px;
            }

            .save, .coupon-discount, .error {
                font-size: 12px;
                color: red;
            }

            .total {
                font-weight: bold;
                font-size: 16px;
            }

            .plan-content {
                height: 150px;
                padding: 30px 5px;
            }

            .buttons {
                margin-top: 20px;
            }

            label.students {
                font-weight: bold;
                font-size: 16px;
                line-height: 51px;
                padding: 0 9px 0px 41px;
                display: inline;
            }

            label.cupon {

            }
        </style>

        <script type="text/javascript">
            $(function () {

                var plan = null;
                var discount = 0;
                var students = 0;


                $('#students').keyup(function () {
                    var studentsTotal = $(this).val();

                    if (studentsTotal >= 0) {
                        $('#total-month').empty().html((studentsTotal * 11.60).toFixed(2).toString().replace(".", ","));
                        $('#total-semester').empty().html((studentsTotal * 10.80 * 6).toFixed(2).toString().replace(".", ","));
                        $('#total-year').empty().html((studentsTotal * 9.90 * 12).toFixed(2).toString().replace(".", ","));
                        $('#save-semester').empty().html("Você economiza R$ " + ((studentsTotal * 11.60 * 6) - (studentsTotal * 10.80 * 6)).toFixed(2).toString().replace(".", ","));
                        $('#save-year').empty().html("Você economiza R$ " + ((studentsTotal * 11.60 * 12) - (studentsTotal * 9.90 * 12)).toFixed(2).toString().replace(".", ","));
                    }

                    if (plan != null) {
                        totalAbstract(plan);
                    }
                });

                $('#continue').click(function () {

                    if ($('#students').val() <= 0) {
                        $('#error').empty().html("Selecione o número de estudantes que deseja gerenciar.");
                    } else if (plan === null) {
                        $('#error').empty().html("Escolha um plano.");
                    } else {
                        $.ajax('/huxley/payment/checkout', {
                            data: JSON.stringify({frequency: plan, quantity: $('#students').val(), hash: $('#coupon').val()}),
                            type: 'POST',
                            dataType: 'json',
                            contentType: 'application/json',
                            beforeSend: function () {
                                discount = 0;
                                $('#continue').empty().html('Processando...');
                            },
                            success: function (data) {
                                window.location.href = data.url;
                            },
                            error: function () {
                                $('#error').empty().html('Desculpe, ocorreu um erro, tente novamente mais tarde.')
                            }
                        });

                        $('#continue').empty().html("Continuar")
                    }
                });

                var totalAbstract = function (frequency) {

                    var ft = "mês";
                    var ff = "mensal"
                    var price = 11.60;

                    if (frequency === 1) {
                        ft = "mês";
                        ff = "Mensal"
                        price = 11.60;
                    } else if (frequency === 6) {
                        ft = "semestre";
                        ff = "Semestral"
                        price = 10.80;
                    } else if (frequency === 12) {
                        ft = "ano";
                        ff = "Anual"
                        price = 9.90;
                    }

                    var studentsTotal = $('#students').val();
                    var total = (studentsTotal * price * frequency);
                    var discountTotal = (total * (discount/100)).toFixed(2);
                    var discountMessage = "";

                    if (discount > 0) {
                        discountMessage = " com o desconto de R$ " + discountTotal.replace(".", ",")  + ', totalizando <b style="font-size: 16px;"> R$ ' + (total - discountTotal).toFixed(2).replace(".", ",") + "</b>";
                    }

                    $('#abstract').empty().html("Plano " + ff + ": <b>R$ " + total.toFixed(2).replace(".", ",") + "</b>" + discountMessage +" por " + ft +".");

                }

                $('#monthly').click(function () {

                    plan = 1;
                    totalAbstract(plan);

                    $('#content-annual').css('background', '#fff');
                    $('#content-semiannual').css('background', '#fff');
                    $('#content-monthly').css('background', '#ffffbb');

                    $('#monthly').attr('disabled', 'disabled');
                    $('#semiannual').removeAttr('disabled');
                    $('#annual').removeAttr('disabled');

                });

                $('#semiannual').click(function () {

                    plan = 6;
                    totalAbstract(plan);

                    $('#content-annual').css('background', '#fff');
                    $('#content-semiannual').css('background', '#ffffbb');
                    $('#content-monthly').css('background', '#fff');

                    $('#semiannual').attr('disabled', 'disabled');
                    $('#monthly').removeAttr('disabled');
                    $('#annual').removeAttr('disabled');
                });

                $('#annual').click(function () {

                    plan = 12;
                    totalAbstract(plan);

                    $('#content-annual').css('background', '#ffffbb');
                    $('#content-semiannual').css('background', '#fff');
                    $('#content-monthly').css('background', '#fff');

                    $('#annual').attr('disabled', 'disabled');
                    $('#semiannual').removeAttr('disabled');
                    $('#monthly').removeAttr('disabled');
                });

                var timeout;

                $('#coupon').keyup(function () {

                    clearTimeout(timeout);

                    timeout = setTimeout(function() {
                        $.ajax('/huxley/payment/checkCoupon', {
                            data: JSON.stringify({coupon:  $('#coupon').val()}),
                            type: 'POST',
                            dataType: 'json',
                            contentType: 'application/json',
                            beforeSend: function () {
                                discount = 0;
                                $('#coupon-discount').empty().html('Processando...');
                            },
                            success: function (data) {
                                if (data.status === "VALID") {
                                    $('#coupon-discount').empty().html('Seu desconto é de ' + data.discount + "%.")
                                    discount = data.discount;
                                } else if (data.status === "USED") {
                                    $('#coupon-discount').empty().html('Cupom já utilizado.');
                                    discount = 0;
                                } else {
                                    $('#coupon-discount').empty().html('Cupom não encontrado.');
                                    discount = 0;
                                }

                                totalAbstract(plan);

                            },
                            error: function (xhr, ajaxOptions, thrownError) {
                                if (xhr.status == 404) {
                                    $('#coupon-discount').empty().html('Cupom não encontrado.');
                                } else {
                                    $('#coupon-discount').empty().html('Desculpe, ocorreu um erro, tente novamente mais tarde.')
                                }
                            }
                        });
                    }, 2000);


                });


            });
        </script>
    </head>
    <body>
        <div class="box">

            <div style="font-weight: bold; font-size: 32px;">Pacote educacional</div><br/>
            <div style="color: #808080; font-size: 12px; margin-bottom: 60px;">Este pacote libera uma série de funcionalidades que permitirão a você, professor, gerenciar suas
            turmas, criar questionários, dentre outras funcionalidades importantes.</div>
            <hr/>
            <div style="font-weight: bold; font-size: 28px;">Escolha o seu plano:</div> <br/><br/>
            <div><label class="students" for="students">Quantos alunos deseja gerenciar: </label><input type="text" id="students" name="students"></div>
            <div style="color: #808080; font-size: 12px; margin-bottom: 30px;">O pacote permite que você gerencie um certo número de alunos. Não importa quantas turmas você tem,
            desde que somados, o número de alunos não ultrapasse o total que você está comprando</div>
            <div style="text-align: center; margin-bottom: 15px;">
                <div class="plan">
                    <div class="plan-title">Plano Mensal</div>
                    <div class="plan-content" id="content-monthly">
                        <div class="price"><span class="currency">R$</span>11,<span class="cents">60</span></div>
                        <div class="byuser">mensais por usuário</div>
                        <div class="total">R$ <span id="total-month">0,00</span> por mês</div>
                        <div class="buttons">
                            <button id="monthly" class="btn btn-success">Selecionar</button>
                        </div>
                    </div>
                </div>
                <div class="plan">
                    <div class="plan-title"><span>Plano Semestral</span></div>
                    <div class="plan-content" id="content-semiannual">
                        <div class="price"><span class="currency">R$</span>10,<span class="cents">80</span></div>
                        <div class="byuser">mensais por usuário</div>
                        <div class="total">R$ <span id="total-semester">0,00</span> por semestre</div>
                        <div id="save-semester" class="save"></div>
                        <div class="buttons">
                            <button id="semiannual" class="btn btn-success">Selecionar</button>
                        </div>
                    </div>
                </div>
                <div class="plan">
                    <div class="plan-title"><span>Plano Anual</span></div>
                    <div class="plan-content" id="content-annual">
                        <div class="price"><span class="currency">R$</span>9,<span class="cents">90</span></div>
                        <div class="byuser">mensais por usuário</div>
                        <div class="total">R$ <span id="total-year">0,00</span> por ano</div>
                        <div id="save-year" class="save"></div>
                        <div class="buttons">
                            <button id="annual" class="btn btn-success">Selecionar</button>
                        </div>
                    </div>
                </div>
                <div style="clear: both;"></div>
            </div>
            <div>
                <label class="cupon" for="coupon">Cupom de desconto: </label><input type="text" name="coupon" id="coupon" />&nbsp;<span id="coupon-discount" class="coupon-discount"></span>
            </div>
            <hr />
            <div style="clear: both;"></div>
            <div style="font-weight: bold; font-size: 16px;">Forma de pagamento:</div> <br/><br/>
            <input type="radio" checked="true">  <img src="http://imgmp.mlstatic.com/org-img/MLB/MP/BANNERS/tipo2_468X60.jpg" alt="MercadoPago - Meios de pagamento" title="MercadoPago - Meios de pagamento" width="468" height="60"/>
            <hr/>
            <div style="text-align: center;">
            <div id="abstract"></div>
            <button id="continue" class="btn btn-large btn-primary">Continuar</button>
            <div id="error" class="error"></div>
            </div>
        </div>
        </div>
    </body>
</html>
