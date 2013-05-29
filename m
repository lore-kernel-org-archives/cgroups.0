From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v8 16/34] xfs: convert buftarg LRU to generic code
Date: Wed, 29 May 2013 20:15:19 +1000
Message-ID: <20130529101519.GA29466@dastard>
References: <1369391368-31562-1-git-send-email-glommer@openvz.org>
 <1369391368-31562-17-git-send-email-glommer@openvz.org>
 <20130525002759.GK24543@dastard>
 <51A4D3B5.6060802@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51A4D3B5.6060802-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, May 28, 2013 at 09:26:37PM +0530, Glauber Costa wrote:
> On 05/25/2013 05:57 AM, Dave Chinner wrote:
> > On Fri, May 24, 2013 at 03:59:10PM +0530, Glauber Costa wrote:
> >> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >> Convert the buftarg LRU to use the new generic LRU list and take
> >> advantage of the functionality it supplies to make the buffer cache
> >> shrinker node aware.
> >>
> >> * v7: Add NUMA aware flag
> > 
> > I know what is wrong with this patch that causes the unmount hang -
> > it's the handling of the _XBF_LRU_DISPOSE flag no longer being
> > modified atomically with the LRU lock. Hence there is a race where
> > we can either lose the _XBF_LRU_DISPOSE or not see it and hence we
> > can end up with code not detecting what list the buffer is on
> > correctly.
> > 
> > I haven't had a chance to work out a fix for it yet. If this ends up
> > likely to hold up the patch set, Glauber, then feel free to drop it
> > from the series and I'll push a fixed version through the XFS tree
> > in due course....
> > 
> > Cheers,
> > 
> > Dave.
> > 
> Please let me know what you think about the following two (very coarse)
> patches. My idea is to expose more of the raw structures so XFS can do
> the locking itself when needed.

No, I'd prefer not to do that.  There's a big difference between a
callback that passes a pointer to an internal lock that protects the
list that the item being passed is on and exposing the guts of the
per node list and lock implementation to everyone....

As it is, the XFS buffer LRU reclaimation is modelled on the
inode/dentry cache lru reclaimation where the "on dispose list" flag
is managed by a lock in the inode/dentry and wraps around the
outside of the LRU locks. The simplest fix to XFS is to add a
spinlock to the buffer to handle this in the same way as inodes and
dentries. I think I might be able to do it in a way that avoids
the spin lock but I just haven't had time to look at it that closely.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
