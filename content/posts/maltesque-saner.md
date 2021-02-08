---
title: "MaLTeSQuE / SANER 2018"
date: 2018-05-09T15:06:32+02:00
draft: false
author: "Fabian Huch"
tags: [Software Analysis, Code Quality]
aliases:
    - /posts/2018-05-09-maltesque-saner/
summary: Talks and workshops I attended of the 25th conference on Software Analysis, Evaluation and Reengineering (SANER).
---
The 25th conference on Software Analysis, Evaluation and Reengineering (SANER) and its co-located workshops took place in the Italian city of Campobasso on March 20-23, 2018. Due to its remoteness, and train and flight delays, it wasn’t easy to reach, but the hospitability and the amazing food made well up for that.

Day 0 (workshop day)
The first day after the long journey started with different workshops. I participated in the workshop on machine learning techniques for software quality evaluation (MaLTeSQuE), presenting an [industrial evaluation of machine learning (ML) approaches for run-time anomaly detection](https://doi.org/10.1109/MALTESQUE.2018.8368453).

After several talks about advances in static code analysis (e.g. class-level defect prediction, prediction of branch coverage of automated tests, or code change prediction), Serge Demeyer hit the nerve with his keynote about “in vivo” software engineering (SE) research: SE research needs to be carried out in practice. For example, to obtain data about human-bot interaction, a student of his chair built a Stack Overflow bot to answer duplicate questions. When it pretended to be a human (the user [Joey Dorrani](https://stackoverflow.com/users/4461216/joey-dorrani)), it did quite well, with an average score – [but once it stated that it was a bot, other users hardly up-voted or accepted answers any more](http://doi.org/10.1145/2851581.2892311). At other times, cooperating with industry can be crucial to obtain relevant data.

My other main takeaway from the talk was the concept of mutation testing: To verify that passing tests would indeed fail at faulty code, they are run on a version of the code that is mutated so it contains errors. This way, test coverage can be measured as the ratio of passed mutations/killed mutations, which tells more about test quality than the percentage of lines covered. In the java world, [Pitest](http://pitest.org/) seemed to be the most popular tool for this – in an example project, it was very good at highlighting the parts of the code I hadn’t thoroughly tested with unit tests. Unfortunately, it was a bit hard to integrate into my gradle multi-module project (also couldn’t aggregate the reports), and there is no proper IntelliJ plugin yet. But apparently, there is a good [SonarQube plugin](https://github.com/VinodAnandan/sonar-pitest) out there (which does aggregate reports)!
Afterwards, some more tools and approaches were presented. As for the tools, [ConfigFile++](https://doi.org/10.1109/MALTESQUE.2018.8368457) uses ML to extract information about c/c++ configuration parameters from multiple sources and utilizes that information to enhance config file documentation. [PyID](https://doi.org/10.1109/MALTESQUE.2018.8368458) can detect type mismatches in Python documentation. Lastly, a model to predict code reusability was introduced.

## Day 1
The next day started with a keynote by Elmar Jürgens. Similar to the one of the previous day, his topic was also about putting research to practice. He outlined how the clone detection tool developed by the [CQSE](https://www.cqse.eu/en/) evolved from an “in vitro” approach to an “in vivo” solution – the run-once analysis didn’t help developers much at first, because it found too many clones that they knew about, but could not fix due to project specific reasons. It was much more successful when built upon an incremental analysis engine that could filter for newly introduced clones. Today, the tool is part of the [Teamscale](https://www.cqse.eu/en/products/teamscale/landing/) solution.

In the following talks, machine learning techniques still dominated the topics of presented papers. I was particularly impressed by the RENE 1 track, where past results were re-examined by other researchers. Verifying results seems especially important given the abundance of ML approaches, and in fact, two papers reported significantly lower performance than what was previously found. In one of the works, [the reason for this was an unrealistic evaluation setting](https://doi.org/10.1109/SANER.2018.8330264); in the other, [the model and data were not published, so a re-implementation had to be evaluated on a new data set](https://doi.org/10.1109/SANER.2018.8330262). It shows that it is crucial to make results reproducible in papers about ML approaches, e.g. by publishing model parameters and datasets.

Another interesting research topic on that day was automated program repair. As much as the technology is still in its infancy, the ability of automatically fixing simpler code issues overnight could greatly enhance productivity when developing.

## Day 2
A very passionate keynote from Jan Bosch about “a new digital business operating model” kicked off the following day. He outlined that a lot of products are becoming software products, since more and more functionality is done in software. This allows for faster release cycles: While in hardware development it can take several years until the next release, with continuous integration/continuous deployment, software release cycles can be as low as several weeks or days. The advantage of shorter cycles, in combination with collected user data, means that the usefulness of features that are in development can be judged early on, thus allowing businesses to focus on what is important to their users.

In the next research track, an approach to modeling complex software behavior using hierarchical recursive models caught my interest. From logging statements, the process hierarchy is made explicit; then, the resulting tree is processed to build a recursive model. The tool for this ([Statechart Workbench](https://svn.win.tue.nl/repos/prom/Packages/Statechart/)) was also presented in the tool demo afterwards, and although it was not that easy to use, its process visualizations were amazing – clear and well readable.

After the tool demo (that was far too short to be able to give all the tools proper credit here), and a binary analysis track, the banquet dinner rounded up the day.


## Day 3 
Peter Gromov from JetBrains started the last conference day with a very technical keynote about what distinguishes an IDE from a compiler. Among other things, IDEs need to understand broken code, whereas the compiler can simply give up. He outlined the different resulting challenges, and how to tackle them. For instance, the code model needs to be efficient enough to be re-built after each keystroke. In IntelliJ, the abstract syntax tree (AST) maps code fragments to their respective syntax tree element. In combination with an efficient symbol cache, only the AST for the current file has to be kept up-to-date – and AST elements can be evaluated individually, thus allowing to compile only valid ones. This example illustrates why the title “Compilers are sprinters – IDEs are marathoners” was very fitting for the keynote.

In the afterwards track about code smell detection, it was found that deep learning models, in particular convolutional neural networks, did not perform much better or even worse than traditional ML models. [But they required several days of computaton time for tuning compared to a few minutes](https://doi.org/10.1109/SANER.2018.8330265). I did not find those results too surprising given that in our work about anomaly detection, deep learning models only performed slightly better. When performing ML for software engineering topics, this is definitely something to keep in mind.

Finally, I want to highlight an innovative approach for unit tests in excel spreadsheets: The "[Spreadsheet Guardian](https://arxiv.org/abs/1612.03813)" tool allows to set assertions for calculations, which can prevent errors, especially in multi-user environments.

This concludes my report on SANER 2018 and its co-located workshops. For any questions or remarks, feel free to leave a comment.