select __relational_items_result__.*
from (select 0 as idx, $1::"int4" as "id0") as __relational_items_identifiers__,
lateral (
  select
    __relational_items__."id"::text as "0",
    __relational_items__."type"::text as "1",
    __relational_items_identifiers__.idx as "2"
  from "polymorphic"."relational_items" as __relational_items__
  where (
    __relational_items__."id" = __relational_items_identifiers__."id0"
  )
) as __relational_items_result__;

select __relational_items_result__.*
from (select 0 as idx, $1::"int4" as "id0") as __relational_items_identifiers__,
lateral (
  select
    __relational_items__."id"::text as "0",
    __relational_items__."type"::text as "1",
    __relational_items_identifiers__.idx as "2"
  from "polymorphic"."relational_items" as __relational_items__
  where (
    __relational_items__."id" = __relational_items_identifiers__."id0"
  )
) as __relational_items_result__;

insert into "polymorphic"."relational_item_relations" as __relational_item_relations__ ("child_id", "parent_id") values ($1::"int4", $2::"int4") returning
  __relational_item_relations__."id"::text as "0",
  __relational_item_relations__."child_id"::text as "1",
  __relational_item_relations__."parent_id"::text as "2";

select __relational_items_result__.*
from (select 0 as idx, $1::"int4" as "id0") as __relational_items_identifiers__,
lateral (
  select
    __relational_items__."id"::text as "0",
    __relational_items__."type"::text as "1",
    __relational_items_identifiers__.idx as "2"
  from "polymorphic"."relational_items" as __relational_items__
  where (
    __relational_items__."id" = __relational_items_identifiers__."id0"
  )
) as __relational_items_result__;

select __relational_items_result__.*
from (select 0 as idx, $1::"int4" as "id0") as __relational_items_identifiers__,
lateral (
  select
    __relational_items__."id"::text as "0",
    __relational_items__."type"::text as "1",
    __relational_items_identifiers__.idx as "2"
  from "polymorphic"."relational_items" as __relational_items__
  where (
    __relational_items__."id" = __relational_items_identifiers__."id0"
  )
) as __relational_items_result__;

select __relational_posts_result__.*
from (select 0 as idx, $1::"int4" as "id0") as __relational_posts_identifiers__,
lateral (
  select
    __relational_posts__."post_item_id"::text as "0",
    __relational_posts_identifiers__.idx as "1"
  from "polymorphic"."relational_posts" as __relational_posts__
  where (
    __relational_posts__."post_item_id" = __relational_posts_identifiers__."id0"
  )
) as __relational_posts_result__;

select __relational_topics_result__.*
from (select 0 as idx, $1::"int4" as "id0") as __relational_topics_identifiers__,
lateral (
  select
    __relational_topics__."topic_item_id"::text as "0",
    __relational_topics_identifiers__.idx as "1"
  from "polymorphic"."relational_topics" as __relational_topics__
  where (
    __relational_topics__."topic_item_id" = __relational_topics_identifiers__."id0"
  )
) as __relational_topics_result__;