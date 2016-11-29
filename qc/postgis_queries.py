select_urma_by_date = ("SELECT st_value(rast,ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) "
                       "FROM %(table)s "
                       "WHERE rast_date = %(rast_date)s AND dataset = 'urma' "
                       "AND ST_Intersects(rast, ST_SetSRID(ST_MakePoint(%(long)s, %(lat)s),4269));")

select_prism_by_date = ("SELECT st_value(rast,ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) "
                        "FROM %(table)s "
                        "WHERE rast_date = %(rast_date)s "
                        "AND ST_Intersects(rast, ST_SetSRID(ST_MakePoint(%(long)s, %(lat)s),4269));")

select_best_six_by_date = ("SELECT st_value(rast,ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) "
                        "FROM %(table)s "
                        "WHERE rast_date = %(rast_date)s AND phenophase = %(phenophase)s "
                        "AND ST_Intersects(rast, ST_SetSRID(ST_MakePoint(%(long)s, %(lat)s),4269));")
