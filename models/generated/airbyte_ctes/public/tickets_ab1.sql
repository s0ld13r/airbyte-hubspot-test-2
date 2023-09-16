{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_tickets') }}
select
    {{ json_extract_scalar('_airbyte_data', ['archived'], ['archived']) }} as archived,
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdat,
    {{ json_extract_string_array('_airbyte_data', ['companies'], ['companies']) }} as companies,
    {{ json_extract_string_array('_airbyte_data', ['deals'], ['deals']) }} as deals,
    {{ json_extract_scalar('_airbyte_data', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_string_array('_airbyte_data', ['contacts'], ['contacts']) }} as contacts,
    {{ json_extract('table_alias', '_airbyte_data', ['properties'], ['properties']) }} as properties,
    {{ json_extract_scalar('_airbyte_data', ['updatedAt'], ['updatedAt']) }} as updatedat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_tickets') }} as table_alias
-- tickets
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

