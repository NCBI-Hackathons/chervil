#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

baseCommand: chervil.sh

hints:
  DockerRequirement:
    dockerPull: benjamindlee/chervil

inputs:
  srr_accessions:
    type: File
    inputBinding:
      position: 1

  blast_database:
    label: main file is the .nhr
    type: File
    secondaryFiles:
      - ^.nin
      - ^.nog
      - ^.nsd
      - ^.nsi
      - ^.nsq
    inputBinding:
      valueFrom: $(self.basename)
      position: 2

  # sam_prefix:
  #   type: string
  #   inputBinding:
  #     position: 5

arguments:
  - valueFrom: $(runtime.cores)
    position: 3
  - valueFrom: $(runtime.outdir)/output
    position: 4
  - valueFrom: test
    position: 5

stdout:  chervil.log

outputs:
  log: stdout
