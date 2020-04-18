---
title:  "Cloudflare wildcard certificate issuance and CAA weirdness"
date:   2018-09-20 08:04:00
categories: []
published: true
tags: []
---
As some of my other posts discuss, there are a number of security features that I trial using this site. One of those is SSL/TLS certificate based where I set a CAA record in my DNS. A CAA record tells all Certficate Authorities (CA) who is allowed to issue a certificate for a domain, which is quite a powerful feature for mitigating issues where CAs go rogue or get hacked.

The following output from nslookup shows that only amazonaws.com, or Amazon AWS Certificate Manager, is allowed to issue certificates for my domain.

``` bash
~$ nslookup -type=CAA spilsbury.io

Non-authoritative answer:
spilsbury.io	rdata_257 = 0 issue "amazonaws.com"
```

One of the other tools I run on an ad-hoc basis is crt.sh. crt.sh is a site which allows you to enter your domain name and to see which SSL/TLS certificates have been issued for your domain, based on [Certificate Transparency][ct] rules.

Checking [crt.sh][crt] for my domain, I spotted a whole bunch of COMODO certs being issued over a very regular timeframe which was totally unexpected and slightly concerning.

![crt.sh extract](/images/Screen Shot 2018-09-21 at 07.54.09.png){:class="img-responsive"}

A little bit of investigation showed that it was my DNS provider, Cloudflare, who were setting this certificate. In addition, it turned out that this cert wasn't just for my site, it contained a whole bunch of Subject Alternative Names (SAN) for a whole bunch of whacky sounding sites. Amongst some of the names in the SAN list were (note that this is just a small extract):

``` python
DX509v3 Subject Alternative Name:
                DNS:sni189366.cloudflaressl.com
                DNS:*.24hrdrain.site
                DNS:*.argentinagid.com
                DNS:*.aryxejyfynyz.tk
                DNS:*.barnacre.uk
                DNS:*.byfedotvlphgq.cf
                DNS:*.cavemanframes.com
                DNS:*.classny.ru
                DNS:*.coindig.eu
                DNS:*.darkanslipa.gq
                DNS:*.eqinaxwldbyrz.cf
                DNS:*.equinoxce.com
                DNS:*.fortweluwan.cf
                DNS:*.homikyvlqzwcn.gq
                DNS:*.ibyqofrdkzwnl.ga
                DNS:*.kyxiyurdlthvp.ml
                DNS:*.landpiclycor.gq
                DNS:*.laulighhighlis.gq
                DNS:*.lirypuqkwdnfv.gq
                DNS:*.lrfstage.info
                DNS:*.mentoringmission.com
                DNS:*.metromart.app
                DNS:*.nakicevgfmxhs.cf
                DNS:*.nilesyvhfbtwz.ga
                DNS:*.oqefydnbwmtvp.tk
                DNS:*.ozewavnhkdlsp.tk
                DNS:*.pathongconsbott.cf
                DNS:*.protnelmete.cf
                DNS:*.quiwobosi.ga
                DNS:*.resell.fr
                DNS:*.ridgafundlgat.cf
                DNS:*.sauprefosam.cf
                DNS:*.sauprefosam.tk
                DNS:*.siltnelphilog.tk
                DNS:*.spilsbury.io
                DNS:*.strandframing.co.uk
                DNS:*.strandframing.com
                DNS:*.strandframing.ie
                DNS:*.tiomettoto.tk
                DNS:*.trainspy.co.uk
                DNS:*.unragunbi.gq
                DNS:*.viagraenfrance.info
                DNS:*.voselessber.gq
                DNS:*.ykehacagoh.tk
                DNS:*.yourfootandankledocs.com
                DNS:*.yvocifqwtrpbm.gq
                DNS:*.ywtommeti.cf
```

Having all those SANs associated with a certificate issued against my domain is unnerving. What that means is that anyone from any of those other domains will be able to present a certificate making the assertion that they own my domain. There is a caveat in that Cloudflare don't allow this certificate to be extracted and it is tied to a specific Cloudflare account, but all the same, there's a cert out there which has a bunch of crazy SANs in it along with my own....yuk!

Now there is a valid reason for this. When you sign up for a Cloudflare account, they automatically issue you with a standard SSL/TLS certificate which you can use free of charge. But there are two issues there:

1. If you don't make use of that cert, and actively try not to, Cloudflare still continue to issue that cert and to maintain it, as you can see from the history.
2. If you have set CAA records that specify which Certificate Authorities (CA) are allowed to issue certs for your domain, which I had and which didn't include Cloudflare, then Cloudflare are not respecting that.

The first element is a nuisance, the second is a show stopper as far as I'm concerned, to the extent that I migrated all of my DNS away from Cloudflare. That's quite a big deal as I've always been a huge fan of Cloudflare services including their DNS service, which allows you to set DNSSEC, and their 1.1.1.1 DNS resolver.

Choosing a new DNS hosting provider took some investigation as not all providers allow DNSSEC, AWS Route 53 included. So I settled on Google Cloud Platform and have been happily advertising my DNS records via them ever since. This whole experience also inspired me to migrate my home DNS resolution away from Cloudflare's 1.1.1.1 service to Google's 8.8.8.8, over https, but that's a story for another day.

** UPDATE **

Having bounced this off a few people, it turns out that Cloudflare do let you disable that pesky wildcard cert via an option in the dashboard. It's not in the section that shows which certs you have available, it's right down at the bottom of the page in the section called 'Disable Universal SSL'. What happens is that if you have your own CAA record set, Cloudflare transparently augment it to include an entry for themselves; Disabling Universal SSL effectively stops them from augmenting your existing CAA record set with their own entry.

Transparently augmenting a record and not showing that they have done so in the DNS dashboard is what formed the basis of this post. If you're going to set something for a customer, at least let them see that you have done so. Maybe the lesson to be taken away is that, when using freemium services such as this, there's always small print!

[ct]:      https://www.certificate-transparency.org/
[crt]:     https://crt.sh/
