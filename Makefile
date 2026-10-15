all: results/bioID-dotplot.pdf results/turbo-dotplot.pdf results/turbo-graph.pdf results/bioID-graph.pdf results/saint-bioID.xlsx results/saint-turbo.xlsx 

results/saint-bioID.RDS: data/bioID.RDS run-saint.R data/meta.RDS data/prey-mass.RDS
	Rscript run-saint.R $< $@
	
results/saint-turbo.RDS: data/turbo.RDS run-saint.R data/meta.RDS data/prey-mass.RDS
	Rscript run-saint.R $< $@

results/saint-bioID.xlsx: results/saint-bioID.RDS make-xlsx.R
	Rscript make-xlsx.R $< $@

results/saint-turbo.xlsx: results/saint-turbo.RDS make-xlsx.R
	Rscript make-xlsx.R $< $@

results/bioID-dotplot.pdf: results/saint-bioID.RDS make-dotplot.R
	Rscript make-dotplot.R $< $@ 8 12

results/turbo-dotplot.pdf: results/saint-turbo.RDS make-dotplot.R
	Rscript make-dotplot.R $< $@ 4 12

results/bioID-graph.dot: results/saint-bioID.RDS make-dot.R
	Rscript make-dot.R $< $@
	
results/turbo-graph.dot: results/saint-turbo.RDS make-dot.R
	Rscript make-dot.R $< $@

results/bioID-graph.pdf: results/bioID-graph.dot
	neato -Tpdf $< > $@
	
results/turbo-graph.pdf: results/turbo-graph.dot
	neato -Tpdf $< > $@

clean:
	rm results/*

.PHONY: clean
