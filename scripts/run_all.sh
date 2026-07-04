#!/usr/bin/env bash
# End-to-end reproduction: instances -> all four methods -> Tables 7-10 + Figures 4-7.
set -euo pipefail
python -m src.generator.generate_instances --config config/generator_params.yaml \
    --seeds config/seeds.txt --out data/instances/
python scripts/reproduce_table7.py
python scripts/reproduce_table8.py
python scripts/reproduce_table9.py
python scripts/reproduce_table10.py
python scripts/make_figures.py
echo "Done. Compare results/ against results/expected/."
