From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix cgroup creation failure after many
 small jobs
Date: Fri, 17 Jun 2016 12:40:43 -0400
Message-ID: <20160617164043.GA10485@cmpxchg.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
 <20160617090655.GE13143@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160617090655.GE13143@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jun 17, 2016 at 12:06:55PM +0300, Vladimir Davydov wrote:
> On Wed, Jun 15, 2016 at 11:42:44PM -0400, Johannes Weiner wrote:
> > The memory controller has quite a bit of state that usually outlives
> > the cgroup and pins its CSS until said state disappears. At the same
> > time it imposes a 16-bit limit on the CSS ID space to economically
> > store IDs in the wild. Consequently, when we use cgroups to contain
> > frequent but small and short-lived jobs that leave behind some page
> > cache, we quickly run into the 64k limitations of outstanding CSSs.
> > Creating a new cgroup fails with -ENOSPC while there are only a few,
> > or even no user-visible cgroups in existence.
> > 
> > Although pinning CSSs past cgroup removal is common, there are only
> > two instances that actually need a CSS ID after a cgroup is deleted:
> > cache shadow entries and swapout records.
> > 
> > Cache shadow entries reference the ID weakly and can deal with the CSS
> > having disappeared when it's looked up later. They pose no hurdle.
> > 
> > Swap-out records do need to pin the css to hierarchically attribute
> > swapins after the cgroup has been deleted; though the only pages that
> > remain swapped out after a process exits are tmpfs/shmem pages. Those
> > references are under the user's control and thus manageable.
> > 
> > This patch introduces a private 16bit memcg ID and switches swap and
> > cache shadow entries over to using that. It then decouples the CSS
> > lifetime from the CSS ID lifetime, such that a CSS ID can be recycled
> > when the CSS is only pinned by common objects that don't need an ID.
> 
> There's already id which is only used for online memory cgroups - it's
> kmemcg_id. May be, instead of introducing one more idr, we could name it
> generically and reuse it for shadow entries?

Good point. But it seems mem_cgroup_idr is more generic, it makes
sense to switch slab accounting over to that. I'll look into that, but
as a refactoring patch on top of this fix.

> Regarding swap entries, would it really make much difference if we used
> 4 bytes per swap page instead of 2? For a 100 GB swap it'd increase
> overhead from 50 MB up to 100 MB, which still doesn't seem too much IMO,
> so may be just use plain unrestricted css->id for swap entries?

Yes and no. I agree that the increased consumption wouldn't be too
crazy, but if we have to maintain a 16-bit ID anyway, we might as well
use it for swap too to save that space. I don't think tmpfs and shmem
pins past offlining will be common enough to significantly eat into
the ID space of online cgroups.
