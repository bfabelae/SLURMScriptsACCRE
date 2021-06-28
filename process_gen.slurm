#!/bin/bash
#SBATCH --mail-user=brenda.fabela.enriquez@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=8
#SBATCH --exclusive
#SBATCH --time=5-00:00:00 
#SBATCH --job-name=processgen_vbfewkino_demslepton
#SBATCH --mem=0
#SBATCH --output=processgen_vbfewkino_demslepton.out

echo "Generating the following process (./bin/mg5_aMC) ..."

module load GCCcore/.8.2.0
module load GCC/8.2.0
module load Python/2.7.15

cd /scratch/fabelab/Madgraph/MG5_aMC_v2_6_7/
# ./bin/mg5_aMC vbf_susy_staudom_gen.sh  # This script includes the commands for the process to generate. They can be found in the proc_card_mg5.dat.
./bin/mg5_aMC vbfewkinodemocraticslepton_gen.sh

echo "Done."

