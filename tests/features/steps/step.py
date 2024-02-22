from behave import given, when, then
from types import SimpleNamespace

@when("the machine starts")
def bootmachine(context):
    nixos = SimpleNamespace(**context.config.userdata)
    nixos.machine.start()

@then("the machine should completely boot")
def booted(context):
    nixos = SimpleNamespace(**context.config.userdata)
    nixos.machine.wait_for_unit("basic.target")
