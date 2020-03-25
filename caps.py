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

    out = s.union()(cap, mx_post(6, z / 2))
    return out


if __name__ == "__main__":
    out_dir = sys.argv[1] if len(sys.argv) > 1 else os.curdir

    cap = flat_cap(17, 17, 3, .75, recess=0.8)
    s.scad_render_to_file(cap, f"{out_dir}/flat_cap.scad", include_orig_code=True)

    wide_cap = flat_cap(36, 17, 3, .75, recess=0.8)
    s.scad_render_to_file(wide_cap, f"{out_dir}/wide_cap.scad", include_orig_code=True)
