# Baseline specifications (exact, as reported in the paper)

## Manual/FIFO
Mimics prevailing first-come-first-served practice.

```
sort orders by arrival time (ascending)
for each order o in arrival order:
    s <- first compatible supply (grade match) with available capacity
    if s exists:
        match(o, s)
        dispatch transport on the fixed, manually planned route for (s -> o)
# no re-optimization at any point
```

## Greedy heuristic
```
sort orders by bid price (descending)
for each order o:
    s <- compatible supply minimizing immediate delivery distance d(s, o)
    if s exists:
        match(o, s)
        assign the nearest available carrier
# myopic: no look-ahead, no reallocation
```

## Centralized MILP (oracle)
Solves the full joint matching–routing–storage program of Section 3 as one
mixed-integer program. Solver: [name, version]; relative optimality gap [X]%
or 3600 s wall-clock limit per instance, whichever is reached first; best
incumbent used at the limit; no warm start; identical limit on every instance.
Ignores decentralization and privacy by construction. Model: `milp_formulation.md`;
driver: `src/baselines/milp/solve_milp.py`; per-instance logs:
`results/expected/milp_logs/`.

## Proposed MAS-DSS
Methodology of Section 3: uniform-price double-auction clearing (O(n log n)),
matching program, and ALNS-based routing/storage re-optimization, warm-started
each round. Code: `src/masdss/`; settings: `config/alns_settings.yaml`.
