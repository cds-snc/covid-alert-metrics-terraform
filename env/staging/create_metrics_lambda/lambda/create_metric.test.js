'use strict';

const { handler } = require("./create_metric")
const AWS = require('aws-sdk');
const fs = require('fs');

jest.mock("aws-sdk", () => {
  const mockDynamoDb = {
      putItem: jest.fn().mockReturnThis(),
      promise: jest.fn(),
  };
  return {
      __esModule: true,
      DynamoDB: jest.fn(() => mockDynamoDb),
  };
});


describe("handler", () => {
  let client

  beforeAll(async (done) => {
    client = new AWS.DynamoDB();
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

  it("returns a 500 error code if large single payload can't be split", async () => {
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 50;

    client.promise = jest.fn(async () => {throw "Error"})

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_large_single.json', 'utf8'))}
    const response = await handler(event)

    expect(response).toStrictEqual({
      isBase64Encoded: false,
      statusCode: 500,
      body: JSON.stringify({ "status" : "UPLOAD FAILED" })
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
        raw: {S: JSON.stringify(event.body)},
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

  it("saves large event body successfully after splitting", async () => {
    
    process.env.TABLE_NAME = "foo"
    process.env.SPLIT_THRESHOLD = 100;

    client.promise = jest.fn(async () => true)

    const event = {body: JSON.parse(fs.readFileSync('test_files/test_payload_large.json', 'utf8'))}
    const response = await handler(event)

    expect(client.putItem).toHaveBeenCalledTimes(4)

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
    process.env.SPLIT_THRESHOLD = 200;

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

