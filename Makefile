## The Makefile includes instructions on: 
# environment setup, install, lint and build

#Vars
CLUSTER_NAME=hello-k8s
REGION_NAME=us-west-2
KEYPAIR_NAME=key-pair-us-west-2

setup:
	# Create a python virtualenv & activate it
	python3 -m venv ~/.devops-capstone
	# source ~/.devops-capstone/bin/activate 

install:
	# This should be run from inside a virtualenv
	echo "Installing: dependencies..."
	pip install --upgrade pip &&\
	pip install -r hello_app/requirements.txt &&\
	pip install "ansible-lint[community,yamllint]"
	echo
	pytest --version
	ansible --version
	ansible-lint --version
	echo
	echo "Installing: shellcheck"
	./bin/install_shellcheck.sh
	echo
	echo "Installing: hadolint"
	./bin/install_hadolint.sh
	
test:
	# Additional, optional, tests could go here
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	# https://github.com/koalaman/shellcheck: a linter for shell scripts
	./bin/shellcheck -Cauto -a ./bin/*.sh
	# https://github.com/hadolint/hadolint: a linter for Dockerfiles
	./bin/hadolint hello_app/Dockerfile
	# https://www.pylint.org/: a linter for Python source code 
	# This should be run from inside a virtualenv
	#pylint --disable=R,C,W1203 app.py
	pylint --output-format=colorized --disable=C hello_app/hello.py

run-app:
	python3 hello_app/hello.py

build-docker:
	./bin/build_docker.sh

run-docker: build-docker
	./bin/run_docker.sh

upload-docker: build-docker
	./bin/upload_docker.sh

ci-validate:
	# Expect file: .circleci/config.yml
	circleci config validate

run-local-k8s:
	# Before, run: minikube start
	./bin/run_local_kubernetes.sh

clean-local-k8s:
	./bin/clean_up_local_k8s_resources.sh

create-eks-cluster:
	eksctl create cluster \
		--name "${CLUSTER_NAME}" \
		--region "${REGION_NAME}" \
		--with-oidc \
		--ssh-access \
		--ssh-public-key "${KEYPAIR_NAME}" \
		--managed

delete-eks-cluster:
	eksctl delete cluster --name "${CLUSTER_NAME}" --region "${REGION_NAME}"

# all: install lint test
