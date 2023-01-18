token_ring_unidir: 
	spin -a token_ring_unidir.pml
	gcc -w -o pan_tru pan.c

token_ring_bidir: token_ring_bidir.pml
	spin -a token_ring_bidir.pml
	gcc -w -o pan_trb pan.c

clean:
	rm -rf pan.* pan_* *.trail *.tmp