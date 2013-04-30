From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 02/31] vmscan: take at least one pass with shrinkers
Date: Tue, 30 Apr 2013 16:37:07 +0100
Message-ID: <20130430153707.GD11497@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-3-git-send-email-glommer@openvz.org>
 <20130430132239.GB6415@suse.de>
 <517FC7B4.5030101@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <517FC7B4.5030101-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Tue, Apr 30, 2013 at 05:31:32PM +0400, Glauber Costa wrote:
> On 04/30/2013 05:22 PM, Mel Gorman wrote:
> > On Sat, Apr 27, 2013 at 03:18:58AM +0400, Glauber Costa wrote:
> >> In very low free kernel memory situations, it may be the case that we
> >> have less objects to free than our initial batch size. If this is the
> >> case, it is better to shrink those, and open space for the new workload
> >> then to keep them and fail the new allocations.
> >>
> >> More specifically, this happens because we encode this in a loop with
> >> the condition: "while (total_scan >= batch_size)". So if we are in such
> >> a case, we'll not even enter the loop.
> >>
> >> This patch modifies turns it into a do () while {} loop, that will
> >> guarantee that we scan it at least once, while keeping the behaviour
> >> exactly the same for the cases in which total_scan > batch_size.
> >>
> >> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> >> Reviewed-by: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> >> Reviewed-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> >> CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> > 
> > There are two cases where this *might* cause a problem and worth keeping
> > an eye out for.
> > 
> 
> Any test case that you envision that could help bringing those issues
> forward should they exist ? (aside from getting it into upstream trees
> early?)
> 

hmm.

fsmark multi-threaded in a small-memory machine with a small number of
very large files greater than the size of physical memory might trigger
it. There should be a small number of inodes active so less than the 128
that would have been ignored before the patch. As the files are larger
than memory, kswapd will be awake and calling shrinkers so if the
shrinker is really discarding active inodes then the performance will
degrade.

-- 
Mel Gorman
SUSE Labs
