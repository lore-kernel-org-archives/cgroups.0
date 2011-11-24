From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 5/8] mm: memcg: remove unneeded checks from
 newpage_charge()
Date: Thu, 24 Nov 2011 11:30:49 +0100
Message-ID: <20111124103049.GG26036@tiehlicka.suse.cz>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-6-git-send-email-hannes@cmpxchg.org>
 <20111124090443.d3f720c5.kamezawa.hiroyu@jp.fujitsu.com>
 <20111124090409.GC6843@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111124090409.GC6843-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 24-11-11 10:04:09, Johannes Weiner wrote:
> On Thu, Nov 24, 2011 at 09:04:43AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 23 Nov 2011 16:42:28 +0100
> > Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > 
> > > From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > > All callsites pass in freshly allocated pages and a valid mm.  As a
> > > result, all checks pertaining the page's mapcount, page->mapping or
> > > the fallback to init_mm are unneeded.
> > > 
> > > Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Hmm, it's true now. But for making clear our assumption to all readers of code,
> > 
> > could you add
> > VM_BUG_ON(!mm || page_mapped(page) || (page->mapping && !PageAnon(page)) ?
> 
> Of course.  Please find the delta patch below.  I broke them up into
> three separate checks to make the problem easier to find if the BUG
> triggers.

sounds reasonable.

> 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> Thank you.
> 
> ---
> From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Subject: mm: memcg: remove unneeded checks from newpage_charge() fix
> 
> Document page state assumptions and catch if they are violated in
> newpage_charge().
> 
> Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I assume you are going to fold it into the previous one.
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0d10be4..f338018 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2679,6 +2679,9 @@ int mem_cgroup_newpage_charge(struct page *page,
>  {
>  	if (mem_cgroup_disabled())
>  		return 0;
> +	VM_BUG_ON(page_mapped(page));
> +	VM_BUG_ON(page->mapping && !PageAnon(page));
> +	VM_BUG_ON(!mm);
>  	return mem_cgroup_charge_common(page, mm, gfp_mask,
>  					MEM_CGROUP_CHARGE_TYPE_MAPPED);
>  }
> -- 
> 1.7.6.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
