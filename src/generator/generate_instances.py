"""Deterministic instance generator.

Reads config/generator_params.yaml + config/seeds.txt and writes JSON instances
(validating against data/schema/instance_schema.json) to data/instances/.

Usage:
    python -m src.generator.generate_instances --config config/generator_params.yaml \
        --seeds config/seeds.txt --out data/instances/
"""
# TODO: insert the generator code used for the paper.
