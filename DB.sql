--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.9
-- Dumped by pg_dump version 9.6.9

-- Started on 2018-05-14 02:27:56 +05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12427)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2171 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 199 (class 1255 OID 21862)
-- Name: add_transfer(integer, double precision, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_transfer(invoke integer, cost double precision, cur character varying, company character varying, refer character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID int;
BEGIN
	if (select count(*) from transfer where invoke_id=invoke)<>0 then
		return json_build_object('status',403,'ERROR','Transfer already exists');
	end if;

	insert into transfer(invoke_id, currency, amount, company, store_page) values(invoke,cur,cost,company,refer)returning transfer.invoke_id into ID;
	return json_build_object('status',201,'invoke_id',ID);
END
$$;


ALTER FUNCTION public.add_transfer(invoke integer, cost double precision, cur character varying, company character varying, refer character varying) OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 21864)
-- Name: get_transfer(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_transfer(page_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
	if (select count(*) from transfer where transfer.invoke_id=page_id)=0 then
		return json_build_object('status',404,'ERROR','Transfer not found');
	end if;

	return (select row_to_json( t)--json convert
		from (
		select 200 as "status",invoke_id, company, store_page, currency,amount from transfer where transfer.invoke_id=page_id
		) t);
END
$$;


ALTER FUNCTION public.get_transfer(page_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 185 (class 1259 OID 21842)
-- Name: transfer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer (
    invoke_id integer,
    currency character varying,
    amount double precision,
    company character varying,
    store_page character varying,
    id integer NOT NULL
);


ALTER TABLE public.transfer OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 21848)
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_id_seq OWNER TO postgres;

--
-- TOC entry 2172 (class 0 OID 0)
-- Dependencies: 186
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfer_id_seq OWNED BY public.transfer.id;


--
-- TOC entry 2042 (class 2604 OID 21850)
-- Name: transfer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer ALTER COLUMN id SET DEFAULT nextval('public.transfer_id_seq'::regclass);


--
-- TOC entry 2162 (class 0 OID 21842)
-- Dependencies: 185
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfer (invoke_id, currency, amount, company, store_page, id) FROM stdin;
1222609871	RUB	39161	ООО РСВ	http://rsvcollection.ru/	47
1222609872	RUB	59273	ООО РСВ	http://rsvcollection.ru/	48
1222609873	RUB	35698	ООО РСВ	http://rsvcollection.ru/	49
\.


--
-- TOC entry 2173 (class 0 OID 0)
-- Dependencies: 186
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transfer_id_seq', 49, true);


--
-- TOC entry 2044 (class 2606 OID 21858)
-- Name: transfer id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer
    ADD CONSTRAINT id PRIMARY KEY (id);


-- Completed on 2018-05-14 02:27:57 +05

--
-- PostgreSQL database dump complete
--

