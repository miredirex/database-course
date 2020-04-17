-- Enum
create type significance as enum ('primary', 'secondary', 'tertiary', 'other');

alter type significance owner to postgres;

-- Enum
create type hostility as enum ('protagonist', 'antagonist', 'neutral', 'other');

alter type hostility owner to postgres;

