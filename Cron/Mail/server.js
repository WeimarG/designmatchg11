const nodemailer = require('nodemailer');

var mail = process.argv.slice(2);

console.log(mail + "hola")



if(mail[0] != "email" ){

let mailTransporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true, // true for 465, false for other ports
    auth: {
        user: 'designmatchg11@gmail.com',
        pass: 'Grupo11cloud'
    },
    tls: {
        rejectUnauthorized: false
    }
});

let mailDetails = {
    from: 'designmatchg11@gmail.com',
    to: 'alejandrasabogal91@gmail.com',
    subject: 'Test mail',
    text: 'Node.js testing mail for GeeksforGeeks'
};

console.log("Antes de enviarlo")

console.log(mailDetails)

mailTransporter.sendMail(mailDetails, function (err, data) {

console.log("callback")
    if (err) {
        console.log('Error Occurs');
        console.log(err);
    } else {
        console.log('Email sent successfully');
    }
});


}



