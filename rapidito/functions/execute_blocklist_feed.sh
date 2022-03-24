#!/bin/sh
exct_blklst(){
	
source ./config/init.rap

feed_source_blocklist="https://s3.i02.estaleiro.serpro.gov.br/blocklist/blocklist.txt"
feed_blocklist_from_src $feed_source_blocklist
}