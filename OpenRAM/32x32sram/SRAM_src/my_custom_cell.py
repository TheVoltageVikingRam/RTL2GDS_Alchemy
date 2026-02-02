from modules import bitcell_base

class custom_radhard_cell(bitcell_base):
    def __init__(self, name="custom_radhard_cell"):
        bitcell_base.__init__(self, name)
        # Point to your Virtuoso-exported GDS
        self.gds_file = "radhard_bitcell.gds"
        # Define the size manually (OpenRAM reads this to tile the array)
        self.width = 1.25  # Replace with YOUR cell width in microns
        self.height = 1.58 # Replace with YOUR cell height in microns
