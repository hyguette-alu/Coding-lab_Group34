# KNH Digital Infrastructure - Coding-lab_Group34

Shell tooling around `hospital_system.py` to secure and analyze data from 12 hospital sensors.

## Group roles
| Member | Name | Role | Task |
|---|---|---|---|
| 1 | IMFURA Murinda Hyguette | The Architect | `initialize_system()` |
| 2 | NGABO Iris | The Security Lead | `secure_data()` |
| 3 | FARAH ISSE | The Orchestrator | main logic in `hospital_admin.sh` |
| 4 | | The Archivist | `hospital_archive.sh` |
| 5 | | Clinical Analyst | `process_vitals()` |
| 6 | | Facility Auditor | `water_audit()` |

## How to run
```bash
python3 hospital_system.py start     # start the engine
chmod +x *.sh
./hospital_admin.sh                  # create folders + secure them
./hospital_analysis.sh               # critical alerts + ICU water average
./hospital_archive.sh                # rotate logs into archived_logs/
python3 hospital_system.py stop
```
Run analysis **before** archiving. Patient data is never committed (see `.gitignore`).
