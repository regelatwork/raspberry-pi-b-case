
// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// fudge value is used to ensure that subtracted solids are a tad taller
// in the z dimension than the polygon being subtracted from.  This helps
// keep the resulting .stl file manifold.

use <offset.git/lib/offset.scad>

fudge = 0.1;

module n7_logo(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[120.753685,13.246345],[171.500005,-37.507295],[171.500005,-50.753655],[171.500005,-64.000015],[184.000005,-64.000015],[196.500005,-64.000015],[196.500005,-0.000015],[196.500005,64.000015],[133.253685,64.000015],[70.007355,64.000015]]);
    linear_extrude(height=h)
      polygon([[-196.500005,-64.000015],[-173.460165,-64.000015],[-155.446595,-63.680905],[-144.088875,-60.818395],[-133.836395,-52.554695],[-119.138555,-36.032025],[-110.913205,-26.617345],[-102.687845,-17.202675],[-94.462495,-7.787995],[-86.237135,1.626685],[-76.515165,12.422935],[-69.143785,19.596595],[-63.509795,23.678335],[-58.999995,25.198845],[-58.249995,25.274145],[-57.499995,25.349445],[-56.749995,25.424745],[-55.999995,25.500045],[-55.479405,-63.999955],[-19.499995,-63.999955],[-19.499995,63.000075],[-37.749995,62.990075],[-54.298835,62.560535],[-66.508095,61.077075],[-75.960195,58.222695],[-84.237615,53.680375],[-88.331355,49.930105],[-95.853805,41.893975],[-106.683895,29.705465],[-120.700545,13.498045],[-133.079125,-0.878185],[-143.478025,-12.819315],[-151.021415,-21.331545],[-154.833455,-25.421055],[-157.786965,-27.341435],[-160.635675,-28.154455],[-162.782645,-28.311365],[-163.630955,-28.263365],[-163.499995,15.998075],[-163.499995,62.998105],[-196.500005,62.998105]]);
    linear_extrude(height=h)
      polygon([[97.333335,-33.133325],[-9.499995,-34.000015],[-9.499995,-64.000015],[149.500005,-64.000015],[149.500005,-33.644055],[54.982745,63.053585],[-2.116535,63.053585]]);
  }
}

s=0.45;
h=3;
insetValue=0.6;

scale([s,s,1])
translate([0,0,-insetValue])
inset(insetValue)
n7_logo(h + 2*insetValue);


