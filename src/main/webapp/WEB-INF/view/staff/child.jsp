<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout"
    layout:decorate="show.html">

<head>
    <title>My App - Child</title>
</head>

<body>
    <main layout:fragment="content">
        <h2>Welcome to the Child Page</h2>
        <p>This is the cosntádent of the sadasdchild page.</p>
        <p th:text="${message}"></p> <!-- Hiển thị dữ liệu -->
    </main>
</body>

</html>