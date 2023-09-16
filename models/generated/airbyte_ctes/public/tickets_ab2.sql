{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('tickets_ab1') }}
select
    {{ cast_to_boolean('archived') }} as archived,
    cast({{ empty_string_to_null('createdat') }} as {{ type_timestamp_with_timezone() }}) as createdat,
    companies,
    deals,
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('id') }},
    contacts,
    cast(properties as {{ type_json() }}) as properties,
    cast({{ empty_string_to_null('updatedat') }} as {{ type_timestamp_with_timezone() }}) as updatedat,
    {{ json_extract_scalar('properties', ['subject'], ['subject']) }} as subject,
    {{ json_extract_scalar('properties', ['content'], ['content']) }} as {{ adapter.quote('content') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('tickets_ab1') }}
-- tickets
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

