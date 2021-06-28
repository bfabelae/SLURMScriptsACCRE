#!/bin/bash
#SBATCH --mail-user=brenda.fabela.enriquez@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --exclusive
#SBATCH --time=5-00:00:00 
#SBATCH --job-name=newmssm_vbfsusy_staudom_mn2_300_mstau_275_mn1_250
#SBATCH --mem=0
#SBATCH --output=vbfsusyouts/newssm_vbfsusy_staudom_mn2_300_mstau_275_mn1_250.out

# Load the modules needed by MG5
source /etc/profile.d/lmod.sh
module load GCCcore/.8.2.0
module load GCC/8.2.0
module load Python/3.7.2

# Define your home directory:
home=/scratch/fabelab
homemg5=/scratch/fabelab/Madgraph/MG5_aMC_v3_1_0
# Enter the name of the <ProcDirectory>
procdirectory=VBFEWKinoStauDominated_full

# Make a directory where the output LHE file will be stored.
echo "Creating a directory where the output LHE file will be stored..."
mkdir -p /lio/lfs/cms/store/user/fabelab/vbfsusy2l/staudom_xsec/Events/newmssm_Run_${SLURM_JOBID}
echo "Done."

# Define a function that cleans up the area when the job is done
trap "rm -rf $localdir" EXIT

# Define a function that will clean up the area once the job is done or when the job fails
tmp_cleaner()
{
rm -rf ${localdir}
exit -1
}
trap 'tmp_cleaner' TERM

# Create a directory in the temporary file of the node where the job is running
echo "Creating a directory in the temporary are of the node where this job is running.."
localdir=/tmp/${procdirectory}_${SLURM_JOBID} # Define the name of your directory in /tmp
mkdir ${localdir} # Create a unique directory on the computer node 
echo "Done."

cd ${localdir} # Move to the directory
echo "Current directory: $PWD"

# Run program that reads/writes to/from local disk
echo "Copying home MG5 installation to this area..."
cp -r ${homemg5}/ ${localdir} # Enter the path to the MG5 directory
echo "Done."
echo "ls"
echo "$(ls)"
cd ${localdir}/MG5_aMC_v3_1_0/${procdirectory}/
echo "Current directory: $PWD"
# Launch the generation for that process, make sure your Cards are properly updated with the desired parameters. The name of the run takes the job ID number as its name. The -f option sets the answers to all questions to default.
echo "Starting event generation, Run_$SLURM_JOBID..."
./bin/generate_events Run_$SLURM_JOBID -f 
echo "Event generation finished."

# Once the sample is done, copy it to your home MG5 installation.
echo "ls"
echo "$(ls)"
echo "Copying output LHE file and banner to the home MG5 installation"
cp ${localdir}/MG5_aMC_v3_1_0/${procdirectory}/Events/Run_${SLURM_JOBID}/unweighted_events.lhe.gz /lio/lfs/cms/store/user/fabelab/vbfsusy2l/staudom_xsec/Events/newmssm_Run_${SLURM_JOBID}
cp ${localdir}/MG5_aMC_v3_1_0/${procdirectory}/Events/Run_${SLURM_JOBID}/*_banner.txt /lio/lfs/cms/store/user/fabelab/vbfsusy2l/staudom_xsec/Events/newmssm_Run_${SLURM_JOBID}
cp ${localdir}/MG5_aMC_v3_1_0/${procdirectory}/HTML/Run_${SLURM_JOBID}/results.html /lio/lfs/cms/store/user/fabelab/vbfsusy2l/staudom_xsec/Events/newmssm_Run_${SLURM_JOBID}

echo "Done."

echo "Job completed."
