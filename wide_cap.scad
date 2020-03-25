// Generated by SolidPython 0.4.6 on 2020-03-25 10:18:37


union() {
	difference() {
		minkowski() {
			cube(center = true, size = [35.0000000000, 16.0000000000, 1.0000000000]);
			sphere($fn = 32, r = 0.5000000000);
		}
		translate(v = [0, 0, 0.9000000000]) {
			minkowski() {
				cube(center = true, size = [27.8000000000, 12.6000000000, 0.1000000000]);
				sphere($fn = 32, r = 0.5000000000);
			}
		}
	}
	union() {
		difference() {
			translate(v = [0, 0, 2.5000000000]) {
				minkowski() {
					cube(center = true, size = [4.2500000000, 2.2500000000, 2.5000000000]);
					sphere($fn = 32, r = 1.5000000000);
				}
			}
			translate(v = [0, 0, 5]) {
				union() {
					cube(center = true, size = [4.1000000000, 1.4000000000, 5.5000000000]);
					cube(center = true, size = [1.2000000000, 4.1000000000, 5.5000000000]);
				}
			}
		}
		cube(center = true, size = [7.5000000000, 5.5000000000, 2]);
	}
}
/***********************************************
*********      SolidPython code:      **********
************************************************
 
#!/usr/bin/env python
"""
keycaps

mostly ported from
https://www.thingiverse.com/thing:2766779
"""

import os
import sys
import solid as s


_SLOP = 0.05


def cross(h=4, slop=_SLOP):

    out = s.union()(
        s.cube([4 + 2 * slop, 1.3 + 2 * slop, h], center=True),
        s.cube([1.1 + 2 * slop, 4 + 2 * slop, h], center=True),
    )

    return out


def rounded_cube(x, y, z, r, segments=32, center=True):
    out = s.minkowski()(
        s.cube([x - 2 * r, y - 2 * r, z - 2 * r], center=center),
        s.sphere(r=r, segments=segments),
    )

    return out


def mx_post(h, z_offset):
    """post to connect to mx switch
    """
    out = s.difference()(
        s.translate([0, 0, (7 / 2) - z_offset])(rounded_cube(7.25, 5.25, h, 1.5)),
        s.translate([0, 0, 5])(cross(h=h)),
    )

    out = s.union()(out, s.cube([7.5, 5.5, 2], center=True))
    return out


def flat_cap(x, y, z, r, recess=0):
    """flat_cap
    x, y, z cap dimensions
    r (int): radius for rounded edges
    recess: decimal, percent of cap to remove
    """

    cap = rounded_cube(x, y, z, r)

    if recess > 0:
        if recess < 1:
            insert = rounded_cube(
                x * recess, y * recess, (z * recess) - 0.5, r, center=True
            )

            cap = s.difference()(
                cap, s.translate([0, 0, z - (z * recess) + 0.5])(insert)
            )

        else:
            raise ValueError(f"recess should be a decimal between 0 and 1")

    out = s.union()(cap, mx_post(5.5, z / 2))
    return out


if __name__ == "__main__":
    out_dir = sys.argv[1] if len(sys.argv) > 1 else os.curdir

    cap = flat_cap(17, 17, 2, .5, recess=0.8)
    s.scad_render_to_file(cap, f"{out_dir}/flat_cap.scad", include_orig_code=True)

    wide_cap = flat_cap(36, 17, 2, .5, recess=0.8)
    s.scad_render_to_file(wide_cap, f"{out_dir}/wide_cap.scad", include_orig_code=True)
 
 
************************************************/
