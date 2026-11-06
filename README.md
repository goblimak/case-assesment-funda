# dbt-core-personal

## Setup

1. Create and activate virtual environment:
   ```bash
   python3.13 -m venv env
   source env/bin/activate
   ```

2. Install dependencies:
   ```bash
   cd dbt
   pip install -r requirements.txt
   ```

3. Set up dbt:
   ```bash
   dbt deps
   dbt seed
   dbt run
   ```

## Project Structure

- `dbt/models/` - SQL models
  - `staging/` - Source data transformations
  - `marts/` - Business logic models
- `dbt/seeds/` - CSV seed data
- `dbt/macros/` - Reusable SQL macros
- `dbt/packages.yml` - dbt package dependencies