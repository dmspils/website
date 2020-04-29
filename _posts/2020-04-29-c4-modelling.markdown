---
title:  "C4 modelling this website"
date:   2020-04-29 10:00
categories: []
tags: []
---

This site has been around for a few years now and has changed significantly, mainly from an infrastructure perspective, over that time. That can be done as the site gets very few hits so I can use it to test features and experiment without worrying about outages.‌

In a work context, I very much promote the use of [C4 modelling](https://c4model.com/) as a consistent and clear means of expressing a system architecture. C4 modelling struck a chord with me when I first came across it as it takes the best bits from UML and structured systems engineering, which is my background, but allows them to be used in a more agile (with a small 'a') software development context. Consistency is also the key; on a daily basis I review a handful of threat models which have historically been drawn using _any_ drawing method (logical, physical, software based, high level, low level, etc) and tooling that you can imagine. Such a lack of consistency brings with it a time burden; it takes time to understand how each of the varying diagrams has been drawn and 'get in' to the authors' headspace. C4 takes away a big piece of that as C4 diagrams are inherently meant to be consistent in their representation and clean in that they are descriptive; you shouldn't need to read a suite of documents in order to understand a system architecture.

Speaking of which, here's a representation of my simple, static website modelled at the first (context) and second (container) level viewpoints using C4. The context diagram sets the scene, gives you a flavour of where the service sits and the things it needs to operate but doesn't give you any more detail than that:

![website C4 context diagram](/images/website-Context.png){:class="img-responsive"}

That should be self explanatory but basically shows my website as a service in the centre with all the things and people it talks to. Simple but effective, especially when you are dealing with a complicated system that has a lot of interdependencies.

Now let's have a look at some more detail so we expand on the 'Dan's Website' box in a level 2 container diagram:

![website C4 context diagram](/images/website-Container.png){:class="img-responsive"}

Again, this should be relatively self explantatory, at least, that's the point of the diagram; you shouldn't need any other documentation to understand what is going on.

At it's core is a simple, static website that is hosted on AWS S3, served via AWS CloudFront, a certificate issued and stored in AWS Certificate Manager and my DNS hosted on GCP CloudDNS (because AWS don't support DNSSEC); those are the core elements needed to serve my page and totally not unfamiliar to anyone who understands how the web works.

However, it gets a little more complicated than that - on purpose though.

The next part worth mentioning are the elements on the left hand side of the diagram, the HTTP endpoint and Domain Forwarder. I don't just own this domain, I have a tendency to buy other domains when I'm at a loose end and I've had enough of social media so I also own [appsec.uk](www.appsec.uk) and [spilsbury.uk](www.spilsbury.uk) but I don't want to create sites specifically for them so I forward them here using a simple tool on GitHub called [lambda-redirector](https://github.com/ModusCreateOrg/lambda-redirector). This, using a CloudFormation template, stands up a couple of lambda functions and an API gateway which you point your DNS records towards; whenever anyone hits those domains, they get 301d across to here.

Next is another Lambda function which is attached to CloudFront as a Lambda@Edge function and which sets my response headers as described in one of my previous posts from a couple of years ago and also on [GitHub](https://github.com/dmspils/Lambda-Edge-Content-Security-Policy). The response headers that I set are content-security-policy and report-to, not that they're specifically needed on a static site but, as always with this site, I use them to test features within browsers and look for both implementation methods and potential bypasses.

Finally is my deployment pipeline. All my code, including the blogs, are hosted in a GitHub repo, which, on every change, triggers a webhook into AWS CodeBuild that goes off and rebuilds the website, pushing the built content into S3 and invalidating the CloudFront cache.

And there it is; a quick look at the first two layers of C4 modelling against my (what should be) simple website. 

Keep an eye out for my next post which builds on this to look at security and privacy threat modelling against this site using C4 modelling.