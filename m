From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 02/31] vmscan: take at least one pass with shrinkers
Date: Tue, 30 Apr 2013 14:22:39 +0100
Message-ID: <20130430132239.GB6415@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-3-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367018367-11278-3-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Sat, Apr 27, 2013 at 03:18:58AM +0400, Glauber Costa wrote:
> In very low free kernel memory situations, it may be the case that we
> have less objects to free than our initial batch size. If this is the
> case, it is better to shrink those, and open space for the new workload
> then to keep them and fail the new allocations.
> 
> More specifically, this happens because we encode this in a loop with
> the condition: "while (total_scan >= batch_size)". So if we are in such
> a case, we'll not even enter the loop.
> 
> This patch modifies turns it into a do () while {} loop, that will
> guarantee that we scan it at least once, while keeping the behaviour
> exactly the same for the cases in which total_scan > batch_size.
> 
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> Reviewed-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

There are two cases where this *might* cause a problem and worth keeping
an eye out for.

The first is that it's possible for caches to shrink to zero where before
the last SHRINK_SLAB objects would often be protected for any slab. If
this is an inode or dentry cache and there are very few objects then it's
possible that objects will be reclaimed before they can be used by the
process allocating them.

The second is if any of the shrinker users have generally a small number
of large objects then any shrink of them may chunk out even the live
objects. This will depend on the quality of the shrinker implementation
but it might expose problems that were hidden before.

Neither potential issue are the fault of your patch so I'm not going
to nack. However, bear in mind that we should watch out for bugs where
processes stall making forward progress because they are constantly
reallocating inodes or bugs like graphics stalls because their objects
keep getting fully reclaimed as only a small number exist.

I suspect that you need this patch because it's very reasonable for a memcg
to have slabs with tiny numbers of objects you want to reclaim. However,
if my imagined scenarios are a problem in reality then you'll need to
revert this patch and special case for memcg. Alternatively you could
shrink in two passes. The first which never shrinks a slab below
shrinker->batch *but* if all slabs are below that threshold then shrink
the slab to 0.

-- 
Mel Gorman
SUSE Labs
