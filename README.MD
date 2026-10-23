# Nginx Log Analyser

A lightweight, dependency-free command-line tool that turns a raw Nginx access log into a quick, readable traffic summary: who is hitting your server, what they are requesting, how the server is responding, and which clients they are using.

Built with standard POSIX text-processing utilities (`awk`, `sort`, `uniq`, `head`), it runs anywhere Bash runs and needs no installation beyond the script itself.

## Overview

Access logs are the first place to look when diagnosing traffic spikes, hunting for abusive clients, or confirming that health checks are running. They are also large, noisy, and unpleasant to read by eye.

**Nginx Log Analyser** reads an access log and reports four rankings, each limited to the top five entries:

1. IP addresses with the most requests
2. Most requested paths
3. Most frequent response status codes
4. Most frequent user agents

## Features

- **Zero dependencies**: uses only tools preinstalled on virtually every Linux and macOS system.
- **Single file**: one self-contained Bash script.
- **Quote-aware parsing**: handles request lines, referrers and user agents that contain spaces.
- **Input validation**: clear usage message and non-zero exit code on missing, invalid or unreadable files.
- **Streaming design**: reads the file in a pipeline rather than loading it into memory in a script variable.

## Requirements

| Requirement | Details |
|---|---|
| Shell | Bash 3.2 or newer (the default on Linux and macOS) |
| Utilities | `awk`, `sort`, `uniq`, `head` (POSIX standard; GNU or BSD variants both work) |
| Permissions | Read access to the log file |
| Log format | Nginx `combined` format (see [Input Format](#input-format)) |

No packages, runtimes or build steps are required.

## Installation

Clone or download the repository, then make the script executable:

```bash
git clone <repository-url>
cd nginx-log-analyser
chmod +x nginx-log-analyzer.sh
```

## Usage

```bash
./nginx-log-analyzer.sh /path/to/nginx/access.log
```

| Argument | Required | Description |
|---|---|---|
| `<logfile>` | Yes | Path to an Nginx access log file |

### Common recipes

Analyse the live log (reading `/var/log/nginx` usually requires elevated privileges):

```bash
sudo ./nginx-log-analyzer.sh /var/log/nginx/access.log
```


## Example Output

Output produced by running the tool against a real 7,606-line log:

```text
Top 5 IP addresses with the most requests:
45.76.135.253 - 1000 requests
142.93.143.8 - 600 requests
178.128.94.113 - 50 requests
43.224.43.187 - 30 requests
178.128.94.113 - 20 requests

Top 5 most requested paths:
/api/v1/users - 1000 requests
/api/v1/products - 600 requests
/api/v1/orders - 50 requests
/api/v1/payments - 30 requests
/api/v1/reviews - 20 requests

Top 5 response status codes:
200 - 1000 requests
404 - 600 requests
500 - 50 requests
401 - 30 requests
304 - 20 requests
```


## Error Handling and Exit Codes

| Condition | Behaviour | Exit code |
|---|---|---|
| Report generated successfully | Four reports printed to `stdout` | `0` |
| No argument supplied | Usage message printed to `stderr` | `1` |
| Path does not exist or is a directory | Usage message printed to `stderr` | `1` |
| File exists but is not readable | Usage message printed to `stderr` | `1` |

Example:

```console
$ ./nginx-log-analyzer.sh /does/not/exist.log
Usage: nginx-log-analyzer.sh /path/to/nginx/access.log
$ echo $?
1
```


## Troubleshooting

| Symptom | Likely cause | Resolution |
|---|---|---|
| `Permission denied` when running the script | Script is not executable | Run `chmod +x nginx-log-analyzer.sh`, or invoke with `bash nginx-log-analyzer.sh <file>`. |
| Usage message even though the file exists | File is unreadable by the current user, or the path is a directory | Check permissions with `ls -l`; use `sudo` for files under `/var/log/nginx`. |
| Empty or odd-looking sections | Log is not in `combined` format | Confirm the `log_format` in your Nginx configuration. |
| Paths look wrong or are missing | Many lines are malformed requests | Inspect the raw log; malformed lines are ignored in the path report by design. |

## Project Structure

```text
nginx-log-analyser/
├── nginx-log-analyzer.sh    # The analyser script
└── logfile.txt          
├── README.md          # Project documentation
```

## Author

**OPSBYNYIKO**