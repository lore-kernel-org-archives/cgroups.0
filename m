From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v6 12/31] fs: convert inode and dentry shrinking to be
 node aware
Date: Wed, 15 May 2013 19:27:26 +0400
Message-ID: <5193A95E.70205@parallels.com>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org> <1368382432-25462-13-git-send-email-glommer@openvz.org> <20130514095200.GI29466@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130514095200.GI29466@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 05/14/2013 01:52 PM, Dave Chinner wrote:
> kswapd0-632 1210443.469309: mm_shrink_slab_start: cache items 600456 delta 1363 total_scan 300228
> kswapd3-635 1210443.510311: mm_shrink_slab_start: cache items 514885 delta 1250 total_scan 101025
> kswapd1-633 1210443.517440: mm_shrink_slab_start: cache items 613824 delta 1357 total_scan 97727
> kswapd2-634 1210443.527026: mm_shrink_slab_start: cache items 568610 delta 1331 total_scan 259185
> kswapd3-635 1210443.573165: mm_shrink_slab_start: cache items 486408 delta 1277 total_scan 243204
> kswapd1-633 1210443.697012: mm_shrink_slab_start: cache items 550827 delta 1224 total_scan 82231
> 
> in the space of 230ms, I can see why the caches are getting
> completely emptied. kswapds are making multiple, large scale scan
> passes on the caches. Looks like our problem is an impedence
> mismatch: global windup counter, per-node cache scan calculations.
> 
> So, that's the mess we really need to cleaning up before going much
> further with this patchset. We need stable behaviour from the
> shrinkers - I'll look into this a bit deeper tomorrow.

That doesn't totally make sense to me.

Both our scan and count functions will be per-node now. This means we
will always try to keep ourselves within reasonable maximums on a
per-node basis as well.

