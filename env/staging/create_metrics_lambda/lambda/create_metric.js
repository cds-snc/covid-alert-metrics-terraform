'use strict';

const
    AWS = require('aws-sdk'),
    dynamodb = new AWS.DynamoDB(),
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

    const eventBody = event.body;
    
    try {
        // The maximum item size in DynamoDB is 400 KB
        const payloadLength = new TextEncoder().encode(event.body.payload).length;
        if (payloadLength > process.env.SPLIT_THRESHOLD){
            console.info(`Large payload being split; size: ${payloadLength}`);

            if(!Array.isArray(event.body.payload) || event.body.payload.length === 1){
                console.error(`Upload failed, unable to split large payload: ${payloadLength} > ${process.env.SPLIT_THRESHOLD}`);
                transactionStatus.statusCode = 200;
                transactionStatus.body= JSON.stringify({ "status" : "RECORD DROPPED" }); 
                return transactionStatus;
            }
            const results = splitPayload(event.body.payload);

            results.forEach((result) => {
                eventBody.payload = result;
                writePayload(eventBody, ttl);
            });
        }else{
            await writePayload(event.body, ttl);
        }
        transactionStatus.statusCode = 200;
        transactionStatus.body = JSON.stringify({ "status": "RECORD CREATED" });
    } catch (err) {
        console.error(`Upload failed ${err}`);
        transactionStatus.statusCode = 500;
        transactionStatus.body= JSON.stringify({ "status" : "UPLOAD FAILED" });
    }

    return transactionStatus;
};

// Recursively splits the payload in half until all chunks are below the limit
const splitPayload = (payload) => {
  const results = [];
  let chunk_size = payload.length;
  while (true) {
    let left = payload.slice(0, chunk_size);
    if (new TextEncoder().encode(left).length < process.env.SPLIT_THRESHOLD) {
     break;
    }
  
    chunk_size /= 2;
    // Can't go smaller then a single element chunk
    if (chunk_size <= 1) {
      break;
    }
  }
  
  for (let i = 0; i < payload.length; i += chunk_size) {
    results.push(payload.slice(i, i + chunk_size));
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
              S: JSON.stringify(payload),
          },
      },
  };
  
  await dynamodb.putItem(params).promise();
};
