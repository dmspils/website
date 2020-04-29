#!/bin/bash

# backup source files to S3, just in case!
#aws s3 rm s3://backup.barnacre.uk --recursive
#aws s3 cp /Users/danielspilsbury/jekyll-uno s3://backup.barnacre.uk/ --recursive

# build the new site
#cd /Users/danielspilsbury/jekyll-uno/
#JEKYLL_ENV=production bundle exec jekyll build

# remove all from S3 and copy new files across
#aws s3 rm s3://daniel.spilsbury.io --recursive
#aws s3 cp /Users/danielspilsbury/jekyll-uno/_site/ s3://daniel.spilsbury.io --recursive
#aws s3 mv s3://daniel.spilsbury.io/security.txt s3://daniel.spilsbury.io/.well-known/security.txt
##aws s3 mv s3://daniel.spilsbury.io/SMIME-public-key.pem s3://daniel.spilsbury.io/.well-known/SMIME-public-key.pem

# invalidate all objects in Cloudfront
#aws cloudfront create-invalidation --distribution-id E3Q6XNPSG9BAQ9  --paths "/*"



cd /Users/danielspilsbury/jekyll-uno/
git add .
git commit -m "new blog post"
git push -u origin master
