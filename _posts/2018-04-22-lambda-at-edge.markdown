---
title:  "Lambda@Edge"
date:   2018-04-22 20:15
categories: []
tags: []
---
CSP for AWS Cloudfront Lambda@Edge

Pre-reqs:

1. In AWS, set up a static site hosted in an S3 bucket.
2. Set the permissions on the S3 bucket to include a public access policy and Cloudfront Object Access Identity.
3. Set up Cloudfront to serve the content in the S3 bucket.


Config:

1. Goto Lambda and make sure you're in US-East-1
2. Create a new function, make it Node.js.6.10
3. Dump in your CSP.js, configured to do what you want. Note: start small and build your policy gradually.
4. Save your code.
5. Publish your code and make a note of the ARN (including version number).
6. Select Cloudfront as a trigger, select Origin-Response, select the distribution that you're going to use, hit the checkbox to say that you are ok with this, hit add and then go back to the top and hit save.
7. Wait for the distribution to redeploy.
8. Consider invalidating your origin objects if you're impatient!
9. Goto Mozilla Observatory [Mozilla Observatory][mozilla] and test your policy.


[mozilla]: https://observatory.mozilla.org/
