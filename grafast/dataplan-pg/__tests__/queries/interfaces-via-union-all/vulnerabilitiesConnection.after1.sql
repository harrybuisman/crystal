select __union_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"float8" as "id0",
    (ids.value->>1)::"text" as "id1",
    (ids.value->>2)::"json" as "id2"
  from json_array_elements($1::json) with ordinality as ids
) as __union_identifiers__,
lateral (
  select
    __union__."0"::text as "0",
    __union__."1" as "1",
    __union__."2"::text as "2",
    __union_identifiers__.idx as "3"
  from (
      select
        __first_party_vulnerabilities__."0",
        __first_party_vulnerabilities__."1",
        __first_party_vulnerabilities__."2",
        "n"
      from (
        select
          __first_party_vulnerabilities__."cvss_score" as "0",
          'FirstPartyVulnerability' as "1",
          json_build_array((__first_party_vulnerabilities__."id")::text) as "2",
          row_number() over (
            order by
              __first_party_vulnerabilities__."cvss_score" asc,
              __first_party_vulnerabilities__."id" asc
          ) as "n"
        from interfaces_and_unions.first_party_vulnerabilities as __first_party_vulnerabilities__
        where (
          (__first_party_vulnerabilities__."cvss_score" > __union_identifiers__."id0")
          or (
            __first_party_vulnerabilities__."cvss_score" = __union_identifiers__."id0"
            and (
              ('FirstPartyVulnerability' > __union_identifiers__."id1")
              or (
                'FirstPartyVulnerability' = __union_identifiers__."id1"
                and (
                  __first_party_vulnerabilities__."id" > (__union_identifiers__."id2"->>0)::"int4"
                )
              )
            )
          )
        )
        order by
          __first_party_vulnerabilities__."cvss_score" asc,
          __first_party_vulnerabilities__."id" asc
        limit 2
      ) as __first_party_vulnerabilities__
    union all
      select
        __third_party_vulnerabilities__."0",
        __third_party_vulnerabilities__."1",
        __third_party_vulnerabilities__."2",
        "n"
      from (
        select
          __third_party_vulnerabilities__."cvss_score" as "0",
          'ThirdPartyVulnerability' as "1",
          json_build_array((__third_party_vulnerabilities__."id")::text) as "2",
          row_number() over (
            order by
              __third_party_vulnerabilities__."cvss_score" asc,
              __third_party_vulnerabilities__."id" asc
          ) as "n"
        from interfaces_and_unions.third_party_vulnerabilities as __third_party_vulnerabilities__
        where (
          (__third_party_vulnerabilities__."cvss_score" > __union_identifiers__."id0")
          or (
            __third_party_vulnerabilities__."cvss_score" = __union_identifiers__."id0"
            and (
              ('ThirdPartyVulnerability' > __union_identifiers__."id1")
              or (
                'ThirdPartyVulnerability' = __union_identifiers__."id1"
                and (
                  __third_party_vulnerabilities__."id" > (__union_identifiers__."id2"->>0)::"int4"
                )
              )
            )
          )
        )
        order by
          __third_party_vulnerabilities__."cvss_score" asc,
          __third_party_vulnerabilities__."id" asc
        limit 2
      ) as __third_party_vulnerabilities__
    order by
      "0" asc,
      "1" asc,
      "n" asc
    limit 2
  ) __union__
) as __union_result__;

select __first_party_vulnerabilities_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"int4" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __first_party_vulnerabilities_identifiers__,
lateral (
  select
    __first_party_vulnerabilities__."team_name" as "0",
    __first_party_vulnerabilities__."name" as "1",
    __first_party_vulnerabilities__."id"::text as "2",
    __first_party_vulnerabilities__."cvss_score"::text as "3",
    __first_party_vulnerabilities_identifiers__.idx as "4"
  from interfaces_and_unions.first_party_vulnerabilities as __first_party_vulnerabilities__
  where
    (
      true /* authorization checks */
    ) and (
      __first_party_vulnerabilities__."id" = __first_party_vulnerabilities_identifiers__."id0"
    )
  order by __first_party_vulnerabilities__."id" asc
) as __first_party_vulnerabilities_result__;

select __third_party_vulnerabilities_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"int4" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __third_party_vulnerabilities_identifiers__,
lateral (
  select
    __third_party_vulnerabilities__."vendor_name" as "0",
    __third_party_vulnerabilities__."name" as "1",
    __third_party_vulnerabilities__."id"::text as "2",
    __third_party_vulnerabilities__."cvss_score"::text as "3",
    __third_party_vulnerabilities_identifiers__.idx as "4"
  from interfaces_and_unions.third_party_vulnerabilities as __third_party_vulnerabilities__
  where
    (
      true /* authorization checks */
    ) and (
      __third_party_vulnerabilities__."id" = __third_party_vulnerabilities_identifiers__."id0"
    )
  order by __third_party_vulnerabilities__."id" asc
) as __third_party_vulnerabilities_result__;
