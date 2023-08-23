load("render.star", "render")
load("http.star", "http")

STATIONS_URL = "https://gbfs.lyft.com/gbfs/1.1/bay/en/station_information.json"
STATION_STATUS_URL = "https://gbfs.lyft.com/gbfs/1.1/bay/en/station_status.json"
MY_STATION_ID = "bf116a73-3718-46c1-ac14-c295963150ae"

def main():
  rep = http.get(STATION_STATUS_URL)
  if rep.status_code != 200:
      fail("Coindesk request failed with status %d", rep.status_code)

  station_data = rep.json()["data"]["stations"]

  text = ""

  for index, value in enumerate(station_data):
    if value["station_id"] == MY_STATION_ID:
        text = "Total bikes: " + str(value["num_bikes_available"]) + "\nE-bikes: " + str(value["num_ebikes_available"])
        break

  return render.Root(
      child = render.Text(text)
  )