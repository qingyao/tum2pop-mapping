# tum2pop-mapping

Population origin mapping from cancer SNP profile into 5 continental groups as defined in 1000 Genomes Project. This tool supports mapping from B-allele frequency data generated with 9 Affymetrix SNP array platforms as input and a population assignment to one of the five continental groups -- AFR(_Africa_), EUR (_Europe_), AMR(_South America_), EAS (_East Asia_), SAS (_South Asia_). The currently supported genome version is GRCh37 (hg19). A mapping to other genome versions is planned.

## Docker version installation
The easiest way is to use docker application. First, install [Docker application](https://docs.docker.com/install/), then:
```
docker pull qingyao/tum2pop
```

## Usage
First, you would like to create a working directory `$hostdir` (use absolute path) to place your input files and to receive the output from the pipeline.
```
docker run -it --rm --mount type=bind,source=$hostdir,target=/data qingyao/tum2pop
```
After entering the interactive mode of the container, you can place your input files in `$hostdir/input` directory. Then:
```
Rscript --vanilla run_pop.r <parameters>
```
Then you will receive in the `/results` folder under `$hostdir` your mapping results.

### Example
You need to download the /test folder [here](https://github.com/qingyao/tum2pop-mapping/tree/master/test_data) and copy the absolute path as `$test_dir`.
```
docker run -it --rm --mount type=bind,source=$test_dir,target=/data qingyao/tum2pop
```

```
Rscript --vanilla run_pop.r -i BAF -o CONT -p Mapping250K_Nsp
```


## Options
  -i --input TEXT         input as B allele frequency file format (BAF), or genotype calling format (GC), or Birdseed genotype format (BS).

  -p --platform  TEXT     SNP array platform

  -o --output TEXT        output as 6 theoretical fractions (FRAC), or standard output as ratio of 5 continents and a voting result (CONT)

The current pipeline supports 9 SNP array platforms from Affymetrix:

- Mapping10K_Xba142

- Mapping50K_Hind240

- Mapping50K_Xba240

- Mapping250K_Nsp

- Mapping250K_Sty

- GenomeWideSNP_5

- GenomeWideSNP_6

- CytoScan750K_Array

- CytoScanHD_Array

The input file should be *tab separated*. There should be 4 columns: ID (SNP ID or simply indicating row number), chromosome (1-23), nucleotide base position, and a value column (a number within 0-1 if **BAF** format, or AA/AB/BB if **GC** format).

Example for **BAF** input format:

ID	CHRO	BASEPOS	VALUE

SNP_A-2131660	1	1220751	0.3487

SNP_A-1967418	1	2302812	0.9451

SNP_A-1969580	1	2398125	1.0000

SNP_A-4263484	1	2622185	0.4612

.

.

.

Example for **GC** input format:

ID	CHRO	BASEPOS	VALUE

SNP_1	1	1220751	AB

SNP_2	1	2302812	BB

SNP_3	1	2398125	BB

SNP_4	1	2622185	AB

.

.

.

Example for **BS** input format:

ID    CHRO    BASEPOS    VALUE

SNP_1    1    1220751    1

SNP_2    1    2302812    2

SNP_3    1    2398125    2

SNP_4    1    2622185    1

.

.

.
