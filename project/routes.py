import router

@router.get(path='/api')
def say(msg):
  print(msg)