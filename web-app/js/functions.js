function notihide() {
	document.getElementById("hide").style.display = "none";
}

function deschide() {
	if (document.getElementById('deschide').style.display == "none") {
		document.getElementById('deschide').style.display = "";
	}
	
	else if (document.getElementById('deschide').style.display == "") {
		document.getElementById('deschide').style.display = "none";
	}
}

function pdrop() {
	if (document.getElementById('pdrop').style.display == "none") {
		document.getElementById('pdrop').style.display = "";
		document.getElementById('parrow').className = "arrow-active";
		if (document.getElementById('cdrop').style.display == "") {
			document.getElementById('cdrop').style.display = "none";
			document.getElementById('carrow').className = "arrow";
		}
	} else if (document.getElementById('pdrop').style.display == "") {
		document.getElementById('pdrop').style.display = "none";
		document.getElementById('parrow').className = "arrow";
	}
}

function cdrop() {
	if (document.getElementById('cdrop').style.display == "none") {
		document.getElementById('cdrop').style.display = "";
		document.getElementById('configicon').className = "icon-active";
		document.getElementById('carrow').className = "arrow-active";
		if (document.getElementById('pdrop').style.display == "") {
			document.getElementById('pdrop').style.display = "none";
			document.getElementById('parrow').className = "arrow";
		}
	} else if (document.getElementById('cdrop').style.display == "") {
		document.getElementById('cdrop').style.display = "none";
		document.getElementById('configicon').className = "icon";
		document.getElementById('carrow').className = "arrow";
	}
}

function tagguests() {
	document.getElementById('guest-user1').style.display = "";
	document.getElementById('guest-user2').style.display = "";
	document.getElementById('guest-user3').style.display = "";
	document.getElementById('guest-user4').style.display = "";
	document.getElementById('guest-user5').style.display = "";
	document.getElementById('general-user1').style.display = "none";
	document.getElementById('general-user2').style.display = "none";
	document.getElementById('general-user3').style.display = "none";
	document.getElementById('general-user4').style.display = "none";
	document.getElementById('general-user5').style.display = "none";
	document.getElementById('guests').className = "active";
	document.getElementById('general').className = "";
}

function taggeneral() {
	document.getElementById('guest-user1').style.display = "none";
	document.getElementById('guest-user2').style.display = "none";
	document.getElementById('guest-user3').style.display = "none";
	document.getElementById('guest-user4').style.display = "none";
	document.getElementById('guest-user5').style.display = "none";
	document.getElementById('general-user1').style.display = "";
	document.getElementById('general-user2').style.display = "";
	document.getElementById('general-user3').style.display = "";
	document.getElementById('general-user4').style.display = "";
	document.getElementById('general-user5').style.display = "";
	document.getElementById('guests').className = "";
	document.getElementById('general').className = "active";
}

/* INPUT NOME */
function limpa_nome() {
	nome_digitada = document.getElementById('inputnome').value;

	if (nome_digitada == "Nome de usu�rio...") {
		document.getElementById('inputnome').value = "";
	} else {
		document.getElementById('inputnome').value = nome_digitada;
	}
}
function verifica_nome() {
	nome_digitada = document.getElementById('inputnome').value;
        
	if (nome_digitada == "") {
		document.getElementById('inputnome').value = "Nome de usu�rio...";
	} else if ((nome_digitada != "Nome de usu�rio...") && (nome_digitada != "")) {
		document.getElementById('inputnome').value = nome_digitada;
	}
}

/* INPUT SENHA */
function limpa_senha() {
	nome_digitada = document.getElementById('inputsenha').value;

	if (nome_digitada == "Senha...") {
		document.getElementById('inputsenha').type = "password";
		document.getElementById('inputsenha').value = "";
	} else {
		document.getElementById('inputsenha').value = nome_digitada;
	}
}
function verifica_senha() {
	nome_digitada = document.getElementById('inputsenha').value;
        
	if (nome_digitada == "") {
		document.getElementById('inputsenha').type = "text";
		document.getElementById('inputsenha').value = "Senha...";
	} else if ((nome_digitada != "Senha...") && (nome_digitada != "")) {
		document.getElementById('inputsenha').value = nome_digitada;
	}
}

/* INPUT EMAIL */
function limpa_email() {
	nome_digitada = document.getElementById('inputemail').value;

	if (nome_digitada == "Digite o email...") {
		document.getElementById('inputemail').value = "";
	} else {
		document.getElementById('inputemail').value = nome_digitada;
	}
}
function verifica_email() {
	nome_digitada = document.getElementById('inputemail').value;
        
	if (nome_digitada == "") {
		document.getElementById('inputemail').value = "Digite o email...";
	} else if ((nome_digitada != "Digite o email...") && (nome_digitada != "")) {
		document.getElementById('inputemail').value = nome_digitada;
	}
}

/* INPUT CURSO */
function limpa_curso() {
	nome_digitada = document.getElementById('inputcurso').value;

	if (nome_digitada == "Digite o curso...") {
		document.getElementById('inputcurso').value = "";
	} else {
		document.getElementById('inputcurso').value = nome_digitada;
	}
}
function verifica_curso() {
	nome_digitada = document.getElementById('inputcurso').value;

	if (nome_digitada == "") {
		document.getElementById('inputcurso').value = "Digite o curso...";
	} else if ((nome_digitada != "Digite o curso...") && (nome_digitada != "")) {
		document.getElementById('inputcurso').value = nome_digitada;
	}
}

/* INPUT GRUPO */
function limpa_grupo() {
	nome_digitada = document.getElementById('inputgrupo').value;

	if (nome_digitada == "Digite o grupo...") {
		document.getElementById('inputgrupo').value = "";
	} else {
		document.getElementById('inputgrupo').value = nome_digitada;
	}
}
function verifica_grupo() {
	nome_digitada = document.getElementById('inputgrupo').value;

	if (nome_digitada == "") {
		document.getElementById('inputgrupo').value = "Digite o grupo...";
	} else if ((nome_digitada != "Digite o grupo...") && (nome_digitada != "")) {
		document.getElementById('inputgrupo').value = nome_digitada;
	}
}

/* INPUT DATEEND */
function limpa_datafim() {
	nome_digitada = document.getElementById('inputdatafim').value;

	if (nome_digitada == "Data de fim") {
		document.getElementById('inputdatafim').value = "";
	} else {
		document.getElementById('inputdatafim').value = nome_digitada;
	}
}
function verifica_datafim() {
	nome_digitada = document.getElementById('inputdatafim').value;

	if (nome_digitada == "") {
		document.getElementById('inputdatafim').value = "Data de fim";
	} else if ((nome_digitada != "Data de fim") && (nome_digitada != "")) {
		document.getElementById('inputdatafim').value = nome_digitada;
	}
}

/* INPUT QUEST */
function limpa_quest() {
	nome_digitada = document.getElementById('inputquest').value;

	if (nome_digitada == "Digite o t�tulo do question�rio...") {
		document.getElementById('inputquest').value = "";
	} else {
		document.getElementById('inputquest').value = nome_digitada;
	}
}
function verifica_quest() {
	nome_digitada = document.getElementById('inputquest').value;

	if (nome_digitada == "") {
		document.getElementById('inputquest').value = "Digite o t�tulo do question�rio...";
	} else if ((nome_digitada != "Digite o t�tulo do question�rio...") && (nome_digitada != "")) {
		document.getElementById('inputquest').value = nome_digitada;
	}
}