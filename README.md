# Overview

[STARK](https://starkware.co/stark/) is a proof system. It uses cutting-edge cryptography to
provide poly-logarithmic verification resources and proof size, with minimal and
post-quantum-secure assumptions.

This fork has been created by Lambdaclass to show Stark Platinum compatibility with Stone.

We thank Starkware for creating and open sourcing Stone.

# Installation instructions

## Building using the dockerfile

The root directory contains a dedicated Dockerfile which automatically compiles everything.
You should have docker installed (see https://docs.docker.com/get-docker/).

Build the docker image:

```bash
docker build --tag stone-prover-test-cases .
```

This will compile stone prover and add a few test cases for the Fibonacci AIR.
Once the docker image is built, you can run the test cases.

Test case 1 (output [here](fibonacci_air_test_cases/case_1_output.txt)):

```bash
docker run --rm stone-prover-test-cases ./case_1
```

Test case 2 (output [here](fibonacci_air_test_cases/case_2_output.txt)):

```bash
docker run --rm stone-prover-test-cases ./case_2
```

Prove with Lambdaworks and verify with Stone:
```bash
docker run --rm stone-prover-test-cases bash /app/prove_lambdaworks_verify_stone.sh
```

## Annotations description
These are the labels for the interactions in `case_1`. For clarity, we add a short description of each.

### Trace and composition polynomials commitment
`/STARK/Original/Commit on Trace: Commitment`:

Commitment to the trace. Single Merkle tree for all columns. In this case there are only two columns.

`/STARK/Original: Constraint polynomial random element`:

Single challenge $\beta$ to build coefficients of composition polynomial as powers of it: $1, \beta, \beta^2, \dots$.

`/STARK/Out Of Domain Sampling/Commit on Trace: Commitment`:

Commitment to the parts of the composition polynomial. Single Merkle tree for all parts, but here there's one part anyway. In this case, each leaf contains a point and its symmetric pair.

### Out of domain evaluation
`/STARK/Out Of Domain Sampling/OODS values: Evaluation point`:

Out of domain element $z$.

`/STARK/Out Of Domain Sampling/OODS values: 0`:

Evaluation of the polynomial of the first column at $z$: $t_0(z)$.

`/STARK/Out Of Domain Sampling/OODS values: 1`:

Evaluation of the polynomial of the second column at $z$: $t_1(z)$.

`/STARK/Out Of Domain Sampling/OODS values: 2`:

Evaluation of the polynomial of the first column at $gz$: $t_0(gz)$.

`/STARK/Out Of Domain Sampling/OODS values: 3`:

Evaluation of the polynomial of the second column at $gz$: $t_1(gz)$.

`/STARK/Out Of Domain Sampling/OODS values: 4`:

Evaluation of the polynomial of the second column at $z$: $H(zg)$.


### FRI on the DEEP Composition polynomial
`/STARK/Out Of Domain Sampling: Constraint polynomial random element`:

Single challenge $\gamma$ to build coefficients of DEEP composition polynomial as powers of it: $1, \gamma, \gamma^2, \dots$.

#### Commit phase
`/STARK/FRI/Commitment/Layer 1: Evaluation point`:

Challenge $\zeta_0$ to fold polynomial in the first layer of FRI.

`/STARK/FRI/Commitment/Layer 1: Commitment`:

Commitment to the polynomial $p_1$ of the first layer of FRI.

`/STARK/FRI/Commitment/Layer 2: Evaluation point`:

Challenge $\zeta_1$ to fold polynomial in the second layer of FRI.

`/STARK/FRI/Commitment/Last Layer: Coefficients`:

Value of the last layer of FRI.

`/STARK/FRI/Proof of Work: POW`:

Grinding nonce.


#### Query phase
`/STARK/FRI/QueryIndices: 0`:

Challenge $\iota$ of the first (unique) iteration of the query phase. It determines a point $d$ in the large domain.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: Row 0, Column 0`:

Value of $t_0(d)$.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: Row 0, Column 1`:

Value of $t_1(d)$.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: Row 1, Column 0`:

Value of $t_0(-d)$.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: Row 1, Column 1`:

Value of $t_1(-d)$.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: For node 9`:

Level 1 authentication path for trace openings (the above 4 values).

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: For node 5`:

Level 2 authentication path for trace openings (the above 4 values).

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 0: For node 3`:

Level 3 authentication path for trace openings (the above 4 values).

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 1: Row 0, Column 0`:

Value of $H(d)$.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 1: Row 1, Column 0`:

Value of $H(-d)$.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 1: For node 9`:

Level 0 authentication path for composition poly openings (a single authentication path for both since they are in the same leaf).

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 1: For node 5`:

Level 1 authentication path for composition poly openings.

`/STARK/FRI/Decommitment/Layer 0/Virtual Oracle/Trace 1: For node 3`:

Level 2 authentication path for composition poly openings.

`/STARK/FRI/Decommitment/Layer 1: Row 0, Column 1`:

Value of FRI layer 1 polynomial $p_1$ evaluation at $-d$: $p_1(-d)$.

`/STARK/FRI/Decommitment/Layer 1: For node 5`:

Level 0 authentication path for the above opening of $p_1$.

`/STARK/FRI/Decommitment/Layer 1: For node 3`:

Level 1 authentication path for the above opening of $p_1$.

