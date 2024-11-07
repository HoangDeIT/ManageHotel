<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link rel="stylesheet" href="/css/styleLogin.css">
</head>

<body>
    <div class="glass-container">
        <div class="login-box">
            <h2>Login</h2>
            <form action="/login" method="POST">

                <input type="text" id="username" name="username" required placeholder="Username">

                <input type="password" id="password" name="password" required placeholder="Password">

                <div class="options">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Remember me</label>
                    <a href="#">Forgot Password?</a>
                </div>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit">Login</button>

                <p>Don't have an account? <a href="#" id="register">Register</a></p>
            </form>
        </div>
    </div>
</body>

</html>