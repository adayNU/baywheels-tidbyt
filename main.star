load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")

STATIONS_URL = "https://gbfs.lyft.com/gbfs/1.1/bay/en/station_information.json"
STATION_STATUS_URL = "https://gbfs.lyft.com/gbfs/1.1/bay/en/station_status.json"
MY_STATION_ID = "bf116a73-3718-46c1-ac14-c295963150ae"
BW_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAADIAAAAiCAYAAAAd6YoqAAAAAXNSR0IArs4c6QAAA4RJREFUWEftmEtoE1EUhv8zqW3TSaqgmRQEX1ARFEHt1kWhYgURsStRKIjoQhExY3WjC3etE1BRsIjgQhFEtypCRdy40IpYxUUVbRZqZyw+p7WPzJFJOyVN53EnSR9gZ5fMeX3n3HPvmUu6nP4I8Cq4PAx0JU21ye1dOf/T5Y5mQHrgZZNAmYSZWunnk+YSxIilG5n5sWhSGBhJmmqVm/ycgejxjq2wpKeiEPlyiqlSod6cgPTLF5KEsa/FQNg6DMokC5baHIFobwhYXyyIrRchacPSPyfeOjZmHcSQtZsM7CsFYjL4aLY28e3Ub/v3rIIw7kQMOTMWADFEwGsGFgNY57tTAV2JiV1VCESXNfYz6DSfIWujDFS47ipA2mLuJaKrPrY+K6a63HnfL2vbCHgkUr1ZBWFQI8CbvQOj64qZOui8ZzAZctqajyAtXofvRLDHFVO9mB940GoI1exBxkSXFoP+FxDqJvATJ8sJU1WDkjhfKzKlHexKL4Dkp8SZfoOyUsYeCV0Rx/dsb79Bzb4AslCR/DWQMFdUfY9+qRuTRvu8TmEC0kHnCIMHCFJuCLQfxUytNmrOn2Gic76ne8RaW5aKCI0QAiAApp3sxrL2OA9FfgX5sPfplwA2uQvSJzsrQbtWkJPcmC0EYm1SzLZXhfZ0+fwDgJp9J2FD1toZaPMSCnMo+ToSAEmY8UrC4dFCO/0xbQ8x7gXYB/wyTtFsLQ9FMgCWiGS+2B4h4FbCVPd76eux9Acwr/GxHwACdFG11GoNW+/AiBcL47e0CBjpM+OxBpdqTJ2E088BbnCLIXcboddol0E44re8cnKyNgggWgwMMZ9lkg64j/H0UDFTO0TsesU6ea3SH0u3EPNdj6bvydLo3gqrMmpJ2Z3EUmt+QAzcAHEfMZ0G4HrvxLC2EyKdBSC9YDquDKbui0A4MkaNtoUl7AZjF4CNE5vJVBNu+7Yzz7xA5yKv8uuy9t2vj36aldWLa/+uAKOOQWPJ3yefhQneT7YXl6qmXXT5KeiyZn8/bwPQA2DAvmIiUJzHP18lT13Ce+WPWl+uwD17RNRBHoioyrhcxFqr/GrrDacUTrrYioTy4nbFGcqAgPDMgzCuKIPqUYFYShKZURC7wetxbLikCAWVZwzEYj5UN3jymmAcJYuFAskdirUd9chKtwFsKfD+gyrQlPipdpccVREG/gEqbUdcVOb8sQAAAABJRU5ErkJggg==
""")

def main():
  rep = http.get(STATION_STATUS_URL, ttl_seconds = 60)
  if rep.status_code != 200:
      fail("Coindesk request failed with status %d", rep.status_code)

  station_data = rep.json()["data"]["stations"]

  text = ""

  for index, value in enumerate(station_data):
    if value["station_id"] == MY_STATION_ID:
        text = "Bikes: " + str(int(value["num_bikes_available"]-value["num_ebikes_available"])) + "\nE-Bikes: " + str(int(value["num_ebikes_available"]))
        break

  return render.Root(
    child = render.Box(
      render.Row( 
        expanded=True, 
        main_align="space_evenly", 
        cross_align="center",
        children = [
            render.Image(src=BW_ICON, width=20),
            render.WrappedText(content=text, font="tb-8"),
        ],
      )
    )
  )