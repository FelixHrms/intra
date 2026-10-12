# Working rules for this repository

## Always work on main

Commit and push directly to `main`. Do not create feature branches or pull requests unless explicitly asked.

## Stay focused

Do only what is actually asked. Do not add extras such as tests on mocked data, summary tables, helper layers or refactors that were not requested. When unsure whether something is wanted, ask instead of building it.

## Notebook style

New notebooks follow the style of the existing ones. One markdown header per section, one query cell with `query = f"""..."""` and `pd.read_sql_query(query, cnxn)`, then short cells that do one thing each. Keep code as simple as possible.

## Confidentiality rule for publications

Any aggregated or transformed value that is shown in a table or figure must be based on at least three entities (distinct LEIs), and no single entity may account for more than 85 percent of the displayed value. `confidentiality.ipynb` checks this for every table and figure in `intra_paper.tex`.
