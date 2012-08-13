From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 02/11] memcg: Reclaim when more than one page needed.
Date: Mon, 13 Aug 2012 15:10:14 +0200
Message-ID: <20120813131014.GB24248@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-3-git-send-email-glommer@parallels.com>
 <20120810185417.GB16110@dhcp22.suse.cz>
 <5028B552.2070708@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5028B552.2070708-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon 13-08-12 12:05:38, Glauber Costa wrote:
> On 08/10/2012 10:54 PM, Michal Hocko wrote:
> > On Thu 09-08-12 17:01:10, Glauber Costa wrote:
> >> From: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
> >>
> >> mem_cgroup_do_charge() was written before kmem accounting, and expects
> >> three cases: being called for 1 page, being called for a stock of 32
> >> pages, or being called for a hugepage.  If we call for 2 or 3 pages (and
> >> both the stack and several slabs used in process creation are such, at
> >> least with the debug options I had), it assumed it's being called for
> >> stock and just retried without reclaiming.
> >>
> >> Fix that by passing down a minsize argument in addition to the csize.
> >>
> >> And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
> >> needed at all (and presumably is since it's there, perhaps to handle
> >> races), then it should be extended to more than PAGE_SIZE, yet how far?
> >> And should there be a retry count limit, of what?  For now retry up to
> >> COSTLY_ORDER (as page_alloc.c does) and make sure not to do it if
> >> __GFP_NORETRY.
> >>
> >> [v4: fixed nr pages calculation pointed out by Christoph Lameter ]
> >>
> >> Signed-off-by: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> >> Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > 
> > I am not happy with the min_pages argument but we can do something more
> > clever  later.
> > 
> > Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > 
> 
> I am a bit confused here. Does your ack come before or after your other
> comments on this patch?

Heh, it was hard Friday ;) Yes, it was after the mind fart...
-- 
Michal Hocko
SUSE Labs
