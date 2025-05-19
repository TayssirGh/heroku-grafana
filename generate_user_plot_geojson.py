import os
import psycopg2
import json
from shapely import wkb
from shapely.geometry import mapping

# Prepare your .env or set these directly
DATABASE_URL = os.getenv("DATABASE_URL", "postgres://u3pui32n86ui9h:p25e721db0374518a903321139d105e27c2a66ebbfe39ecd0a4"
                                         "e8c964166a60a3@c2sbm44gu4v1s2.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5"
                                         "432/d4t9nlo26pgdka")

USER_ID = 4

polygon_features = []
centroid_features = []

query = """
SELECT p.id_code_idu, p.borders, p.surface, p.commune_insee_code
FROM geo_plot p
JOIN nn_property_plots npp ON npp.plot_idu = p.id_code_idu
JOIN user_property up ON up.id = npp.property_id
JOIN nn_user_property nup ON nup.property_id = up.id
WHERE nup.user_id = %s AND p.borders IS NOT NULL;
"""

conn = psycopg2.connect(DATABASE_URL)
cur = conn.cursor()
cur.execute(query, (USER_ID,))

for row in cur.fetchall():
    id_code, borders_wkb, surface, commune_code = row
    geom = wkb.loads(borders_wkb, hex=False)
    surface = float(surface) if surface else None
    commune = commune_code.strip() if commune_code else None

    polygon_features.append({
        "type": "Feature",
        "geometry": mapping(geom),
        "properties": {
            "id": id_code.strip(),
            "surface": surface,
            "commune": commune
        }
    })

    centroid = geom.centroid
    centroid_features.append({
        "type": "Feature",
        "geometry": {
            "type": "Point",
            "coordinates": [centroid.x, centroid.y]
        },
        "properties": {
            "id": id_code.strip(),
            "surface": surface,
            "commune": commune
        }
    })

polygon_geojson = {
    "type": "FeatureCollection",
    "features": polygon_features
}

centroid_geojson = {
    "type": "FeatureCollection",
    "features": centroid_features
}

os.makedirs("geojson", exist_ok=True)

with open("geojson/user_4_polygons.geojson", "w") as f:
    json.dump(polygon_geojson, f)

with open("geojson/user_4_centroids.geojson", "w") as f:
    json.dump(centroid_geojson, f)

print("✅ GeoJSON files saved to geojson/")
cur.close()
conn.close()