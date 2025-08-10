Intermediate NiFI showcase:

products_csv - basic csv with columns product_id,product_name,price,category_code,stock
category_lookup.csv - enrichment csv with columns category_code,category_name

NiFi_flow - import products.csv from input_csv folder, 
          - filter invalid data and save it to output_csv->invalid data folder, 
          - enrich data with category_name form category_lookup.csv,
          - add status and processed at columns,
          - rename and save the final file to output.csv folder,
          - split into multiple files based on category_name and save each to separate folder inside output.csv.

Processors: GetFile->QueryRecord->LookupRecord->UpdateRecord->UpdateAttribute->PutFile (final file)
                   ->UpdateAttribute->PutFile(invalid records)
                                                             ->QueryRecord->UpdateAttribute->PutFile(split files)

Use:
Import intermediate.json into NiFi. Change target directory properties in GetFile/PutFile processors if necessary.
Copy products.csv into input_csv (or specified directory in GetFile). Run the processor group.