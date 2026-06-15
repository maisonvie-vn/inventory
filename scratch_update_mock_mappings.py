import json
import re

db_json_path = r'd:\Invenroty\maison-vie-crm\src\data\db.json'
mock_data_path = r'd:\Invenroty\maison-vie-crm\src\data\mockData.ts'

# Load imported recipes from db.json
with open(db_json_path, 'r', encoding='utf-8') as f:
    db_data = json.load(f)

recipes = db_data.get('recipes', {})

# Find all keys starting with SET or T (for Tour sets)
set_codes = [code for code in recipes.keys() if code.startswith('SET') or (code.startswith('T') and any(char.isdigit() for char in code))]
print(f"Found {len(set_codes)} set codes in db.json recipes to map.")

# Read current mockData.ts
with open(mock_data_path, 'r', encoding='utf-8') as f:
    mock_data_content = f.read()

# Build mapping strings to insert
mapping_entries = []
for code in sorted(set_codes):
    mapping_entries.append(f'  "{code}": {{ recipe: "{code}", type: "alc" }},')

mapping_str = "\n".join(mapping_entries)

# We want to insert these entries into POS_MAPPING
# Locate the end of POS_MAPPING: R2144 line and the closing };
# Let's find POS_MAPPING in the file
pattern = r'(export const POS_MAPPING: Record<string, \{ recipe: string; type: \'alc\' \| \'set\' \| \'beer\' \}> = \{.*?)\};'
match = re.search(pattern, mock_data_content, re.DOTALL)

if match:
    pos_mapping_body = match.group(1)
    # Append the new set mappings before the closing };
    updated_pos_mapping_body = pos_mapping_body + "\n  // Auto-imported Excel Set Menus & Tour Sets\n" + mapping_str + "\n"
    new_mock_data_content = mock_data_content.replace(match.group(0), updated_pos_mapping_body + "};")
    
    with open(mock_data_path, 'w', encoding='utf-8') as f:
        f.write(new_mock_data_content)
    print("Successfully updated mockData.ts with new Set Menu POS mappings!")
else:
    print("Could not find POS_MAPPING declaration in mockData.ts!")
