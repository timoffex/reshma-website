def get_relative_path(*, of, relative_to):
    if not of.startswith(relative_to):
        fail(of + " must start with " + relative_to)
    return of[len(relative_to):]
