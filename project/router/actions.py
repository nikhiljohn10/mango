from functools import wraps

def get(path):
  def get_wrapper(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
      print("Function that started running is " + func.__name__ + " in path: " + path)
      result = func(*args, **kwargs)
      return result
    return wrapper
  return get_wrapper

