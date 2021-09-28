'use strict';

const { handler } = require("./create_metric")
const AWS = require('aws-sdk');
const fs = require('fs');

jest.mock("aws-sdk", () => {
  const mockDynamoDb = {
      putItem: jest.fn().mockReturnThis(),
      promise: jest.fn(),
  };
  const mockS3 = {
    putObject: jest.fn().mockReturnThis(),
    promise: jest.fn(),
  };
  return {
      __esModule: true,
      DynamoDB: jest.fn(() => mockDynamoDb),
      S3: jest.fn(() => mockS3),
  };
});


describe("handler", () => {
  let client
  let s3Client

  beforeAll(async (done) => {
    client = new AWS.DynamoDB();
    s3Client = new AWS.S3();
    jest.spyOn(console, 'error').mockImplementation(jest.fn());
    done();
   });

  it("returns a 500 error code if the putItem fails", async () => {
    client.promise = jest.fn(async () => {throw "Error"})

    const event = {body: ""}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 500,
      body: JSON.stringify({ "status" : "UPLOAD FAILED" })
    })
  })

  it("returns a 500 error code if the putObject fails", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.BUCKET_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 1;

    s3Client.promise = jest.fn(async () => {throw "Error"})

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_small.json', 'utf8'))}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 500,
      body: JSON.stringify({ "status" : "UPLOAD FAILED" })
    })
  })

  it("returns a 500 error code if the putItem fails when processing split payloads", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 50;

    client.promise = jest.fn(async () => {throw "Error"})

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_large.json', 'utf8'))}

    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 500,
      body: JSON.stringify({ "status" : "UPLOAD FAILED" })
    })
  })

  it("returns a 200 error code if large single payload can't be split", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 50;
    process.env.BUCKET_NAME = "bar"

    client.promise = jest.fn(async () => {throw "Error"})
    s3Client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_large_single.json', 'utf8'))}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD DROPPED" })
    })
  })

  it("returns a 200 error code if payload array has one element and can't be split", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 10;

    client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_small.json', 'utf8'))}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD DROPPED" })
    })
  })

  it("returns a 200 code if the putItem succeeds", async () => {
    client.promise = jest.fn(async () => true)

    const event = {body: ""}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD CREATED" })
    })
  })

  it("returns a 200 code if the putObject succeeds", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 1;
    process.env.BUCKET_NAME = "bar"

    s3Client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_small.json', 'utf8'))}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD DROPPED" })
    })
  })

  it("saves the event body with a random UUID and a TTL", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 307200;

    client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_small.json', 'utf8'))}
    const response = await handler(event)

    expect(client.putItem).toHaveBeenCalledWith(expect.objectContaining({
      TableName: process.env.TABLE_NAME,
      Item: {
        expdate: {N: expect.any(String)},
        raw: {S: event.body},
        uuid: {S: expect.any(String)},
      }
    }))

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD CREATED" })
    })

    delete process.env.TABLE_NAME
    delete process.env.SPLIT_THRESHOLD
  })

  it("writes the event body to S3 if it's too large with random UUID as the key", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 1;
    process.env.BUCKET_NAME = "bar"

    s3Client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_small.json', 'utf8'))}
    const response = await handler(event)

    expect(s3Client.putObject).toHaveBeenCalledWith(expect.objectContaining({
      Bucket: process.env.BUCKET_NAME,
      Key: expect.any(String),
      Body:  JSON.stringify(event.body)
    }))

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD DROPPED" })
    })

    delete process.env.TABLE_NAME
    delete process.env.SPLIT_THRESHOLD
    delete process.env.BUCKET_NAME
  })

  it("saves large event body successfully after splitting", async () => {
    
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 307200;

    client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_gigantic.json', 'utf8'))}
    const response = await handler(event)

    expect(client.putItem).toHaveBeenCalledTimes(32)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD CREATED" })
    })

    delete process.env.TABLE_NAME
    delete process.env.SPLIT_THRESHOLD
  })

  it("saves large event body successfully after splitting in half", async () => {
    
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 1000;

    client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_large.json', 'utf8'))}
    const response = await handler(event)

    expect(client.putItem).toHaveBeenCalledTimes(2)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD CREATED" })
    })

    delete process.env.TABLE_NAME
    delete process.env.SPLIT_THRESHOLD
  })

  it("does not split if file is below split threshold", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 307200;

    client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_large.json', 'utf8'))}
    const response = await handler(event)

    expect(client.putItem).toHaveBeenCalledTimes(1)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 200,
      body: JSON.stringify({ "status" : "RECORD CREATED" })
    })

    delete process.env.TABLE_NAME
    delete process.env.SPLIT_THRESHOLD
  })
})

