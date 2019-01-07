import logging
try:
    import requests
    HAS_REQUESTS = True
except ImportError:
    HAS_REQUESTS = False

log = logging.getLogger(__name__)

__virtualname__ = 'weather'

def __virtual__():
    
    if HAS_REQUESTS:
        return __virtualname__
    else:
        return (False, 'The weather module cannot be loaded: requests package unavailable.')



def get(signs=None):
    '''
    Gets the Current Weather

    CLI Example::

        salt minion weather.get KPHL

    This module also accepts multiple values in a comma separated list::

        salt minion weather.get KPHL,KACY
    '''
    log.debug(signs)
    return_value = {}
    signs = signs.split(',')
    for sign in signs:
        return_value[sign] = _make_request(sign)
    return return_value


def _make_request(sign):
    '''
    The function that makes the request for weather data from the National Weather Service.
    '''
    request = requests.get('https://api.weather.gov/stations/{}/observations/current'.format(sign))
    conditions = {
        "description:": request.json()["properties"]["textDescription"],
        "temperature": round(request.json()["properties"]["temperature"]["value"], 1)
    }
    return conditions
