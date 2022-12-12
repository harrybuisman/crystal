select
  (select json_agg(_) from (
    select
      (count(*))::text as "0"
    from app_public.messages as __messages__
    where
      (
        __messages__.archived_at is null
      ) and (
        __forums__."id"::"uuid" = __messages__."forum_id"
      )
  ) _) as "0",
  (select json_agg(_) from (
    select
      __messages__."id" as "0",
      __users__."gravatar_url" as "1",
      __users__."username" as "2",
      __messages__."body" as "3"
    from app_public.messages as __messages__
    left outer join app_public.users as __users__
    on (__messages__."author_id"::"uuid" = __users__."id")
    where
      (
        __messages__.archived_at is null
      ) and (
        __forums__."id"::"uuid" = __messages__."forum_id"
      )
    order by __messages__."id" desc
    limit 3
  ) _) as "1",
  __forums__."name" as "2"
from app_public.forums as __forums__
where (
  true /* authorization checks */
)
order by __forums__."id" asc
limit 2;
