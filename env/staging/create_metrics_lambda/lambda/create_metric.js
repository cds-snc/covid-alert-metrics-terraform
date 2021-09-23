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
                transactionStatus.statusCode = 500;
                transactionStatus.body= JSON.stringify({ "status" : "UPLOAD FAILED" }); 
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
  let results = [];
  
  const middle = payload.length / 2; // if it's odd, it'll round down
  const left = payload.slice(0, middle);
  const right = payload.slice(middle, payload.length);
  
  if (new TextEncoder().encode(left).length > process.env.SPLIT_THRESHOLD){
      results = results.concat(splitPayload(left));
      results = results.concat(splitPayload(right));
      return results;
  }else{
      results.push(left);
      results.push(right);
      return results;
  }
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
