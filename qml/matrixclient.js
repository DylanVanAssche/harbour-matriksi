var matrix;

function Matrix() {
}

Matrix.prototype.login_with_passwords = function (username, password) {
    client.call('client.MatrixClient', [username, password], function (result) {
        console.log(result)
    });
}
