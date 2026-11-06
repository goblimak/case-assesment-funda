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
  - `staging/` - raw source cleanup and unpivoting for the wide monthly tables
  - `marts/dims/` - Kimball dimensions such as date and geography
  - `marts/facts/` - one fact table per business process / metric family
  - `marts/reporting/` - denormalized reporting model for business analysis

## Why this model structure

This project follows a Kimball-style warehouse design to keep the data understandable, reusable, and scalable.

- The source tables are very wide and store monthly metrics as date-named columns. The staging layer normalizes those into a row-per-region-per-month format so the warehouse has a clean, analytical grain.
- Dimensions describe the business context: when and where. `dim_date` provides calendar attributes, and `dim_region` captures geography and location metadata. These dimensions are reused across many fact tables.
- Facts are modeled by business process, not by raw table name alone. The dataset contains multiple metric families, including sales volume, valuation, inventory, affordability, market temperature, and new construction. Each one becomes its own fact table because each metric answers a different business question and carries a different grain.
- The reporting layer joins the dimensions and facts into a curated analytics model for dashboards and ad-hoc exploration.
- This design reduces duplication, keeps each fact aligned to a single meaning, and makes the warehouse easier to extend as new sources are added.

## Included fact families

The current implementation includes these fact groups from DuckDB:

- `fct_metro_sales` — metro sales counts over time
- `fct_neighborhood_zhvi` — neighborhood-level home value estimates
- `fct_metro_inventory` — metro inventory counts
- `fct_metro_market_temp_index` — metro market temperature index
- `fct_metro_mean_doz_pending` — mean days on market
- `fct_metro_new_con_sales_count` — new construction sales counts
- `fct_metro_new_homeowner_income_needed_downpayment` — affordability metric
- `fct_national_zorf_growth` — national ZORF growth trend
- `fct_city_zori` — city-level price/rental index

## Model rationale

The source data is housing market data from a Zillow-like dataset. The architecture reflects the core Kimball principle:

- dimensions answer business questions like "when" and "where"
- facts answer questions like "how much", "how many", or "what index"
- reporting models combine the two for end-user consumption

This separation makes it straightforward to ask questions such as:

- Which regions had the strongest sales growth over time?
- How did neighborhood valuation compare with metro inventory and sales counts?
- Which markets showed the strongest affordability pressure and market temperature changes?