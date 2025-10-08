# fix env address to the root - to ensure that Snakemake looks for env yaml in the correct place
from pathlib import Path
ENV_DIR = Path(workflow.basedir) / "envs"

rule bwa_mem2:
    input:
        r1 = "DNA_samples/{sample}_1.fastq.gz", 
        r2 = "DNA_samples/{sample}_2.fastq.gz"
    output:
        bam = "bwa_mem/{sample}.bam"
        bai = "bwa_mem/{sample}.bam.bai"
    log:
        "logs/bwa_mem/{sample}.bam.log"
    params:
        rg  = lambda wc: "@RG\\tID:{s}\\tSM:{s}\\tPL:ILLUMINA\\tLB:lib1".format(s=wc.sample)
        bwa_core_n=8,
        sam_core_n=2,
        sort_mem_per_thread_mb = XXX
        ref = config["references"]["GRCh38"]
    threads: 10
    resources:
        mem_mb = 25000
    conda:
        str(ENV_DIR / "envs/bwa_mem2.yml")
    shell:
        '''
        bwa-mem2 mem -t {threads} -R {params.rg} {params.ref} {input.r1} {input.r2} 2> {log} \
        | samtools sort -@ {threads} -m {params.sort_mem_per_thread_mb}M -o {output.bam} 2>> {log}
        samtools index -@ {threads} {output.bam} 2>> {log}
        '''