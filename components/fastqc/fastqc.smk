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
        shell:
            "fastqc -t {threads} -a {params.adapters} -o fastqc_raw/{input.fastq} 2>{log}