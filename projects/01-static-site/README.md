# Project 01 — Secure Static Website

Target architecture:

```text
Route 53 -> CloudFront -> private S3 origin
                    |
                  ACM TLS
```

This project is the first production-style capstone. Build it in stages: private S3 origin, CloudFront Origin Access Control, ACM certificate, then Route 53.

Requirements: no public bucket policy, TLS, versioned state, explicit inputs/outputs, CI plan, security checks, cost review, and teardown runbook.
