From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 8/8] mm: memcg: modify PageCgroupCache non-atomically
Date: Thu, 24 Nov 2011 10:13:12 +0100
Message-ID: <20111124091312.GE6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-9-git-send-email-hannes@cmpxchg.org>
 <20111124091328.d28d9f55.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111124091328.d28d9f55.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 24, 2011 at 09:13:28AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 23 Nov 2011 16:42:31 +0100
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > This bit is protected by lock_page_cgroup(), there is no need for
> > locked operations when setting and clearing it.
> > 
> > Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Hm. non-atomic ops for pc->flags seems dangerous.
> How about try to remove PCG_CACHE ? Maybe we can depends on PageAnon(page).
> We see 'page' on memcg->lru now.
> I'm sorry I forgot why we needed PCG_CACHE flag..

The problem is that we charge/uncharged pages that are not fully
rmapped and so PageAnon() is not reliable.  I forgot if there are more
places, but the commit_charge in migration was a prominent one.

I have a patch set that reworks migration so to only commit pages that
are fully rmapped but it clashed with the THP patches and I didn't see
too much value to fix it up.  But I should probably revive it, because
it makes some things simpler.

As I replied to Hugh, it might even work for PCG_CACHE, but it's
definitely dangerous and not worth the complex dependencies it brings
on other parts of the code, so please consider 7/8 and 8/8 dropped.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
