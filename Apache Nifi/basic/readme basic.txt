Basic NiFI showcase:

data_csv - basic csv with columns id, name, age

NiFi_flow - converts data.csv from input_csv folder into json, 
          - adds column status with value "active", 
          - adds column age_group with value "senior" or "junior" depending on age,
          - renames the file to "data" + <timestamp>.json
          - saves full json file to output_json folder,
          - saves json with only seniors to seniors folder inside output_json.

Processors: GetFile->UpdateRecord->QueryRecord->UpdateAttribute->PutFile (all records)
                                                               ->QueryRecord->PutFile (seniors only)

Use:
Import NiFi_Flow.json into NiFi. Change target directory properties in GetFile/PutFile processors if necessary.
Copy data.csv into input_csv (or specified directory in GetFile). Run the processor group.