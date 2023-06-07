import sys
import unittest
from unittest.mock import patch

import shim


class Job:

    def __init__(self, argv):
        self.argv = argv

    def run(self):
        # This is just a trivial output to give tests something to assert.
        return self.argv


class NoRunJob:
    pass


class TestShim(unittest.TestCase):

    def test_main(self):
        args = ["executable", "--job_entry_point", f"{__name__}:Job"]
        with patch.object(sys, "argv", args):
            self.assertEqual(shim.main(), args)

    def test_main_missing_entry_point(self):
        args = ["executable"]
        with patch.object(sys, "argv", args):
            with self.assertRaises(shim.JobEntryPointNotFoundException):
                shim.main()

    def test_main_invalid_entry_point(self):
        args = ["executable", "--job_entry_point", "no.colon"]
        with patch.object(sys, "argv", args):
            with self.assertRaises(shim.InvalidJobEntryPointException):
                shim.main()

    def test_main_module_not_found(self):
        args = ["executable", "--job_entry_point", "missing.module:Job"]
        with patch.object(sys, "argv", args):
            with self.assertRaises(ModuleNotFoundError):
                shim.main()

    def test_main_class_not_found(self):
        args = ["executable", "--job_entry_point", f"{__name__}:MissingJob"]
        with patch.object(sys, "argv", args):
            with self.assertRaises(shim.JobClassNotFoundException):
                shim.main()

    def test_main_run_method_not_found(self):
        args = ["executable", "--job_entry_point", f"{__name__}:NoRunJob"]
        with patch.object(sys, "argv", args):
            with self.assertRaises(shim.RunMethodNotFoundException):
                shim.main()


if __name__ == "__main__":
    unittest.main()
