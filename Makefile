SHELL := /bin/bash
TEMPLATE = "https://raw.githubusercontent.com/tajmone/pandoc-goodies/2e29e9cd54bb9113c0b4fb474a07b8fcf6ee287b/templates/html5/github/GitHub.html5"

report/report.html: README.md report/GitHub.html5 report/frame.png report/drag.png report/wheel.png
	mkdir -p report && pandoc README.md --template report/GitHub.html5 --self-contained --toc --toc-depth 3 -r markdown+yaml_metadata_block -t html -s -o report/report.html
report/GitHub.html5:
	mkdir -p report && rm -f report/GitHub.html5 && wget $(TEMPLATE) -O report/GitHub.html5
clean:
	rm -rf report
report/frame.png: cad/frame.scad cad/main.scad
	openscad --render --imgsize 1600,1200 -o report/frame.png cad/frame.scad
report/drag.png: cad/drag.scad cad/main.scad
	openscad --render --imgsize 1600,1200 -o report/drag.png cad/drag.scad
report/wheel.png: cad/wheel.scad cad/main.scad
	openscad --render --imgsize 1600,1200 --camera 0,0,0,40,0,25,240 -o report/wheel.png cad/wheel.scad
