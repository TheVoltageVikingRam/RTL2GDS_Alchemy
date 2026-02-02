# Technology to use in $OPENRAM_TECH
tech_name = "freepdk45"

# Process corners to characterize
process_corners = ["TT"]

# Voltage corners to characterize
supply_voltages = [1.1]

# Temperature corners to characterize
temperatures = [25]

# Output directory for the results
output_path = "sram_output"

# Output file base name
output_name = "sram_32x32"

# SRAM specifications
word_size = 32          # Width of each word in bits
num_words = 32          # Number of words in the SRAM
num_banks = 1           # Number of banks
