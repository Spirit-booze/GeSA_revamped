# fix env address to the root - to ensure that Snakemake looks for env yaml in the correct place
from pathlib import Path
ENV_DIR = Path(workflow.basedir) / "envs"

# fastqc rule

rule fastqc_raw:
    input:
        fastq="DNA_fastq/{sample}fastq.gz"
    output:
        "fastqc_raw/{sample}_fastqc.html"
        "fastqc_raw/{sample}_fastqc_fastqc.zip"
    log:
        "logs/fastqc_raw/{sample}_fastqc.log"
    params:
        queue="shortq"
        adapters=config["fastqc"]["adapters"]
    threads: 4
    resources:
        mem_mb=25600
    conda: 
        str(ENV_DIR / "fastqc.yml")
    shell:
            "fastqc -t {threads} -a {params.adapters} -o fastqc_raw/{input.fastq} 2>{log}