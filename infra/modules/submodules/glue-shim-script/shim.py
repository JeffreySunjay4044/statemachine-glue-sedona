import argparse
import sys
from importlib import import_module


class JobEntryPointNotFoundException(Exception):
    pass


class InvalidJobEntryPointException(Exception):
    pass


class JobClassNotFoundException(Exception):
    pass


class RunMethodNotFoundException(Exception):
    pass


JOB_ENTRY_POINT_ARG = "job_entry_point"

parser = argparse.ArgumentParser()
parser.add_argument(f"--{JOB_ENTRY_POINT_ARG}")


def process_input():
    # Parse command-line arguments (uses sys.argv[1:] by default)
    args, unknown = parser.parse_known_args()

    args_vars = vars(args)
    if not args_vars[JOB_ENTRY_POINT_ARG]:
        raise JobEntryPointNotFoundException(
            f"The '--{JOB_ENTRY_POINT_ARG}' argument is required. "
            "Its value should be of the form 'module:Class' or 'module1.module2:Class'.")

    entry_point: str = args_vars[JOB_ENTRY_POINT_ARG]
    entry_point_parts = entry_point.split(":")
    if len(entry_point_parts) != 2:
        raise InvalidJobEntryPointException(
            f"Invalid entry point value '{entry_point}'. "
            "The value should be of the form 'module:Class' or 'module1.module2:Class'.")

    return entry_point_parts


def load_job(module_name_, class_name_):
    # This can throw a ModuleNotFoundError, which is pretty descriptive
    #  already, so we don't catch/throw our own exception.
    module = import_module(module_name_)

    if not hasattr(module, class_name_):
        raise JobClassNotFoundException(f"Job class '{class_name_}' was not found in module '{module}'.")

    job_class = module.__getattribute__(class_name_)

    if not hasattr(job_class, "run"):
        raise RunMethodNotFoundException(f"Job class '{class_name_}' does not have a 'run' method.")

    return job_class


def main():
    (module_name, class_name) = process_input()
    job = load_job(module_name, class_name)
    # Instantiate and run the Job
    return job(sys.argv).run()


if __name__ == "__main__":
    main()
