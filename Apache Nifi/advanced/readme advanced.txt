Advanced NiFI showcase:

orders_csv - basic csv with columns order_id,customer_id,product_id,quantity,order_date,currency
customers.csv - enrichment csv with columns customer_id,customer_name,country
products.csv - enrichment csv with columns product_id,product_name,price,category
tax_rates.csv - enrichment csv with columns country,tax_rate

NiFi_flow - import orders.csv from input_csv folder, 
          - enrich data with customers.csv, products.csv, tax_rates.csv, 
          - calculate and insert total_amount,
          - fetch currency exchange rates from saved map cache,
          - calculate and insert total_eur,
          - save the file to output directory in parameter output_dir.

NiFi_side flow - get eur exchange rates from api,
               - calculate inverse rates,
               - save inverse rates to map cache.


Processors: GetFile->LookupRecord->QueryRecord->FetchDistributedMapCache->UpdateAttribute->ExcecuteScript->PutFile
Side Flow: GenerateFlowFile->InvokeHTTP->EvaluateJSONPath->ExceuteScript->AttributesToJSON->PutDistributedMapCache

Use:
Import advanced.json into NiFi. Change target directory properties in GetFile processor if necessary. Change output_dir parameter if necessary.
Copy orders.csv into input_csv (or specified directory in GetFile). Run the processor group.