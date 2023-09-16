{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('tickets_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        boolean_to_string('archived'),
        'createdat',
        array_to_string('companies'),
        array_to_string('deals'),
        adapter.quote('id'),
        array_to_string('contacts'),
        object_to_string('properties'),
        'updatedat',
        'subject',
         adapter.quote('content'),
    ]) }} as _airbyte_tickets_hashid,
    tmp.*
from {{ ref('tickets_ab2') }} tmp
-- tickets
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

