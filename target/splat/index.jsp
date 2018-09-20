<%@page import="com.tyrsa.JSONTree"%>
<%@page import="com.tyrsa.TreeRoot"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <script>
        function openFolder(){
            var selected = document.getElementsByClassName("selected");
            var text = null
            if(selected.length != 0){
                text = selected[0].getElementsByTagName("div")[0].innerText;
                var form = document.getElementById("folder_form");
                document.getElementById('folder_name').value = text;
                form.submit();
            }
            else{
                alert("Вы не выбрали папку");
            }
        }
    </script>
    <script>

        function add(div) {
            var img = div.getElementsByTagName("img")
            if(img[0].id === "folder"){
                img[0].src = "/img/folder_selected.png"
            }
            else {
                img[0].src = "/img/docs_selected.png"
            }
        }
        function remove(div) {
            var tmp = div.getElementsByTagName('img')
            if(tmp[0].id === "folder"){
                tmp[0].src = "/img/folder.png"
            }
            else {
                tmp[0].src = "/img/docs.png"
            }
        }
        var clickHandler = function(e){
            var p = e.target;
            while (p != null && !p.classList.contains("panel-body")){
                p = p.parentElement;
            }
            var selected = document.getElementsByClassName("selected");
            for (var i = 0; i < selected.length; i++){
                remove(selected[i])
                selected[i].classList.remove("selected");
            }
            p.classList.add("selected");
            add(p)

        };
        window.addEventListener("keypress", function (e) {
            var key = e.which || e.keyCode;
            if (key === 13) { // Нажатие Enter
                document.getElementsByClassName("selected")[0].dispatchEvent(new MouseEvent('dblclick', {
                    'view': window,
                    'bubbles': true,
                    'cancelable': true
                }));
            }
        })
        window.addEventListener("dblclick",function(e){
            e.preventDefault();
            openFolder();
        })
        window.addEventListener("keydown",function(e){
            if(e.code === "ArrowDown" || e.code === "ArrowUp"){
                //e.preventDefault();
                var selected = document.getElementsByClassName("selected");
                var doc = document.getElementById("file-list");
                if(selected != null && selected.length !== 0 ){
                    var array = doc.getElementsByClassName("panel");
                    var i;
                    var found = false;
                    for(i = 0; i < array.length; i++){
                        var elem = array[i].getElementsByClassName("selected");
                        if(elem.length != 0){
                            found = true;
                            break;
                        }
                    }
                    if(found){
                        if(e.code === "ArrowDown" && i != (array.length - 1)){
                            var elem = array[i].getElementsByClassName("selected");
                            remove(elem[0])
                            elem[0].classList.remove("selected")
                            var div = array[i+1].getElementsByClassName("panel-body")[0]
                            add(div)
                            div.classList.add("selected")
                        }
                        else if(e.code === "ArrowUp" && i != 0){
                            var elem = array[i].getElementsByClassName("selected");
                            remove(elem[0])
                            elem[0].classList.remove("selected")
                            var div = array[i-1].getElementsByClassName("panel-body")[0]
                            add(div)
                            div.classList.add("selected")
                        }
                    }
                }
                else {
                    console.log("here")
                    var div = document.getElementsByClassName("panel-body")[0]
                    add(div)
                    div.classList.add("selected")
                }
            }
        })
    </script>

    <br/>
    <div class="file-list" id="file-list"></div>
        <script>
            var list = document.getElementById("file-list");
            list.innerHTML = ""
            function printTree(text, dir) {
                var panelDiv = document.createElement("div");
                panelDiv.classList.add("panel");
                var panelBody = document.createElement("div");
                panelBody.classList.add("panel-body");
                var p = document.createElement("div");
                p.setAttribute("style", "font-weight: bold");
                p.innerText = text;
                panelBody.onclick = clickHandler;

                var img = document.createElement("img");
                if(dir === "true"){
                    img.setAttribute("src","/img/folder.png");
                    img.id = 'folder'
                }
                else{
                    img.setAttribute("src","/img/docs.png");
                    img.id = 'file'
                }
                panelBody.appendChild(img);
                panelBody.appendChild(p);
                panelDiv.appendChild(panelBody);
                list.appendChild(panelDiv);
            }
        </script>
    <%
        JSONTree[] tree = (JSONTree[]) request.getAttribute("message");
        if(tree == null){
            tree = TreeRoot.getRoot();
        }
        if(tree != null && tree.length != 0){
            %><script>
                var list = document.getElementById("file-list");
                list.innerHTML = ""
            </script><%
            for(JSONTree obj : tree) {
                String name = obj.getName();
                boolean isDir = obj.isDirectory();
                %><script>printTree("<%=name%>", "<%=isDir%>")</script><%
            }
        }
    %>





    <form id="folder_form" action="/tree_action" method="post">
        <input type="hidden" id="folder_name" name="folder_name"/>
    </form>


    <br><br><br><br><br>
    <form id="button_form" action="/tree_action" method="post">
        Имя для добавления/редактирования<br>
        <input type="text" name="name_field"><br>
        <input type="radio" name="file_type" value="directory">Каталог<br>
        <input type="radio" name="file_type" value="file">Файл<br>
        <button type="submit" name="button" value="add_button">Добавить элемент</button>
        <button type="submit" name="button" value="edit_button">Изменить элемент</button>
        <button type="submit" name="button" value="remove_buton">Удалить элемент</button>
    </form>
</body>
</html>