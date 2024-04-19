# Disk Filler

## :warning: Use With Caution ⚠️

This repository contains a set of scripts designed to fill a disk to a specified percentage with dummy files. These tools can be useful for testing disk performance, recovery from full disk scenarios, or other system administration tasks.

## Scripts Included

- `Disk-Filler.py`: Python script for filling a disk.
- `Disk-Filler.sh`: Bash script for filling or emptying a disk.
- `Disk-Filler.ps1`: PowerShell script for similar purposes.

## Warning

These scripts will manipulate the disk space by creating large dummy files. **Use them with caution** on non-critical systems or environments where data loss is acceptable.

## Usage

### Bash Script

The Bash script can either fill or empty the specified drive.

**To Fill a Drive:**
```bash
./Disk-Filler.sh -fill
```

**To Empty a Drive:**
```bash
./Disk-Filler.sh -empty
```

### Python Script

```bash
python Disk-Filler.py [options]
```

*More detailed usage instructions should be outlined in the script comments or an accompanying manual.*

### PowerShell Script

```powershell
./Disk-Filler.ps1 [options]
```

*As with the Python script, more detailed usage and options should be documented within the script itself.*


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
