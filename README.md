# docker-compose-zipline

while on ubuntu that was working for me, on centos i got issue with SSL, looks like we have to generate key size 2048 instead of 1024
https://github.com/jupyter/notebook/issues/507

Open a terminal via jupyter or via command line
>    docker exec -it \<containerid\> bash

Then issue following commands 
>    export QUANDL_API_KEY=<YOUR_QUANDL_API_KEY> <br>
>    zipline ingest <br>
>    zipline ingest -b quantopian-quandl <br>
    
We need SPY as bench mark data, see example in the notebook
try_zipline-local-succesfully-with-selected-universe
