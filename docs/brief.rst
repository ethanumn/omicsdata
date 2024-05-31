
Examples
=========

Load an SSM file

.. code-block:: python

    from omicsdata.ssm.parse import load_ssm
    from omicsdata.ssm.colums import SSM_Columns

    data = load_ssm("example.ssm")
    for vid in list(data.keys()):
        print("id (%s) name (%s)" % (vid, data[vid][SSM_Columns.NAME]))


Writing *numpy* data to an archive

.. code-block:: python

    import numpy as np 
    from omicsdata.npz.archive import Archive

    # initialize archive
    data_archive = Archive("data_archive.npz")

    # write data to archive 
    data_archive.add("random", np.random.randn(10))

    # save the data archive
    data_archive.save() 


Convert an adjacency matrix to an ancestry matrix

.. code-block:: python

    import numpy as np
    from omicsdata.tree.adj import adj_to_anc 

    adjacency_matrix = np.eye(5)
    adjacency_matrix[1,2] = 1
    adjacency_matrix[2,3] = 1
    ancestry_matrix = adj_to_anc(adjacency_matrix)


Simple somatic mutation file
====================================

The simple somatic mutation (SSM) file format is a human-readable format that contain single nucleotide variant (SNV) data from bulk DNA sequencing.  The data for a simple somatic mutation file can be extracted from a *variant call format* (VCF) file (see `omicsdata/examples`. An alternative description of the SSM format can be found `here <https://www.sciencedirect.com/science/article/pii/S266616672200586X>`_.

The SSM file format is a tab-delimited format. The first line of an SSM file is the header containing the following columns: *id*, *name*, *var_reads*, *total_reads*, *var_read_prob*. Each subsequent line provides data for an individual SNV or *mutation*. Here is a description for each of these columns:

  * **id**: a unique identifier that must match the following regular expression *s\d+*. The numeric value in the *id* field does not need to be contiguous. For example, the first mutation in an SSM file can have an *id* of *s0*, the second mutation could have an *id* of *s1*, etc.  
  
  * **name**: a descriptive label for the mutation. The *name* value does not need to be unique. 

  * **var_reads**: a comma-separated vector of integers denoting how many reads mapped to a genomic locus containing the variant allele in each tissue sample. Each index in this comma-delimited vector represents the number variant reads in a specific sample. If for example the variant read count *Sample 1*, occurred in index 0 (the first element of the comma-delimited vector), then all data for *Sample 1* should occur in index 0 (e.g., for *total_reads*, *var_read-prob*). If a *parameter* file is being used, the order of the data for each sample should match the order of the *samples* key in the *parameter file*.

  * **total_reads**: a comma-separated vector of integers denoting the total number of reads that mapped to the genomic locus in each sample.

  * **var_read_prob**: a comma-separated vector of floats, where each float is the ratio of the population average copy number of the mutated genomic locus relative to the population average copy number of the genomic locus. If a mutation *j* occurred in a diploid region of the genome that had no copy number alterations, then it should be the case that there is 1 genomic locus containing the mutated allele, and 1 genomic locus containing the reference allele, such that the variant read probability for mutation *j* in the sample is *1/2*. If the mutation *j* occurred in a haploid region of the genome that had no copy number alterations, then the variant read probability for mutation *j* should be *1.0*. 


Parameter file 
====================================
A common input that accompanies an SSM file is a *parameter* file. A *parameter* file is a structured file containing key/value pairs. Here are some of the common key/value pairs that are used in a *parameter* file:

* **samples**: a list of sample names. These order of the sample names matters, as an accompanying SSM file should have the data for each sample occur in the same order.

* **clusters**: list-of-lists denoting mutations that are assumed to have co-occurred (i.e., each sublist is a *mutation cluster* or *subclone*).  Each sub-list need only to contain the mutation *id* value that it was given in the corresponding SSM file. 


Writing data archives
====================================
The *omicsdata.npz* has some basic utilities for compressing data. An *archive* is simply an alternative way to create a *gzip* to store numpy data. The *archive* class provides a few simple methods for read/writing numpy data to a *gzip*. Here' an example of how to write data to an *archive*

.. code-block:: python

    import numpy as np 
    from omicsdata.npz.archive import Archive

    # initialize archive
    data_archive = Archive("data_archive.npz")

    # write data to archive 
    data_archive.add("random", np.random.randn(10))

    # save the data archive
    data_archive.save() 


Here's an example of how to read data from an `archive`

.. code-block:: python

    import numpy as np 
    from omicsdata.npz.archive import Archive

    # initialize archive
    data_archive = Archive("data_archive.npz")

    # grabbed stored data
    random_data = data_archive.get("random")


Manipulating tree structures
====================================

The `omicsdata.tree` package contains some basic utilities for converting between datatypes that represent a tree. One basic use case is for converting from a *parents list*  to an *adjacency matrix*, then from an *adjacency matrix* to an *ancestry matrix*. Here is some example code to go from a parents list to an adjacency matrix:


.. code-block:: python

    import numpy as np 
    from omicsdata.tree.parents import parents_to_adj 

    parents_list = np.arange(0, 10)
    adjancency_matrix = parents_to_adj(parents_list)


And here is some example code to go from an adjacency matrix to an ancestry matrix:

.. code-block:: python

    import numpy as np
    from omicsdata.tree.adj import adj_to_anc 
    adjacency_matrix = np.eye(5)
    adjacency_matrix[1,2] = 1
    adjacency_matrix[2,3] = 1
    ancestry_matrix = adj_to_anc(adjacency_matrix)


We can also convert an adjacency matrix to a `Newick file format <https://en.wikipedia.org/wiki/Newick_format>`_:

.. code-block:: python

    import numpy as np
    from omicsdata.tree.newick import adj_to_newick 
    adjacency_matrix = np.eye(5)
    adjacency_matrix[1,2] = 1
    adjacency_matrix[2,3] = 1
    newick_string = adj_to_newick(adjacency_matrix)