SHELL := /bin/bash
TEMPLATE = "https://raw.githubusercontent.com/tajmone/pandoc-goodies/2e29e9cd54bb9113c0b4fb474a07b8fcf6ee287b/templates/html5/github/GitHub.html5"
.PHONY: clean
.PHONY: articlepdf

articlepdf: article/article.pdf

report/report.html: README.md report/GitHub.html5 renderings/frame.png renderings/drag.png renderings/wheel.png report/generated report/stl | report
	pandoc README.md --template report/GitHub.html5 --resource-path=assets:renderings --self-contained --toc --toc-depth 4 -r markdown+yaml_metadata_block+footnotes+pipe_tables -t html -s -o report/report.html
article/article.pdf: renderings/frame.png renderings/drag.png renderings/wheel.png report/generated report/stl article/references.bib article/article.tex schematics/bluehunters-robot.png schematics/bluehunters-sdb.png | article
	cd article && latexmk -pdf article.tex
report/GitHub.html5: | report
	rm -f report/GitHub.html5 && wget $(TEMPLATE) -O report/GitHub.html5
clean:
	rm -rf report
	rm -rf jng55_zd53_jgc232.zip
	rm -rf renderings
	rm -rf generated
	cd article && latexmk -c && rm -f article.pdf
renderings/frame.png: cad/frame.scad cad/main.scad | renderings
	openscad --render --imgsize 1600,1200 -o renderings/frame.png cad/frame.scad
renderings/drag.png: cad/drag.scad cad/main.scad | renderings
	openscad --render --imgsize 1600,1200 -o renderings/drag.png cad/drag.scad
renderings/wheel.png: cad/wheel.scad cad/main.scad | renderings
	openscad --render --imgsize 1600,1200 --camera 0,0,0,40,0,25,240 -o renderings/wheel.png cad/wheel.scad
report/generated: report/GitHub.html5 ble.X/$(wildcard *.c) ble.X/$(wildcard *.h) cad/$(wildcard *.scad) generate_source_pages.sh
	./generate_source_pages.sh
report/stl: cad/$(wildcard *.stl)
	mkdir -p report/stl
	cp cad/*.stl report/stl
report:
	mkdir -p $@
renderings:
	mkdir -p $@
article:
	mkdir -p $@
zip: jng55_zd53_jgc232.zip
jng55_zd53_jgc232.zip: report/report.html
	rm -rf jng55_zd53_jgc232
	mkdir jng55_zd53_jgc232
	cp -r report/* jng55_zd53_jgc232/
	zip -r jng55_zd53_jgc232.zip jng55_zd53_jgc232/
	rm -rf jng55_zd53_jgc232
