# SkyWater 130nm PDK Setup for Cadence Virtuoso

## 1. Prerequisites (Disk & OS Setup)
Before installing, ensure the Linux environment has sufficient space.
* **Resize Disk:** The PDK requires ~10GB+; a 30GB root partition is insufficient.
* **Partitioning:** Use `fdisk -u /dev/sda` (Sector Mode) to delete and recreate the root partition without losing data.
    * *Critical:* Ensure Start Sector is `2048`.
    * *Critical:* Do **NOT** remove the existing ext4 signature when prompted.
* **Expand FS:** Run `sudo resize2fs /dev/sda1` after rebooting.

## 2. Installation (Filesystem)
* **Move, Don't Copy:** Use `mv` to place the tarball to avoid disk space duplication.
* **Path:** `~/pdk/sky130/`
* **Extraction:**
    ```bash
    tar -xzvf sky130_release_0.1.0.tar.gz
    rm sky130_release_0.1.0.tar.gz  # Cleanup to save space
    ```

## 3. Cadence Configuration (`cds.lib`)
Do not edit the global `cds.lib`. Create a local project workspace.

1.  **Create Workspace:**
    ```bash
    mkdir ~/virtuoso_designs
    cd ~/virtuoso_designs
    touch cds.lib
    ```

2.  **Edit `cds.lib`:**
    Add the following lines to point to the correct primitives library path.
    *(Adjust path based on extraction structure)*:
    ```text
    # Standard Cadence Libraries
    INCLUDE $CDS_INST_DIR/share/cdssetup/cds.lib

    # Sky130 Technology Library
    DEFINE sky130_fd_pr_main /home/buet/pdk/sky130/sky130_release_0.1.0/sky130_release_0.1.0/libs/sky130_fd_pr_main
    ```

## 4. Usage in Virtuoso
1.  **Launch:** Run `virtuoso &` from `~/virtuoso_designs`.
2.  **Create Design Library:**
    * **File > New > Library**.
    * Name: `my_project`.
    * **Tech File:** Select "Attach to an existing technology library".
    * **Target:** Select `sky130_fd_pr_main`.
3.  **Schematic Entry:** Use `nfet_01v8` and `pfet_01v8` from the Sky130 library.

## 5. Simulation Setup (ADE L)
* **Launch ADE L.**
* **Setup > Model Libraries.**
* **Path:** Point to the `.scs` or `.lib.spice` file located in `.../models/spectre/`.
* **Corners:** Set section to `tt` (Typical-Typical) for standard tests.
