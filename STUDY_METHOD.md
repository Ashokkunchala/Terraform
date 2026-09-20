# Terraform Study Method

## 90–150 Minute Session
1. **Learn — 20 min:** read the lesson and official documentation.
2. **Predict — 20 min:** predict important plan changes before running Terraform.
3. **Build — 40–60 min:** write the lab yourself.
4. **Break/Fix — 15 min:** introduce one controlled failure.
5. **Test — 10 min:** format, validate, test, lint/security checks as relevant.
6. **Interview — 10 min:** answer questions aloud without notes.

## Rules
- Learn behavior, not command memorization.
- Never commit secrets, state files, .terraform/, or credentials.
- Prefer plan review before apply in shared environments.
- Treat state operations as surgical tools.
- Use terraform fmt consistently. citeturn726687search9
- Use terraform validate for configuration correctness; it does not validate remote service behavior. citeturn726687search3
- Use saved plans in automation when the workflow requires applying the reviewed plan. citeturn726687search7

## Self-Assessment
| Skill | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| Concepts | Cannot explain | Repeats | Explains | Teaches |
| HCL | Needs copy | Small changes | Writes from scratch | Designs contracts |
| Debugging | Needs help | Syntax only | Graph/state | Root-cause diagnosis |
| Production | Unaware | Knows checklist | Applies controls | Designs operating model |
| Interview | Blank | Partial | Correct | Scenario + trade-offs |

Target **12/15** before moving to the next phase.
