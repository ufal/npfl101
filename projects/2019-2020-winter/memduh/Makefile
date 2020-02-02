EN_TO_36=en-to-36
37_to_37=37-to-37


all: $(EN_TO_36) $(37_TO_37)

$(EN_TO_36) $(37_TO_37):
	mkdir -p data
	wget -e robots=off -r --no-parent --reject "index.html*" --user=elitr2021 --password=rotunda http://data.statmt.org/elitr/uedin-models/37-to-37/ 
	wget -e robots=off -r --no-parent --reject "index.html*" --user=elitr2021 --password=rotunda http://data.statmt.org/elitr/uedin-models/en-to-36/
