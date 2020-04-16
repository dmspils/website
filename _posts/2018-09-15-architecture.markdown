---
title:  "site architecture and construction"
date:   2018-09-15 20:15
categories: []
tags: [CSP, architecture, CAA, SRI, DNSSEC, lambda]
---
This site is now in v3. v1 was EC2 hosted in AWS and served via nginx because that was the only way that I could serve Content Security Policy (CSP) headers. Using a CDN, Cloudfront or Cloudflare, meant that my headers would be stripped which was not cool.

However, [@swewing][swewing] put me on to Lambda@Edge, which is a way of serving JS from Cloudfront, and is something which I have now used to serve my CSP headers; the code can be seen on [GitHub][git]. I therefore removed the use of EC2/nginx and serve directly from S3 via Cloudfront which took the site to v2.

v3 came along a little after that with a move from my previous site generator, Mobirise, to Jekyll. Nothing architecturally changed, it's still hosted in S3 and served by Cloudfront with Lambda@Edge, but v3 is better integrated and is served via CI/CD, meaning that I can make more frequent updates without going through the pain I had to previously.

One of the main reasons that I maintain this site is to play with some of the cool security related technologies out there that I wanted to implement and test via this site, for example:

- [Content Security Policy (CSP)][csp]: tells your browser the locations that it's allowed to load resources from.
- HTTP Strict Transport Security (HSTS): tells your browser that http is not allowed and this site may only be loaded over https. It's not one of my favourite tools as it's really faffy. I've enabled the header but set it to a really low max-age.
- DNS Certification Authority Authorization (CAA) records: instead of HPKP, I'm using CAA records which are set via my DNS provider, GCP. The records I have set are for AWS Cloudfront only, with any request to generate a cert via any other CA being rejected (blog post to come on this later given some interesting stuff I found with Cloudflare).
- Subresource Integrity (SRI): for all the JavaScript assets associated with this page, their hashes are built into my html so that your browser knows they've not been modified in transit
- Domain Name System Security Extensions (DNSSEC): if you have enabled DNSSEC validation on your network, you can be sure that you're actually browsing my site and not an imposters
- Networking: dual stack IPv4 and IPv6 hosting: this site is IPv6 enabled so, if you're on an IPv6 network, you will be pulling these pages properly!

[swewing]: https://twitter.com/swewing
[git]: https://github.com/dmspils/Lambda-Edge-Content-Security-Policy
[csp]: https://scotthelme.co.uk/content-security-policy-an-introduction/
