Learning Smooth Pooling Regions
===============================

This code is used to re-produce results from [1] and [2]. You can execute 
the code by either MainSmallData.m or MainLargeScale.m. Note however that the 
latter needs much more computational time and storage space. By executing 
MainTransferFeatures you can reproduce the transfer results between two 
datasets. The source code is built on top of [3] and [4]. We also modified 
the source code provided with [3] and [4] for our purpose. We use 
modified [5] as the optimization method. For the purpose of the multilayer
perceptron's interpretation we have adopted code from [6]. The main file to 
modify is Configuration.m. However, it also contains some default values.
Questions should be sent to mmalinow@mpi-inf.mpg.de

How to execute the code? -- Short Version
=================================
We can execute the code with default parameters (they might not be the most 
optimal).
1. Small scale
a) Set paths (to local data, and to datasets) in Configuration.m
b) Run MainSmallScale.m

2. Large scale
a) Set paths (to local data, and to datasets) in Configuration.m
b) Run MainLargeScalePrepareInput.m 
c) Run TriangleCodingPoolingRegion.m on the cluster in parallel;
If cluster cannot be applicable use RunTriangleCodingPoolingSequential.m
d) Run MainLargeScaleClassification.m

How to execute the code? -- LongVersion
=================================
1. Small scale (no batch approximation)
a) Works well for smaller dictionaries as we don't use approximation by splitting into batches.
b) Check if all paths in Configuration.m are set correctly;
Be sure that all directories pointed by paths in b) exist
c) Set the working_dataset in Configuration.m. This gives the current dataset
that is used for the experiments.
d) Set dictionary_size in Configuration.m. This gives you dimensionality
of the features.
e) Run MainSmallScale.m script.

2. Large scale (with batch approximation);
a) Works well for bigger dictionaries as we use approximation by splitting into batches.
b) Check if all paths in Configuration.m are set correctly. All directories must also exist.
c) Set the working_dataset in Configuration.m. This gives the current dataset
that is used for the experiments.
d) Set dictionary_size in Configuration.m. This gives you dimensionality
of the features. Set also parts_size in Configuration.m
e) Set sizeSplitPart in SplitCodes.m to be the size of the batches.
By default it is set to 40.
Set also numCodes in SplitCodes.m to be the size of the original dictionary.
By default it is set to 1600.
f) Run MainLargeScalePrepareInput.m script.
g) Set variable original_dictionary_size in Configuration.m;
original_dictionary_size points out to the size of the original dictionary
- one before splitting.
h) Set dictionary_size for the size of the batches in Configuration.m. 
For instance dictionary_size = 40.
i) Run TriangleCodingPoolingRegions.m with different parts (argument currentPart
in TriangleCodingPoolingRegions.m). You can either use cluster and run
such script in parallel (embarrasingly parallel computations - preferable),
or by running the script RunTriangleCodingPoolingSequential.m in sequential
manner. Latter is not recommended.
j) Make sure that source_dataset in Configuration.m is empty.
k) Run MainLargeScaleClassification.m

3. Transfer features between datasets
a) We can transfer pooling regions between two datasets.
b) Check if all paths in Configuration.m are set correctly. All directories must also exist.
c) Run MainSmallScale.m or MainLargeScall.m depending if we want to transfer
features in the small or large scale setting. Run the script twice with 
working_dataset = CIFAR10 and working_dataset = CIFAR100 (Configuration.m).
d) Set source_dataset in Configuration.m to point to the source dataset that
we transfer from. Set working_dataset in Configuration.m to point to the 
target dataset. 
e) Set number of centroids (numCentroidsArray) and partsArray in ComputePooledFeaturesBetweenDatasets.m.
If partsArray are left empty then no approximation by splitting into batches is used.
If partsArray are not empty then you must set originalDictSize. Latter indicates
the size of the original dictionary (where the data split into parts originate from).
f) Set correspondingly originalDictSizeArr and partsSizeArr in 
TransferTriangleFeaturesSVM.m, or use values from Configuration.m.
g) Run MainTransferBetweenDatasets.m

4. Show the pooling regions
a) We can visualize learned pooling regions
b) Check if all paths in Configuration.m are set correctly. All directories must also exist.
c) Set the pooling layers to visualize in VizPoolingRegions.m
d) Set partsNo in VizPoolingRegions if we want to visualize a batch
number partsNo (used in approximation). If not then set partsNo = 0. 
e) Set working_dataset and dictionary_size in Configuration.m
f) If partsNo in VizPoolingRegions is non-zero then set original_dictionary_size
g) Run VizPoolingRegions.m script.

Notes:
=================================
1. The source code produces high dimensional features that are stored 
in hard-drive. Be sure to have enough storage space.
2. Fill in the Configuration.m file where you define the data sources.
3. You can speed up learning by setting up DATA_FRACTION in 
subsampled_composed_nn_sites_cost.m. There is a trade-off between the 
speed and accuracy, but setting DATA_FRACTION to 0.9 should give a 
significant speed-up without much loss in accuracy.
4. bias is harmful for the results when transfer is done - 
better be switched off (isBias = false); on the other hand may save time
when joint training is a goal - can be turned on (isBias = true).

Publications:
=================================
[1] M. Malinowski, and M. Fritz, 'Learning Smooth Pooling Regions for Visual Recognition', BMVC 2013 
[2] M. Malinowski, and M. Fritz, 'Learnable Pooling Regions for Image Classification', ICLR 2013: Workshop Track
[3] A. Coates and A. Y. Ng 'The Importance of Encoding Versus Training with Sparse Coding and Vector Quantization', ICML 2011
[4] A. Coates, H. Lee, and A. Y. Ng., 'An Analysis of Single-Layer Networks in Unsupervised Feature Learning', AISTATS 2011
[5] M. Schmidt, http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html
[6] http://deeplearning.stanford.edu/wiki/index.php/UFLDL_Tutorial
