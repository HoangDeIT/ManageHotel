<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Login Page</title>
                <link rel="stylesheet" href="/css/styleLogin.css">

                <link rel="stylesheet" type="text/css"
                    href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
            </head>

            <body>
                <div class="glass-container" style="height: 500px !important;">
                    <div class="login-box">
                        <h2>Register</h2>
                        <form:form action="/register" method="POST" modelAttribute="registerDTO">

                            <form:input path="fullName" placeholder="Full Name" required="true" />
                            <form:input path="phoneNumber" placeholder="Phone Number" required="true" />
                            <form:password path="password" placeholder="Password" required="true" />
                            <form:password path="confirmPassword" placeholder="Confirm Password" required="true" />
                            <form:input type="date" path="birthDate" placeholder="Birth Date" required="true" />

                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit">Register</button>

                            <p>Already have an account? <a href="/login" id="register">Login</a></p>
                        </form:form>
                    </div>
                </div>
            </body>
            <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
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