function ejecutar() {
    if (!editor4D.getValue()) {
        alert("NO HAY NADA PARA ANALIZAR");
        return;
    }
    var result = gramatica.parse(editor4D.getValue());
    document.getElementById("consolaArea").value = result;
}