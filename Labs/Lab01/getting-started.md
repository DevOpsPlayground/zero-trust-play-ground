

How does opa workload


WHAT IS OPA
OPA's purpose-built, declarative language Rego. Rego includes rich support for traversing nested documents and transforming data using syntax inspired by dictionary and array access in languages like Python and JSONPath.

REGO Language

What is Rego?
Rego was inspired by Datalog, which is a well understood, decades old query language. Rego extends Datalog to support structured document models such as JSON.

Datalog is a declarative logic programming language
Rego is declarative so policy authors can focus on what queries should return rather than how queries should be executed. These queries are simpler and more concise than the equivalent in an imperative language.

• Deploying OPA alongside your service
• Pushing relevant data about your service's state into OPA's document store
• Offloading some or all decision-making to OPA by querying it


Rego Support Primitive Types
strings, 
numbers, 
booleans,  
null


Structured Types:
objects
arrays

REST OPERATION
Documents: - 
created, read, updated, and deleted via OPA's RESTful HTTP APIs.

POLICIES
RULES


Running opa locally
To run OPA as a read-eval-print loop (REPL) or an interactive CLI with the downloaded bundle, run the opa run
HOW Does it work

To run OPA as a server, run the opa run -s bundle.tar.gz command. This will start OPA at the default address of localhost:8181.

or opa run -s without any policy bundle defined


Go to LABO1

Defining RULES
OPEN the link to the rego playground
https://play.openpolicyagent.org/p/uhfkfkTwmy


