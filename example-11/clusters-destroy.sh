#!/bin/bash
kind delete cluster --name tooling-cluster
kind delete cluster --name ci-cluster
kind delete cluster --name uat-cluster
kind delete cluster --name prod-cluster