# Implementation-only: these buffer output pins are present after IP linking.
# They were verified in the linked synthesis design on XCZU4EV.
set_property CLOCK_DELAY_GROUP hdmi_shared_clock_group [get_nets -of_objects [get_pins -hierarchical -filter {NAME =~ *hdmi_shared*/fast_buffer/O || NAME =~ *hdmi_shared*/slow_buffer/O || NAME =~ *hdmi_shared*/pixel_buffer/O}]]
