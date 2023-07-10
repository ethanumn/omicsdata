# grab script path under the assumption the vcf_to_ssm and example.vcf are in the same directory
script_path=$(dirname "$(realpath $0)")

# run vcf_to_ssm on example vcf
python3 $script_path/vcf_to_ssm $script_path/example.vcf $script_path/example.ssm -p $script_path/example.params.json 