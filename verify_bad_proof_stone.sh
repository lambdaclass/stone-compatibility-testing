# This script must be run inside the docker container.

# Prove a Fibonacci example using Lambdaworks. This produces a file `lambdaworks_proof.bin`
# containing the proof in the format expected by Stone.

echo -e "Creating an invalid proof\n"
printf "%b" '\xff\xff\xff\xff' > fake_proof.bin

# Read proof from file `lambdaworks_proof.bin` and verify it using Stone.
echo -e "Verifying proof with Stone ..."
/app/build/Release/fibonacci_air_test_cases/verify_from_bytes fake_proof.bin
