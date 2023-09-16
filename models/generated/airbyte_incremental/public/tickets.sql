{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('tickets_scd') }}
select
    _airbyte_unique_key,
    archived as is_deleted,
    createdat as created_at,
    companies,
    deals,
    {{ adapter.quote('id') }},
    contacts,
    -- properties,
    subject,
    {{adapter.quote('content')}},
    updatedat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_tickets_hashid
from {{ ref('tickets_scd') }}
-- tickets from {{ source('public', '_airbyte_raw_tickets') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

