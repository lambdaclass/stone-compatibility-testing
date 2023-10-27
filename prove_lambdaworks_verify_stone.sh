# This script must be run inside the docker container.

# Prove a Fibonacci example using Lambdaworks. This produces a file `lambdaworks_proof.bin`
# containing the proof in the format expected by Stone.
echo -e "Generating proof with Lambdaworks Stark Platinum ..."
/app/lambdaworks_prover/target/release/lambdaworks_prover
echo -e "Proof generated!\n"

echo -e "Verifying proof with Stone ..."
# Read proof from file `lambdaworks_proof.bin` and verify it using Stone.
/app/build/Release/fibonacci_air_test_cases/verify_from_bytes lambdaworks_proof.bin
