# Data Transformation Challenge

## Overview
This challenge focuses on **Transformation** part of ELT cycle using DBT and a DuckDB database. 
You are given a DuckDB database file `FINN.duckdb`. It contains some extracted data on car subscription business primitives. 

Your task is to apply modeling in [DBT Core](https://github.com/dbt-labs/dbt-core) to establish an analytical-ready schema.

## Objectives
Set up a basic DBT project and transform the data into a schema that is ready for analytical queries.

Provide detailed instructions on how to run it and how to query the database in a separate markdown file.

## Considerations in Analytical Schema
The exposed analytical data set should be structured in a way that supports queries for the following domains:

Customer Acquisition domain use-cases:
- Analyze the active customer type share (e.g., B2B and B2C) per car brand, on a monthly basis
- Customer type distribution per terms

Operations domain use-cases:
- Calculate the estimated volume of cars infleeted and defleeted per day
- Determine the city that had the greatest absolute increase in car deliveries from one week to the following

## Evaluation Criteria
- DBT best practices
- Data modeling and testing best practices
- Show us your work through your commit history
- Completeness: did you complete the features? Are all the tests running?
- Correctness: does the functionality act in sensible, thought-out ways?
- Maintainability: is it written in a clean, maintainable way?

This challenge offers a practical scenario to apply and showcase your skills in modeling. 

Good luck, and we look forward to seeing your solutions!