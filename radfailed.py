#!/usr/bin/python
import boto3
client = boto3.client('batch')
response=client.list_jobs(
   jobQueue='spot40C',
   jobStatus='FAILED',
   maxResults=100
)
for item in response['jobSummaryList']:
   print item['jobName']

while 'nextToken' in response.keys():
   response=client.list_jobs(
      jobQueue='spot40C',
      jobStatus='FAILED',
      maxResults=100,
      nextToken=response['nextToken']
   )
   for item in response['jobSummaryList']:
      print item['jobName']
