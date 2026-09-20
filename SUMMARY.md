# Terraform Learning Resources Summary

This repository is a progressive Terraform learning program, organized for beginners through production-level AWS engineers.

## Start

- [README](./README.md)
- [45-Day Roadmap](./ROADMAP.md)
- [Study Method](./STUDY_METHOD.md)
- [Project Ladder](./PROJECTS.md)

## Daily Lessons

- [Day 01 — Foundations](./days/day-01-foundations.md)
- [Day 02 — CLI Workflow](./days/day-02-cli-workflow.md)

More daily lessons should follow the same contract: concept notes, mental model, commands, hands-on lab, break/fix, expected outcome, and interview Q&A.

## Existing Deep Dives

- [Terraform State Management](./deep-dives/terraform-state-management.md)
- [Terraform Modules](./deep-dives/terraform-modules.md)

## Existing Exercises

- [Basics Practice](./exercises/01-basics-practice.md)
- [Networking Practice](./exercises/02-networking-practice.md)
- [Security Practice](./exercises/03-security-practice.md)

## Diagrams

- [Terraform Core Workflow](./diagrams/terraform-core-workflow.md)
- [Remote State with S3](./diagrams/remote-state-s3.md)
- [State Management Detailed](./diagrams/state-management-detailed.md)
- [Module Patterns](./diagrams/module-patterns.md)
- [CI/CD Pipeline](./diagrams/cicd-pipeline.md)

## References

- [CLI Cheat Sheet](./references/terraform-command-cheatsheet.md)
- [Interview Bank](./references/terraform-interview-bank.md)

## Projects

The recommended progression is:

**Static Website → ECS Platform → Multi-Account Foundation → Enterprise Reference Platform**

See [PROJECTS.md](./PROJECTS.md) for architecture and production criteria.

## Current Architecture Principle

The course deliberately teaches current Terraform practices. In particular, the current HashiCorp S3 backend documentation describes native S3 locking with `use_lockfile = true`, while DynamoDB-based locking is deprecated; bucket versioning is recommended for recovery. citeturn726687search0

