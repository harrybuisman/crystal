select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"inet" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    __network__."macaddr8"::text as "0",
    __network__."macaddr"::text as "1",
    __network__."cidr"::text as "2",
    __network__."inet"::text as "3",
    __network__."id"::text as "4",
    __network_identifiers__.idx as "5"
  from "pg11"."network" as __network__
  where (
    __network__."inet" = __network_identifiers__."id0"
  )
  order by __network__."id" asc
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"inet" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    (count(*))::text as "0",
    __network_identifiers__.idx as "1"
  from "pg11"."network" as __network__
  where (
    __network__."inet" = __network_identifiers__."id0"
  )
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"cidr" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    __network__."macaddr8"::text as "0",
    __network__."macaddr"::text as "1",
    __network__."cidr"::text as "2",
    __network__."inet"::text as "3",
    __network__."id"::text as "4",
    __network_identifiers__.idx as "5"
  from "pg11"."network" as __network__
  where (
    __network__."cidr" = __network_identifiers__."id0"
  )
  order by __network__."id" asc
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"cidr" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    (count(*))::text as "0",
    __network_identifiers__.idx as "1"
  from "pg11"."network" as __network__
  where (
    __network__."cidr" = __network_identifiers__."id0"
  )
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"macaddr" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    __network__."macaddr8"::text as "0",
    __network__."macaddr"::text as "1",
    __network__."cidr"::text as "2",
    __network__."inet"::text as "3",
    __network__."id"::text as "4",
    __network_identifiers__.idx as "5"
  from "pg11"."network" as __network__
  where (
    __network__."macaddr" = __network_identifiers__."id0"
  )
  order by __network__."id" asc
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"macaddr" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    (count(*))::text as "0",
    __network_identifiers__.idx as "1"
  from "pg11"."network" as __network__
  where (
    __network__."macaddr" = __network_identifiers__."id0"
  )
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"macaddr8" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    __network__."macaddr8"::text as "0",
    __network__."macaddr"::text as "1",
    __network__."cidr"::text as "2",
    __network__."inet"::text as "3",
    __network__."id"::text as "4",
    __network_identifiers__.idx as "5"
  from "pg11"."network" as __network__
  where (
    __network__."macaddr8" = __network_identifiers__."id0"
  )
  order by __network__."id" asc
) as __network_result__;

select __network_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"macaddr8" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __network_identifiers__,
lateral (
  select
    (count(*))::text as "0",
    __network_identifiers__.idx as "1"
  from "pg11"."network" as __network__
  where (
    __network__."macaddr8" = __network_identifiers__."id0"
  )
) as __network_result__;