process SPLITBAM {
    tag "$meta.id"

    container (workflow.containerEngine ? "merszym/splitbam:v0.1.6" : null)

    input:
    tuple val(meta), path(bam), path(by)

    output:
    tuple val(meta), path("*.bam")              , emit: bams
    tuple val(meta), path('splittingstats.txt') , emit: stats
    path "versions.yml"                         , emit: versions

    script:
    """
    splitbam -s -c 0 -f ${by} --minscore 10 --maxnumber 0 ${bam} > splittingstats.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        splitbam: \$(splitbam --version)
    END_VERSIONS
    """
}