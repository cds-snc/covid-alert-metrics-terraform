'use strict';

const
    AWS = require('aws-sdk'),
    dynamodb = new AWS.DynamoDB(),
    s3 = new AWS.S3(),
    crypto = require('crypto');
    
const uuidv4 = () => {
    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
        (c ^ crypto.randomFillSync(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
    );
}


exports.handler = async (event, context) => {

    const transactionStatus = {
        isBase64Encoded:  false
    };

    // expire after 24 hours
    const ttl = (Math.floor(Date.now()/1000) + 86400).toString();

    try {
        // The maximum item size in DynamoDB is 400 KB
        const payloadLength = new TextEncoder().encode(event.body).length;
        if (payloadLength > process.env.SPLIT_THRESHOLD){
            const parsedBody = JSON.parse(event.body);
            console.info(`Large payload being split; size: ${payloadLength}`);

            if(!Array.isArray(parsedBody.payload) || parsedBody.payload.length === 1){
                const key = uuidv4();
                console.error(`${key} - Upload failed, unable to split large payload: ${payloadLength} > ${process.env.SPLIT_THRESHOLD}`);
                console.info(`${key} - Payload type: ${typeof parsedBody.payload}`);
                console.info(`${key} - Payload isArray: ${Array.isArray(parsedBody.payload)}`);

                if (parsedBody.payload) {
                  console.info(`${key} - Payload length: ${parsedBody.payload.length}`);
                }
                await saveSample(event.body, key);
                transactionStatus.statusCode = 200;
                transactionStatus.body= JSON.stringify({ "status" : "RECORD DROPPED" }); 
                return transactionStatus;
            }
            const results = splitPayload(parsedBody);

            for(const result of results){
                let eventBody = {
                    ...parsedBody
                };
                eventBody.payload = result;
                await writePayload(JSON.stringify(eventBody), ttl);
            };
        }else{
            await writePayload(event.body, ttl);
        }
        transactionStatus.statusCode = 200;
        transactionStatus.body = JSON.stringify({ "status": "RECORD CREATED" });
    } catch (err) {
        console.error(`Upload failed ${err}`);
        transactionStatus.statusCode = 500;
        transactionStatus.body = JSON.stringify({ "status" : "UPLOAD FAILED" });
    }

    return transactionStatus;
};

// Splits the payload in half until all chunks are below the limit
const splitPayload = (body) => {
  const results = [];
  const eventBody = {
    ...body
  };
  let chunk_size = body.payload.length;
  while (true) {
    let left = body.payload.slice(0, chunk_size);
    
    //Include the rest of the body when calculating new split payload length
    eventBody.payload = left;
    if (new TextEncoder().encode(JSON.stringify(eventBody)).length < process.env.SPLIT_THRESHOLD) {
     break;
    }
  
    chunk_size /= 2;
    // Can't go smaller then a single element chunk
    if (chunk_size <= 1) {
      chunk_size = 1;
      break;
    }
  }

  for (let i = 0; i < body.payload.length; i += chunk_size) {
    results.push(body.payload.slice(i, i + chunk_size));
  }
  return results;
};

const  writePayload = async (payload, ttl) => {
  const params = {
      TableName: process.env.TABLE_NAME,
      Item : {
          "uuid": {
              S: uuidv4(),
          },
          "expdate" : {
              N: ttl,
          },
          "raw": {
              S: payload,
          },
      },
  };
  
  return dynamodb.putItem(params).promise();
};

const  saveSample = async (data, key) => {
  var params = {
      Bucket : process.env.BUCKET_NAME,
      Key : key,
      Body : data
  }

  return s3.putObject(params).promise(); 
};