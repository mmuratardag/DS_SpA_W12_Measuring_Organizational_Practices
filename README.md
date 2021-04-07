# Week 12 Final / Graduation Project:

## Measuring Organizational Practices from Employee Reviews

This project was completed in the final week of the Data Science Bootcamp at Spiced Academy in Berlin.

This is a dictionary that measures organizational practices from employee reviews. The project has the following work-flow.

* __Collect / prep data / corpus__ --- Cheers to <a href="https://www.matthewchatham.com/" target="_blank">Matthew Chatham</a>
* __Explore data & obtain seed words__
	- Topic modeling
	- Joint Maximum Likelihood Estimation for High-Dimensional Item Factor Analysis
	- deep artificial neural network model: importance-weighted autoencoder for exploratory IFA --- Cheers to <a href="https://github.com/cjurban" target="_blank">Christopher J. Urban</a>
* __Build the dictionary with word2vec__ --- Cheers to <a href="https://academic.oup.com/rfs/advance-article-abstract/doi/10.1093/rfs/hhaa079/5869446?redirectedFrom=fulltext" target="_blank">Kai Li, Feng Mai, Rui Shen, Xinyan Yan</a>
* __Validate the dictionary__
	- Check for the pattern of correlations across train / test sets
		- Dictionary (saliency) scores & employee ratings
		- Repeat the step above with a different corpus
		- Dictionary (saliency) scores & topic sentiments (estimated with joint sentiment topic models) & regular sentiment scores
	- Check the associations between dictionary (saliency) scores & dimensions obtained with autoencoders
* __Visualizations__

## Disclaimer
This is an ___ongoing___ project, which may end up being a product. At this stage I'm sharing the dictionary as a .dic file in the LIWC format.

## TO-DO
* Explore  the associations with some ground truth
	- revenues / revenue %s for employee well-being
	- hiring & firing %s
	- ranking in global innovation index
	- etc.
* The current version is based on "employees talking about their companies" type of text data
	- collect & append "companies talking about themselves" type of text data for a more accurate picture of organizational culture

Presentation slides are available at
<a href="https://1drv.ms/p/s!AuQR1pEfkazyliMRvAgVAqcpZ9Ze?e=6k6kS7" target="_blank">https://1drv.ms/p/s!AuQR1pEfkazyliMRvAgVAqcpZ9Ze?e=6k6kS7</a>