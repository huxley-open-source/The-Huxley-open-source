/*global $*/

$(function () {
	'use strict';

	$.ajax('/huxley/topCoder/getTopCoders', {
		data: {limit: 10},
		dataType: 'json',
		success: function (data) {
			var template = Handlebars.compile($("#topcoder-box").html());
			$.each(data, function(i, user) {
				$("#topcoder ul.topcoder").prepend(template(user));
			});

			$("ul.topcoder li:last-child .userbox").addClass("show");

			$('div.userbox').click(function () {
				$('div.userbox.show').removeClass('show');
				$(this).addClass('show');
			});
		}
	});



	$('ul.hero-carousel > li:first-child').addClass("show");
	$('ul.hero-carousel-thumbs > li:first-child').addClass("show");
	window.setInterval(function () {
		$('ul.hero-carousel > li.show').next().length !== 0 ? $('ul.hero-carousel > li.show').removeClass("show").next().addClass("show") : $('ul.hero-carousel > li.show').removeClass("show").parent().find('li:first-child').addClass("show")
		$('ul.hero-carousel-thumbs > li.show').next().length !== 0 ? $('ul.hero-carousel-thumbs > li.show').removeClass("show").next().addClass("show") : $('ul.hero-carousel-thumbs > li.show').removeClass("show").parent().find('li:first-child').addClass("show")
	}, 8000);

	$('div.hero-carousel-news > p:first-child').addClass("show");
	window.setInterval(function () {
		$('div.hero-carousel-news > p.show').next().length !== 0 ? $('div.hero-carousel-news > p.show').removeClass("show").next().addClass("show") : $('div.hero-carousel-news > p.show').removeClass("show").parent().find('p:first-child').addClass("show")
	}, 4000);


	var changeForm = function () {
		if($('input[name=roleOptions]:checked').val() == "teacher") {
			$('#teacher-form').removeClass("hidden");
			$('#student-form').addClass("hidden");
			$('.input-status').addClass("hidden");
		} else {
			$('#student-form').removeClass("hidden");
			$('#teacher-form').addClass("hidden");
			$('.input-status').addClass("hidden");
		}
	}

	$("#studentOption").click(changeForm);
	$("#teacherOption").click(changeForm);

	$('#login-button > a').click(function (e) {

		$(this).toggleClass("active");
		e.preventDefault();
		e.stopPropagation();
		$('#login-button > div').toggle(100, function () {
			$(document).one('click', function () {
				$('#login-button > div').hide();
				$('#login-button > a').removeClass("active");
			});
		});

		$('#username').focus();
	});

	$('#student-form input[name="name"]').blur(function () {validateName(this);});
	$('#student-form input[name="email"]').blur(function () {validateEmail(this);});
	$('#student-form input[name="username"]').blur(function () {validateUsername(this);});
	$('#student-form input[name="password"]').blur(function () {validatePassword(this);});
	$('#teacher-form input[name="name"]').blur(function () {validateName(this);});
	$('#teacher-form input[name="email"]').blur(function () {validateEmail(this);});
	$('#teacher-form input[name="username"]').blur(function () {validateUsername(this);});
	$('#teacher-form input[name="password"]').blur(function () {validatePassword(this);});
    $('#teacher-form input[name="institution"]').blur(function () {validateInstitution(this);});

	var institutions = new Bloodhound({
		datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
		queryTokenizer: Bloodhound.tokenizers.whitespace,
		prefetch: '/huxley/1.0/institutions/',
		remote: '/huxley/1.0/institutions?name=%QUERY'
	});

	institutions.initialize();

	$('#teacher-form input[name="institution"]').typeahead(null, {
		name: 'institution',
		displayKey: 'name',
		source: institutions.ttAdapter()
	});

	$('#login-form').click(function(e) {
		e.stopPropagation();
	})

});



var validateEmail = function (el) {
	var isValid = false, email = $(el).val();

	$(el).popover('hide');

	if (email === null || email === "") {
		$(el).attr('data-content', "Não deixe o seu email em branco.");
		$(el).popover();
		$('.input-status-email').addClass("input-status-error").removeClass("hidden");
		return false;
	}

	var atpos = email.indexOf("@");
	var dotpos = email.lastIndexOf(".");
	if (atpos< 1 || dotpos<atpos+2 || dotpos+2>=email.length) {
		$(el).attr('data-content', "Não parece um email válido.");
		$(el).popover();
		$('.input-status-email').addClass("input-status-error").removeClass("hidden");
		return false;
	}

	$.ajax({
		url: '/huxley/auth/validateEmail',
		async: false,
		data: {email: email},
		dataType: 'json',
		success: function(data) {
			if(data.msg.status == 'ok'){
				isValid = true;
			}
		}
	});

	if (!isValid) {
		$(el).attr('data-content', "Email já cadastrado.");
		$('.input-status-email').addClass("input-status-error").removeClass("hidden");
		$(el).popover();
		return false;
	}

	$(el).popover('destroy')
	$('.input-status-email').removeClass("input-status-error").removeClass("hidden");
	return true;
}

var validateName = function (el) {
	var name = $(el).val();
	$(el).popover('hide');
	if (name === null || name === "") {
		$(el).attr('data-content', "Não deixe o seu nome em branco.");
		$(el).popover();
		$('.input-status-name').addClass("input-status-error").removeClass("hidden");
		return false;
	}
	$(el).popover('destroy')
	$('.input-status-name').removeClass("input-status-error").removeClass("hidden");
	return true;
}

var validateInstitution = function (el) {
    var name = $(el).val();
    $(el).popover('hide');
    if (name === null || name === "") {
        $(el).attr('data-content', "Não deixe o nome da sua instituição em branco.");
        $(el).popover();
        $('.input-status-institution').addClass("input-status-error").removeClass("hidden");
        return false;
    }
    $(el).popover('destroy')
    $('.input-status-institution').removeClass("input-status-error").removeClass("hidden");
    return true;
}

var validatePassword = function (el) {
	var username = $(el).val();

	$(el).popover('hide');

	if (username === null || username === "" || username.length < 6) {
		$(el).attr('data-content', "Escolha uma senha com mais de 6 caracteres.");
		$(el).popover();
		$('.input-status-password').addClass("input-status-error").removeClass("hidden");
		return false;
	}

	$(el).popover('destroy')

	$('.input-status-password').removeClass("input-status-error").removeClass("hidden");
	return true;
}

var validateUsername = function (el) {
	var isValid, username = $(el).val();
	isValid = false;

	$(el).popover('hide');

	if (username === null || username === "" || username.length < 5) {
		$(el).attr('data-content', "Escolha um login com mais de 5 caracteres.");
		$(el).popover();
		$('.input-status-login').addClass("input-status-error").removeClass("hidden");
		return false;
	}

	$.ajax({
		url: '/huxley/auth/validateUsername',
		async: false,
		data:'username='+ username,
		dataType: 'json',
		success: function(data) {
			if(data.msg.status == 'ok'){
				isValid = true;
			}
		}
	});

	if (!isValid) {
		$(el).attr('data-content', "login já cadastrado.");
		$('.input-status-login').addClass("input-status-error").removeClass("hidden");
		$(el).popover();
		return false;
	}

	$(el).popover('destroy')
	$('.input-status-login').removeClass("input-status-error").removeClass("hidden");
	return true;
}

function validateStudentForm() {

	$('#student-form input[name="repeatEmail"]').val($('#student-form input[name="email"]').val());
	$('#student-form input[name="repeatPassword"]').val($('#student-form input[name="password"]').val());

	return(validateName($('#student-form input[name="name"]'))
			&& validateEmail($('#student-form input[name="email"]'))
			&& validateUsername($('#student-form input[name="username"]'))
			&& validatePassword($('#student-form input[name="password"]')));
}

function validateTeacherForm() {

	$('#teacher-form input[name="repeatEmail"]').val($('#teacher-form input[name="email"]').val());
	$('#teacher-form input[name="repeatPassword"]').val($('#teacher-form input[name="password"]').val());

	return(validateName($('#teacher-form input[name="name"]'))
		&& validateEmail($('#teacher-form input[name="email"]'))
		&& validateUsername($('#teacher-form input[name="username"]'))
		&& validatePassword($('#teacher-form input[name="password"]')))
        && validateInstitution($('#teacher-form input[name="institution"]'));
}

