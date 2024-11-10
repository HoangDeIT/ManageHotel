<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login Page</title>
            <link rel="stylesheet" href="/css/styleLogin.css">
            <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
            <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        </head>

        <body>
            <div class="glass-container">
                <div class="login-box">
                    <h2>Login</h2>
                    <form action="/login" method="POST">

                        <input type="text" id="username" name="username" required placeholder="Username">

                        <input type="password" id="password" name="password" required placeholder="Password">


                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit">Login</button>

                        <p>Don't have an account? <a href="/register" id="register">Register</a></p>
                    </form>
                </div>
            </div>
        </body>
        <script>
            function handleErrorFromQueryString() {
                const urlParams = new URLSearchParams(window.location.search);
                const error = urlParams.get('error'); // Lấy giá trị từ query string "error"
                const logout = urlParams.get('logout');
                // Nếu có lỗi, hiển thị thông báo bằng Toastify
                if (urlParams.has("error")) {
                    Toastify({
                        text: `Lỗi: Tài khoản chưa được duyệt hoặc do tài khoản không hợp lệ`,
                        className: "info",
                        duration: 3000,
                        close: true,
                        gravity: "top",
                        position: "right",
                        style: {
                            background: "linear-gradient(to right, #ff5f6d, #ffc3a0)" // Màu nền lỗi
                        }
                    }).showToast();
                }
                if (urlParams.has("logout")) {
                    Toastify({
                        text: `Đăng xuất thành công`,
                        className: "info",
                        duration: 3000,
                        close: true,
                        gravity: "top",
                        position: "right",
                        style: {
                            background: "linear-gradient(to right, #ff5f6d, #ffc3a0)" // Màu nền lỗi
                        }
                    }).showToast();
                }
            }


            handleErrorFromQueryString();
        </script>
        <c:if test="${not empty status}">
            <script>
                Toastify({
                    text: "${ status }",
                    className: "info",
                    duration: 3000,
                    close: true,
                    gravity: "top", // `top` or `bottom`
                    position: "right",
                    style: {
                        background: "linear-gradient(to right, #00b09b, #96c93d)"
                    }
                }).showToast();
            </script>
        </c:if>

        </html>