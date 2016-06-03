-- noinspection SqlDialectInspectionForFile
--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: agdd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agdd (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE agdd OWNER TO postgres;

--
-- Name: agdd_2016; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agdd_2016 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    scale text,
    base integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE agdd_2016 OWNER TO postgres;

--
-- Name: agdd_2016_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agdd_2016_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agdd_2016_rid_seq OWNER TO postgres;

--
-- Name: agdd_2016_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agdd_2016_rid_seq OWNED BY agdd_2016.rid;


--
-- Name: agdd_50f; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agdd_50f (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE agdd_50f OWNER TO postgres;

--
-- Name: agdd_50f_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agdd_50f_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agdd_50f_fid_seq OWNER TO postgres;

--
-- Name: agdd_50f_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agdd_50f_fid_seq OWNED BY agdd_50f.fid;


--
-- Name: agdd_anomaly; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agdd_anomaly (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE agdd_anomaly OWNER TO postgres;

--
-- Name: agdd_anomaly_2016; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agdd_anomaly_2016 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    scale text,
    base integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE agdd_anomaly_2016 OWNER TO postgres;

--
-- Name: agdd_anomaly_2016_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agdd_anomaly_2016_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agdd_anomaly_2016_rid_seq OWNER TO postgres;

--
-- Name: agdd_anomaly_2016_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agdd_anomaly_2016_rid_seq OWNED BY agdd_anomaly_2016.rid;


--
-- Name: agdd_anomaly_50f; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agdd_anomaly_50f (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE agdd_anomaly_50f OWNER TO postgres;

--
-- Name: agdd_anomaly_50f_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agdd_anomaly_50f_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agdd_anomaly_50f_fid_seq OWNER TO postgres;

--
-- Name: agdd_anomaly_50f_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agdd_anomaly_50f_fid_seq OWNED BY agdd_anomaly_50f.fid;


--
-- Name: agdd_anomaly_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agdd_anomaly_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agdd_anomaly_fid_seq OWNER TO postgres;

--
-- Name: agdd_anomaly_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agdd_anomaly_fid_seq OWNED BY agdd_anomaly.fid;


--
-- Name: agdd_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agdd_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agdd_fid_seq OWNER TO postgres;

--
-- Name: agdd_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agdd_fid_seq OWNED BY agdd.fid;


--
-- Name: avg_agdd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE avg_agdd (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    doy integer
);


ALTER TABLE avg_agdd OWNER TO postgres;

--
-- Name: avg_agdd_50f; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE avg_agdd_50f (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    doy integer
);


ALTER TABLE avg_agdd_50f OWNER TO postgres;

--
-- Name: avg_agdd_50f_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE avg_agdd_50f_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avg_agdd_50f_fid_seq OWNER TO postgres;

--
-- Name: avg_agdd_50f_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE avg_agdd_50f_fid_seq OWNED BY avg_agdd_50f.fid;


--
-- Name: avg_agdd_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE avg_agdd_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avg_agdd_fid_seq OWNER TO postgres;

--
-- Name: avg_agdd_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE avg_agdd_fid_seq OWNED BY avg_agdd.fid;


--
-- Name: hourly_temp_2014; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hourly_temp_2014 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    rast_hour integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE hourly_temp_2014 OWNER TO postgres;

--
-- Name: hourly_temp_2014_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hourly_temp_2014_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hourly_temp_2014_rid_seq OWNER TO postgres;

--
-- Name: hourly_temp_2014_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE hourly_temp_2014_rid_seq OWNED BY hourly_temp_2014.rid;


--
-- Name: hourly_temp_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hourly_temp_2015 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    rast_hour integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE hourly_temp_2015 OWNER TO postgres;

--
-- Name: hourly_temp_2015_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hourly_temp_2015_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hourly_temp_2015_rid_seq OWNER TO postgres;

--
-- Name: hourly_temp_2015_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE hourly_temp_2015_rid_seq OWNED BY hourly_temp_2015.rid;


--
-- Name: hourly_temp_2016; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hourly_temp_2016 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    rast_hour integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE hourly_temp_2016 OWNER TO postgres;

--
-- Name: hourly_temp_2016_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hourly_temp_2016_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hourly_temp_2016_rid_seq OWNER TO postgres;

--
-- Name: hourly_temp_2016_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE hourly_temp_2016_rid_seq OWNED BY hourly_temp_2016.rid;


--
-- Name: hourly_temp_uncertainty_2016; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hourly_temp_uncertainty_2016 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    rast_hour integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE hourly_temp_uncertainty_2016 OWNER TO postgres;

--
-- Name: hourly_temp_uncertainty_2016_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hourly_temp_uncertainty_2016_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hourly_temp_uncertainty_2016_rid_seq OWNER TO postgres;

--
-- Name: hourly_temp_uncertainty_2016_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE hourly_temp_uncertainty_2016_rid_seq OWNED BY hourly_temp_uncertainty_2016.rid;


--
-- Name: lee_test; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lee_test (
    latitude double precision,
    longitude double precision,
    name text,
    id integer
);


ALTER TABLE lee_test OWNER TO postgres;

--
-- Name: mosaic; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mosaic (
    name text,
    tiletable text,
    minx double precision,
    miny double precision,
    maxx double precision,
    maxy double precision,
    resx double precision,
    resy double precision
);


ALTER TABLE mosaic OWNER TO postgres;

--
-- Name: ncep_spring_index; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ncep_spring_index (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    plant text,
    phenophase text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{16BSI}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFB48A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE ncep_spring_index OWNER TO postgres;

--
-- Name: ncep_spring_index_historic; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ncep_spring_index_historic (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    plant text,
    phenophase text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{16BSI}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFB58A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE ncep_spring_index_historic OWNER TO postgres;

--
-- Name: ncep_spring_index_historic_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ncep_spring_index_historic_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ncep_spring_index_historic_rid_seq OWNER TO postgres;

--
-- Name: ncep_spring_index_historic_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ncep_spring_index_historic_rid_seq OWNED BY ncep_spring_index_historic.rid;


--
-- Name: ncep_spring_index_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ncep_spring_index_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ncep_spring_index_rid_seq OWNER TO postgres;

--
-- Name: ncep_spring_index_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ncep_spring_index_rid_seq OWNED BY ncep_spring_index.rid;


--
-- Name: postgis_rasters; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE postgis_rasters (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone,
    climatesource character varying(255)
);


ALTER TABLE postgis_rasters OWNER TO postgres;

--
-- Name: postgis_rasters_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE postgis_rasters_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE postgis_rasters_fid_seq OWNER TO postgres;

--
-- Name: postgis_rasters_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE postgis_rasters_fid_seq OWNED BY postgis_rasters.fid;


--
-- Name: prism_30yr_avg_agdd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_30yr_avg_agdd (
    rid integer NOT NULL,
    rast raster,
    filename text,
    doy integer,
    scale text,
    base integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '01000000008D844BF3D900973FB7E96E99989395BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641852136114::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055391)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE prism_30yr_avg_agdd OWNER TO postgres;

--
-- Name: prism_30yr_avg_agdd_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_30yr_avg_agdd_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_30yr_avg_agdd_rid_seq OWNER TO postgres;

--
-- Name: prism_30yr_avg_agdd_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_30yr_avg_agdd_rid_seq OWNED BY prism_30yr_avg_agdd.rid;


--
-- Name: prism_30yr_avg_spring_index; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_30yr_avg_spring_index (
    rid integer NOT NULL,
    rast raster,
    filename text,
    plant text,
    phenophase text,
    doy integer,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '01000000008B844BF3D900973FB7E96E99989395BF5655555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641852136114::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055391)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE prism_30yr_avg_spring_index OWNER TO postgres;

--
-- Name: prism_30yr_avg_spring_index_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_30yr_avg_spring_index_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_30yr_avg_spring_index_rid_seq OWNER TO postgres;

--
-- Name: prism_30yr_avg_spring_index_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_30yr_avg_spring_index_rid_seq OWNED BY prism_30yr_avg_spring_index.rid;


--
-- Name: prism_spring_index; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_spring_index (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    plant text,
    phenophase text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{16BSI}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5655555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_spring_index OWNER TO postgres;

--
-- Name: prism_spring_index_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_spring_index_2015 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    plant text,
    phenophase text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{16BSI}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_spring_index_2015 OWNER TO postgres;

--
-- Name: prism_spring_index_2015_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_spring_index_2015_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_spring_index_2015_rid_seq OWNER TO postgres;

--
-- Name: prism_spring_index_2015_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_spring_index_2015_rid_seq OWNED BY prism_spring_index_2015.rid;


--
-- Name: prism_spring_index_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_spring_index_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_spring_index_rid_seq OWNER TO postgres;

--
-- Name: prism_spring_index_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_spring_index_rid_seq OWNED BY prism_spring_index.rid;


--
-- Name: prism_tmax_1981; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1981 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1981 OWNER TO postgres;

--
-- Name: prism_tmax_1981_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1981_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1981_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1981_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1981_rid_seq OWNED BY prism_tmax_1981.rid;


--
-- Name: prism_tmax_1982; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1982 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1982 OWNER TO postgres;

--
-- Name: prism_tmax_1982_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1982_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1982_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1982_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1982_rid_seq OWNED BY prism_tmax_1982.rid;


--
-- Name: prism_tmax_1983; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1983 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1983 OWNER TO postgres;

--
-- Name: prism_tmax_1983_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1983_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1983_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1983_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1983_rid_seq OWNED BY prism_tmax_1983.rid;


--
-- Name: prism_tmax_1984; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1984 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1984 OWNER TO postgres;

--
-- Name: prism_tmax_1984_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1984_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1984_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1984_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1984_rid_seq OWNED BY prism_tmax_1984.rid;


--
-- Name: prism_tmax_1985; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1985 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1985 OWNER TO postgres;

--
-- Name: prism_tmax_1985_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1985_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1985_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1985_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1985_rid_seq OWNED BY prism_tmax_1985.rid;


--
-- Name: prism_tmax_1986; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1986 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE00000000884740010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1986 OWNER TO postgres;

--
-- Name: prism_tmax_1986_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1986_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1986_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1986_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1986_rid_seq OWNED BY prism_tmax_1986.rid;


--
-- Name: prism_tmax_1987; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1987 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1987 OWNER TO postgres;

--
-- Name: prism_tmax_1987_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1987_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1987_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1987_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1987_rid_seq OWNED BY prism_tmax_1987.rid;


--
-- Name: prism_tmax_1988; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1988 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1988 OWNER TO postgres;

--
-- Name: prism_tmax_1988_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1988_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1988_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1988_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1988_rid_seq OWNED BY prism_tmax_1988.rid;


--
-- Name: prism_tmax_1989; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1989 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1989 OWNER TO postgres;

--
-- Name: prism_tmax_1989_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1989_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1989_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1989_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1989_rid_seq OWNED BY prism_tmax_1989.rid;


--
-- Name: prism_tmax_1990; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1990 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1990 OWNER TO postgres;

--
-- Name: prism_tmax_1990_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1990_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1990_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1990_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1990_rid_seq OWNED BY prism_tmax_1990.rid;


--
-- Name: prism_tmax_1991; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1991 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1991 OWNER TO postgres;

--
-- Name: prism_tmax_1991_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1991_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1991_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1991_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1991_rid_seq OWNED BY prism_tmax_1991.rid;


--
-- Name: prism_tmax_1992; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1992 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1992 OWNER TO postgres;

--
-- Name: prism_tmax_1992_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1992_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1992_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1992_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1992_rid_seq OWNED BY prism_tmax_1992.rid;


--
-- Name: prism_tmax_1993; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1993 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1993 OWNER TO postgres;

--
-- Name: prism_tmax_1993_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1993_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1993_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1993_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1993_rid_seq OWNED BY prism_tmax_1993.rid;


--
-- Name: prism_tmax_1994; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1994 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1994 OWNER TO postgres;

--
-- Name: prism_tmax_1994_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1994_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1994_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1994_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1994_rid_seq OWNED BY prism_tmax_1994.rid;


--
-- Name: prism_tmax_1995; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1995 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1995 OWNER TO postgres;

--
-- Name: prism_tmax_1995_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1995_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1995_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1995_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1995_rid_seq OWNED BY prism_tmax_1995.rid;


--
-- Name: prism_tmax_1996; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1996 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1996 OWNER TO postgres;

--
-- Name: prism_tmax_1996_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1996_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1996_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1996_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1996_rid_seq OWNED BY prism_tmax_1996.rid;


--
-- Name: prism_tmax_1997; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1997 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1997 OWNER TO postgres;

--
-- Name: prism_tmax_1997_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1997_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1997_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1997_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1997_rid_seq OWNED BY prism_tmax_1997.rid;


--
-- Name: prism_tmax_1998; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1998 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1998 OWNER TO postgres;

--
-- Name: prism_tmax_1998_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmax_1998_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmax_1998_rid_seq OWNER TO postgres;

--
-- Name: prism_tmax_1998_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmax_1998_rid_seq OWNED BY prism_tmax_1998.rid;


--
-- Name: prism_tmax_1999; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_1999 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_1999 OWNER TO postgres;

--
-- Name: prism_tmax_2000; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2000 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2000 OWNER TO postgres;

--
-- Name: prism_tmax_2001; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2001 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE00000000884740010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2001 OWNER TO postgres;

--
-- Name: prism_tmax_2002; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2002 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2002 OWNER TO postgres;

--
-- Name: prism_tmax_2003; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2003 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2003 OWNER TO postgres;

--
-- Name: prism_tmax_2004; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2004 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2004 OWNER TO postgres;

--
-- Name: prism_tmax_2005; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2005 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2005 OWNER TO postgres;

--
-- Name: prism_tmax_2006; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2006 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2006 OWNER TO postgres;

--
-- Name: prism_tmax_2007; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2007 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2007 OWNER TO postgres;

--
-- Name: prism_tmax_2008; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2008 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2008 OWNER TO postgres;

--
-- Name: prism_tmax_2009; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2009 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2009 OWNER TO postgres;

--
-- Name: prism_tmax_2010; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2010 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2010 OWNER TO postgres;

--
-- Name: prism_tmax_2011; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2011 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2011 OWNER TO postgres;

--
-- Name: prism_tmax_2012; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2012 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2012 OWNER TO postgres;

--
-- Name: prism_tmax_2013; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2013 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2013 OWNER TO postgres;

--
-- Name: prism_tmax_2014; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2014 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2014 OWNER TO postgres;

--
-- Name: prism_tmax_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmax_2015 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmax_2015 OWNER TO postgres;

--
-- Name: prism_tmin_1981; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1981 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A84440010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE000000008847400103000000010000000F0000001E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE000000001846400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE0000000018464001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1981 OWNER TO postgres;

--
-- Name: prism_tmin_1981_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1981_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1981_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1981_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1981_rid_seq OWNED BY prism_tmin_1981.rid;


--
-- Name: prism_tmin_1982; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1982 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1982 OWNER TO postgres;

--
-- Name: prism_tmin_1982_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1982_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1982_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1982_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1982_rid_seq OWNED BY prism_tmin_1982.rid;


--
-- Name: prism_tmin_1983; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1983 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A84440010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE000000008847400103000000010000000F0000001E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE000000001846400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE0000000018464001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A40010300000001000000150000007A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1983 OWNER TO postgres;

--
-- Name: prism_tmin_1983_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1983_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1983_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1983_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1983_rid_seq OWNED BY prism_tmin_1983.rid;


--
-- Name: prism_tmin_1984; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1984 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1984 OWNER TO postgres;

--
-- Name: prism_tmin_1984_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1984_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1984_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1984_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1984_rid_seq OWNED BY prism_tmin_1984.rid;


--
-- Name: prism_tmin_1985; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1985 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1985 OWNER TO postgres;

--
-- Name: prism_tmin_1985_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1985_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1985_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1985_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1985_rid_seq OWNED BY prism_tmin_1985.rid;


--
-- Name: prism_tmin_1986; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1986 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A844400103000000010000000F0000009E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000D000000FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1986 OWNER TO postgres;

--
-- Name: prism_tmin_1986_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1986_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1986_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1986_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1986_rid_seq OWNED BY prism_tmin_1986.rid;


--
-- Name: prism_tmin_1987; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1987 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1987 OWNER TO postgres;

--
-- Name: prism_tmin_1987_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1987_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1987_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1987_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1987_rid_seq OWNED BY prism_tmin_1987.rid;


--
-- Name: prism_tmin_1988; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1988 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A844400103000000010000000F0000009E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000D000000FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1988 OWNER TO postgres;

--
-- Name: prism_tmin_1988_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1988_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1988_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1988_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1988_rid_seq OWNED BY prism_tmin_1988.rid;


--
-- Name: prism_tmin_1989; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1989 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1989 OWNER TO postgres;

--
-- Name: prism_tmin_1989_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1989_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1989_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1989_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1989_rid_seq OWNED BY prism_tmin_1989.rid;


--
-- Name: prism_tmin_1990; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1990 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1990 OWNER TO postgres;

--
-- Name: prism_tmin_1990_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1990_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1990_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1990_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1990_rid_seq OWNED BY prism_tmin_1990.rid;


--
-- Name: prism_tmin_1991; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1991 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1991 OWNER TO postgres;

--
-- Name: prism_tmin_1991_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1991_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1991_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1991_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1991_rid_seq OWNED BY prism_tmin_1991.rid;


--
-- Name: prism_tmin_1992; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1992 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1992 OWNER TO postgres;

--
-- Name: prism_tmin_1992_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1992_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1992_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1992_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1992_rid_seq OWNED BY prism_tmin_1992.rid;


--
-- Name: prism_tmin_1993; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1993 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1993 OWNER TO postgres;

--
-- Name: prism_tmin_1993_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1993_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1993_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1993_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1993_rid_seq OWNED BY prism_tmin_1993.rid;


--
-- Name: prism_tmin_1994; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1994 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1994 OWNER TO postgres;

--
-- Name: prism_tmin_1994_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1994_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1994_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1994_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1994_rid_seq OWNED BY prism_tmin_1994.rid;


--
-- Name: prism_tmin_1995; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1995 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1995 OWNER TO postgres;

--
-- Name: prism_tmin_1995_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1995_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1995_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1995_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1995_rid_seq OWNED BY prism_tmin_1995.rid;


--
-- Name: prism_tmin_1996; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1996 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1996 OWNER TO postgres;

--
-- Name: prism_tmin_1996_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1996_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1996_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1996_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1996_rid_seq OWNED BY prism_tmin_1996.rid;


--
-- Name: prism_tmin_1997; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1997 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40010300000001000000150000000C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1997 OWNER TO postgres;

--
-- Name: prism_tmin_1997_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1997_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1997_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1997_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1997_rid_seq OWNED BY prism_tmin_1997.rid;


--
-- Name: prism_tmin_1998; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1998 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1998 OWNER TO postgres;

--
-- Name: prism_tmin_1998_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prism_tmin_1998_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prism_tmin_1998_rid_seq OWNER TO postgres;

--
-- Name: prism_tmin_1998_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE prism_tmin_1998_rid_seq OWNED BY prism_tmin_1998.rid;


--
-- Name: prism_tmin_1999; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_1999 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_1999 OWNER TO postgres;

--
-- Name: prism_tmin_2000; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2000 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A84440010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE000000008847400103000000010000000F0000001E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE000000001846400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE0000000018464001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2000 OWNER TO postgres;

--
-- Name: prism_tmin_2001; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2001 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2001 OWNER TO postgres;

--
-- Name: prism_tmin_2002; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2002 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2002 OWNER TO postgres;

--
-- Name: prism_tmin_2003; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2003 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2003 OWNER TO postgres;

--
-- Name: prism_tmin_2004; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2004 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A844400103000000010000000F0000009E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000D000000FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2004 OWNER TO postgres;

--
-- Name: prism_tmin_2005; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2005 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC07700000000D03D403155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2005 OWNER TO postgres;

--
-- Name: prism_tmin_2006; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2006 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2006 OWNER TO postgres;

--
-- Name: prism_tmin_2007; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2007 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2007 OWNER TO postgres;

--
-- Name: prism_tmin_2008; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2008 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A84440010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE000000008847400103000000010000000F0000001E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE000000001846400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE0000000018464001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2008 OWNER TO postgres;

--
-- Name: prism_tmin_2009; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2009 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2009 OWNER TO postgres;

--
-- Name: prism_tmin_2010; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2010 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2010 OWNER TO postgres;

--
-- Name: prism_tmin_2011; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2011 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2011 OWNER TO postgres;

--
-- Name: prism_tmin_2012; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2012 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40010300000001000000150000006854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2012 OWNER TO postgres;

--
-- Name: prism_tmin_2013; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2013 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2013 OWNER TO postgres;

--
-- Name: prism_tmin_2014; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2014 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2014 OWNER TO postgres;

--
-- Name: prism_tmin_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE prism_tmin_2015 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A844400103000000010000000F0000009E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D000000003843400103000000010000000D000000E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A84440010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE000000008847400103000000010000000F0000001E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE000000001846400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE0000000018464001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000000D000000E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000001500000061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D40010300000001000000150000006854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A400103000000010000000F000000C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D4001030000000100000013000000E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D40E854555555615AC03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE prism_tmin_2015 OWNER TO postgres;

--
-- Name: six_30yr_average_bloom; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_30yr_average_bloom (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    doy integer
);


ALTER TABLE six_30yr_average_bloom OWNER TO postgres;

--
-- Name: six_30yr_average_bloom_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_30yr_average_bloom_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_30yr_average_bloom_fid_seq OWNER TO postgres;

--
-- Name: six_30yr_average_bloom_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_30yr_average_bloom_fid_seq OWNED BY six_30yr_average_bloom.fid;


--
-- Name: six_30yr_average_leaf; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_30yr_average_leaf (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    doy integer
);


ALTER TABLE six_30yr_average_leaf OWNER TO postgres;

--
-- Name: six_30yr_average_leaf_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_30yr_average_leaf_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_30yr_average_leaf_fid_seq OWNER TO postgres;

--
-- Name: six_30yr_average_leaf_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_30yr_average_leaf_fid_seq OWNED BY six_30yr_average_leaf.fid;


--
-- Name: six_anomaly; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_anomaly (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    plant text,
    phenophase text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFB18A315555415FC00300000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE six_anomaly OWNER TO postgres;

--
-- Name: six_anomaly_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_anomaly_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_anomaly_rid_seq OWNER TO postgres;

--
-- Name: six_anomaly_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_anomaly_rid_seq OWNED BY six_anomaly.rid;


--
-- Name: six_arnoldred_bloom_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_arnoldred_bloom_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_arnoldred_bloom_ncep OWNER TO postgres;

--
-- Name: six_arnoldred_bloom_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_arnoldred_bloom_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_arnoldred_bloom_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_arnoldred_bloom_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_arnoldred_bloom_ncep_fid_seq OWNED BY six_arnoldred_bloom_ncep.fid;


--
-- Name: six_arnoldred_bloom_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_arnoldred_bloom_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_arnoldred_bloom_prism OWNER TO postgres;

--
-- Name: six_arnoldred_bloom_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_arnoldred_bloom_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_arnoldred_bloom_prism_fid_seq OWNER TO postgres;

--
-- Name: six_arnoldred_bloom_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_arnoldred_bloom_prism_fid_seq OWNED BY six_arnoldred_bloom_prism.fid;


--
-- Name: six_arnoldred_leaf_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_arnoldred_leaf_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_arnoldred_leaf_ncep OWNER TO postgres;

--
-- Name: six_arnoldred_leaf_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_arnoldred_leaf_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_arnoldred_leaf_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_arnoldred_leaf_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_arnoldred_leaf_ncep_fid_seq OWNED BY six_arnoldred_leaf_ncep.fid;


--
-- Name: six_arnoldred_leaf_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_arnoldred_leaf_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_arnoldred_leaf_prism OWNER TO postgres;

--
-- Name: six_arnoldred_leaf_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_arnoldred_leaf_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_arnoldred_leaf_prism_fid_seq OWNER TO postgres;

--
-- Name: six_arnoldred_leaf_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_arnoldred_leaf_prism_fid_seq OWNED BY six_arnoldred_leaf_prism.fid;


--
-- Name: six_average_bloom_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_average_bloom_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_average_bloom_ncep OWNER TO postgres;

--
-- Name: six_average_bloom_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_average_bloom_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_average_bloom_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_average_bloom_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_average_bloom_ncep_fid_seq OWNED BY six_average_bloom_ncep.fid;


--
-- Name: six_average_bloom_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_average_bloom_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_average_bloom_prism OWNER TO postgres;

--
-- Name: six_average_bloom_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_average_bloom_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_average_bloom_prism_fid_seq OWNER TO postgres;

--
-- Name: six_average_bloom_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_average_bloom_prism_fid_seq OWNED BY six_average_bloom_prism.fid;


--
-- Name: six_average_leaf_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_average_leaf_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_average_leaf_ncep OWNER TO postgres;

--
-- Name: six_average_leaf_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_average_leaf_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_average_leaf_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_average_leaf_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_average_leaf_ncep_fid_seq OWNED BY six_average_leaf_ncep.fid;


--
-- Name: six_average_leaf_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_average_leaf_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_average_leaf_prism OWNER TO postgres;

--
-- Name: six_average_leaf_prism_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_average_leaf_prism_2015 (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_average_leaf_prism_2015 OWNER TO postgres;

--
-- Name: six_average_leaf_prism_2015_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_average_leaf_prism_2015_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_average_leaf_prism_2015_fid_seq OWNER TO postgres;

--
-- Name: six_average_leaf_prism_2015_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_average_leaf_prism_2015_fid_seq OWNED BY six_average_leaf_prism_2015.fid;


--
-- Name: six_average_leaf_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_average_leaf_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_average_leaf_prism_fid_seq OWNER TO postgres;

--
-- Name: six_average_leaf_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_average_leaf_prism_fid_seq OWNED BY six_average_leaf_prism.fid;


--
-- Name: six_bloom_anomaly; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_bloom_anomaly (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_bloom_anomaly OWNER TO postgres;

--
-- Name: six_bloom_anomaly_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_bloom_anomaly_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_bloom_anomaly_fid_seq OWNER TO postgres;

--
-- Name: six_bloom_anomaly_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_bloom_anomaly_fid_seq OWNED BY six_bloom_anomaly.fid;


--
-- Name: six_leaf_anomaly; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_leaf_anomaly (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_leaf_anomaly OWNER TO postgres;

--
-- Name: six_leaf_anomaly_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_leaf_anomaly_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_leaf_anomaly_fid_seq OWNER TO postgres;

--
-- Name: six_leaf_anomaly_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_leaf_anomaly_fid_seq OWNED BY six_leaf_anomaly.fid;


--
-- Name: six_lilac_bloom_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_lilac_bloom_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_lilac_bloom_ncep OWNER TO postgres;

--
-- Name: six_lilac_bloom_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_lilac_bloom_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_lilac_bloom_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_lilac_bloom_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_lilac_bloom_ncep_fid_seq OWNED BY six_lilac_bloom_ncep.fid;


--
-- Name: six_lilac_bloom_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_lilac_bloom_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_lilac_bloom_prism OWNER TO postgres;

--
-- Name: six_lilac_bloom_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_lilac_bloom_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_lilac_bloom_prism_fid_seq OWNER TO postgres;

--
-- Name: six_lilac_bloom_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_lilac_bloom_prism_fid_seq OWNED BY six_lilac_bloom_prism.fid;


--
-- Name: six_lilac_leaf_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_lilac_leaf_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_lilac_leaf_ncep OWNER TO postgres;

--
-- Name: six_lilac_leaf_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_lilac_leaf_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_lilac_leaf_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_lilac_leaf_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_lilac_leaf_ncep_fid_seq OWNED BY six_lilac_leaf_ncep.fid;


--
-- Name: six_lilac_leaf_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_lilac_leaf_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_lilac_leaf_prism OWNER TO postgres;

--
-- Name: six_lilac_leaf_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_lilac_leaf_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_lilac_leaf_prism_fid_seq OWNER TO postgres;

--
-- Name: six_lilac_leaf_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_lilac_leaf_prism_fid_seq OWNED BY six_lilac_leaf_prism.fid;


--
-- Name: six_zabelli_bloom_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_zabelli_bloom_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_zabelli_bloom_ncep OWNER TO postgres;

--
-- Name: six_zabelli_bloom_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_zabelli_bloom_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_zabelli_bloom_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_zabelli_bloom_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_zabelli_bloom_ncep_fid_seq OWNED BY six_zabelli_bloom_ncep.fid;


--
-- Name: six_zabelli_bloom_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_zabelli_bloom_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_zabelli_bloom_prism OWNER TO postgres;

--
-- Name: six_zabelli_bloom_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_zabelli_bloom_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_zabelli_bloom_prism_fid_seq OWNER TO postgres;

--
-- Name: six_zabelli_bloom_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_zabelli_bloom_prism_fid_seq OWNED BY six_zabelli_bloom_prism.fid;


--
-- Name: six_zabelli_leaf_ncep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_zabelli_leaf_ncep (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_zabelli_leaf_ncep OWNER TO postgres;

--
-- Name: six_zabelli_leaf_ncep_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_zabelli_leaf_ncep_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_zabelli_leaf_ncep_fid_seq OWNER TO postgres;

--
-- Name: six_zabelli_leaf_ncep_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_zabelli_leaf_ncep_fid_seq OWNED BY six_zabelli_leaf_ncep.fid;


--
-- Name: six_zabelli_leaf_prism; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE six_zabelli_leaf_prism (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE six_zabelli_leaf_prism OWNER TO postgres;

--
-- Name: six_zabelli_leaf_prism_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE six_zabelli_leaf_prism_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE six_zabelli_leaf_prism_fid_seq OWNER TO postgres;

--
-- Name: six_zabelli_leaf_prism_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE six_zabelli_leaf_prism_fid_seq OWNED BY six_zabelli_leaf_prism.fid;


--
-- Name: spring_index; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spring_index (
    rid integer NOT NULL,
    rast raster,
    year smallint,
    plant text,
    phenophase text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = 69)),
    CONSTRAINT enforce_max_extent_rast CHECK (st_coveredby(st_convexhull(rast), '0106000020AD10000012000000010300000001000000090000003155555555A15DC0BD00000000A844403155555555A15DC09D000000003843404355555555715EC09D000000003843405555555555415FC09D000000003843405555555555415FC0BD00000000A844405555555555415FC0DD000000001846404355555555715EC0DD000000001846403155555555A15DC0DD000000001846403155555555A15DC0BD00000000A844400103000000010000000F0000008C545555555156C0DD000000001846407A545555558155C0DD000000001846406854555555B154C0DD000000001846406854555555B154C0BD00000000A844406854555555B154C09D000000003843407A545555558155C09D000000003843408C545555555156C09D000000003843409E545555552157C09D00000000384340B054555555F157C09D00000000384340C254555555C158C09D00000000384340C254555555C158C0BD00000000A84440C254555555C158C0DD00000000184640B054555555F157C0DD000000001846409E545555552157C0DD000000001846408C545555555156C0DD000000001846400103000000010000000D0000001E55555555D15CC0DD000000001846400C55555555015CC0DD00000000184640FA54555555315BC0DD00000000184640E854555555615AC0DD00000000184640E854555555615AC0BD00000000A84440E854555555615AC09D00000000384340FA54555555315BC09D000000003843400C55555555015CC09D000000003843401E55555555D15CC09D000000003843403055555555A15DC09D000000003843403055555555A15DC0BD00000000A844403055555555A15DC0DD000000001846401E55555555D15CC0DD000000001846400103000000010000000F00000061A9AAAAAA9E50C0BD00000000A8444061A9AAAAAA9E50C09D000000003843400C54555555A150C09D000000003843401E545555557151C09D0000000038434030545555554152C09D0000000038434042545555551153C09D000000003843405454555555E153C09D000000003843405454555555E153C0BD00000000A844405454555555E153C0DD0000000018464042545555551153C0DD0000000018464030545555554152C0DD000000001846401E545555557151C0DD000000001846400C54555555A150C0DD0000000018464061A9AAAAAA9E50C0DD0000000018464061A9AAAAAA9E50C0BD00000000A84440010300000001000000070000005554555555E153C0BD00000000A844405554555555E153C09D000000003843406754555555B154C09D000000003843406754555555B154C0BD00000000A844406754555555B154C0DD000000001846405554555555E153C0DD000000001846405554555555E153C0BD00000000A8444001030000000100000009000000C354555555C158C0BD00000000A84440C354555555C158C09D00000000384340D5545555559159C09D00000000384340E754555555615AC09D00000000384340E754555555615AC0BD00000000A84440E754555555615AC0DD00000000184640D5545555559159C0DD00000000184640C354555555C158C0DD00000000184640C354555555C158C0BD00000000A844400103000000010000000F00000061A9AAAAAA9E50C0FE0000000088474061A9AAAAAA9E50C0DE000000001846400C54555555A150C0DE000000001846401E545555557151C0DE0000000018464030545555554152C0DE0000000018464042545555551153C0DE000000001846405454555555E153C0DE000000001846405454555555E153C0FE000000008847405454555555E153C01E01000000F8484042545555551153C01E01000000F8484030545555554152C01E01000000F848401E545555557151C01E01000000F848400C54555555A150C01E01000000F8484061A9AAAAAA9E50C01E01000000F8484061A9AAAAAA9E50C0FE000000008847400103000000010000000F0000007A545555558155C0DE000000001846408C545555555156C0DE000000001846409E545555552157C0DE00000000184640B054555555F157C0DE00000000184640C254555555C158C0DE00000000184640C254555555C158C0FE00000000884740C254555555C158C01E01000000F84840B054555555F157C01E01000000F848409E545555552157C01E01000000F848408C545555555156C01E01000000F848407A545555558155C01E01000000F848406854555555B154C01E01000000F848406854555555B154C0FE000000008847406854555555B154C0DE000000001846407A545555558155C0DE00000000184640010300000001000000090000003155555555A15DC0FE000000008847403155555555A15DC0DE000000001846404355555555715EC0DE000000001846405555555555415FC0DE000000001846405555555555415FC0FE000000008847405555555555415FC01E01000000F848404355555555715EC01E01000000F848403155555555A15DC01E01000000F848403155555555A15DC0FE000000008847400103000000010000000D000000FA54555555315BC0DE000000001846400C55555555015CC0DE000000001846401E55555555D15CC0DE000000001846403055555555A15DC0DE000000001846403055555555A15DC0FE000000008847403055555555A15DC01E01000000F848401E55555555D15CC01E01000000F848400C55555555015CC01E01000000F84840FA54555555315BC01E01000000F84840E854555555615AC01E01000000F84840E854555555615AC0FE00000000884740E854555555615AC0DE00000000184640FA54555555315BC0DE00000000184640010300000001000000070000005554555555E153C0FE000000008847405554555555E153C0DE000000001846406754555555B154C0DE000000001846406754555555B154C0FE000000008847406754555555B154C01E01000000F848405554555555E153C01E01000000F848405554555555E153C0FE0000000088474001030000000100000009000000C354555555C158C0FE00000000884740C354555555C158C0DE00000000184640D5545555559159C0DE00000000184640E754555555615AC0DE00000000184640E754555555615AC0FE00000000884740E754555555615AC01E01000000F84840D5545555559159C01E01000000F84840C354555555C158C01E01000000F84840C354555555C158C0FE000000008847400103000000010000001500000061A9AAAAAA9E50C03600000000F03A4061A9AAAAAA9E50C0F5FFFFFFFF0F38400C54555555A150C0F5FFFFFFFF0F38401E545555557151C0F5FFFFFFFF0F384030545555554152C0F5FFFFFFFF0F384042545555551153C0F5FFFFFFFF0F38405454555555E153C0F5FFFFFFFF0F38405454555555E153C03600000000F03A405454555555E153C07700000000D03D405454555555E153C05C000000005840405454555555E153C07C00000000C841405454555555E153C09C0000000038434042545555551153C09C0000000038434030545555554152C09C000000003843401E545555557151C09C000000003843400C54555555A150C09C0000000038434061A9AAAAAA9E50C09C0000000038434061A9AAAAAA9E50C07C00000000C8414061A9AAAAAA9E50C05C0000000058404061A9AAAAAA9E50C07700000000D03D4061A9AAAAAA9E50C03600000000F03A400103000000010000000D0000005554555555E153C03600000000F03A405554555555E153C0F5FFFFFFFF0F38406754555555B154C0F5FFFFFFFF0F38406754555555B154C03600000000F03A406754555555B154C07700000000D03D406754555555B154C05C000000005840406754555555B154C07C00000000C841406754555555B154C09C000000003843405554555555E153C09C000000003843405554555555E153C07C00000000C841405554555555E153C05C000000005840405554555555E153C07700000000D03D405554555555E153C03600000000F03A40010300000001000000150000007A545555558155C0F5FFFFFFFF0F38408C545555555156C0F5FFFFFFFF0F38409E545555552157C0F5FFFFFFFF0F3840B054555555F157C0F5FFFFFFFF0F3840C254555555C158C0F5FFFFFFFF0F3840C254555555C158C03600000000F03A40C254555555C158C07700000000D03D40C254555555C158C05C00000000584040C254555555C158C07C00000000C84140C254555555C158C09C00000000384340B054555555F157C09C000000003843409E545555552157C09C000000003843408C545555555156C09C000000003843407A545555558155C09C000000003843406854555555B154C09C000000003843406854555555B154C07C00000000C841406854555555B154C05C000000005840406854555555B154C07700000000D03D406854555555B154C03600000000F03A406854555555B154C0F5FFFFFFFF0F38407A545555558155C0F5FFFFFFFF0F38400103000000010000000F0000003155555555A15DC03600000000F03A403155555555A15DC0F5FFFFFFFF0F38404355555555715EC0F5FFFFFFFF0F38405555555555415FC0F5FFFFFFFF0F38405555555555415FC03600000000F03A405555555555415FC07700000000D03D405555555555415FC05C000000005840405555555555415FC07C00000000C841405555555555415FC09C000000003843404355555555715EC09C000000003843403155555555A15DC09C000000003843403155555555A15DC07C00000000C841403155555555A15DC05C000000005840403155555555A15DC07700000000D03D403155555555A15DC03600000000F03A4001030000000100000013000000E854555555615AC07700000000D03D40E854555555615AC03600000000F03A40E854555555615AC0F5FFFFFFFF0F3840FA54555555315BC0F5FFFFFFFF0F38400C55555555015CC0F5FFFFFFFF0F38401E55555555D15CC0F5FFFFFFFF0F38403055555555A15DC0F5FFFFFFFF0F38403055555555A15DC03600000000F03A403055555555A15DC07700000000D03D403055555555A15DC05C000000005840403055555555A15DC07C00000000C841403055555555A15DC09C000000003843401E55555555D15CC09C000000003843400C55555555015CC09C00000000384340FA54555555315BC09C00000000384340E854555555615AC09C00000000384340E854555555615AC07C00000000C84140E854555555615AC05C00000000584040E854555555615AC07700000000D03D400103000000010000000F000000C354555555C158C03600000000F03A40C354555555C158C0F5FFFFFFFF0F3840D5545555559159C0F5FFFFFFFF0F3840E754555555615AC0F5FFFFFFFF0F3840E754555555615AC03600000000F03A40E754555555615AC07700000000D03D40E754555555615AC05C00000000584040E754555555615AC07C00000000C84140E754555555615AC09C00000000384340D5545555559159C09C00000000384340C354555555C158C09C00000000384340C354555555C158C07C00000000C84140C354555555C158C05C00000000584040C354555555C158C07700000000D03D40C354555555C158C03600000000F03A40'::geometry)),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{16BSI}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000365755555555A53F365755555555A5BF5555555555415FC01E01000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.04166666666667::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.04166666666667)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[78, 1])))
);


ALTER TABLE spring_index OWNER TO postgres;

--
-- Name: spring_index_2012; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW spring_index_2012 AS
 SELECT spring_index.rast
   FROM spring_index
  WHERE (spring_index.year = 2012);


ALTER TABLE spring_index_2012 OWNER TO postgres;

--
-- Name: spring_index_2013; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW spring_index_2013 AS
 SELECT spring_index.rast
   FROM spring_index
  WHERE (spring_index.year = 2013);


ALTER TABLE spring_index_2013 OWNER TO postgres;

--
-- Name: spring_index_2014; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW spring_index_2014 AS
 SELECT spring_index.rast
   FROM spring_index
  WHERE (spring_index.year = 2014);


ALTER TABLE spring_index_2014 OWNER TO postgres;

--
-- Name: spring_index_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE spring_index_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE spring_index_rid_seq OWNER TO postgres;

--
-- Name: spring_index_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE spring_index_rid_seq OWNED BY spring_index.rid;


--
-- Name: testing; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE testing (
    rid integer NOT NULL,
    rast raster,
    filename text
);


ALTER TABLE testing OWNER TO postgres;

--
-- Name: testing_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE testing_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE testing_rid_seq OWNER TO postgres;

--
-- Name: testing_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE testing_rid_seq OWNED BY testing.rid;


--
-- Name: tmax; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tmax (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE tmax OWNER TO postgres;

--
-- Name: tmax_1999_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_1999_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_1999_rid_seq OWNER TO postgres;

--
-- Name: tmax_1999_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_1999_rid_seq OWNED BY prism_tmax_1999.rid;


--
-- Name: tmax_2000_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2000_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2000_rid_seq OWNER TO postgres;

--
-- Name: tmax_2000_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2000_rid_seq OWNED BY prism_tmax_2000.rid;


--
-- Name: tmax_2001_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2001_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2001_rid_seq OWNER TO postgres;

--
-- Name: tmax_2001_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2001_rid_seq OWNED BY prism_tmax_2001.rid;


--
-- Name: tmax_2002_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2002_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2002_rid_seq OWNER TO postgres;

--
-- Name: tmax_2002_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2002_rid_seq OWNED BY prism_tmax_2002.rid;


--
-- Name: tmax_2003_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2003_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2003_rid_seq OWNER TO postgres;

--
-- Name: tmax_2003_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2003_rid_seq OWNED BY prism_tmax_2003.rid;


--
-- Name: tmax_2004_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2004_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2004_rid_seq OWNER TO postgres;

--
-- Name: tmax_2004_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2004_rid_seq OWNED BY prism_tmax_2004.rid;


--
-- Name: tmax_2005_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2005_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2005_rid_seq OWNER TO postgres;

--
-- Name: tmax_2005_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2005_rid_seq OWNED BY prism_tmax_2005.rid;


--
-- Name: tmax_2006_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2006_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2006_rid_seq OWNER TO postgres;

--
-- Name: tmax_2006_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2006_rid_seq OWNED BY prism_tmax_2006.rid;


--
-- Name: tmax_2007_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2007_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2007_rid_seq OWNER TO postgres;

--
-- Name: tmax_2007_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2007_rid_seq OWNED BY prism_tmax_2007.rid;


--
-- Name: tmax_2008_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2008_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2008_rid_seq OWNER TO postgres;

--
-- Name: tmax_2008_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2008_rid_seq OWNED BY prism_tmax_2008.rid;


--
-- Name: tmax_2009_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2009_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2009_rid_seq OWNER TO postgres;

--
-- Name: tmax_2009_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2009_rid_seq OWNED BY prism_tmax_2009.rid;


--
-- Name: tmax_2010_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2010_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2010_rid_seq OWNER TO postgres;

--
-- Name: tmax_2010_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2010_rid_seq OWNED BY prism_tmax_2010.rid;


--
-- Name: tmax_2011_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2011_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2011_rid_seq OWNER TO postgres;

--
-- Name: tmax_2011_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2011_rid_seq OWNED BY prism_tmax_2011.rid;


--
-- Name: tmax_2012_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2012_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2012_rid_seq OWNER TO postgres;

--
-- Name: tmax_2012_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2012_rid_seq OWNED BY prism_tmax_2012.rid;


--
-- Name: tmax_2013_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2013_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2013_rid_seq OWNER TO postgres;

--
-- Name: tmax_2013_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2013_rid_seq OWNED BY prism_tmax_2013.rid;


--
-- Name: tmax_2014_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2014_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2014_rid_seq OWNER TO postgres;

--
-- Name: tmax_2014_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2014_rid_seq OWNED BY prism_tmax_2014.rid;


--
-- Name: tmax_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tmax_2015 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE tmax_2015 OWNER TO postgres;

--
-- Name: tmax_2015_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2015_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2015_rid_seq OWNER TO postgres;

--
-- Name: tmax_2015_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2015_rid_seq OWNED BY prism_tmax_2015.rid;


--
-- Name: tmax_2015_rid_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2015_rid_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2015_rid_seq1 OWNER TO postgres;

--
-- Name: tmax_2015_rid_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2015_rid_seq1 OWNED BY tmax_2015.rid;


--
-- Name: tmax_2016; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tmax_2016 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE tmax_2016 OWNER TO postgres;

--
-- Name: tmax_2016_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_2016_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_2016_rid_seq OWNER TO postgres;

--
-- Name: tmax_2016_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_2016_rid_seq OWNED BY tmax_2016.rid;


--
-- Name: tmax_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmax_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmax_fid_seq OWNER TO postgres;

--
-- Name: tmax_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmax_fid_seq OWNED BY tmax.fid;


--
-- Name: tmin; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tmin (
    fid integer NOT NULL,
    the_geom geometry(Polygon,4269),
    location character varying(255),
    ingestion timestamp without time zone
);


ALTER TABLE tmin OWNER TO postgres;

--
-- Name: tmin_1999_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_1999_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_1999_rid_seq OWNER TO postgres;

--
-- Name: tmin_1999_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_1999_rid_seq OWNED BY prism_tmin_1999.rid;


--
-- Name: tmin_2000_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2000_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2000_rid_seq OWNER TO postgres;

--
-- Name: tmin_2000_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2000_rid_seq OWNED BY prism_tmin_2000.rid;


--
-- Name: tmin_2001_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2001_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2001_rid_seq OWNER TO postgres;

--
-- Name: tmin_2001_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2001_rid_seq OWNED BY prism_tmin_2001.rid;


--
-- Name: tmin_2002_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2002_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2002_rid_seq OWNER TO postgres;

--
-- Name: tmin_2002_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2002_rid_seq OWNED BY prism_tmin_2002.rid;


--
-- Name: tmin_2003_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2003_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2003_rid_seq OWNER TO postgres;

--
-- Name: tmin_2003_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2003_rid_seq OWNED BY prism_tmin_2003.rid;


--
-- Name: tmin_2004_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2004_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2004_rid_seq OWNER TO postgres;

--
-- Name: tmin_2004_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2004_rid_seq OWNED BY prism_tmin_2004.rid;


--
-- Name: tmin_2005_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2005_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2005_rid_seq OWNER TO postgres;

--
-- Name: tmin_2005_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2005_rid_seq OWNED BY prism_tmin_2005.rid;


--
-- Name: tmin_2006_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2006_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2006_rid_seq OWNER TO postgres;

--
-- Name: tmin_2006_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2006_rid_seq OWNED BY prism_tmin_2006.rid;


--
-- Name: tmin_2007_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2007_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2007_rid_seq OWNER TO postgres;

--
-- Name: tmin_2007_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2007_rid_seq OWNED BY prism_tmin_2007.rid;


--
-- Name: tmin_2008_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2008_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2008_rid_seq OWNER TO postgres;

--
-- Name: tmin_2008_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2008_rid_seq OWNED BY prism_tmin_2008.rid;


--
-- Name: tmin_2009_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2009_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2009_rid_seq OWNER TO postgres;

--
-- Name: tmin_2009_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2009_rid_seq OWNED BY prism_tmin_2009.rid;


--
-- Name: tmin_2010_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2010_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2010_rid_seq OWNER TO postgres;

--
-- Name: tmin_2010_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2010_rid_seq OWNED BY prism_tmin_2010.rid;


--
-- Name: tmin_2011_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2011_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2011_rid_seq OWNER TO postgres;

--
-- Name: tmin_2011_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2011_rid_seq OWNED BY prism_tmin_2011.rid;


--
-- Name: tmin_2012_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2012_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2012_rid_seq OWNER TO postgres;

--
-- Name: tmin_2012_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2012_rid_seq OWNED BY prism_tmin_2012.rid;


--
-- Name: tmin_2013_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2013_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2013_rid_seq OWNER TO postgres;

--
-- Name: tmin_2013_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2013_rid_seq OWNED BY prism_tmin_2013.rid;


--
-- Name: tmin_2014_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2014_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2014_rid_seq OWNER TO postgres;

--
-- Name: tmin_2014_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2014_rid_seq OWNED BY prism_tmin_2014.rid;


--
-- Name: tmin_2015; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tmin_2015 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE tmin_2015 OWNER TO postgres;

--
-- Name: tmin_2015_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2015_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2015_rid_seq OWNER TO postgres;

--
-- Name: tmin_2015_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2015_rid_seq OWNED BY prism_tmin_2015.rid;


--
-- Name: tmin_2015_rid_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2015_rid_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2015_rid_seq1 OWNER TO postgres;

--
-- Name: tmin_2015_rid_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2015_rid_seq1 OWNED BY tmin_2015.rid;


--
-- Name: tmin_2016; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tmin_2016 (
    rid integer NOT NULL,
    rast raster,
    filename text,
    rast_date date,
    dataset text,
    CONSTRAINT enforce_height_rast CHECK ((st_height(rast) = ANY (ARRAY[72, 4]))),
    CONSTRAINT enforce_nodata_values_rast CHECK (((_raster_constraint_nodata_values(rast))::numeric(16,10)[] = '{-9999}'::numeric(16,10)[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((_raster_constraint_out_db(rast) = '{t}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((_raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000BBFFDAF2D900973FDDE76E99989395BFBD8A315555415FC00000000000F8484000000000000000000000000000000000AD10000001000100'::raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((st_scalex(rast))::numeric(25,10) = 0.0224641851880276::numeric(25,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((st_scaley(rast))::numeric(25,10) = (-0.0210708469055375)::numeric(25,10))),
    CONSTRAINT enforce_srid_rast CHECK ((st_srid(rast) = 4269)),
    CONSTRAINT enforce_width_rast CHECK ((st_width(rast) = ANY (ARRAY[93, 2])))
);


ALTER TABLE tmin_2016 OWNER TO postgres;

--
-- Name: tmin_2016_rid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_2016_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_2016_rid_seq OWNER TO postgres;

--
-- Name: tmin_2016_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_2016_rid_seq OWNED BY tmin_2016.rid;


--
-- Name: tmin_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tmin_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmin_fid_seq OWNER TO postgres;

--
-- Name: tmin_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tmin_fid_seq OWNED BY tmin.fid;


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agdd ALTER COLUMN fid SET DEFAULT nextval('agdd_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agdd_2016 ALTER COLUMN rid SET DEFAULT nextval('agdd_2016_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agdd_50f ALTER COLUMN fid SET DEFAULT nextval('agdd_50f_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agdd_anomaly ALTER COLUMN fid SET DEFAULT nextval('agdd_anomaly_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agdd_anomaly_2016 ALTER COLUMN rid SET DEFAULT nextval('agdd_anomaly_2016_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agdd_anomaly_50f ALTER COLUMN fid SET DEFAULT nextval('agdd_anomaly_50f_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avg_agdd ALTER COLUMN fid SET DEFAULT nextval('avg_agdd_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avg_agdd_50f ALTER COLUMN fid SET DEFAULT nextval('avg_agdd_50f_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hourly_temp_2014 ALTER COLUMN rid SET DEFAULT nextval('hourly_temp_2014_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hourly_temp_2015 ALTER COLUMN rid SET DEFAULT nextval('hourly_temp_2015_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hourly_temp_2016 ALTER COLUMN rid SET DEFAULT nextval('hourly_temp_2016_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hourly_temp_uncertainty_2016 ALTER COLUMN rid SET DEFAULT nextval('hourly_temp_uncertainty_2016_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ncep_spring_index ALTER COLUMN rid SET DEFAULT nextval('ncep_spring_index_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ncep_spring_index_historic ALTER COLUMN rid SET DEFAULT nextval('ncep_spring_index_historic_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postgis_rasters ALTER COLUMN fid SET DEFAULT nextval('postgis_rasters_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_30yr_avg_agdd ALTER COLUMN rid SET DEFAULT nextval('prism_30yr_avg_agdd_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_30yr_avg_spring_index ALTER COLUMN rid SET DEFAULT nextval('prism_30yr_avg_spring_index_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_spring_index ALTER COLUMN rid SET DEFAULT nextval('prism_spring_index_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_spring_index_2015 ALTER COLUMN rid SET DEFAULT nextval('prism_spring_index_2015_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1981 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1981_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1982 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1982_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1983 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1983_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1984 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1984_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1985 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1985_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1986 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1986_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1987 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1987_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1988 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1988_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1989 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1989_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1990 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1990_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1991 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1991_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1992 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1992_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1993 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1993_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1994 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1994_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1995 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1995_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1996 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1996_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1997 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1997_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1998 ALTER COLUMN rid SET DEFAULT nextval('prism_tmax_1998_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_1999 ALTER COLUMN rid SET DEFAULT nextval('tmax_1999_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2000 ALTER COLUMN rid SET DEFAULT nextval('tmax_2000_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2001 ALTER COLUMN rid SET DEFAULT nextval('tmax_2001_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2002 ALTER COLUMN rid SET DEFAULT nextval('tmax_2002_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2003 ALTER COLUMN rid SET DEFAULT nextval('tmax_2003_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2004 ALTER COLUMN rid SET DEFAULT nextval('tmax_2004_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2005 ALTER COLUMN rid SET DEFAULT nextval('tmax_2005_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2006 ALTER COLUMN rid SET DEFAULT nextval('tmax_2006_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2007 ALTER COLUMN rid SET DEFAULT nextval('tmax_2007_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2008 ALTER COLUMN rid SET DEFAULT nextval('tmax_2008_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2009 ALTER COLUMN rid SET DEFAULT nextval('tmax_2009_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2010 ALTER COLUMN rid SET DEFAULT nextval('tmax_2010_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2011 ALTER COLUMN rid SET DEFAULT nextval('tmax_2011_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2012 ALTER COLUMN rid SET DEFAULT nextval('tmax_2012_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2013 ALTER COLUMN rid SET DEFAULT nextval('tmax_2013_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2014 ALTER COLUMN rid SET DEFAULT nextval('tmax_2014_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmax_2015 ALTER COLUMN rid SET DEFAULT nextval('tmax_2015_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1981 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1981_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1982 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1982_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1983 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1983_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1984 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1984_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1985 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1985_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1986 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1986_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1987 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1987_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1988 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1988_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1989 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1989_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1990 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1990_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1991 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1991_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1992 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1992_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1993 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1993_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1994 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1994_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1995 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1995_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1996 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1996_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1997 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1997_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1998 ALTER COLUMN rid SET DEFAULT nextval('prism_tmin_1998_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_1999 ALTER COLUMN rid SET DEFAULT nextval('tmin_1999_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2000 ALTER COLUMN rid SET DEFAULT nextval('tmin_2000_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2001 ALTER COLUMN rid SET DEFAULT nextval('tmin_2001_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2002 ALTER COLUMN rid SET DEFAULT nextval('tmin_2002_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2003 ALTER COLUMN rid SET DEFAULT nextval('tmin_2003_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2004 ALTER COLUMN rid SET DEFAULT nextval('tmin_2004_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2005 ALTER COLUMN rid SET DEFAULT nextval('tmin_2005_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2006 ALTER COLUMN rid SET DEFAULT nextval('tmin_2006_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2007 ALTER COLUMN rid SET DEFAULT nextval('tmin_2007_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2008 ALTER COLUMN rid SET DEFAULT nextval('tmin_2008_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2009 ALTER COLUMN rid SET DEFAULT nextval('tmin_2009_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2010 ALTER COLUMN rid SET DEFAULT nextval('tmin_2010_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2011 ALTER COLUMN rid SET DEFAULT nextval('tmin_2011_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2012 ALTER COLUMN rid SET DEFAULT nextval('tmin_2012_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2013 ALTER COLUMN rid SET DEFAULT nextval('tmin_2013_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2014 ALTER COLUMN rid SET DEFAULT nextval('tmin_2014_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prism_tmin_2015 ALTER COLUMN rid SET DEFAULT nextval('tmin_2015_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_30yr_average_bloom ALTER COLUMN fid SET DEFAULT nextval('six_30yr_average_bloom_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_30yr_average_leaf ALTER COLUMN fid SET DEFAULT nextval('six_30yr_average_leaf_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_anomaly ALTER COLUMN rid SET DEFAULT nextval('six_anomaly_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_arnoldred_bloom_ncep ALTER COLUMN fid SET DEFAULT nextval('six_arnoldred_bloom_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_arnoldred_bloom_prism ALTER COLUMN fid SET DEFAULT nextval('six_arnoldred_bloom_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_arnoldred_leaf_ncep ALTER COLUMN fid SET DEFAULT nextval('six_arnoldred_leaf_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_arnoldred_leaf_prism ALTER COLUMN fid SET DEFAULT nextval('six_arnoldred_leaf_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_average_bloom_ncep ALTER COLUMN fid SET DEFAULT nextval('six_average_bloom_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_average_bloom_prism ALTER COLUMN fid SET DEFAULT nextval('six_average_bloom_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_average_leaf_ncep ALTER COLUMN fid SET DEFAULT nextval('six_average_leaf_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_average_leaf_prism ALTER COLUMN fid SET DEFAULT nextval('six_average_leaf_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_average_leaf_prism_2015 ALTER COLUMN fid SET DEFAULT nextval('six_average_leaf_prism_2015_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_bloom_anomaly ALTER COLUMN fid SET DEFAULT nextval('six_bloom_anomaly_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_leaf_anomaly ALTER COLUMN fid SET DEFAULT nextval('six_leaf_anomaly_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_lilac_bloom_ncep ALTER COLUMN fid SET DEFAULT nextval('six_lilac_bloom_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_lilac_bloom_prism ALTER COLUMN fid SET DEFAULT nextval('six_lilac_bloom_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_lilac_leaf_ncep ALTER COLUMN fid SET DEFAULT nextval('six_lilac_leaf_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_lilac_leaf_prism ALTER COLUMN fid SET DEFAULT nextval('six_lilac_leaf_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_zabelli_bloom_ncep ALTER COLUMN fid SET DEFAULT nextval('six_zabelli_bloom_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_zabelli_bloom_prism ALTER COLUMN fid SET DEFAULT nextval('six_zabelli_bloom_prism_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_zabelli_leaf_ncep ALTER COLUMN fid SET DEFAULT nextval('six_zabelli_leaf_ncep_fid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY six_zabelli_leaf_prism ALTER COLUMN fid SET DEFAULT nextval('six_zabelli_leaf_prism_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spring_index ALTER COLUMN rid SET DEFAULT nextval('spring_index_rid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY testing ALTER COLUMN rid SET DEFAULT nextval('testing_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tmax ALTER COLUMN fid SET DEFAULT nextval('tmax_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tmax_2015 ALTER COLUMN rid SET DEFAULT nextval('tmax_2015_rid_seq1'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tmax_2016 ALTER COLUMN rid SET DEFAULT nextval('tmax_2016_rid_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tmin ALTER COLUMN fid SET DEFAULT nextval('tmin_fid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tmin_2015 ALTER COLUMN rid SET DEFAULT nextval('tmin_2015_rid_seq1'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tmin_2016 ALTER COLUMN rid SET DEFAULT nextval('tmin_2016_rid_seq'::regclass);


--
-- Name: agdd_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agdd_2016
    ADD CONSTRAINT agdd_2016_pkey PRIMARY KEY (rid);


--
-- Name: agdd_50f_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agdd_50f
    ADD CONSTRAINT agdd_50f_pkey PRIMARY KEY (fid);


--
-- Name: agdd_anomaly_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agdd_anomaly_2016
    ADD CONSTRAINT agdd_anomaly_2016_pkey PRIMARY KEY (rid);


--
-- Name: agdd_anomaly_50f_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agdd_anomaly_50f
    ADD CONSTRAINT agdd_anomaly_50f_pkey PRIMARY KEY (fid);


--
-- Name: agdd_anomaly_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agdd_anomaly
    ADD CONSTRAINT agdd_anomaly_pkey PRIMARY KEY (fid);


--
-- Name: agdd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agdd
    ADD CONSTRAINT agdd_pkey PRIMARY KEY (fid);


--
-- Name: avg_agdd_50f_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY avg_agdd_50f
    ADD CONSTRAINT avg_agdd_50f_pkey PRIMARY KEY (fid);


--
-- Name: avg_agdd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY avg_agdd
    ADD CONSTRAINT avg_agdd_pkey PRIMARY KEY (fid);


--
-- Name: hourly_temp_2014_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hourly_temp_2014
    ADD CONSTRAINT hourly_temp_2014_pkey PRIMARY KEY (rid);


--
-- Name: hourly_temp_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hourly_temp_2015
    ADD CONSTRAINT hourly_temp_2015_pkey PRIMARY KEY (rid);


--
-- Name: hourly_temp_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hourly_temp_2016
    ADD CONSTRAINT hourly_temp_2016_pkey PRIMARY KEY (rid);


--
-- Name: hourly_temp_uncertainty_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hourly_temp_uncertainty_2016
    ADD CONSTRAINT hourly_temp_uncertainty_2016_pkey PRIMARY KEY (rid);


--
-- Name: ncep_spring_index_historic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ncep_spring_index_historic
    ADD CONSTRAINT ncep_spring_index_historic_pkey PRIMARY KEY (rid);


--
-- Name: ncep_spring_index_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ncep_spring_index
    ADD CONSTRAINT ncep_spring_index_pkey PRIMARY KEY (rid);


--
-- Name: postgis_rasters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY postgis_rasters
    ADD CONSTRAINT postgis_rasters_pkey PRIMARY KEY (fid);


--
-- Name: prism_30yr_avg_agdd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_30yr_avg_agdd
    ADD CONSTRAINT prism_30yr_avg_agdd_pkey PRIMARY KEY (rid);


--
-- Name: prism_30yr_avg_spring_index_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_30yr_avg_spring_index
    ADD CONSTRAINT prism_30yr_avg_spring_index_pkey PRIMARY KEY (rid);


--
-- Name: prism_spring_index_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_spring_index_2015
    ADD CONSTRAINT prism_spring_index_2015_pkey PRIMARY KEY (rid);


--
-- Name: prism_spring_index_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_spring_index
    ADD CONSTRAINT prism_spring_index_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1981_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1981
    ADD CONSTRAINT prism_tmax_1981_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1982_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1982
    ADD CONSTRAINT prism_tmax_1982_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1983_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1983
    ADD CONSTRAINT prism_tmax_1983_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1984_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1984
    ADD CONSTRAINT prism_tmax_1984_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1985_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1985
    ADD CONSTRAINT prism_tmax_1985_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1986_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1986
    ADD CONSTRAINT prism_tmax_1986_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1987_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1987
    ADD CONSTRAINT prism_tmax_1987_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1988_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1988
    ADD CONSTRAINT prism_tmax_1988_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1989_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1989
    ADD CONSTRAINT prism_tmax_1989_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1990_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1990
    ADD CONSTRAINT prism_tmax_1990_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1991_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1991
    ADD CONSTRAINT prism_tmax_1991_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1992_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1992
    ADD CONSTRAINT prism_tmax_1992_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1993_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1993
    ADD CONSTRAINT prism_tmax_1993_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1994_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1994
    ADD CONSTRAINT prism_tmax_1994_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1995_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1995
    ADD CONSTRAINT prism_tmax_1995_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1996_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1996
    ADD CONSTRAINT prism_tmax_1996_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1997_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1997
    ADD CONSTRAINT prism_tmax_1997_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmax_1998_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1998
    ADD CONSTRAINT prism_tmax_1998_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1981_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1981
    ADD CONSTRAINT prism_tmin_1981_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1982_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1982
    ADD CONSTRAINT prism_tmin_1982_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1983_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1983
    ADD CONSTRAINT prism_tmin_1983_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1984_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1984
    ADD CONSTRAINT prism_tmin_1984_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1985_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1985
    ADD CONSTRAINT prism_tmin_1985_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1986_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1986
    ADD CONSTRAINT prism_tmin_1986_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1987_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1987
    ADD CONSTRAINT prism_tmin_1987_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1988_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1988
    ADD CONSTRAINT prism_tmin_1988_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1989_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1989
    ADD CONSTRAINT prism_tmin_1989_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1990_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1990
    ADD CONSTRAINT prism_tmin_1990_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1991_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1991
    ADD CONSTRAINT prism_tmin_1991_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1992_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1992
    ADD CONSTRAINT prism_tmin_1992_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1993_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1993
    ADD CONSTRAINT prism_tmin_1993_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1994_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1994
    ADD CONSTRAINT prism_tmin_1994_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1995_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1995
    ADD CONSTRAINT prism_tmin_1995_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1996_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1996
    ADD CONSTRAINT prism_tmin_1996_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1997_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1997
    ADD CONSTRAINT prism_tmin_1997_pkey PRIMARY KEY (rid);


--
-- Name: prism_tmin_1998_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1998
    ADD CONSTRAINT prism_tmin_1998_pkey PRIMARY KEY (rid);


--
-- Name: six_30yr_average_bloom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_30yr_average_bloom
    ADD CONSTRAINT six_30yr_average_bloom_pkey PRIMARY KEY (fid);


--
-- Name: six_30yr_average_leaf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_30yr_average_leaf
    ADD CONSTRAINT six_30yr_average_leaf_pkey PRIMARY KEY (fid);


--
-- Name: six_anomaly_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_anomaly
    ADD CONSTRAINT six_anomaly_pkey PRIMARY KEY (rid);


--
-- Name: six_arnoldred_bloom_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_arnoldred_bloom_ncep
    ADD CONSTRAINT six_arnoldred_bloom_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_arnoldred_bloom_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_arnoldred_bloom_prism
    ADD CONSTRAINT six_arnoldred_bloom_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_arnoldred_leaf_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_arnoldred_leaf_ncep
    ADD CONSTRAINT six_arnoldred_leaf_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_arnoldred_leaf_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_arnoldred_leaf_prism
    ADD CONSTRAINT six_arnoldred_leaf_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_average_bloom_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_average_bloom_ncep
    ADD CONSTRAINT six_average_bloom_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_average_bloom_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_average_bloom_prism
    ADD CONSTRAINT six_average_bloom_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_average_leaf_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_average_leaf_ncep
    ADD CONSTRAINT six_average_leaf_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_average_leaf_prism_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_average_leaf_prism_2015
    ADD CONSTRAINT six_average_leaf_prism_2015_pkey PRIMARY KEY (fid);


--
-- Name: six_average_leaf_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_average_leaf_prism
    ADD CONSTRAINT six_average_leaf_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_bloom_anomaly_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_bloom_anomaly
    ADD CONSTRAINT six_bloom_anomaly_pkey PRIMARY KEY (fid);


--
-- Name: six_leaf_anomaly_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_leaf_anomaly
    ADD CONSTRAINT six_leaf_anomaly_pkey PRIMARY KEY (fid);


--
-- Name: six_lilac_bloom_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_lilac_bloom_ncep
    ADD CONSTRAINT six_lilac_bloom_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_lilac_bloom_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_lilac_bloom_prism
    ADD CONSTRAINT six_lilac_bloom_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_lilac_leaf_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_lilac_leaf_ncep
    ADD CONSTRAINT six_lilac_leaf_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_lilac_leaf_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_lilac_leaf_prism
    ADD CONSTRAINT six_lilac_leaf_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_zabelli_bloom_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_zabelli_bloom_ncep
    ADD CONSTRAINT six_zabelli_bloom_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_zabelli_bloom_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_zabelli_bloom_prism
    ADD CONSTRAINT six_zabelli_bloom_prism_pkey PRIMARY KEY (fid);


--
-- Name: six_zabelli_leaf_ncep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_zabelli_leaf_ncep
    ADD CONSTRAINT six_zabelli_leaf_ncep_pkey PRIMARY KEY (fid);


--
-- Name: six_zabelli_leaf_prism_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY six_zabelli_leaf_prism
    ADD CONSTRAINT six_zabelli_leaf_prism_pkey PRIMARY KEY (fid);


--
-- Name: spring_index_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spring_index
    ADD CONSTRAINT spring_index_pkey PRIMARY KEY (rid);


--
-- Name: testing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testing
    ADD CONSTRAINT testing_pkey PRIMARY KEY (rid);


--
-- Name: tmax_1999_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_1999
    ADD CONSTRAINT tmax_1999_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2000_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2000
    ADD CONSTRAINT tmax_2000_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2001_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2001
    ADD CONSTRAINT tmax_2001_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2002_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2002
    ADD CONSTRAINT tmax_2002_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2003_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2003
    ADD CONSTRAINT tmax_2003_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2004_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2004
    ADD CONSTRAINT tmax_2004_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2005_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2005
    ADD CONSTRAINT tmax_2005_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2006_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2006
    ADD CONSTRAINT tmax_2006_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2007_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2007
    ADD CONSTRAINT tmax_2007_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2008_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2008
    ADD CONSTRAINT tmax_2008_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2009_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2009
    ADD CONSTRAINT tmax_2009_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2010_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2010
    ADD CONSTRAINT tmax_2010_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2011_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2011
    ADD CONSTRAINT tmax_2011_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2012_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2012
    ADD CONSTRAINT tmax_2012_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2013_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2013
    ADD CONSTRAINT tmax_2013_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2014_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2014
    ADD CONSTRAINT tmax_2014_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmax_2015
    ADD CONSTRAINT tmax_2015_pkey PRIMARY KEY (rid);


--
-- Name: tmax_2015_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tmax_2015
    ADD CONSTRAINT tmax_2015_pkey1 PRIMARY KEY (rid);


--
-- Name: tmax_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tmax_2016
    ADD CONSTRAINT tmax_2016_pkey PRIMARY KEY (rid);


--
-- Name: tmax_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tmax
    ADD CONSTRAINT tmax_pkey PRIMARY KEY (fid);


--
-- Name: tmin_1999_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_1999
    ADD CONSTRAINT tmin_1999_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2000_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2000
    ADD CONSTRAINT tmin_2000_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2001_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2001
    ADD CONSTRAINT tmin_2001_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2002_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2002
    ADD CONSTRAINT tmin_2002_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2003_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2003
    ADD CONSTRAINT tmin_2003_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2004_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2004
    ADD CONSTRAINT tmin_2004_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2005_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2005
    ADD CONSTRAINT tmin_2005_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2006_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2006
    ADD CONSTRAINT tmin_2006_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2007_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2007
    ADD CONSTRAINT tmin_2007_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2008_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2008
    ADD CONSTRAINT tmin_2008_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2009_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2009
    ADD CONSTRAINT tmin_2009_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2010_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2010
    ADD CONSTRAINT tmin_2010_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2011_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2011
    ADD CONSTRAINT tmin_2011_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2012_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2012
    ADD CONSTRAINT tmin_2012_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2013_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2013
    ADD CONSTRAINT tmin_2013_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2014_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2014
    ADD CONSTRAINT tmin_2014_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY prism_tmin_2015
    ADD CONSTRAINT tmin_2015_pkey PRIMARY KEY (rid);


--
-- Name: tmin_2015_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tmin_2015
    ADD CONSTRAINT tmin_2015_pkey1 PRIMARY KEY (rid);


--
-- Name: tmin_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tmin_2016
    ADD CONSTRAINT tmin_2016_pkey PRIMARY KEY (rid);


--
-- Name: tmin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tmin
    ADD CONSTRAINT tmin_pkey PRIMARY KEY (fid);


--
-- Name: agdd_2016_base_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_2016_base_idx ON agdd_2016 USING btree (base);


--
-- Name: agdd_2016_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_2016_filename_idx ON agdd_2016 USING btree (filename);


--
-- Name: agdd_2016_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_2016_rast_date_idx ON agdd_2016 USING btree (rast_date);


--
-- Name: agdd_2016_scale_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_2016_scale_idx ON agdd_2016 USING btree (scale);


--
-- Name: agdd_2016_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_2016_st_convexhull_idx ON agdd_2016 USING gist (st_convexhull(rast));


--
-- Name: agdd_anomaly_2016_base_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_anomaly_2016_base_idx ON agdd_anomaly_2016 USING btree (base);


--
-- Name: agdd_anomaly_2016_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_anomaly_2016_filename_idx ON agdd_anomaly_2016 USING btree (filename);


--
-- Name: agdd_anomaly_2016_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_anomaly_2016_rast_date_idx ON agdd_anomaly_2016 USING btree (rast_date);


--
-- Name: agdd_anomaly_2016_scale_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_anomaly_2016_scale_idx ON agdd_anomaly_2016 USING btree (scale);


--
-- Name: agdd_anomaly_2016_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX agdd_anomaly_2016_st_convexhull_idx ON agdd_anomaly_2016 USING gist (st_convexhull(rast));


--
-- Name: hourly_temp_2014_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2014_filename_idx ON hourly_temp_2014 USING btree (filename);


--
-- Name: hourly_temp_2014_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2014_rast_date_idx ON hourly_temp_2014 USING btree (rast_date);


--
-- Name: hourly_temp_2014_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2014_st_convexhull_idx ON hourly_temp_2014 USING gist (st_convexhull(rast));


--
-- Name: hourly_temp_2015_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2015_filename_idx ON hourly_temp_2015 USING btree (filename);


--
-- Name: hourly_temp_2015_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2015_rast_date_idx ON hourly_temp_2015 USING btree (rast_date);


--
-- Name: hourly_temp_2015_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2015_st_convexhull_idx ON hourly_temp_2015 USING gist (st_convexhull(rast));


--
-- Name: hourly_temp_2016_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2016_filename_idx ON hourly_temp_2016 USING btree (filename);


--
-- Name: hourly_temp_2016_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2016_rast_date_idx ON hourly_temp_2016 USING btree (rast_date);


--
-- Name: hourly_temp_2016_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_2016_st_convexhull_idx ON hourly_temp_2016 USING gist (st_convexhull(rast));


--
-- Name: hourly_temp_uncertainty_2016_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_uncertainty_2016_filename_idx ON hourly_temp_uncertainty_2016 USING btree (filename);


--
-- Name: hourly_temp_uncertainty_2016_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_uncertainty_2016_rast_date_idx ON hourly_temp_uncertainty_2016 USING btree (rast_date);


--
-- Name: hourly_temp_uncertainty_2016_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX hourly_temp_uncertainty_2016_st_convexhull_idx ON hourly_temp_uncertainty_2016 USING gist (st_convexhull(rast));


--
-- Name: ncep_spring_index_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ncep_spring_index_filename_idx ON ncep_spring_index USING btree (filename);


--
-- Name: ncep_spring_index_historic_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ncep_spring_index_historic_filename_idx ON ncep_spring_index_historic USING btree (filename);


--
-- Name: ncep_spring_index_historic_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ncep_spring_index_historic_rast_date_idx ON ncep_spring_index_historic USING btree (rast_date);


--
-- Name: ncep_spring_index_historic_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ncep_spring_index_historic_st_convexhull_idx ON ncep_spring_index_historic USING gist (st_convexhull(rast));


--
-- Name: ncep_spring_index_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ncep_spring_index_rast_date_idx ON ncep_spring_index USING btree (rast_date);


--
-- Name: ncep_spring_index_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ncep_spring_index_st_convexhull_idx ON ncep_spring_index USING gist (st_convexhull(rast));


--
-- Name: prism_30yr_avg_agdd_base_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_agdd_base_idx ON prism_30yr_avg_agdd USING btree (base);


--
-- Name: prism_30yr_avg_agdd_doy_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_agdd_doy_idx ON prism_30yr_avg_agdd USING btree (doy);


--
-- Name: prism_30yr_avg_agdd_scale_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_agdd_scale_idx ON prism_30yr_avg_agdd USING btree (scale);


--
-- Name: prism_30yr_avg_agdd_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_agdd_st_convexhull_idx ON prism_30yr_avg_agdd USING gist (st_convexhull(rast));


--
-- Name: prism_30yr_avg_spring_index_doy_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_spring_index_doy_idx ON prism_30yr_avg_spring_index USING btree (doy);


--
-- Name: prism_30yr_avg_spring_index_phenophase_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_spring_index_phenophase_idx ON prism_30yr_avg_spring_index USING btree (phenophase);


--
-- Name: prism_30yr_avg_spring_index_plant_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_spring_index_plant_idx ON prism_30yr_avg_spring_index USING btree (plant);


--
-- Name: prism_30yr_avg_spring_index_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_30yr_avg_spring_index_st_convexhull_idx ON prism_30yr_avg_spring_index USING gist (st_convexhull(rast));


--
-- Name: prism_spring_index_2015_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_spring_index_2015_filename_idx ON prism_spring_index_2015 USING btree (filename);


--
-- Name: prism_spring_index_2015_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_spring_index_2015_rast_date_idx ON prism_spring_index_2015 USING btree (rast_date);


--
-- Name: prism_spring_index_2015_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_spring_index_2015_st_convexhull_idx ON prism_spring_index_2015 USING gist (st_convexhull(rast));


--
-- Name: prism_spring_index_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_spring_index_filename_idx ON prism_spring_index USING btree (filename);


--
-- Name: prism_spring_index_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_spring_index_rast_date_idx ON prism_spring_index USING btree (rast_date);


--
-- Name: prism_spring_index_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_spring_index_st_convexhull_idx ON prism_spring_index USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1981_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1981_rast_date_idx ON prism_tmax_1981 USING btree (rast_date);


--
-- Name: prism_tmax_1981_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1981_st_convexhull_idx ON prism_tmax_1981 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1982_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1982_rast_date_idx ON prism_tmax_1982 USING btree (rast_date);


--
-- Name: prism_tmax_1982_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1982_st_convexhull_idx ON prism_tmax_1982 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1983_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1983_rast_date_idx ON prism_tmax_1983 USING btree (rast_date);


--
-- Name: prism_tmax_1983_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1983_st_convexhull_idx ON prism_tmax_1983 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1984_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1984_rast_date_idx ON prism_tmax_1984 USING btree (rast_date);


--
-- Name: prism_tmax_1984_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1984_st_convexhull_idx ON prism_tmax_1984 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1985_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1985_rast_date_idx ON prism_tmax_1985 USING btree (rast_date);


--
-- Name: prism_tmax_1985_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1985_st_convexhull_idx ON prism_tmax_1985 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1986_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1986_rast_date_idx ON prism_tmax_1986 USING btree (rast_date);


--
-- Name: prism_tmax_1986_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1986_st_convexhull_idx ON prism_tmax_1986 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1987_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1987_rast_date_idx ON prism_tmax_1987 USING btree (rast_date);


--
-- Name: prism_tmax_1987_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1987_st_convexhull_idx ON prism_tmax_1987 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1988_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1988_rast_date_idx ON prism_tmax_1988 USING btree (rast_date);


--
-- Name: prism_tmax_1988_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1988_st_convexhull_idx ON prism_tmax_1988 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1989_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1989_rast_date_idx ON prism_tmax_1989 USING btree (rast_date);


--
-- Name: prism_tmax_1989_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1989_st_convexhull_idx ON prism_tmax_1989 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1990_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1990_rast_date_idx ON prism_tmax_1990 USING btree (rast_date);


--
-- Name: prism_tmax_1990_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1990_st_convexhull_idx ON prism_tmax_1990 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1991_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1991_rast_date_idx ON prism_tmax_1991 USING btree (rast_date);


--
-- Name: prism_tmax_1991_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1991_st_convexhull_idx ON prism_tmax_1991 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1992_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1992_rast_date_idx ON prism_tmax_1992 USING btree (rast_date);


--
-- Name: prism_tmax_1992_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1992_st_convexhull_idx ON prism_tmax_1992 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1993_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1993_rast_date_idx ON prism_tmax_1993 USING btree (rast_date);


--
-- Name: prism_tmax_1993_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1993_st_convexhull_idx ON prism_tmax_1993 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1994_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1994_rast_date_idx ON prism_tmax_1994 USING btree (rast_date);


--
-- Name: prism_tmax_1994_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1994_st_convexhull_idx ON prism_tmax_1994 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1995_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1995_rast_date_idx ON prism_tmax_1995 USING btree (rast_date);


--
-- Name: prism_tmax_1995_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1995_st_convexhull_idx ON prism_tmax_1995 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1996_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1996_rast_date_idx ON prism_tmax_1996 USING btree (rast_date);


--
-- Name: prism_tmax_1996_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1996_st_convexhull_idx ON prism_tmax_1996 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1997_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1997_rast_date_idx ON prism_tmax_1997 USING btree (rast_date);


--
-- Name: prism_tmax_1997_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1997_st_convexhull_idx ON prism_tmax_1997 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1998_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1998_rast_date_idx ON prism_tmax_1998 USING btree (rast_date);


--
-- Name: prism_tmax_1998_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1998_st_convexhull_idx ON prism_tmax_1998 USING gist (st_convexhull(rast));


--
-- Name: prism_tmax_1999_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_1999_rast_date_idx ON prism_tmax_1999 USING btree (rast_date);


--
-- Name: prism_tmax_2000_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2000_rast_date_idx ON prism_tmax_2000 USING btree (rast_date);


--
-- Name: prism_tmax_2001_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2001_rast_date_idx ON prism_tmax_2001 USING btree (rast_date);


--
-- Name: prism_tmax_2002_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2002_rast_date_idx ON prism_tmax_2002 USING btree (rast_date);


--
-- Name: prism_tmax_2003_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2003_rast_date_idx ON prism_tmax_2003 USING btree (rast_date);


--
-- Name: prism_tmax_2004_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2004_rast_date_idx ON prism_tmax_2004 USING btree (rast_date);


--
-- Name: prism_tmax_2005_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2005_rast_date_idx ON prism_tmax_2005 USING btree (rast_date);


--
-- Name: prism_tmax_2006_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2006_rast_date_idx ON prism_tmax_2006 USING btree (rast_date);


--
-- Name: prism_tmax_2007_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2007_rast_date_idx ON prism_tmax_2007 USING btree (rast_date);


--
-- Name: prism_tmax_2008_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2008_rast_date_idx ON prism_tmax_2008 USING btree (rast_date);


--
-- Name: prism_tmax_2009_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2009_rast_date_idx ON prism_tmax_2009 USING btree (rast_date);


--
-- Name: prism_tmax_2010_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2010_rast_date_idx ON prism_tmax_2010 USING btree (rast_date);


--
-- Name: prism_tmax_2011_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2011_rast_date_idx ON prism_tmax_2011 USING btree (rast_date);


--
-- Name: prism_tmax_2012_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2012_rast_date_idx ON prism_tmax_2012 USING btree (rast_date);


--
-- Name: prism_tmax_2013_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2013_rast_date_idx ON prism_tmax_2013 USING btree (rast_date);


--
-- Name: prism_tmax_2014_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2014_rast_date_idx ON prism_tmax_2014 USING btree (rast_date);


--
-- Name: prism_tmax_2014_rast_date_idx1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2014_rast_date_idx1 ON prism_tmax_2014 USING btree (rast_date);


--
-- Name: prism_tmax_2015_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmax_2015_rast_date_idx ON prism_tmax_2015 USING btree (rast_date);


--
-- Name: prism_tmin_1981_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1981_rast_date_idx ON prism_tmin_1981 USING btree (rast_date);


--
-- Name: prism_tmin_1981_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1981_st_convexhull_idx ON prism_tmin_1981 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1982_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1982_rast_date_idx ON prism_tmin_1982 USING btree (rast_date);


--
-- Name: prism_tmin_1982_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1982_st_convexhull_idx ON prism_tmin_1982 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1983_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1983_rast_date_idx ON prism_tmin_1983 USING btree (rast_date);


--
-- Name: prism_tmin_1983_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1983_st_convexhull_idx ON prism_tmin_1983 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1984_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1984_rast_date_idx ON prism_tmin_1984 USING btree (rast_date);


--
-- Name: prism_tmin_1984_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1984_st_convexhull_idx ON prism_tmin_1984 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1985_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1985_rast_date_idx ON prism_tmin_1985 USING btree (rast_date);


--
-- Name: prism_tmin_1985_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1985_st_convexhull_idx ON prism_tmin_1985 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1986_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1986_rast_date_idx ON prism_tmin_1986 USING btree (rast_date);


--
-- Name: prism_tmin_1986_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1986_st_convexhull_idx ON prism_tmin_1986 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1987_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1987_rast_date_idx ON prism_tmin_1987 USING btree (rast_date);


--
-- Name: prism_tmin_1987_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1987_st_convexhull_idx ON prism_tmin_1987 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1988_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1988_rast_date_idx ON prism_tmin_1988 USING btree (rast_date);


--
-- Name: prism_tmin_1988_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1988_st_convexhull_idx ON prism_tmin_1988 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1989_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1989_rast_date_idx ON prism_tmin_1989 USING btree (rast_date);


--
-- Name: prism_tmin_1989_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1989_st_convexhull_idx ON prism_tmin_1989 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1990_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1990_rast_date_idx ON prism_tmin_1990 USING btree (rast_date);


--
-- Name: prism_tmin_1990_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1990_st_convexhull_idx ON prism_tmin_1990 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1991_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1991_rast_date_idx ON prism_tmin_1991 USING btree (rast_date);


--
-- Name: prism_tmin_1991_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1991_st_convexhull_idx ON prism_tmin_1991 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1992_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1992_rast_date_idx ON prism_tmin_1992 USING btree (rast_date);


--
-- Name: prism_tmin_1992_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1992_st_convexhull_idx ON prism_tmin_1992 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1993_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1993_rast_date_idx ON prism_tmin_1993 USING btree (rast_date);


--
-- Name: prism_tmin_1993_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1993_st_convexhull_idx ON prism_tmin_1993 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1994_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1994_rast_date_idx ON prism_tmin_1994 USING btree (rast_date);


--
-- Name: prism_tmin_1994_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1994_st_convexhull_idx ON prism_tmin_1994 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1995_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1995_rast_date_idx ON prism_tmin_1995 USING btree (rast_date);


--
-- Name: prism_tmin_1995_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1995_st_convexhull_idx ON prism_tmin_1995 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1996_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1996_rast_date_idx ON prism_tmin_1996 USING btree (rast_date);


--
-- Name: prism_tmin_1996_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1996_st_convexhull_idx ON prism_tmin_1996 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1997_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1997_rast_date_idx ON prism_tmin_1997 USING btree (rast_date);


--
-- Name: prism_tmin_1997_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1997_st_convexhull_idx ON prism_tmin_1997 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1998_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1998_rast_date_idx ON prism_tmin_1998 USING btree (rast_date);


--
-- Name: prism_tmin_1998_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1998_st_convexhull_idx ON prism_tmin_1998 USING gist (st_convexhull(rast));


--
-- Name: prism_tmin_1999_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_1999_rast_date_idx ON prism_tmin_1999 USING btree (rast_date);


--
-- Name: prism_tmin_2000_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2000_rast_date_idx ON prism_tmin_2000 USING btree (rast_date);


--
-- Name: prism_tmin_2001_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2001_rast_date_idx ON prism_tmin_2001 USING btree (rast_date);


--
-- Name: prism_tmin_2002_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2002_rast_date_idx ON prism_tmin_2002 USING btree (rast_date);


--
-- Name: prism_tmin_2003_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2003_rast_date_idx ON prism_tmin_2003 USING btree (rast_date);


--
-- Name: prism_tmin_2004_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2004_rast_date_idx ON prism_tmin_2004 USING btree (rast_date);


--
-- Name: prism_tmin_2005_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2005_rast_date_idx ON prism_tmin_2005 USING btree (rast_date);


--
-- Name: prism_tmin_2006_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2006_rast_date_idx ON prism_tmin_2006 USING btree (rast_date);


--
-- Name: prism_tmin_2007_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2007_rast_date_idx ON prism_tmin_2007 USING btree (rast_date);


--
-- Name: prism_tmin_2008_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2008_rast_date_idx ON prism_tmin_2008 USING btree (rast_date);


--
-- Name: prism_tmin_2009_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2009_rast_date_idx ON prism_tmin_2009 USING btree (rast_date);


--
-- Name: prism_tmin_2010_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2010_rast_date_idx ON prism_tmin_2010 USING btree (rast_date);


--
-- Name: prism_tmin_2011_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2011_rast_date_idx ON prism_tmin_2011 USING btree (rast_date);


--
-- Name: prism_tmin_2012_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2012_rast_date_idx ON prism_tmin_2012 USING btree (rast_date);


--
-- Name: prism_tmin_2013_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2013_rast_date_idx ON prism_tmin_2013 USING btree (rast_date);


--
-- Name: prism_tmin_2014_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2014_rast_date_idx ON prism_tmin_2014 USING btree (rast_date);


--
-- Name: prism_tmin_2014_rast_date_idx1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2014_rast_date_idx1 ON prism_tmin_2014 USING btree (rast_date);


--
-- Name: prism_tmin_2014_rast_date_idx2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2014_rast_date_idx2 ON prism_tmin_2014 USING btree (rast_date);


--
-- Name: prism_tmin_2015_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX prism_tmin_2015_rast_date_idx ON prism_tmin_2015 USING btree (rast_date);


--
-- Name: six_anomaly_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX six_anomaly_filename_idx ON six_anomaly USING btree (filename);


--
-- Name: six_anomaly_phenophase_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX six_anomaly_phenophase_idx ON six_anomaly USING btree (phenophase);


--
-- Name: six_anomaly_plant_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX six_anomaly_plant_idx ON six_anomaly USING btree (plant);


--
-- Name: six_anomaly_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX six_anomaly_rast_date_idx ON six_anomaly USING btree (rast_date);


--
-- Name: six_anomaly_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX six_anomaly_st_convexhull_idx ON six_anomaly USING gist (st_convexhull(rast));


--
-- Name: spatial_agdd_50f_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_agdd_50f_the_geom ON agdd_50f USING gist (the_geom);


--
-- Name: spatial_agdd_anomaly_50f_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_agdd_anomaly_50f_the_geom ON agdd_anomaly_50f USING gist (the_geom);


--
-- Name: spatial_agdd_anomaly_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_agdd_anomaly_the_geom ON agdd_anomaly USING gist (the_geom);


--
-- Name: spatial_agdd_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_agdd_the_geom ON agdd USING gist (the_geom);


--
-- Name: spatial_avg_agdd_50f_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_avg_agdd_50f_the_geom ON avg_agdd_50f USING gist (the_geom);


--
-- Name: spatial_avg_agdd_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_avg_agdd_the_geom ON avg_agdd USING gist (the_geom);


--
-- Name: spatial_postgis_rasters_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_postgis_rasters_the_geom ON postgis_rasters USING gist (the_geom);


--
-- Name: spatial_six_30yr_average_bloom_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_30yr_average_bloom_the_geom ON six_30yr_average_bloom USING gist (the_geom);


--
-- Name: spatial_six_30yr_average_leaf_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_30yr_average_leaf_the_geom ON six_30yr_average_leaf USING gist (the_geom);


--
-- Name: spatial_six_arnoldred_bloom_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_arnoldred_bloom_ncep_the_geom ON six_arnoldred_bloom_ncep USING gist (the_geom);


--
-- Name: spatial_six_arnoldred_bloom_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_arnoldred_bloom_prism_the_geom ON six_arnoldred_bloom_prism USING gist (the_geom);


--
-- Name: spatial_six_arnoldred_leaf_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_arnoldred_leaf_ncep_the_geom ON six_arnoldred_leaf_ncep USING gist (the_geom);


--
-- Name: spatial_six_arnoldred_leaf_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_arnoldred_leaf_prism_the_geom ON six_arnoldred_leaf_prism USING gist (the_geom);


--
-- Name: spatial_six_average_bloom_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_average_bloom_ncep_the_geom ON six_average_bloom_ncep USING gist (the_geom);


--
-- Name: spatial_six_average_bloom_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_average_bloom_prism_the_geom ON six_average_bloom_prism USING gist (the_geom);


--
-- Name: spatial_six_average_leaf_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_average_leaf_ncep_the_geom ON six_average_leaf_ncep USING gist (the_geom);


--
-- Name: spatial_six_average_leaf_prism_2015_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_average_leaf_prism_2015_the_geom ON six_average_leaf_prism_2015 USING gist (the_geom);


--
-- Name: spatial_six_average_leaf_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_average_leaf_prism_the_geom ON six_average_leaf_prism USING gist (the_geom);


--
-- Name: spatial_six_bloom_anomaly_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_bloom_anomaly_the_geom ON six_bloom_anomaly USING gist (the_geom);


--
-- Name: spatial_six_leaf_anomaly_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_leaf_anomaly_the_geom ON six_leaf_anomaly USING gist (the_geom);


--
-- Name: spatial_six_lilac_bloom_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_lilac_bloom_ncep_the_geom ON six_lilac_bloom_ncep USING gist (the_geom);


--
-- Name: spatial_six_lilac_bloom_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_lilac_bloom_prism_the_geom ON six_lilac_bloom_prism USING gist (the_geom);


--
-- Name: spatial_six_lilac_leaf_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_lilac_leaf_ncep_the_geom ON six_lilac_leaf_ncep USING gist (the_geom);


--
-- Name: spatial_six_lilac_leaf_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_lilac_leaf_prism_the_geom ON six_lilac_leaf_prism USING gist (the_geom);


--
-- Name: spatial_six_zabelli_bloom_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_zabelli_bloom_ncep_the_geom ON six_zabelli_bloom_ncep USING gist (the_geom);


--
-- Name: spatial_six_zabelli_bloom_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_zabelli_bloom_prism_the_geom ON six_zabelli_bloom_prism USING gist (the_geom);


--
-- Name: spatial_six_zabelli_leaf_ncep_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_zabelli_leaf_ncep_the_geom ON six_zabelli_leaf_ncep USING gist (the_geom);


--
-- Name: spatial_six_zabelli_leaf_prism_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_six_zabelli_leaf_prism_the_geom ON six_zabelli_leaf_prism USING gist (the_geom);


--
-- Name: spatial_tmax_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_tmax_the_geom ON tmax USING gist (the_geom);


--
-- Name: spatial_tmin_the_geom; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spatial_tmin_the_geom ON tmin USING gist (the_geom);


--
-- Name: spring_index_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spring_index_st_convexhull_idx ON spring_index USING gist (st_convexhull(rast));


--
-- Name: testing_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX testing_st_convexhull_idx ON testing USING gist (st_convexhull(rast));


--
-- Name: testing_st_convexhull_idx1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX testing_st_convexhull_idx1 ON testing USING gist (st_convexhull(rast));


--
-- Name: tmax_1999_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_1999_st_convexhull_idx ON prism_tmax_1999 USING gist (st_convexhull(rast));


--
-- Name: tmax_2000_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2000_st_convexhull_idx ON prism_tmax_2000 USING gist (st_convexhull(rast));


--
-- Name: tmax_2001_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2001_st_convexhull_idx ON prism_tmax_2001 USING gist (st_convexhull(rast));


--
-- Name: tmax_2002_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2002_st_convexhull_idx ON prism_tmax_2002 USING gist (st_convexhull(rast));


--
-- Name: tmax_2003_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2003_st_convexhull_idx ON prism_tmax_2003 USING gist (st_convexhull(rast));


--
-- Name: tmax_2004_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2004_st_convexhull_idx ON prism_tmax_2004 USING gist (st_convexhull(rast));


--
-- Name: tmax_2005_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2005_st_convexhull_idx ON prism_tmax_2005 USING gist (st_convexhull(rast));


--
-- Name: tmax_2006_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2006_st_convexhull_idx ON prism_tmax_2006 USING gist (st_convexhull(rast));


--
-- Name: tmax_2007_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2007_st_convexhull_idx ON prism_tmax_2007 USING gist (st_convexhull(rast));


--
-- Name: tmax_2008_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2008_st_convexhull_idx ON prism_tmax_2008 USING gist (st_convexhull(rast));


--
-- Name: tmax_2009_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2009_st_convexhull_idx ON prism_tmax_2009 USING gist (st_convexhull(rast));


--
-- Name: tmax_2010_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2010_st_convexhull_idx ON prism_tmax_2010 USING gist (st_convexhull(rast));


--
-- Name: tmax_2011_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2011_st_convexhull_idx ON prism_tmax_2011 USING gist (st_convexhull(rast));


--
-- Name: tmax_2012_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2012_st_convexhull_idx ON prism_tmax_2012 USING gist (st_convexhull(rast));


--
-- Name: tmax_2013_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2013_st_convexhull_idx ON prism_tmax_2013 USING gist (st_convexhull(rast));


--
-- Name: tmax_2014_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2014_st_convexhull_idx ON prism_tmax_2014 USING gist (st_convexhull(rast));


--
-- Name: tmax_2015_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2015_filename_idx ON tmax_2015 USING btree (filename);


--
-- Name: tmax_2015_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2015_rast_date_idx ON tmax_2015 USING btree (rast_date);


--
-- Name: tmax_2015_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2015_st_convexhull_idx ON prism_tmax_2015 USING gist (st_convexhull(rast));


--
-- Name: tmax_2015_st_convexhull_idx1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2015_st_convexhull_idx1 ON tmax_2015 USING gist (st_convexhull(rast));


--
-- Name: tmax_2016_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2016_filename_idx ON tmax_2016 USING btree (filename);


--
-- Name: tmax_2016_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2016_rast_date_idx ON tmax_2016 USING btree (rast_date);


--
-- Name: tmax_2016_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmax_2016_st_convexhull_idx ON tmax_2016 USING gist (st_convexhull(rast));


--
-- Name: tmin_1999_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_1999_st_convexhull_idx ON prism_tmin_1999 USING gist (st_convexhull(rast));


--
-- Name: tmin_2000_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2000_st_convexhull_idx ON prism_tmin_2000 USING gist (st_convexhull(rast));


--
-- Name: tmin_2001_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2001_st_convexhull_idx ON prism_tmin_2001 USING gist (st_convexhull(rast));


--
-- Name: tmin_2002_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2002_st_convexhull_idx ON prism_tmin_2002 USING gist (st_convexhull(rast));


--
-- Name: tmin_2003_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2003_st_convexhull_idx ON prism_tmin_2003 USING gist (st_convexhull(rast));


--
-- Name: tmin_2004_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2004_st_convexhull_idx ON prism_tmin_2004 USING gist (st_convexhull(rast));


--
-- Name: tmin_2005_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2005_st_convexhull_idx ON prism_tmin_2005 USING gist (st_convexhull(rast));


--
-- Name: tmin_2006_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2006_st_convexhull_idx ON prism_tmin_2006 USING gist (st_convexhull(rast));


--
-- Name: tmin_2007_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2007_st_convexhull_idx ON prism_tmin_2007 USING gist (st_convexhull(rast));


--
-- Name: tmin_2008_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2008_st_convexhull_idx ON prism_tmin_2008 USING gist (st_convexhull(rast));


--
-- Name: tmin_2009_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2009_st_convexhull_idx ON prism_tmin_2009 USING gist (st_convexhull(rast));


--
-- Name: tmin_2010_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2010_st_convexhull_idx ON prism_tmin_2010 USING gist (st_convexhull(rast));


--
-- Name: tmin_2011_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2011_st_convexhull_idx ON prism_tmin_2011 USING gist (st_convexhull(rast));


--
-- Name: tmin_2012_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2012_st_convexhull_idx ON prism_tmin_2012 USING gist (st_convexhull(rast));


--
-- Name: tmin_2013_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2013_st_convexhull_idx ON prism_tmin_2013 USING gist (st_convexhull(rast));


--
-- Name: tmin_2014_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2014_st_convexhull_idx ON prism_tmin_2014 USING gist (st_convexhull(rast));


--
-- Name: tmin_2015_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2015_filename_idx ON tmin_2015 USING btree (filename);


--
-- Name: tmin_2015_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2015_rast_date_idx ON tmin_2015 USING btree (rast_date);


--
-- Name: tmin_2015_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2015_st_convexhull_idx ON prism_tmin_2015 USING gist (st_convexhull(rast));


--
-- Name: tmin_2015_st_convexhull_idx1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2015_st_convexhull_idx1 ON tmin_2015 USING gist (st_convexhull(rast));


--
-- Name: tmin_2016_filename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2016_filename_idx ON tmin_2016 USING btree (filename);


--
-- Name: tmin_2016_rast_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2016_rast_date_idx ON tmin_2016 USING btree (rast_date);


--
-- Name: tmin_2016_st_convexhull_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tmin_2016_st_convexhull_idx ON tmin_2016 USING gist (st_convexhull(rast));


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

