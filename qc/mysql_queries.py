# six table queries
select_station_six_rows_for_year = ("SELECT * FROM climate.six "
                                    "WHERE station_id = %s AND source_id = %s AND year = %s ;")

insert_six_row = ("INSERT INTO climate.six (station_id, source_id, leaf_lilac, leaf_arnoldred, leaf_zabelli, "
                  "leaf_average, bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average, year, missing) "
                  "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);")

update_six_row = ("UPDATE climate.six SET leaf_lilac = %s, leaf_arnoldred = %s, leaf_zabelli = %s, leaf_average = %s, "
                  "bloom_lilac = %s, bloom_arnoldred = %s, bloom_zabelli = %s, bloom_average = %s, missing = %s "
                  "WHERE station_id = %s AND source_id = %s AND year = %s;")

# agdds table queries
search_for_agdd_row = ("SELECT * FROM climate.agdds "
                       "WHERE station_id = %s AND source_id = %s AND date = %s AND base_temp_f = %s ;")

insert_agdd_row = ("INSERT INTO climate.agdds (station_id, source_id, gdd, agdd, "
                   "year, doy, date, base_temp_f, missing, tmin, tmax) "
                   "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);")

update_agdd_row = ("UPDATE climate.agdds SET tmin = %s, tmax = %s, gdd = %s, agdd = %s, missing = %s "
                   "WHERE station_id = %s AND source_id = %s AND base_temp_f = %s AND date = %s;")

select_agdd_temps_for_year = ("SELECT * FROM climate.agdds "
                              "WHERE station_id = %s AND source_id = %s AND base_temp_f = 32 AND YEAR = %s "
                              "ORDER BY date;")

select_agdd_by_date = ("SELECT * FROM climate.agdds "
                       "WHERE station_id = %s AND source_id = %s AND base_temp_f = %s AND date = %s;")

# stations and sources queries
insert_source = "INSERT INTO climate.sources (name, description) VALUES (%s, %s);"

select_sources = "SELECT * FROM climate.sources;"

insert_station = ("INSERT INTO climate.stations (latitude, longitude, elevation, name, int_network_id, "
                  "char_network_id, type) "
                  "VALUES (%s, %s, %s, %s, %s, %s, %s);")

select_stations = "SELECT * FROM climate.stations s LEFT JOIN climate.station_attributes sa ON s.id = sa.station_id and sa.attribute_id = 1;"

insert_station_attribute = ("INSERT INTO climate.station_attributes (station_id, attribute_id, int_value, char_value, "
                            "float_value) "
                            "VALUES (%s, %s, %s, %s, %s);")

select_attribute_types = "SELECT * FROM climate.attribute_types;"
