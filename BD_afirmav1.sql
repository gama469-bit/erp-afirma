--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2026-02-04 15:19:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 259 (class 1255 OID 41118)
-- Name: update_equipment_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_equipment_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_equipment_updated_at() OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 24983)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 24793)
-- Name: areas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.areas (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.areas OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24792)
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.areas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.areas_id_seq OWNER TO postgres;

--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 234
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.areas_id_seq OWNED BY public.areas.id;


--
-- TOC entry 219 (class 1259 OID 24601)
-- Name: candidates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.candidates (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    position_applied character varying(100) NOT NULL,
    status character varying(50) DEFAULT 'En revisión'::character varying,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.candidates OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24600)
-- Name: candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.candidates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.candidates_id_seq OWNER TO postgres;

--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 218
-- Name: candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.candidates_id_seq OWNED BY public.candidates.id;


--
-- TOC entry 239 (class 1259 OID 24825)
-- Name: cells; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cells (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    area_id integer,
    project_id integer,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cells OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 24824)
-- Name: cells_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cells_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cells_id_seq OWNER TO postgres;

--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 238
-- Name: cells_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cells_id_seq OWNED BY public.cells.id;


--
-- TOC entry 243 (class 1259 OID 24926)
-- Name: contract_schemes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract_schemes (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contract_schemes OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 24925)
-- Name: contract_schemes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_schemes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contract_schemes_id_seq OWNER TO postgres;

--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 242
-- Name: contract_schemes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_schemes_id_seq OWNED BY public.contract_schemes.id;


--
-- TOC entry 245 (class 1259 OID 24938)
-- Name: contract_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract_types (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contract_types OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 24937)
-- Name: contract_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contract_types_id_seq OWNER TO postgres;

--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 244
-- Name: contract_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_types_id_seq OWNED BY public.contract_types.id;


--
-- TOC entry 221 (class 1259 OID 24614)
-- Name: entities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entities (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    manager_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.entities OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24613)
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO postgres;

--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 220
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.entities.id;


--
-- TOC entry 229 (class 1259 OID 24709)
-- Name: emergency_contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emergency_contacts (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    contact_name character varying(100) NOT NULL,
    relationship character varying(50),
    phone character varying(20) NOT NULL,
    email character varying(120),
    address text,
    priority integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.emergency_contacts OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24708)
-- Name: emergency_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.emergency_contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.emergency_contacts_id_seq OWNER TO postgres;

--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 228
-- Name: emergency_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.emergency_contacts_id_seq OWNED BY public.emergency_contacts.id;


--
-- TOC entry 227 (class 1259 OID 24691)
-- Name: employee_audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_audit_log (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    action character varying(50) NOT NULL,
    field_name character varying(100),
    old_value text,
    new_value text,
    changed_by character varying(100),
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_audit_log OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24690)
-- Name: employee_audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_audit_log_id_seq OWNER TO postgres;

--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 226
-- Name: employee_audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_audit_log_id_seq OWNED BY public.employee_audit_log.id;


--
-- TOC entry 241 (class 1259 OID 24907)
-- Name: employee_banking_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_banking_info (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    bank_name character varying(255) NOT NULL,
    account_holder_name character varying(255) NOT NULL,
    account_number character varying(50) NOT NULL,
    clabe_interbancaria character varying(18),
    clabe_document_path character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_banking_info OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 24906)
-- Name: employee_banking_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_banking_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_banking_info_id_seq OWNER TO postgres;

--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 240
-- Name: employee_banking_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_banking_info_id_seq OWNED BY public.employee_banking_info.id;


--
-- TOC entry 247 (class 1259 OID 24950)
-- Name: employee_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_contracts (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    contract_type_id integer,
    obra character varying(255),
    contract_document_path character varying(500),
    contract_scheme_id integer,
    initial_rate numeric(12,2),
    gross_monthly_salary numeric(12,2),
    net_monthly_salary numeric(12,2),
    company_cost numeric(12,2),
    start_date date,
    end_date date,
    termination_reason text,
    is_rehireable boolean DEFAULT true,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_contracts OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 24949)
-- Name: employee_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_contracts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_contracts_id_seq OWNER TO postgres;

--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 246
-- Name: employee_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_contracts_id_seq OWNED BY public.employee_contracts.id;


--
-- TOC entry 231 (class 1259 OID 24727)
-- Name: employee_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_documents (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    document_type character varying(100),
    document_number character varying(50),
    issue_date date,
    expiry_date date,
    document_file_path character varying(255),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_documents OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24726)
-- Name: employee_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_documents_id_seq OWNER TO postgres;

--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 230
-- Name: employee_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_documents_id_seq OWNED BY public.employee_documents.id;


--
-- TOC entry 255 (class 1259 OID 49617)
-- Name: employee_vacations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_vacations (
    id integer NOT NULL,
    employee_name character varying(255) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status character varying(32) DEFAULT 'Pendiente'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    employee_id integer,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_vacations OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 49616)
-- Name: employee_vacations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_vacations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_vacations_id_seq OWNER TO postgres;

--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 254
-- Name: employee_vacations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_vacations_id_seq OWNED BY public.employee_vacations.id;


--
-- TOC entry 253 (class 1259 OID 49310)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    "position" character varying(100),
    start_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 49309)
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO postgres;

--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 252
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- TOC entry 225 (class 1259 OID 24648)
-- Name: employees_v2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees_v2 (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(120) NOT NULL,
    phone character varying(20),
    personal_phone character varying(20),
    employee_code character varying(20),
    position_id integer,
    entity_id integer,
    hire_date date DEFAULT CURRENT_DATE NOT NULL,
    start_date date,
    birth_date date,
    address character varying(255),
    city character varying(100),
    state character varying(100),
    postal_code character varying(10),
    country character varying(100) DEFAULT 'Colombia'::character varying,
    employment_type character varying(50) DEFAULT 'Permanente'::character varying,
    contract_end_date date,
    status character varying(50) DEFAULT 'Activo'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(100),
    updated_by character varying(100),
    area_id integer,
    project_id integer,
    cell_id integer,
    address_street character varying(255),
    address_city character varying(100),
    address_state character varying(100),
    address_postal_code character varying(20),
    address_country character varying(100) DEFAULT 'México'::character varying,
    exterior_number character varying(10),
    interior_number character varying(10),
    colonia character varying(100),
    curp character varying(18),
    rfc character varying(13),
    nss character varying(11),
    passport character varying(20),
    gender character varying(20),
    marital_status character varying(20),
    nationality character varying(50),
    blood_type character varying(5),
    CONSTRAINT hire_date_not_future CHECK ((hire_date <= CURRENT_DATE)),
    CONSTRAINT valid_email CHECK (((email)::text ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'::text)),
    CONSTRAINT valid_employment_type CHECK (((employment_type)::text = ANY ((ARRAY['Permanente'::character varying, 'Temporal'::character varying, 'Contratista'::character varying])::text[]))),
    CONSTRAINT valid_phone CHECK (((phone IS NULL) OR ((phone)::text ~ '^[0-9\-\+\(\)]{7,}$'::text))),
    CONSTRAINT valid_status CHECK (((status)::text = ANY ((ARRAY['Activo'::character varying, 'Inactivo'::character varying, 'En licencia'::character varying, 'Suspendido'::character varying])::text[])))
);


ALTER TABLE public.employees_v2 OWNER TO postgres;

--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.exterior_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.exterior_number IS 'Número exterior del domicilio';


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.interior_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.interior_number IS 'Número interior del domicilio (apartamento, depto, etc.)';


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.colonia; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.colonia IS 'Colonia, barrio o fraccionamiento';


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.curp; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.curp IS 'Clave Única de Registro de Población';


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.rfc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.rfc IS 'Registro Federal de Contribuyentes';


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.nss; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.nss IS 'Número de Seguro Social';


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.passport; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.passport IS 'Número de pasaporte';


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.gender IS 'Género del empleado';


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.marital_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.marital_status IS 'Estado civil';


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.nationality; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.nationality IS 'Nacionalidad';


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN employees_v2.blood_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employees_v2.blood_type IS 'Tipo de sangre';


--
-- TOC entry 224 (class 1259 OID 24647)
-- Name: employees_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_v2_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_v2_id_seq OWNER TO postgres;

--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 224
-- Name: employees_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_v2_id_seq OWNED BY public.employees_v2.id;


--
-- TOC entry 251 (class 1259 OID 41096)
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    id integer NOT NULL,
    codigo character varying(50) NOT NULL,
    nombre character varying(255) NOT NULL,
    marca character varying(100),
    modelo character varying(100),
    serie character varying(100),
    categoria character varying(100) NOT NULL,
    ubicacion character varying(255),
    asignado_id integer,
    estado character varying(50) DEFAULT 'Activo'::character varying,
    valor numeric(10,2),
    fecha_compra date,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 41095)
-- Name: equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_id_seq OWNER TO postgres;

--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 250
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;


--
-- TOC entry 249 (class 1259 OID 24987)
-- Name: mastercode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mastercode (
    id integer NOT NULL,
    lista character varying(50) NOT NULL,
    item character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mastercode OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 24986)
-- Name: mastercode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mastercode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mastercode_id_seq OWNER TO postgres;

--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 248
-- Name: mastercode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mastercode_id_seq OWNED BY public.mastercode.id;


--
-- TOC entry 223 (class 1259 OID 24628)
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    entity_id integer,
    salary_min numeric(10,2),
    salary_max numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24627)
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.positions_id_seq OWNER TO postgres;

--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 222
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- TOC entry 257 (class 1259 OID 49765)
-- Name: project_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_assignments (
    id integer NOT NULL,
    project_id integer NOT NULL,
    employee_id integer NOT NULL,
    role character varying(100),
    start_date date,
    end_date date,
    hours_allocated numeric(5,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.project_assignments OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 49764)
-- Name: project_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.project_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_assignments_id_seq OWNER TO postgres;

--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 256
-- Name: project_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.project_assignments_id_seq OWNED BY public.project_assignments.id;


--
-- TOC entry 237 (class 1259 OID 24806)
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    area_id integer,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24805)
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO postgres;

--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 236
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- TOC entry 233 (class 1259 OID 24745)
-- Name: salary_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salary_history (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    salary_amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'COP'::character varying,
    effective_date date NOT NULL,
    reason character varying(255),
    notes text,
    created_by character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.salary_history OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24744)
-- Name: salary_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salary_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salary_history_id_seq OWNER TO postgres;

--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 232
-- Name: salary_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salary_history_id_seq OWNED BY public.salary_history.id;


--
-- TOC entry 217 (class 1259 OID 16396)
-- Name: sge_ots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sge_ots (
    "Número OT" character varying(50) NOT NULL,
    "Folio Principal Santec" character varying(50),
    "Folio Santec" character varying(50),
    "Nombre Proyecto" character varying(255),
    "Estado" character varying(50),
    "Descripción" text,
    "Tipo Servicio" character varying(50),
    "Tecnología" character varying(100),
    "Aplicativo" character varying(100),
    "Fecha Inicio Santander" date,
    "Fecha Fin Santander" date,
    "Fecha Inicio Proveedor" date,
    "Fecha Fin Proveedor" date,
    "Hras. Acordadas" numeric(10,2),
    "Semáforo de Esfuerzo" character varying(50),
    "Semáforo de Plazo" character varying(50),
    "Líder Delivery" character varying(100),
    "Autorización RdP" character varying(3),
    "Responsable de Proyecto" character varying(100),
    "CBT Responsable" character varying(100),
    "Proveedor" character varying(100),
    "Fecha Inicio Real" date,
    "Fecha Fin Real" date,
    "Fecha Entrega Proveedor" date,
    "Días Desvío Entrega" integer,
    "Ambiente" character varying(100),
    "Fecha Creación" date,
    "FT's" numeric(10,2),
    "Estimación e-Lab + Pruebas" character varying(50),
    "Costo por hora del Servicio (Proveedor)" numeric(15,2),
    "Monto del Servicio (Proveedor)" numeric(15,2),
    "Monto del Servicio (Proveedor) con IVA" numeric(15,2),
    "Clase de Coste" character varying(100),
    "Folio PdS" character varying(50),
    "Programa" character varying(255),
    "Front de Negocio" character varying(100),
    "VoBo Front de Negocio" character varying(50),
    "Fecha VoBo Front de Negocio" date
);


ALTER TABLE public.sge_ots OWNER TO postgres;

--
-- TOC entry 4872 (class 2604 OID 24796)
-- Name: areas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas ALTER COLUMN id SET DEFAULT nextval('public.areas_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 24604)
-- Name: candidates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates ALTER COLUMN id SET DEFAULT nextval('public.candidates_id_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 24828)
-- Name: cells id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cells ALTER COLUMN id SET DEFAULT nextval('public.cells_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 24929)
-- Name: contract_schemes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_schemes ALTER COLUMN id SET DEFAULT nextval('public.contract_schemes_id_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 24941)
-- Name: contract_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_types ALTER COLUMN id SET DEFAULT nextval('public.contract_types_id_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 24712)
-- Name: emergency_contacts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emergency_contacts ALTER COLUMN id SET DEFAULT nextval('public.emergency_contacts_id_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 24694)
-- Name: employee_audit_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_audit_log ALTER COLUMN id SET DEFAULT nextval('public.employee_audit_log_id_seq'::regclass);


--
-- TOC entry 4878 (class 2604 OID 24910)
-- Name: employee_banking_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_banking_info ALTER COLUMN id SET DEFAULT nextval('public.employee_banking_info_id_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 24953)
-- Name: employee_contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_contracts ALTER COLUMN id SET DEFAULT nextval('public.employee_contracts_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 24730)
-- Name: employee_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_documents ALTER COLUMN id SET DEFAULT nextval('public.employee_documents_id_seq'::regclass);


--
-- TOC entry 4900 (class 2604 OID 49620)
-- Name: employee_vacations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_vacations ALTER COLUMN id SET DEFAULT nextval('public.employee_vacations_id_seq'::regclass);


--
-- TOC entry 4898 (class 2604 OID 49313)
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 24651)
-- Name: employees_v2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2 ALTER COLUMN id SET DEFAULT nextval('public.employees_v2_id_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 24617)
-- Name: entities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 41099)
-- Name: equipment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);


--
-- TOC entry 4891 (class 2604 OID 24990)
-- Name: mastercode id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mastercode ALTER COLUMN id SET DEFAULT nextval('public.mastercode_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 24631)
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- TOC entry 4904 (class 2604 OID 49768)
-- Name: project_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_assignments ALTER COLUMN id SET DEFAULT nextval('public.project_assignments_id_seq'::regclass);


--
-- TOC entry 4874 (class 2604 OID 24809)
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 24748)
-- Name: salary_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_history ALTER COLUMN id SET DEFAULT nextval('public.salary_history_id_seq'::regclass);


--
-- TOC entry 5211 (class 0 OID 24793)
-- Dependencies: 235
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.areas (id, name, description, created_at) FROM stdin;
1	STAFF – PMO	\N	2025-11-13 17:46:16.385117
2	STAFF – RRHH	\N	2025-11-13 17:46:16.392479
3	STAFF – TI	\N	2025-11-13 17:46:16.394981
4	STAFF-FINANZAS	\N	2025-11-13 17:46:16.396554
5	OPERACIONES	\N	2025-11-13 17:46:16.398379
\.


--
-- TOC entry 5195 (class 0 OID 24601)
-- Dependencies: 219
-- Data for Name: candidates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.candidates (id, first_name, last_name, email, phone, position_applied, status, notes, created_at) FROM stdin;
\.


--
-- TOC entry 5215 (class 0 OID 24825)
-- Dependencies: 239
-- Data for Name: cells; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cells (id, name, area_id, project_id, description, created_at) FROM stdin;
\.


--
-- TOC entry 5219 (class 0 OID 24926)
-- Dependencies: 243
-- Data for Name: contract_schemes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract_schemes (id, name, description, created_at) FROM stdin;
1	Nómina	Empleado en nómina tradicional	2025-11-13 19:49:55.288465
2	Honorarios	Esquema de honorarios profesionales	2025-11-13 19:49:55.288465
3	Mixto	Esquema mixto nómina + honorarios	2025-11-13 19:49:55.288465
4	Outsourcing	Esquema de tercerización	2025-11-13 19:49:55.288465
\.


--
-- TOC entry 5221 (class 0 OID 24938)
-- Dependencies: 245
-- Data for Name: contract_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract_types (id, name, description, created_at) FROM stdin;
1	Indefinido	Contrato por tiempo indefinido	2025-11-13 19:49:55.288465
2	Temporal	Contrato temporal o por obra determinada	2025-11-13 19:49:55.288465
3	Proyecto	Contrato por proyecto específico	2025-11-13 19:49:55.288465
4	Práctica	Contrato de práctica profesional	2025-11-13 19:49:55.288465
5	Consultoría	Contrato de consultoría externa	2025-11-13 19:49:55.288465
\.


--
-- TOC entry 5205 (class 0 OID 24709)
-- Dependencies: 229
-- Data for Name: emergency_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emergency_contacts (id, employee_id, contact_name, relationship, phone, email, address, priority, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5203 (class 0 OID 24691)
-- Dependencies: 227
-- Data for Name: employee_audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_audit_log (id, employee_id, action, field_name, old_value, new_value, changed_by, changed_at) FROM stdin;
\.


--
-- TOC entry 5217 (class 0 OID 24907)
-- Dependencies: 241
-- Data for Name: employee_banking_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_banking_info (id, employee_id, bank_name, account_holder_name, account_number, clabe_interbancaria, clabe_document_path, is_active, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5223 (class 0 OID 24950)
-- Dependencies: 247
-- Data for Name: employee_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_contracts (id, employee_id, contract_type_id, obra, contract_document_path, contract_scheme_id, initial_rate, gross_monthly_salary, net_monthly_salary, company_cost, start_date, end_date, termination_reason, is_rehireable, is_active, created_at, updated_at) FROM stdin;
1	788	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	t	2025-11-21 16:28:54.918129	2025-11-21 16:28:54.918129
\.


--
-- TOC entry 5207 (class 0 OID 24727)
-- Dependencies: 231
-- Data for Name: employee_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_documents (id, employee_id, document_type, document_number, issue_date, expiry_date, document_file_path, notes, created_at, updated_at) FROM stdin;
1	14	import_meta	\N	\N	\N	\N	{"original_row":{"Nombre":"Juan","Apellido":"García López","Email":"juan.garcia@afirma.com","Teléfono":"+57-1-1234567","Posición":"Desarrollador Senior","Departamento":"Desarrollo"}}	2025-11-13 15:10:14.367099	2025-11-13 15:10:14.367099
2	15	import_meta	\N	\N	\N	\N	{"original_row":{"Nombre":"María","Apellido":"Rodríguez Martínez","Email":"maria.rodriguez@afirma.com","Teléfono":"+57-1-2345678","Posición":"Desarrollador Junior","Departamento":"Desarrollo"}}	2025-11-13 15:10:14.386944	2025-11-13 15:10:14.386944
3	16	import_meta	\N	\N	\N	\N	{"original_row":{"Nombre":"Carlos","Apellido":"Martínez Torres","Email":"carlos.martinez@afirma.com","Teléfono":"+57-1-3456789","Posición":"Diseñador UX/UI","Departamento":"Diseño"}}	2025-11-13 15:10:14.392585	2025-11-13 15:10:14.392585
4	17	import_meta	\N	\N	\N	\N	{"original_row":{"Nombre":"Patricia","Apellido":"López Fernández","Email":"patricia.lopez@afirma.com","Teléfono":"+57-1-4567890","Posición":"Project Manager","Departamento":"Gestión"}}	2025-11-13 15:10:14.394981	2025-11-13 15:10:14.394981
5	18	import_meta	\N	\N	\N	\N	{"original_row":{"Nombre":"Roberto","Apellido":"Sánchez García","Email":"roberto.sanchez@afirma.com","Teléfono":"+57-1-5678901","Posición":"Especialista RRHH","Departamento":"Recursos Humanos"}}	2025-11-13 15:10:14.398533	2025-11-13 15:10:14.398533
6	273	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF-FINANZAS","proyecto":"FINANZAS","sgmm":"X","vida":"X","correo_personal":"jorgegaliciauach@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2018-07-16","Fecha de asignación":"2018-07-16","Nombre del empleado":"JORGE LUIS GALICIA PEDRAZA","SGMM":"X","vida":"X","Posición":"Auxiliar Administrativo","Proyecto":"FINANZAS","Tarifa inicial de contratación":"151.38","Área":"AFIRMA MEX","Teléfono laboral":"5547718145","Teléfono personal":"5547718145","Correo de trabajo":"administracion@afirma-solutions.com","Correo electrónico personal":"jorgegaliciauach@gmail.com"}}	2025-11-13 15:45:10.970294	2025-11-13 15:45:10.970294
7	274	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF-FINANZAS","proyecto":"FINANZAS","sgmm":"X","vida":"X","correo_personal":"hectormtzh@hotmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2019-01-07","Fecha de asignación":"2019-01-04","Nombre del empleado":"HECTOR MARTINEZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Gerente","Proyecto":"FINANZAS","Tarifa inicial de contratación":"426.93","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"55771523612","Correo de trabajo":"hector.martinez@afirma-solutions.com","Correo electrónico personal":"hectormtzh@hotmail.com"}}	2025-11-13 15:45:10.99092	2025-11-13 15:45:10.99092
8	275	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – RRHH","proyecto":"RRHH","sgmm":"X","vida":"X","correo_personal":"ivonne.gonzalez.it@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – RRHH","Fecha de ingreso":"2019-04-22","Fecha de asignación":"2019-04-22","Nombre del empleado":"SANDRA IVONNE GONZALEZ MEJIA","SGMM":"X","vida":"X","Posición":"Gerente","Proyecto":"RRHH","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5527157754","Correo de trabajo":"ivonne.gonzalez@afirma-solutions.com","Correo electrónico personal":"ivonne.gonzalez.it@gmail.com"}}	2025-11-13 15:45:10.994808	2025-11-13 15:45:10.994808
9	276	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – PMO","proyecto":"STAFF - PMO","sgmm":"X","vida":"X","correo_personal":"gama469@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – PMO","Fecha de ingreso":"2019-06-12","Fecha de asignación":"2021-07-13","Nombre del empleado":"GARY MANUEL VAZQUEZ RAYGOZA","SGMM":"X","vida":"X","Posición":"PMO Digital","Proyecto":"STAFF - PMO","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"4191138225","Teléfono personal":"4191138225","Correo de trabajo":"gary.vazquez@afirma-solutions.com","Correo electrónico personal":"gama469@gmail.com"}}	2025-11-13 15:45:10.998309	2025-11-13 15:45:10.998309
10	277	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"POSEIDON","proyecto":"POSEIDON","sgmm":"X","vida":"X","correo_personal":"RMG.SERVER@GMAIL.COM","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"POSEIDON","Fecha de ingreso":"2019-09-02","Fecha de asignación":"2019-09-02","Nombre del empleado":"RAYMUNDO MARTINEZ GARCIA","SGMM":"X","vida":"X","Posición":"Especialista DBA Oracle","Proyecto":"POSEIDON","Tarifa inicial de contratación":"827","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5513643502","Correo de trabajo":"raymundo.martinez@afirma.solutions","Correo electrónico personal":"RMG.SERVER@GMAIL.COM"}}	2025-11-13 15:45:11.001855	2025-11-13 15:45:11.001855
11	278	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF-FINANZAS","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"angelbejarano85@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2021-03-01","Fecha de asignación":"2021-03-01","Nombre del empleado":"JOSE ANGEL LUNA BEJARANO","SGMM":"X","vida":"X","Posición":"Gerente","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5521412415","Teléfono personal":"5521412415","Correo de trabajo":"jangel.luna@afirma.solutions","Correo electrónico personal":"angelbejarano85@gmail.com"}}	2025-11-13 15:45:11.006351	2025-11-13 15:45:11.006351
12	279	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – TI","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"sacasher@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2021-03-22","Fecha de asignación":"2021-03-22","Nombre del empleado":"SAUL CASTILLO HERNANDEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5529183017","Teléfono personal":"5526413349","Correo de trabajo":"saul.castillo@afirma-solutions.com","Correo electrónico personal":"sacasher@gmail.com"}}	2025-11-13 15:45:11.008749	2025-11-13 15:45:11.008749
13	280	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – TI","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"villamar.jacome@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2021-12-28","Fecha de asignación":"2023-12-28","Nombre del empleado":"ALBERTO VILLAMAR JACOME","SGMM":"X","vida":"X","Posición":"Auxiliar Administrativo","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5626674118","Teléfono personal":"5627537014","Correo de trabajo":"alberto.villamar@afirma-solutions.com","Correo electrónico personal":"villamar.jacome@gmail.com"}}	2025-11-13 15:45:11.010977	2025-11-13 15:45:11.010977
14	281	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – RRHH","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"ilse_nz@hotmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – RRHH","Fecha de ingreso":"2022-01-10","Fecha de asignación":"2022-01-10","Nombre del empleado":"ILSE NARVAEZ ABUNDIZ","SGMM":"X","vida":"X","Posición":"Reclutador","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5549656894","Teléfono personal":"5549656894","Correo de trabajo":"ilse.narvaez@afirma-solutions.com","Correo electrónico personal":"ilse_nz@hotmail.com"}}	2025-11-13 15:45:11.014652	2025-11-13 15:45:11.014652
15	282	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – TI","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"ferchoduy_9@hotmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2022-07-04","Fecha de asignación":"2022-07-04","Nombre del empleado":"FERNANDO GARRIDO PEREZ","SGMM":"X","vida":"X","Posición":"DEVOPS UTP","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"2282225257","Teléfono personal":"2282225257","Correo de trabajo":"fernando.garrido@afirma.solutions","Correo electrónico personal":"ferchoduy_9@hotmail.com"}}	2025-11-13 15:45:11.017178	2025-11-13 15:45:11.017178
16	283	import_meta	\N	\N	\N	\N	{"cliente":"ADO MOBILITY","celula":"ADO","proyecto":"CELULA Y CLIENTE MARKETING","sgmm":"X","vida":"X","correo_personal":"luizalmaraz@gmail.com","original_row":{"CLIENTE":"ADO MOBILITY","Célula":"ADO","Fecha de ingreso":"2022-11-14","Fecha de asignación":"2022-11-14","Nombre del empleado":"LUIS ALMARAZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Arquitecto","Proyecto":"CELULA Y CLIENTE MARKETING","Tarifa inicial de contratación":"875.00","Área":"AFIRMA MEX","Teléfono laboral":"5527626245","Teléfono personal":"5527626245","Correo de trabajo":"luis.almaraz@afirma.solutions","Correo electrónico personal":"luizalmaraz@gmail.com"}}	2025-11-13 15:45:11.021756	2025-11-13 15:45:11.021756
17	284	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"hetr_tovar@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-01-30","Fecha de asignación":"2024-05-02","Nombre del empleado":"HUGO ENRIQUE TOVAR ROMERO","SGMM":"X","vida":"X","Posición":"Desarrollador WEB","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"7224243048","Teléfono personal":"7224243048","Correo de trabajo":"hugo.tovar@afirma.solutions","Correo electrónico personal":"hetr_tovar@hotmail.com"}}	2025-11-13 15:45:11.025202	2025-11-13 15:45:11.025202
18	285	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"oscar.mtz.ac@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-02-07","Fecha de asignación":"2023-02-07","Nombre del empleado":"OSCAR MARTINEZ ACOSTA","SGMM":"X","vida":"X","Posición":"Arquitecto","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"4432367898","Teléfono personal":"442 1913514","Correo de trabajo":"oscar.martinez@afirma.solutions","Correo electrónico personal":"oscar.mtz.ac@gmail.com"}}	2025-11-13 15:45:11.028098	2025-11-13 15:45:11.028098
19	286	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"murga_07@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-02-13","Fecha de asignación":"2023-02-13","Nombre del empleado":"OSCAR ABARCA MURGA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"315.03","Área":"ATVANTTI","Teléfono laboral":"5544422500","Teléfono personal":"5544422500","Correo de trabajo":"oscar.abarca@afirma.solutions","Correo electrónico personal":"murga_07@hotmail.com"}}	2025-11-13 15:45:11.0315	2025-11-13 15:45:11.0315
20	287	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"bdricardo6@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-02-13","Fecha de asignación":"2023-02-13","Nombre del empleado":"RICARDO BLANCO DEANDA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"4423289296","Teléfono personal":"4423289296","Correo de trabajo":"ricardo.blanco@afirma.solutions","Correo electrónico personal":"bdricardo6@gmail.com"}}	2025-11-13 15:45:11.034798	2025-11-13 15:45:11.034798
21	288	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"lucielms01@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2023-04-24","Fecha de asignación":"2025-09-01","Nombre del empleado":"ANA LUCIEL MORENO SALAZAR","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"RPA","Tarifa inicial de contratación":"615","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"2281000613","Correo de trabajo":"ana.moreno@afirma.solutions","Correo electrónico personal":"lucielms01@gmail.com"}}	2025-11-13 15:45:11.037555	2025-11-13 15:45:11.037555
22	289	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"j_cruz1997@outlook.es","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-04-24","Fecha de asignación":"2024-10-07","Nombre del empleado":"JOSUE CRUZ SANTIAGO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"600","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4425543052","Correo de trabajo":"josue.cruz@afirma.solutions","Correo electrónico personal":"j_cruz1997@outlook.es"}}	2025-11-13 15:45:11.041235	2025-11-13 15:45:11.041235
23	290	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – TI","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"ghernandez.m@outlook.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2023-05-02","Fecha de asignación":"2023-05-02","Nombre del empleado":"GUSTAVO HERNANDEZ MONTES DE OCA","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5621056735","Correo de trabajo":"gustavo.hernandez@afirma.solutions","Correo electrónico personal":"ghernandez.m@outlook.com"}}	2025-11-13 15:45:11.04404	2025-11-13 15:45:11.04404
24	291	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RECUPERACIONES","proyecto":"RECUPERACIONES","sgmm":"X","vida":"X","correo_personal":"josue_x@outlook.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2023-05-08","Fecha de asignación":"2025-07-15","Nombre del empleado":"MARCOS JOSUE CASTILLO RENDON","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"850","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"720 754 4431","Correo de trabajo":"marcos.castillo@afirma.solutions","Correo electrónico personal":"josue_x@outlook.com"}}	2025-11-13 15:45:11.046942	2025-11-13 15:45:11.046942
25	292	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"lordchavez@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-05-15","Fecha de asignación":"2023-05-16","Nombre del empleado":"LUIS DAVID CHAVEZ ACEVEDO ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"5564236602","Correo de trabajo":"luis.chavez@afirma.solutions","Correo electrónico personal":"lordchavez@hotmail.com"}}	2025-11-13 15:45:11.049811	2025-11-13 15:45:11.049811
26	293	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"jsfernandez1209@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-05-31","Fecha de asignación":"2023-06-01","Nombre del empleado":"JORGE SAUL FERNANDEZ ENRIQUEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"777 493 3918","Correo de trabajo":"jorge.fernandez@afirma.solutions","Correo electrónico personal":"jsfernandez1209@gmail.com"}}	2025-11-13 15:45:11.05269	2025-11-13 15:45:11.05269
27	294	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"STAFF – TI","proyecto":"DATA LAKE","sgmm":"X","vida":"X","correo_personal":"wences46@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – TI","Fecha de ingreso":"2023-06-05","Fecha de asignación":"2023-06-05","Nombre del empleado":"ISMAEL WENCESLAO BARRAGAN HERNANDEZ","SGMM":"X","vida":"X","Posición":"Desarrollador .NET","Proyecto":"DATA LAKE","Tarifa inicial de contratación":"630","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5532264475","Correo de trabajo":"ismael.barragan@afirma.solutions","Correo electrónico personal":"wences46@hotmail.com"}}	2025-11-13 15:45:11.058099	2025-11-13 15:45:11.058099
28	295	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"nr961538@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-06-16","Fecha de asignación":"2023-06-16","Nombre del empleado":"FATIMA NATALIA RUIZ RIVERA","SGMM":"X","vida":"X","Posición":"Analista","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4681570776","Correo de trabajo":"natalia.ruiz@afirma.solutions","Correo electrónico personal":"nr961538@gmail.com"}}	2025-11-13 15:45:11.061363	2025-11-13 15:45:11.061363
29	296	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"rocagaby2001@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-07-06","Fecha de asignación":"2023-07-06","Nombre del empleado":"GABRIELA ROSAS CASTILLO","SGMM":"X","vida":"X","Posición":"Analista","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4181026314","Correo de trabajo":"gabriela.rosas@afirma.solutions","Correo electrónico personal":"rocagaby2001@gmail.com"}}	2025-11-13 15:45:11.064884	2025-11-13 15:45:11.064884
30	297	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"rodrigomendozamarq@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-07-10","Fecha de asignación":"2023-07-10","Nombre del empleado":"RODRIGO MENDOZA MARQUEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"777 330 8523","Correo de trabajo":"rodrigo.mendoza@afirma.solutions","Correo electrónico personal":"rodrigomendozamarq@gmail.com"}}	2025-11-13 15:45:11.06718	2025-11-13 15:45:11.06718
31	298	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"jose7.balbuena@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-07-10","Fecha de asignación":"2023-07-10","Nombre del empleado":"JOSE DE JESUS RODRIGUEZ BALBUENA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"222 111 0016","Correo de trabajo":"jesus.rodriguez@afirma.solutions","Correo electrónico personal":"jose7.balbuena@gmail.com"}}	2025-11-13 15:45:11.070325	2025-11-13 15:45:11.070325
32	299	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA // BUSCANDO  PROYECTO","proyecto":"BANCA PRIVADA","sgmm":"X","vida":"X","correo_personal":"samilpez@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA // BUSCANDO  PROYECTO ","Fecha de ingreso":"2023-07-24","Fecha de asignación":"2025-09-01","Nombre del empleado":"SAMUEL LOPEZ PEDRERO","SGMM":"X","vida":"X","Posición":"Front End","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"600","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"9934313125","Correo de trabajo":"samuel.lopez@afirma-solutions.com","Correo electrónico personal":"samilpez@gmail.com"}}	2025-11-13 15:45:11.074957	2025-11-13 15:45:11.074957
33	300	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"dmartinezssh@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-07-24","Fecha de asignación":"2023-07-24","Nombre del empleado":"DANIEL MARTINEZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"55 7011 9910","Correo de trabajo":"daniel.martinez@afirma.solutions","Correo electrónico personal":"dmartinezssh@gmail.com"}}	2025-11-13 15:45:11.077861	2025-11-13 15:45:11.077861
34	301	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BET","proyecto":"BET - CELULA CONFIRMING AGIL","sgmm":"X","vida":"X","correo_personal":"john3048@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BET","Fecha de ingreso":"2023-08-01","Fecha de asignación":"2023-08-01","Nombre del empleado":"MARCOS ENRIQUE TELLEZ HERRERA","SGMM":"X","vida":"X","Posición":"Analista","Proyecto":"BET - CELULA CONFIRMING AGIL","Tarifa inicial de contratación":"750","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"2871460779","Correo de trabajo":"marcos.tellez@afirma.solutions","Correo electrónico personal":"john3048@hotmail.com"}}	2025-11-13 15:45:11.081452	2025-11-13 15:45:11.081452
35	302	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BET","proyecto":"BET - BANCA EMPRESAS","sgmm":"X","vida":"X","correo_personal":"miguel.delrellop@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BET","Fecha de ingreso":"2023-08-01","Fecha de asignación":"2023-08-01","Nombre del empleado":"MIGUEL ANGEL DEL RELLO PORTILLO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BET - BANCA EMPRESAS","Tarifa inicial de contratación":"750","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"5587963107","Correo de trabajo":"angel.portillo@afirma.solutions","Correo electrónico personal":"miguel.delrellop@gmail.com"}}	2025-11-13 15:45:11.084137	2025-11-13 15:45:11.084137
36	303	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"padre_japg@163.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-08-03","Fecha de asignación":"2023-08-03","Nombre del empleado":"JOSE ANTONIO PADRE GARCIA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7721347703","Correo de trabajo":"antonio.padre@afirma.solutions","Correo electrónico personal":"padre_japg@163.com"}}	2025-11-13 15:45:11.087593	2025-11-13 15:45:11.087593
37	304	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF-FINANZAS","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"isaacyael_1993@hotmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2023-08-09","Fecha de asignación":"2023-08-09","Nombre del empleado":"ISAAC YAEL MARTINEZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Contador","Proyecto":"AFIRMA","Tarifa inicial de contratación":"205.42","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7713657501","Correo de trabajo":"yael.martinez@afirma.solutions","Correo electrónico personal":"isaacyael_1993@hotmail.com"}}	2025-11-13 15:45:11.090874	2025-11-13 15:45:11.090874
38	305	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"alex.perez.ppd@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-08-28","Fecha de asignación":"2023-08-28","Nombre del empleado":"ALEJANDRO PEREZ PEREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4181400096","Correo de trabajo":"alejandro.perez@afirma.solutions","Correo electrónico personal":"alex.perez.ppd@gmail.com"}}	2025-11-13 15:45:11.093676	2025-11-13 15:45:11.093676
39	306	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"hgortizm@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-09-25","Fecha de asignación":"2024-05-02","Nombre del empleado":"HECTOR GABRIEL ORTIZ MORA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7775007400","Correo de trabajo":"hector.ortiz@afirma.solutions","Correo electrónico personal":"hgortizm@gmail.com"}}	2025-11-13 15:45:11.097812	2025-11-13 15:45:11.097812
40	307	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"OPICS","proyecto":"OPICS","sgmm":"X","vida":"X","correo_personal":"victor.fajardo1369@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"OPICS","Fecha de ingreso":"2023-10-16","Fecha de asignación":"2023-10-16","Nombre del empleado":"VICTOR FAJARDO URIZAR","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"OPICS","Tarifa inicial de contratación":"910","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5511731858","Correo de trabajo":"victor.fajardo@afirma.solutions","Correo electrónico personal":"victor.fajardo1369@gmail.com"}}	2025-11-13 15:45:11.100559	2025-11-13 15:45:11.100559
41	308	import_meta	\N	\N	\N	\N	{"cliente":"PLAYTOPIA","celula":"PLAYTOPIA","proyecto":"PLAYTOPIA","sgmm":"X","vida":"X","correo_personal":"paezcuf@gmail.com","original_row":{"CLIENTE":"PLAYTOPIA","Célula":"PLAYTOPIA","Fecha de ingreso":"2023-10-23","Fecha de asignación":"2023-10-23","Nombre del empleado":"CARLOS URIEL PAEZ BERNABE","SGMM":"X","vida":"X","Posición":"Desarrollador PHP","Proyecto":"PLAYTOPIA","Tarifa inicial de contratación":"690","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7224190567","Correo de trabajo":"carlos.paez@afirma-solutions.com","Correo electrónico personal":"paezcuf@gmail.com"}}	2025-11-13 15:45:11.105751	2025-11-13 15:45:11.105751
42	309	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"OPICS","proyecto":"OPICS","sgmm":"X","vida":"X","correo_personal":"ocrunaje@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"OPICS","Fecha de ingreso":"2023-10-24","Fecha de asignación":"2023-10-24","Nombre del empleado":"OSWALDO CRUZ NAJERA","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"OPICS","Tarifa inicial de contratación":"960","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4461225365","Correo de trabajo":"oswaldo.cruz@afirma.solutions","Correo electrónico personal":"ocrunaje@hotmail.com"}}	2025-11-13 15:45:11.109272	2025-11-13 15:45:11.109272
43	310	import_meta	\N	\N	\N	\N	{"cliente":"CESVI","celula":"STAFF – TI","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"aaceves.andrea@gmail.com","original_row":{"CLIENTE":"CESVI","Célula":"STAFF – TI","Fecha de ingreso":"2023-10-24","Fecha de asignación":"2025-11-13","Nombre del empleado":"ANDREA ACEVES GUALITO","SGMM":"X","vida":"X","Posición":"UX","Proyecto":"AFIRMA","Tarifa inicial de contratación":"500","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4422719357","Correo de trabajo":"andrea.aceves@afirma.solutions","Correo electrónico personal":"aaceves.andrea@gmail.com"}}	2025-11-13 15:45:11.112673	2025-11-13 15:45:11.112673
44	311	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"galmoka6@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-11-15","Fecha de asignación":"2023-11-15","Nombre del empleado":"GALGANI MONTES CALLEJA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"5514832171","Correo de trabajo":"galgani.montes@afirma.solutions","Correo electrónico personal":"galmoka6@gmail.com"}}	2025-11-13 15:45:11.116268	2025-11-13 15:45:11.116268
45	312	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – PMO","proyecto":"POSEIDON","sgmm":"X","vida":"X","correo_personal":"stefania_villalba@outlook.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – PMO","Fecha de ingreso":"2023-12-04","Fecha de asignación":"2023-12-04","Nombre del empleado":"ESTEFANIA VILLALBA HERNANDEZ","SGMM":"X","vida":"X","Posición":"Gestor de Proyectos","Proyecto":"POSEIDON","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4421416264","Correo de trabajo":"estefania.villalba@afirma-solutions.com","Correo electrónico personal":"stefania_villalba@outlook.com"}}	2025-11-13 15:45:11.118411	2025-11-13 15:45:11.118411
46	313	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"andreshernan@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-12-08","Fecha de asignación":"2023-12-08","Nombre del empleado":"ANDRES HERNANDEZ LIMON","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"1000","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7224490235","Correo de trabajo":"andres.hernandez@afirma.solutions","Correo electrónico personal":"andreshernan@gmail.com"}}	2025-11-13 15:45:11.12149	2025-11-13 15:45:11.12149
47	314	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RECUPERACIONES","proyecto":"RECUPERACIONES","sgmm":"X","vida":"X","correo_personal":"edpardes@yahoo.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-04-01","Fecha de asignación":"2025-04-01","Nombre del empleado":"PANFILO EDUARDO PAREDES COLIN","SGMM":"X","vida":"X","Posición":"Business Analyst","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"900","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"5532383997","Correo de trabajo":"edpardes@yahoo.com","Correo electrónico personal":"edpardes@yahoo.com"}}	2025-11-13 15:45:11.125461	2025-11-13 15:45:11.125461
48	315	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BOR","proyecto":"BOR","sgmm":"X","vida":"X","correo_personal":"fer.ma.pe.di@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2024-01-08","Fecha de asignación":"2024-01-08","Nombre del empleado":"FERNANDO MANUEL PEREZ DIAZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BOR","Tarifa inicial de contratación":"856","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5561133861","Correo de trabajo":"fernando.perez@afirma.solutions","Correo electrónico personal":"fer.ma.pe.di@gmail.com"}}	2025-11-13 15:45:11.129791	2025-11-13 15:45:11.129791
49	316	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"mig.hgn@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-01-09","Fecha de asignación":"2024-01-09","Nombre del empleado":"MIGUEL HEDAI GALINDO NUÑEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":5638824284,"Correo de trabajo":"miguel.galindo@afirma.solutions","Correo electrónico personal":"mig.hgn@gmail.com"}}	2025-11-13 15:45:11.133363	2025-11-13 15:45:11.133363
50	317	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"arath.mm19@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2024-01-10","Fecha de asignación":"2024-06-05","Nombre del empleado":"ANTONIO ARATH MEDINA MEJIA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"RPA","Tarifa inicial de contratación":"N/A Proyecto Cerrado","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5527650787","Correo de trabajo":"antonio.medina@afirma-solutions.com","Correo electrónico personal":"arath.mm19@gmail.com"}}	2025-11-13 15:45:11.136207	2025-11-13 15:45:11.136207
51	318	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"ivan2909@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-01-15","Fecha de asignación":"2024-01-15","Nombre del empleado":"IVAN RODRIGUEZ APOLINAR","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"1000","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5539553788","Correo de trabajo":"ivan.rodriguez@afirma.solutions","Correo electrónico personal":"ivan2909@hotmail.com"}}	2025-11-13 15:45:11.139526	2025-11-13 15:45:11.139526
52	319	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – TI","proyecto":"STAF-TI","sgmm":"X","vida":"X","correo_personal":"erick.bruno@afirma.solutions","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2024-01-15","Fecha de asignación":"2025-09-03","Nombre del empleado":"ERICK BRUNO GARCIA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"STAF-TI","Tarifa inicial de contratación":"743.38","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"2351150572","Correo de trabajo":"erick.bruno@afirma.solutions","Correo electrónico personal":"erick.bruno@afirma.solutions"}}	2025-11-13 15:45:11.142274	2025-11-13 15:45:11.142274
53	320	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"erick.m.romero.g@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-01-22","Fecha de asignación":"2024-05-02","Nombre del empleado":"ERICK MISAEL ROMERO GARCIA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5554662472","Correo de trabajo":"erick.romero@afirma.solutions","Correo electrónico personal":"erick.m.romero.g@gmail.com"}}	2025-11-13 15:45:11.14552	2025-11-13 15:45:11.14552
54	321	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF-FINANZAS","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"pako_gy16@hotmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2024-02-06","Fecha de asignación":"2024-02-06","Nombre del empleado":"FRANCISCO JAVIER GUTIERREZ YAÑEZ","SGMM":"X","vida":"X","Posición":"Contador","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5530695997","Correo de trabajo":"francisco.gutierrez@afirma.solutions","Correo electrónico personal":"pako_gy16@hotmail.com"}}	2025-11-13 15:45:11.149192	2025-11-13 15:45:11.149192
55	322	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – PMO","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"romadi_86@hotmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – PMO","Fecha de ingreso":"2024-02-19","Fecha de asignación":"2024-02-19","Nombre del empleado":"ROGELIO MARTINEZ DIAZ","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5544797974","Correo de trabajo":"rogelio.martinez@afirma-solutions.com","Correo electrónico personal":"romadi_86@hotmail.com"}}	2025-11-13 15:45:11.151359	2025-11-13 15:45:11.151359
56	323	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BET","proyecto":"BET","sgmm":"X","vida":"X","correo_personal":"ing_antonio_mendez@outlook.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BET","Fecha de ingreso":"2024-02-21","Fecha de asignación":"2024-02-22","Nombre del empleado":"JOSE ANTONIO MENDEZ HUITRON","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BET","Tarifa inicial de contratación":"900","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4421040895","Correo de trabajo":"jose.mendez@afirma.solutions","Correo electrónico personal":"ing_antonio_mendez@outlook.com"}}	2025-11-13 15:45:11.153941	2025-11-13 15:45:11.153941
57	324	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"LYNX","proyecto":"LYNX","sgmm":"X","vida":"X","correo_personal":"gonzaleventos@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"LYNX","Fecha de ingreso":"2024-03-04","Fecha de asignación":"2024-03-04","Nombre del empleado":"SALVADOR GONZALEZ GONZALEZ","SGMM":"X","vida":"X","Posición":"Gestor de Infraestructura","Proyecto":"LYNX","Tarifa inicial de contratación":"675","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4421865010","Correo de trabajo":"salvador.gonzalez@afirma.solutions","Correo electrónico personal":"gonzaleventos@gmail.com"}}	2025-11-13 15:45:11.15817	2025-11-13 15:45:11.15817
58	325	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BOR","proyecto":"BOR","sgmm":"X","vida":"X","correo_personal":"carlosvaldezm@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2024-04-01","Fecha de asignación":"2024-04-01","Nombre del empleado":"MARIO CARLOS VALDEZ MUÑOZ","SGMM":"X","vida":"X","Posición":"Scrum Master","Proyecto":"BOR","Tarifa inicial de contratación":"692","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5545254535","Correo de trabajo":"mario.valdez@afirma.solutions","Correo electrónico personal":"carlosvaldezm@gmail.com"}}	2025-11-13 15:45:11.160318	2025-11-13 15:45:11.160318
59	326	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF-FINANZAS","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"jorge.clementeg18@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2024-04-15","Fecha de asignación":"2024-04-15","Nombre del empleado":"JORGE DANIEL CLEMENTE GONZALEZ","SGMM":"X","vida":"X","Posición":"Contador","Proyecto":"AFIRMA","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5513707285","Correo de trabajo":"jorge.clementeg18@gmail.com","Correo electrónico personal":"jorge.clementeg18@gmail.com"}}	2025-11-13 15:45:11.164333	2025-11-13 15:45:11.164333
60	327	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"CBT-DIGITAL","proyecto":"CBT  - DIGITAL","sgmm":"X","vida":"X","correo_personal":"alexxer_18@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"CBT-DIGITAL","Fecha de ingreso":"2024-04-22","Fecha de asignación":"2024-04-22","Nombre del empleado":"ERICK ALEJANDRO AVILA TORRES","SGMM":"X","vida":"X","Posición":"PO Digital","Proyecto":"CBT  - DIGITAL","Tarifa inicial de contratación":"923.70","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5519516301","Correo de trabajo":"erick.avila@afirma.solutions","Correo electrónico personal":"alexxer_18@hotmail.com"}}	2025-11-13 15:45:11.166097	2025-11-13 15:45:11.166097
61	328	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"campos2859@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-05-07","Fecha de asignación":"2024-05-07","Nombre del empleado":"BRIAN CAMPOS ISLAS","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5566804637","Correo de trabajo":"brian.campos@afirma.solutions","Correo electrónico personal":"campos2859@gmail.com"}}	2025-11-13 15:45:11.168409	2025-11-13 15:45:11.168409
62	329	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"jorgehirashi@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-05-07","Fecha de asignación":"2024-05-07","Nombre del empleado":"JORGE ARTURO CASTORENA HIRASHI","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5621809711","Correo de trabajo":"jorge.castorena@afirma.solutions","Correo electrónico personal":"jorgehirashi@gmail.com"}}	2025-11-13 15:45:11.172473	2025-11-13 15:45:11.172473
63	330	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PERSONAL","proyecto":"BANCA PERSONAL","sgmm":"X","vida":"X","correo_personal":"mcarrasco270992@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2024-05-13","Fecha de asignación":"2024-09-01","Nombre del empleado":"MAURICIO CARRASCO AYALA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4421283972","Correo de trabajo":"mauricio.carrasco@afirma.solutions","Correo electrónico personal":"mcarrasco270992@gmail.com"}}	2025-11-13 15:45:11.174963	2025-11-13 15:45:11.174963
64	331	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"DATA LAKE","proyecto":"DATA LAKE","sgmm":"X","vida":"X","correo_personal":"agussevi73@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"DATA LAKE","Fecha de ingreso":"2024-05-27","Fecha de asignación":"2024-09-01","Nombre del empleado":"AGUSTIN SEVILLA SAIZ","SGMM":"X","vida":"X","Posición":"Gestor de Proyectos","Proyecto":"DATA LAKE","Tarifa inicial de contratación":"738","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4421280162","Correo de trabajo":"agustin.sevilla@afirma.solutions","Correo electrónico personal":"agussevi73@hotmail.com"}}	2025-11-13 15:45:11.180299	2025-11-13 15:45:11.180299
65	332	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"diegourielarteaga@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-06-12","Fecha de asignación":"2024-06-12","Nombre del empleado":"DIEGO URIEL ARTEAGA ZAMORA 2","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"435.55","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4422338246","Correo de trabajo":"diego.arteaga@afirma.solutions","Correo electrónico personal":"diegourielarteaga@gmail.com"}}	2025-11-13 15:45:11.182505	2025-11-13 15:45:11.182505
66	333	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"edgar-ml89@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2024-06-05","Fecha de asignación":"2024-06-05","Nombre del empleado":"EDGAR JONNATHAN MORALES LUCIO","SGMM":"X","vida":"X","Posición":"Gestor de Infraestructura","Proyecto":"RPA","Tarifa inicial de contratación":"N/A Proyecto Cerrado","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4424234316","Correo de trabajo":"edgar.morales@afirma.solutions","Correo electrónico personal":"edgar-ml89@hotmail.com"}}	2025-11-13 15:45:11.184671	2025-11-13 15:45:11.184671
67	334	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BOR","proyecto":"DATA LAKE","sgmm":"X","vida":"X","correo_personal":"munozbrianalexis@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2024-06-17","Fecha de asignación":"2024-11-02","Nombre del empleado":"BRIAN ALEXIS MUÑOZ MONROY","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"DATA LAKE","Tarifa inicial de contratación":"480","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4425548377","Correo de trabajo":"brian.munoz@afirma.solutions","Correo electrónico personal":"munozbrianalexis@gmail.com"}}	2025-11-13 15:45:11.18655	2025-11-13 15:45:11.18655
68	335	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"espinoza.mdin.mig@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-06-17","Fecha de asignación":"2024-06-17","Nombre del empleado":"MIGUEL ANGEL ESPINOZA MEDINA","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"1000","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5519175961","Correo de trabajo":"miguel.espinoza@afirma.solutions","Correo electrónico personal":"espinoza.mdin.mig@gmail.com"}}	2025-11-13 15:45:11.189919	2025-11-13 15:45:11.189919
69	336	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"carlosbetancourtnav@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2024-07-01","Fecha de asignación":"2024-07-01","Nombre del empleado":"CARLOS ANDRES BETANCOURT NAVARRETE","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5540761609","Correo de trabajo":"carlos.betancourt@afirma.solutions","Correo electrónico personal":"carlosbetancourtnav@gmail.com"}}	2025-11-13 15:45:11.19203	2025-11-13 15:45:11.19203
70	337	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"ramonz09@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2024-07-01","Fecha de asignación":"2024-07-01","Nombre del empleado":"RAMON ANTONIO ZURITA ALCUDIA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5543863591","Correo de trabajo":"ramon.zurita@afirma.solutions","Correo electrónico personal":"ramonz09@hotmail.com"}}	2025-11-13 15:45:11.193988	2025-11-13 15:45:11.193988
71	338	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"snoaserk12@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-07-01","Fecha de asignación":"2024-07-01","Nombre del empleado":"OMAR ALBERTO SANTOS NUÑEZ","SGMM":"X","vida":"X","Posición":"Desarrollador PL/SQL","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5539157934","Correo de trabajo":"omar.santos@afirma.solutions","Correo electrónico personal":"snoaserk12@gmail.com"}}	2025-11-13 15:45:11.197942	2025-11-13 15:45:11.197942
72	339	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"david.437018@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2024-07-22","Fecha de asignación":"2024-07-22","Nombre del empleado":"DAVID VAZQUEZ DE LA CRUZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"9934350730","Correo de trabajo":"david.vazquez@afirma.solutions","Correo electrónico personal":"david.437018@gmail.com"}}	2025-11-13 15:45:11.200044	2025-11-13 15:45:11.200044
73	340	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"cc.espinosa@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-07-22","Fecha de asignación":"2024-07-22","Nombre del empleado":"CARLOS ARMANDO CALDERON ESPINOSA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"56 3664 5523","Correo de trabajo":"carlos.calderon@afirma.solutions","Correo electrónico personal":"cc.espinosa@hotmail.com"}}	2025-11-13 15:45:11.202107	2025-11-13 15:45:11.202107
74	341	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"ELIASLM@GMAIL.COM","original_row":{"CLIENTE":"AFIRMA","Célula":"RPA","Fecha de ingreso":"2024-07-29","Fecha de asignación":"2025-09-01","Nombre del empleado":"LUZ MARIA ELIAS SEASTIAN","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"RPA","Tarifa inicial de contratación":"750","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4424751149","Correo de trabajo":"luz.elias@afirma.solutions","Correo electrónico personal":"ELIASLM@GMAIL.COM"}}	2025-11-13 15:45:11.206944	2025-11-13 15:45:11.206944
75	342	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"enriquecl1024@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2024-08-07","Fecha de asignación":"2024-08-07","Nombre del empleado":"ENRIQUE CRUZ LIMON","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"RPA","Tarifa inicial de contratación":"N/A Proyecto Cerrado","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4428800532","Correo de trabajo":"enrique.cruz@afirma.solutions","Correo electrónico personal":"enriquecl1024@gmail.com"}}	2025-11-13 15:45:11.209331	2025-11-13 15:45:11.209331
76	343	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"eduardo.0702.nunez@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-08-27","Fecha de asignación":"2024-08-27","Nombre del empleado":"EDUARDO PASTOR NUÑEZ MARTINEZ-2","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5578663707","Teléfono personal":"5540043455","Correo de trabajo":"eduardo.martinez@afirma.solutions","Correo electrónico personal":"eduardo.0702.nunez@gmail.com"}}	2025-11-13 15:45:11.210989	2025-11-13 15:45:11.210989
77	344	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"oscarulises5552@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-09-03","Fecha de asignación":"2024-09-03","Nombre del empleado":"OSCAR ULISES ACOSTA GUERRERO-2","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4428787989","Correo de trabajo":"ulises.acosta@afirma.solutions","Correo electrónico personal":"oscarulises5552@gmail.com"}}	2025-11-13 15:45:11.214102	2025-11-13 15:45:11.214102
78	345	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"STAFF – PMO","proyecto":"STAFF","sgmm":"X","vida":"X","correo_personal":"faby_vr@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – PMO","Fecha de ingreso":"2024-08-19","Fecha de asignación":"2024-08-19","Nombre del empleado":"LAURA FABIOLA VALENCIA RODRIGUEZ","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"STAFF","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"7223958614","Correo de trabajo":"laura.valencia@afirma-solutions.com","Correo electrónico personal":"faby_vr@hotmail.com"}}	2025-11-13 15:45:11.21584	2025-11-13 15:45:11.21584
79	346	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"paredes.yatziri@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-10-17","Fecha de asignación":"2023-01-17","Nombre del empleado":"GUADALUPE YATZIRI PAREDES MEDINA 2","SGMM":"X","vida":"X","Posición":"Analista","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"523","Área":"ATVANTTI","Teléfono laboral":"4131002127","Teléfono personal":"4131002127","Correo de trabajo":"guadalupe.paredes@afirma.solutions","Correo electrónico personal":"paredes.yatziri@gmail.com"}}	2025-11-13 15:45:11.217952	2025-11-13 15:45:11.217952
80	347	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"aaronsotormz@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-12-02","Fecha de asignación":"2024-12-02","Nombre del empleado":"AARON SOTO RAMIREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4151490032","Correo de trabajo":"aaron.soto@afirma.solutions","Correo electrónico personal":"aaronsotormz@gmail.com"}}	2025-11-13 15:45:11.221072	2025-11-13 15:45:11.221072
81	348	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"jtobonorozco@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2024-09-17","Fecha de asignación":"2025-07-01","Nombre del empleado":"JOSE JAVIER TOBON OROZCO","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"RPA","Tarifa inicial de contratación":"N/A Proyecto Cerrado","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"6182162722","Correo de trabajo":"jose.tobon@afirma-solutions.com","Correo electrónico personal":"jtobonorozco@gmail.com"}}	2025-11-13 15:45:11.223288	2025-11-13 15:45:11.223288
82	349	import_meta	\N	\N	\N	\N	{"cliente":"PLAYTOPIA","celula":"PLAYTOPIA","proyecto":"PLAYTOPIA","sgmm":"X","vida":"X","correo_personal":"nidiacmh@gmail.com","original_row":{"CLIENTE":"PLAYTOPIA","Célula":"PLAYTOPIA","Fecha de ingreso":"2025-02-04","Fecha de asignación":"2025-03-14","Nombre del empleado":"NIDIA CAROLINA MEZA HERNANDEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"PLAYTOPIA","Tarifa inicial de contratación":"","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4775973194","Correo de trabajo":"nidia.meza@afirma.solutions","Correo electrónico personal":"nidiacmh@gmail.com"}}	2025-11-13 15:45:11.225034	2025-11-13 15:45:11.225034
83	350	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – TI","proyecto":"STAFF TI","sgmm":"X","vida":"X","correo_personal":"alonsoeduardo.1324@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2025-02-04","Fecha de asignación":"2025-09-01","Nombre del empleado":"EDUARDO BERNABE ALONSO","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"STAFF TI","Tarifa inicial de contratación":"","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4434200002","Correo de trabajo":"eduardo.bernabe@afirma.solutions","Correo electrónico personal":"alonsoeduardo.1324@gmail.com"}}	2025-11-13 15:45:11.22669	2025-11-13 15:45:11.22669
84	351	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"MIGRACION AGAVE","proyecto":"MIGRACION AGAVE","sgmm":"X","vida":"X","correo_personal":"zowarin@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"MIGRACION AGAVE","Fecha de ingreso":"2025-02-17","Fecha de asignación":"2025-11-13","Nombre del empleado":"IVAN UAPEANI RAMOS ZEPEDA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"MIGRACION AGAVE","Tarifa inicial de contratación":"N/A","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4421812633","Correo de trabajo":"ivan.ramos@afirma.solutions","Correo electrónico personal":"zowarin@gmail.com"}}	2025-11-13 15:45:11.230108	2025-11-13 15:45:11.230108
85	352	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PERSONAL","proyecto":"BANCA PERSONAL","sgmm":"X","vida":"X","correo_personal":"auflores.es@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-02-24","Fecha de asignación":"2025-02-24","Nombre del empleado":"AURORA FLORES ESTRADA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5610833959","Correo de trabajo":"aurora.flores@afirma.solutions","Correo electrónico personal":"auflores.es@gmail.com"}}	2025-11-13 15:45:11.232081	2025-11-13 15:45:11.232081
86	353	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BOR","proyecto":"BOR","sgmm":"X","vida":"X","correo_personal":"erhico@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2025-02-28","Fecha de asignación":"2025-02-28","Nombre del empleado":"ERIC HIGAREDA COLIN","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BOR","Tarifa inicial de contratación":"745.72","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7221789718","Correo de trabajo":"eric.higareda@afirma.solutions","Correo electrónico personal":"erhico@gmail.com"}}	2025-11-13 15:45:11.234345	2025-11-13 15:45:11.234345
87	354	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PERSONAL","proyecto":"BANCA PERSONAL","sgmm":"X","vida":"X","correo_personal":"josecorrea2702@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-03-17","Fecha de asignación":"2025-03-17","Nombre del empleado":"JOSE MIGUEL CORREA MORALES","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7774431898","Correo de trabajo":"jose.correa@afirma.solutions","Correo electrónico personal":"josecorrea2702@gmail.com"}}	2025-11-13 15:45:11.236666	2025-11-13 15:45:11.236666
88	355	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PRIVADA","proyecto":"BANCA PRIVADA","sgmm":"X","vida":"X","correo_personal":"san.her.hector@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-03-17","Fecha de asignación":"2025-03-17","Nombre del empleado":"HECTOR SANCHEZ HERNANDEZ 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"2462170674","Teléfono personal":"2462170674","Correo de trabajo":"hector.sanchez@afirma.solutions","Correo electrónico personal":"san.her.hector@gmail.com"}}	2025-11-13 15:45:11.239989	2025-11-13 15:45:11.239989
89	356	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"INVERSIONES","proyecto":"INVERSIONES","sgmm":"X","vida":"X","correo_personal":"juancarlossalgado2411@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INVERSIONES","Fecha de ingreso":"2025-03-17","Fecha de asignación":"2025-03-17","Nombre del empleado":"JUAN CARLOS SALGADO MARTINEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"INVERSIONES","Tarifa inicial de contratación":"900","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5548177809","Correo de trabajo":"juan.salgado@afirma.solutions","Correo electrónico personal":"juancarlossalgado2411@gmail.com"}}	2025-11-13 15:45:11.242974	2025-11-13 15:45:11.242974
90	357	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PRIVADA","proyecto":"BANCA PRIVADA","sgmm":"X","vida":"X","correo_personal":"bracamontesquinteroc@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-03-18","Fecha de asignación":"2025-03-18","Nombre del empleado":"CARLOS BRACAMONTES QUINTERO 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5532075363","Correo de trabajo":"carlos.bracamontes@afirma.solutions","Correo electrónico personal":"bracamontesquinteroc@gmail.com"}}	2025-11-13 15:45:11.245973	2025-11-13 15:45:11.245973
91	358	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PERSONAL","proyecto":"BANCA PERSONAL","sgmm":"X","vida":"X","correo_personal":"eduardoarzate017@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-03-20","Fecha de asignación":"2025-03-20","Nombre del empleado":"LUIS EDUARDO ARZATE ARIAS","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7294466006","Correo de trabajo":"luis.arzate@afirma.solutions","Correo electrónico personal":"eduardoarzate017@gmail.com"}}	2025-11-13 15:45:11.24859	2025-11-13 15:45:11.24859
92	359	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS","sgmm":"X","vida":"X","correo_personal":"luis.grimis@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-04-14","Fecha de asignación":"2025-04-14","Nombre del empleado":"LUIS ALBERTO GRIMALDO ROBLES","SGMM":"X","vida":"X","Posición":"SEGUROS ZAURICH","Proyecto":"SEGUROS","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"419 118 9660","Correo de trabajo":"luis.grimaldo@afirma.solutions","Correo electrónico personal":"luis.grimis@gmail.com"}}	2025-11-13 15:45:11.250609	2025-11-13 15:45:11.250609
93	360	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PRIVADA","proyecto":"BANCA PRIVADA","sgmm":"X","vida":"X","correo_personal":"fredysolis86@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-23","Nombre del empleado":"FREDY OLDAIR SOLIS PORTILLA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":7711494558,"Correo de trabajo":"fredy.solis@afirma.solutions","Correo electrónico personal":"fredysolis86@gmail.com"}}	2025-11-13 15:45:11.252973	2025-11-13 15:45:11.252973
94	361	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"CBT-DIGITAL","proyecto":"CBT - DIGITAL","sgmm":"X","vida":"X","correo_personal":"bisman.lemus@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"CBT-DIGITAL","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-23","Nombre del empleado":"BISMAN ABIMAEL PEREZ LEMUS","SGMM":"X","vida":"X","Posición":"Desarrollador Android","Proyecto":"CBT - DIGITAL","Tarifa inicial de contratación":"663.53","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"ci","Correo de trabajo":"bisman.perez@afirma.solutions","Correo electrónico personal":"bisman.lemus@gmail.com"}}	2025-11-13 15:45:11.256411	2025-11-13 15:45:11.256411
95	362	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RECUPERACIONES","proyecto":"RECUPERACIONES","sgmm":"X","vida":"X","correo_personal":"grireyes@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-23","Nombre del empleado":"GRISELDA REYES BAUTISTA","SGMM":"X","vida":"X","Posición":"Business Analyst","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":800,"Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4463101622","Correo de trabajo":"griselda.reyes@afirma.solutions","Correo electrónico personal":"grireyes@gmail.com"}}	2025-11-13 15:45:11.258484	2025-11-13 15:45:11.258484
96	363	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RECUPERACIONES","proyecto":"RECUPERACIONES","sgmm":"X","vida":"X","correo_personal":"mmiranda.gabriela@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-29","Nombre del empleado":"MARIA GABRIELA MIRANDA RIVERA","SGMM":"X","vida":"X","Posición":"Business Analyst","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"800","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4421563187","Correo de trabajo":"maria.miranda@afirma.solutions","Correo electrónico personal":"mmiranda.gabriela@gmail.com"}}	2025-11-13 15:45:11.260817	2025-11-13 15:45:11.260817
97	364	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"STAFF – PMO","proyecto":"STAFF - PMO","sgmm":"X","vida":"X","correo_personal":"ABIGAIL.GALINDOT@HOTMAIL.COM","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – PMO","Fecha de ingreso":"2025-05-12","Fecha de asignación":"2025-09-01","Nombre del empleado":"ABIGAIL GALINDO TOVAR","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"STAFF - PMO","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4428682311","Correo de trabajo":"abigail.galindo@afirma-solutions.com","Correo electrónico personal":"ABIGAIL.GALINDOT@HOTMAIL.COM"}}	2025-11-13 15:45:11.264578	2025-11-13 15:45:11.264578
98	365	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PERSONAL","proyecto":"BANCA PERSONAL","sgmm":"X","vida":"X","correo_personal":"fredy97daniel@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-05-22","Fecha de asignación":"2025-05-22","Nombre del empleado":"FREDI DANIEL CIFUENTES ROBLEDO","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"9621161646","Correo de trabajo":"fredi.cifuentes@afirma.solutions","Correo electrónico personal":"fredy97daniel@gmail.com"}}	2025-11-13 15:45:11.266183	2025-11-13 15:45:11.266183
99	366	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RECUPERACIONES","proyecto":"RECUPERACIONES","sgmm":"X","vida":"X","correo_personal":"tauroamp@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-05-26","Fecha de asignación":"2025-05-26","Nombre del empleado":"ALEXANDRE MARTINEZ PINO","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"900","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"7713973086","Correo de trabajo":"alexandre.martinez@afirma.solutions","Correo electrónico personal":"tauroamp@gmail.com"}}	2025-11-13 15:45:11.268235	2025-11-13 15:45:11.268235
100	367	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"leo.cruz.ing@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-05-26","Fecha de asignación":"2025-05-26","Nombre del empleado":"LEONARDO LEHI CRUZ ARREGUIN","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"860","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5522541939","Correo de trabajo":"leonardo.cruz@afirma.solutions","Correo electrónico personal":"leo.cruz.ing@gmail.com"}}	2025-11-13 15:45:11.271466	2025-11-13 15:45:11.271466
101	368	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – PMO","sgmm":"X","vida":"X","correo_personal":"danyh180202@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – PMO","Fecha de ingreso":"2025-06-10","Fecha de asignación":"2025-06-09","Nombre del empleado":"DANIELA HERRERA URBINA","SGMM":"X","vida":"X","Posición":"Auxiliar Administrativo","Proyecto":"","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5560640020","Correo de trabajo":"daniela.herrera@afirma-solutions.com","Correo electrónico personal":"danyh180202@gmail.com"}}	2025-11-13 15:45:11.273826	2025-11-13 15:45:11.273826
102	369	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"INTEGRACIÓN SERVICIOS","proyecto":"INTEGRACION SERVICIOS","sgmm":"X","vida":"X","correo_personal":"jeshua_11_7@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INTEGRACIÓN SERVICIOS ","Fecha de ingreso":"2025-06-16","Fecha de asignación":"2025-06-16","Nombre del empleado":"ALBERTO DE JESUS AGUILAR LOPEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"INTEGRACION SERVICIOS","Tarifa inicial de contratación":"743.38","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"5514903426","Correo de trabajo":"alberto.aguilar@afirma.solutions","Correo electrónico personal":"jeshua_11_7@hotmail.com"}}	2025-11-13 15:45:11.275189	2025-11-13 15:45:11.275189
103	370	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"INTEGRACIÓN SERVICIOS","proyecto":"INTEGRACIÓN SERVICIOS","sgmm":"X","vida":"X","correo_personal":"esmazariego@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INTEGRACIÓN SERVICIOS ","Fecha de ingreso":"2025-06-16","Fecha de asignación":"2025-06-16","Nombre del empleado":"EDUARDO SANTIAGO MAZARIEGO MORENO","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"INTEGRACIÓN SERVICIOS","Tarifa inicial de contratación":"969.40","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"442 747 9963","Correo de trabajo":"eduardo.mazariego@afirma.solutions","Correo electrónico personal":"esmazariego@gmail.com"}}	2025-11-13 15:45:11.276798	2025-11-13 15:45:11.276798
104	371	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"INTEGRACIÓN SERVICIOS","proyecto":"INTEGRACIÓN SERVICIOS","sgmm":"X","vida":"X","correo_personal":"erikcruzm0190@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INTEGRACIÓN SERVICIOS ","Fecha de ingreso":"2025-06-16","Fecha de asignación":"2025-06-16","Nombre del empleado":"ERIK CRUZ MUÑOZ","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"INTEGRACIÓN SERVICIOS","Tarifa inicial de contratación":"969.40","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"55 5400 8726","Correo de trabajo":"erik.cruz@afirma.solutions","Correo electrónico personal":"erikcruzm0190@gmail.com"}}	2025-11-13 15:45:11.280156	2025-11-13 15:45:11.280156
105	372	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RIESGOS","proyecto":"RIESGOS","sgmm":"X","vida":"X","correo_personal":"verogl92@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RIESGOS","Fecha de ingreso":"2025-06-24","Fecha de asignación":"2025-06-24","Nombre del empleado":"MARIA VERONICA DEL SOCORRO GONZALEZ LANZAGORTA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RIESGOS","Tarifa inicial de contratación":"773.28","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"5526537380","Correo de trabajo":"maria.gonzalez@afirma.solutions","Correo electrónico personal":"verogl92@hotmail.com"}}	2025-11-13 15:45:11.282393	2025-11-13 15:45:11.282393
106	373	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS INTERNO","proyecto":"SEGUROS INTERNO","sgmm":"X","vida":"X","correo_personal":"eftorresp@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2025-07-07","Fecha de asignación":"2025-07-07","Nombre del empleado":"EFREN TORRES PEREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4423566253","Correo de trabajo":"efren.torres@afirma.solutions","Correo electrónico personal":"eftorresp@gmail.com"}}	2025-11-13 15:45:11.284411	2025-11-13 15:45:11.284411
107	374	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURIZCH","sgmm":"X","vida":"X","correo_personal":"gladiolagpe@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-07-14","Fecha de asignación":"2025-07-14","Nombre del empleado":"GLADYS GUADALUPE GARCIA LOPEZ","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS ZURIZCH","Tarifa inicial de contratación":"850","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5529652602","Correo de trabajo":"gladys.garcia@afirma.solutions","Correo electrónico personal":"gladiolagpe@gmail.com"}}	2025-11-13 15:45:11.287103	2025-11-13 15:45:11.287103
108	375	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS","sgmm":"X","vida":"X","correo_personal":"juanrobledo.desarrollo@gmial.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-07-14","Fecha de asignación":"2025-07-14","Nombre del empleado":"JUAN CARLOS ROBLEDO ORTIZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"SEGUROS","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5563972631","Correo de trabajo":"juan.robledo@afirma.solutions","Correo electrónico personal":"juanrobledo.desarrollo@gmial.com"}}	2025-11-13 15:45:11.290193	2025-11-13 15:45:11.290193
109	376	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS","sgmm":"X","vida":"X","correo_personal":"carlocompagny@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-07-16","Fecha de asignación":"2025-07-16","Nombre del empleado":"CARLO IVAN RAMIREZ COMPAGNY","SGMM":"X","vida":"X","Posición":"Gestor de Infraestructura","Proyecto":"SEGUROS","Tarifa inicial de contratación":"900","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"55 3139 9186","Correo de trabajo":"ivan.ramirez@afirma.solutions","Correo electrónico personal":"carlocompagny@gmail.com"}}	2025-11-13 15:45:11.292181	2025-11-13 15:45:11.292181
110	377	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RIESGOS","proyecto":"RIESGOS","sgmm":"X","vida":"X","correo_personal":"lucerorubygachuzv4aitsoeh@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RIESGOS","Fecha de ingreso":"2025-08-04","Fecha de asignación":"2025-08-04","Nombre del empleado":"LUCERO RUBY GACHUZ VAZQUEZ","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RIESGOS","Tarifa inicial de contratación":"778.65","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"7721411433","Correo de trabajo":"lucero.gachuz@afirma.solutions","Correo electrónico personal":"lucerorubygachuzv4aitsoeh@gmail.com"}}	2025-11-13 15:45:11.294216	2025-11-13 15:45:11.294216
111	378	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"SEGUROS ZURICH","proyecto":"SEGUROS ZURICH","sgmm":"X","vida":"X","correo_personal":"dencruz417@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-08-26","Fecha de asignación":"2025-08-26","Nombre del empleado":"DENISSE AZUCENA CRUZ ALVARADO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5518163650","Correo de trabajo":"denisse.cruz@afirma.solutions","Correo electrónico personal":"dencruz417@gmail.com"}}	2025-11-13 15:45:11.297682	2025-11-13 15:45:11.297682
112	379	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – PMO","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"psicmae@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – PMO","Fecha de ingreso":"2025-09-01","Fecha de asignación":"2025-09-01","Nombre del empleado":"MIRIAM ARREDONDO ESTRADA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RPA","Tarifa inicial de contratación":"403.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"+52 1 442 181 6470","Correo de trabajo":"miriam.arredondo@afirma.solutions","Correo electrónico personal":"psicmae@gmail.com"}}	2025-11-13 15:45:11.300021	2025-11-13 15:45:11.300021
113	380	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","proyecto":"Área de Riesgos","sgmm":"X","vida":"X","correo_personal":"cesarivan.rojas.salazar@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-09-03","Fecha de asignación":"2025-09-03","Nombre del empleado":"CESAR IVAN ROJAS SALAZAR","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"Área de Riesgos","Tarifa inicial de contratación":"970","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"5512496044","Correo de trabajo":"cesar.rojas@afirma.solutions","Correo electrónico personal":"cesarivan.rojas.salazar@gmail.com"}}	2025-11-13 15:45:11.302019	2025-11-13 15:45:11.302019
114	381	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BOR","proyecto":"BOR","sgmm":"X","correo_personal":"r_guillermo0@yahoo.com.mx","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2025-09-08","Fecha de asignación":"2025-09-08","Nombre del empleado":"JERONIMO GUILLERMO ROJAS PINEDA","SGMM":"X","vida":"","Posición":"Desarrollador Middleware","Proyecto":"BOR","Tarifa inicial de contratación":"650","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"+52 1 442 122 9591","Correo de trabajo":"sergio.fernandez@afirma.solutions","Correo electrónico personal":"r_guillermo0@yahoo.com.mx"}}	2025-11-13 15:45:11.306351	2025-11-13 15:45:11.306351
115	382	import_meta	\N	\N	\N	\N	{"cliente":"AFIRMA","celula":"STAFF – RRHH","proyecto":"RH","sgmm":"X","vida":"X","correo_personal":"psicomonrodriguez@gmail.com","original_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – RRHH","Fecha de ingreso":"2025-09-08","Fecha de asignación":"2025-09-08","Nombre del empleado":"MONICA FANDILA RODRIGUEZ PEREZ","SGMM":"X","vida":"X","Posición":"Reclutador","Proyecto":"RH","Tarifa inicial de contratación":"N/A","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5571953897","Correo de trabajo":"monica.rodriguez@afirma-solutions.com","Correo electrónico personal":"psicomonrodriguez@gmail.com"}}	2025-11-13 15:45:11.310007	2025-11-13 15:45:11.310007
116	383	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"STAFF – PMO","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"eliezersantiago-100@outlook.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – PMO","Fecha de ingreso":"2025-09-10","Fecha de asignación":"2025-09-10","Nombre del empleado":"ELIEZER SANTIAGO FUENTES 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"RPA","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7971060312","Correo de trabajo":"eliezer.santiago@afirma.solutions","Correo electrónico personal":"eliezersantiago-100@outlook.com"}}	2025-11-13 15:45:11.313031	2025-11-13 15:45:11.313031
117	384	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"BANCA PRIVADA","proyecto":"BANCA PRIVADA","sgmm":"X","vida":"X","correo_personal":"ricardo.camacho.info@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-09-22","Fecha de asignación":"2025-09-22","Nombre del empleado":"RICARDO CAMACHO TENORIO 2","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":743.3,"Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5520147557","Correo de trabajo":"ricardo.camacho@afirma.solutions","Correo electrónico personal":"ricardo.camacho.info@gmail.com"}}	2025-11-13 15:45:11.31635	2025-11-13 15:45:11.31635
118	385	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"cut_garcia@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-09-29","Fecha de asignación":"2025-10-29","Nombre del empleado":"CUTBERTO GARCIA TAMAYO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"738","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4611249957","Correo de trabajo":"cutberto.garcia@afirma.solutions","Correo electrónico personal":"cut_garcia@hotmail.com"}}	2025-11-13 15:45:11.320771	2025-11-13 15:45:11.320771
119	386	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"adriancortes-25@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2025-09-30","Fecha de asignación":"2025-09-30","Nombre del empleado":"LUIS ADRIAN ELIAS VALDEZ CORTES","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RPA","Tarifa inicial de contratación":714,"Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5537116759","Correo de trabajo":"luis.valdez@afirma.solutions","Correo electrónico personal":"adriancortes-25@hotmail.com"}}	2025-11-13 15:45:11.324468	2025-11-13 15:45:11.324468
120	388	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"ang.huertam@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-06","Fecha de asignación":"2025-10-06","Nombre del empleado":"MIGUEL ANGEL HUERTA MOCTEZUMA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"55 74417598","Correo de trabajo":"miguel.huerta@afirma.solutions","Correo electrónico personal":"ang.huertam@gmail.com"}}	2025-11-13 15:45:11.416634	2025-11-13 15:45:11.416634
121	389	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"axel.reyes159@yahoo.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-13","Fecha de asignación":"2025-10-13","Nombre del empleado":"BRUNO AXEL REYES MENDEZ","SGMM":"X","vida":"X","Posición":"Analytics","Proyecto":"ATVANTTI","Tarifa inicial de contratación":551,"Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"5540687670","Correo de trabajo":"bruno.reyes@afirma.solutions","Correo electrónico personal":"axel.reyes159@yahoo.com"}}	2025-11-13 15:45:11.426805	2025-11-13 15:45:11.426805
122	390	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"usielurbina@yahoo.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-13","Fecha de asignación":"2025-10-13","Nombre del empleado":"USIEL URBINA ECHEVERRIA","SGMM":"X","vida":"X","Posición":"Desarrollador PL/SQL","Proyecto":"ATVANTTI","Tarifa inicial de contratación":684.48,"Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"442-142-2323","Correo de trabajo":"usiel.urbina@afirma.solutions","Correo electrónico personal":"usielurbina@yahoo.com"}}	2025-11-13 15:45:11.432869	2025-11-13 15:45:11.432869
123	391	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"aguerrerom6@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-14","Fecha de asignación":"2025-10-14","Nombre del empleado":"ANGELICA GUERRERO MEDINA","SGMM":"X","vida":"X","Posición":"DESARROLLADOR COBOL","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4423057742","Correo de trabajo":"angelica.guerrero@afirma.solutions","Correo electrónico personal":"aguerrerom6@gmail.com"}}	2025-11-13 15:45:11.436237	2025-11-13 15:45:11.436237
124	392	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"ch_rron@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-14","Fecha de asignación":"2025-10-14","Nombre del empleado":"JAVIER PEREZ BARRON","SGMM":"X","vida":"X","Posición":"DESARROLLADOR COBOL","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"N/A","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"0457711632401","Correo de trabajo":"javier.perez@afirma.solutions","Correo electrónico personal":"ch_rron@hotmail.com"}}	2025-11-13 15:45:11.439174	2025-11-13 15:45:11.439174
125	393	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","proyecto":"OPERATIONAL RISK MITIGATION","sgmm":"X","vida":"X","correo_personal":"dnaisgone@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-10-20","Fecha de asignación":"2025-10-20","Nombre del empleado":"DIANA ANGELICA RAMIREZ HERNANDEZ 3","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"OPERATIONAL RISK MITIGATION","Tarifa inicial de contratación":461.19,"Área":"LEITMOTIV","Teléfono laboral":"5580002369","Teléfono personal":"4422674061","Correo de trabajo":"diana.ramirez@afirma.solutions","Correo electrónico personal":"dnaisgone@gmail.com"}}	2025-11-13 15:45:11.442617	2025-11-13 15:45:11.442617
126	394	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","proyecto":"AFIRMA","sgmm":"X","vida":"X","correo_personal":"fernandasanchezperez97@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-10-27","Fecha de asignación":"2025-10-28","Nombre del empleado":"MARIA FERNANDA SANCHEZ PEREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"AFIRMA","Tarifa inicial de contratación":400,"Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"442 5663006","Correo de trabajo":"maria.sanchez@afirma.solutions","Correo electrónico personal":"fernandasanchezperez97@gmail.com"}}	2025-11-13 15:45:11.44791	2025-11-13 15:45:11.44791
127	395	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"ATVANTTI","proyecto":"ATVANTTI","sgmm":"X","vida":"X","correo_personal":"alejandroisidromartinez@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-28","Fecha de asignación":"2025-10-28","Nombre del empleado":"ALEJANDRO ISIDRO MARTINEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":515,"Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4423809624","Correo de trabajo":"alejandro.isidro@afirma.solutions","Correo electrónico personal":"alejandroisidromartinez@gmail.com"}}	2025-11-13 15:45:11.450863	2025-11-13 15:45:11.450863
128	396	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"alfred_ap60@hotmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2025-10-28","Fecha de asignación":"2025-10-28","Nombre del empleado":"ALFREDO AGUILAR PUGA","SGMM":"X","vida":"X","Posición":"Desarrollador BI","Proyecto":"RPA","Tarifa inicial de contratación":"689.86","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5561322528","Correo de trabajo":"alfredo.aguilar@afirma.solutions","Correo electrónico personal":"alfred_ap60@hotmail.com"}}	2025-11-13 15:45:11.45446	2025-11-13 15:45:11.45446
129	397	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","celula":"RPA","proyecto":"RPA","sgmm":"X","vida":"X","correo_personal":"ghfernando@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2025-10-28","Fecha de asignación":"2025-10-28","Nombre del empleado":"FERNANDO GARCIA HIDEROA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RPA","Tarifa inicial de contratación":"778.65","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5544926636","Correo de trabajo":"fernando.garcia@afirma.solutions","Correo electrónico personal":"ghfernando@gmail.com"}}	2025-11-13 15:45:11.458017	2025-11-13 15:45:11.458017
130	398	import_meta	\N	\N	\N	\N	{"cliente":"BANCO SANTANDER","proyecto":"OPERATIONAL RISK MITIGATION","sgmm":"X","vida":"X","correo_personal":"jesusluisfernando@gmail.com","original_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-11-03","Fecha de asignación":"2025-11-13","Nombre del empleado":"JESUS LUIS FERNANDO HERNANDEZ LUNA 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"OPERATIONAL RISK MITIGATION","Tarifa inicial de contratación":461.19,"Área":"LEITMOTIV","Teléfono laboral":"5580002369","Teléfono personal":"4421223211","Correo de trabajo":"jesus.hernandez@afirma.solutions","Correo electrónico personal":"jesusluisfernando@gmail.com"}}	2025-11-13 15:45:11.46071	2025-11-13 15:45:11.46071
\.


--
-- TOC entry 5231 (class 0 OID 49617)
-- Dependencies: 255
-- Data for Name: employee_vacations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_vacations (id, employee_name, start_date, end_date, status, created_at, employee_id, updated_at) FROM stdin;
1	Test	2025-02-01	2025-02-07	Pendiente	2026-01-30 14:02:16.630461	1	2026-01-30 14:02:16.630461
2	ROGELIO MARTINEZ DIAZ	2026-02-02	2026-02-02	Aprobado	2026-01-30 14:03:07.373948	322	2026-01-30 14:08:24.729044
3	ivonne villalba martinez	2026-02-02	2026-02-06	Pendiente	2026-01-30 14:13:12.846155	813	2026-01-30 14:18:53.576145
\.


--
-- TOC entry 5229 (class 0 OID 49310)
-- Dependencies: 253
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, first_name, last_name, email, "position", start_date, created_at) FROM stdin;
\.


--
-- TOC entry 5201 (class 0 OID 24648)
-- Dependencies: 225
-- Data for Name: employees_v2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees_v2 (id, first_name, last_name, email, phone, personal_phone, employee_code, position_id, entity_id, hire_date, start_date, birth_date, address, city, state, postal_code, country, employment_type, contract_end_date, status, created_at, updated_at, created_by, updated_by, area_id, project_id, cell_id, address_street, address_city, address_state, address_postal_code, address_country, exterior_number, interior_number, colonia, curp, rfc, nss, passport, gender, marital_status, nationality, blood_type) FROM stdin;
813	ivonne	villalba martinez	ivo@mail.com	\N	\N	AF1001	\N	98	2026-01-30	\N	2026-01-30	falsa	cdmx	Ciudad de México	50001	México	Permanente	\N	Activo	2026-01-30 14:12:43.501244	2026-01-30 14:12:43.501244	web	\N	137	165	166	\N	\N	\N	\N	México	123	\N	si	RSFD84125741DRADSA	RSFD84125741D	10546834684	\N	Prefiero no decir	Soltero(a)	Mexicana	O+
354	JOSE	MIGUEL CORREA MORALES	jose.correa@afirma.solutions	5580002369	7774431898	\N	\N	\N	2025-03-17	2025-03-17	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.235727	2025-11-13 15:45:11.235727	import_direct	\N	\N	4	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
384	RICARDO	CAMACHO TENORIO 2	ricardo.camacho@afirma.solutions	5580002369	5520147557	\N	\N	\N	2025-09-22	2025-09-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.315422	2025-11-13 15:45:11.315422	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
388	MIGUEL	ANGEL HUERTA MOCTEZUMA	miguel.huerta@afirma.solutions	5580002369	55 74417598	\N	\N	10	2025-10-06	2025-10-06	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.41251	2025-11-13 15:45:11.41251	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
364	ABIGAIL	GALINDO TOVAR	abigail.galindo@afirma-solutions.com	5580002369	4428682311	\N	\N	\N	2025-05-12	2025-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.263804	2025-11-13 15:45:11.263804	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
376	CARLO	IVAN RAMIREZ COMPAGNY	ivan.ramirez@afirma.solutions	5580002369	55 3139 9186	\N	\N	\N	2025-07-16	2025-07-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.291554	2025-11-13 15:45:11.291554	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
385	CUTBERTO	GARCIA TAMAYO	cutberto.garcia@afirma.solutions	5580002369	4611249957	\N	\N	10	2025-09-29	2025-10-29	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.318683	2025-11-13 15:45:11.318683	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
395	ALEJANDRO	ISIDRO MARTINEZ	alejandro.isidro@afirma.solutions	5580002369	4423809624	\N	\N	10	2025-10-28	2025-10-28	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.450016	2025-11-13 15:45:11.450016	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	Carlos	(Sin Apellido)	carlos.martinez@afirma.com	+57-1-3456789	\N	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:10:14.390417	2025-11-13 15:10:14.390417	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	Roberto	(Sin Apellido)	roberto.sanchez@afirma.com	+57-1-5678901	\N	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:10:14.396598	2025-11-13 15:10:14.396598	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
314	PANFILO	EDUARDO PAREDES COLIN	edpardes@yahoo.com	5580002369	5532383997	\N	\N	\N	2025-04-01	2025-04-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.124377	2025-11-13 15:45:11.124377	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
333	EDGAR	JONNATHAN MORALES LUCIO	edgar.morales@afirma.solutions	5580002369	4424234316	\N	\N	\N	2024-06-05	2024-06-05	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.183981	2025-11-13 15:45:11.183981	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
339	DAVID	VAZQUEZ DE LA CRUZ	david.vazquez@afirma.solutions	5580002369	9934350730	\N	\N	\N	2024-07-22	2024-07-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.199399	2025-11-13 15:45:11.199399	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
346	GUADALUPE	YATZIRI PAREDES MEDINA 2	guadalupe.paredes@afirma.solutions	4131002127	4131002127	\N	\N	10	2024-10-17	2023-01-17	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.217305	2025-11-13 15:45:11.217305	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
370	EDUARDO	SANTIAGO MAZARIEGO MORENO	eduardo.mazariego@afirma.solutions	5580002369	442 747 9963	\N	\N	12	2025-06-16	2025-06-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.276242	2025-11-13 15:45:11.276242	import_direct	\N	\N	10	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
390	USIEL	URBINA ECHEVERRIA	usiel.urbina@afirma.solutions	5580002369	442-142-2323	\N	\N	10	2025-10-13	2025-10-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.431708	2025-11-13 15:45:11.431708	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
290	GUSTAVO	HERNANDEZ MONTES DE OCA	gustavo.hernandez@afirma.solutions	5580002369	5621056735	\N	\N	\N	2023-05-02	2023-05-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.043205	2025-11-13 15:45:11.043205	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
306	HECTOR	GABRIEL ORTIZ MORA	hector.ortiz@afirma.solutions	5580002369	7775007400	\N	\N	\N	2023-09-25	2024-05-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.096698	2025-11-13 15:45:11.096698	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
327	ERICK	ALEJANDRO AVILA TORRES	erick.avila@afirma.solutions	\N	5519516301	\N	\N	\N	2024-04-22	2024-04-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.165433	2025-11-13 15:45:11.165433	import_direct	\N	\N	8	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
369	ALBERTO	DE JESUS AGUILAR LOPEZ	alberto.aguilar@afirma.solutions	5580002369	5514903426	\N	\N	12	2025-06-16	2025-06-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.274567	2025-11-13 15:45:11.274567	import_direct	\N	\N	10	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
374	GLADYS	GUADALUPE GARCIA LOPEZ	gladys.garcia@afirma.solutions	\N	5529652602	\N	\N	\N	2025-07-14	2025-07-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.285833	2025-11-13 15:45:11.285833	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
785	Ana Mar�a	Garc�a L�pez	ana.garcia@afirma.test	5551234567	5559876543	TEST001	\N	6	2025-11-13	\N	1985-03-15	\N	\N	\N	\N	México	Permanente	\N	En licencia	2025-11-13 22:49:54.285169	2025-11-21 08:12:25.827814	web	system	137	150	166	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
358	LUIS	EDUARDO ARZATE ARIAS	luis.arzate@afirma.solutions	5580002369	7294466006	\N	\N	\N	2025-03-20	2025-03-20	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.247871	2025-11-13 15:45:11.247871	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
360	FREDY	OLDAIR SOLIS PORTILLA	fredy.solis@afirma.solutions	5580002369	7711494558	\N	\N	\N	2025-04-23	2025-04-23	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.25215	2025-11-13 15:45:11.25215	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
361	BISMAN	ABIMAEL PEREZ LEMUS	bisman.perez@afirma.solutions	\N	ci	\N	\N	\N	2025-04-23	2025-04-23	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.25563	2025-11-13 15:45:11.25563	import_direct	\N	\N	8	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
341	LUZ	MARIA ELIAS SEASTIAN	luz.elias@afirma.solutions	\N	4424751149	\N	\N	\N	2024-07-29	2025-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.205786	2025-11-13 15:45:11.205786	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
367	LEONARDO	LEHI CRUZ ARREGUIN	leonardo.cruz@afirma.solutions	\N	5522541939	\N	\N	\N	2025-05-26	2025-05-26	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.270256	2025-11-13 15:45:11.270256	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
342	ENRIQUE	CRUZ LIMON	enrique.cruz@afirma.solutions	5580002369	4428800532	\N	\N	\N	2024-08-07	2024-08-07	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.208661	2025-11-13 15:45:11.208661	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
348	JOSE	JAVIER TOBON OROZCO	jose.tobon@afirma-solutions.com	\N	6182162722	\N	\N	\N	2024-09-17	2025-07-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.222554	2025-11-13 15:45:11.222554	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
357	CARLOS	BRACAMONTES QUINTERO 2	carlos.bracamontes@afirma.solutions	5580002369	5532075363	\N	\N	\N	2025-03-18	2025-03-18	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.24473	2025-11-13 15:45:11.24473	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
394	MARIA	FERNANDA SANCHEZ PEREZ	maria.sanchez@afirma.solutions	5580002369	442 5663006	\N	\N	\N	2025-10-27	2025-10-28	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.446774	2025-11-13 15:45:11.446774	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
286	OSCAR	ABARCA MURGA	oscar.abarca@afirma.solutions	5544422500	5544422500	\N	\N	10	2023-02-13	2023-02-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.030466	2025-11-13 15:45:11.030466	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
780	Ana	Rodríguez	ana.rodriguez.test@afirma.solutions	5512345001	\N	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 22:38:19.627418	2025-11-13 22:38:19.627418	integral-test	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
371	ERIK	CRUZ MUÑOZ	erik.cruz@afirma.solutions	5580002369	55 5400 8726	\N	\N	12	2025-06-16	2025-06-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.279006	2025-11-13 15:45:11.279006	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
386	LUIS	ADRIAN ELIAS VALDEZ CORTES	luis.valdez@afirma.solutions	\N	5537116759	\N	\N	\N	2025-09-30	2025-09-30	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.323653	2025-11-13 15:45:11.323653	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
779	María	González Test	maria.gonzalez.test@afirma.solutions	5511112222	5533334444	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Inactivo	2025-11-13 22:35:19.664441	2025-11-13 22:36:51.743292	test-script	system	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
781	Carlos	López	carlos.lopez.test@afirma.solutions	5512345002	\N	\N	\N	6	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 22:38:19.6945	2025-11-13 22:38:19.6945	integral-test	\N	2	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
347	AARON	SOTO RAMIREZ	aaron.soto@afirma.solutions	5580002369	4151490032	\N	\N	10	2024-12-02	2024-12-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.219669	2025-11-13 15:45:11.219669	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
323	JOSE	ANTONIO MENDEZ HUITRON	jose.mendez@afirma.solutions	5580002369	4421040895	\N	\N	\N	2024-02-21	2024-02-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.152711	2025-11-13 15:45:11.152711	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
330	MAURICIO	CARRASCO AYALA	mauricio.carrasco@afirma.solutions	5580002369	4421283972	\N	\N	\N	2024-05-13	2024-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.174174	2025-11-13 15:45:11.174174	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
351	IVAN	UAPEANI RAMOS ZEPEDA	ivan.ramos@afirma.solutions	5580002369	4421812633	\N	\N	\N	2025-02-17	2025-11-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.2284	2025-11-13 15:45:11.2284	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
363	MARIA	GABRIELA MIRANDA RIVERA	maria.miranda@afirma.solutions	5580002369	4421563187	\N	\N	\N	2025-04-23	2025-04-29	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.259898	2025-11-13 15:45:11.259898	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
310	ANDREA	ACEVES GUALITO	andrea.aceves@afirma.solutions	\N	4422719357	\N	\N	\N	2023-10-24	2025-11-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.111349	2025-11-13 15:45:11.111349	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
379	MIRIAM	ARREDONDO ESTRADA	miriam.arredondo@afirma.solutions	5580002369	+52 1 442 181 6470	\N	\N	\N	2025-09-01	2025-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.299328	2025-11-13 15:45:11.299328	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
391	ANGELICA	GUERRERO MEDINA	angelica.guerrero@afirma.solutions	5580002369	4423057742	\N	\N	10	2025-10-14	2025-10-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.435088	2025-11-13 15:45:11.435088	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
397	FERNANDO	GARCIA HIDEROA	fernando.garcia@afirma.solutions	5580002369	5544926636	\N	\N	98	2025-10-28	2025-10-28	\N	\N	\N	\N	\N	México	Permanente	\N	Activo	2025-11-13 15:45:11.457092	2025-11-20 10:45:32.411143	import_direct	system	137	68	166	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
299	SAMUEL	LOPEZ PEDRERO	samuel.lopez@afirma-solutions.com	5580002369	9934313125	\N	\N	\N	2023-07-24	2025-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.074102	2025-11-13 15:45:11.074102	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
392	JAVIER	PEREZ BARRON	javier.perez@afirma.solutions	5580002369	0457711632401	\N	\N	10	2025-10-14	2025-10-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.438089	2025-11-13 15:45:11.438089	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
294	ISMAEL	WENCESLAO BARRAGAN HERNANDEZ	ismael.barragan@afirma.solutions	5580002369	5532264475	\N	\N	\N	2023-06-05	2023-06-05	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.057002	2025-11-13 15:45:11.057002	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
313	ANDRES	HERNANDEZ LIMON	andres.hernandez@afirma.solutions	5580002369	7224490235	\N	\N	\N	2023-12-08	2023-12-08	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.120002	2025-11-13 15:45:11.120002	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
276	GARY	MANUEL VAZQUEZ RAYGOZA	gary.vazquez@afirma-solutions.com	4191138225	4191138225	\N	\N	98	2019-06-12	2021-07-13	\N	cerro silla	San José Iturbide	Guanajuato	37980	México	Permanente	\N	Activo	2025-11-13 15:45:10.997167	2025-11-21 10:40:34.54897	web	system	163	165	166	\N	\N	\N	\N	México	18	na	San jose campestre	\N	\N	\N	\N	\N	\N	\N	\N
331	AGUSTIN	SEVILLA SAIZ	agustin.sevilla@afirma.solutions	5580002369	4421280162	\N	\N	\N	2024-05-27	2024-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.179196	2025-11-13 15:45:11.179196	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	María	(Sin Apellido)	maria.rodriguez@afirma.com	+57-1-2345678	\N	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:10:14.385083	2025-11-13 15:10:14.385083	import_direct	\N	5	3	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
302	MIGUEL	ANGEL DEL RELLO PORTILLO	angel.portillo@afirma.solutions	5580002369	5587963107	\N	\N	\N	2023-08-01	2023-08-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.083328	2025-11-13 15:45:11.083328	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
332	DIEGO	URIEL ARTEAGA ZAMORA 2	diego.arteaga@afirma.solutions	5580002369	4422338246	\N	\N	10	2024-06-12	2024-06-12	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.181843	2025-11-13 15:45:11.181843	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
298	JOSE	DE JESUS RODRIGUEZ BALBUENA	jesus.rodriguez@afirma.solutions	5580002369	222 111 0016	\N	\N	\N	2023-07-10	2023-07-10	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.069117	2025-11-13 15:45:11.069117	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
335	MIGUEL	ANGEL ESPINOZA MEDINA	miguel.espinoza@afirma.solutions	\N	5519175961	\N	\N	\N	2024-06-17	2024-06-17	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.189163	2025-11-13 15:45:11.189163	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
345	LAURA	FABIOLA VALENCIA RODRIGUEZ	laura.valencia@afirma-solutions.com	\N	7223958614	\N	\N	\N	2024-08-19	2024-08-19	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.215106	2025-11-13 15:45:11.215106	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
398	JESUS	LUIS FERNANDO HERNANDEZ LUNA 2	jesus.hernandez@afirma.solutions	5580002369	4421223211	\N	\N	\N	2025-11-03	2025-11-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.459939	2025-11-13 19:05:19.330807	import_direct	system	4	5	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
278	JOSE	ANGEL LUNA BEJARANO	jangel.luna@afirma.solutions	5521412415	5521412415	\N	\N	\N	2021-03-01	2021-03-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.005093	2025-11-13 15:45:11.005093	import_direct	\N	\N	8	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
317	ANTONIO	ARATH MEDINA MEJIA	antonio.medina@afirma-solutions.com	5580002369	5527650787	\N	\N	\N	2024-01-10	2024-06-05	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.135348	2025-11-13 15:45:11.135348	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
352	AURORA	FLORES ESTRADA	aurora.flores@afirma.solutions	5580002369	5610833959	\N	\N	\N	2025-02-24	2025-02-24	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.231333	2025-11-13 15:45:11.231333	import_direct	\N	\N	4	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
368	DANIELA	HERRERA URBINA	daniela.herrera@afirma-solutions.com	\N	5560640020	\N	\N	\N	2025-06-10	2025-06-09	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.273215	2025-11-13 15:45:11.273215	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
288	ANA	LUCIEL MORENO SALAZAR	ana.moreno@afirma.solutions	5580002369	2281000613	\N	\N	\N	2023-04-24	2025-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.036293	2025-11-13 15:45:11.036293	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
273	JORGE	LUIS GALICIA PEDRAZA	administracion@afirma-solutions.com	5547718145	5547718145	\N	\N	\N	2018-07-16	2018-07-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:10.965234	2025-11-13 15:45:10.965234	import_direct	\N	\N	14	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
277	RAYMUNDO	MARTINEZ GARCIA	raymundo.martinez@afirma.solutions	5580002369	5513643502	\N	\N	\N	2019-09-02	2019-09-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.000834	2025-11-13 15:45:11.000834	import_direct	\N	\N	16	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
287	RICARDO	BLANCO DEANDA	ricardo.blanco@afirma.solutions	4423289296	4423289296	\N	\N	10	2023-02-13	2023-02-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.033902	2025-11-13 15:45:11.033902	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	Patricia	(Sin Apellido)	patricia.lopez@afirma.com	+57-1-4567890	\N	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:10:14.393964	2025-11-13 15:10:14.393964	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
788	Juan	Test Direccion	test.direccion.1763496072774@tes.com	5551234567	\N	\N	\N	6	2025-11-18	\N	\N	Calle Revolucion	Ciudad de Mexico	\N	06000	México	Permanente	\N	Activo	2025-11-18 14:01:12.911346	2025-11-21 16:28:54.880686	web	system	163	139	166	\N	\N	\N	\N	México	456C	Depto 8	Nueva Colonia	\N	\N	\N	\N	Masculino	\N	\N	\N
295	FATIMA	NATALIA RUIZ RIVERA	natalia.ruiz@afirma.solutions	5580002369	4681570776	\N	\N	10	2023-06-16	2023-06-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.06037	2025-11-13 15:45:11.06037	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
296	GABRIELA	ROSAS CASTILLO	gabriela.rosas@afirma.solutions	5580002369	4181026314	\N	\N	10	2023-07-06	2023-07-06	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.063751	2025-11-13 15:45:11.063751	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
396	ALFREDO	AGUILAR PUGA	alfredo.aguilar@afirma.solutions	\N	5561322528	\N	\N	\N	2025-10-28	2025-10-28	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.453053	2025-11-13 15:45:11.453053	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
301	MARCOS	ENRIQUE TELLEZ HERRERA	marcos.tellez@afirma.solutions	5580002369	2871460779	\N	\N	\N	2023-08-01	2023-08-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.080581	2025-11-13 15:45:11.080581	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
786	Carlos	Rodríguez Méndez	carlos.rodriguez@afirma.test	5552345678	5558765432	TEST002	\N	6	2025-11-13	\N	1990-07-22	\N	\N	\N	\N	México	Permanente	\N	Activo	2025-11-13 22:49:54.329779	2025-11-20 10:27:03.177117	\N	system	54	76	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
337	RAMON	ANTONIO ZURITA ALCUDIA	ramon.zurita@afirma.solutions	5580002369	5543863591	\N	\N	\N	2024-07-01	2024-07-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.193368	2025-11-13 15:45:11.193368	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
340	CARLOS	ARMANDO CALDERON ESPINOSA	carlos.calderon@afirma.solutions	5580002369	56 3664 5523	\N	\N	\N	2024-07-22	2024-07-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.201461	2025-11-13 15:45:11.201461	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
300	DANIEL	MARTINEZ HERNANDEZ	daniel.martinez@afirma.solutions	5580002369	55 7011 9910	\N	\N	\N	2023-07-24	2023-07-24	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.07699	2025-11-13 15:45:11.07699	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
315	FERNANDO	MANUEL PEREZ DIAZ	fernando.perez@afirma.solutions	5580002369	5561133861	\N	\N	\N	2024-01-08	2024-01-08	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.128198	2025-11-13 15:45:11.128198	import_direct	\N	\N	7	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
319	ERICK	BRUNO GARCIA	erick.bruno@afirma.solutions	5580002369	2351150572	\N	\N	\N	2024-01-15	2025-09-03	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.141456	2025-11-13 15:45:11.141456	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
320	ERICK	MISAEL ROMERO GARCIA	erick.romero@afirma.solutions	5580002369	5554662472	\N	\N	\N	2024-01-22	2024-05-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.144262	2025-11-13 15:45:11.144262	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
328	BRIAN	CAMPOS ISLAS	brian.campos@afirma.solutions	5580002369	5566804637	\N	\N	\N	2024-05-07	2024-05-07	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.167631	2025-11-13 15:45:11.167631	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
329	JORGE	ARTURO CASTORENA HIRASHI	jorge.castorena@afirma.solutions	5580002369	5621809711	\N	\N	\N	2024-05-07	2024-05-07	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.171239	2025-11-13 15:45:11.171239	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
350	EDUARDO	BERNABE ALONSO	eduardo.bernabe@afirma.solutions	\N	4434200002	\N	\N	\N	2025-02-04	2025-09-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.225965	2025-11-13 15:45:11.225965	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
366	ALEXANDRE	MARTINEZ PINO	alexandre.martinez@afirma.solutions	5580002369	7713973086	\N	\N	\N	2025-05-26	2025-05-26	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.267551	2025-11-13 15:45:11.267551	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
372	MARIA	VERONICA DEL SOCORRO GONZALEZ LANZAGORTA	maria.gonzalez@afirma.solutions	5580002369	5526537380	\N	\N	12	2025-06-24	2025-06-24	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.281736	2025-11-13 15:45:11.281736	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
378	DENISSE	AZUCENA CRUZ ALVARADO	denisse.cruz@afirma.solutions	5580002369	5518163650	\N	\N	\N	2025-08-26	2025-08-26	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.296844	2025-11-13 15:45:11.296844	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
787	Mar�a	Hern�ndez Silva	maria.hernandez@afirma.test	5553456789	5557654321	TEST003	\N	98	2025-11-13	\N	1988-11-08	Calle Nueva	Guadalajara	Jalisco	44100	México	Permanente	\N	Inactivo	2025-11-13 22:49:54.350654	2025-11-20 10:26:26.250939	\N	system	137	165	166	\N	\N	\N	\N	México	18	na	San Jose Campestre	\N	\N	\N	\N	\N	\N	\N	\N
362	GRISELDA	REYES BAUTISTA	griselda.reyes@afirma.solutions	5580002369	4463101622	\N	\N	\N	2025-04-23	2025-04-23	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.257857	2025-11-13 15:45:11.257857	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
293	JORGE	SAUL FERNANDEZ ENRIQUEZ	jorge.fernandez@afirma.solutions	5580002369	777 493 3918	\N	\N	\N	2023-05-31	2023-06-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.05174	2025-11-13 15:45:11.05174	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
303	JOSE	ANTONIO PADRE GARCIA	antonio.padre@afirma.solutions	5580002369	7721347703	\N	\N	\N	2023-08-03	2023-08-03	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.086038	2025-11-13 15:45:11.086038	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
311	GALGANI	MONTES CALLEJA	galgani.montes@afirma.solutions	5580002369	5514832171	\N	\N	10	2023-11-15	2023-11-15	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.11538	2025-11-13 15:45:11.11538	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
312	ESTEFANIA	VILLALBA HERNANDEZ	estefania.villalba@afirma-solutions.com	\N	4421416264	\N	\N	\N	2023-12-04	2023-12-04	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.117621	2025-11-13 15:45:11.117621	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
316	MIGUEL	HEDAI GALINDO NUÑEZ	miguel.galindo@afirma.solutions	5580002369	5638824284	\N	\N	\N	2024-01-09	2024-01-09	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.132476	2025-11-13 15:45:11.132476	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
321	FRANCISCO	JAVIER GUTIERREZ YAÑEZ	francisco.gutierrez@afirma.solutions	5580002369	5530695997	\N	\N	\N	2024-02-06	2024-02-06	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.148323	2025-11-13 15:45:11.148323	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
322	ROGELIO	MARTINEZ DIAZ	rogelio.martinez@afirma-solutions.com	5580002369	5544797974	\N	\N	\N	2024-02-19	2024-02-19	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.150482	2025-11-13 15:45:11.150482	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	Gary Manuel	Vazquez	gama469@gmail.com	4191138225	\N	\N	\N	8	2019-09-09	2019-09-09	1985-08-25	Cerro Silla18	San José Iturbide	Guanajuato	37980	mexico	Permanente	\N	Activo	2025-11-13 13:07:53.432447	2025-11-13 13:07:53.432447	web	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
326	JORGE	DANIEL CLEMENTE GONZALEZ	jorge.clementeg18@gmail.com	\N	5513707285	\N	\N	\N	2024-04-15	2024-04-15	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.163121	2025-11-13 15:45:11.163121	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	Juan	(Sin Apellido)	juan.garcia@afirma.com	+57-1-1234567	\N	\N	\N	\N	2025-11-13	\N	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:10:14.332328	2025-11-13 15:10:14.332328	import_direct	\N	2	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
377	LUCERO	RUBY GACHUZ VAZQUEZ	lucero.gachuz@afirma.solutions	5580002369	7721411433	\N	\N	12	2025-08-04	2025-08-04	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.293568	2025-11-13 15:45:11.293568	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
336	CARLOS	ANDRES BETANCOURT NAVARRETE	carlos.betancourt@afirma.solutions	5580002369	5540761609	\N	\N	\N	2024-07-01	2024-07-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.191389	2025-11-13 15:45:11.191389	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
338	OMAR	ALBERTO SANTOS NUÑEZ	omar.santos@afirma.solutions	5580002369	5539157934	\N	\N	\N	2024-07-01	2024-07-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.197008	2025-11-13 15:45:11.197008	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
343	EDUARDO	PASTOR NUÑEZ MARTINEZ-2	eduardo.martinez@afirma.solutions	5578663707	5540043455	\N	\N	10	2024-08-27	2024-08-27	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.210261	2025-11-13 15:45:11.210261	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
344	OSCAR	ULISES ACOSTA GUERRERO-2	ulises.acosta@afirma.solutions	5580002369	4428787989	\N	\N	10	2024-09-03	2024-09-03	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.213207	2025-11-13 15:45:11.213207	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
359	LUIS	ALBERTO GRIMALDO ROBLES	luis.grimaldo@afirma.solutions	5580002369	419 118 9660	\N	\N	\N	2025-04-14	2025-04-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.249962	2025-11-13 15:45:11.249962	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
373	EFREN	TORRES PEREZ	efren.torres@afirma.solutions	5580002369	4423566253	\N	\N	\N	2025-07-07	2025-07-07	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.283755	2025-11-13 15:45:11.283755	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
349	NIDIA	CAROLINA MEZA HERNANDEZ	nidia.meza@afirma.solutions	\N	4775973194	\N	\N	\N	2025-02-04	2025-03-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.224299	2025-11-13 15:45:11.224299	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
353	ERIC	HIGAREDA COLIN	eric.higareda@afirma.solutions	5580002369	7221789718	\N	\N	\N	2025-02-28	2025-02-28	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.233619	2025-11-13 15:45:11.233619	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
355	HECTOR	SANCHEZ HERNANDEZ 2	hector.sanchez@afirma.solutions	2462170674	2462170674	\N	\N	\N	2025-03-17	2025-03-17	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.23927	2025-11-13 15:45:11.23927	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
356	JUAN	CARLOS SALGADO MARTINEZ	juan.salgado@afirma.solutions	5580002369	5548177809	\N	\N	\N	2025-03-17	2025-03-17	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.242338	2025-11-13 15:45:11.242338	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
365	FREDI	DANIEL CIFUENTES ROBLEDO	fredi.cifuentes@afirma.solutions	5580002369	9621161646	\N	\N	\N	2025-05-22	2025-05-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.265544	2025-11-13 15:45:11.265544	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
383	ELIEZER	SANTIAGO FUENTES 2	eliezer.santiago@afirma.solutions	5580002369	7971060312	\N	\N	\N	2025-09-10	2025-09-10	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.311812	2025-11-13 15:45:11.311812	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
308	CARLOS	URIEL PAEZ BERNABE	carlos.paez@afirma-solutions.com	5580002369	7224190567	\N	\N	\N	2023-10-23	2023-10-23	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.102458	2025-11-13 15:45:11.102458	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
325	MARIO	CARLOS VALDEZ MUÑOZ	mario.valdez@afirma.solutions	5580002369	5545254535	\N	\N	\N	2024-04-01	2024-04-01	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.159611	2025-11-13 15:45:11.159611	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
380	CESAR	IVAN ROJAS SALAZAR	cesar.rojas@afirma.solutions	5580002369	5512496044	\N	\N	12	2025-09-03	2025-09-03	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.301428	2025-11-13 15:45:11.301428	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
389	BRUNO	AXEL REYES MENDEZ	bruno.reyes@afirma.solutions	5580002369	5540687670	\N	\N	10	2025-10-13	2025-10-13	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.425764	2025-11-13 15:45:11.425764	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
304	ISAAC	YAEL MARTINEZ HERNANDEZ	yael.martinez@afirma.solutions	5580002369	7713657501	\N	\N	\N	2023-08-09	2023-08-09	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.090037	2025-11-13 15:45:11.090037	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
381	JERONIMO	GUILLERMO ROJAS PINEDA	sergio.fernandez@afirma.solutions	5580002369	+52 1 442 122 9591	\N	\N	\N	2025-09-08	2025-09-08	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.305065	2025-11-13 15:45:11.305065	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
382	MONICA	FANDILA RODRIGUEZ PEREZ	monica.rodriguez@afirma-solutions.com	5580002369	5571953897	\N	\N	\N	2025-09-08	2025-09-08	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.309101	2025-11-13 15:45:11.309101	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
393	DIANA	ANGELICA RAMIREZ HERNANDEZ 3	diana.ramirez@afirma.solutions	5580002369	4422674061	\N	\N	\N	2025-10-20	2025-10-20	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.440814	2025-11-13 15:45:11.440814	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
281	ILSE	NARVAEZ ABUNDIZ	ilse.narvaez@afirma-solutions.com	5549656894	5549656894	\N	\N	\N	2022-01-10	2022-01-10	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.013374	2025-11-13 15:45:11.013374	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
289	JOSUE	CRUZ SANTIAGO	josue.cruz@afirma.solutions	5580002369	4425543052	\N	\N	\N	2023-04-24	2024-10-07	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.040373	2025-11-13 15:45:11.040373	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
291	MARCOS	JOSUE CASTILLO RENDON	marcos.castillo@afirma.solutions	5580002369	720 754 4431	\N	\N	\N	2023-05-08	2025-07-15	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.045761	2025-11-13 15:45:11.045761	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
292	LUIS	DAVID CHAVEZ ACEVEDO	luis.chavez@afirma.solutions	5580002369	5564236602	\N	\N	\N	2023-05-15	2023-05-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.04897	2025-11-13 15:45:11.04897	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
274	HECTOR	MARTINEZ HERNANDEZ	hector.martinez@afirma-solutions.com	5580002369	55771523612	\N	\N	\N	2019-01-07	2019-01-04	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:10.989599	2025-11-13 15:45:10.989599	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
282	FERNANDO	GARRIDO PEREZ	fernando.garrido@afirma.solutions	2282225257	2282225257	\N	\N	\N	2022-07-04	2022-07-04	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.016282	2025-11-13 15:45:11.016282	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
283	LUIS	ALMARAZ HERNANDEZ	luis.almaraz@afirma.solutions	5527626245	5527626245	\N	\N	\N	2022-11-14	2022-11-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.020173	2025-11-13 15:45:11.020173	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
284	HUGO	ENRIQUE TOVAR ROMERO	hugo.tovar@afirma.solutions	7224243048	7224243048	\N	\N	\N	2023-01-30	2024-05-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.024277	2025-11-13 15:45:11.024277	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
309	OSWALDO	CRUZ NAJERA	oswaldo.cruz@afirma.solutions	\N	4461225365	\N	\N	\N	2023-10-24	2023-10-24	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.108435	2025-11-13 15:45:11.108435	import_direct	\N	\N	14	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
318	IVAN	RODRIGUEZ APOLINAR	ivan.rodriguez@afirma.solutions	5580002369	5539553788	\N	\N	\N	2024-01-15	2024-01-15	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.138398	2025-11-13 15:45:11.138398	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
334	BRIAN	ALEXIS MUÑOZ MONROY	brian.munoz@afirma.solutions	5580002369	4425548377	\N	\N	\N	2024-06-17	2024-11-02	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.185597	2025-11-13 15:45:11.185597	import_direct	\N	\N	7	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
275	SANDRA	IVONNE GONZALEZ MEJIA	ivonne.gonzalez@afirma-solutions.com	5580002369	5527157754	\N	\N	\N	2019-04-22	2019-04-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:10.993623	2025-11-13 15:45:10.993623	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
279	SAUL	CASTILLO HERNANDEZ	saul.castillo@afirma-solutions.com	5529183017	5526413349	\N	\N	\N	2021-03-22	2021-03-22	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.007845	2025-11-13 15:45:11.007845	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
280	ALBERTO	VILLAMAR JACOME	alberto.villamar@afirma-solutions.com	5626674118	5627537014	\N	\N	\N	2021-12-28	2023-12-28	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.010066	2025-11-13 15:45:11.010066	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
297	RODRIGO	MENDOZA MARQUEZ	rodrigo.mendoza@afirma.solutions	5580002369	777 330 8523	\N	\N	\N	2023-07-10	2023-07-10	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.06627	2025-11-13 15:45:11.06627	import_direct	\N	\N	20	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
305	ALEJANDRO	PEREZ PEREZ	alejandro.perez@afirma.solutions	5580002369	4181400096	\N	\N	\N	2023-08-28	2023-08-28	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.092851	2025-11-13 15:45:11.092851	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
307	VICTOR	FAJARDO URIZAR	victor.fajardo@afirma.solutions	5580002369	5511731858	\N	\N	\N	2023-10-16	2023-10-16	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.099752	2025-11-13 15:45:11.099752	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
324	SALVADOR	GONZALEZ GONZALEZ	salvador.gonzalez@afirma.solutions	5580002369	4421865010	\N	\N	\N	2024-03-04	2024-03-04	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.157428	2025-11-13 15:45:11.157428	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
375	JUAN	CARLOS ROBLEDO ORTIZ	juan.robledo@afirma.solutions	5580002369	5563972631	\N	\N	\N	2025-07-14	2025-07-14	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.28951	2025-11-13 15:45:11.28951	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
285	OSCAR	MARTINEZ ACOSTA	oscar.martinez@afirma.solutions	4432367898	442 1913514	\N	\N	10	2023-02-07	2023-02-07	\N	\N	\N	\N	\N	Colombia	Permanente	\N	Activo	2025-11-13 15:45:11.027175	2025-11-13 15:45:11.027175	import_direct	\N	\N	\N	\N	\N	\N	\N	\N	México	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5197 (class 0 OID 24614)
-- Dependencies: 221
-- Data for Name: entities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entities (id, name, description, manager_id, created_at, updated_at) FROM stdin;
9	AFIRMA MEX	\N	\N	2025-11-13 15:15:15.047234	2025-11-13 15:15:15.047234
10	ATVANTTI	\N	\N	2025-11-13 15:15:16.116776	2025-11-13 15:15:16.116776
11	TECNIVA	\N	\N	2025-11-13 15:15:16.504081	2025-11-13 15:15:16.504081
12	SOFTNERGYSOLUTIONS	\N	\N	2025-11-13 15:15:23.682765	2025-11-13 15:15:23.682765
13	LEITMOTIV	\N	\N	2025-11-13 15:15:25.829243	2025-11-13 15:15:25.829243
8	AFIRMA ESP	\N	\N	2025-11-13 12:59:11.901247	2025-11-13 12:59:11.901247
27	SOFTNERGYS	\N	\N	2025-11-20 23:03:44.243762	2025-11-20 23:03:44.243762
\.


--
-- TOC entry 5227 (class 0 OID 41096)
-- Dependencies: 251
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment (id, codigo, nombre, marca, modelo, serie, categoria, ubicacion, asignado_id, estado, valor, fecha_compra, observaciones, created_at, updated_at) FROM stdin;
11	EQ001	Equipo EQ001	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.756071	2025-11-19 19:33:15.756071
12	EQ002	Equipo EQ002	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.761728	2025-11-19 19:33:15.761728
13	EQ003	Equipo EQ003	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.763644	2025-11-19 19:33:15.763644
14	EQ004	Equipo EQ004	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.765873	2025-11-19 19:33:15.765873
15	EQ005	Equipo EQ005	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.76806	2025-11-19 19:33:15.76806
16	EQ006	Equipo EQ006	ACER	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.770099	2025-11-19 19:33:15.770099
17	EQ007	Equipo EQ007	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.77198	2025-11-19 19:33:15.77198
18	EQ008	Equipo EQ008	ACER	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.774892	2025-11-19 19:33:15.774892
19	EQ009	Equipo EQ009	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.778234	2025-11-19 19:33:15.778234
20	EQ010	Equipo EQ010	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.779908	2025-11-19 19:33:15.779908
21	EQ011	Equipo EQ011	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.782088	2025-11-19 19:33:15.782088
22	EQ012	Equipo EQ012	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.784243	2025-11-19 19:33:15.784243
23	EQ013	Equipo EQ013	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.785487	2025-11-19 19:33:15.785487
24	EQ014	Equipo EQ014	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.786548	2025-11-19 19:33:15.786548
25	EQ015	Equipo EQ015	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.78787	2025-11-19 19:33:15.78787
26	EQ016	Equipo EQ016	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.790312	2025-11-19 19:33:15.790312
27	EQ017	Equipo EQ017	ACER PA-1450-26	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.792965	2025-11-19 19:33:15.792965
28	EQ018	Equipo EQ018	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.795549	2025-11-19 19:33:15.795549
29	EQ019	Equipo EQ019	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.797771	2025-11-19 19:33:15.797771
30	EQ020	Equipo EQ020	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.80091	2025-11-19 19:33:15.80091
31	EQ021	Equipo EQ021	ACER	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.802782	2025-11-19 19:33:15.802782
32	EQ022	Equipo EQ022	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.804729	2025-11-19 19:33:15.804729
33	EQ023	Equipo EQ023	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.807997	2025-11-19 19:33:15.807997
34	EQ024	Equipo EQ024	ACER	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.810202	2025-11-19 19:33:15.810202
35	EQ025	Equipo EQ025	ACER	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.812302	2025-11-19 19:33:15.812302
36	EQ026	Equipo EQ026	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.814245	2025-11-19 19:33:15.814245
37	EQ027	Equipo EQ027	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.817025	2025-11-19 19:33:15.817025
38	EQ028	Equipo EQ028	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.818667	2025-11-19 19:33:15.818667
39	EQ029	Equipo EQ029	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.819971	2025-11-19 19:33:15.819971
40	EQ030	Equipo EQ030	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.821185	2025-11-19 19:33:15.821185
41	EQ031	Equipo EQ031	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.823061	2025-11-19 19:33:15.823061
42	EQ032	Equipo EQ032	LENOVO ThinkPad	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.825675	2025-11-19 19:33:15.825675
43	EQ033	Equipo EQ033	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.827705	2025-11-19 19:33:15.827705
44	EQ034	Equipo EQ034	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.829109	2025-11-19 19:33:15.829109
45	EQ035	Equipo EQ035	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.830254	2025-11-19 19:33:15.830254
46	EQ036	Equipo EQ036	LENOVO ThinkPad L15 Gen1	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.83199	2025-11-19 19:33:15.83199
47	EQ037	Equipo EQ037	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.833323	2025-11-19 19:33:15.833323
48	EQ038	Equipo EQ038	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.834897	2025-11-19 19:33:15.834897
49	EQ039	Equipo EQ039	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.836539	2025-11-19 19:33:15.836539
50	EQ040	Equipo EQ040	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.837879	2025-11-19 19:33:15.837879
51	EQ041	Equipo EQ041	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.839365	2025-11-19 19:33:15.839365
52	EQ042	Equipo EQ042	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.842439	2025-11-19 19:33:15.842439
53	EQ043	Equipo EQ043	ACER	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.844528	2025-11-19 19:33:15.844528
54	EQ044	Equipo EQ044	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.84639	2025-11-19 19:33:15.84639
55	EQ045	Equipo EQ045	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.848649	2025-11-19 19:33:15.848649
56	EQ046	Equipo EQ046	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.850858	2025-11-19 19:33:15.850858
57	EQ047	Equipo EQ047	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.852454	2025-11-19 19:33:15.852454
58	EQ048	Equipo EQ048	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.853862	2025-11-19 19:33:15.853862
59	EQ049	Equipo EQ049	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.855165	2025-11-19 19:33:15.855165
60	EQ050	Equipo EQ050	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.856841	2025-11-19 19:33:15.856841
61	EQ051	Equipo EQ051	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.859313	2025-11-19 19:33:15.859313
62	EQ052	Equipo EQ052	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.861405	2025-11-19 19:33:15.861405
63	EQ053	Equipo EQ053	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.863131	2025-11-19 19:33:15.863131
64	EQ054	Equipo EQ054	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.864947	2025-11-19 19:33:15.864947
65	EQ055	Equipo EQ055	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.867684	2025-11-19 19:33:15.867684
66	EQ056	Equipo EQ056	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.869083	2025-11-19 19:33:15.869083
67	EQ057	Equipo EQ057	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.870324	2025-11-19 19:33:15.870324
68	EQ058	Equipo EQ058	DELL YR2018	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.871925	2025-11-19 19:33:15.871925
69	EQ059	Equipo EQ059	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.874183	2025-11-19 19:33:15.874183
70	EQ060	Equipo EQ060	MOTOROLA	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.875618	2025-11-19 19:33:15.875618
71	EQ061	Equipo EQ061	SAMSUNG	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.877341	2025-11-19 19:33:15.877341
72	EQ062	Equipo EQ062	NOKIA	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.87862	2025-11-19 19:33:15.87862
73	EQ063	Equipo EQ063	LANIX	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.880094	2025-11-19 19:33:15.880094
74	EQ064	Equipo EQ064	LANIX	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.884803	2025-11-19 19:33:15.884803
75	EQ065	Equipo EQ065	NOKIA	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.886	2025-11-19 19:33:15.886
76	EQ066	Equipo EQ066	SAMSUNG	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.887763	2025-11-19 19:33:15.887763
77	EQ067	Equipo EQ067	IONOS	\N	\N	SERVICIO IT	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.889167	2025-11-19 19:33:15.889167
78	EQ068	Equipo EQ068	IONOS	\N	\N	SERVICIO IT	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.891317	2025-11-19 19:33:15.891317
79	EQ069	Equipo EQ069	Odoo	\N	\N	APLICACION	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.892946	2025-11-19 19:33:15.892946
80	EQ070	Equipo EQ070	Contpaq	\N	\N	APLICACION	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.894547	2025-11-19 19:33:15.894547
81	EQ071	Equipo EQ071	Microsoft	\N	\N	SERVICIO IT	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.896079	2025-11-19 19:33:15.896079
82	EQ072	Equipo EQ072	HUB	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.897616	2025-11-19 19:33:15.897616
83	EQ073	Equipo EQ073	HUB	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.899947	2025-11-19 19:33:15.899947
84	EQ074	Equipo EQ074	HUB	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.90126	2025-11-19 19:33:15.90126
85	EQ075	Equipo EQ075	LOGITECH	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.902251	2025-11-19 19:33:15.902251
86	EQ076	Equipo EQ076	LOGITECH	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.903417	2025-11-19 19:33:15.903417
87	EQ077	Equipo EQ077	STUK	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.904683	2025-11-19 19:33:15.904683
88	EQ078	Equipo EQ078	Expedientes	\N	\N	DATOS	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.906435	2025-11-19 19:33:15.906435
89	EQ079	Equipo EQ079	Expedientes	\N	\N	DATOS	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.908921	2025-11-19 19:33:15.908921
90	EQ080	Equipo EQ080	Contabilidad	\N	\N	DATOS	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.910339	2025-11-19 19:33:15.910339
91	EQ081	Equipo EQ081	Contabilidad	\N	\N	DATOS	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.911383	2025-11-19 19:33:15.911383
92	EQ082	Equipo EQ082	WD	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.91237	2025-11-19 19:33:15.91237
93	EQ083	Equipo EQ083	TP-LINK	\N	\N	RED	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.913242	2025-11-19 19:33:15.913242
94	EQ084	Equipo EQ084	CISCO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.91492	2025-11-19 19:33:15.91492
95	EQ085	Equipo EQ085	SAMSUNG	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.917084	2025-11-19 19:33:15.917084
96	EQ086	Equipo EQ086	Guardian Gs5	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.918411	2025-11-19 19:33:15.918411
97	EQ087	Equipo EQ087	DODAUG	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.919546	2025-11-19 19:33:15.919546
98	EQ088	Equipo EQ088	NOKIA	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.920892	2025-11-19 19:33:15.920892
99	EQ089	Equipo EQ089	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.922098	2025-11-19 19:33:15.922098
100	EQ090	Equipo EQ090	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.924629	2025-11-19 19:33:15.924629
101	EQ091	Equipo EQ091	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.926613	2025-11-19 19:33:15.926613
102	EQ092	Equipo EQ092	Nokia	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.928119	2025-11-19 19:33:15.928119
103	EQ093	Equipo EQ093	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.929431	2025-11-19 19:33:15.929431
104	EQ094	Equipo EQ094	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.930551	2025-11-19 19:33:15.930551
105	EQ095	Equipo EQ095	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.93249	2025-11-19 19:33:15.93249
106	EQ096	Equipo EQ096	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.934638	2025-11-19 19:33:15.934638
107	EQ097	Equipo EQ097	LANIX	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.935864	2025-11-19 19:33:15.935864
108	EQ098	Equipo EQ098	NOKIA	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.936704	2025-11-19 19:33:15.936704
109	EQ099	Equipo EQ099	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.937452	2025-11-19 19:33:15.937452
110	EQ100	Equipo EQ100	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.938193	2025-11-19 19:33:15.938193
111	EQ101	Equipo EQ101	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.939353	2025-11-19 19:33:15.939353
112	EQ102	Equipo EQ102	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.942106	2025-11-19 19:33:15.942106
113	EQ103	Equipo EQ103	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.943888	2025-11-19 19:33:15.943888
114	EQ104	Equipo EQ104	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.944947	2025-11-19 19:33:15.944947
115	EQ105	Equipo EQ105	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.946166	2025-11-19 19:33:15.946166
116	EQ106	Equipo EQ106	BENQ	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.947242	2025-11-19 19:33:15.947242
117	EQ107	Equipo EQ107	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.949732	2025-11-19 19:33:15.949732
118	EQ108	Equipo EQ108	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.95133	2025-11-19 19:33:15.95133
119	EQ109	Equipo EQ109	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.952905	2025-11-19 19:33:15.952905
120	EQ110	Equipo EQ110	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.954113	2025-11-19 19:33:15.954113
121	EQ111	Equipo EQ111	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.95538	2025-11-19 19:33:15.95538
122	EQ112	Equipo EQ112	Windows	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.958022	2025-11-19 19:33:15.958022
123	EQ113	Equipo EQ113	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.960009	2025-11-19 19:33:15.960009
124	EQ114	Equipo EQ114	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.961755	2025-11-19 19:33:15.961755
125	EQ115	Equipo EQ115	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.96335	2025-11-19 19:33:15.96335
126	EQ116	Equipo EQ116	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.966243	2025-11-19 19:33:15.966243
127	EQ117	Equipo EQ117	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.967942	2025-11-19 19:33:15.967942
128	EQ118	Equipo EQ118	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.969531	2025-11-19 19:33:15.969531
129	EQ119	Equipo EQ119	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.97088	2025-11-19 19:33:15.97088
130	EQ120	Equipo EQ120	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.972085	2025-11-19 19:33:15.972085
131	EQ121	Equipo EQ121	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.974606	2025-11-19 19:33:15.974606
132	EQ122	Equipo EQ122	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.976504	2025-11-19 19:33:15.976504
133	EQ123	Equipo EQ123	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.978246	2025-11-19 19:33:15.978246
134	EQ124	Equipo EQ124	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.979539	2025-11-19 19:33:15.979539
135	EQ125	Equipo EQ125	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.981043	2025-11-19 19:33:15.981043
136	EQ126	Equipo EQ126	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.983468	2025-11-19 19:33:15.983468
137	EQ127	Equipo EQ127	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.985198	2025-11-19 19:33:15.985198
138	EQ128	Equipo EQ128	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.986966	2025-11-19 19:33:15.986966
139	EQ129	Equipo EQ129	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.988336	2025-11-19 19:33:15.988336
140	EQ130	Equipo EQ130	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.990867	2025-11-19 19:33:15.990867
141	EQ131	Equipo EQ131	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.99334	2025-11-19 19:33:15.99334
142	EQ132	Equipo EQ132	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.994751	2025-11-19 19:33:15.994751
143	EQ133	Equipo EQ133	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.995855	2025-11-19 19:33:15.995855
144	EQ134	Equipo EQ134	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.997004	2025-11-19 19:33:15.997004
145	EQ135	Equipo EQ135	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:15.999481	2025-11-19 19:33:15.999481
146	EQ136	Equipo EQ136	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.001441	2025-11-19 19:33:16.001441
147	EQ137	Equipo EQ137	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.002629	2025-11-19 19:33:16.002629
148	EQ138	Equipo EQ138	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.00408	2025-11-19 19:33:16.00408
149	EQ139	Equipo EQ139	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.005577	2025-11-19 19:33:16.005577
150	EQ140	Equipo EQ140	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.008321	2025-11-19 19:33:16.008321
151	EQ141	Equipo EQ141	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.010517	2025-11-19 19:33:16.010517
152	EQ142	Equipo EQ142	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.011902	2025-11-19 19:33:16.011902
153	EQ143	Equipo EQ143	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.013084	2025-11-19 19:33:16.013084
154	EQ144	Equipo EQ144	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.014471	2025-11-19 19:33:16.014471
155	EQ145	Equipo EQ145	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.016966	2025-11-19 19:33:16.016966
156	EQ146	Equipo EQ146	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.018839	2025-11-19 19:33:16.018839
157	EQ147	Equipo EQ147	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.021063	2025-11-19 19:33:16.021063
158	EQ148	Equipo EQ148	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.022292	2025-11-19 19:33:16.022292
159	EQ149	Equipo EQ149	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.024762	2025-11-19 19:33:16.024762
160	EQ150	Equipo EQ150	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.026492	2025-11-19 19:33:16.026492
161	EQ151	Equipo EQ151	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.028113	2025-11-19 19:33:16.028113
162	EQ152	Equipo EQ152	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.029418	2025-11-19 19:33:16.029418
163	EQ153	Equipo EQ153	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.030854	2025-11-19 19:33:16.030854
164	EQ154	Equipo EQ154	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.033037	2025-11-19 19:33:16.033037
165	EQ155	Equipo EQ155	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.034593	2025-11-19 19:33:16.034593
166	EQ156	Equipo EQ156	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.036071	2025-11-19 19:33:16.036071
167	EQ157	Equipo EQ157	LENOVO	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.037202	2025-11-19 19:33:16.037202
168	EQ158	Equipo EQ158	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.038239	2025-11-19 19:33:16.038239
169	EQ159	Equipo EQ159	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.039917	2025-11-19 19:33:16.039917
170	EQ160	Equipo EQ160	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.042261	2025-11-19 19:33:16.042261
171	EQ161	Equipo EQ161	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.0439	2025-11-19 19:33:16.0439
172	EQ162	Equipo EQ162	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.045166	2025-11-19 19:33:16.045166
173	EQ163	Equipo EQ163	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.046427	2025-11-19 19:33:16.046427
174	EQ164	Equipo EQ164	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.049057	2025-11-19 19:33:16.049057
175	EQ165	Equipo EQ165	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.050832	2025-11-19 19:33:16.050832
176	EQ166	Equipo EQ166	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.05243	2025-11-19 19:33:16.05243
177	EQ167	Equipo EQ167	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.05377	2025-11-19 19:33:16.05377
178	EQ168	Equipo EQ168	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.054768	2025-11-19 19:33:16.054768
179	EQ169	Equipo EQ169	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.056123	2025-11-19 19:33:16.056123
180	EQ170	Equipo EQ170	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.058229	2025-11-19 19:33:16.058229
181	EQ171	Equipo EQ171	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.06027	2025-11-19 19:33:16.06027
182	EQ172	Equipo EQ172	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.06167	2025-11-19 19:33:16.06167
183	EQ173	Equipo EQ173	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.063098	2025-11-19 19:33:16.063098
184	EQ174	Equipo EQ174	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.06419	2025-11-19 19:33:16.06419
185	EQ175	Equipo EQ175	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.066479	2025-11-19 19:33:16.066479
186	EQ176	Equipo EQ176	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.068128	2025-11-19 19:33:16.068128
187	EQ177	Equipo EQ177	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.069853	2025-11-19 19:33:16.069853
188	EQ178	Equipo EQ178	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.071166	2025-11-19 19:33:16.071166
189	EQ179	Equipo EQ179	HP	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.073318	2025-11-19 19:33:16.073318
190	EQ180	Equipo EQ180	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.076036	2025-11-19 19:33:16.076036
191	EQ181	Equipo EQ181	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.077448	2025-11-19 19:33:16.077448
192	EQ182	Equipo EQ182	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.078746	2025-11-19 19:33:16.078746
193	EQ183	Equipo EQ183	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.080028	2025-11-19 19:33:16.080028
194	EQ184	Equipo EQ184	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.08197	2025-11-19 19:33:16.08197
195	EQ185	Equipo EQ185	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.084378	2025-11-19 19:33:16.084378
196	EQ186	Equipo EQ186	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.086054	2025-11-19 19:33:16.086054
197	EQ187	Equipo EQ187	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.087661	2025-11-19 19:33:16.087661
198	EQ188	Equipo EQ188	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.089036	2025-11-19 19:33:16.089036
199	EQ189	Equipo EQ189	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.091742	2025-11-19 19:33:16.091742
200	EQ190	Equipo EQ190	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.094013	2025-11-19 19:33:16.094013
201	EQ191	Equipo EQ191	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.095375	2025-11-19 19:33:16.095375
202	EQ192	Equipo EQ192	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.096469	2025-11-19 19:33:16.096469
203	EQ193	Equipo EQ193	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.09773	2025-11-19 19:33:16.09773
204	EQ194	Equipo EQ194	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.10035	2025-11-19 19:33:16.10035
205	EQ195	Equipo EQ195	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.101918	2025-11-19 19:33:16.101918
206	EQ196	Equipo EQ196	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.103206	2025-11-19 19:33:16.103206
207	EQ197	Equipo EQ197	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.104427	2025-11-19 19:33:16.104427
208	EQ198	Equipo EQ198	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.105986	2025-11-19 19:33:16.105986
209	EQ199	Equipo EQ199	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.108563	2025-11-19 19:33:16.108563
210	EQ200	Equipo EQ200	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.110671	2025-11-19 19:33:16.110671
211	EQ201	Equipo EQ201	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.111972	2025-11-19 19:33:16.111972
212	EQ202	Equipo EQ202	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.11294	2025-11-19 19:33:16.11294
213	EQ203	Equipo EQ203	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.113838	2025-11-19 19:33:16.113838
214	EQ204	Equipo EQ204	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.1162	2025-11-19 19:33:16.1162
215	EQ205	Equipo EQ205	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.118046	2025-11-19 19:33:16.118046
216	EQ206	Equipo EQ206	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.119799	2025-11-19 19:33:16.119799
217	EQ207	Equipo EQ207	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.121049	2025-11-19 19:33:16.121049
218	EQ208	Equipo EQ208	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.122169	2025-11-19 19:33:16.122169
219	EQ209	Equipo EQ209	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.124848	2025-11-19 19:33:16.124848
220	EQ210	Equipo EQ210	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.126689	2025-11-19 19:33:16.126689
221	EQ211	Equipo EQ211	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.128143	2025-11-19 19:33:16.128143
222	EQ212	Equipo EQ212	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.129364	2025-11-19 19:33:16.129364
223	EQ213	Equipo EQ213	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.130514	2025-11-19 19:33:16.130514
224	EQ214	Equipo EQ214	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.132486	2025-11-19 19:33:16.132486
225	EQ215	Equipo EQ215	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.134242	2025-11-19 19:33:16.134242
226	EQ216	Equipo EQ216	MAC	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.135382	2025-11-19 19:33:16.135382
227	EQ217	Equipo EQ217	DELL	\N	\N	FISICO	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.136476	2025-11-19 19:33:16.136476
230	AF002	ThinkPad L15 Gen 1	LENOVO	ThinkPad L15 Gen 1	PF-2KV899	LAPTOP	\N	386	Mantenimiento	\N	\N	Comentarios: EQUIPO AUN SE ENCUENTRA EN BANCO YA QUE NO PUEDEN QUIOTAR LA PASSWORD DEL BIOS  | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro	2025-11-19 19:34:19.76246	2025-11-19 19:34:19.76246
231	AF003	ThinkPad L15 Gen 1	LENOVO	ThinkPad L15 Gen 1	PF-2KTQR7	LAPTOP	\N	369	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-71PIJQI	2025-11-19 19:34:19.768097	2025-11-19 19:34:19.768097
332	AF104	V14 G2 ITL	LENOVO	V14 G2 ITL	PF45LSTE	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: DESKTOP-3UOIPP2	2025-11-19 19:34:20.200879	2025-11-19 19:34:20.200879
232	AF004	MacBook Pro16 2019	MAC	MacBook Pro16 2019	C02C8GL2MD6M	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: PARA ASIGNAR A  Denis Gustavo Garcia Mendez | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.774202	2025-11-19 19:34:19.774202
233	AF005	LATITUDE 5500	DELL	LATITUDE 5500	68LX0Z2	LAPTOP	\N	276	Activo	\N	\N	RAM: 16 GB | Disco: 1 TB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-GARYVAZQUEZ	2025-11-19 19:34:19.778913	2025-11-19 19:34:19.778913
234	AF006	E5-475-57QS	ACER	E5-475-57QS	NXGJVAL00471215B207600	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: Se encuentra en España | RAM: 16  GB | Disco: 1 TB + 119 GB SSD | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-005V57I	2025-11-19 19:34:19.783286	2025-11-19 19:34:19.783286
235	AF007	INSPIRON 5566	DELL	INSPIRON 5566	4GB9VP2	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: PARA ASIGNAR A DANEL DOMINGUEZ | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-6UHBA3P	2025-11-19 19:34:19.787163	2025-11-19 19:34:19.787163
236	AF008	N17C4	ACER	N17C4	NXH38AL0129090114B3400	LAPTOP	\N	\N	Activo	\N	\N	RAM: 20 GB | Disco: 1 TB HDD | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-9FFGE44	2025-11-19 19:34:19.791382	2025-11-19 19:34:19.791382
237	AF009	ideapad 320	LENOVO	ideapad 320	PF0WMHTB	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: COMPUTADORA CON BLOQUEO BIOS | RAM: 16 GB | Disco: 1 TB | CPU: Intel Core i5 | SO: Windows 10 Home | Host: DESKTOP-QRQ2LS0	2025-11-19 19:34:19.796711	2025-11-19 19:34:19.796711
238	AF010	LATITUDE 5450	DELL	LATITUDE 5450	GR99J72/36476665454	LAPTOP	\N	\N	Mantenimiento	\N	\N	Comentarios: EQUIPO PRESENTA FALLA EN EL CHIP DE VIDEO  | RAM: 12 GB | Disco: 1 TB | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-UEFDVQ7	2025-11-19 19:34:19.80195	2025-11-19 19:34:19.80195
239	AF011	MacBook Pro 16-inch	MAC	MacBook Pro 16-inch	C02CLPRRMD6M	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: equipo vendido | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.8055	2025-11-19 19:34:19.8055
240	AF012	MacBook Pro 15-inch 2018	MAC	MacBook Pro 15-inch 2018	CO2XQCY4JG5J	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: Antonio de Jesús Gonzalez Gonzalez | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.81093	2025-11-19 19:34:19.81093
241	AF013	330S-15LKB	LENOVO	330S-15LKB	PF1PXJWM	LAPTOP	\N	16	Activo	\N	\N	RAM: 12 GB | Disco: 1 TB | CPU: Intel Core i5 | SO: Windows 10 HOME SINGLE | Host: \tDESKTOP-VVQQRAJ	2025-11-19 19:34:19.814881	2025-11-19 19:34:19.814881
242	AF014	15-cc501la	HP	15-cc501la	5CD7321FYK	LAPTOP	\N	300	Activo	\N	\N	Comentarios: COMPUTADORA CON BLOQUEO DEL BIOS | RAM: 12 GB | Disco: 1 TB + 128 GB SSD | CPU: Intel Core i5 | SO: Windows 10 Pro	2025-11-19 19:34:19.819735	2025-11-19 19:34:19.819735
243	AF015	15-cw0009la	HP	15-cw0009la	5CD84261FT	LAPTOP	\N	\N	Activo	\N	\N	RAM: 12 GB | Disco: 1 TB + 128 GB SSD | CPU: AMD Quad-Core Ryzen | SO: Ubuntu 17	2025-11-19 19:34:19.826151	2025-11-19 19:34:19.826151
244	AF016	ideapad 320	LENOVO	ideapad 320	PF0WAUS0	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 1 TB | CPU: Intel Core i5 | SO: Windows 10 Pro	2025-11-19 19:34:19.830362	2025-11-19 19:34:19.830362
245	AF017	E5-475-57QS	ACER PA-1450-26	E5-475-57QS	NXGJVAL00471215E2E7600	LAPTOP	\N	304	Activo	\N	\N	Comentarios: EQUIPO ROBADO  | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-KH8NJL8	2025-11-19 19:34:19.834957	2025-11-19 19:34:19.834957
246	AF018	LATITUDE E7450	DELL	LATITUDE E7450	BCYBL72	LAPTOP	\N	306	Activo	\N	\N	Comentarios: PARA USO INTERNO  | RAM: 12 GB | Disco: 512 GB | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-MC7H5A0	2025-11-19 19:34:19.838199	2025-11-19 19:34:19.838199
247	AF019	INSPIRON 5566	DELL	INSPIRON 5566	2HXPHM2	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: PARA ASIGNAR A GARY | RAM: 24 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-307TIFP	2025-11-19 19:34:19.843367	2025-11-19 19:34:19.843367
248	AF020	15-bs011la	HP	15-bs011la	CND7196CSQ	General	\N	\N	Activo	\N	\N	Comentarios: USO INTERNO | RAM: 12 GB | Disco: 1 TB | CPU: Intel Core i3 | SO: Windows 10 Pro | Host: DESKTOP-L50M2AA	2025-11-19 19:34:19.847005	2025-11-19 19:34:19.847005
249	AF021	E5-475	ACER	E5-475	NXGJVAL00471215D017600	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: FALLA EN LA TARJETA MADRE | RAM: 16 GB | Disco: 1 TB + 128 GB SSD | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-PAN0UDP	2025-11-19 19:34:19.852123	2025-11-19 19:34:19.852123
250	AF022	INSPIRON 5566	DELL	INSPIRON 5566	C1PJMQ2	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 438.63 GB + 477 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-J2O490J	2025-11-19 19:34:19.855175	2025-11-19 19:34:19.855175
251	AF023	INSPIRON 15 5566	DELL	INSPIRON 15 5566	JNQ10N2	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-MGPLEGK	2025-11-19 19:34:19.859879	2025-11-19 19:34:19.859879
252	AF024	ASPIRE A315-51	ACER	ASPIRE A315-51	NXGNPAL030804217B57600	LAPTOP	\N	\N	Activo	\N	\N	RAM: 12 GB | Disco: 1 TB | CPU: Intel Core i3 | SO: Windows 10 Pro | Host: DESKTOP-H8T2GF4	2025-11-19 19:34:19.864593	2025-11-19 19:34:19.864593
253	AF025	Travel Mate N19Q7	ACER	Travel Mate N19Q7	NXVLFAL0080304832C7600	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-E33F88A	2025-11-19 19:34:19.869555	2025-11-19 19:34:19.869555
254	AF026	INSPIRON 3552	DELL	INSPIRON 3552	84269L2	LAPTOP	\N	\N	Activo	\N	\N	RAM: 8 GB | Disco: 1 TB | CPU: IntelPentium N3710 | SO: Windows 10 Pro	2025-11-19 19:34:19.872511	2025-11-19 19:34:19.872511
255	AF027	330S-15LKB	LENOVO	330S-15LKB	PF1MVRBE	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: EQUIPO CON FALLA DE TECLADO | RAM: 12 GB | Disco: 1 TB HDD | CPU: Intel Core i5 | SO: Windws 11 Home | Host: \tDESKTOP-QMB6QDR	2025-11-19 19:34:19.877398	2025-11-19 19:34:19.877398
256	AF028	LATITUDE E7450	DELL	LATITUDE E7450	C5R0S72	LAPTOP	\N	\N	Activo	\N	\N	RAM: 8 GB | Disco: 256 GB | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-7H7BBSG	2025-11-19 19:34:19.879847	2025-11-19 19:34:19.879847
257	AF029	MacBook Pro 15-inch	MAC	MacBook Pro 15-inch	C02XQAGSJG5J	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: PARA ASIGNARA A MARTIN TAPIA | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: macOs Sonoma 14 | Host: MacBook-Pro-de-Afirma	2025-11-19 19:34:19.884097	2025-11-19 19:34:19.884097
258	AF030	15-bs011la	HP	15-bs011la	CND7183TKX	LAPTOP	\N	\N	Activo	\N	\N	RAM: 12 GB | Disco: 256 GB SSD | CPU: AMD A9-9420 RADEON R5 5 COMPUTE CORES 2C+3G      3.00 GHz | SO: Windows 10 Pro | Host: DESKTOP-EF2T66J	2025-11-19 19:34:19.887954	2025-11-19 19:34:19.887954
259	AF031	INSPIRON 15 5566	DELL	INSPIRON 15 5566	28PZRQ2	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-MLE98YU	2025-11-19 19:34:19.892533	2025-11-19 19:34:19.892533
260	AF032	L15 Gen 1	LENOVO ThinkPad	L15 Gen 1	PF-2KWTBC	LAPTOP	\N	281	Activo	\N	\N	Comentarios: PARA ASIGNAR A ILSE | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-UBFTVGR	2025-11-19 19:34:19.895945	2025-11-19 19:34:19.895945
261	AF033	IDEAPAD S145-15IIL	LENOVO	IDEAPAD S145-15IIL	PF2DCNGJ	LAPTOP	\N	\N	Mantenimiento	\N	\N	Comentarios: FALLA EN CHIP DE VIDEO  | RAM: 12 GB | Disco:  300 GB + 128 GB SSD | CPU: Intel Core i3 | SO: Windows 10 Pro | Host: DESKTOP-98VO3FQ	2025-11-19 19:34:19.901668	2025-11-19 19:34:19.901668
262	AF034	Inspiron 3493	DELL	Inspiron 3493	DF0LS53	LAPTOP	\N	382	Activo	\N	\N	RAM: 8 GB | Disco: 256 GB SSD | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-TL8DP5L	2025-11-19 19:34:19.904683	2025-11-19 19:34:19.904683
263	AF035	INSPIRON 3583	DELL	INSPIRON 3583	FBP4622	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: SE LE DEJO AL USARIO  | RAM: 8 GB | Disco: 1 TB HDD | CPU: Intel Core i5 | SO: N/A	2025-11-19 19:34:19.908797	2025-11-19 19:34:19.908797
264	AF036	L15 Gen 1	LENOVO ThinkPad L15 Gen1	L15 Gen 1	PF-2KSZDN	LAPTOP	\N	309	Activo	\N	\N	Comentarios: para asignar a Osvaldo Cruz Gary tiene el equipo  | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-A04UUUG	2025-11-19 19:34:19.912686	2025-11-19 19:34:19.912686
265	AF037	T530	LENOVO	T530	PK-1HC7W	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: equipo dañado, para refacciones  | RAM: 16 GB | Disco: 320 GB HDD | CPU: Intel Core i5 | SO: Windows 10 Pro	2025-11-19 19:34:19.917433	2025-11-19 19:34:19.917433
266	AF038	IDEAPAD S340-14IWL	LENOVO	IDEAPAD S340-14IWL	MP1MN1FA	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: SE LE DEJO AL USUARIO | RAM: 8.00 GB | Disco: 117 GB  + 100 GB  + 831 GB | CPU: Intel Core i5-8265U | SO: Windows 10 Pro	2025-11-19 19:34:19.922424	2025-11-19 19:34:19.922424
267	AF039	ThinkBook 14-IML 20RV	LENOVO	ThinkBook 14-IML 20RV	LR0F1EY1	LAPTOP	\N	349	Activo	\N	\N	Comentarios: NIDIA MEZA | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-57DDVKG	2025-11-19 19:34:19.928303	2025-11-19 19:34:19.928303
268	AF040	ThinkBook 14-IML 20RV	LENOVO	ThinkBook 14-IML 20RV	LR0F1F0J	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-79CDBPE	2025-11-19 19:34:19.933516	2025-11-19 19:34:19.933516
269	AF041	LATITUDE E6430	DELL	LATITUDE E6430	3T28HV1	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: PRESENTA FALLA, NO ENCIENDE | RAM: 16 GB | Disco: 1 TB | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-N41BG6H	2025-11-19 19:34:19.937987	2025-11-19 19:34:19.937987
270	AF042	INSPIRON 15 5566	DELL	INSPIRON 15 5566	46PHRQ2	LAPTOP	\N	279	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: SMCDFCMZ300100P	2025-11-19 19:34:19.943303	2025-11-19 19:34:19.943303
271	AF043	TravelMate P214-52	ACER	TravelMate P214-52	NXVLFAL0080304830A7600	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: RAUL SANTOS | RAM: 16 GB | Disco: 512 GB SSD + 466 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: \tDESKTOP-TMGHN7G	2025-11-19 19:34:19.947021	2025-11-19 19:34:19.947021
272	AF044	MAC BOOK PRO 15	MAC	MAC BOOK PRO 15	C02FP3WYML7H	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: Equpo vendido | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i5 | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.952576	2025-11-19 19:34:19.952576
273	AF045	ThlnkPad E14 Gen2	LENOVO	ThlnkPad E14 Gen2	PF33JHFQ	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-QFMUAPI	2025-11-19 19:34:19.956558	2025-11-19 19:34:19.956558
274	AF046	E7450	DELL	E7450	9FB0S72	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: REPARACION DE DISPLAY  | RAM: 16 GB | Disco: 256 GB SSD | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-8HNFKR3	2025-11-19 19:34:19.961668	2025-11-19 19:34:19.961668
275	AF047	THINKPAD E14	LENOVO	THINKPAD E14	PF33GY93	LAPTOP	\N	780	Activo	\N	\N	Comentarios: JESUS OSVALDO ANAYA RUIZ | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-NSRC0BK	2025-11-19 19:34:19.964856	2025-11-19 19:34:19.964856
276	AF048	MACBOOK PRO 14 2021	MAC	MACBOOK PRO 14 2021	QMKGXWMG7D	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: RODRIGO MENDOZA MARQUEZ | RAM: 16  GB | Disco: 512 GB SSD | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.969145	2025-11-19 19:34:19.969145
277	AF049	MACBOOK PRO 14 A2442	MAC	MACBOOK PRO 14 A2442	QNK775F0Y3	LAPTOP	\N	279	Activo	\N	\N	RAM: 16  GB | Disco: 512 GB SSD | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host: MACBOOK PRO AFIRMA	2025-11-19 19:34:19.972256	2025-11-19 19:34:19.972256
278	AF050	MACBOOK PRO 14 A2442	MAC	MACBOOK PRO 14 A2442	QR9DY7LXX3	LAPTOP	\N	384	Activo	\N	\N	Comentarios: Ricardo Camacho Tenorio | RAM: 16  GB | Disco: 512 GB SSD | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.97728	2025-11-19 19:34:19.97728
279	AF051	MACBOOK PRO 14 INCH 2021	MAC	MACBOOK PRO 14 INCH 2021	N7XVP6492T	LAPTOP	\N	290	Activo	\N	\N	RAM: 16  GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:19.980376	2025-11-19 19:34:19.980376
280	AF052	ThinkPad L15 Gen 1	LENOVO	ThinkPad L15 Gen 1	PF34E099	LAPTOP	\N	317	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-05PEME1	2025-11-19 19:34:19.986603	2025-11-19 19:34:19.986603
281	AF053	20U4S86T00	LENOVO	20U4S86T00	PF34FZTL	LAPTOP	\N	16	Activo	\N	\N	RAM: 32 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-GRT89OP	2025-11-19 19:34:19.990286	2025-11-19 19:34:19.990286
282	AF054	ThinkPad L15 Gen 1	LENOVO	ThinkPad L15 Gen 1	PF34FZ4W	LAPTOP	\N	312	Activo	\N	\N	Comentarios: ESTEFANIA VILLALBA | RAM: 16 GB | Disco: 475 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-JJLF098	2025-11-19 19:34:19.994619	2025-11-19 19:34:19.994619
283	AF055	MACBOOK PRO 14 2021	MAC	MACBOOK PRO 14 2021	MQ0CCP975M	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: EQUIPO SE ENCUENTRA CON APPLE | RAM: 16 GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host: MACBOOK-PRO-AFIRMA	2025-11-19 19:34:19.9981	2025-11-19 19:34:19.9981
284	AF056	MACBOOK PRO 14 A2442	MAC	MACBOOK PRO 14 A2442	CWVK6N2997	LAPTOP	\N	352	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:20.002733	2025-11-19 19:34:20.002733
285	AF057	MACBOOK PRO 14 2021	MAC	MACBOOK PRO 14 2021	CMFVTQHGYC	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: SE LE DEJA AL IUSUARIO  | RAM: 16 GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS Moterey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:20.005802	2025-11-19 19:34:20.005802
286	AF058	INSPIRON 15 5566	DELL YR2018	INSPIRON 15 5566	JKR80N2	LAPTOP	\N	350	Activo	\N	\N	Comentarios: Eduardo Alonso | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host:  DESKTOP-IBATII8	2025-11-19 19:34:20.011091	2025-11-19 19:34:20.011091
287	AF059	MACBOOK PRO 14 2021	MAC	MACBOOK PRO 14 2021	WCWTXF40NW	LAPTOP	\N	310	Activo	\N	\N	Comentarios: PARA ASIGNAR A UX CBRE | RAM: 16 GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS Ventura | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:20.015111	2025-11-19 19:34:20.015111
288	AF060	MOTO G7 PLUS	MOTOROLA	MOTO G7 PLUS	N/A	TELEFONO MOVIL	\N	\N	Activo	\N	\N	RAM: 3 GB | Disco: N/A | CPU: N/A | SO: Android 11	2025-11-19 19:34:20.020449	2025-11-19 19:34:20.020449
289	AF061	A21 S	SAMSUNG	A21 S	R58NC22S9YL	TELEFONO MOVIL	\N	392	Baja	\N	\N	Comentarios: SE LE DEJA AL USUARIO  | RAM: 2 GB | Disco: N/A | CPU: N/A | SO: Android 11	2025-11-19 19:34:20.023853	2025-11-19 19:34:20.023853
290	AF062	TA-1079 NOKIA 1	NOKIA	TA-1079 NOKIA 1	354479091044832	TELEFONO MOVIL	\N	\N	Activo	\N	\N	Comentarios: IMEI 354479091044832 CON CHIP (5571673688) | RAM: 2 GB | Disco: N/A | CPU: N/A | SO: Android 8	2025-11-19 19:34:20.028178	2025-11-19 19:34:20.028178
291	AF063	ILIUM LT520	LANIX	ILIUM LT520	356454081426404	TELEFONO MOVIL	\N	\N	Activo	\N	\N	Comentarios: SIN CHIP IMEI356454081426404 | RAM: 2 GB | Disco: N/A | CPU: N/A | SO: Android 8	2025-11-19 19:34:20.031292	2025-11-19 19:34:20.031292
292	AF064	ILIUM LT520	LANIX	ILIUM LT520	356454081475823	TELEFONO MOVIL	\N	\N	Activo	\N	\N	Comentarios: TIENE LA PANTALLA DAÑADA SIN CHIP (telcel) | RAM: 2 GB | Disco: 8 GB | CPU: N/A | SO: Android 7	2025-11-19 19:34:20.036274	2025-11-19 19:34:20.036274
293	AF065	TA-1027	NOKIA	TA-1027	356025082399335	TELEFONO MOVIL	\N	397	Activo	\N	\N	Comentarios: IMEI 356025082399335  | RAM: 2 GB | Disco: N/A | CPU: N/A | SO: Android 8	2025-11-19 19:34:20.038942	2025-11-19 19:34:20.038942
294	AF066	GALAXY A11	SAMSUNG	GALAXY A11	350578546779571	TELEFONO MOVIL	\N	\N	Activo	\N	\N	Comentarios: IME 350578546779571 CON CHIP, PANTALLA ROTA  | RAM: 4 GB | Disco: N/A | CPU: N/A | SO: Android 11	2025-11-19 19:34:20.044363	2025-11-19 19:34:20.044363
295	AF067	Servicio de Correo de IONOS	IONOS	Servicio de Correo de IONOS	N/A	EMAIL	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.04776	2025-11-19 19:34:20.04776
296	AF068	Servicio de maquina virtualizada (microsoft Windows Server)	IONOS	Servicio de maquina virtualizada (microsoft Windows Server)	VM070CB6A	SERVIDOR	\N	369	Activo	\N	\N	Comentarios: Maquina Virtual  | RAM: 8 GB | Disco: 400 GB | CPU: 2VCORE | SO: wndows server 2019 datacenter | Host: VM070CB6A	2025-11-19 19:34:20.052538	2025-11-19 19:34:20.052538
297	AF069	Odoo 16.0+e Versión Enterprise	Odoo	Odoo 16.0+e Versión Enterprise	N/A	APLICACION ESPECIFICA	\N	290	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.055118	2025-11-19 19:34:20.055118
298	AF070	Contpaq ( todos los modulos)	Contpaq	Contpaq ( todos los modulos)	N/A	APLICACION ESPECIFICA	\N	16	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.06057	2025-11-19 19:34:20.06057
299	AF071	Suite de office 365	Microsoft	Suite de office 365	N/A	SaaS	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.06376	2025-11-19 19:34:20.06376
300	AF072	TYPE C	HUB	TYPE C	X002TDG3U3	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.068649	2025-11-19 19:34:20.068649
301	AF073	TYPE C	HUB	TYPE C	X002TDG3U4	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.071259	2025-11-19 19:34:20.071259
302	AF074	HUB  SPECTRA TYPE C	HUB	HUB  SPECTRA TYPE C	85684	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.075797	2025-11-19 19:34:20.075797
303	AF075	MOUSE inalambrico	LOGITECH	MOUSE inalambrico	2146LZD3H4E9	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.079444	2025-11-19 19:34:20.079444
304	AF076	MOUSE inalambrico	LOGITECH	MOUSE inalambrico	2146LZD2MSJ9	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.083637	2025-11-19 19:34:20.083637
305	AF077	MOUSE inalambrico	STUK	MOUSE inalambrico	102808	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.08725	2025-11-19 19:34:20.08725
306	AF078	Contratos del Personal	Expedientes	Contratos del Personal	Carpeta 1	DOCUMENTO FISICO	\N	275	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.092293	2025-11-19 19:34:20.092293
307	AF079	Contratos del Personal	Expedientes	Contratos del Personal	Carpeta 2	DOCUMENTO FISICO	\N	275	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.096384	2025-11-19 19:34:20.096384
308	AF080	Documentos de Contabilidad	Contabilidad	Documentos de Contabilidad	Carpeta 3	DOCUMENTO FISICO	\N	16	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.100807	2025-11-19 19:34:20.100807
309	AF081	Documentos de Contabilidad	Contabilidad	Documentos de Contabilidad	Carpeta 4	DOCUMENTO FISICO	\N	16	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.104095	2025-11-19 19:34:20.104095
310	AF082	D.D. Portable 10BBK	WD	D.D. Portable 10BBK	WX81A27E5F65	ALMACENAMIENTO	\N	\N	Activo	\N	\N	RAM: N/A | Disco: 1 TB | CPU: N/A | SO: N/A	2025-11-19 19:34:20.108564	2025-11-19 19:34:20.108564
311	AF083	TL-SF1008D	TP-LINK	TL-SF1008D	2178493006648	SWITCH	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.112262	2025-11-19 19:34:20.112262
312	AF084	CP-7942G	CISCO	CP-7942G	FCH16318KCX	TELEFONO IP	\N	\N	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.116407	2025-11-19 19:34:20.116407
313	AF085	Printer Express M2885FW	SAMSUNG	Printer Express M2885FW	CNB2M56KQ9	IMPRESORA	\N	369	Activo	\N	\N	RAM:  128 MB | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.119615	2025-11-19 19:34:20.119615
314	AF086	Destructora De Papel	Guardian Gs5	Destructora De Papel	P7326	ACCESORIO	\N	369	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.122419	2025-11-19 19:34:20.122419
315	AF087	Cargador para Mac Book Pro, 87W	DODAUG	Cargador para Mac Book Pro, 87W	16D394-11	ACCESORIO	\N	369	Activo	\N	\N	Comentarios: Cargador nuevo Asiganado a jose luis toxtle | RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A	2025-11-19 19:34:20.127574	2025-11-19 19:34:20.127574
316	AF088	TA-1027	NOKIA	TA-1027	356025082404986	TELEFONO MOVIL	\N	294	Baja	\N	\N	Comentarios: SE REPORTA COMO ROBADO | RAM: 1.9 GB | Disco: 16 GB | CPU: N/A | SO: Android 9	2025-11-19 19:34:20.130667	2025-11-19 19:34:20.130667
317	AF089	MACBOOK PRO 14 2021	MAC	MACBOOK PRO 14 2021	VY2K2V0FRW	LAPTOP	\N	397	Activo	\N	\N	Comentarios: PARA ASIGNAR A FERNANDO GARRIDO | RAM: 16 GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS VENTURA | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:20.135346	2025-11-19 19:34:20.135346
318	AF090	MACBOOK PRO 14 2021	MAC	MACBOOK PRO 14 2021	NVY2199F6T	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: FALLA DEL SISTEMA OPERATIVO  | RAM: 16 GB | Disco: 512 GB | CPU: APPLE M1 PRO | SO: IOS Moterrey | Host:  MacBook-Pro-de-Afirma	2025-11-19 19:34:20.137827	2025-11-19 19:34:20.137827
319	AF091	LATITUDE 5500	DELL	LATITUDE 5500	4MJC1Z2	LAPTOP	\N	337	Activo	\N	\N	Comentarios: ASIGNADO A PROYECTO EN ESPAÑA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-FNDCPJN	2025-11-19 19:34:20.141982	2025-11-19 19:34:20.141982
320	AF092	TA-1027	Nokia	TA-1027	356025082404812	TELEFONO MOVIL	\N	\N	Activo	\N	\N	RAM: 2 GB | Disco: N/A | CPU: ANDROID 9 | SO: Android 8	2025-11-19 19:34:20.145671	2025-11-19 19:34:20.145671
321	AF093	15s-fq4010ns	HP	15s-fq4010ns	5CD2093MPG	LAPTOP	\N	298	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-HRNCKPT	2025-11-19 19:34:20.149719	2025-11-19 19:34:20.149719
322	AF094	15s-fq2107ns	HP	15s-fq2107ns	5CD13887JB	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: SE ENCUENTRA EN ESPAÑA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: JCY	2025-11-19 19:34:20.153888	2025-11-19 19:34:20.153888
323	AF095	MACBOOK PRO15	MAC	MACBOOK PRO15	C02XR6CUJG5H	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: FALLA EN BATERIA | RAM: 16 GB | Disco: 250 GB | CPU: Intel Core i7 6 NUCLEOS  | SO: MACBOOK BIG SUR  | Host: MACBOOK PRO DE AFIRMA	2025-11-19 19:34:20.158563	2025-11-19 19:34:20.158563
324	AF096	Latitude 3520	DELL	Latitude 3520	8WNLHS3	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: SE ENCUENTRA EN ESPAÑA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-A5INCCQ	2025-11-19 19:34:20.162685	2025-11-19 19:34:20.162685
325	AF097	ILIUM LT520	LANIX	ILIUM LT520	356454081122474	TELEFONO MOVIL	\N	\N	Activo	\N	\N	Comentarios: Compañia Telcel con chip  numero 5582427670 | RAM: 2 GB | Disco: 8 GB | CPU: N/A | SO: Android 7	2025-11-19 19:34:20.168462	2025-11-19 19:34:20.168462
326	AF098	TA-1027	NOKIA	TA-1027	356025082404812	TELEFONO MOVIL	\N	277	Activo	\N	\N	Comentarios: PARA ASIGNAR A RAYMUNDO CUENTA CON NUMERO 5546936042 | RAM: 1.9 GB | Disco: 16 GB | CPU: N/A | SO: Android 9 | Host: Afirma Solutions	2025-11-19 19:34:20.172693	2025-11-19 19:34:20.172693
327	AF099	DELL LATITUDE 3520	DELL	DELL LATITUDE 3520	7WNLHS3	LAPTOP	\N	306	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: \tDESKTOP-NNJVFRP	2025-11-19 19:34:20.177904	2025-11-19 19:34:20.177904
328	AF100	DELL LATITUDE 3520	DELL	DELL LATITUDE 3520	HVNLHS3	LAPTOP	\N	321	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i5 | SO: Windows 10 Pro | Host: DESKTOP-F9D2EN8	2025-11-19 19:34:20.181791	2025-11-19 19:34:20.181791
329	AF101	DELL LATITUDE 3520	DELL	DELL LATITUDE 3520	JCSSBS3	LAPTOP	\N	363	Activo	\N	\N	Comentarios: SE ENCUENTRA EN ESPAÑA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i5 | SO: Windows 10 Pro	2025-11-19 19:34:20.186964	2025-11-19 19:34:20.186964
330	AF102	V14 G2 ITL	LENOVO	V14 G2 ITL	PF458XTG	LAPTOP	\N	294	Activo	\N	\N	Comentarios: ISMAEL WENCESLAO BARRAGAN HERNANDEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-KQVQ5GKB	2025-11-19 19:34:20.191479	2025-11-19 19:34:20.191479
331	AF103	V14 G2 ITL	LENOVO	V14 G2 ITL	PF4591CV	LAPTOP	\N	386	Activo	\N	\N	Comentarios: PARA ASIGNAR JORGE GALICIA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-EL74NBNV	2025-11-19 19:34:20.195887	2025-11-19 19:34:20.195887
333	AF105	Inspiron 15 3511	DELL	Inspiron 15 3511	8LHK7K3	LAPTOP	\N	386	Activo	\N	\N	Comentarios: Luis David Chavez Acevedo | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i-1165G7  | SO: Windows 10 Pro | Host: DEFINIDO POR CLIENTE 	2025-11-19 19:34:20.204561	2025-11-19 19:34:20.204561
334	AF106	GW2870T	BENQ	GW2870T	ET1J03385019	MONITOR	\N	\N	Activo	\N	\N	RAM: N/A | Disco: N/A | CPU: N/A | SO: N/A | Host: GC287H	2025-11-19 19:34:20.210122	2025-11-19 19:34:20.210122
335	AF107	ELITE BOOK 840	HP	ELITE BOOK 840	5CG2410L13	LAPTOP	\N	276	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i-1165G7  | SO: Windows 10 Pro | Host: DESKTOP-VGFU41V	2025-11-19 19:34:20.213385	2025-11-19 19:34:20.213385
336	AF108	ELITE BOOK 840	HP	ELITE BOOK 840	5CG2410L1X	LAPTOP	\N	\N	Activo	\N	\N	Comentarios: Alfredo Aguilar Puga | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i-1165G7  | SO: Windows 10 Pro | Host: DESKTOP- M1597AB	2025-11-19 19:34:20.218443	2025-11-19 19:34:20.218443
337	AF109	ELITE BOOK 840	HP	ELITE BOOK 840	5CG2410L1L	LAPTOP	\N	350	Activo	\N	\N	Comentarios: Eduardo Bernabe | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i-1165G7  | SO: Windows 10 Pro | Host: DESKTOP-6J73FS6	2025-11-19 19:34:20.221515	2025-11-19 19:34:20.221515
338	AF110	ELITE BOOK 840	HP	ELITE BOOK 840	5CG2410L1R	LAPTOP	\N	364	Activo	\N	\N	Comentarios: ABIGAIL GALINDO TOVAR | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i-1165G7  | SO: Windows 10 Pro | Host: DESKTOP-D7KNFED	2025-11-19 19:34:20.225933	2025-11-19 19:34:20.225933
339	AF111	ELITE BOOK 840	HP	ELITE BOOK 840	5CG2410L1S	LAPTOP	\N	279	Activo	\N	\N	Comentarios: Saul Castillo | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i-1165G7  | SO: Windows 10 Pro | Host: DESKTOP-0371CK1	2025-11-19 19:34:20.229357	2025-11-19 19:34:20.229357
340	AF112	SERVER 2019 STANDART	Windows	SERVER 2019 STANDART	TIT101657	SERVIDOR	\N	369	Activo	\N	\N	RAM: 64 GB | Disco: 960 GB | CPU: AMD RYZEN 7 PRO  | SO: Windows server 2019 | Host: E084CB1	2025-11-19 19:34:20.233537	2025-11-19 19:34:20.233537
341	AF113	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46B6VK	LAPTOP	\N	300	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: DESKTOP-O97DNB7	2025-11-19 19:34:20.236663	2025-11-19 19:34:20.236663
342	AF114	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46C0ES	LAPTOP	\N	297	Activo	\N	\N	Comentarios:   | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-QVLC7163	2025-11-19 19:34:20.240969	2025-11-19 19:34:20.240969
343	AF115	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46B9F1	LAPTOP	\N	298	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-HIA99A3V	2025-11-19 19:34:20.24431	2025-11-19 19:34:20.24431
344	AF116	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46CPFZ	LAPTOP	\N	298	Activo	\N	\N	Comentarios: angel luna | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-KL4NKH2F	2025-11-19 19:34:20.247206	2025-11-19 19:34:20.247206
345	AF117	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46B9GM	LAPTOP	\N	294	Baja	\N	\N	Comentarios: SE REPORTA COMO ROBADO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-JRQBCO59	2025-11-19 19:34:20.251712	2025-11-19 19:34:20.251712
346	AF118	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46CPHW	LAPTOP	\N	300	Activo	\N	\N	Comentarios: DANIELA HERRERA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-6FJ19E55	2025-11-19 19:34:20.254814	2025-11-19 19:34:20.254814
347	AF119	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46AL9M	LAPTOP	\N	\N	Baja	\N	\N	Comentarios: Equipo presenta falla | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-SPSUBVMH	2025-11-19 19:34:20.259208	2025-11-19 19:34:20.259208
348	AF120	V14 G2 ITL	LENOVO	V14 G2 ITL	PF46KLA8	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-GUNOVBMO	2025-11-19 19:34:20.26287	2025-11-19 19:34:20.26287
349	AF121	THINKBOOK 14 G2	LENOVO	THINKBOOK 14 G2	MP2ECNB5	LAPTOP	\N	345	Activo	\N	\N	Comentarios: PARA ASIGNAR A LAURA VALENCIA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-IN3GM9NI	2025-11-19 19:34:20.267033	2025-11-19 19:34:20.267033
350	AF122	THINKBOOK 14 G2	LENOVO	THINKBOOK 14 G2	MP2ECW87	LAPTOP	\N	386	Activo	\N	\N	Comentarios: LUIS ALMARAZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-QSBUCAGI	2025-11-19 19:34:20.270535	2025-11-19 19:34:20.270535
351	AF123	THINKBOOK 14 G2	LENOVO	THINKBOOK 14 G2	MP2ECWEZ	LAPTOP	\N	395	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-GJ2M61IT	2025-11-19 19:34:20.274988	2025-11-19 19:34:20.274988
352	AF124	THINKBOOK 14 G2	LENOVO	THINKBOOK 14 G2	MP2EC8BK	LAPTOP	\N	275	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: DESKTOP-O0AMJM0	2025-11-19 19:34:20.279189	2025-11-19 19:34:20.279189
353	AF125	THINKBOOK 14 G2	LENOVO	THINKBOOK 14 G2	MP2E177W	LAPTOP	\N	\N	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-CLAC2FSU	2025-11-19 19:34:20.28495	2025-11-19 19:34:20.28495
354	AF126	THINKBOOK 14 G2	LENOVO	THINKBOOK 14 G2	MP2E1QZX	LAPTOP	\N	301	Activo	\N	\N	Comentarios: FALLA EN TECLADO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 11 | SO: Windows 10 Pro | Host: LAPTOP-K87EHDVI	2025-11-19 19:34:20.28897	2025-11-19 19:34:20.28897
355	AF127	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD232C9HL	LAPTOP	\N	294	Activo	\N	\N	Comentarios: ISMAEL WENCESLAO BARRAGAN HERNANDEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-FEHIM6B	2025-11-19 19:34:20.29433	2025-11-19 19:34:20.29433
356	AF128	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD232C9FQ	LAPTOP	\N	324	Activo	\N	\N	Comentarios: Revisar | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-N2B3L4T	2025-11-19 19:34:20.297761	2025-11-19 19:34:20.297761
357	AF129	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD230CHPK	LAPTOP	\N	378	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-7LC305U	2025-11-19 19:34:20.30251	2025-11-19 19:34:20.30251
358	AF130	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD232C9H3	LAPTOP	\N	339	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-TKP5STJ	2025-11-19 19:34:20.30595	2025-11-19 19:34:20.30595
359	AF131	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD2383SQN	LAPTOP	\N	377	Activo	\N	\N	Comentarios: LUCERO RUBY GACHUZ VAZQUEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-VACFAB9	2025-11-19 19:34:20.311357	2025-11-19 19:34:20.311357
360	AF132	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD2383SQ8	LAPTOP	\N	328	Activo	\N	\N	Comentarios: BRIAN CAMPOS ISLAS  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-1KVRQ40	2025-11-19 19:34:20.314664	2025-11-19 19:34:20.314664
361	AF133	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD331CTBY	LAPTOP	\N	307	Activo	\N	\N	Comentarios: VICTOR FAJAROD | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-PUIKEBN	2025-11-19 19:34:20.319646	2025-11-19 19:34:20.319646
362	AF134	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM08	LAPTOP	\N	319	Activo	\N	\N	Comentarios: ERICK ALEJANDRO AVILA TORRES | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-J8FC98N	2025-11-19 19:34:20.32348	2025-11-19 19:34:20.32348
363	AF135	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM0L	LAPTOP	\N	16	Activo	\N	\N	Comentarios: para cragde de imagen Gustavo hernandez | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-FN3BHSE	2025-11-19 19:34:20.32814	2025-11-19 19:34:20.32814
364	AF136	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM0M	LAPTOP	\N	298	Activo	\N	\N	Comentarios: JOSE ANTONIO MENDEZ HUITRON | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-0FTKF4J	2025-11-19 19:34:20.333282	2025-11-19 19:34:20.333282
365	AF137	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM18	LAPTOP	\N	333	Activo	\N	\N	Comentarios: EDGAR JONNATHAN MORALES LUCIO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-V8EIKJD	2025-11-19 19:34:20.337365	2025-11-19 19:34:20.337365
366	AF138	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM0S	LAPTOP	\N	346	Activo	\N	\N	Comentarios: GUADALUPE PAREDES | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-I9BIO3H	2025-11-19 19:34:20.342013	2025-11-19 19:34:20.342013
367	AF139	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM1K	LAPTOP	\N	313	Activo	\N	\N	Comentarios: Andres Hernandez | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-D33423J	2025-11-19 19:34:20.346745	2025-11-19 19:34:20.346745
368	AF140	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DM06	LAPTOP	\N	312	Activo	\N	\N	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-DM06GHU	2025-11-19 19:34:20.351063	2025-11-19 19:34:20.351063
369	AF141	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD334DLZV	LAPTOP	\N	324	Activo	\N	\N	Comentarios: SALVADOR GONZALEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-VZDL353	2025-11-19 19:34:20.354848	2025-11-19 19:34:20.354848
370	AF142	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD338GMDC	LAPTOP	\N	353	Activo	\N	\N	Comentarios: ERIC HIGAREDA COLIN | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: \tDESKTOP-CDQRCDJ	2025-11-19 19:34:20.359876	2025-11-19 19:34:20.359876
371	AF143	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD338GMC8	LAPTOP	\N	302	Activo	\N	\N	Comentarios: MIGUEL HEDAI GALINDO NUÑEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-I2K900L	2025-11-19 19:34:20.363127	2025-11-19 19:34:20.363127
372	AF144	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD338GMCQ	LAPTOP	\N	351	Activo	\N	2023-12-28	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-4BC9PAT	2025-11-19 19:34:20.367234	2025-11-19 19:34:20.367234
373	AF145	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD338GMFK	LAPTOP	\N	\N	Activo	\N	2023-12-28	Comentarios: PANFILO EDUARDO PAREDES COLIN | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-DL8J9QE	2025-11-19 19:34:20.37027	2025-11-19 19:34:20.37027
374	AF146	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD338GMFN	LAPTOP	\N	299	Activo	\N	2023-12-28	Comentarios: SAMUEL LÓPEZ PEDRERO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-0CQ96PL	2025-11-19 19:34:20.373013	2025-11-19 19:34:20.373013
375	AF147	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C94X	LAPTOP	\N	331	Activo	\N	2023-12-28	Comentarios: AGUSTIN SEVILLA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-MITIUGN	2025-11-19 19:34:20.377834	2025-11-19 19:34:20.377834
376	AF148	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C95F	LAPTOP	\N	277	Activo	\N	2023-12-28	Comentarios: PARA ASIGNAR A RAYMUNDO MARTINEZ GARCIA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-4LVSJ2L	2025-11-19 19:34:20.381044	2025-11-19 19:34:20.381044
377	AF149	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C918	LAPTOP	\N	373	Activo	\N	2024-01-08	Comentarios: EFREN TORRES PEREZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-7TAVK86	2025-11-19 19:34:20.386364	2025-11-19 19:34:20.386364
378	AF150	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C942	LAPTOP	\N	350	Activo	\N	2024-01-08	Comentarios: Eduardo Santiago Mazariego Moreno | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-B1991SL	2025-11-19 19:34:20.389014	2025-11-19 19:34:20.389014
379	AF151	V14 G3	LENOVO	V14 G3	PF4BJX3P	LAPTOP	\N	304	Activo	\N	2024-01-12	Comentarios: ISAAC YAEL MARTINEZ | RAM: 16 GB | Disco: 256 GB | CPU: 12th Gen Intel(R)  i5-1235U | SO: Windows 10 Pro | Host: DESKTOP-FD6N4P6	2025-11-19 19:34:20.394953	2025-11-19 19:34:20.394953
380	AF152	V14 G3	LENOVO	V14 G3	PF4BMZ14	LAPTOP	\N	392	Activo	\N	2024-01-22	Comentarios: FRANCISCO GUTIERREZ | RAM: 16 GB | Disco: 256 GB | CPU: 12th Gen Intel(R)  i5-1235U | SO: Windows 10 Pro | Host: DESKTOP-UHTVCPJ	2025-11-19 19:34:20.398281	2025-11-19 19:34:20.398281
381	AF153	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C92C	LAPTOP	\N	371	Activo	\N	2024-01-22	Comentarios: Eric Cruz  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-GNV2V1Q	2025-11-19 19:34:20.402444	2025-11-19 19:34:20.402444
382	AF154	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C923	LAPTOP	\N	329	Activo	\N	2024-01-22	Comentarios: JORGE CASTORENA HIRASHI | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-F5T3C95	2025-11-19 19:34:20.404995	2025-11-19 19:34:20.404995
383	AF155	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD335CHW9C	LAPTOP	\N	386	Activo	\N	2024-01-22	Comentarios: LUIS ALBERTO GRIMALDO ROBLES | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-3V5M32G	2025-11-19 19:34:20.41015	2025-11-19 19:34:20.41015
384	AF156	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD335CHY4C	LAPTOP	\N	397	Activo	\N	2024-01-22	Comentarios: FERNANDO MANUEL PEREZ DIAZ\r\n | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-NJBQ6T1	2025-11-19 19:34:20.412704	2025-11-19 19:34:20.412704
385	AF157	V14 G3	LENOVO	V14 G3	PF4PQ48F	LAPTOP	\N	\N	Activo	\N	2024-01-22	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-TKS0ULF	2025-11-19 19:34:20.416877	2025-11-19 19:34:20.416877
386	AF158	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C92J	LAPTOP	\N	\N	Activo	\N	2024-02-13	Comentarios: ALEJANDRO PEREZ PEREZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-IV48H1L	2025-11-19 19:34:20.420515	2025-11-19 19:34:20.420515
387	AF159	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C93S	LAPTOP	\N	363	Activo	\N	2024-02-13	Comentarios: LUZ MARIA ELIAS SEASTIAN | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-1SP0DHD	2025-11-19 19:34:20.423519	2025-11-19 19:34:20.423519
388	AF160	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C91C	LAPTOP	\N	322	Activo	\N	2024-02-13	Comentarios: ROGELIO MARTINEZ DIAZ\r\n | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-TVLDDSO	2025-11-19 19:34:20.4282	2025-11-19 19:34:20.4282
389	AF161	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD349C92S	LAPTOP	\N	301	Activo	\N	2024-02-13	Comentarios: MARCOS JOSUE CASTILLO RENDON | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 10 Pro | Host: DESKTOP-TDR4VBR	2025-11-19 19:34:20.433291	2025-11-19 19:34:20.433291
390	AF162	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037Y09	LAPTOP	\N	319	Activo	\N	2024-02-13	Comentarios: ERICK MISAEL ROMERO GARCIA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-LVDAMP2	2025-11-19 19:34:20.435989	2025-11-19 19:34:20.435989
391	AF163	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037XZ4	LAPTOP	\N	306	Activo	\N	2024-03-04	Comentarios: HECTOR GABRIEL ORTIZ MORA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-SL3VKTI	2025-11-19 19:34:20.438367	2025-11-19 19:34:20.438367
392	AF164	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037Y03	LAPTOP	\N	342	Activo	\N	2024-03-04	Comentarios: HUGO ENRIQUE TOVAR ROMERO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-B01E48R	2025-11-19 19:34:20.442059	2025-11-19 19:34:20.442059
393	AF165	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037Y0C	LAPTOP	\N	\N	Activo	\N	2024-03-04	Comentarios: Jerónimo Guillermo Rojas Pineda | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-NSU543U	2025-11-19 19:34:20.44585	2025-11-19 19:34:20.44585
394	AF166	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037XZS	LAPTOP	\N	351	Activo	\N	2024-03-04	Comentarios: Cesar Ivan Rojas Salazar | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-C9JJFVP	2025-11-19 19:34:20.449708	2025-11-19 19:34:20.449708
395	AF167	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZDL	LAPTOP	\N	328	Activo	\N	2024-04-26	Comentarios:  Brian Alexis Muñoz Monroy | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-44IN18Q	2025-11-19 19:34:20.4536	2025-11-19 19:34:20.4536
396	AF168	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZFY	LAPTOP	\N	\N	Activo	\N	2024-04-26	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-BBCO46	2025-11-19 19:34:20.459734	2025-11-19 19:34:20.459734
397	AF169	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZGC	LAPTOP	\N	302	Activo	\N	2024-04-26	Comentarios: MIGUEL ANGEL ESPINOZA MEDINA  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-G1NAUQE	2025-11-19 19:34:20.462264	2025-11-19 19:34:20.462264
398	AF170	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZGJ	LAPTOP	\N	317	Activo	\N	2024-04-26	Comentarios: ANTONIO ARATH MEDINA MEJIA   | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-AADDL3H	2025-11-19 19:34:20.464715	2025-11-19 19:34:20.464715
399	AF171	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZH0	LAPTOP	\N	\N	Activo	\N	2024-04-26	Comentarios: USIEL URBINA ECHEVERRIA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-DNJ1HVC	2025-11-19 19:34:20.4695	2025-11-19 19:34:20.4695
400	AF172	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZH7	LAPTOP	\N	363	Activo	\N	2024-06-20	Comentarios: MARIA FERNANDA SANCHEZ PEREZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-22LI0U5	2025-11-19 19:34:20.472067	2025-11-19 19:34:20.472067
401	AF173	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4076ZHR	LAPTOP	\N	397	Activo	\N	2024-06-20	Comentarios: FERNANDO GARCIA HIDEROA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-E0CKORN	2025-11-19 19:34:20.476847	2025-11-19 19:34:20.476847
402	AF174	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD411516L	LAPTOP	\N	389	Activo	\N	2024-06-20	Comentarios: BRUNO AXEL REYES MENDEZ | RAM: 16  GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-59DO46V	2025-11-19 19:34:20.479828	2025-11-19 19:34:20.479828
403	AF175	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4155FV1	LAPTOP	\N	392	Activo	\N	2024-06-20	Comentarios: Jose Javier Tobon Orozco  | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-0H8ENON	2025-11-19 19:34:20.485156	2025-11-19 19:34:20.485156
404	AF176	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037XXZ	LAPTOP	\N	16	Activo	\N	2024-07-15	Comentarios: Carlos Andrés Betancourt Navarrete | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-8DA83HA	2025-11-19 19:34:20.489463	2025-11-19 19:34:20.489463
405	AF177	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037XT6	LAPTOP	\N	337	Activo	\N	2024-07-15	Comentarios: Ramon Antonio Zurita Alcudia | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-PKCLALJ	2025-11-19 19:34:20.494718	2025-11-19 19:34:20.494718
406	AF178	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037Y0M	LAPTOP	\N	369	Activo	\N	2024-07-15	Comentarios: OMAR ALBERTO SANTOS NUÑEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-1VEBRPT	2025-11-19 19:34:20.501661	2025-11-19 19:34:20.501661
407	AF179	ProBook440 Gen 9	HP	ProBook440 Gen 9	5CD4037XSK	LAPTOP	\N	780	Activo	\N	2024-07-15	Comentarios: DIANA ANGELICA RAMIREZ HERNANDEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-9QS4IPD	2025-11-19 19:34:20.504855	2025-11-19 19:34:20.504855
408	AF180	Inspiron 15 3520	DELL	Inspiron 15 3520	JF99VW3	LAPTOP	\N	383	Activo	\N	2024-07-17	Comentarios: ELIEZER SANTIAGO FUENTES | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-IP6E978	2025-11-19 19:34:20.51	2025-11-19 19:34:20.51
409	AF181	Inspiron 15 3520	DELL	Inspiron 15 3520	DLZ9VW3	LAPTOP	\N	351	Activo	\N	2024-07-17	Comentarios: CARLO IVAN RAMIREZ COMPAGNY | RAM: 16  GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-7HFSNR8	2025-11-19 19:34:20.513558	2025-11-19 19:34:20.513558
410	AF182	Inspiron 15 3520	DELL	Inspiron 15 3520	6SG9VW3	LAPTOP	\N	362	Activo	\N	2024-07-17	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-6KBRQ4Q	2025-11-19 19:34:20.518408	2025-11-19 19:34:20.518408
411	AF183	Inspiron 15 3520	DELL	Inspiron 15 3520	HD99VW3	LAPTOP	\N	390	Activo	\N	2024-07-23	Comentarios:  USIEL URBINA ECHEVERRIA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-POKM34I	2025-11-19 19:34:20.521563	2025-11-19 19:34:20.521563
412	AF184	Inspiron 15 3520	DELL	Inspiron 15 3520	B6GBM34	LAPTOP	\N	300	Activo	\N	2024-07-23	Comentarios: DANIELA HERRERA URBINA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-VVB68PT	2025-11-19 19:34:20.526539	2025-11-19 19:34:20.526539
413	AF185	Inspiron 15 3520	DELL	Inspiron 15 3520	4Y8BM34	LAPTOP	\N	329	Activo	\N	2024-07-23	Comentarios: JORGE SAUL FERNANDEZ ENRIQUEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-93L75V0	2025-11-19 19:34:20.529678	2025-11-19 19:34:20.529678
414	AF186	Inspiron 15 3520	DELL	Inspiron 15 3520	3HMBM34	LAPTOP	\N	788	Activo	\N	2024-07-23	Comentarios:  Juan Carlos Robledo Ortiz | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-RA99AL3	2025-11-19 19:34:20.533791	2025-11-19 19:34:20.533791
415	AF187	Inspiron 15 3520	DELL	Inspiron 15 3520	D7N9VW3	LAPTOP	\N	346	Activo	\N	2024-07-23	Comentarios: GLADYS GUADALUPE GARCIA LOPEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-HQ4HAVQ	2025-11-19 19:34:20.53728	2025-11-19 19:34:20.53728
416	AF188	Inspiron 15 3520	DELL	Inspiron 15 3520	58Y9M34	LAPTOP	\N	350	Activo	\N	2024-07-23	Comentarios: Eduardo Santiago Mazariego Moreno | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-4U93BFF	2025-11-19 19:34:20.541499	2025-11-19 19:34:20.541499
417	AF189	Inspiron 15 3520	DELL	Inspiron 15 3520	FV89VW3	LAPTOP	\N	342	Activo	\N	2024-07-23	Comentarios:  Para Asignar a Enrique Cruz Limón | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-UNM3TE2	2025-11-19 19:34:20.545549	2025-11-19 19:34:20.545549
418	AF190	Inspiron 15 3520	DELL	Inspiron 15 3520	6ZQKVW3	LAPTOP	\N	366	Activo	\N	\N	Comentarios: ALEXANDRE MARTINEZ PINO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-PU95NHE	2025-11-19 19:34:20.549559	2025-11-19 19:34:20.549559
419	AF191	Inspiron 15 3520	DELL	Inspiron 15 3520	75GBM34	LAPTOP	\N	395	Activo	\N	\N	Comentarios: ALEJANDRO ISIDRO MARTINEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-9GLNTK7	2025-11-19 19:34:20.555398	2025-11-19 19:34:20.555398
420	AF192	Inspiron 15 3520	DELL	Inspiron 15 3520	531NR34	LAPTOP	\N	363	Activo	\N	2024-07-23	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-G6TEQHG	2025-11-19 19:34:20.560303	2025-11-19 19:34:20.560303
421	AF193	Inspiron 15 3520	DELL	Inspiron 15 3520	B4GBM34	LAPTOP	\N	379	Activo	\N	2024-07-23	Comentarios: PARA ASIGNAR A LAURA FABIOLA VALENCIA RODRIGUEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-1JNOIVE	2025-11-19 19:34:20.563244	2025-11-19 19:34:20.563244
422	AF194	Inspiron 15 3520	DELL	Inspiron 15 3520	5W8BM34	LAPTOP	\N	367	Activo	\N	2024-07-23	Comentarios:  Leonardo Lehi Cruz Arreguin | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-CV2Q71V	2025-11-19 19:34:20.56744	2025-11-19 19:34:20.56744
423	AF195	Inspiron 15 3520	DELL	Inspiron 15 3520	G3N9VW3	LAPTOP	\N	296	Activo	\N	2024-07-23	Comentarios: MARIA GABRIELA MIRANDA RIVERA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro	2025-11-19 19:34:20.570524	2025-11-19 19:34:20.570524
424	AF196	Inspiron 15 3520	DELL	Inspiron 15 3520	9BN9VW3	LAPTOP	\N	16	Activo	\N	2024-07-23	Comentarios: CARLOS ARMANDO CALDERON ESPINOSA | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-TUUIGUG	2025-11-19 19:34:20.573843	2025-11-19 19:34:20.573843
425	AF197	Inspiron 15 3520	DELL	Inspiron 15 3520	4QG9VW3	LAPTOP	\N	398	Activo	\N	2024-07-23	Comentarios: ALBERTO DE JESUS AGUILAR LOPEZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-LKJ23WG	2025-11-19 19:34:20.577962	2025-11-19 19:34:20.577962
426	AF198	Inspiron 15 3520	DELL	Inspiron 15 3520	47N9VW3	LAPTOP	\N	780	Activo	\N	2024-07-23	RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro	2025-11-19 19:34:20.581152	2025-11-19 19:34:20.581152
427	AF199	Inspiron 15 3520	DELL	Inspiron 15 3520	3HJM044	LAPTOP	\N	319	Activo	\N	2024-07-23	Comentarios: ERICK BRUNO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro	2025-11-19 19:34:20.585721	2025-11-19 19:34:20.585721
428	AF200	Inspiron 15 3520	DELL	Inspiron 15 3520	55MM044	LAPTOP	\N	276	Activo	\N	\N	Comentarios: MARTIN TAPIA ORTIZ | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro	2025-11-19 19:34:20.590044	2025-11-19 19:34:20.590044
429	AF201	Inspiron 15 3520	DELL	Inspiron 15 3520	HSDGS64	LAPTOP	\N	16	Activo	\N	\N	Comentarios: CARLOS VIDAL | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro	2025-11-19 19:34:20.595276	2025-11-19 19:34:20.595276
430	AF202	Inspiron 15 3520	DELL	Inspiron 15 3520	BVWF854	LAPTOP	\N	386	Activo	\N	\N	Comentarios: Luis Adrian Elias Valdez Corte | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro	2025-11-19 19:34:20.599861	2025-11-19 19:34:20.599861
431	AF203	Inspiron 15 3520	DELL	Inspiron 15 3520	7VKGS64	LAPTOP	\N	385	Activo	\N	\N	Comentarios:  CUTBERTO GARCIA TAMAYO | RAM: 16 GB | Disco: 512 GB | CPU: Intel Core i7 12 | SO: Windows 11 Pro | Host: DESKTOP-58PLOK	2025-11-19 19:34:20.603599	2025-11-19 19:34:20.603599
432	AF204	MacBookPro 14 2024	MAC	MacBookPro 14 2024	CMF69HVQXH	LAPTOP	\N	298	Activo	\N	2025-02-17	Comentarios: JOSE ANTONIO PADRE GARCIA | RAM: 16 GB | Disco: 1 TB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.606953	2025-11-19 19:34:20.606953
433	AF205	MacBookPro 14 2024	MAC	MacBookPro 14 2024	GQK1034Y9T	LAPTOP	\N	330	Activo	\N	2025-02-17	Comentarios: MAURICIO CARRASCO AYALA | RAM: 16 GB | Disco: 1 TB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.611454	2025-11-19 19:34:20.611454
434	AF206	MacBookPro 14 2024	MAC	MacBookPro 14 2024	KV07CKVX2Y	LAPTOP	\N	386	Activo	\N	2025-02-17	Comentarios: LUIS EDUARDO ARZATE ARIAS | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.614605	2025-11-19 19:34:20.614605
435	AF207	MacBookPro 14 2024	MAC	MacBookPro 14 2024	JR4RLXQGRQ	LAPTOP	\N	788	Activo	\N	2025-02-28	Comentarios: JUAN SALGADO | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.619296	2025-11-19 19:34:20.619296
436	AF208	MacBookPro 14 2024	MAC	MacBookPro 14 2024	K463F40WLD	LAPTOP	\N	302	Activo	\N	2025-03-04	Comentarios: JOSE MIGUEL CORREA MORALES | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.622152	2025-11-19 19:34:20.622152
437	AF209	MacBookPro 14 2024	MAC	MacBookPro 14 2024	HGGPD91V2H	LAPTOP	\N	\N	Activo	\N	2025-03-04	Comentarios:  HÉCTOR SÁNCHEZ HERNÁNDEZ | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.62785	2025-11-19 19:34:20.62785
438	AF210	MacBookPro 14 2024	MAC	MacBookPro 14 2024	L7TGRTYWP1	LAPTOP	\N	16	Activo	\N	2025-03-19	Comentarios: CARLOS BRACAMONTES QUINTERO | RAM: 16 GB | Disco: 1 TB  | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.630437	2025-11-19 19:34:20.630437
439	AF211	MacBookPro 14 2024	MAC	MacBookPro 14 2024	MW6CM2J061	LAPTOP	\N	361	Activo	\N	2025-04-14	Comentarios: BISMAN ABIMAEL | RAM: 24 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.635473	2025-11-19 19:34:20.635473
440	AF212	MacBookPro 14 2024	MAC	MacBookPro 14 2024	K2QRQ0PY1V	LAPTOP	\N	298	Activo	\N	2025-04-14	Comentarios: JOSE RICARDO CORONA LEDEZMA | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.638483	2025-11-19 19:34:20.638483
441	AF213	MacBookPro 14 2024	MAC	MacBookPro 14 2024	FT7C59QK3W	LAPTOP	\N	\N	Activo	\N	2025-04-14	Comentarios: Joshua Gonzalez Herrera | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.644278	2025-11-19 19:34:20.644278
442	AF214	MacBookPro 14 2024	MAC	MacBookPro 14 2024	C4J7TL9R16	LAPTOP	\N	360	Activo	\N	2025-04-14	Comentarios: Fredy Oldair Solis Portilla | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.64957	2025-11-19 19:34:20.64957
443	AF215	MacBookPro 14 2024	MAC	MacBookPro 14 2024	M5JM2K09CN	LAPTOP	\N	300	Activo	\N	2025-04-14	RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.654548	2025-11-19 19:34:20.654548
444	AF216	MacBookPro 14 2024	MAC	MacBookPro 14 2024	LW590N6K7T	LAPTOP	\N	300	Activo	\N	2025-04-14	Comentarios: DANIEL MARTINEZ HERNANDEZ | RAM: 16 GB | Disco: 512 GB | CPU: Apple M4 | SO: IOS Sequa | Host: MacBook Pro de Afirma	2025-11-19 19:34:20.659951	2025-11-19 19:34:20.659951
445	AF217	Inspiron 15 3520	DELL	Inspiron 15 3520	HFVL654	LAPTOP	\N	\N	Activo	\N	2025-10-28	Comentarios: OSWALDO CRUZ | RAM: 16GB | Disco: 512GB | CPU: Intel core 7 12 gen | SO: Windows 11 Pro | Host: DESKTOP-C301CFV	2025-11-19 19:34:20.664295	2025-11-19 19:34:20.664295
228	EQ218	Sin descripción	\N	\N	\N	General	\N	\N	Activo	\N	\N	\N	2025-11-19 19:33:16.137512	2025-11-19 19:34:20.667892
229	AF001	ThinkPad L15 Gen 1	Dell	ThinkPad L15 Gen 1	PF-2KVCHD	Computo		322	Mantenimiento	\N	2026-01-06	Comentarios: PARA ASIGNAR  ROGELIO MARTINEZ | RAM: 16 GB | Disco: 512 GB SSD | CPU: Intel Core i7 | SO: Windows 10 Pro | Host: DESKTOP-9QFQQNH	2025-11-19 19:34:19.755639	2025-11-20 09:56:27.066749
\.


--
-- TOC entry 5225 (class 0 OID 24987)
-- Dependencies: 249
-- Data for Name: mastercode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mastercode (id, lista, item, created_at, updated_at) FROM stdin;
167	Puestos roles	Desarrollador Test	2025-11-14 16:45:08.073349	2025-11-14 16:45:08.073349
2	Entidad	ATVANTTI	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
3	Entidad	TECNIVA	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
4	Entidad	SOFTNERGYSOLUTIONS	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
5	Entidad	LEITMOTIV	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
6	Entidad	AFIRMA ESP	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
7	Puestos roles	Director de Operaciones	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
8	Puestos roles	Auxiliar Administrativo	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
169	inventario de categoria de equipos	Computo	2025-11-21 08:40:25.963234	2025-11-21 08:40:25.963234
10	Puestos roles	PMO Digital	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
170	inventario de categoria de equipos	Mobiliario	2025-11-21 08:40:25.977811	2025-11-21 08:40:25.977811
12	Puestos roles	Desarrollador Middleware	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
171	inventario de categoria de equipos	Electronico	2025-11-21 08:40:25.979743	2025-11-21 08:40:25.979743
14	Puestos roles	DEVOPS UTP	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
172	inventario de categoria de equipos	Herramientas	2025-11-21 08:40:25.981089	2025-11-21 08:40:25.981089
16	Puestos roles	Desarrollador WEB	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
173	inventario de categoria de equipos	Vehiculos	2025-11-21 08:40:25.982165	2025-11-21 08:40:25.982165
174	inventario de categoria de equipos	Telecomunicaciones	2025-11-21 08:40:25.983151	2025-11-21 08:40:25.983151
175	inventario de categoria de equipos	Audio y Video	2025-11-21 08:40:25.985474	2025-11-21 08:40:25.985474
20	Puestos roles	Analista	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
176	inventario de categoria de equipos	Seguridad	2025-11-21 08:40:25.987078	2025-11-21 08:40:25.987078
177	inventario de categoria de equipos	Climatización	2025-11-21 08:40:25.988391	2025-11-21 08:40:25.988391
23	Puestos roles	Contador	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
178	inventario de categoria de equipos	Iluminación	2025-11-21 08:40:25.989492	2025-11-21 08:40:25.989492
25	Puestos roles	UX	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
27	Puestos roles	Business Analyst	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
30	Puestos roles	PO Digital	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
33	Puestos roles	Desarrollador Android	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
36	Puestos roles	Desarrollador BI	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
41	Puestos roles	Desarrollador Junior	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
42	Puestos roles	DevOps Engineer	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
43	Puestos roles	Diseñador UX/UI	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
44	Puestos roles	Diseñador Gráfico	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
45	Puestos roles	Contabilista	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
46	Puestos roles	Project Manager	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
47	Puestos roles	Director Ejecutivo	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
48	Puestos roles	Especialista RRHH	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
49	Puestos roles	Técnico de Soporte	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
50	Puestos roles	Ejecutivo de Ventas	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
51	Areas	STAFF – PMO	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
52	Areas	STAFF – RRHH	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
54	Areas	STAFF-FINANZAS	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
60	Proyecto	BOR	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
61	Proyecto	CBT-DIGITAL	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
68	Proyecto	PLAYTOPIA	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
72	Proyecto	RPA	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
76	Proyecto	ADO	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
81	Proyecto	BET	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
84	Proyecto	DATA LAKE	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
91	Proyecto	POSEIDON	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
93	Proyecto	RIESGOS	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
98	Entidad	AFIRMA MEX	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
105	Puestos roles	Arquitecto	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
168	Puestos roles	Tester	2025-11-14 16:53:05.138914	2025-11-14 16:53:05.138914
109	Puestos roles	Desarrollador .NET	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
112	Puestos roles	Desarrollador COBOL	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
113	Puestos roles	Desarrollador Java	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
115	Puestos roles	Desarrollador PHP	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
116	Puestos roles	Desarrollador PL/SQL	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
119	Puestos roles	Especialista DBA Oracle	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
120	Puestos roles	Front End	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
121	Puestos roles	Functional Lead	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
122	Puestos roles	Gerente	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
123	Puestos roles	Gestor de Infraestructura	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
124	Puestos roles	Gestor de Proyectos	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
128	Puestos roles	Reclutador	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
129	Puestos roles	Scrum Master	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
131	Puestos roles	Technical Lead	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
135	Areas	STAFF – TI	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
137	Areas	OPERACIONES	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
139	Proyecto	ATVANTTI	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
140	Proyecto	BANCA // BUSCANDO_PRO	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
141	Proyecto	BANCA PERSONAL	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
142	Proyecto	BANCA PRIVADA	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
147	Proyecto	INTEGRACIÓN SERVICIOS	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
148	Proyecto	INVERSIONES	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
149	Proyecto	LYNX	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
150	Proyecto	MIGRACION AGAVE	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
151	Proyecto	OPICS	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
154	Proyecto	RECUPERACIONES	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
157	Proyecto	SEGUROS INTERNO	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
158	Proyecto	SEGUROS ZURICH	2025-11-13 21:34:32.095	2025-11-13 21:34:32.095
161	Proyecto	PROYECTO DE PRUEBAS FUNCIONALES	2025-11-13 22:36:09.56716	2025-11-13 22:36:09.56716
163	Areas	DIRECCION	2025-11-14 16:04:29.96334	2025-11-14 16:04:29.96334
165	Proyecto	STAFF	2025-11-14 16:05:57.618888	2025-11-14 16:05:57.618888
166	Celulas	N/A	2025-11-14 16:07:23.217113	2025-11-14 16:07:23.217113
\.


--
-- TOC entry 5199 (class 0 OID 24628)
-- Dependencies: 223
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (id, name, description, entity_id, salary_min, salary_max, created_at, updated_at) FROM stdin;
12	Director de Operaciones	\N	8	\N	\N	2025-11-13 12:59:11.908745	2025-11-13 12:59:11.908745
13	Auxiliar Administrativo	\N	9	\N	\N	2025-11-13 15:15:15.054163	2025-11-13 15:15:15.054163
14	Gerente	\N	9	\N	\N	2025-11-13 15:15:15.139582	2025-11-13 15:15:15.139582
15	PMO Digital	\N	9	\N	\N	2025-11-13 15:15:15.323245	2025-11-13 15:15:15.323245
16	Especialista DBA Oracle	\N	9	\N	\N	2025-11-13 15:15:15.411374	2025-11-13 15:15:15.411374
17	Desarrollador Middleware	\N	9	\N	\N	2025-11-13 15:15:15.586955	2025-11-13 15:15:15.586955
18	Reclutador	\N	9	\N	\N	2025-11-13 15:15:15.773843	2025-11-13 15:15:15.773843
19	DEVOPS UTP	\N	9	\N	\N	2025-11-13 15:15:15.862553	2025-11-13 15:15:15.862553
20	Arquitecto	\N	9	\N	\N	2025-11-13 15:15:15.948308	2025-11-13 15:15:15.948308
21	Desarrollador WEB	\N	9	\N	\N	2025-11-13 15:15:16.034313	2025-11-13 15:15:16.034313
22	Functional Lead	\N	10	\N	\N	2025-11-13 15:15:16.212783	2025-11-13 15:15:16.212783
23	Technical Lead	\N	9	\N	\N	2025-11-13 15:15:16.706701	2025-11-13 15:15:16.706701
24	Desarrollador .NET	\N	9	\N	\N	2025-11-13 15:15:17.074647	2025-11-13 15:15:17.074647
25	Analista	\N	10	\N	\N	2025-11-13 15:15:17.17155	2025-11-13 15:15:17.17155
26	Front End	\N	9	\N	\N	2025-11-13 15:15:17.499809	2025-11-13 15:15:17.499809
27	Desarrollador Java	\N	9	\N	\N	2025-11-13 15:15:17.599887	2025-11-13 15:15:17.599887
28	Contador	\N	9	\N	\N	2025-11-13 15:15:17.945266	2025-11-13 15:15:17.945266
29	Desarrollador PHP	\N	9	\N	\N	2025-11-13 15:15:18.302361	2025-11-13 15:15:18.302361
30	UX	\N	9	\N	\N	2025-11-13 15:15:18.486656	2025-11-13 15:15:18.486656
31	Gestor de Proyectos	\N	9	\N	\N	2025-11-13 15:15:18.748211	2025-11-13 15:15:18.748211
32	Business Analyst	\N	11	\N	\N	2025-11-13 15:15:18.914767	2025-11-13 15:15:18.914767
33	Gestor de Infraestructura	\N	9	\N	\N	2025-11-13 15:15:19.932473	2025-11-13 15:15:19.932473
34	Scrum Master	\N	9	\N	\N	2025-11-13 15:15:20.028497	2025-11-13 15:15:20.028497
35	PO Digital	\N	9	\N	\N	2025-11-13 15:15:20.20184	2025-11-13 15:15:20.20184
36	Desarrollador PL/SQL	\N	9	\N	\N	2025-11-13 15:15:21.321474	2025-11-13 15:15:21.321474
37	SEGUROS ZAURICH	\N	9	\N	\N	2025-11-13 15:15:22.950352	2025-11-13 15:15:22.950352
38	Desarrollador Android	\N	9	\N	\N	2025-11-13 15:15:23.060808	2025-11-13 15:15:23.060808
39	Analytics	\N	10	\N	\N	2025-11-13 15:15:25.508511	2025-11-13 15:15:25.508511
40	DESARROLLADOR COBOL	\N	10	\N	\N	2025-11-13 15:15:25.674952	2025-11-13 15:15:25.674952
41	Desarrollador BI	\N	9	\N	\N	2025-11-13 15:15:26.072187	2025-11-13 15:15:26.072187
45	Auxiliar Adm	\N	\N	\N	\N	2025-11-13 17:46:16.332863	2025-11-13 17:46:16.332863
46	Business Ana	\N	\N	\N	\N	2025-11-13 17:46:16.341269	2025-11-13 17:46:16.341269
66	PROJECT MANAGER	\N	\N	\N	\N	2025-11-13 17:46:16.375559	2025-11-13 17:46:16.375559
1	Desarrollador Senior	Desarrollador con experiencia en backend	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
2	Desarrollador Junior	Desarrollador en formación	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
3	DevOps Engineer	Especialista en infraestructura y deployment	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
4	Diseñador UX/UI	Diseñador de interfaz y experiencia de usuario	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
5	Diseñador Gráfico	Diseño gráfico y branding	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
9	Contabilista	Gestión contable y financiera	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
6	Project Manager	Gestor de proyectos	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
7	Director Ejecutivo	Dirección ejecutiva	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
8	Especialista RRHH	Gestión de recursos humanos	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
11	Técnico de Soporte	Soporte técnico a clientes	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
10	Ejecutivo de Ventas	Vendedor de productos y servicios	\N	\N	\N	2025-11-13 12:23:14.054902	2025-11-13 12:23:14.054902
\.


--
-- TOC entry 5233 (class 0 OID 49765)
-- Dependencies: 257
-- Data for Name: project_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_assignments (id, project_id, employee_id, role, start_date, end_date, hours_allocated, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5213 (class 0 OID 24806)
-- Dependencies: 237
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, name, area_id, description, created_at) FROM stdin;
3	BANCA / BU	\N	\N	2025-11-13 17:46:16.412119
4	BANCA PERSON	\N	\N	2025-11-13 17:46:16.414074
5	BANCA PRIV	\N	\N	2025-11-13 17:46:16.416275
6	BET	\N	\N	2025-11-13 17:46:16.418878
7	BOR	\N	\N	2025-11-13 17:46:16.420837
8	CBT-DIGITAL	\N	\N	2025-11-13 17:46:16.422002
9	DATA LAKE	\N	\N	2025-11-13 17:46:16.423188
10	INTEGRACIÓN	\N	\N	2025-11-13 17:46:16.424651
11	INVERSIONES	\N	\N	2025-11-13 17:46:16.427051
12	LYNX	\N	\N	2025-11-13 17:46:16.429135
13	MIGRACION A	\N	\N	2025-11-13 17:46:16.430428
14	OPICS	\N	\N	2025-11-13 17:46:16.431761
15	PLAYTOPIA	\N	\N	2025-11-13 17:46:16.433449
16	POSEIDON	\N	\N	2025-11-13 17:46:16.435787
17	RECUPERACION	\N	\N	2025-11-13 17:46:16.437164
18	RIESGOS	\N	\N	2025-11-13 17:46:16.438177
19	RPA	\N	\N	2025-11-13 17:46:16.439314
20	SEGUROS INT	\N	\N	2025-11-13 17:46:16.440746
21	SEGUROS ZUR	\N	\N	2025-11-13 17:46:16.443313
22	STAFF	\N	\N	2025-11-13 17:46:16.444828
23	ADO	\N	\N	2025-11-13 17:46:24.338582
24	ATVANTTI	\N	\N	2025-11-13 17:46:24.342544
25	BANCA / BU	\N	\N	2025-11-13 17:46:24.344312
26	BANCA PERSON	\N	\N	2025-11-13 17:46:24.349935
27	BANCA PRIV	\N	\N	2025-11-13 17:46:24.353201
28	BET	\N	\N	2025-11-13 17:46:24.355458
29	BOR	\N	\N	2025-11-13 17:46:24.359544
30	CBT-DIGITAL	\N	\N	2025-11-13 17:46:24.361401
31	DATA LAKE	\N	\N	2025-11-13 17:46:24.364691
32	INTEGRACIÓN	\N	\N	2025-11-13 17:46:24.367006
33	INVERSIONES	\N	\N	2025-11-13 17:46:24.370315
34	LYNX	\N	\N	2025-11-13 17:46:24.372305
35	MIGRACION A	\N	\N	2025-11-13 17:46:24.374051
36	OPICS	\N	\N	2025-11-13 17:46:24.375833
37	PLAYTOPIA	\N	\N	2025-11-13 17:46:24.378427
38	POSEIDON	\N	\N	2025-11-13 17:46:24.380116
39	RECUPERACION	\N	\N	2025-11-13 17:46:24.38216
40	RIESGOS	\N	\N	2025-11-13 17:46:24.384202
41	RPA	\N	\N	2025-11-13 17:46:24.386807
42	SEGUROS INT	\N	\N	2025-11-13 17:46:24.38927
43	SEGUROS ZUR	\N	\N	2025-11-13 17:46:24.390947
44	STAFF	\N	\N	2025-11-13 17:46:24.393506
45	ADO	\N	\N	2025-11-20 23:03:44.309288
46	ATVANTTI	\N	\N	2025-11-20 23:03:44.321493
47	BANCA / BU	\N	\N	2025-11-20 23:03:44.323652
48	BANCA PERSON	\N	\N	2025-11-20 23:03:44.325664
49	BANCA PRIV	\N	\N	2025-11-20 23:03:44.327169
50	BET	\N	\N	2025-11-20 23:03:44.328335
51	BOR	\N	\N	2025-11-20 23:03:44.330064
52	CBT-DIGITAL	\N	\N	2025-11-20 23:03:44.332067
53	DATA LAKE	\N	\N	2025-11-20 23:03:44.333948
54	INTEGRACIÓN	\N	\N	2025-11-20 23:03:44.335483
55	INVERSIONES	\N	\N	2025-11-20 23:03:44.336789
56	LYNX	\N	\N	2025-11-20 23:03:44.338663
57	MIGRACION A	\N	\N	2025-11-20 23:03:44.34038
58	OPICS	\N	\N	2025-11-20 23:03:44.341794
59	PLAYTOPIA	\N	\N	2025-11-20 23:03:44.343829
60	POSEIDON	\N	\N	2025-11-20 23:03:44.345634
61	RECUPERACION	\N	\N	2025-11-20 23:03:44.347933
62	RIESGOS	\N	\N	2025-11-20 23:03:44.34994
63	RPA	\N	\N	2025-11-20 23:03:44.351491
64	SEGUROS INT	\N	\N	2025-11-20 23:03:44.352752
65	SEGUROS ZUR	\N	\N	2025-11-20 23:03:44.354176
66	STAFF	\N	\N	2025-11-20 23:03:44.355952
\.


--
-- TOC entry 5209 (class 0 OID 24745)
-- Dependencies: 233
-- Data for Name: salary_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salary_history (id, employee_id, salary_amount, currency, effective_date, reason, notes, created_by, created_at) FROM stdin;
1	273	151.38	COP	2018-07-16	Tarifa inicial importada	{"source_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2018-07-16","Fecha de asignación":"2018-07-16","Nombre del empleado":"JORGE LUIS GALICIA PEDRAZA","SGMM":"X","vida":"X","Posición":"Auxiliar Administrativo","Proyecto":"FINANZAS","Tarifa inicial de contratación":"151.38","Área":"AFIRMA MEX","Teléfono laboral":"5547718145","Teléfono personal":"5547718145","Correo de trabajo":"administracion@afirma-solutions.com","Correo electrónico personal":"jorgegaliciauach@gmail.com"}}	import_direct	2025-11-13 15:45:10.978699
2	274	426.93	COP	2019-01-07	Tarifa inicial importada	{"source_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2019-01-07","Fecha de asignación":"2019-01-04","Nombre del empleado":"HECTOR MARTINEZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Gerente","Proyecto":"FINANZAS","Tarifa inicial de contratación":"426.93","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"55771523612","Correo de trabajo":"hector.martinez@afirma-solutions.com","Correo electrónico personal":"hectormtzh@hotmail.com"}}	import_direct	2025-11-13 15:45:10.991971
3	277	827.00	COP	2019-09-02	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"POSEIDON","Fecha de ingreso":"2019-09-02","Fecha de asignación":"2019-09-02","Nombre del empleado":"RAYMUNDO MARTINEZ GARCIA","SGMM":"X","vida":"X","Posición":"Especialista DBA Oracle","Proyecto":"POSEIDON","Tarifa inicial de contratación":"827","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5513643502","Correo de trabajo":"raymundo.martinez@afirma.solutions","Correo electrónico personal":"RMG.SERVER@GMAIL.COM"}}	import_direct	2025-11-13 15:45:11.002621
4	283	875.00	COP	2022-11-14	Tarifa inicial importada	{"source_row":{"CLIENTE":"ADO MOBILITY","Célula":"ADO","Fecha de ingreso":"2022-11-14","Fecha de asignación":"2022-11-14","Nombre del empleado":"LUIS ALMARAZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Arquitecto","Proyecto":"CELULA Y CLIENTE MARKETING","Tarifa inicial de contratación":"875.00","Área":"AFIRMA MEX","Teléfono laboral":"5527626245","Teléfono personal":"5527626245","Correo de trabajo":"luis.almaraz@afirma.solutions","Correo electrónico personal":"luizalmaraz@gmail.com"}}	import_direct	2025-11-13 15:45:11.022603
5	284	800.00	COP	2023-01-30	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-01-30","Fecha de asignación":"2024-05-02","Nombre del empleado":"HUGO ENRIQUE TOVAR ROMERO","SGMM":"X","vida":"X","Posición":"Desarrollador WEB","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"7224243048","Teléfono personal":"7224243048","Correo de trabajo":"hugo.tovar@afirma.solutions","Correo electrónico personal":"hetr_tovar@hotmail.com"}}	import_direct	2025-11-13 15:45:11.025773
6	286	315.03	COP	2023-02-13	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2023-02-13","Fecha de asignación":"2023-02-13","Nombre del empleado":"OSCAR ABARCA MURGA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"315.03","Área":"ATVANTTI","Teléfono laboral":"5544422500","Teléfono personal":"5544422500","Correo de trabajo":"oscar.abarca@afirma.solutions","Correo electrónico personal":"murga_07@hotmail.com"}}	import_direct	2025-11-13 15:45:11.0322
7	288	615.00	COP	2023-04-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2023-04-24","Fecha de asignación":"2025-09-01","Nombre del empleado":"ANA LUCIEL MORENO SALAZAR","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"RPA","Tarifa inicial de contratación":"615","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"2281000613","Correo de trabajo":"ana.moreno@afirma.solutions","Correo electrónico personal":"lucielms01@gmail.com"}}	import_direct	2025-11-13 15:45:11.038627
8	289	600.00	COP	2023-04-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-04-24","Fecha de asignación":"2024-10-07","Nombre del empleado":"JOSUE CRUZ SANTIAGO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"600","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4425543052","Correo de trabajo":"josue.cruz@afirma.solutions","Correo electrónico personal":"j_cruz1997@outlook.es"}}	import_direct	2025-11-13 15:45:11.041813
9	291	850.00	COP	2023-05-08	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2023-05-08","Fecha de asignación":"2025-07-15","Nombre del empleado":"MARCOS JOSUE CASTILLO RENDON","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"850","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"720 754 4431","Correo de trabajo":"marcos.castillo@afirma.solutions","Correo electrónico personal":"josue_x@outlook.com"}}	import_direct	2025-11-13 15:45:11.047581
10	292	700.00	COP	2023-05-15	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-05-15","Fecha de asignación":"2023-05-16","Nombre del empleado":"LUIS DAVID CHAVEZ ACEVEDO ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"5564236602","Correo de trabajo":"luis.chavez@afirma.solutions","Correo electrónico personal":"lordchavez@hotmail.com"}}	import_direct	2025-11-13 15:45:11.050436
11	293	700.00	COP	2023-05-31	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-05-31","Fecha de asignación":"2023-06-01","Nombre del empleado":"JORGE SAUL FERNANDEZ ENRIQUEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"777 493 3918","Correo de trabajo":"jorge.fernandez@afirma.solutions","Correo electrónico personal":"jsfernandez1209@gmail.com"}}	import_direct	2025-11-13 15:45:11.054312
12	294	630.00	COP	2023-06-05	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – TI","Fecha de ingreso":"2023-06-05","Fecha de asignación":"2023-06-05","Nombre del empleado":"ISMAEL WENCESLAO BARRAGAN HERNANDEZ","SGMM":"X","vida":"X","Posición":"Desarrollador .NET","Proyecto":"DATA LAKE","Tarifa inicial de contratación":"630","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5532264475","Correo de trabajo":"ismael.barragan@afirma.solutions","Correo electrónico personal":"wences46@hotmail.com"}}	import_direct	2025-11-13 15:45:11.058793
13	297	700.00	COP	2023-07-10	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-07-10","Fecha de asignación":"2023-07-10","Nombre del empleado":"RODRIGO MENDOZA MARQUEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"777 330 8523","Correo de trabajo":"rodrigo.mendoza@afirma.solutions","Correo electrónico personal":"rodrigomendozamarq@gmail.com"}}	import_direct	2025-11-13 15:45:11.067759
14	298	700.00	COP	2023-07-10	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-07-10","Fecha de asignación":"2023-07-10","Nombre del empleado":"JOSE DE JESUS RODRIGUEZ BALBUENA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"222 111 0016","Correo de trabajo":"jesus.rodriguez@afirma.solutions","Correo electrónico personal":"jose7.balbuena@gmail.com"}}	import_direct	2025-11-13 15:45:11.071493
15	299	600.00	COP	2023-07-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA // BUSCANDO  PROYECTO ","Fecha de ingreso":"2023-07-24","Fecha de asignación":"2025-09-01","Nombre del empleado":"SAMUEL LOPEZ PEDRERO","SGMM":"X","vida":"X","Posición":"Front End","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"600","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"9934313125","Correo de trabajo":"samuel.lopez@afirma-solutions.com","Correo electrónico personal":"samilpez@gmail.com"}}	import_direct	2025-11-13 15:45:11.075529
16	300	800.00	COP	2023-07-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-07-24","Fecha de asignación":"2023-07-24","Nombre del empleado":"DANIEL MARTINEZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"55 7011 9910","Correo de trabajo":"daniel.martinez@afirma.solutions","Correo electrónico personal":"dmartinezssh@gmail.com"}}	import_direct	2025-11-13 15:45:11.07864
17	301	750.00	COP	2023-08-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BET","Fecha de ingreso":"2023-08-01","Fecha de asignación":"2023-08-01","Nombre del empleado":"MARCOS ENRIQUE TELLEZ HERRERA","SGMM":"X","vida":"X","Posición":"Analista","Proyecto":"BET - CELULA CONFIRMING AGIL","Tarifa inicial de contratación":"750","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"2871460779","Correo de trabajo":"marcos.tellez@afirma.solutions","Correo electrónico personal":"john3048@hotmail.com"}}	import_direct	2025-11-13 15:45:11.082028
18	302	750.00	COP	2023-08-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BET","Fecha de ingreso":"2023-08-01","Fecha de asignación":"2023-08-01","Nombre del empleado":"MIGUEL ANGEL DEL RELLO PORTILLO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BET - BANCA EMPRESAS","Tarifa inicial de contratación":"750","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"5587963107","Correo de trabajo":"angel.portillo@afirma.solutions","Correo electrónico personal":"miguel.delrellop@gmail.com"}}	import_direct	2025-11-13 15:45:11.084696
19	303	700.00	COP	2023-08-03	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-08-03","Fecha de asignación":"2023-08-03","Nombre del empleado":"JOSE ANTONIO PADRE GARCIA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7721347703","Correo de trabajo":"antonio.padre@afirma.solutions","Correo electrónico personal":"padre_japg@163.com"}}	import_direct	2025-11-13 15:45:11.088565
20	304	205.42	COP	2023-08-09	Tarifa inicial importada	{"source_row":{"CLIENTE":"AFIRMA","Célula":"STAFF-FINANZAS","Fecha de ingreso":"2023-08-09","Fecha de asignación":"2023-08-09","Nombre del empleado":"ISAAC YAEL MARTINEZ HERNANDEZ","SGMM":"X","vida":"X","Posición":"Contador","Proyecto":"AFIRMA","Tarifa inicial de contratación":"205.42","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7713657501","Correo de trabajo":"yael.martinez@afirma.solutions","Correo electrónico personal":"isaacyael_1993@hotmail.com"}}	import_direct	2025-11-13 15:45:11.0915
21	305	700.00	COP	2023-08-28	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-08-28","Fecha de asignación":"2023-08-28","Nombre del empleado":"ALEJANDRO PEREZ PEREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4181400096","Correo de trabajo":"alejandro.perez@afirma.solutions","Correo electrónico personal":"alex.perez.ppd@gmail.com"}}	import_direct	2025-11-13 15:45:11.094255
22	306	800.00	COP	2023-09-25	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2023-09-25","Fecha de asignación":"2024-05-02","Nombre del empleado":"HECTOR GABRIEL ORTIZ MORA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7775007400","Correo de trabajo":"hector.ortiz@afirma.solutions","Correo electrónico personal":"hgortizm@gmail.com"}}	import_direct	2025-11-13 15:45:11.098416
23	307	910.00	COP	2023-10-16	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"OPICS","Fecha de ingreso":"2023-10-16","Fecha de asignación":"2023-10-16","Nombre del empleado":"VICTOR FAJARDO URIZAR","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"OPICS","Tarifa inicial de contratación":"910","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5511731858","Correo de trabajo":"victor.fajardo@afirma.solutions","Correo electrónico personal":"victor.fajardo1369@gmail.com"}}	import_direct	2025-11-13 15:45:11.101136
24	308	690.00	COP	2023-10-23	Tarifa inicial importada	{"source_row":{"CLIENTE":"PLAYTOPIA","Célula":"PLAYTOPIA","Fecha de ingreso":"2023-10-23","Fecha de asignación":"2023-10-23","Nombre del empleado":"CARLOS URIEL PAEZ BERNABE","SGMM":"X","vida":"X","Posición":"Desarrollador PHP","Proyecto":"PLAYTOPIA","Tarifa inicial de contratación":"690","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7224190567","Correo de trabajo":"carlos.paez@afirma-solutions.com","Correo electrónico personal":"paezcuf@gmail.com"}}	import_direct	2025-11-13 15:45:11.106846
25	309	960.00	COP	2023-10-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"OPICS","Fecha de ingreso":"2023-10-24","Fecha de asignación":"2023-10-24","Nombre del empleado":"OSWALDO CRUZ NAJERA","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"OPICS","Tarifa inicial de contratación":"960","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4461225365","Correo de trabajo":"oswaldo.cruz@afirma.solutions","Correo electrónico personal":"ocrunaje@hotmail.com"}}	import_direct	2025-11-13 15:45:11.109849
26	310	500.00	COP	2023-10-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"CESVI","Célula":"STAFF – TI","Fecha de ingreso":"2023-10-24","Fecha de asignación":"2025-11-13","Nombre del empleado":"ANDREA ACEVES GUALITO","SGMM":"X","vida":"X","Posición":"UX","Proyecto":"AFIRMA","Tarifa inicial de contratación":"500","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4422719357","Correo de trabajo":"andrea.aceves@afirma.solutions","Correo electrónico personal":"aaceves.andrea@gmail.com"}}	import_direct	2025-11-13 15:45:11.113594
27	313	1000.00	COP	2023-12-08	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2023-12-08","Fecha de asignación":"2023-12-08","Nombre del empleado":"ANDRES HERNANDEZ LIMON","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"1000","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7224490235","Correo de trabajo":"andres.hernandez@afirma.solutions","Correo electrónico personal":"andreshernan@gmail.com"}}	import_direct	2025-11-13 15:45:11.122322
28	314	900.00	COP	2025-04-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-04-01","Fecha de asignación":"2025-04-01","Nombre del empleado":"PANFILO EDUARDO PAREDES COLIN","SGMM":"X","vida":"X","Posición":"Business Analyst","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"900","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"5532383997","Correo de trabajo":"edpardes@yahoo.com","Correo electrónico personal":"edpardes@yahoo.com"}}	import_direct	2025-11-13 15:45:11.126181
29	315	856.00	COP	2024-01-08	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2024-01-08","Fecha de asignación":"2024-01-08","Nombre del empleado":"FERNANDO MANUEL PEREZ DIAZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BOR","Tarifa inicial de contratación":"856","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5561133861","Correo de trabajo":"fernando.perez@afirma.solutions","Correo electrónico personal":"fer.ma.pe.di@gmail.com"}}	import_direct	2025-11-13 15:45:11.130719
30	316	800.00	COP	2024-01-09	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-01-09","Fecha de asignación":"2024-01-09","Nombre del empleado":"MIGUEL HEDAI GALINDO NUÑEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":5638824284,"Correo de trabajo":"miguel.galindo@afirma.solutions","Correo electrónico personal":"mig.hgn@gmail.com"}}	import_direct	2025-11-13 15:45:11.134022
31	318	1000.00	COP	2024-01-15	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-01-15","Fecha de asignación":"2024-01-15","Nombre del empleado":"IVAN RODRIGUEZ APOLINAR","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"1000","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5539553788","Correo de trabajo":"ivan.rodriguez@afirma.solutions","Correo electrónico personal":"ivan2909@hotmail.com"}}	import_direct	2025-11-13 15:45:11.140116
32	319	743.38	COP	2024-01-15	Tarifa inicial importada	{"source_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – TI","Fecha de ingreso":"2024-01-15","Fecha de asignación":"2025-09-03","Nombre del empleado":"ERICK BRUNO GARCIA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"STAF-TI","Tarifa inicial de contratación":"743.38","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"2351150572","Correo de trabajo":"erick.bruno@afirma.solutions","Correo electrónico personal":"erick.bruno@afirma.solutions"}}	import_direct	2025-11-13 15:45:11.142899
33	320	800.00	COP	2024-01-22	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-01-22","Fecha de asignación":"2024-05-02","Nombre del empleado":"ERICK MISAEL ROMERO GARCIA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5554662472","Correo de trabajo":"erick.romero@afirma.solutions","Correo electrónico personal":"erick.m.romero.g@gmail.com"}}	import_direct	2025-11-13 15:45:11.146744
34	323	900.00	COP	2024-02-21	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BET","Fecha de ingreso":"2024-02-21","Fecha de asignación":"2024-02-22","Nombre del empleado":"JOSE ANTONIO MENDEZ HUITRON","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BET","Tarifa inicial de contratación":"900","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4421040895","Correo de trabajo":"jose.mendez@afirma.solutions","Correo electrónico personal":"ing_antonio_mendez@outlook.com"}}	import_direct	2025-11-13 15:45:11.155135
35	324	675.00	COP	2024-03-04	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"LYNX","Fecha de ingreso":"2024-03-04","Fecha de asignación":"2024-03-04","Nombre del empleado":"SALVADOR GONZALEZ GONZALEZ","SGMM":"X","vida":"X","Posición":"Gestor de Infraestructura","Proyecto":"LYNX","Tarifa inicial de contratación":"675","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4421865010","Correo de trabajo":"salvador.gonzalez@afirma.solutions","Correo electrónico personal":"gonzaleventos@gmail.com"}}	import_direct	2025-11-13 15:45:11.15863
36	325	692.00	COP	2024-04-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2024-04-01","Fecha de asignación":"2024-04-01","Nombre del empleado":"MARIO CARLOS VALDEZ MUÑOZ","SGMM":"X","vida":"X","Posición":"Scrum Master","Proyecto":"BOR","Tarifa inicial de contratación":"692","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5545254535","Correo de trabajo":"mario.valdez@afirma.solutions","Correo electrónico personal":"carlosvaldezm@gmail.com"}}	import_direct	2025-11-13 15:45:11.160759
37	327	923.70	COP	2024-04-22	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"CBT-DIGITAL","Fecha de ingreso":"2024-04-22","Fecha de asignación":"2024-04-22","Nombre del empleado":"ERICK ALEJANDRO AVILA TORRES","SGMM":"X","vida":"X","Posición":"PO Digital","Proyecto":"CBT  - DIGITAL","Tarifa inicial de contratación":"923.70","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5519516301","Correo de trabajo":"erick.avila@afirma.solutions","Correo electrónico personal":"alexxer_18@hotmail.com"}}	import_direct	2025-11-13 15:45:11.166542
38	328	800.00	COP	2024-05-07	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-05-07","Fecha de asignación":"2024-05-07","Nombre del empleado":"BRIAN CAMPOS ISLAS","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5566804637","Correo de trabajo":"brian.campos@afirma.solutions","Correo electrónico personal":"campos2859@gmail.com"}}	import_direct	2025-11-13 15:45:11.168848
39	329	800.00	COP	2024-05-07	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-05-07","Fecha de asignación":"2024-05-07","Nombre del empleado":"JORGE ARTURO CASTORENA HIRASHI","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5621809711","Correo de trabajo":"jorge.castorena@afirma.solutions","Correo electrónico personal":"jorgehirashi@gmail.com"}}	import_direct	2025-11-13 15:45:11.173091
40	330	743.38	COP	2024-05-13	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2024-05-13","Fecha de asignación":"2024-09-01","Nombre del empleado":"MAURICIO CARRASCO AYALA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4421283972","Correo de trabajo":"mauricio.carrasco@afirma.solutions","Correo electrónico personal":"mcarrasco270992@gmail.com"}}	import_direct	2025-11-13 15:45:11.17573
41	331	738.00	COP	2024-05-27	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"DATA LAKE","Fecha de ingreso":"2024-05-27","Fecha de asignación":"2024-09-01","Nombre del empleado":"AGUSTIN SEVILLA SAIZ","SGMM":"X","vida":"X","Posición":"Gestor de Proyectos","Proyecto":"DATA LAKE","Tarifa inicial de contratación":"738","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4421280162","Correo de trabajo":"agustin.sevilla@afirma.solutions","Correo electrónico personal":"agussevi73@hotmail.com"}}	import_direct	2025-11-13 15:45:11.180808
42	332	435.55	COP	2024-06-12	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-06-12","Fecha de asignación":"2024-06-12","Nombre del empleado":"DIEGO URIEL ARTEAGA ZAMORA 2","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"435.55","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4422338246","Correo de trabajo":"diego.arteaga@afirma.solutions","Correo electrónico personal":"diegourielarteaga@gmail.com"}}	import_direct	2025-11-13 15:45:11.182968
43	334	480.00	COP	2024-06-17	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2024-06-17","Fecha de asignación":"2024-11-02","Nombre del empleado":"BRIAN ALEXIS MUÑOZ MONROY","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"DATA LAKE","Tarifa inicial de contratación":"480","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4425548377","Correo de trabajo":"brian.munoz@afirma.solutions","Correo electrónico personal":"munozbrianalexis@gmail.com"}}	import_direct	2025-11-13 15:45:11.18738
44	335	1000.00	COP	2024-06-17	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-06-17","Fecha de asignación":"2024-06-17","Nombre del empleado":"MIGUEL ANGEL ESPINOZA MEDINA","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"1000","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5519175961","Correo de trabajo":"miguel.espinoza@afirma.solutions","Correo electrónico personal":"espinoza.mdin.mig@gmail.com"}}	import_direct	2025-11-13 15:45:11.19037
45	336	800.00	COP	2024-07-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2024-07-01","Fecha de asignación":"2024-07-01","Nombre del empleado":"CARLOS ANDRES BETANCOURT NAVARRETE","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5540761609","Correo de trabajo":"carlos.betancourt@afirma.solutions","Correo electrónico personal":"carlosbetancourtnav@gmail.com"}}	import_direct	2025-11-13 15:45:11.192459
46	337	800.00	COP	2024-07-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2024-07-01","Fecha de asignación":"2024-07-01","Nombre del empleado":"RAMON ANTONIO ZURITA ALCUDIA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5543863591","Correo de trabajo":"ramon.zurita@afirma.solutions","Correo electrónico personal":"ramonz09@hotmail.com"}}	import_direct	2025-11-13 15:45:11.194814
47	338	800.00	COP	2024-07-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-07-01","Fecha de asignación":"2024-07-01","Nombre del empleado":"OMAR ALBERTO SANTOS NUÑEZ","SGMM":"X","vida":"X","Posición":"Desarrollador PL/SQL","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5539157934","Correo de trabajo":"omar.santos@afirma.solutions","Correo electrónico personal":"snoaserk12@gmail.com"}}	import_direct	2025-11-13 15:45:11.198421
48	339	700.00	COP	2024-07-22	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2024-07-22","Fecha de asignación":"2024-07-22","Nombre del empleado":"DAVID VAZQUEZ DE LA CRUZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"9934350730","Correo de trabajo":"david.vazquez@afirma.solutions","Correo electrónico personal":"david.437018@gmail.com"}}	import_direct	2025-11-13 15:45:11.200484
49	340	800.00	COP	2024-07-22	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2024-07-22","Fecha de asignación":"2024-07-22","Nombre del empleado":"CARLOS ARMANDO CALDERON ESPINOSA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"56 3664 5523","Correo de trabajo":"carlos.calderon@afirma.solutions","Correo electrónico personal":"cc.espinosa@hotmail.com"}}	import_direct	2025-11-13 15:45:11.202819
50	341	750.00	COP	2024-07-29	Tarifa inicial importada	{"source_row":{"CLIENTE":"AFIRMA","Célula":"RPA","Fecha de ingreso":"2024-07-29","Fecha de asignación":"2025-09-01","Nombre del empleado":"LUZ MARIA ELIAS SEASTIAN","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"RPA","Tarifa inicial de contratación":"750","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"4424751149","Correo de trabajo":"luz.elias@afirma.solutions","Correo electrónico personal":"ELIASLM@GMAIL.COM"}}	import_direct	2025-11-13 15:45:11.207629
51	345	800.00	COP	2024-08-19	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – PMO","Fecha de ingreso":"2024-08-19","Fecha de asignación":"2024-08-19","Nombre del empleado":"LAURA FABIOLA VALENCIA RODRIGUEZ","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"STAFF","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"7223958614","Correo de trabajo":"laura.valencia@afirma-solutions.com","Correo electrónico personal":"faby_vr@hotmail.com"}}	import_direct	2025-11-13 15:45:11.216278
52	346	523.00	COP	2024-10-17	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2024-10-17","Fecha de asignación":"2023-01-17","Nombre del empleado":"GUADALUPE YATZIRI PAREDES MEDINA 2","SGMM":"X","vida":"X","Posición":"Analista","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"523","Área":"ATVANTTI","Teléfono laboral":"4131002127","Teléfono personal":"4131002127","Correo de trabajo":"guadalupe.paredes@afirma.solutions","Correo electrónico personal":"paredes.yatziri@gmail.com"}}	import_direct	2025-11-13 15:45:11.218438
53	352	743.38	COP	2025-02-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-02-24","Fecha de asignación":"2025-02-24","Nombre del empleado":"AURORA FLORES ESTRADA","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5610833959","Correo de trabajo":"aurora.flores@afirma.solutions","Correo electrónico personal":"auflores.es@gmail.com"}}	import_direct	2025-11-13 15:45:11.232533
54	353	745.72	COP	2025-02-28	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2025-02-28","Fecha de asignación":"2025-02-28","Nombre del empleado":"ERIC HIGAREDA COLIN","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BOR","Tarifa inicial de contratación":"745.72","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7221789718","Correo de trabajo":"eric.higareda@afirma.solutions","Correo electrónico personal":"erhico@gmail.com"}}	import_direct	2025-11-13 15:45:11.234794
55	354	743.38	COP	2025-03-17	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-03-17","Fecha de asignación":"2025-03-17","Nombre del empleado":"JOSE MIGUEL CORREA MORALES","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7774431898","Correo de trabajo":"jose.correa@afirma.solutions","Correo electrónico personal":"josecorrea2702@gmail.com"}}	import_direct	2025-11-13 15:45:11.237823
56	355	743.38	COP	2025-03-17	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-03-17","Fecha de asignación":"2025-03-17","Nombre del empleado":"HECTOR SANCHEZ HERNANDEZ 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"2462170674","Teléfono personal":"2462170674","Correo de trabajo":"hector.sanchez@afirma.solutions","Correo electrónico personal":"san.her.hector@gmail.com"}}	import_direct	2025-11-13 15:45:11.240431
57	356	900.00	COP	2025-03-17	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INVERSIONES","Fecha de ingreso":"2025-03-17","Fecha de asignación":"2025-03-17","Nombre del empleado":"JUAN CARLOS SALGADO MARTINEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"INVERSIONES","Tarifa inicial de contratación":"900","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5548177809","Correo de trabajo":"juan.salgado@afirma.solutions","Correo electrónico personal":"juancarlossalgado2411@gmail.com"}}	import_direct	2025-11-13 15:45:11.243402
58	357	743.38	COP	2025-03-18	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-03-18","Fecha de asignación":"2025-03-18","Nombre del empleado":"CARLOS BRACAMONTES QUINTERO 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5532075363","Correo de trabajo":"carlos.bracamontes@afirma.solutions","Correo electrónico personal":"bracamontesquinteroc@gmail.com"}}	import_direct	2025-11-13 15:45:11.246784
59	358	743.38	COP	2025-03-20	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-03-20","Fecha de asignación":"2025-03-20","Nombre del empleado":"LUIS EDUARDO ARZATE ARIAS","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7294466006","Correo de trabajo":"luis.arzate@afirma.solutions","Correo electrónico personal":"eduardoarzate017@gmail.com"}}	import_direct	2025-11-13 15:45:11.249031
60	359	800.00	COP	2025-04-14	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-04-14","Fecha de asignación":"2025-04-14","Nombre del empleado":"LUIS ALBERTO GRIMALDO ROBLES","SGMM":"X","vida":"X","Posición":"SEGUROS ZAURICH","Proyecto":"SEGUROS","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"419 118 9660","Correo de trabajo":"luis.grimaldo@afirma.solutions","Correo electrónico personal":"luis.grimis@gmail.com"}}	import_direct	2025-11-13 15:45:11.251171
61	360	743.38	COP	2025-04-23	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-23","Nombre del empleado":"FREDY OLDAIR SOLIS PORTILLA","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":7711494558,"Correo de trabajo":"fredy.solis@afirma.solutions","Correo electrónico personal":"fredysolis86@gmail.com"}}	import_direct	2025-11-13 15:45:11.253781
62	361	663.53	COP	2025-04-23	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"CBT-DIGITAL","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-23","Nombre del empleado":"BISMAN ABIMAEL PEREZ LEMUS","SGMM":"X","vida":"X","Posición":"Desarrollador Android","Proyecto":"CBT - DIGITAL","Tarifa inicial de contratación":"663.53","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"ci","Correo de trabajo":"bisman.perez@afirma.solutions","Correo electrónico personal":"bisman.lemus@gmail.com"}}	import_direct	2025-11-13 15:45:11.25687
63	362	800.00	COP	2025-04-23	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-23","Nombre del empleado":"GRISELDA REYES BAUTISTA","SGMM":"X","vida":"X","Posición":"Business Analyst","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":800,"Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4463101622","Correo de trabajo":"griselda.reyes@afirma.solutions","Correo electrónico personal":"grireyes@gmail.com"}}	import_direct	2025-11-13 15:45:11.258916
64	363	800.00	COP	2025-04-23	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-04-23","Fecha de asignación":"2025-04-29","Nombre del empleado":"MARIA GABRIELA MIRANDA RIVERA","SGMM":"X","vida":"X","Posición":"Business Analyst","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"800","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"4421563187","Correo de trabajo":"maria.miranda@afirma.solutions","Correo electrónico personal":"mmiranda.gabriela@gmail.com"}}	import_direct	2025-11-13 15:45:11.26171
65	365	743.38	COP	2025-05-22	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PERSONAL","Fecha de ingreso":"2025-05-22","Fecha de asignación":"2025-05-22","Nombre del empleado":"FREDI DANIEL CIFUENTES ROBLEDO","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"BANCA PERSONAL","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"9621161646","Correo de trabajo":"fredi.cifuentes@afirma.solutions","Correo electrónico personal":"fredy97daniel@gmail.com"}}	import_direct	2025-11-13 15:45:11.266616
66	366	900.00	COP	2025-05-26	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RECUPERACIONES","Fecha de ingreso":"2025-05-26","Fecha de asignación":"2025-05-26","Nombre del empleado":"ALEXANDRE MARTINEZ PINO","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"RECUPERACIONES","Tarifa inicial de contratación":"900","Área":"TECNIVA","Teléfono laboral":"5580002369","Teléfono personal":"7713973086","Correo de trabajo":"alexandre.martinez@afirma.solutions","Correo electrónico personal":"tauroamp@gmail.com"}}	import_direct	2025-11-13 15:45:11.26866
67	367	860.00	COP	2025-05-26	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-05-26","Fecha de asignación":"2025-05-26","Nombre del empleado":"LEONARDO LEHI CRUZ ARREGUIN","SGMM":"X","vida":"X","Posición":"PROJECT MANAGER","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"860","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5522541939","Correo de trabajo":"leonardo.cruz@afirma.solutions","Correo electrónico personal":"leo.cruz.ing@gmail.com"}}	import_direct	2025-11-13 15:45:11.272108
68	369	743.38	COP	2025-06-16	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INTEGRACIÓN SERVICIOS ","Fecha de ingreso":"2025-06-16","Fecha de asignación":"2025-06-16","Nombre del empleado":"ALBERTO DE JESUS AGUILAR LOPEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"INTEGRACION SERVICIOS","Tarifa inicial de contratación":"743.38","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"5514903426","Correo de trabajo":"alberto.aguilar@afirma.solutions","Correo electrónico personal":"jeshua_11_7@hotmail.com"}}	import_direct	2025-11-13 15:45:11.275511
69	370	969.40	COP	2025-06-16	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INTEGRACIÓN SERVICIOS ","Fecha de ingreso":"2025-06-16","Fecha de asignación":"2025-06-16","Nombre del empleado":"EDUARDO SANTIAGO MAZARIEGO MORENO","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"INTEGRACIÓN SERVICIOS","Tarifa inicial de contratación":"969.40","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"442 747 9963","Correo de trabajo":"eduardo.mazariego@afirma.solutions","Correo electrónico personal":"esmazariego@gmail.com"}}	import_direct	2025-11-13 15:45:11.277265
70	371	969.40	COP	2025-06-16	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"INTEGRACIÓN SERVICIOS ","Fecha de ingreso":"2025-06-16","Fecha de asignación":"2025-06-16","Nombre del empleado":"ERIK CRUZ MUÑOZ","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"INTEGRACIÓN SERVICIOS","Tarifa inicial de contratación":"969.40","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"55 5400 8726","Correo de trabajo":"erik.cruz@afirma.solutions","Correo electrónico personal":"erikcruzm0190@gmail.com"}}	import_direct	2025-11-13 15:45:11.280728
71	372	773.28	COP	2025-06-24	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RIESGOS","Fecha de ingreso":"2025-06-24","Fecha de asignación":"2025-06-24","Nombre del empleado":"MARIA VERONICA DEL SOCORRO GONZALEZ LANZAGORTA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RIESGOS","Tarifa inicial de contratación":"773.28","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"5526537380","Correo de trabajo":"maria.gonzalez@afirma.solutions","Correo electrónico personal":"verogl92@hotmail.com"}}	import_direct	2025-11-13 15:45:11.282833
72	373	743.38	COP	2025-07-07	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS INTERNO","Fecha de ingreso":"2025-07-07","Fecha de asignación":"2025-07-07","Nombre del empleado":"EFREN TORRES PEREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS INTERNO","Tarifa inicial de contratación":"743.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"4423566253","Correo de trabajo":"efren.torres@afirma.solutions","Correo electrónico personal":"eftorresp@gmail.com"}}	import_direct	2025-11-13 15:45:11.284844
73	374	850.00	COP	2025-07-14	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-07-14","Fecha de asignación":"2025-07-14","Nombre del empleado":"GLADYS GUADALUPE GARCIA LOPEZ","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"SEGUROS ZURIZCH","Tarifa inicial de contratación":"850","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5529652602","Correo de trabajo":"gladys.garcia@afirma.solutions","Correo electrónico personal":"gladiolagpe@gmail.com"}}	import_direct	2025-11-13 15:45:11.288231
74	375	800.00	COP	2025-07-14	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-07-14","Fecha de asignación":"2025-07-14","Nombre del empleado":"JUAN CARLOS ROBLEDO ORTIZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"SEGUROS","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5563972631","Correo de trabajo":"juan.robledo@afirma.solutions","Correo electrónico personal":"juanrobledo.desarrollo@gmial.com"}}	import_direct	2025-11-13 15:45:11.290637
75	376	900.00	COP	2025-07-16	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-07-16","Fecha de asignación":"2025-07-16","Nombre del empleado":"CARLO IVAN RAMIREZ COMPAGNY","SGMM":"X","vida":"X","Posición":"Gestor de Infraestructura","Proyecto":"SEGUROS","Tarifa inicial de contratación":"900","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"55 3139 9186","Correo de trabajo":"ivan.ramirez@afirma.solutions","Correo electrónico personal":"carlocompagny@gmail.com"}}	import_direct	2025-11-13 15:45:11.292663
76	377	778.65	COP	2025-08-04	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RIESGOS","Fecha de ingreso":"2025-08-04","Fecha de asignación":"2025-08-04","Nombre del empleado":"LUCERO RUBY GACHUZ VAZQUEZ","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RIESGOS","Tarifa inicial de contratación":"778.65","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"7721411433","Correo de trabajo":"lucero.gachuz@afirma.solutions","Correo electrónico personal":"lucerorubygachuzv4aitsoeh@gmail.com"}}	import_direct	2025-11-13 15:45:11.294883
77	378	800.00	COP	2025-08-26	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"SEGUROS ZURICH","Fecha de ingreso":"2025-08-26","Fecha de asignación":"2025-08-26","Nombre del empleado":"DENISSE AZUCENA CRUZ ALVARADO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"SEGUROS ZURICH","Tarifa inicial de contratación":"800","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5518163650","Correo de trabajo":"denisse.cruz@afirma.solutions","Correo electrónico personal":"dencruz417@gmail.com"}}	import_direct	2025-11-13 15:45:11.298195
78	379	403.38	COP	2025-09-01	Tarifa inicial importada	{"source_row":{"CLIENTE":"AFIRMA","Célula":"STAFF – PMO","Fecha de ingreso":"2025-09-01","Fecha de asignación":"2025-09-01","Nombre del empleado":"MIRIAM ARREDONDO ESTRADA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RPA","Tarifa inicial de contratación":"403.38","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"+52 1 442 181 6470","Correo de trabajo":"miriam.arredondo@afirma.solutions","Correo electrónico personal":"psicmae@gmail.com"}}	import_direct	2025-11-13 15:45:11.300478
79	380	970.00	COP	2025-09-03	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-09-03","Fecha de asignación":"2025-09-03","Nombre del empleado":"CESAR IVAN ROJAS SALAZAR","SGMM":"X","vida":"X","Posición":"Technical Lead","Proyecto":"Área de Riesgos","Tarifa inicial de contratación":"970","Área":"SOFTNERGYSOLUTIONS","Teléfono laboral":"5580002369","Teléfono personal":"5512496044","Correo de trabajo":"cesar.rojas@afirma.solutions","Correo electrónico personal":"cesarivan.rojas.salazar@gmail.com"}}	import_direct	2025-11-13 15:45:11.302466
80	381	650.00	COP	2025-09-08	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BOR","Fecha de ingreso":"2025-09-08","Fecha de asignación":"2025-09-08","Nombre del empleado":"JERONIMO GUILLERMO ROJAS PINEDA","SGMM":"X","vida":"","Posición":"Desarrollador Middleware","Proyecto":"BOR","Tarifa inicial de contratación":"650","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"+52 1 442 122 9591","Correo de trabajo":"sergio.fernandez@afirma.solutions","Correo electrónico personal":"r_guillermo0@yahoo.com.mx"}}	import_direct	2025-11-13 15:45:11.30749
81	383	700.00	COP	2025-09-10	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"STAFF – PMO","Fecha de ingreso":"2025-09-10","Fecha de asignación":"2025-09-10","Nombre del empleado":"ELIEZER SANTIAGO FUENTES 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"RPA","Tarifa inicial de contratación":"700","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"7971060312","Correo de trabajo":"eliezer.santiago@afirma.solutions","Correo electrónico personal":"eliezersantiago-100@outlook.com"}}	import_direct	2025-11-13 15:45:11.313729
82	384	743.30	COP	2025-09-22	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"BANCA PRIVADA","Fecha de ingreso":"2025-09-22","Fecha de asignación":"2025-09-22","Nombre del empleado":"RICARDO CAMACHO TENORIO 2","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"BANCA PRIVADA","Tarifa inicial de contratación":743.3,"Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5520147557","Correo de trabajo":"ricardo.camacho@afirma.solutions","Correo electrónico personal":"ricardo.camacho.info@gmail.com"}}	import_direct	2025-11-13 15:45:11.316967
83	385	738.00	COP	2025-09-29	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-09-29","Fecha de asignación":"2025-10-29","Nombre del empleado":"CUTBERTO GARCIA TAMAYO","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":"738","Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4611249957","Correo de trabajo":"cutberto.garcia@afirma.solutions","Correo electrónico personal":"cut_garcia@hotmail.com"}}	import_direct	2025-11-13 15:45:11.32187
84	386	714.00	COP	2025-09-30	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2025-09-30","Fecha de asignación":"2025-09-30","Nombre del empleado":"LUIS ADRIAN ELIAS VALDEZ CORTES","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RPA","Tarifa inicial de contratación":714,"Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5537116759","Correo de trabajo":"luis.valdez@afirma.solutions","Correo electrónico personal":"adriancortes-25@hotmail.com"}}	import_direct	2025-11-13 15:45:11.325051
85	389	551.00	COP	2025-10-13	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-13","Fecha de asignación":"2025-10-13","Nombre del empleado":"BRUNO AXEL REYES MENDEZ","SGMM":"X","vida":"X","Posición":"Analytics","Proyecto":"ATVANTTI","Tarifa inicial de contratación":551,"Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"5540687670","Correo de trabajo":"bruno.reyes@afirma.solutions","Correo electrónico personal":"axel.reyes159@yahoo.com"}}	import_direct	2025-11-13 15:45:11.427525
86	390	684.48	COP	2025-10-13	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-13","Fecha de asignación":"2025-10-13","Nombre del empleado":"USIEL URBINA ECHEVERRIA","SGMM":"X","vida":"X","Posición":"Desarrollador PL/SQL","Proyecto":"ATVANTTI","Tarifa inicial de contratación":684.48,"Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"442-142-2323","Correo de trabajo":"usiel.urbina@afirma.solutions","Correo electrónico personal":"usielurbina@yahoo.com"}}	import_direct	2025-11-13 15:45:11.433615
87	393	461.19	COP	2025-10-20	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-10-20","Fecha de asignación":"2025-10-20","Nombre del empleado":"DIANA ANGELICA RAMIREZ HERNANDEZ 3","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"OPERATIONAL RISK MITIGATION","Tarifa inicial de contratación":461.19,"Área":"LEITMOTIV","Teléfono laboral":"5580002369","Teléfono personal":"4422674061","Correo de trabajo":"diana.ramirez@afirma.solutions","Correo electrónico personal":"dnaisgone@gmail.com"}}	import_direct	2025-11-13 15:45:11.44395
88	394	400.00	COP	2025-10-27	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-10-27","Fecha de asignación":"2025-10-28","Nombre del empleado":"MARIA FERNANDA SANCHEZ PEREZ","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"AFIRMA","Tarifa inicial de contratación":400,"Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"442 5663006","Correo de trabajo":"maria.sanchez@afirma.solutions","Correo electrónico personal":"fernandasanchezperez97@gmail.com"}}	import_direct	2025-11-13 15:45:11.448521
89	395	515.00	COP	2025-10-28	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"ATVANTTI","Fecha de ingreso":"2025-10-28","Fecha de asignación":"2025-10-28","Nombre del empleado":"ALEJANDRO ISIDRO MARTINEZ","SGMM":"X","vida":"X","Posición":"Desarrollador Middleware","Proyecto":"ATVANTTI","Tarifa inicial de contratación":515,"Área":"ATVANTTI","Teléfono laboral":"5580002369","Teléfono personal":"4423809624","Correo de trabajo":"alejandro.isidro@afirma.solutions","Correo electrónico personal":"alejandroisidromartinez@gmail.com"}}	import_direct	2025-11-13 15:45:11.451433
90	396	689.86	COP	2025-10-28	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2025-10-28","Fecha de asignación":"2025-10-28","Nombre del empleado":"ALFREDO AGUILAR PUGA","SGMM":"X","vida":"X","Posición":"Desarrollador BI","Proyecto":"RPA","Tarifa inicial de contratación":"689.86","Área":"AFIRMA MEX","Teléfono laboral":"","Teléfono personal":"5561322528","Correo de trabajo":"alfredo.aguilar@afirma.solutions","Correo electrónico personal":"alfred_ap60@hotmail.com"}}	import_direct	2025-11-13 15:45:11.455406
91	397	778.65	COP	2025-10-28	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"RPA","Fecha de ingreso":"2025-10-28","Fecha de asignación":"2025-10-28","Nombre del empleado":"FERNANDO GARCIA HIDEROA","SGMM":"X","vida":"X","Posición":"Functional Lead","Proyecto":"RPA","Tarifa inicial de contratación":"778.65","Área":"AFIRMA MEX","Teléfono laboral":"5580002369","Teléfono personal":"5544926636","Correo de trabajo":"fernando.garcia@afirma.solutions","Correo electrónico personal":"ghfernando@gmail.com"}}	import_direct	2025-11-13 15:45:11.458642
92	398	461.19	COP	2025-11-03	Tarifa inicial importada	{"source_row":{"CLIENTE":"BANCO SANTANDER","Célula":"","Fecha de ingreso":"2025-11-03","Fecha de asignación":"2025-11-13","Nombre del empleado":"JESUS LUIS FERNANDO HERNANDEZ LUNA 2","SGMM":"X","vida":"X","Posición":"Desarrollador Java","Proyecto":"OPERATIONAL RISK MITIGATION","Tarifa inicial de contratación":461.19,"Área":"LEITMOTIV","Teléfono laboral":"5580002369","Teléfono personal":"4421223211","Correo de trabajo":"jesus.hernandez@afirma.solutions","Correo electrónico personal":"jesusluisfernando@gmail.com"}}	import_direct	2025-11-13 15:45:11.461362
\.


--
-- TOC entry 5193 (class 0 OID 16396)
-- Dependencies: 217
-- Data for Name: sge_ots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sge_ots ("Número OT", "Folio Principal Santec", "Folio Santec", "Nombre Proyecto", "Estado", "Descripción", "Tipo Servicio", "Tecnología", "Aplicativo", "Fecha Inicio Santander", "Fecha Fin Santander", "Fecha Inicio Proveedor", "Fecha Fin Proveedor", "Hras. Acordadas", "Semáforo de Esfuerzo", "Semáforo de Plazo", "Líder Delivery", "Autorización RdP", "Responsable de Proyecto", "CBT Responsable", "Proveedor", "Fecha Inicio Real", "Fecha Fin Real", "Fecha Entrega Proveedor", "Días Desvío Entrega", "Ambiente", "Fecha Creación", "FT's", "Estimación e-Lab + Pruebas", "Costo por hora del Servicio (Proveedor)", "Monto del Servicio (Proveedor)", "Monto del Servicio (Proveedor) con IVA", "Clase de Coste", "Folio PdS", "Programa", "Front de Negocio", "VoBo Front de Negocio", "Fecha VoBo Front de Negocio") FROM stdin;
\.


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 234
-- Name: areas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.areas_id_seq', 15, true);


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 218
-- Name: candidates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.candidates_id_seq', 1, false);


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 238
-- Name: cells_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cells_id_seq', 1, false);


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 242
-- Name: contract_schemes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contract_schemes_id_seq', 120, true);


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 244
-- Name: contract_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contract_types_id_seq', 150, true);


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 220
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 28, true);


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 228
-- Name: emergency_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emergency_contacts_id_seq', 1, false);


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 226
-- Name: employee_audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_audit_log_id_seq', 1, false);


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 240
-- Name: employee_banking_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_banking_info_id_seq', 1, false);


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 246
-- Name: employee_contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_contracts_id_seq', 1, true);


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 230
-- Name: employee_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_documents_id_seq', 130, true);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 254
-- Name: employee_vacations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_vacations_id_seq', 3, true);


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 252
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 1, false);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 224
-- Name: employees_v2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_v2_id_seq', 813, true);


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 250
-- Name: equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_id_seq', 445, true);


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 248
-- Name: mastercode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mastercode_id_seq', 182, true);


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 222
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.positions_id_seq', 131, true);


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 256
-- Name: project_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.project_assignments_id_seq', 1, false);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 236
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 66, true);


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 232
-- Name: salary_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salary_history_id_seq', 92, true);


--
-- TOC entry 4968 (class 2606 OID 24803)
-- Name: areas areas_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_name_key UNIQUE (name);


--
-- TOC entry 4970 (class 2606 OID 24801)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- TOC entry 4915 (class 2606 OID 24612)
-- Name: candidates candidates_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT candidates_email_key UNIQUE (email);


--
-- TOC entry 4917 (class 2606 OID 24610)
-- Name: candidates candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);


--
-- TOC entry 4979 (class 2606 OID 24835)
-- Name: cells cells_name_area_id_project_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cells
    ADD CONSTRAINT cells_name_area_id_project_id_key UNIQUE (name, area_id, project_id);


--
-- TOC entry 4981 (class 2606 OID 24833)
-- Name: cells cells_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cells
    ADD CONSTRAINT cells_pkey PRIMARY KEY (id);


--
-- TOC entry 4992 (class 2606 OID 24936)
-- Name: contract_schemes contract_schemes_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_schemes
    ADD CONSTRAINT contract_schemes_name_key UNIQUE (name);


--
-- TOC entry 4994 (class 2606 OID 24934)
-- Name: contract_schemes contract_schemes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_schemes
    ADD CONSTRAINT contract_schemes_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 24948)
-- Name: contract_types contract_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_types
    ADD CONSTRAINT contract_types_name_key UNIQUE (name);


--
-- TOC entry 4998 (class 2606 OID 24946)
-- Name: contract_types contract_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_types
    ADD CONSTRAINT contract_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4919 (class 2606 OID 24625)
-- Name: entities departments_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- TOC entry 4921 (class 2606 OID 24623)
-- Name: entities departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 4957 (class 2606 OID 24719)
-- Name: emergency_contacts emergency_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emergency_contacts
    ADD CONSTRAINT emergency_contacts_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 24699)
-- Name: employee_audit_log employee_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_audit_log
    ADD CONSTRAINT employee_audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4986 (class 2606 OID 24919)
-- Name: employee_banking_info employee_banking_info_employee_id_is_active_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_banking_info
    ADD CONSTRAINT employee_banking_info_employee_id_is_active_key UNIQUE (employee_id, is_active);


--
-- TOC entry 4988 (class 2606 OID 24917)
-- Name: employee_banking_info employee_banking_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_banking_info
    ADD CONSTRAINT employee_banking_info_pkey PRIMARY KEY (id);


--
-- TOC entry 5000 (class 2606 OID 24961)
-- Name: employee_contracts employee_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_contracts
    ADD CONSTRAINT employee_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 2606 OID 24736)
-- Name: employee_documents employee_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_documents
    ADD CONSTRAINT employee_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 5021 (class 2606 OID 49624)
-- Name: employee_vacations employee_vacations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_vacations
    ADD CONSTRAINT employee_vacations_pkey PRIMARY KEY (id);


--
-- TOC entry 5017 (class 2606 OID 49320)
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- TOC entry 5019 (class 2606 OID 49318)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- TOC entry 4930 (class 2606 OID 24668)
-- Name: employees_v2 employees_v2_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT employees_v2_email_key UNIQUE (email);


--
-- TOC entry 4932 (class 2606 OID 24670)
-- Name: employees_v2 employees_v2_employee_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT employees_v2_employee_code_key UNIQUE (employee_code);


--
-- TOC entry 4934 (class 2606 OID 24666)
-- Name: employees_v2 employees_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT employees_v2_pkey PRIMARY KEY (id);


--
-- TOC entry 5009 (class 2606 OID 41108)
-- Name: equipment equipment_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_codigo_key UNIQUE (codigo);


--
-- TOC entry 5011 (class 2606 OID 41106)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);


--
-- TOC entry 5007 (class 2606 OID 24994)
-- Name: mastercode mastercode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mastercode
    ADD CONSTRAINT mastercode_pkey PRIMARY KEY (id);


--
-- TOC entry 4926 (class 2606 OID 24639)
-- Name: positions positions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_name_key UNIQUE (name);


--
-- TOC entry 4928 (class 2606 OID 24637)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- TOC entry 5023 (class 2606 OID 49772)
-- Name: project_assignments project_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_assignments
    ADD CONSTRAINT project_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 4975 (class 2606 OID 24816)
-- Name: projects projects_name_area_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_name_area_id_key UNIQUE (name, area_id);


--
-- TOC entry 4977 (class 2606 OID 24814)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- TOC entry 4966 (class 2606 OID 24754)
-- Name: salary_history salary_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_history
    ADD CONSTRAINT salary_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4913 (class 2606 OID 16402)
-- Name: sge_ots sge_ots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sge_ots
    ADD CONSTRAINT sge_ots_pkey PRIMARY KEY ("Número OT");


--
-- TOC entry 4971 (class 1259 OID 24804)
-- Name: idx_areas_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_areas_name ON public.areas USING btree (name);


--
-- TOC entry 4953 (class 1259 OID 24707)
-- Name: idx_audit_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_action ON public.employee_audit_log USING btree (action);


--
-- TOC entry 4954 (class 1259 OID 24706)
-- Name: idx_audit_changed_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_changed_at ON public.employee_audit_log USING btree (changed_at);


--
-- TOC entry 4955 (class 1259 OID 24705)
-- Name: idx_audit_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_employee_id ON public.employee_audit_log USING btree (employee_id);


--
-- TOC entry 4982 (class 1259 OID 24846)
-- Name: idx_cells_area_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cells_area_id ON public.cells USING btree (area_id);


--
-- TOC entry 4983 (class 1259 OID 24848)
-- Name: idx_cells_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cells_name ON public.cells USING btree (name);


--
-- TOC entry 4984 (class 1259 OID 24847)
-- Name: idx_cells_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cells_project_id ON public.cells USING btree (project_id);


--
-- TOC entry 4922 (class 1259 OID 24626)
-- Name: idx_departments_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_departments_name ON public.entities USING btree (name);


--
-- TOC entry 4958 (class 1259 OID 24725)
-- Name: idx_emergency_contacts_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_emergency_contacts_employee_id ON public.emergency_contacts USING btree (employee_id);


--
-- TOC entry 4989 (class 1259 OID 24979)
-- Name: idx_employee_banking_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_banking_active ON public.employee_banking_info USING btree (employee_id, is_active) WHERE (is_active = true);


--
-- TOC entry 4990 (class 1259 OID 24978)
-- Name: idx_employee_banking_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_banking_employee_id ON public.employee_banking_info USING btree (employee_id);


--
-- TOC entry 5001 (class 1259 OID 24981)
-- Name: idx_employee_contracts_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_contracts_active ON public.employee_contracts USING btree (employee_id, is_active) WHERE (is_active = true);


--
-- TOC entry 5002 (class 1259 OID 24982)
-- Name: idx_employee_contracts_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_contracts_dates ON public.employee_contracts USING btree (start_date, end_date);


--
-- TOC entry 5003 (class 1259 OID 24980)
-- Name: idx_employee_contracts_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_contracts_employee_id ON public.employee_contracts USING btree (employee_id);


--
-- TOC entry 4961 (class 1259 OID 24742)
-- Name: idx_employee_documents_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_documents_employee_id ON public.employee_documents USING btree (employee_id);


--
-- TOC entry 4962 (class 1259 OID 24743)
-- Name: idx_employee_documents_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_documents_type ON public.employee_documents USING btree (document_type);


--
-- TOC entry 4935 (class 1259 OID 24864)
-- Name: idx_employees_v2_area_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_area_id ON public.employees_v2 USING btree (area_id);


--
-- TOC entry 4936 (class 1259 OID 24866)
-- Name: idx_employees_v2_cell_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_cell_id ON public.employees_v2 USING btree (cell_id);


--
-- TOC entry 4937 (class 1259 OID 41015)
-- Name: idx_employees_v2_colonia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_colonia ON public.employees_v2 USING btree (colonia);


--
-- TOC entry 4938 (class 1259 OID 41032)
-- Name: idx_employees_v2_curp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_curp ON public.employees_v2 USING btree (curp);


--
-- TOC entry 4939 (class 1259 OID 24681)
-- Name: idx_employees_v2_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_email ON public.employees_v2 USING btree (email);


--
-- TOC entry 4940 (class 1259 OID 24682)
-- Name: idx_employees_v2_employee_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_employee_code ON public.employees_v2 USING btree (employee_code);


--
-- TOC entry 4941 (class 1259 OID 24684)
-- Name: idx_employees_v2_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_entity_id ON public.employees_v2 USING btree (entity_id);


--
-- TOC entry 4942 (class 1259 OID 24687)
-- Name: idx_employees_v2_first_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_first_name ON public.employees_v2 USING btree (first_name);


--
-- TOC entry 4943 (class 1259 OID 24689)
-- Name: idx_employees_v2_fullname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_fullname ON public.employees_v2 USING btree (lower((((first_name)::text || ' '::text) || (last_name)::text)));


--
-- TOC entry 4944 (class 1259 OID 24686)
-- Name: idx_employees_v2_hire_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_hire_date ON public.employees_v2 USING btree (hire_date);


--
-- TOC entry 4945 (class 1259 OID 24688)
-- Name: idx_employees_v2_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_last_name ON public.employees_v2 USING btree (last_name);


--
-- TOC entry 4946 (class 1259 OID 41034)
-- Name: idx_employees_v2_nss; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_nss ON public.employees_v2 USING btree (nss);


--
-- TOC entry 4947 (class 1259 OID 24683)
-- Name: idx_employees_v2_position_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_position_id ON public.employees_v2 USING btree (position_id);


--
-- TOC entry 4948 (class 1259 OID 24865)
-- Name: idx_employees_v2_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_project_id ON public.employees_v2 USING btree (project_id);


--
-- TOC entry 4949 (class 1259 OID 41033)
-- Name: idx_employees_v2_rfc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_rfc ON public.employees_v2 USING btree (rfc);


--
-- TOC entry 4950 (class 1259 OID 24685)
-- Name: idx_employees_v2_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_v2_status ON public.employees_v2 USING btree (status);


--
-- TOC entry 5012 (class 1259 OID 41117)
-- Name: idx_equipment_asignado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_asignado_id ON public.equipment USING btree (asignado_id);


--
-- TOC entry 5013 (class 1259 OID 41115)
-- Name: idx_equipment_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_categoria ON public.equipment USING btree (categoria);


--
-- TOC entry 5014 (class 1259 OID 41114)
-- Name: idx_equipment_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_codigo ON public.equipment USING btree (codigo);


--
-- TOC entry 5015 (class 1259 OID 41116)
-- Name: idx_equipment_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_estado ON public.equipment USING btree (estado);


--
-- TOC entry 5004 (class 1259 OID 24995)
-- Name: idx_mastercode_lista; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mastercode_lista ON public.mastercode USING btree (lista);


--
-- TOC entry 5005 (class 1259 OID 24996)
-- Name: idx_mastercode_lista_item; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mastercode_lista_item ON public.mastercode USING btree (lista, item);


--
-- TOC entry 4923 (class 1259 OID 24646)
-- Name: idx_positions_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_positions_entity_id ON public.positions USING btree (entity_id);


--
-- TOC entry 4924 (class 1259 OID 24645)
-- Name: idx_positions_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_positions_name ON public.positions USING btree (name);


--
-- TOC entry 4972 (class 1259 OID 24822)
-- Name: idx_projects_area_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_area_id ON public.projects USING btree (area_id);


--
-- TOC entry 4973 (class 1259 OID 24823)
-- Name: idx_projects_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_name ON public.projects USING btree (name);


--
-- TOC entry 4963 (class 1259 OID 24761)
-- Name: idx_salary_history_effective_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_salary_history_effective_date ON public.salary_history USING btree (effective_date);


--
-- TOC entry 4964 (class 1259 OID 24760)
-- Name: idx_salary_history_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_salary_history_employee_id ON public.salary_history USING btree (employee_id);


--
-- TOC entry 5047 (class 2620 OID 41119)
-- Name: equipment equipment_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER equipment_updated_at BEFORE UPDATE ON public.equipment FOR EACH ROW EXECUTE FUNCTION public.update_equipment_updated_at();


--
-- TOC entry 5044 (class 2620 OID 49868)
-- Name: employee_banking_info update_employee_banking_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_employee_banking_info_updated_at BEFORE UPDATE ON public.employee_banking_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5045 (class 2620 OID 49869)
-- Name: employee_contracts update_employee_contracts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_employee_contracts_updated_at BEFORE UPDATE ON public.employee_contracts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5046 (class 2620 OID 24997)
-- Name: mastercode update_mastercode_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_mastercode_updated_at BEFORE UPDATE ON public.mastercode FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5035 (class 2606 OID 24836)
-- Name: cells cells_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cells
    ADD CONSTRAINT cells_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id) ON DELETE SET NULL;


--
-- TOC entry 5036 (class 2606 OID 24841)
-- Name: cells cells_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cells
    ADD CONSTRAINT cells_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- TOC entry 5031 (class 2606 OID 24720)
-- Name: emergency_contacts emergency_contacts_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emergency_contacts
    ADD CONSTRAINT emergency_contacts_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5030 (class 2606 OID 24700)
-- Name: employee_audit_log employee_audit_log_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_audit_log
    ADD CONSTRAINT employee_audit_log_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5037 (class 2606 OID 24920)
-- Name: employee_banking_info employee_banking_info_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_banking_info
    ADD CONSTRAINT employee_banking_info_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5038 (class 2606 OID 24972)
-- Name: employee_contracts employee_contracts_contract_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_contracts
    ADD CONSTRAINT employee_contracts_contract_scheme_id_fkey FOREIGN KEY (contract_scheme_id) REFERENCES public.contract_schemes(id);


--
-- TOC entry 5039 (class 2606 OID 24967)
-- Name: employee_contracts employee_contracts_contract_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_contracts
    ADD CONSTRAINT employee_contracts_contract_type_id_fkey FOREIGN KEY (contract_type_id) REFERENCES public.contract_types(id);


--
-- TOC entry 5040 (class 2606 OID 24962)
-- Name: employee_contracts employee_contracts_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_contracts
    ADD CONSTRAINT employee_contracts_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5032 (class 2606 OID 24737)
-- Name: employee_documents employee_documents_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_documents
    ADD CONSTRAINT employee_documents_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5041 (class 2606 OID 49870)
-- Name: equipment equipment_asignado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_asignado_id_fkey FOREIGN KEY (asignado_id) REFERENCES public.employees_v2(id) ON DELETE SET NULL;


--
-- TOC entry 5025 (class 2606 OID 25053)
-- Name: employees_v2 fk_employees_v2_area_mastercode; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT fk_employees_v2_area_mastercode FOREIGN KEY (area_id) REFERENCES public.mastercode(id) ON DELETE SET NULL;


--
-- TOC entry 5026 (class 2606 OID 25063)
-- Name: employees_v2 fk_employees_v2_cell_mastercode; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT fk_employees_v2_cell_mastercode FOREIGN KEY (cell_id) REFERENCES public.mastercode(id) ON DELETE SET NULL;


--
-- TOC entry 5027 (class 2606 OID 25048)
-- Name: employees_v2 fk_employees_v2_entity_mastercode; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT fk_employees_v2_entity_mastercode FOREIGN KEY (entity_id) REFERENCES public.mastercode(id) ON DELETE SET NULL;


--
-- TOC entry 5028 (class 2606 OID 25043)
-- Name: employees_v2 fk_employees_v2_position_mastercode; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT fk_employees_v2_position_mastercode FOREIGN KEY (position_id) REFERENCES public.mastercode(id) ON DELETE SET NULL;


--
-- TOC entry 5029 (class 2606 OID 25058)
-- Name: employees_v2 fk_employees_v2_project_mastercode; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_v2
    ADD CONSTRAINT fk_employees_v2_project_mastercode FOREIGN KEY (project_id) REFERENCES public.mastercode(id) ON DELETE SET NULL;


--
-- TOC entry 5024 (class 2606 OID 24640)
-- Name: positions positions_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_department_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- TOC entry 5042 (class 2606 OID 49778)
-- Name: project_assignments project_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_assignments
    ADD CONSTRAINT project_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5043 (class 2606 OID 49773)
-- Name: project_assignments project_assignments_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_assignments
    ADD CONSTRAINT project_assignments_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 5034 (class 2606 OID 24817)
-- Name: projects projects_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id) ON DELETE CASCADE;


--
-- TOC entry 5033 (class 2606 OID 24755)
-- Name: salary_history salary_history_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_history
    ADD CONSTRAINT salary_history_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees_v2(id) ON DELETE CASCADE;


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO gama;


-- Completed on 2026-02-04 15:19:09

--
-- PostgreSQL database dump complete
--

