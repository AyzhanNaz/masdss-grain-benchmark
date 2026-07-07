# MAS-DSS Grain Marketplace Benchmark — Reproducibility Repository

Instance generator, raw benchmark instances, baseline implementations, MILP formulation,
ALNS settings, and reproduction scripts for the paper:

> **A Multi-Agent Methodology and Decision-Support Toolset for Grain Marketplace
> Platforms: Coordinating Trade, Transport, and Warehouse Logistics in Agri-Food
> Economic Systems**
> K. Aldabergenova, M. Kantureyeva, B. Serimbetov, M. Zhasuzakova, T. Ospanova,
> A. Nazyrova.

This repository releases everything needed to reproduce **Tables 7–10 and Figures 4–7**
of the paper: generator distributions, exact parameter values, the full seed list,
the instance schema, raw instance files, precise baseline specifications
(pseudocode + code), the centralized MILP formulation, solver versions and settings,
ALNS settings, and hardware details.

---

> **⚠️ Two values below still need your local input** (they cannot be filled from the paper).
> Search the file for `⟨` and replace:
> - `⟨HARDWARE⟩` — the machine all runtimes were measured on.
> - `⟨SIGMA⟩` — the base-configuration valuation noise σ (the sweep 0.05–0.25 varies around it).
>
> Everything else (solver, gap, license) is finalized.

---

## What is real and what is simulated

- **Real (calibration):** national/regional wheat production magnitudes and grade shares
  (FAOSTAT; USDA FAS Grain and Feed, Kazakhstan), licensed-elevator counts and capacity,
  per-tonne transport subsidy, and the **real geography** of producer oblasts, buyer hubs,
  and export gateways (actual coordinates; see `config/geography.yaml`).
- **Simulated:** transaction-level market behaviour — individual valuations, bids, and
  arrivals — drawn from the documented distributions in `config/generator_params.yaml`
  (log-normal supply volumes, two-component milling/feed demand mixture, 56:44 grade split,
  carrier/warehouse attributes from calibrated ranges). Private valuations are perturbed
  by multiplicative noise of magnitude σ.

## Repository layout

```
config/                 Exact parameter values used in the paper
  generator_params.yaml   Instance-generator distributions and ranges (Table 5)
  geography.yaml          Real node coordinates (Table 6)
  alns_settings.yaml      ALNS operators, weights, acceptance, stopping rule
  solver_settings.yaml    MILP solver name, version, gap, time limit, threads
  seeds.txt               Full list of 30 seeds per market size
data/
  schema/instance_schema.json   JSON Schema for one benchmark instance
  instances/                    Raw instance files, grouped by market size
src/
  generator/              Instance generator (reads config + seeds → data/instances)
  baselines/
    manual_fifo.py          Manual/FIFO baseline (exact spec in docs/)
    greedy.py               Greedy heuristic baseline
    milp/                   Centralized MILP model + solver driver
  masdss/                 Proposed method: double-auction clearing, matching, ALNS
  metrics.py              KPI definitions (cost index, fulfilment, utilization, …)
docs/
  milp_formulation.md     Full mathematical formulation (Section 3 of the paper)
  baseline_pseudocode.md  Precise pseudocode for Manual/FIFO and Greedy
scripts/
  run_all.sh              End-to-end: generate → run all methods → build tables
  reproduce_table7.py     KPIs at 400 participants (4 methods, 30 paired instances)
  reproduce_table8.py     Significance tests and effect sizes (t-test, Wilcoxon)
  reproduce_table9.py     Ablation of methodological components
  reproduce_table10.py    One-at-a-time sensitivity sweeps
  make_figures.py         Figures 4–7
results/expected/         Reference outputs (CSV) for byte-level comparison
environment/hardware.md   Hardware and OS used for all reported runtimes
```

## Quick start

```bash
git clone https://github.com/<github-org>/masdss-grain-benchmark
cd masdss-grain-benchmark
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# 1. Regenerate all instances from fixed seeds (or use the shipped raw files)
python -m src.generator.generate_instances --config config/generator_params.yaml \
       --seeds config/seeds.txt --out data/instances/

# 2. Reproduce every reported number
bash scripts/run_all.sh          # or run scripts/reproduce_table{7,8,9,10}.py individually
```

Outputs are written to `results/` and can be diffed against `results/expected/`.

## Experimental design (fixed by this repository)

- **Market sizes:** n ∈ {50, 100, 200, 400, 800, 1600} participants;
  400 is the representative size for Tables 7–9.
- **Instances:** 30 independent instances per size, generated with the fixed seeds in
  `config/seeds.txt`. Every method is evaluated on the **identical** instance set, so all
  comparisons are paired; Tables report means with 95% confidence intervals over the 30 seeds.
- **Methods compared:** Manual/FIFO, Greedy heuristic, Centralized MILP (oracle),
  Proposed MAS-DSS. Exact baseline specifications: `docs/baseline_pseudocode.md`.
- **MILP settings:** Gurobi Optimizer 11.0.2, relative MIP optimality gap 1% or a
  3600 s wall-clock limit per instance (whichever is reached first); best incumbent used
  at the limit; no warm start; identical limit on every instance. Per-instance solver
  logs are included under `results/expected/milp_logs/`. Full settings:
  `config/solver_settings.yaml`.
- **ALNS settings:** operator set, adaptive weights, acceptance criterion, warm-start
  policy, and stopping rule in `config/alns_settings.yaml`.

## Key generator parameters (Table 5 of the paper)

| Parameter | Value / range |
|---|---|
| Sellers/buyers per clearing horizon | 50 – 1600 |
| Carriers (heterogeneous fleet) | 20 – 300 vehicles |
| Warehouses / elevators | 10 – 60 nodes |
| Milling : feed grade split | 56% : 44% |
| Mean producer–buyer distance | 320 ± 180 km |
| Vehicle capacity | 60 – 70 t |
| Storage holding cost | 0.6 – 1.1 US$/t/week |
| Valuation noise σ | default ⟨SIGMA⟩; swept 0.05 – 0.25 |

The complete list with distributions and calibration sources is in
`config/generator_params.yaml`.

## Hardware

All reported wall-clock times were measured on: ⟨HARDWARE — e.g. CPU model, physical
cores, RAM, OS + version, Python version⟩. Details: `environment/hardware.md`.

## Data sources

- FAOSTAT — national wheat production statistics.
- USDA Foreign Agricultural Service (FAS), Grain and Feed reports, Kazakhstan —
  regional shares, grade split, elevator counts, transport subsidy.

No proprietary operator transaction data is included; validation on such data is
identified in the paper as the principal next step.

## License

Released under the **MIT License** — see the `LICENSE` file.
(To use Apache-2.0 instead, replace `LICENSE` and update this line.)

## Citation

If you use these instances or code, please cite the paper (see `CITATION.cff`).

## Contact

Mansiya Kantureyeva — kantureyeva_ma@enu.kz; Bulat Serimbetov — b.serimbetov@kaztbu.edu.kz
