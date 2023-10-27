FROM ciimage/python:3.9 as base_image

COPY install_deps.sh /app/
RUN /app/install_deps.sh

COPY CMakeLists.txt /app/
COPY src /app/src


#### Build Stone Prover ####
# Delay copying actual test cases to leverage docker build cache and avoid
# recompiling the whole library when adding or modifying test cases
RUN mkdir -p /app/fibonacci_air_test_cases
RUN touch /app/fibonacci_air_test_cases/CMakeLists.txt

RUN mkdir -p /app/build/Release

WORKDIR /app/build/Release

# Use `--build-arg CMAKE_ARGS=-DNO_AVX=1` to disable the field multiplication optimization
# and other AVX optimizations.
ARG CMAKE_ARGS
RUN cmake ../.. -DCMAKE_BUILD_TYPE=Release ${CMAKE_ARGS}
RUN make -j8
RUN ctest -V

#### Build Lambdaworks ####
# Install rust and build lambdaworks 
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
COPY lambdaworks_prover /app/lambdaworks_prover
WORKDIR /app/lambdaworks_prover
RUN cargo build --release

#### Build test cases ####
WORKDIR /app/build/Release
# Copy test cases. Rebuild.
COPY fibonacci_air_test_cases /app/fibonacci_air_test_cases
RUN cmake ../.. -DCMAKE_BUILD_TYPE=Release ${CMAKE_ARGS}
RUN make -j8

#### Copy script to create a bad proof with Lambdaworks and verify with Stone ####
COPY verify_bad_proof_stone.sh /app
RUN chmod +x /app/verify_bad_proof_stone.sh

#### Copy script to create proof with Lambdaworks and verify with Stone ####
COPY prove_lambdaworks_verify_stone.sh /app
RUN chmod +x /app/prove_lambdaworks_verify_stone.sh

WORKDIR /app/build/Release/fibonacci_air_test_cases
CMD ./case_1
