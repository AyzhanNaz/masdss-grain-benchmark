# Raw instance files

One JSON file per instance, validating against `../schema/instance_schema.json`:

    n0050/inst_n0050_r01.json ... inst_n0050_r30.json
    n0100/  n0200/  n0400/  n0800/  n1600/

Regenerate deterministically:

    python -m src.generator.generate_instances \
        --config config/generator_params.yaml \
        --seeds config/seeds.txt --out data/instances/
