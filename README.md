# Archiver

Script *modulare* per la copia di log su un server remoto.

## Configurazione

Il file di configurazione dovra' contenere i moduli da abilitare **protocol** e la loro configurazione

```
protocol:
  - ssh
remote:
  ssh:
    host: "localhost"
    user: archiver
    port: 2222
  generic:
    host: none
```

## Pattern

Il pattern o i file da copiare dovranno essere definiti in un file ```applicazione_di_esempio.yaml```. Dovranno seguire la sintassi yaml e contenere la hash **pattern** --> **include** --> e l'array dei pattern o file da gestire

```
pattern:
  include:
    - '/var/log/*/*.gz'
    - '/var/log/*/*.zip'
```

## Moduli

E' possibile implementare un nuovo modulo (es: copia file su Amazon S3...). Il modulo dovra' essere inserito nella dir ```modules/``` e dovra' avere le funzioni:


```
function nomemodulo_test {
}
```


```
function nomemodulo_config {
}
```


```
# Arg: path del file 
# Metodo per la copia dei file con il modulo corrente
function nomemodulo_copy {
}
```

.. tali metodi verranno chiamati dallo script nel modo seguente:

```
for i in ${config_protocol[*]}
do
  set -e
  ${i}_config 
  ${i}_test

  # Loop through list of files..
  for file in $(cat $temp); do ${i}_copy $file; done
done
```
