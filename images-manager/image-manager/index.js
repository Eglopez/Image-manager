const fs = require('fs');
const AWS = require('aws-sdk');
const s3 = new AWS.S3({
    accessKeyId: '',
    secretAccessKey: ''
});


exports.handler = async(event) => {
    console.log("Hello World");


    const uploadFile = (imageName) => {

        const fileContent = fs.readFileSync(imageName);


        const params = {
            Bucket: BUCKET_NAME,
            Key: `${imageName}.jpg`,
            Body: fileContent
        };

        s3.upload(params, function(err, data) {
            if (err) {
                throw err;
            }
            console.log(`File uploaded successfully. ${data.Location}`);
        });
    };

};