DO $$
BEGIN
    CREATE TYPE public.month_name_enum AS ENUM (
        'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
        'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    );

    CREATE SEQUENCE public.seq_dim_quarters;

    CREATE TABLE public.dim_quarters (
        id bigint primary key DEFAULT nextval('public.seq_dim_quarters'),
        quarter_number integer NOT NULL UNIQUE CHECK (quarter_number BETWEEN 1 AND 4),
        quarter_name text NOT NULL
    );

    COMMENT ON TABLE public.dim_quarters IS 'Номера и названия календарных кварталов';

    INSERT INTO public.dim_quarters (quarter_number, quarter_name)
    VALUES (1, 'I квартал'),
           (2, 'II квартал'),
           (3, 'III квартал'),
           (4, 'IV квартал');

    CREATE SEQUENCE public.seq_dim_time;

    CREATE TABLE public.dim_time (
        id bigint primary key DEFAULT nextval('public.seq_dim_time'),
        code integer NOT NULL UNIQUE,
        month_start date NOT NULL,
        month_end date NOT NULL CHECK (month_end >= month_start),
        month_name public.month_name_enum NOT NULL,
        year integer NOT NULL,
        quarter_id bigint NOT NULL REFERENCES public.dim_quarters (id)
    );

    COMMENT ON TABLE public.dim_time IS 'Месячный календарь';
END;
$$;
