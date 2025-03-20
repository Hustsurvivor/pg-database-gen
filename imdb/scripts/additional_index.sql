-- Balsa adds two additional indexes to IMDB/JO compared to the ones provided by https://github.com/gregrahn/join-order-benchmark/blob/master/fkindexes.sql
create index subject_id_complete_cast on complete_cast(subject_id);
create index status_id_complete_cast on complete_cast(status_id);